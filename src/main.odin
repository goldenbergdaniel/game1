package game

import "core:fmt"
import "core:time"

import "src:basic/mem"
import plf "src:platform"
import "src:render"

WIDTH  :: 1440
HEIGHT :: 810

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

  curr_game, prev_game: Game
  init_game(&curr_game)

  r_init_renderer()

  TIME_STEP :: 1.0/30

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !should_quit()
  {
    plf.pump_events(&g_user.window)

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= TIME_STEP
    {
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, TIME_STEP)
      
      accumulator -= TIME_STEP
      if frame_time * 1000 > 1/TIME_STEP do fmt.println("ft:", frame_time * 1000)
    }

    alpha := accumulator / TIME_STEP
    render_game(&curr_game, &prev_game, f32(alpha))
    
    plf.swap_buffers(&g_user.window)
  }
}

should_quit :: proc() -> bool
{
  return g_user.window.should_close
}
