package game

import "core:math"
import "basic"
import "basic/vmath"

Circle :: struct
{
  origin: v2f32,
  radius: f32,
}

Polygon :: struct
{
  vertices: [dynamic; 8]v2f32,
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
  for i in 0..<len(a.vertices)
  {
    j := (i + 1) % len(a.vertices)
    proj_axis := vmath.normal(a.vertices[i], a.vertices[j])
    
    min_pa, max_pa := max(f32), min(f32)
    for k in 0..<len(a.vertices)
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb, max_pb := max(f32), min(f32)
    for k in 0..<len(b.vertices)
    {
      p := vmath.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    if basic.range_overlap(Range(f32){min_pa, max_pa}, Range(f32){min_pb, max_pb}) do return false
  }

  // - Collider B ---
  for i in 0..<len(b.vertices)
  {
    j := (i + 1) % len(b.vertices)
    proj_axis := vmath.normal(b.vertices[i], b.vertices[j])
    
    min_pa, max_pa := max(f32), min(f32)
    for k in 0..<len(a.vertices)
    {
      p := vmath.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb, max_pb := max(f32), min(f32)
    for k in 0..<len(b.vertices)
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
  for i in 0..<len(polygon.vertices)
  {
    j := (i + 1) % len(polygon.vertices)
    vi, vj := polygon.vertices[i], polygon.vertices[i]

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

    verticies := polygon.vertices
    if point_in_polygon(circle.origin, verticies[:len(polygon.vertices)]) do return true
  }

  return false
}

point_in_circle :: proc(point: v2f32, circle: Circle) -> bool
{
  return vmath.distance(point, circle.origin) <= circle.radius
}

point_in_bounds :: proc(point: v2f32, bounds: [2]Range(f32)) -> bool
{
  return (point.x > bounds.x.min && point.x < bounds.x.max) && 
         (point.y > bounds.y.min && point.y < bounds.y.max)
}

point_in_polygon :: proc(point: v2f32, polygon: []v2f32) -> bool
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

move_to_point :: proc(src, dst: v2f32, r: f32) -> v2f32
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
