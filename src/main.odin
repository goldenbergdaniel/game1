package game

import "core:fmt"
import "core:time"

import "src:basic/mem"
import plf "src:platform"
import "src:render"

WIDTH     :: 960
HEIGHT    :: 540
TICK_RATE :: 1.0/20

User :: struct
{
  window:      plf.Window,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

g_user: User

main :: proc()
{
  mem.init_static_arena(&g_user.perm_arena)
  mem.init_growing_arena(&g_user.frame_arena)

  g_user.window = plf.create_window("GAME", WIDTH, HEIGHT, &g_user.perm_arena)
  defer plf.release_resources(&g_user.window)

  curr_game, prev_game, res_game: Game
  init_game(&curr_game)

  r_init_renderer()

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !should_quit()
  {
    plf.pump_events(&g_user.window)

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= TICK_RATE
    {
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, TICK_RATE)
      plf.save_prev_input()

      accumulator -= TICK_RATE
    }

    alpha := accumulator / TICK_RATE
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game)
    
    plf.swap_buffers(&g_user.window)
  }
}

should_quit :: proc() -> bool
{
  return g_user.window.should_close
}
