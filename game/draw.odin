package game

import "core:math"

import plf "platform"
import r "render"
import vm "vecmath"

SPRITE_SCALE :: 1.5

Sprite :: struct
{
  coords:  [2]i32,
  grid:    [2]i32,
  pivot:   v2f32,
  texture: r.Texture_ID,
}

Sprite_ID :: enum
{
  SQUARE,
  CIRCLE,
  SHIP,
  ALIEN,
  FOOTBALL,
  ASTEROID,
  PROJECTILE,
  LASER,
  ASTEROID_BIG,
}

begin_draw :: #force_inline proc(color: v4f32)
{
  r.clear(color)
}

end_draw :: #force_inline proc()
{
  r.flush()
}

draw_sprite :: proc(
  pos:    v2f32,
  scl:    v2f32,
  rot:    f32 = 0,
  tint:   v4f32 = {1, 1, 1, 1},
  color:  v4f32 = {0, 0, 0, 0},
  sprite: Sprite_ID = .SQUARE,
)
{
  sprite_res := &res.sprites[sprite]
  texture_res := &res.textures[sprite_res.texture]
  dim := scl * vm.array_cast(sprite_res.grid * 16, f32)

  xform := vm.translation_3x3f(pos - dim * sprite_res.pivot)
  xform *= vm.translation_3x3f(dim * sprite_res.pivot)
  xform *= vm.rotation_3x3f(rot)
  xform *= vm.translation_3x3f(-dim * sprite_res.pivot)
  xform *= vm.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  tl, tr, br, bl := r.coords_from_texture(texture_res, sprite_res.coords, sprite_res.grid)

  r.push_vertex(p1.xy, tint, color, tl)
  r.push_vertex(p2.xy, tint, color, tr)
  r.push_vertex(p3.xy, tint, color, br)
  r.push_vertex(p4.xy, tint, color, bl)
  r.push_rect_indices()
}

rgba_from_hsva :: proc(hsva: v4f32) -> (rgba: v4f32)
{
  h, s, v, a := hsva[0], hsva[1], hsva[2], hsva[3]

  if s == 0.0 do return v4f32{v, v, v, a}

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

  return v4f32{r, g, b, a}
}
