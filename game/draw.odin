package game

import "basic/mem"
import "basic/vmath"
import "render"
import "ui"


// Sprite /////////////////////////////////////////////////////////////////////////////////////////


Sprite :: struct
{
  coord: v2f32,
  grid:  v2f32,
  pivot: v2f32,
}

draw_sprite :: proc(
  sprite: Sprite_Name,
  pos:    v2f32,
  scl:    v2f32,
  rot:    f32 = 0,
  tint:   v4f32 = {1, 1, 1, 1},
  color:  v4f32 = {0, 0, 0, 0},
){
  sprite_data := &res.sprites[sprite]
  dim := scl * sprite_data.grid

  xform := vmath.translation_3x3f(pos - dim * sprite_data.pivot)
  xform *= vmath.translation_3x3f(dim * sprite_data.pivot)
  xform *= vmath.rotation_3x3f(rot)
  xform *= vmath.translation_3x3f(-dim * sprite_data.pivot)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  tl, tr, br, bl := render.uv_from_texture(&res.textures[.Sprite_Atlas], 
                                           sprite_data.coord, 
                                           sprite_data.grid)

  render.push_vertex({p1.xy, tint, color, tl, 0})
  render.push_vertex({p2.xy, tint, color, tr, 0})
  render.push_vertex({p3.xy, tint, color, br, 0})
  render.push_vertex({p4.xy, tint, color, bl, 0})
  render.push_rectangle_indices()
}


// Text //////////////////////////////////////////////////////////////////////////////////


draw_text :: proc(
  text:        string,
  pos:         v2f32,
  size:        f32 = 1,
  line_height: f32 = 1,
  color:       v4f32 = {1, 1, 1, 0},
){
  cursor: v2f32
  for r in text
  {
    if r == '\n'
    {
      cursor.x = 0
      cursor.y += 15 * line_height * size
      continue
    }

    glyph := ui.glyph_from_rune(r)
    tl, tr, br, bl := render.uv_from_texture(&res.textures[.Glyph_Atlas], 
                                             array_cast(glyph.coord, f32), 
                                             {f32(glyph.width), f32(glyph.height)})

    offset := pos + {cursor.x + glyph.bearing.x * size, cursor.y - glyph.bearing.y * size}
    xform := vmath.translation_3x3f(offset)
    cursor += glyph.advance * size

    xform *= vmath.scale_3x3f({f32(glyph.width), f32(glyph.height)} * size)

    p1 := xform * v3f32{0, 0, 1}
    p2 := xform * v3f32{1, 0, 1}
    p3 := xform * v3f32{1, 1, 1}
    p4 := xform * v3f32{0, 1, 1}

    render.push_vertex({p1.xy, {1, 1, 1, 1}, color, tl, u32(1)})
    render.push_vertex({p2.xy, {1, 1, 1, 1}, color, tr, u32(1)})
    render.push_vertex({p3.xy, {1, 1, 1, 1}, color, br, u32(1)})
    render.push_vertex({p4.xy, {1, 1, 1, 1}, color, bl, u32(1)})
    render.push_rectangle_indices()
  }
}


// Util //////////////////////////////////////////////////////////////////////////////////


rgba_from_hsva :: proc(hsva: v4f32) -> (rgba: v4f32)
{
  h, s, v, a := hsva[0], hsva[1], hsva[2], hsva[3]

  if s == 0 do return {v, v, v, a}

  h6 := h * 6
  if h6 >= 6 do h6 = 0

  sector := cast(int) h6
  f := h6 - cast(f32) sector

  p := v * (1 - s)
  q := v * (1 - s * f)
  t := v * (1 - s * (1 - f))

  r, g, b: f32
  switch sector
  {
  case 0: r, g, b = v, t, p
  case 1: r, g, b = q, v, p
  case 2: r, g, b = p, v, t
  case 3: r, g, b = p, q, v
  case 4: r, g, b = t, p, v
  case 5: r, g, b = v, p, q
  }

  return {r, g, b, a}
}
