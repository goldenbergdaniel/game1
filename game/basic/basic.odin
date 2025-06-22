package basic

import "base:intrinsics"

Range :: struct($T: typeid) where intrinsics.type_is_numeric(T)
{
  min: T, 
  max: T,
}

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
