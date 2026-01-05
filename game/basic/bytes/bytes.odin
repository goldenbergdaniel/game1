package bytes0

import "core:encoding/endian"

Buffer :: struct
{
  data:   []byte,
  r_pos:  int,
  w_pos:  int,
  endian: Endian,
}

Endian :: enum
{
  BE, 
  LE,
}

make_buffer :: proc(data: []byte, kind: Endian) -> Buffer
{
  return {data, 0, 0, kind}
}

read_byte :: #force_inline proc(buffer: ^Buffer) -> byte
{
  return read_u8(buffer)
}

read_i8 :: proc(buffer: ^Buffer) -> i8
{
  result := cast(i8) buffer.data[buffer.r_pos]
  buffer.r_pos += 1
  return result
}

read_u8 :: proc(buffer: ^Buffer) -> u8
{
  result := buffer.data[buffer.r_pos]
  buffer.r_pos += 1
  return result
}

read_i16 :: proc(buffer: ^Buffer) -> i16
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+2]
  buffer.r_pos += 2

  if buffer.endian == .BE do return cast(i16) endian.unchecked_get_u16be(data)
  else                    do return cast(i16) endian.unchecked_get_u16le(data)
}

read_u16 :: proc(buffer: ^Buffer) -> u16
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+2]
  buffer.r_pos += 2
  
  if buffer.endian == .BE do return endian.unchecked_get_u16be(data)
  else                    do return endian.unchecked_get_u16le(data)
}

read_i32 :: proc(buffer: ^Buffer) -> i32
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+4]
  buffer.r_pos += 4
  
  if buffer.endian == .BE do return cast(i32) endian.unchecked_get_u32be(data)
  else                    do return cast(i32) endian.unchecked_get_u32le(data)
}

read_u32 :: proc(buffer: ^Buffer) -> u32
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+4]
  buffer.r_pos += 4
  
  if buffer.endian == .BE do return endian.unchecked_get_u32be(data)
  else                    do return endian.unchecked_get_u32le(data)
}

read_i64 :: proc(buffer: ^Buffer) -> i64
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+8]
  buffer.r_pos += 8
  
  if buffer.endian == .BE do return cast(i64) endian.unchecked_get_u64be(data)
  else                    do return cast(i64) endian.unchecked_get_u64le(data)
}

read_u64 :: proc(buffer: ^Buffer) -> u64
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+8]
  buffer.r_pos += 8

  if buffer.endian == .BE do return endian.unchecked_get_u64be(data)
  else                    do return endian.unchecked_get_u64le(data)
}

read_f16 :: proc(buffer: ^Buffer) -> f16
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+8]
  buffer.r_pos += 8
  
  if buffer.endian == .BE do return transmute(f16) endian.unchecked_get_u16be(data)
  else                    do return transmute(f16) endian.unchecked_get_u16le(data)
}

read_f32 :: proc(buffer: ^Buffer) -> f32
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+8]
  buffer.r_pos += 8
  
  if buffer.endian == .BE do return transmute(f32) endian.unchecked_get_u32be(data)
  else                    do return transmute(f32) endian.unchecked_get_u32le(data)
}

read_f64 :: proc(buffer: ^Buffer) -> f64
{
  data := buffer.data[buffer.r_pos:buffer.r_pos+8]
  buffer.r_pos += 8
  
  if buffer.endian == .BE do return transmute(f64) endian.unchecked_get_u64be(data)
  else                    do return transmute(f64) endian.unchecked_get_u64le(data)
}

read_bytes :: proc(buffer: ^Buffer, size := -1) -> []byte
{
  end := size == -1 ? len(buffer.data) : buffer.r_pos + size
  result := buffer.data[buffer.r_pos:end]
  buffer.r_pos += size == -1 ? end : size
  return result
}

write_byte :: #force_inline proc(buffer: ^Buffer, val: byte)
{
  write_u8(buffer, val)
}

write_i8 :: proc(buffer: ^Buffer, val: i8)
{
  buffer.data[buffer.w_pos] = cast(byte) val
  buffer.w_pos += 1
}

write_u8 :: proc(buffer: ^Buffer, val: u8)
{
  buffer.data[buffer.w_pos] = val
  buffer.w_pos += 1
}

write_i16 :: proc(buffer: ^Buffer, val: i16)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+2]
  buffer.w_pos += 2

  if buffer.endian == .BE do endian.unchecked_put_u16be(data, u16(val))
  else                    do endian.unchecked_put_u16le(data, u16(val))
}

write_u16 :: proc(buffer: ^Buffer, val: u16)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+2]
  buffer.w_pos += 2

  if buffer.endian == .BE do endian.unchecked_put_u16be(data, val)
  else                    do endian.unchecked_put_u16le(data, val)
}

write_i32 :: proc(buffer: ^Buffer, val: i32)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+4]
  buffer.w_pos += 4
  
  if buffer.endian == .BE do endian.unchecked_put_u32be(data, u32(val))
  else                    do endian.unchecked_put_u32le(data, u32(val))
}

write_u32 :: proc(buffer: ^Buffer, val: u32)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+4]
  buffer.w_pos += 4

  if buffer.endian == .BE do endian.unchecked_put_u32be(data, val)
  else                    do endian.unchecked_put_u32le(data, val)
}

write_i64 :: proc(buffer: ^Buffer, val: i64)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+8]
  buffer.w_pos += 8

  if buffer.endian == .BE do endian.unchecked_put_u64be(data, u64(val))
  else                    do endian.unchecked_put_u64le(data, u64(val))
}

write_u64 :: proc(buffer: ^Buffer, val: u64)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+8]
  buffer.w_pos += 8

  if buffer.endian == .BE do endian.unchecked_put_u64be(data, val)
  else                    do endian.unchecked_put_u64le(data, val)
}

write_f16 :: proc(buffer: ^Buffer, val: f16)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+2]
  buffer.w_pos += 2

  if buffer.endian == .BE do endian.unchecked_put_u16be(data, transmute(u16) val)
  else                    do endian.unchecked_put_u16le(data, transmute(u16) val)
}

write_f32 :: proc(buffer: ^Buffer, val: f32)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+2]
  buffer.w_pos += 2

  if buffer.endian == .BE do endian.unchecked_put_u32be(data, transmute(u32) val)
  else                    do endian.unchecked_put_u32le(data, transmute(u32) val)
}

write_f64 :: proc(buffer: ^Buffer, val: f64)
{
  data := buffer.data[buffer.w_pos:buffer.w_pos+2]
  buffer.w_pos += 2

  if buffer.endian == .BE do endian.unchecked_put_u64be(data, transmute(u64) val)
  else                    do endian.unchecked_put_u64le(data, transmute(u64) val)
}

write_bytes :: proc(buffer: ^Buffer, val: []byte)
{
  for b in val
  {
    buffer.data[buffer.w_pos] = b
    buffer.w_pos += 1
  }
}

equal :: proc(a, b: []byte) -> bool
{
  if len(a) != len(b) do return false

  for i in 0..<len(a)
  {
    if a[i] != b[i] do return false
  }

  return true
}
