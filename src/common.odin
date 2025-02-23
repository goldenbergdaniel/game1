package game

import "core:fmt"

v2f :: [2]f32
v3f :: [3]f32
v4f :: [4]f32

v2i :: [2]i32
v3i :: [3]i32
v4i :: [4]i32

m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

print   :: fmt.print
printf  :: fmt.printf
println :: fmt.println

to_zero :: #force_inline proc "contextless" (a: $T, tol: T) -> T
{
  return abs(a) - tol <= 0 ? 0 : a
}

dir :: #force_inline proc "contextless" (a: $T) -> T
{
  return a != 0 ? a / abs(a) : 0
}
