package game

import "core:fmt"
import "core:math"
import "core:os"
import "basic/vmath"
import "platform"
import "render"
import "ui"

update_gui_test :: proc()
{
  cursor_pos := platform.get_cursor_position()
  window_size := platform.window_get_size(&user.window)

  ui.begin_tree(&global.gui_tree, {
    window_size = window_size, 
    cursor_pos = cursor_pos,
    input_down = platform.any_mouse_btn_down(),
  })

  if ui.P(ui.box("Left"))
  {
    ui.layout_size(.Percent, {0.5, 1.0})
    ui.layout_fill_color({0.1, 0.1, 0.1, 1})
    ui.layout_child_align(.Horizontal)

    N :: 4.0
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
          i := cast(f32) i
          
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

    if ui.P(ui.text("Hello, world!"))
    {

    }

    N :: 4.0
    for i in 0..<N do if ui.P(ui.box("Box", idx=int(i)))
    {
      i := cast(f32) i
      
      ui.layout_size(.Percent, {1/N, 1/N})
      ui.layout_fill_color({0, i/N, 1, 1})

      if ui.is_hovered()
      {
        ui.layout_fill_color({0, i/N, 1, 1} * 0.8)

        if ui.P(ui.box("Floater"))  
        {
          ui.layout_props({.Floating})
          ui.layout_offset(cursor_pos + {0, -50})
          ui.layout_width(.Pixels, 125)
          ui.layout_height(.Pixels, 50)
          ui.layout_fill_color({1, 1, 0, 1})

          if ui.P(ui.box("Box"))
          {
            ui.layout_size(.Percent, {1, 0.5})
            ui.layout_fill_color({i/N, i/N, i/N, 1})
          }
        }
      }

      if ui.is_pressed()
      {
        ui.current_box().counter += 1
        ui.layout_fill_color({1, 1, 1, 1} * 0.8)
      }
    }
  }
  
  ui.end_tree()
  // os.exit(0)
}

render_gui_test :: proc()
{
  window_size := platform.window_get_size(&user.window)
  
  render.begin_pass({
    shader = &res.shaders[.Sprite],
    texture = &res.textures[.Sprite_Map],
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic_3x3f(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 1},
  })

  for box in global.gui_tree.boxes[1:global.gui_tree.count]
  {
    draw_sprite(
      pos=box.rect_pos,
      scl=box.rect_dim/16,
      color=vmath.concat(box.color.rgb, 0),
      tint={1, 1, 1, box.color.a},
      sprite=.Rect,
    )
  }

  render.end_pass()
}
