package ui

import "core:fmt"
import "core:image"
import "core:image/netpbm"
import "core:log"
import "core:slice"
import "core:os"
import ft "ext:freetype"
import "../basic/mem"

Glyph :: struct
{
  char:    rune,
  coord:   [2]int,
  width:   int,
  height:  int,
  advance: [2]f32,
  bearing: [2]f32,
  offset:  [2]f32,
  data:    []byte,
}

Font :: struct
{
  pixels: []byte,
  width:  int,
  height: int,
}

Font_Flag :: enum
{
  Hinting,
}

@(private)
global: struct
{
  glyph_table: [256]Glyph,
  font_height: f32,
  dpi:         uint,
}

load_font :: proc
{
  load_font_from_path,
  load_font_from_bytes,
}

load_font_from_path :: proc(
  path: string, 
  size: int, 
  flags: bit_set[Font_Flag], 
  arena: ^mem.Arena,
) -> (
  font: Font, 
  err: ft.Error,
){
  data, read_err := os.read_entire_file(path, mem.allocator(arena))
  if err != nil
  {
    return {}, .Invalid_Argument
  }
  else
  {
    return load_font_from_bytes(data, size, flags, arena)
  }
}

load_font_from_bytes :: proc(
  bytes: []byte, 
  size: int, 
  flags: bit_set[Font_Flag], 
  arena: ^mem.Arena,
) -> (
  font: Font, 
  err: ft.Error,
){
  library: ft.Library
  ft.init_freetype(&library) or_return
  defer ft.done_freetype(library)

  face: ft.Face
  ft.new_memory_face(library, raw_data(bytes), i64(len(bytes)), 0, &face) or_return
  defer ft.done_face(face)

  dpi := global.dpi != 0 ? cast(u32) global.dpi : 96
  ft.set_char_size(face, 0, cast(ft.F26Dot6) (size * 64), dpi, dpi) or_return

  global.font_height += cast(f32) (face.size.metrics.ascender >> 6)
  global.font_height -= cast(f32) (face.size.metrics.descender >> 6)
  // fmt.println(global.font_height)

  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  glyphs: [dynamic]Glyph
  glyphs.allocator = mem.allocator(scratch.arena)

  // - Load glyphs from face ---
  for c in 0..<max(byte)
  {
    char_idx := ft.get_char_index(face, u64(c))
    if char_idx != 0
    {
      load_flags := ft.Load_Flags{.Render}
      if .Hinting not_in flags do load_flags += {.No_Hinting, .No_Autohint}

      ft.load_glyph(face, char_idx, load_flags) or_return

      glyph := Glyph{
        char = rune(c),
        width = int(face.glyph.bitmap.width),
        height = int(face.glyph.bitmap.rows),
        advance = {f32(face.glyph.advance.x >> 6), f32(face.glyph.advance.y >> 6)},
        bearing = {f32(face.glyph.bitmap_left), f32(face.glyph.bitmap_top)},
      }

      size := glyph.width * glyph.height
      glyph.data = slice.clone(face.glyph.bitmap.buffer[:size], mem.allocator(scratch.arena))

      append(&glyphs, glyph)
    }
  }

  // - Fill glyph table ---
  for i := 0; i < len(glyphs) && i < len(global.glyph_table); i += 1
  {
    global.glyph_table[glyphs[i].char] = glyphs[i]
  }

  // - Pack glyph bitmaps in atlas --
  {
    MAX_ATLAS_WIDTH :: 512

    atlas_width, atlas_height: int
    max_glyph_height: int
    num_rows: int = 1

    for glyph in glyphs
    {
      if atlas_width + glyph.width + 1 > MAX_ATLAS_WIDTH
      {
        atlas_width = 0
        num_rows += 1
      }
      
      atlas_width += glyph.width + 1
      max_glyph_height = max(glyph.height, max_glyph_height)
    }

    atlas_width = MAX_ATLAS_WIDTH
    atlas_height = max_glyph_height * num_rows

    atlas_bmp := make([]byte, atlas_width * atlas_height, mem.allocator(arena))
    atlas_pos: [enum{Abs, Rel}][2]int
    
    for glyph in global.glyph_table[:] do if glyph.data != nil
    {
      glyph_pos: int

      if atlas_pos[.Abs].x + glyph.width + 1 > MAX_ATLAS_WIDTH
      {
        atlas_pos[.Abs].x = 0
        atlas_pos[.Abs].y += max_glyph_height
      }

      global.glyph_table[glyph.char].coord = atlas_pos[.Abs]

      for r in 0..<glyph.height
      {
        for c in 0..<glyph.width
        {
          pos := atlas_pos[.Abs] + atlas_pos[.Rel]
          atlas_bmp[pos.x + pos.y * MAX_ATLAS_WIDTH] = glyph.data[glyph_pos]

          glyph_pos += 1
          atlas_pos[.Rel].x += 1
        }

        atlas_pos[.Rel].x = 0
        atlas_pos[.Rel].y += 1
      }
      
      atlas_pos[.Rel].y = 0
      atlas_pos[.Abs].x += glyph.width + 1
    }

    atlas, _ := image.pixels_to_image(transmute([][1]byte) atlas_bmp, atlas_width, atlas_height)
    err := netpbm.save_to_file("res/gen/font_atlas.pbm", &atlas)
    if err != nil
    {
      log.errorf("[ui]: Failed to save atlas to file. (%s)\n", err)
    }

    font = Font{
      pixels = atlas_bmp,
      width = atlas_width,
      height = atlas_height,
    }
  }

  return font, .Ok
}

@(require_results)
glyph_from_rune :: proc(r: rune) -> ^Glyph
{
  if r > 0 && r < len(global.glyph_table)
  {
    return &global.glyph_table[r]
  }
  
  return &global.glyph_table[0]
}

@(require_results)
max_height_from_text :: proc(text: string) -> f32
{
  max_ascent, max_descent: f32

  for r in text
  {
    glyph := glyph_from_rune(r)
    
    ascent := glyph.bearing.y
    descent := f32(glyph.height) - glyph.bearing.y

    max_ascent = ascent if ascent > max_ascent else max_ascent
    max_descent = descent if descent > max_descent else max_descent
  }

  return max_ascent + max_descent
}

set_dpi :: proc(dpi: uint)
{
  global.dpi = dpi
}
