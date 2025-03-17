package vecmath

import "base:intrinsics"
import "core:math"

// Vector ///////////////////////////////////////////////////////////////////////////

@(require_results)
array_cast :: #force_inline proc "contextless" (
  arr: $A/[$N]$T, 
  $E:  typeid,
) -> (
  res: [N]E,
) where N <= 4 #no_bounds_check
{
	#unroll(N) for i in 0..<N
  {
		res[i] = cast(E) arr[i]
	}

	return res
}

@(require_results)
dot :: #force_inline proc "contextless" (
  a, b: [$N]$T,
) -> T where intrinsics.type_is_numeric(T)
{
  return (a.x * b.x) + (a.y * b.y)
}

cross :: proc
{
  cross_2f32,
  cross_3f32,
}

@(require_results)
cross_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  return a.x * b.y + a.y * b.x
}

@(require_results)
cross_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> [3]f32
{
  return {
    (a.y * b.z) - (a.z * b.y), 
   -(a.x * b.z) + (a.z * b.x), 
    (a.x * b.y) - (a.y * b.x),
  }
}

normal :: proc
{
  normal_2f32,
  normal_3f32,
}

@(require_results)
normal_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> [2]f32
{
  return {-(b.y - a.y), b.x - a.x}
}

@(require_results)
normal_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> [3]f32
{
  return cross(a, b)
}

projection :: proc
{
  projection_2f32,
}

@(require_results)
projection_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> [2]f32
{
  return (dot(a, b) / magnitude_squared(b)) * b
}

magnitude :: proc
{
  magnitude_2f32,
  magnitude_3f32,
}

@(require_results)
magnitude_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

@(require_results)
magnitude_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
}

magnitude_squared :: proc
{
  magnitude_squared_2f32,
  magnitude_squared_3f32,
}

@(require_results)
magnitude_squared_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2)
}

@(require_results)
magnitude_squared_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2)
}

distance :: proc
{
  distance_2f32,
  distance_3f32,
}

@(require_results)
distance_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  v := b - a
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

@(require_results)
distance_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> f32
{
  v := b - a
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
}

distance_squared :: proc
{
  distance_squared_2f32,
  distance_squared_3f32,
}

@(require_results)
distance_squared_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  c := b - a
  return math.pow(c.x, 2) + math.pow(c.y, 2)
}

@(require_results)
distance_squared_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> f32
{
  v := b - a
  return math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2)
}

midpoint :: proc
{
  midpoint_2f32,
  midpoint_3f32,
}

@(require_results)
midpoint_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> [2]f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0}
}

@(require_results)
midpoint_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> [3]f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0, (a.z + b.z) / 2.0}
}

normalize :: proc
{
  normalize_2f32,
  normalize_3f32,
}

@(require_results)
normalize_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> [2]f32
{
  return v / magnitude_2f32(v)
}

@(require_results)
normalize_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> [3]f32
{
  return v / magnitude_3f32(v)
}

@(require_results)
lerp :: #force_inline proc(
  curr, target, rate: $T,
) -> T where intrinsics.type_is_numeric(T)
{
  return curr + ((target - curr) * rate)
}

@(require_results)
lerp_angle :: #force_inline proc "contextless" (
  current, target, t: $T,
) -> T where intrinsics.type_is_float(T)
{
  result: T

  current := math.mod(current, math.TAU)
  target := math.mod(target, math.TAU)

  diff := target - current
  if diff > math.PI
  {
    diff -= math.TAU
  }
  else if diff < -math.PI
  {
    diff += math.TAU
  }
  
  result = current + diff * t

  // Ensure result stays in [0, 2π)
  result = math.mod_f32(result + math.TAU, math.TAU)
  
  return result;
}

// Matrix ///////////////////////////////////////////////////////////////////////////

m2x2f :: matrix[2,2]f32
m3x3f :: matrix[3,3]f32

@(require_results)
ident_2x2f :: #force_inline proc "contextless" (val: f32) -> m2x2f
{
  return {
    val, 0,
    0, val,
  }
}

@(require_results)
ident_3x3f :: #force_inline proc "contextless" (val: f32) -> m3x3f
{
  return {
    val, 0, 0,
    0, val, 0,
    0, 0, val,
  }
}

@(require_results)
translation_3x3f :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = ident_3x3f(1)
  result[0,2] = v.x
  result[1,2] = v.y
  return result
}

@(require_results)
scale_3x3f :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = ident_3x3f(1)
  result[0,0] = v.x
  result[1,1] = v.y
  return result
}

@(require_results)
shear_3x3f :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = ident_3x3f(1)
  result[0,1] = v.x
  result[1,0] = v.y
  return result
}

@(require_results)
rotation_2x2f :: proc "contextless" (rads: f32) -> m2x2f
{
  result: m2x2f = ident_2x2f(1)
  result[0,0] = math.cos(rads)
  result[0,1] = -math.sin(rads)
  result[1,0] = math.sin(rads)
  result[1,1] = math.cos(rads)
  return result
}

@(require_results)
rotation_3x3f :: proc "contextless" (rads: f32) -> m3x3f
{
  result: m3x3f = ident_3x3f(1)
  result[0,0] = math.cos(rads)
  result[0,1] = -math.sin(rads)
  result[1,0] = math.sin(rads)
  result[1,1] = math.cos(rads)
  return result
}

@(require_results)
orthographic_3x3f :: proc "contextless" (left, right, top, bot: f32) -> m3x3f
{
  result: m3x3f = ident_3x3f(1)
  result[0,0] = 2.0 / (right - left)
  result[1,1] = 2.0 / (top - bot)
  result[0,2] = -(right + left) / (right - left)
  result[1,2] = -(top + bot) / (top - bot)
  result[2,2] = 1.0
  return result
}
