package vecmath

import "base:intrinsics"
import "core:math"
import "core:math/linalg"

// Vector ///////////////////////////////////////////////////////////////////////////

@(require_results)
array_cast :: proc "contextless" (
  v: $A/[$N]$T, 
  $Elem_Type: typeid
) -> (
  w: [N]Elem_Type,
) #no_bounds_check
{
	for i in 0..<N
  {
		w[i] = Elem_Type(v[i])
	}

	return
}

dot :: proc
{
  dot_2f32,
  dot_3f32,
  dot_4f32,
}

dot_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  return (a.x * a.y) + (b.x * b.y)
}

dot_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> f32
{
  return (a.x * a.y) + (b.x * b.y) + (b.z * b.z)
}

dot_4f32 :: #force_inline proc "contextless" (a, b: [4]f32) -> f32
{
  return (a.x * a.y) + (b.x * b.y) + (b.z * b.z) + (b.w * b.w)
}

cross :: proc
{
  cross_2f32,
  cross_3f32,
}

cross_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  return a.x * b.y + a.y * b.x
}

cross_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> [3]f32
{
  return {
    (a.y * b.z) - (a.z * b.y), 
    -(a.x * b.z) + (a.z * b.x), 
    (a.x * b.y) - (a.y * b.x),
  }
}

magnitude :: proc
{
  magnitude_2f32,
  magnitude_3f32,
}

magnitude_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

magnitude_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
}

magnitude_squared :: proc
{
  magnitude_squared_2f32,
  magnitude_squared_3f32,
}

magnitude_squared_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2)
}

magnitude_squared_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2)
}

distance :: proc
{
  distance_2f32,
  distance_3f32,
}

distance_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  v := b - a
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

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

distance_squared_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> f32
{
  c := b - a
  return math.pow(c.x, 2) + math.pow(c.y, 2)
}

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

midpoint_2f32 :: #force_inline proc "contextless" (a, b: [2]f32) -> [2]f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0}
}

midpoint_3f32 :: #force_inline proc "contextless" (a, b: [3]f32) -> [3]f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0, (a.z + b.z) / 2.0}
}

normalize :: proc
{
  normalize_2f32,
  normalize_3f32,
}

normalize_2f32 :: #force_inline proc "contextless" (v: [2]f32) -> [2]f32
{
  return v / magnitude_2f32(v)
}

normalize_3f32 :: #force_inline proc "contextless" (v: [3]f32) -> [3]f32
{
  return v / magnitude_3f32(v)
}

lerp :: proc
{
  lerp_2f32,
  lerp_3f32,
  lerp_4f32,
}

lerp_2f32 :: #force_inline proc "contextless" (curr, target: [2]f32, rate: f32) -> [2]f32
{
  return curr + ((target - curr) * rate)
}

lerp_3f32 :: #force_inline proc "contextless" (curr, target: [3]f32, rate: f32) -> [3]f32
{
  return curr + ((target - curr) * rate)
}

lerp_4f32 :: #force_inline proc "contextless" (curr, target: [4]f32, rate: f32) -> [4]f32
{
  return curr + ((target - curr) * rate)
}

// Matrix ///////////////////////////////////////////////////////////////////////////

m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

diag_3x3 :: #force_inline proc "contextless" (val: f32) -> m3x3f
{
  return {
    val, 0, 0,
    0, val, 0,
    0, 0, val,
  }
}

diag_4x4 :: #force_inline proc "contextless" (val: f32) -> m4x4f
{
  return {
    val, 0, 0, 0,
    0, val, 0, 0,
    0, 0, val, 0,
    0, 0, 0, val,
  }
}

transpose_3x3 :: proc "contextless" (m: m3x3f) -> m3x3f
{
  return intrinsics.transpose(m)
}

translate_3x3 :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = diag_3x3(1)
  result[0, 2] = v.x
  result[1, 2] = v.y
  return result
}

scale_3x3 :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = diag_3x3(1)
  result[0, 0] = v.x
  result[1, 1] = v.y
  return result
}

shear_3x3 :: proc "contextless" (v: [2]f32) -> m3x3f
{
  result: m3x3f = diag_3x3(1)
  result[0, 1] = v.x
  result[1, 0] = v.y
  return result
}

rotate_3x3 :: proc "contextless" (rads: f32) -> m3x3f
{
  result: m3x3f = diag_3x3(1)
  result[0, 0] = math.cos(rads)
  result[0, 1] = -math.sin(rads)
  result[1, 0] = math.sin(rads)
  result[1, 1] = math.cos(rads)
  return result
}

orthographic_3x3 :: proc "contextless" (left, right, top, bot: f32) -> m3x3f
{
  result: m3x3f = diag_3x3(1)
  result[0, 0] = 2.0 / (right - left)
  result[1, 1] = 2.0 / (top - bot)
  result[0, 2] = -(right + left) / (right - left)
  result[1, 2] = -(top + bot) / (top - bot)
  result[2, 2] = 1.0
  return result
}
