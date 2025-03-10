package game

import "core:fmt"
import "core:math"

v2i :: [2]i32
v3i :: [3]i32
v4i :: [4]i32

v2f :: [2]f32
v3f :: [3]f32
v4f :: [4]f32

m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

printf  :: fmt.printf
println :: fmt.println

approx :: #force_inline proc "contextless" (val, tar, tol: $T) -> T
{
  return tar if abs(val) - abs(tol) <= abs(tar) else val
}
