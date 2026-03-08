#+feature using-stmt
package vmath

import "base:intrinsics"
import "base:builtin"
import "core:math"
import "core:math/linalg"

DEPTH :: "vulkan"


// Vector ///////////////////////////////////////////////////////////////////////////


v2f32 :: [2]f32
v3f32 :: [3]f32
v4f32 :: [4]f32

concat :: proc
{
  concat_1f32_2f32,
  concat_1f32_3f32,
  concat_2f32_1f32,
  concat_2f32_2f32,
  concat_3f32_1f32,
  concat_1f32_2f32_1f32,
}

@(require_results)
concat_1f32_2f32 :: #force_inline proc(a: f32, b: v2f32) -> v3f32
{
  return {a, b[0], b[1]}
}

@(require_results)
concat_2f32_1f32 :: #force_inline proc(a: v2f32, b: f32) -> v3f32
{
  return {a[0], a[1], b}
}

@(require_results)
concat_1f32_3f32 :: #force_inline proc(a: f32, b: v3f32) -> v4f32
{
  return {a, b[0], b[1], b[2]}
}

@(require_results)
concat_2f32_2f32 :: #force_inline proc(a: v2f32, b: v2f32) -> v4f32
{
  return {a[0], a[1], b[0], b[1]}
}

@(require_results)
concat_3f32_1f32 :: #force_inline proc(a: v3f32, b: f32) -> v4f32
{
  return {a[0], a[1], a[2], b}
}

@(require_results)
concat_1f32_2f32_1f32 :: #force_inline proc(a: f32, b: v2f32, c: f32) -> v4f32
{
  return {a, b[0], b[1], c}
}

dot :: proc
{
  dot_2f,
  dot_3f,
}

@(require_results)
dot_2f :: #force_inline proc(a, b: [2]$T) -> T where intrinsics.type_is_numeric(T)
{
  return (a.x * b.x) + (a.y * b.y)
}

@(require_results)
dot_3f :: #force_inline proc(a, b: [3]$T) -> T where intrinsics.type_is_numeric(T)
{
  return (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
}

cross :: proc
{
  cross_2f,
  cross_3f,
}

@(require_results)
cross_2f :: #force_inline proc(a, b: v2f32) -> f32
{
  return a.x * b.y + a.y * b.x
}

@(require_results)
cross_3f :: #force_inline proc(a, b: v3f32) -> v3f32
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
normal_2f32 :: #force_inline proc(a, b: v2f32) -> v2f32
{
  return {-(b.y - a.y), b.x - a.x}
}

@(require_results)
normal_3f32 :: #force_inline proc(a, b: v3f32) -> v3f32
{
  return cross(a, b)
}

projection :: proc
{
  projection_2f32,
}

@(require_results)
projection_2f32 :: #force_inline proc(a, b: v2f32) -> v2f32
{
  return (dot(a, b) / magnitude_squared(b)) * b
}

abs :: proc
{
  abs_2f32,
  abs_3f32,
}

@(require_results)
abs_2f32 :: proc(v: v2f32) -> v2f32
{
  return {builtin.abs(v.x), builtin.abs(v.y)}
}

@(require_results)
abs_3f32 :: proc(v: v3f32) -> v3f32
{
  return {builtin.abs(v.x), builtin.abs(v.y), builtin.abs(v.z)}
}

length :: proc
{
  length_2f32,
  length_3f32,
}

@(require_results)
length_2f32 :: #force_inline proc(v: v2f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

@(require_results)
length_3f32 :: #force_inline proc(v: v3f32) -> f32
{
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
}

magnitude_squared :: proc
{
  magnitude_squared_2f32,
  magnitude_squared_3f32,
}

@(require_results)
magnitude_squared_2f32 :: #force_inline proc(v: v2f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2)
}

@(require_results)
magnitude_squared_3f32 :: #force_inline proc(v: v3f32) -> f32
{
  return math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2)
}

distance :: proc
{
  distance_2f32,
  distance_3f32,
}

@(require_results)
distance_2f32 :: #force_inline proc(a, b: v2f32) -> f32
{
  v := b - a
  return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

@(require_results)
distance_3f32 :: #force_inline proc(a, b: v3f32) -> f32
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
distance_squared_2f32 :: #force_inline proc(a, b: v2f32) -> f32
{
  c := b - a
  return math.pow(c.x, 2) + math.pow(c.y, 2)
}

@(require_results)
distance_squared_3f32 :: #force_inline proc(a, b: v3f32) -> f32
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
midpoint_2f32 :: #force_inline proc(a, b: v2f32) -> v2f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0}
}

@(require_results)
midpoint_3f32 :: #force_inline proc(a, b: v3f32) -> v3f32
{
  return {(a.x + b.x) / 2.0, (a.y + b.y) / 2.0, (a.z + b.z) / 2.0}
}

normalize :: proc
{
  normalize_2f32,
  normalize_3f32,
}

@(require_results)
normalize_2f32 :: #force_inline proc(v: v2f32) -> v2f32
{
  mag := length_2f32(v)
  return 0 if mag == 0 else v / mag
}

@(require_results)
normalize_3f32 :: #force_inline proc(v: v3f32) -> v3f32
{
  mag := length_3f32(v)
  return 0 if mag == 0 else v / mag
}

@(require_results)
lerp :: #force_inline proc(
  curr, target, rate: $T,
) -> T where intrinsics.type_is_numeric(T)
{
  return curr + ((target - curr) * rate)
}

@(require_results)
lerp_angle :: #force_inline proc(
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

vectorize :: proc(mat: ^[$R][$C]$T, math_proc: proc(T) -> T)
{
  for &dim in mat
  {
    for &elem in dim
    {
      elem = math_proc(elem)
    }
  }
}


// Matrix ///////////////////////////////////////////////////////////////////////////


m2x2f32 :: matrix[2,2]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

IDENTITY_2X2F :: m2x2f32{
  1, 0,
  0, 1,
}

IDENTITY_3X3F :: m3x3f32{
  1, 0, 0,
  0, 1, 0,
  0, 0, 1,
}

IDENTITY_4X4F :: m4x4f32{
  1, 0, 0, 0,
  0, 1, 0, 0,
  0, 0, 1, 0,
  0, 0, 0, 1,
}

translation :: proc
{
  translation_3x3f,
  translation_4x4f,
}

@(require_results)
translation_3x3f :: proc(v: v2f32) -> m3x3f32
{
  return {
    1, 0, v.x,
    0, 1, v.y,
    0, 0, 1,
  }
}

@(require_results)
translation_4x4f :: proc(v: v3f32) -> m4x4f32
{
  return {
    1, 0, 0, v.x,
    0, 1, 0, v.y,
    0, 0, 1, v.z,
    0, 0, 0, 1,
  }
}

scale :: proc
{
  scale_3x3f,
  scale_4x4f,
}

@(require_results)
scale_2x2f :: proc(v: v2f32) -> m3x3f32
{
  result: m3x3f32
  result[0,0] = v.x
  result[1,1] = v.y
  return result
}

@(require_results)
scale_3x3f :: proc(v: v2f32) -> m3x3f32
{
  result: m3x3f32
  result[0,0] = v.x
  result[1,1] = v.y
  result[2,2] = 1
  return result
}

@(require_results)
scale_4x4f :: proc(v: v3f32) -> m4x4f32
{
  result: m4x4f32
  result[0,0] = v.x
  result[1,1] = v.y
  result[2,2] = v.z
  result[3,3] = 1
  return result
}

@(require_results)
shear_2x2f :: proc(v: v2f32) -> m2x2f32
{
  result: m2x2f32 = IDENTITY_2X2F
  result[0,1] = v.x
  result[1,0] = v.y
  return result
}

@(require_results)
shear_3x3f :: proc(v: v2f32) -> m3x3f32
{
  result: m3x3f32 = IDENTITY_3X3F
  result[0,1] = v.x
  result[1,0] = v.y
  return result
}

@(require_results)
rotation_2x2f :: proc(rads: f32) -> m2x2f32
{
  result: m2x2f32
  result[0,0] = math.cos(rads)
  result[0,1] = -math.sin(rads)
  result[1,0] = math.sin(rads)
  result[1,1] = math.cos(rads)
  return result
}

rotation :: proc
{
  rotation_3x3f,
  rotation_4x4f,
}

@(require_results)
rotation_3x3f :: proc(rads: f32) -> m3x3f32
{
  result: m3x3f32
  result[0,0] = math.cos(rads)
  result[0,1] = -math.sin(rads)
  result[1,0] = math.sin(rads)
  result[1,1] = math.cos(rads)
  result[2,2] = 1.0
  return result
}

// NOTE: Taken from core:linalg
@(require_results)
rotation_4x4f :: proc(rads: f32, v: v3f32) -> (m: m4x4f32)
{
	c := math.cos(rads)
	s := math.sin(rads)

	u := normalize(v)
	t := u * (1-c)

	m = IDENTITY_4X4F

	m[0][0] = c + t[0]*u[0]
	m[0][1] = 0 + t[0]*u[1] + s*u[2]
	m[0][2] = 0 + t[0]*u[2] - s*u[1]
	m[0][3] = 0

	m[1][0] = 0 + t[1]*u[0] - s*u[2]
	m[1][1] = c + t[1]*u[1]
	m[1][2] = 0 + t[1]*u[2] + s*u[0]
	m[1][3] = 0

	m[2][0] = 0 + t[2]*u[0] + s*u[1]
	m[2][1] = 0 + t[2]*u[1] - s*u[0]
	m[2][2] = c + t[2]*u[2]
	m[2][3] = 0

  return
}

@(require_results)
rotation_x_4x4f :: proc(rads: f32) -> m4x4f32
{
  using math

  return {
    1, 0, 0, 0,
    0, cos(rads), -sin(rads), 0,
    0, sin(rads), cos(rads), 0,
    0, 0, 0, 1,
  }
}

@(require_results)
rotation_y_4x4f :: proc(rads: f32) -> m4x4f32
{
  using math

  return {
    cos(rads), 0, sin(rads), 0,
    0, 1, 0, 0,
    -sin(rads), 0, cos(rads), 0,
    0, 0, 0, 1,
  }
}

@(require_results)
rotation_z_4x4f :: proc(rads: f32) -> m4x4f32
{
  using math

  return {
    cos(rads), -sin(rads), 0, 0,
    sin(rads), cos(rads), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  }
}

@(require_results)
transform_3x3f :: proc(pos: v2f32, rot: f32, scl: v2f32) -> m3x3f32
{
  result := translation_3x3f(pos)
  result *= rotation_3x3f(rot)
  result *= scale_3x3f(scl)
  return result
}

@(require_results)
orthographic :: proc(left, right, top, bot: f32) -> m3x3f32
{
  result: m3x3f32
  result[0,0] = 2.0 / (right - left)
  result[1,1] = 2.0 / (top - bot)
  result[0,2] = -(right + left) / (right - left)
  result[1,2] = -(top + bot) / (top - bot)
  result[2,2] = 1.0
  return result
}

@(require_results)
perspective :: proc(fov, aspect, near, far: f32) -> m4x4f32
{
  tan_half_fov := math.tan(0.5 * fov)

  result: m4x4f32
	result[0,0] = +1 / (aspect * tan_half_fov)
	result[1,1] = +1 / tan_half_fov
	result[2,2] = +(far + near) / (far - near)
	result[2,3] = -2*far*near / (far - near)
	result[3,2] = +1
  
  result[1] = -result[1]
  result[2] = -result[2]

	return result
}

lookat :: proc
{
  lookat_target,
  lookat_fru,
}

@(require_results)
lookat_target :: proc(eye, target, up: v3f32) -> m4x4f32
{
  assert(length(target - eye) != 0.0)

	f := normalize(target - eye)
	s := normalize(cross(f, up))
	u := cross(s, f)

	return {
		+s.x, +s.y, +s.z, -dot(s, eye),
		+u.x, +u.y, +u.z, -dot(u, eye),
		-f.x, -f.y, -f.z, -dot(f, eye),
		   0,    0,    0,            1,
	}
}

@(require_results)
lookat_fru :: proc(eye, f, r, u: v3f32) -> m4x4f32
{
  u := -u

	return {
		+r.x, +r.y, +r.z, -dot(r, eye),
		-u.x, -u.y, -u.z, +dot(u, eye),
		-f.x, -f.y, -f.z, +dot(f, eye),
		   0,    0,    0,            1,
	}
}
