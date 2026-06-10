package deco_string

import "base:builtin"
import "core:strings"
import "../mem"

Decorated_String :: struct
{
  chunks:     [dynamic]Chunk,
  len:        int,
  base_color: [3]f32,
  arena:      ^mem.Arena,
}

Chunk :: struct
{
  text:  string,
  color: [3]f32,
  props: bit_set[Chunk_Prop],
}

Chunk_Prop :: enum
{
  Bold,
  Italic,
  Underline,
  Strikethrough,
}

create :: proc(base_color: [3]f32, arena: ^mem.Arena) -> Decorated_String
{
  result: Decorated_String
  result.base_color = base_color
  result.chunks.allocator = mem.allocator(arena)
  result.arena = arena
  return result
}

push :: proc(dstr: ^Decorated_String, chunks: []union{string, Chunk})
{
  for chunk in chunks
  {
    switch v in chunk
    {
    case string:
      builtin.append(&dstr.chunks, Chunk{v, dstr.base_color, {}})
      dstr.len += len(v)

    case Chunk:
      builtin.append(&dstr.chunks, v)
      dstr.len += len(v.text)
    }
  }
}

clear :: proc(dstr: ^Decorated_String)
{
  builtin.clear(&dstr.chunks)
  dstr.len = 0
}

to_string :: proc(dstr: Decorated_String, arena: ^mem.Arena) -> string
{
  result: strings.Builder
  result = strings.builder_make_len(dstr.len, mem.allocator(arena))

  for chunk in dstr.chunks
  {
    strings.write_string(&result, chunk.text)
  }

  return strings.to_string(result)
}

L :: proc(text: string, color: [3]f32 = {1, 1, 1}, props: bit_set[Chunk_Prop] = {}) -> Chunk
{
  return {text, color, props}
}
