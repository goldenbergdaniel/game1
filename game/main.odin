package game

import "base:intrinsics"
import "core:fmt"
import "core:time"

import "basic"
import "basic/mem"
import "platform"
import "render"

WORLD_WIDTH  :: 320.0
WORLD_HEIGHT :: 180.0
WORLD_TEXEL  :: 16.0
WORLD_STEP   :: 1.0/40

user: struct
{
  window:      platform.Window,
  viewport:    f32x4,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
  show_imgui:  bool,
}

update_start_tick, update_end_tick: time.Tick
curr_game, prev_game, res_game: Game

main :: proc()
{
  _ = mem.arena_init_static(&user.perm_arena)
  _ = mem.arena_init_growing(&user.frame_arena)

  window_desc := platform.Window_Desc{
    title = "GAME",
    width = 960,
    height = 540,
    props = {.FULLSCREEN},
  }

  user.window = platform.create_window(window_desc, &user.perm_arena)
  defer platform.destroy_window(&user.window)

  init_resources(&user.perm_arena)
  render.init(&user.window, {0, WORLD_WIDTH, 0, WORLD_HEIGHT}, &res.textures)
  init_global_game_memory()

  init_game(&curr_game)
  start_game(&curr_game)

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !user.window.should_close
  {
    platform.pump_events(&user.window)

    // - Update viewport ---
    {
      window_size := basic.array_cast(platform.window_size(&user.window), f32)
      ratio := window_size.x / window_size.y
      if ratio >= WORLD_WIDTH / WORLD_HEIGHT
      {
        img_width := window_size.x / (ratio * (WORLD_HEIGHT / WORLD_WIDTH))
        user.viewport = {(window_size.x - img_width) / 2, 0, img_width, window_size.y}
      }
      else
      {
        img_height := window_size.y * (ratio / (WORLD_WIDTH / WORLD_HEIGHT))
        user.viewport = {0, (window_size.y - img_height) / 2, window_size.x, img_height}
      }
      
      render.set_viewport(basic.array_cast(user.viewport, i32))
    }

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= WORLD_STEP
    {
      update_start_tick = time.tick_now()
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, WORLD_STEP * curr_game.t_mult)
      platform.save_input()
      update_end_tick = time.tick_now()
 
      // if frame_time * 1000 > 20 do printf("%.0f ms\n", frame_time * 1000)

      curr_game.t += WORLD_STEP * curr_game.t_mult
      accumulator -= WORLD_STEP
    }
    
    platform.imgui_begin()

    if user.show_imgui
    {
      update_debug_gui(&curr_game, WORLD_STEP * curr_game.t_mult)
    }

    alpha := accumulator / WORLD_STEP
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game)

    platform.imgui_end()

    // start_tick := time.tick_now()
    platform.window_swap(&user.window)
    // end_tick := time.tick_now()
    // printf("%.f\n", time.duration_milliseconds(time.tick_diff(start_tick, end_tick)))
  }
}

f32x2 :: [2]f32
f32x3 :: [3]f32
f32x4 :: [4]f32

m2f32 :: matrix[2,2]f32
m3f32 :: matrix[3,3]f32

Range :: basic.Range

range_overlap :: basic.range_overlap
array_cast    :: basic.array_cast
approc        :: basic.approx

printf  :: fmt.printf
println :: fmt.println
panicf  :: fmt.panicf
