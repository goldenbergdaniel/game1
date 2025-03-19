package metagen

import "core:fmt"
import "core:os"
import "core:strings"
import "core:image/qoi"

import "../game"
import "ext:basic/mem"

TEX_CELL :: 16
TEX_X    :: 8
TEX_Y    :: 8

Color :: [4]u8

Collider_Map_Entry :: struct
{
  vertices:     [6][2]f32,
  vertex_count: int,
  origin:       [2]f32,
  kind:         type_of(game.Collider{}.kind),
}

COLLIDER_MAP_ENTRY_STRUCT_STR :: `
Collider_Map_Entry :: struct
{
  vertices:     [6]v2f,
  vertex_count: int,
  origin:       v2f,
  kind:         type_of(Collider{}.kind),
}

`

perm_arena: mem.Arena
collider_map: [game.Sprite_ID]Collider_Map_Entry
color_map: map[Color]int

main :: proc()
{
  mem.init_static_arena(&perm_arena)
  context.allocator = mem.a(&perm_arena)

  generate_collider_map()
}

generate_collider_map :: proc()
{
  color_map.allocator = context.allocator
  color_map[Color{255, 0, 0, 255}]   = 0
  color_map[Color{255, 255, 0, 255}] = 1
  color_map[Color{0, 255, 0, 255}]   = 2
  color_map[Color{0, 255, 255, 255}] = 3
  color_map[Color{0, 0, 255, 255}]   = 4
  color_map[Color{255, 0, 255, 255}] = 5
  
  gen_buffer: strings.Builder = strings.builder_make()
  
  // - Write package, imports, and structs ---
  {
    PACKAGE_AND_IMPORTS_STR :: "// NOTE: Machine generated. Do not edit.\npackage game\n"

    strings.write_string(&gen_buffer, PACKAGE_AND_IMPORTS_STR)
    strings.write_string(&gen_buffer, COLLIDER_MAP_ENTRY_STRUCT_STR)
  }

  tex, qoi_err := qoi.load_from_file("res/textures/collider_map.qoi")
  if qoi_err != nil
  {
    fmt.eprintln("Metagen: Error opening texture file.")
    os.exit(1)
  }

  collider_map_from_bitmap(tex.pixels.buf[:])

  // - Write collider map entries ---
  {
    scratch := mem.begin_temp(mem.get_scratch())
    defer mem.end_temp(scratch)
    context.temp_allocator = mem.a(scratch.arena)
    
    strings.write_string(&gen_buffer, "collider_map: [Sprite_ID]Collider_Map_Entry = {\n")

    for entry, sprite_id in collider_map
    {
      enum_str := fmt.tprintf("  .%s = ", sprite_id)
      strings.write_string(&gen_buffer, enum_str)
      entry_str := fmt.tprintf("%w,\n", entry)
      strings.write_string(&gen_buffer, entry_str)
    }

    strings.write_string(&gen_buffer, "}\n")
  }

  file_flags := os.O_CREATE | os.O_TRUNC | os.O_RDWR
  output_file, open_err := os.open("game/game.meta.odin", file_flags, 0o644)
  if open_err != nil
  {
    fmt.eprintln("Metagen: Error creating generated Odin file.")
    os.exit(1)
  }

  os.write(output_file, gen_buffer.buf[:])
}

// TODO(dg): This will not work for sprites larger than 16x16. Fix it!
collider_map_from_bitmap :: proc(data: []byte)
{
  for i := 0; i < len(data); i += 4
  {
    pixel_idx := i / 4
    
    cell_idx := (pixel_idx / TEX_CELL) % TEX_X
    cell_idx += (pixel_idx / (TEX_CELL * TEX_CELL * TEX_Y)) * TEX_X
    sprite := cast(game.Sprite_ID) (cell_idx % int(max(game.Sprite_ID)))

    color := color_from_data(data[i:i+4])
    if color in color_map
    {
      vertex_idx := color_map[color]
      collider_map[sprite].vertices[vertex_idx] = {
        f32(pixel_idx % TEX_CELL) + 1,
        f32((pixel_idx / (TEX_CELL * TEX_Y)) % TEX_CELL) + 1,
      }
    }
  }

  for &entry in collider_map
  {
    for &vert in entry.vertices
    {
      vert -= 1
      if vert != {-1, -1}
      {
        entry.vertex_count += 1
        vert += 0.5
      }
    }

    if entry.vertex_count == 1
    {
      entry.kind = .CIRCLE
      entry.origin = entry.vertices[0]
    }
    else
    {
      entry.kind = .POLYGON
    }
  }

  color_from_data :: #force_inline proc(pixels: []byte) -> Color
  {
    return {pixels[0], pixels[1], pixels[2], pixels[3]}
  }
}
