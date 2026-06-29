#+feature dynamic-literals
package game

import "basic/mem"
import vmath "basic/vmath"
import "platform"
import "render"
import "ui"

box_counters: [5]int
show_options: bool

update_gui_test :: proc(dt: f32)
{
  ui.begin_tree(&global.gui_tree, {
    background_color = {0.1, 0.1, 0.1, 1.0},
    window_size = platform.window_get_size(&user.window), 
    cursor_pos = platform.get_cursor_position(),
    mouse_btn_down = {
      .Left = platform.input.mouse_btns[.Left],
      .Right = platform.input.mouse_btns[.Right],
      .Middle = platform.input.mouse_btns[.Middle],
    },
  })

  if platform.key_down(.Escape)
  {
    show_options = false
  }
  
  if user.screen == .Main_Menu
  {
    ui.layout_child_width(ui.pct(1.0))
    ui.layout_child_height(ui.pct(1.0))
    ui.layout_child_align(.Vertical)
    ui.layout_child_justify({.Center, nil})

    if !show_options
    {
      ui_main_menu()
    }
    else if show_options
    {
      ui_options_menu()
    }

    ui.spacer(ui.px(0), ui.pct(0.05))

    if (ui.P(ui.text("© 2026 Daniel Goldenberg")))
    {
      ui.layout_text_size(1)
    }
  }
  else if user.screen == .Game
  {
    ui.layout_child_width(ui.pct(1.0))
    ui.layout_child_height(ui.pct(1.0))
    ui.layout_color({0, 0, 0, 0})

    ui_hud()
  }

  ui.end_tree(dt)
}

ui_main_menu :: proc()
{
  ui.spacer(ui.px(0), ui.pct(0.1))
  
  if (ui.P(ui.text("Untitled")))
  {
    ui.layout_text_size(8)
  }

  ui.spacer(ui.px(0), ui.pct(0.1))

  if ui.P(ui.box("MainMenu"))
  {
    ui.layout_child_align(.Vertical)
    ui.layout_child_justify({.Center, nil})
    ui.layout_height(ui.fit_children())

    for i in 0..<3
    {
      @(static)
      names := [?]string{"Play", "Options", "Quit"}

      button := ui.image(names[i], sprite_id(.UI_Square), idx=i)
      if ui.P(button)
      {
        ui.layout_width(ui.pct(0.3))
        ui.layout_height(ui.px(70))
        ui.layout_child_justify({.Center, .Center})

        if ui.P(ui.text(names[i]))
        {
          ui.layout_text_size(3)
        }

        if ui.hovered(button)
        {
          ui.layout_shade(1.2)
        }
        
        if ui.just_pressed(button, .Left)
        {
          switch names[i]
          {
            case "Play":
              user.screen = .Game

            case "Options":
              show_options = true

            case "Quit":
              user.window.should_close = true
          }

          platform.consume_mouse_btn(.Left)
        }

        ui.layout_color({0.2, 0.2, 0.2, 1.0})
      }

      ui.spacer(ui.px(0), ui.px(10))
    }
  }
}

ui_options_menu :: proc()
{
  frame_arena := &global.ui_frame_arena

  ui.spacer(ui.px(0), ui.pct(0.05))
  
  if (ui.P(ui.text("Options")))
  {
    ui.layout_text_size(4)
  }

  ui.spacer(ui.px(0), ui.pct(0.05))

  if ui.P(ui.box("OptionsMenu"))
  {
    ui.layout_child_align(.Vertical)
    ui.layout_child_justify({.Center, nil})
    ui.layout_height(ui.fit_children())

    for i in 0..<5
    {
      @(static)
      names := [?]string{"Vsync", "View Bobbing", "Auto-Jump", "Show Debug", "Allow Cheats"}

      button := ui.image(names[i], sprite_id(.UI_Square), idx=i)
      if ui.P(button)
      {
        ui.layout_width(ui.pct(0.4))
        ui.layout_height(ui.px(60))
        ui.layout_child_justify({.Center, .Center})
        ui.layout_color({0.2, 0.2, 0.2, 1.0})

        @(static)
        states := [2]string{"OFF", "ON"}
        @(static)
        colors := [2][3]f32{{0.9, 0.1, 0.1}, {0.1, 0.9, 0.1}}

        button_state := states[0 if box_counters[i] % 2 == 0 else 1]
        button_color := colors[0 if box_counters[i] % 2 == 0 else 1]

        option_label := ui.create_decorated_string({1, 1, 1}, frame_arena)
        ui.decorated_string_push(&option_label, names[i])
        ui.decorated_string_push(&option_label, ": ")
        ui.decorated_string_push(&option_label, ui.dstr(button_state, color=button_color))
        if ui.P(ui.text(option_label))
        {
          ui.layout_text_size(2)
        }

        if ui.hovered(button)
        {
          ui.layout_shade(1.2)
          ui_tooltip(i, platform.get_cursor_position())
        }
        
        if ui.just_pressed(button, .Left)
        {
          box_counters[i] += 1
        }
      }

      ui.spacer(ui.px(0), ui.px(10))
    }
  }
}

heart_critical: ui.Animation_Desc

ui_hud :: proc()
{
  heart_critical = transmute(ui.Animation_Desc) res.animations[.Heart_Healthy]

  if ui.P(ui.animated_image("Health", &heart_critical, looping=true))
  {
    ui.layout_offset({96, 96})
    ui.layout_width(ui.px(160))
    ui.layout_height(ui.px(160))
  }
}

ui_tooltip :: proc(i: int, cursor_pos: v2f32) -> ^ui.Box
{
  box := ui.box("Tooltip")
  if ui.P(box)
  {
    ui.layout_props({.Floating})
    ui.layout_offset(cursor_pos + {0, -40})
    ui.layout_width(ui.fit_children())
    ui.layout_height(ui.px(40))
    ui.layout_color({0.4, 0.4, 0.4, 0.9})
    ui.layout_child_justify({nil, .Center})

    if ui.P(ui.text("This is a tooltip. (%i)", box_counters[i]))
    {
      ui.layout_text_size(2)
    }
  }

  return box
}

@(private="file")
sprite_id :: proc(sprite: Sprite_Name) -> int
{
  return cast(int) sprite
}

render_gui :: proc(tree: ^ui.Tree)
{
  window_size := platform.window_get_size(&user.window)

  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)
  
  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 0},
  })

  iter := ui.make_iterator_preorder(tree.root, scratch)
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

    if box.decorated_text.len != 0
    {
      draw_decorated_text(text=box.decorated_text, 
                          pos=box.rect_pos, 
                          size=box.text_size, 
                          line_height=1)
    }
    else if box.text != ""
    {
      draw_text(text=box.text, 
                pos=box.rect_pos, 
                size=box.text_size, 
                line_height=1,
                color=box.color)
    }
  }

  render.end_pass()

  mem.arena_clear(&global.ui_frame_arena)
}
