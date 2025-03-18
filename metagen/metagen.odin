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

Collider_Map_Entry :: struct
{
  vertices:     [6][2]int,
  vertex_count: int,
  origin:       [2]int,
  kind:         type_of(game.Collider{}.kind),
}

Color :: [4]u8

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
  write_package_and_imports(&gen_buffer)

  tex, qoi_err := qoi.load_from_file("res/textures/collider_map.qoi")
  if qoi_err != nil do panic("Metagen: Error opening texture file.")

  collider_map_from_bitmap(tex.pixels.buf[:])

  write_collider_map_entry_struct(&gen_buffer)
  write_collider_map_map(&gen_buffer)

  file_flags := os.O_CREATE | os.O_TRUNC | os.O_RDWR
  output_file, open_err := os.open("game/game.gen.odin", file_flags, 0o644)
  if open_err != nil do panic("Metagen: Error creating generated file.")

  os.write(output_file, transmute([]byte) strings.to_string(gen_buffer))
}

// TODO(dg): This will not work for sprites larger than 16x16. Fix it!
collider_map_from_bitmap :: proc(data: []byte)
{
  for i := 0; i < len(data); i += 4
  {
    pixel_idx := i / 4
    
    cell_idx := (pixel_idx / TEX_CELL) % (TEX_X)
    cell_idx += (pixel_idx / (TEX_CELL * TEX_CELL * TEX_Y)) * TEX_X
    sprite := cast(game.Sprite_ID) (cell_idx % int(max(game.Sprite_ID)))

    color := color_from_data(data[i:i+4])
    if color in color_map
    {
      vertex_idx := color_map[color]
      collider_map[sprite].vertices[vertex_idx] = {
        pixel_idx % TEX_CELL + 1,
        (pixel_idx / (TEX_CELL * TEX_Y)) % TEX_CELL + 1,
      }
    }
  }

  for &entry in collider_map
  {
    for &vert in entry.vertices
    {
      if vert != {0, 0}
      {
        entry.vertex_count += 1
      }

      vert -= 1
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

  color_from_data :: proc(pixels: []byte) -> Color
  {
    return {pixels[0], pixels[1], pixels[2], pixels[3]}
  }
}

write_package_and_imports :: proc(buf: ^strings.Builder)
{
  STRING :: `// NOTE(dg): Machine generated. Do not edit.
package game
`

  strings.write_string(buf, STRING)
}

write_collider_map_entry_struct :: proc(buf: ^strings.Builder)
{
  STRING :: `
Collider_Map_Entry :: struct
{
  vertices:     [6][2]int,
  vertex_count: int,
  origin:       [2]int,
  kind:         type_of(Collider{}.kind),
}

`

  strings.write_string(buf, STRING)
}

write_collider_map_map :: proc(buf: ^strings.Builder)
{
  scratch := mem.begin_temp(mem.get_scratch())
  defer mem.end_temp(scratch)
  context.temp_allocator = mem.a(scratch.arena)
  
  strings.write_string(buf, "collider_map: [Sprite_ID]Collider_Map_Entry = {\n")

  for entry, sprite_id in collider_map
  {
    enum_str := fmt.tprintf("  .%s = ", sprite_id)
    strings.write_string(buf, enum_str)
    entry_str := fmt.tprintf("%w,\n", entry)
    strings.write_string(buf, entry_str)
  }

  strings.write_string(buf, "}\n")
}
