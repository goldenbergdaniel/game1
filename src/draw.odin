package game

import "core:math"

import plf "src:platform"
import r "src:render"
import vm "src:vecmath"

Sprite :: struct
{
  coords:       v2i,
  dim:          v2i,
  pivot:        v2f,
  texture_kind: r.Texture_ID,
}

Sprite_ID :: enum
{
  NIL,
  SHIP_1,
  SHIP_2,
  PROJECTILE,
  ASTEROID,
}

begin_draw :: #force_inline proc(color: v4f)
{
  r.clear(color)
}

end_draw :: #force_inline proc()
{
  r.flush()
}

draw_tri :: proc(
  pos:    v2f,
  dim:    v2f,
  tint:   v4f = {1, 1, 1, 1},
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite_ID = .NIL, 
)
{
  texture := &res.textures[res.sprites[sprite].texture_kind]
  tl, tr, br, bl := r.coords_from_texture(texture, res.sprites[sprite].coords)

  r.push_vertex(pos + v2f{0, 0}, tint, color, tl)
  r.push_vertex(pos + v2f{-dim.x/2, dim.y}, tint, color, bl)
  r.push_vertex(pos + v2f{dim.x/2, dim.y}, tint, color, br)
  r.push_tri_indices()
}

draw_rect :: proc(
  pos:    v2f,
  dim:    v2f,
  rot:    f32 = 0,
  tint:   v4f = {1, 1, 1, 1},
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite_ID = {},
)
{
  sprite_data := res.sprites[sprite]

  xform := vm.diag_3x3(1)
  xform *= vm.translate_3x3(pos)
  xform *= vm.translate_3x3(dim * sprite_data.pivot)
  xform *= vm.rotate_3x3(rot)
  xform *= vm.translate_3x3(-dim * sprite_data.pivot)
  xform *= vm.scale_3x3(dim)

  p1 := xform * v3f{0, 0, 1}
  p2 := xform * v3f{1, 0, 1}
  p3 := xform * v3f{1, 1, 1}
  p4 := xform * v3f{0, 1, 1}

  texture := &res.textures[sprite_data.texture_kind]
  tl, tr, br, bl := r.coords_from_texture(texture, sprite_data.coords)

  r.push_vertex(p1.xy, tint, color, tl)
  r.push_vertex(p2.xy, tint, color, tr)
  r.push_vertex(p3.xy, tint, color, br)
  r.push_vertex(p4.xy, tint, color, bl)
  r.push_rect_indices()
}
