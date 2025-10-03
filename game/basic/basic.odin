package basic

import "base:intrinsics"

PI :: 3.14159265358979323846264338327950288

Range :: struct($T: typeid) where intrinsics.type_is_numeric(T)
{
  min: T, 
  max: T,
}

@(require_results)
range_overlap :: proc(a, b: Range($T)) -> bool
{
  return a.min <= b.max && a.max >= b.min
}

@(require_results)
approx :: #force_inline proc "contextless" (val, tar, tol: $T) -> T
  where intrinsics.type_is_numeric(T)
{
  return tar if abs(val) - abs(tol) <= abs(tar) else val
}

@(require_results)
array_cast :: #force_inline proc "contextless" (arr: $A/[$N]$T, $E: typeid) -> [N]E
{
  result: [N]E

	for i in 0..<N
  {
		result[i] = cast(E) arr[i]
	}

	return result
}

@(require_results)
rad_from_deg :: #force_inline proc(deg: $T) -> T
  where intrinsics.type_is_float(T)
{
  return deg * PI / 180.0
}

@(require_results)
deg_from_rad :: #force_inline proc(rad: $T) -> T
  where intrinsics.type_is_float(T)
{
  return rad * 180.0 / PI
}
