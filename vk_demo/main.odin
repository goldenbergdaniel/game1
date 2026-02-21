package vk_demo

import "core:fmt"
import "core:time"
import "../game/basic"
import "../game/basic/mem"
import "../game/platform"

User :: struct
{
  perm_arena: mem.Arena,
  window:     platform.Window,
  viewport:   v4f,
  show_dbgui: bool,
}

user: User
game: Game

main :: proc()
{
  @(static)
  prev_keys: [platform.Key_Kind]bool

  if arena_err := mem.arena_init_static(&user.perm_arena); arena_err != nil
  {
    fmt.eprintln("[FATAL][game]: Failed to allocate static arena!", arena_err)
    return
  }

  window_desc := platform.Window_Desc{
    title = "Vulkan Demo",
    width = 1280,
    height = 720,
    props = {},
    renderer = .Vulkan,
  }
  user.window = platform.create_window(window_desc, &user.perm_arena)
  defer platform.destroy_window(&user.window)

  vk_init(&user.window)
  defer vk_done()

  start(&game)

  t, dt: f64
  dt = 0.1

  for !user.window.should_close
  {
    platform.window_pump_events(&user.window)

    // - Global keybinds ---
    {
      if platform.key_down(.Q) && platform.key_down(.Left_Ctrl)
      {
        user.window.should_close = true
      }

      if platform.key_down(.Enter) && !prev_keys[.Enter] && platform.key_down(.Left_Ctrl)
      {
        platform.window_toggle_fullscreen(&user.window)
      }
    }

    update(&game, t, dt)
    t += dt

    vk_render(&game)

    prev_keys = platform.global_input.keys
    platform.window_draw(&user.window)
  }
}

v2f :: [2]f32
v3f :: [3]f32
v4f :: [4]f32

m2x2f :: matrix[2,2]f32
m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

Range :: basic.Range

range_overlap :: basic.range_overlap
array_cast    :: basic.array_cast
approx        :: basic.approx
rad_from_deg  :: basic.rad_from_deg
deg_from_rad  :: basic.deg_from_rad
