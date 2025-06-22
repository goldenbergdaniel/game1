package game

import "core:math"

import vmath "basic/vector_math"
import "render"

// Physics //////////////////////////////////////////////////////////////////////////////

Collider :: union
{
  Circle,
  Polygon,
}

Circle :: struct
{
  origin: f32x2,
  radius: f32,
}

Polygon :: struct
{
  vertices: [8]f32x2,
  number:   u32,
}

circle_circle_overlap :: proc(a, b: Circle) -> bool
{
  return vmath.distance(a.origin, b.origin) <= a.radius + b.radius
}

polygon_polygon_overlap :: proc(a, b: Polygon) -> bool
{
  // - Collider A ---
  for i in 0..<a.number
  {
    j := (i + 1) % a.number
    proj_axis := vmath.normal(a.vertices[i], a.vertices[j])
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.number
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
    for k in 0..<b.number
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    range_overlap(Range(f32){min_pa, max_pa}, Range(f32){min_pb, max_pb}) or_return
  }

  // - Collider B ---
  for i in 0..<b.number
  {
    j := (i + 1) % b.number
    proj_axis := vmath.normal(b.vertices[i], b.vertices[j])
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.number
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
    for k in 0..<b.number
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    range_overlap(Range(f32){min_pa, max_pa}, Range(f32){min_pb, max_pb}) or_return
  }

  return true
}

circle_polygon_overlap :: proc(circle: Circle, polygon: Polygon) -> bool
{
  for i in 0..<polygon.number
  {
    j := (i + 1) % polygon.number
    vi := polygon.vertices[i]
    vj := polygon.vertices[j]

    edge := vj - vi
    proj := vmath.dot(circle.origin - vi, edge) / vmath.magnitude_squared(edge)

    edge_point: f32x2
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

    verticies := polygon.vertices
    inside := point_in_polygon(circle.origin, verticies[:polygon.number])
    if inside do return true
  }

  return false
}

point_in_circle :: proc(point: f32x2, circle: Circle) -> bool
{
  return vmath.distance(point, circle.origin) <= circle.radius
}

point_in_bounds :: proc(point: f32x2, bounds: [2]Range(f32)) -> bool
{
  return (point.x > bounds.x.min && point.x < bounds.x.max) && 
         (point.y > bounds.y.min && point.y < bounds.y.max)
}

point_in_polygon :: proc(point: f32x2, polygon: []f32x2) -> bool
{
  inside: bool

  for i in 0..<len(polygon)
  {
    j := (i + 1) % len(polygon)
    vi := polygon[i]
    vj := polygon[j]

    // Check if point is between y-coords of edge and to the left of the edge
    if (vi.y > point.y) != (vj.y > point.y) &&
        point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x
    {
      inside = !inside
    }
  }

  return inside
}

move_to_point :: proc(src, dst: f32x2, r: f32) -> f32x2
{
  dx := dst.x - src.x
  dy := dst.y - src.y
  dist := math.sqrt(dx*dx + dy*dy)

  if dist == 0 do return src

  if r > dist do return dst

  factor := r / dist
  return {src.x + (dx * factor), src.y + (dy * factor)} 
}

// Draw //////////////////////////////////////////////////////////////////////////////////

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

// Sound /////////////////////////////////////////////////////////////////////////////////

play_sound :: proc()
{

}
