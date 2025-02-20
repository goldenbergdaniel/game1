package game

import "core:log"
import "core:math"

import plf "src:platform"
import r "src:render"
import vm "src:vecmath"

Sprite :: struct
{
  uv:    v2i,
  dim:   v2i,
  pivot: v2f,
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
  pos:   v2f,
  dim:   v2f,
  color: v4f = {0, 0, 0, 0},
)
{
  r.push_vertex(pos + v2f{0, 0}, color)
  r.push_vertex(pos + v2f{-dim.x/2, dim.y}, color)
  r.push_vertex(pos + v2f{dim.x/2, dim.y}, color)
  r.push_tri_indices()
}

draw_rect :: proc(
  pos:    v2f,
  dim:    v2f,
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite = {},
)
{
  r.push_vertex(pos + v2f{0, 0}, color)
  r.push_vertex(pos + v2f{dim.x, 0}, color)
  r.push_vertex(pos + v2f{dim.x, dim.y}, color)
  r.push_vertex(pos + v2f{0, dim.y}, color)
  r.push_rect_indices()
}
