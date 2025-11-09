package game

import "core:math"
import "basic"
import "basic/vmath"

Circle :: struct
{
  origin: f32x2,
  radius: f32,
}

Polygon :: struct
{
  vertices: [8]f32x2,
  number:   u8,
}

Collider :: union
{
  Circle,
  Polygon,
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
    
    min_pa, max_pa := max(f32), min(f32)
    for k in 0..<a.number
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb, max_pb := max(f32), min(f32)
    for k in 0..<b.number
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    if basic.range_overlap(Range(f32){min_pa, max_pa}, Range(f32){min_pb, max_pb}) do return false
  }

  // - Collider B ---
  for i in 0..<b.number
  {
    j := (i + 1) % b.number
    proj_axis := vmath.normal(b.vertices[i], b.vertices[j])
    
    min_pa, max_pa := max(f32), min(f32)
    for k in 0..<a.number
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb, max_pb := max(f32), min(f32)
    for k in 0..<b.number
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    if basic.range_overlap(Range(f32){min_pa, max_pa}, Range(f32){min_pb, max_pb}) do return false
  }

  return true
}

circle_polygon_overlap :: proc(circle: Circle, polygon: Polygon) -> bool
{
  for i in 0..<polygon.number
  {
    j := (i + 1) % polygon.number
    vi, vj := polygon.vertices[i], polygon.vertices[i]

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
    if point_in_polygon(circle.origin, verticies[:polygon.number]) do return true
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
  n := len(polygon)

  for i in 0..<n
  {
    j := (i + 1) % n
    vi, vj := polygon[i], polygon[j]

    // Check if point is between y-coords of edge and to the left of the edge
    if (vi.y > point.y) != (vj.y > point.y) &&
        point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x
    {
      inside = !inside
    }
  }

  return inside
}

collider_overlap :: proc(a, b: Collider) -> bool
{
  switch va in a
  {
  case Circle:
    switch vb in b
    {
    case Circle:  return circle_circle_overlap(va, vb)
    case Polygon: return circle_polygon_overlap(va, vb)
    }
  case Polygon:
    switch vb in b
    {
    case Circle:  return circle_polygon_overlap(vb, va)
    case Polygon: return polygon_polygon_overlap(va, vb)
    }
  }

  return false
}

move_to_point :: proc(src, dst: f32x2, r: f32) -> f32x2
{
  dx := dst.x - src.x
  dy := dst.y - src.y

  dist := math.sqrt(dx*dx + dy*dy)

  if dist == 0 do return src

  if r > dist do return dst

  return {
    src.x + (dx * (r / dist)), 
    src.y + (dy * (r / dist)),
  } 
}
