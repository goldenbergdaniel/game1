package game

import "core:math"

import plf "src:platform"
import r "src:render"
import vm "src:vecmath"

Sprite :: struct
{
  coords:  v2i,
  grid:    v2i,
  pivot:   v2f,
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

begin_draw :: #force_inline proc(color: v4f)
{
  r.clear(color)
}

end_draw :: #force_inline proc()
{
  r.flush()
}

draw_rect :: proc(
  pos:    v2f,
  scl:    v2f,
  rot:    f32 = 0,
  tint:   v4f = {1, 1, 1, 1},
  color:  v4f = {0, 0, 0, 0},
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

  p1 := xform * v3f{0, 0, 1}
  p2 := xform * v3f{1, 0, 1}
  p3 := xform * v3f{1, 1, 1}
  p4 := xform * v3f{0, 1, 1}

  tl, tr, br, bl := r.coords_from_texture(texture_res, sprite_res.coords, sprite_res.grid)

  r.push_vertex(p1.xy, tint, color, tl)
  r.push_vertex(p2.xy, tint, color, tr)
  r.push_vertex(p3.xy, tint, color, br)
  r.push_vertex(p4.xy, tint, color, bl)
  r.push_rect_indices()
}
