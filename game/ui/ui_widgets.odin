package ui

import "core:fmt"
import "../basic/mem"

box :: proc(name: string, idx: Maybe(int) = nil) -> ^Box
{
  return create_box(name == "" ? "Box" : name, idx, true)
}

image :: proc(name: string, sprite: int, idx: Maybe(int) = nil) -> ^Box
{
  image := create_box(name, idx, true)
  image.color.a = 1
  image.sprite = sprite
  return image
}

animated_image :: proc(
  name: string, 
  anim: ^Animation_Desc, 
  looping: bool, 
  reverse: bool = false, 
  speed: f32 = 1.0, 
  idx: Maybe(int) = nil
) -> ^Box
{
  image := create_box(name, idx, true)
  image.color.a = 1
  image.animation.data = anim
  image.animation.looping = looping
  image.animation.reverse = reverse
  image.animation.speed = speed
  return image
}

spacer :: proc(w, h: Size, idx: Maybe(int) = nil) -> ^Box
{
  spacer := create_box("Spacer", idx, false)

  begin_box(spacer)
  layout_width(w)
  layout_height(h)
  end_box()

  return spacer
}

text :: proc{plain_text, decorated_text}

plain_text :: proc(fmt_str: string, fmt_args: ..any, idx: Maybe(int) = nil) -> ^Box
{
  text := create_box("Text", idx, false)

  begin_box(text)
  layout_width(fit_text())
  layout_height(fit_text())
  layout_text_size(2)
  layout_color({1, 1, 1, 0})
  content := fmt.aprintf(fmt_str, ..fmt_args, allocator=mem.allocator(global_tree.temp_arena))
  global_tree.curr.text = content
  end_box()

  return text
}

decorated_text :: proc(str: Decorated_String, idx: Maybe(int) = nil) -> ^Box
{
  decorated_text := create_box("Text", idx, false)

  begin_box(decorated_text)
  layout_width(fit_text())
  layout_height(fit_text())
  layout_text_size(2)
  layout_color({1, 1, 1, 0})
  global_tree.curr.decorated_text = str
  global_tree.curr.text = string_from_decorated_string(str, global_tree.temp_arena)
  end_box()

  return decorated_text
}
