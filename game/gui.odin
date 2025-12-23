package game

import "core:math"
import "basic/mem"
import "basic/vmath"
import "platform"
import "render"
import "ui"

update_gui_test :: proc()
{
  cursor_pos := platform.get_cursor_position()
  window_size := platform.window_get_size(&user.window)

  ui.begin_tree(&global.gui_tree, {
    background_color = {1, 1, 1, 1},
    window_size = window_size, 
    cursor_pos = cursor_pos,
    input_down = platform.any_mouse_btn_down(),
  })

  if ui.P(ui.box("Left"))
  {
    ui.layout_size(.Percent, {0.5, 1.0})
    ui.layout_fill_color({0.1, 0.1, 0.1, 1})
    ui.layout_child_align(.Horizontal)

    N : f32 : 4.0
    for i in 0..<N
    {
      if i == 2
      {
        ui.spacer({.Percent, 1/N}, {.Percent, 1/N})
      }
      else
      {
        if ui.P(ui.box("Box", idx=int(i)))
        {
          ui.layout_size(.Percent, {1/N, 1/(2*N)})
          ui.layout_fill_color({1, i/N, 0, 1})

          if ui.is_hovered()
          {
            ui.layout_fill_color({1, i/N, 0, 1} * 0.8)
          }
        }
      }
    }
  }
  
  if ui.P(ui.box("Right"))
  {
    ui.layout_size(.Percent, {0.5, 1.0})
    ui.layout_fill_color({0.1, 0.1, 0.1, 1})
    ui.layout_child_align(.Vertical)

    N : f32 : 4.0
    for i in 0..<N do if ui.P(ui_sprite("Box", .Rect, idx=int(i)))
    {
      ui.layout_size(.Percent, {1/N, 1/N})
      ui.layout_fill_color({0, i/N, 1, 1})

      if ui.is_hovered()
      {
        ui.layout_fill_color({0, i/N, 1, 1} * 0.8)

        if ui.P(ui.box("Floater"))  
        {
          ui.layout_props({.Floating})
          ui.layout_offset(cursor_pos + {0, -50})
          ui.layout_width(.Pixels, 150)
          ui.layout_height(.Pixels, 50)
          ui.layout_fill_color({0.7, 0.7, 0.7, 1})

          if ui.P(ui.text("Box %i", int(i)))
          {
            ui.layout_offset({0, 35})
          }
        }
      }

      if ui.is_pressed()
      {
        ui.layout_fill_color({1, 1, 1, 1} * 0.8)
      }

      if ui.is_just_pressed()
      {
        ui.current_box().counter += 1
      }
    }
  }
  
  ui.end_tree()
}

render_gui_test :: proc()
{
  window_size := platform.window_get_size(&user.window)

  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)
  
  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic_3x3f(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 1},
  })


  iter := ui.make_iterator_preorder(global.gui_tree.root, scratch)
  for box in ui.iterate_preorder(&iter)
  {
    sprite := cast(Sprite_Name) box.sprite
    if sprite == nil
    {
      sprite = .Rect
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
