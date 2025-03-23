package game

import "core:time"
import "ext:basic/mem"

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
}

user: User

main :: proc()
{
  mem.init_static_arena(&user.perm_arena)
  mem.init_growing_arena(&user.frame_arena)

  user.window = plf.create_window("GAME", WORLD_WIDTH, WORLD_HEIGHT, &user.perm_arena)
  defer plf.release_resources(&user.window)

  init_resources(&user.perm_arena)
  r.init(&user.window, &res.textures)

  curr_game, prev_game, res_game: Game
  init_game(&curr_game)

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !should_quit()
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
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, SIM_STEP * curr_game.t_mult)
      plf.remember_prev_input()

      // if frame_time * 1000 > 20 do printf("%.0f ms\n", frame_time * 1000)

      curr_game.t += SIM_STEP * curr_game.t_mult
      accumulator -= SIM_STEP
    }

    alpha := accumulator / SIM_STEP
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game, SIM_STEP)
    
    plf.swap_buffers(&user.window)
  }
}

should_quit :: #force_inline proc() -> bool
{
  return user.window.should_close
}
