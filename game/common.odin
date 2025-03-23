package game

import "core:fmt"
import "core:math"

v2f32 :: [2]f32
v3f32 :: [3]f32
v4f32 :: [4]f32

m2x2f32 :: matrix[2,2]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

printf  :: fmt.printf
println :: fmt.println

approx :: #force_inline proc "contextless" (val, tar, tol: $T) -> T
{
  return tar if abs(val) - abs(tol) <= abs(tar) else val
}
