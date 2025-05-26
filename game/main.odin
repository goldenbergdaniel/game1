package game

import "base:intrinsics"
import "core:fmt"
import "core:time"

import "basic/mem"
import plf "platform"
import r "render"
import vm "vecmath"

WORLD_WIDTH  :: 960.0
WORLD_HEIGHT :: 540.0
SIM_STEP     :: 1.0/60

User :: struct
{
  window:      plf.Window,
  viewport:    v4f32,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
  show_imgui:  bool,
}

user: User
update_start_tick, update_end_tick: time.Tick
curr_game, prev_game, res_game: Game

main :: proc()
{
  mem.init_static_arena(&user.perm_arena)
  mem.init_growing_arena(&user.frame_arena)

  user.window = plf.create_window("GAME", WORLD_WIDTH, WORLD_HEIGHT, &user.perm_arena)
  defer plf.release_resources(&user.window)
  plf.window_toggle_fullscreen(&user.window)

  init_resources(&user.perm_arena)
  r.init(&user.window, &res.textures)

  init_game(&curr_game)

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !user.window.should_close
  {
    plf.pump_events(&user.window)

    // - Update viewport ---
    {
      window_size := vm.array_cast(plf.window_size(&user.window), f32)
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
      
      r.set_viewport(vm.array_cast(user.viewport, i32))
    }

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= SIM_STEP
    {
      update_start_tick = time.tick_now()
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, SIM_STEP * curr_game.t_mult)
      plf.remember_prev_input()
      update_end_tick = time.tick_now()
 
      // if frame_time * 1000 > 20 do printf("%.0f ms\n", frame_time * 1000)

      curr_game.t += SIM_STEP * curr_game.t_mult
      accumulator -= SIM_STEP
    }
    
    plf.imgui_begin()

    if user.show_imgui
    {
      update_debug_ui(&curr_game, SIM_STEP * curr_game.t_mult)
    }

    alpha := accumulator / SIM_STEP
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game, SIM_STEP)

    plf.imgui_end()

    // start_tick := time.tick_now()
    plf.swap_buffers(&user.window)
    // end_tick := time.tick_now()
    // printf("%.f\n", time.duration_milliseconds(time.tick_diff(start_tick, end_tick)))
  }
}

v2f32 :: [2]f32
v3f32 :: [3]f32
v4f32 :: [4]f32

m2x2f32 :: matrix[2,2]f32
m3x3f32 :: matrix[3,3]f32

printf  :: fmt.printf
println :: fmt.println
panicf  :: fmt.panicf

approx :: #force_inline proc(val, tar, tol: $T) -> T 
  where intrinsics.type_is_numeric(T)
{
  return tar if abs(val) - abs(tol) <= abs(tar) else val
}
