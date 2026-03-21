package game

import "core:math"
import "basic/mem"
import "basic/vmath"
import "platform"
import "render"
import "ui"

box_counters: [4]int

update_gui_test :: proc()
{
  cursor_pos := platform.get_cursor_position()
  window_size := platform.window_get_size(&user.window)

  ui.begin_tree(&global.gui_tree, {
    background_color = {0.1, 0.1, 0.1, 1},
    window_size = window_size, 
    cursor_pos = cursor_pos,
    input_down = platform.any_mouse_btn_down(),
  })

  ui.spacer({.Percent, 0.333}, {.Percent, 1.0})
  
  if ui.P(ui.box("Right"))
  {
    ui.layout_size(.Percent, {0.333, 1.0})
    ui.layout_child_align(.Vertical)

    ui.spacer({.Percent, 1.0}, {.Percent, 0.35})

    N : f32 : 3.0
    for i in 0..<int(N) do if ui.P(ui_sprite("Box", .UI_Square, idx=i))
    {
      ui.layout_width(.Percent, 1)
      ui.layout_height(.Percent, 0.1)
      ui.layout_color({f32(i+1)/(N+1), f32(i+1)/(N+1), f32(i+1)/(N+1), 1})

      if ui.is_hovered()
      {
        ui.layout_color({f32(i+1)/(N+1), f32(i+1)/(N+1), f32(i+1)/(N+1), 1} * 0.9)
        ui.text("Bücher")

        if ui.P(ui_tooltip(i, cursor_pos))
        {
          ui.layout_color({1, 0, 0, 1})
        }
      }

      if ui.is_pressed()
      {
        ui.layout_color({1, 1, 1, 1} * 0.8)
      }

      if ui.is_just_pressed()
      {
        ui.current_box().counter += 1
        box_counters[i] = ui.current_box().counter
      }
    }

    ui.spacer({.Percent, 1.0}, {.Percent, 0.35})
  }

  ui.spacer({.Percent, 0.333}, {.Percent, 1.0})
  
  ui.end_tree()
}

render_gui_test :: proc()
{
  window_size := platform.window_get_size(&user.window)

  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)
  
  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 1},
  })

  iter := ui.make_iterator_preorder(global.gui_tree.root, scratch)
  for box in ui.iterate_preorder(&iter)
  {
    sprite := cast(Sprite_Name) box.sprite
    if sprite == nil
    {
      sprite = .UI_Square
    }

    draw_sprite(sprite=sprite,
                pos=box.rect_pos,
                scl=box.rect_dim/16,
                color=vmath.concat(box.color.rgb, 0),
                tint={1, 1, 1, box.color.a})

    draw_text(text=box.text, 
              pos=box.rect_pos, 
              size=box.text_size, 
              line_height=box.text_line_height,
              color=box.color)
  }

  render.end_pass()

  mem.arena_clear(&global.ui_frame_arena)
}

@(private="file")
ui_sprite :: proc(name: string, sprite: Sprite_Name, idx: Maybe(int) = nil) -> ^ui.Box
{
  box := ui.create_box(name, idx, true)
  box.sprite = cast(int) sprite
  return box
}

ui_tooltip :: proc(i: int, cursor_pos: [2]f32) -> ^ui.Box
{
  box := ui.box("Tooltip")
  if ui.P(box)  
  {
    ui.layout_props({.Floating})
    ui.layout_offset(cursor_pos + {0, -50})
    ui.layout_width(.Pixels, 150)
    ui.layout_height(.Pixels, 50)
    ui.layout_color({0.7, 0.7, 0.7, 1})

    if ui.P(ui.text("Box %i: %i", i+1, box_counters[i]))
    {
      ui.layout_text_size(2)
      ui.layout_color({1, 1, 1, 0})
      ui.layout_offset({10, 35})
    }
  }

  return box
}
