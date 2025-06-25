package game

import vmath "basic/vector_math"
import "render"

Sprite :: struct
{
  coords:  [2]f32,
  grid:    [2]f32,
  pivot:   f32x2,
  texture: render.Texture_ID,
}

draw_sprite :: proc(
  pos:    f32x2,
  scl:    f32x2 = {1, 1},
  rot:    f32 = 0,
  tint:   f32x4 = {1, 1, 1, 1},
  color:  f32x4 = {0, 0, 0, 0},
  sprite: Sprite_Name = .NIL,
){
  sprite_res := &res.sprites[sprite]
  texture_res := &res.textures[sprite_res.texture]
  dim := scl * sprite_res.grid * 16

  xform := vmath.translation_3x3f(pos - dim * sprite_res.pivot)
  xform *= vmath.translation_3x3f(dim * sprite_res.pivot)
  xform *= vmath.rotation_3x3f(rot)
  xform *= vmath.translation_3x3f(-dim * sprite_res.pivot)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * f32x3{0, 0, 1}
  p2 := xform * f32x3{1, 0, 1}
  p3 := xform * f32x3{1, 1, 1}
  p4 := xform * f32x3{0, 1, 1}

  // grid := vm.array_cast(sprite_res.grid, i32)
  tl, tr, br, bl := render.coords_from_texture(texture_res, sprite_res.coords, sprite_res.grid)

  render.push_vertex(p1.xy, tint, color, tl)
  render.push_vertex(p2.xy, tint, color, tr)
  render.push_vertex(p3.xy, tint, color, br)
  render.push_vertex(p4.xy, tint, color, bl)
  render.push_rect_indices()
}

rgba_from_hsva :: proc(hsva: f32x4) -> (rgba: f32x4)
{
  h, s, v, a := hsva[0], hsva[1], hsva[2], hsva[3]

  if s == 0.0 do return {v, v, v, a}

  h6 := h * 6.0
  if h6 >= 6.0 do h6 = 0.0

  sector := cast(int) h6
  f := h6 - cast(f32) sector

  p := v * (1.0 - s)
  q := v * (1.0 - s * f)
  t := v * (1.0 - s * (1.0 - f))

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
