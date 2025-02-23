package game

import "core:time"

import "src:basic/mem"
import plf "src:platform"
import r "src:render"

WINDOW_WIDTH  :: 960
WINDOW_HEIGHT :: 540
SIM_STEP      :: 1.0/60

User :: struct
{
  window:      plf.Window,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

user: User

main :: proc()
{
  mem.init_static_arena(&user.perm_arena)
  mem.init_growing_arena(&user.frame_arena)

  user.window = plf.create_window("GAME", WINDOW_WIDTH, WINDOW_HEIGHT, &user.perm_arena)
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

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= SIM_STEP
    {
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, SIM_STEP)
      plf.remember_prev_input()

      curr_game.t += SIM_STEP
      accumulator -= SIM_STEP
    }

    alpha := accumulator / SIM_STEP
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game, SIM_STEP)
    
    plf.swap_buffers(&user.window)
  }
}

should_quit :: proc() -> bool
{
  return user.window.should_close
}
