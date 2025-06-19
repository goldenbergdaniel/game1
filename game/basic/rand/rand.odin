package rand0

import "core:math/rand"

import ".."

Range :: basic.Range

set_seed :: rand.reset
num_i31  :: rand.int31
num_i63  :: rand.int63

boolean :: proc() -> bool
{
  return cast(bool) rand.int31_max(2)
}

range_i31 :: proc(range: Range(i32)) -> i32
{
  return rand.int31_max(range.max - range.min) + range.min
}

range_i63 :: proc(range: Range(i64)) -> i64
{
  return rand.int63_max(range.max - range.min) + range.min
}

range_2i31 :: proc(range: [2]Range(i32)) -> [2]i32
{
  return {
    rand.int31_max(range.x.max - range.x.min) + range.x.min,
    rand.int31_max(range.y.max - range.y.min) + range.y.min,
  }
}

range_2i63 :: proc(range: [2]Range(i64)) -> [2]i64
{
  return {
    rand.int63_max(range.x.max - range.x.min) + range.x.min,
    rand.int63_max(range.y.max - range.y.min) + range.y.min,
  }
}

range_f32 :: proc(range: Range(f32)) -> f32
{
  return rand.float32_range(range.min, range.max)
}

range_2f32 :: proc(range: [2]Range(f32)) -> [2]f32
{
  return {
    rand.float32_range(range.x.min, range.x.max),
    rand.float32_range(range.y.min, range.y.max),
  }
}

choice_bit_set :: rand.choice_bit_set
choice_enum    :: rand.choice_enum
choice_slice   :: rand.choice
