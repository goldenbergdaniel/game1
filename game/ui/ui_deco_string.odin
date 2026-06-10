package ui

import "base:builtin"
import "core:strings"
import "../basic/mem"

Decorated_String :: struct
{
  chunks:     [dynamic]Decorated_String_Chunk,
  len:        int,
  base_color: [3]f32,
  arena:      ^mem.Arena,
}

Decorated_String_Chunk :: struct
{
  text:  string,
  color: [3]f32,
  props: bit_set[Text_Decoration],
}

Text_Decoration :: enum
{
  Bold,
  Italic,
  Underline,
  Strikethrough,
}

create_decorated_string :: proc(base_color: [3]f32, arena: ^mem.Arena) -> Decorated_String
{
  result: Decorated_String
  result.base_color = base_color
  result.chunks.allocator = mem.allocator(arena)
  result.arena = arena
  return result
}

decorated_string_push :: proc(dstr: ^Decorated_String, chunk: union{string, Decorated_String_Chunk})
{
  switch v in chunk
  {
  case string:
    builtin.append(&dstr.chunks, Decorated_String_Chunk{v, dstr.base_color, {}})
    dstr.len += len(v)

  case Decorated_String_Chunk:
    builtin.append(&dstr.chunks, v)
    dstr.len += len(v.text)
  }
}

decorated_string_clear :: proc(dstr: ^Decorated_String)
{
  builtin.clear(&dstr.chunks)
  dstr.len = 0
}

string_from_decorated_string :: proc(dstr: Decorated_String, arena: ^mem.Arena) -> string
{
  builder: strings.Builder
  builder = strings.builder_make_len(dstr.len, mem.allocator(arena))

  for chunk in dstr.chunks
  {
    strings.write_string(&builder, chunk.text)
  }

  return strings.to_string(builder)
}

dstr :: proc(
  text: string, 
  color: [3]f32 = {1, 1, 1}, 
  props: bit_set[Text_Decoration] = {},
) -> Decorated_String_Chunk
{
  return {text, color, props}
}
