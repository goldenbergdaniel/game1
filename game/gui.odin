#+private file
package game

import "core:math"
import "basic/mem"
import vmath "basic/vmath"
import "platform"
import "ui"

box_counters: [10]int
show_options: bool

Options :: struct
{
  music_volume: f32,
  sfx_volume:   f32,
}

options: Options

@(private="package")
gui_init :: proc(tree: ^ui.Tree)
{
  options.music_volume = 1.0
  options.sfx_volume = 1.0
}

@(private="package")
gui_update :: proc(tree: ^ui.Tree, dt: f32)
{
  ui.begin_tree(tree, {
    background_color = {0.0252, 0.0252, 0.0252, 1.0},
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
    ui.layout_text_color({0.0762, 0.1248, 0.0437})
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

      button := ui.image(names[i], sprite_id(.UI_Rect), idx=i)
      if ui.P(button)
      {
        ui.layout_width(ui.pct(0.3))
        ui.layout_height(ui.px(70))
        ui.layout_child_justify({.Center, .Center})

        if ui.P(ui.text(names[i]))
        {
          ui.layout_text_color({1, 1, 1})
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

        ui.layout_color({0.05, 0.05, 0.05, 1.0})
      }

      ui.spacer(ui.px(0), ui.px(10))
    }
  }
}

ui_options_menu :: proc()
{
  temp_arena := &global.gui_temp_arena

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

    @(static)
    names := [?]string{"Vsync", "View Bobbing", "Show Debug", "Allow Cheats"}

    for i in 0..<len(names)
    {
      button := ui.image(names[i], sprite_id(.UI_Rect), idx=i)
      if ui.P(button)
      {
        ui.layout_width(ui.pct(0.4))
        ui.layout_height(ui.px(60))
        ui.layout_color({0.05, 0.05, 0.05, 1.0})
        ui.layout_child_justify({.Center, .Center})

        @(static)
        states := [2]string{"OFF", "ON"}
        @(static)
        colors := [2][3]f32{{0.9, 0.1, 0.1}, {0.1, 0.9, 0.1}}

        button_state := states[0 if box_counters[i] % 2 == 0 else 1]
        button_color := colors[0 if box_counters[i] % 2 == 0 else 1]

        option_label := ui.create_decorated_string({1, 1, 1}, temp_arena)
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
          ui_tooltip("This is a tooltip. (%i)", box_counters[i])
        }
        
        if ui.just_pressed(button, .Left)
        {
          box_counters[i] += 1
        }
      }

      ui.spacer(ui.px(0), ui.px(10))
    }

    ui_slider("Music", &options.music_volume, true)
    ui.spacer(ui.px(0), ui.px(10))
    ui_slider("SFX", &options.sfx_volume, true)
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

ui_slider :: proc(label: string, value: ^f32, discrete: bool)
{
  assert(value != nil)

  cursor_pos := platform.get_cursor_position()

  outer := ui.box("OuterSlider", idx=int(uintptr(value)))
  if ui.P(outer)
  {
    ui.layout_width(ui.pct(0.4))
    ui.layout_height(ui.px(60))
    ui.layout_color({0.2, 0.2, 0.2, 1.0})
    ui.layout_child_align(.None)

    if ui.pressed(outer, .Left)
    {
      value^ = (cursor_pos.x - outer.rect_pos.x) / outer.rect_dim.x
      value^ = clamp(value^, 0, 1)
      if discrete
      {
        value ^= math.round(value^ * 100.0) / 100.0
      }
    }

    if ui.P(ui.box("InnerSlider"))
    {
      ui.layout_width(ui.pct(value^))
      ui.layout_height(ui.pct(1.0))
      ui.layout_color({0.4, 0.4, 0.8, 1.0})
    }

    if ui.P(ui.box("SliderText"))
    {
      ui.layout_child_justify({.Center, .Center})
      ui.text(label)
    }
    
    if ui.hovered(outer)
    {
      ui_tooltip("%.2f", value^)
    }
  }
}

ui_tooltip :: proc(fmt_str: string, fmt_args: ..any) -> ^ui.Box
{
  box := ui.box("Tooltip")
  if ui.P(box)
  {
    ui.layout_props({.Floating})
    ui.layout_offset(platform.get_cursor_position() + {0, -40})
    ui.layout_width(ui.fit_children())
    ui.layout_height(ui.px(40))
    ui.layout_color({0.4, 0.4, 0.4, 0.9})
    ui.layout_child_justify({nil, .Center})

    if ui.P(ui.text(fmt_str, ..fmt_args))
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
