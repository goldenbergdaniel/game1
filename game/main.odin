package game

import "core:fmt"
import "core:math"
import "core:time"
import "basic"
import "basic/mem"
import "platform"
import "render"

VIEWPORT_WIDTH  :: 240.0
VIEWPORT_HEIGHT :: 135.0
TIME_STEP       :: 1.0 / 40

User :: struct
{
  perm_arena: mem.Arena,
  window:     platform.Window,
  viewport:   v4f32,
  screen:     Screen,
  show_dbgui: bool,
}

Screen :: enum
{
  Main_Menu, 
  Game, 
}

user: User

update_start_tick, update_end_tick: time.Tick
render_start_tick, render_end_tick: time.Tick

main :: proc()
{
  @(static)
  curr_game, prev_game, res_game: Game

  @(static)
  prev_keys: [platform.Key_Kind]bool

  arena_err: mem.Allocator_Error

  arena_err = mem.arena_init_static(&user.perm_arena)
  if arena_err != nil
  {
    fmt.eprintln("Failed to allocate static arena!", arena_err)
    return
  }

  window_desc := platform.Window_Desc{
    title = "GAME",
    width = 1280,
    height = 720,
    props = {.Vsync, .Resizeable},
    renderer = .OpenGL,
  }

  user.window = platform.create_window(window_desc, &user.perm_arena)
  defer platform.destroy_window(&user.window)

  user.screen = .Game

  render.init_renderer(&user.window)
  init_resources(&user.perm_arena)

  platform.window_init_imgui(&user.window)

  init_audio()
  init_global()

  game_init(&curr_game)
  game_start(&curr_game)

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !user.window.should_close
  {
    platform.window_pump_events(&user.window)

    // - Global keybinds ---
    {
      if platform.key_down(.Q) && !prev_keys[.Q] && platform.key_down(.Left_Ctrl)
      {
        user.window.should_close = true
      }

      if platform.key_down(.Tab) && !prev_keys[.Tab] && !platform.key_down(.Left_Ctrl)
      {
        user.show_dbgui = !user.show_dbgui
      }

      if platform.key_down(.Backward_Slash) && !prev_keys[.Backward_Slash]
      {
        user.screen = cast(Screen) ((int(user.screen) + 1) % len(Screen))
      }

      if platform.key_down(.Enter) && !prev_keys[.Enter] && platform.key_down(.Left_Ctrl)
      {
        platform.window_toggle_fullscreen(&user.window)
      }
    }

    window_size := platform.window_get_size(&user.window)
    ratio := window_size.x / window_size.y
    if ratio >= VIEWPORT_WIDTH / VIEWPORT_HEIGHT
    {
      img_width := window_size.x / (ratio * (VIEWPORT_HEIGHT / VIEWPORT_WIDTH))
      user.viewport = {(window_size.x - img_width) / 2, 0, img_width, window_size.y}
    }
    else
    {
      img_height := window_size.y * (ratio / (VIEWPORT_WIDTH / VIEWPORT_HEIGHT))
      user.viewport = {0, (window_size.y - img_height) / 2, window_size.x, img_height}
    }

    update_start_tick = time.tick_now()

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time

    if user.screen == .Game
    {
      accumulator += frame_time
      num_ticks := int(math.floor(accumulator / TIME_STEP))
      accumulator -= f64(num_ticks) * TIME_STEP

      for tick_idx in 0..<num_ticks
      {
        game_copy(&prev_game, &curr_game)
        game_update(&curr_game, TIME_STEP * curr_game.t_mult)
         
        curr_game.t += TIME_STEP * curr_game.t_mult
      }
    }
    else if user.screen == .Main_Menu
    {
      update_gui_test()
    }

    update_end_tick = time.tick_now()

    render_start_tick = time.tick_now()

    switch user.screen
    {
    case .Main_Menu:
      render_gui_test()
      
    case .Game:
      alpha := accumulator / TIME_STEP
      interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
      game_render(&res_game)
    }

    render_end_tick = time.tick_now()

    if user.show_dbgui
    {
      platform.imgui_begin()
      update_debug_gui(&curr_game, TIME_STEP * curr_game.t_mult)
      platform.imgui_end()
    }

    prev_keys = platform.global_input.keys
    platform.window_draw(&user.window)
  }
}

v2f32 :: [2]f32
v3f32 :: [3]f32
v4f32 :: [4]f32

m2f32 :: matrix[2,2]f32
m3f32 :: matrix[3,3]f32

Range :: basic.Range

range_overlap :: basic.range_overlap
array_cast    :: basic.array_cast
approx        :: basic.approx
rad_from_deg  :: basic.rad_from_deg
deg_from_rad  :: basic.deg_from_rad

print   :: fmt.print
printf  :: fmt.printf
println :: fmt.println
panicf  :: fmt.panicf
