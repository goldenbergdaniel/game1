package game

import vmath "basic/vector_math"
import "render"

// Draw //////////////////////////////////////////////////////////////////////////////////

draw_sprite :: proc(
  pos:    v2f32,
  scl:    v2f32 = {1, 1},
  rot:    f32 = 0,
  tint:   v4f32 = {1, 1, 1, 1},
  color:  v4f32 = {0, 0, 0, 0},
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

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  // grid := vm.array_cast(sprite_res.grid, i32)
  tl, tr, br, bl := render.coords_from_texture(texture_res, sprite_res.coords, sprite_res.grid)

  render.push_vertex(p1.xy, tint, color, tl)
  render.push_vertex(p2.xy, tint, color, tr)
  render.push_vertex(p3.xy, tint, color, br)
  render.push_vertex(p4.xy, tint, color, bl)
  render.push_rect_indices()
}

rgba_from_hsva :: proc(hsva: v4f32) -> (rgba: v4f32)
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

// Sound /////////////////////////////////////////////////////////////////////////////////

play_sound :: proc()
{

}

// Collider //////////////////////////////////////////////////////////////////////////////

Collider :: struct
{
  origin:       v2f32,
  radius:       f32,
  vertices:     [8]v2f32,
  vertices_cnt: u8, 
  kind:         enum u8 {NIL, CIRCLE, POLYGON},
}

bounds_overlap :: proc(a, b: [2]f32) -> bool
{
  return a[0] <= b[1] && a[1] >= b[0]
}

circle_circle_overlap :: proc(a, b: ^Collider) -> bool
{
  return vmath.distance(a.origin, b.origin) <= a.radius + b.radius
}

polygon_polygon_overlap :: proc(a, b: ^Collider) -> bool
{
  // - Entity A ---
  for i in 0..<a.vertices_cnt
  {
    j := (i + 1) % a.vertices_cnt
    proj_axis := vmath.normal(a.vertices[i], a.vertices[j])
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
    for k in 0..<b.vertices_cnt
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    bounds_overlap({min_pa, max_pa}, {min_pb, max_pb}) or_return
  }

  // - Entity B ---
  for i in 0..<b.vertices_cnt
  {
    j := (i + 1) % b.vertices_cnt
    proj_axis := vmath.normal(b.vertices[i], b.vertices[j])
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
    for k in 0..<b.vertices_cnt
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    bounds_overlap({min_pa, max_pa}, {min_pb, max_pb}) or_return
  }

  return true
}

circle_polygon_overlap :: proc(circle, polygon: ^Collider) -> bool
{
  for i in 0..<polygon.vertices_cnt
  {
    j := (i + 1) % polygon.vertices_cnt
    vi := polygon.vertices[i]
    vj := polygon.vertices[j]

    edge := vj - vi
    proj := vmath.dot(circle.origin - vi, edge) / vmath.magnitude_squared(edge)

    edge_point: v2f32
    if proj <= 0
    {
      edge_point = vi
    }
    else if proj >= 1
    {
      edge_point = vj
    }
    else
    {
      edge_point = vi + edge * proj
    }
    
    dist_to_circle := vmath.distance(edge_point, circle.origin)
    if dist_to_circle <= circle.radius do return true

    inside := point_in_polygon(circle.origin, polygon.vertices[:polygon.vertices_cnt])
    if inside do return true
  }

  return false
}

point_in_polygon :: proc(point: v2f32, polygon: []v2f32) -> bool
{
  inside: bool

  for i in 0..<len(polygon)
  {
    j := (i + 1) % len(polygon)
    vi := polygon[i]
    vj := polygon[j]

    // Check if point is between y-coordinates of edge and to the left of the edge
    if (vi.y > point.y) != (vj.y > point.y) &&
        point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x
    {
      inside = !inside
    }
  }

  return inside
}
