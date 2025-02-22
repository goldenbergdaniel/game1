package game

import "core:log"
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
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite = {}, 
)
{
  r.push_vertex(pos + v2f{0, 0}, color, v2f{})
  r.push_vertex(pos + v2f{-dim.x/2, dim.y}, color, v2f{})
  r.push_vertex(pos + v2f{dim.x/2, dim.y}, color, v2f{})
  r.push_tri_indices()
}

draw_rect :: proc(
  pos:    v2f,
  dim:    v2f,
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite = {},
)
{
  texture := &res.textures[sprite.texture_kind]
  tl, tr, br, bl := r.coords_from_texture(texture, sprite.coords)

  r.push_vertex(pos + v2f{0, 0}, color, tl)
  r.push_vertex(pos + v2f{dim.x, 0}, color, tr)
  r.push_vertex(pos + v2f{dim.x, dim.y}, color, br)
  r.push_vertex(pos + v2f{0, dim.y}, color, bl)
  r.push_rect_indices()
}
