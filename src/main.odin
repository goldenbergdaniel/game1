package game

import "core:fmt"
import "core:time"

import "src:basic/mem"
import plf "src:platform"
import "src:render"

WIDTH  :: 960
HEIGHT :: 540

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

  game: Game
  init_game(&game)

  r_init_renderer()

  for !should_quit()
  {
    plf.pump_events(&g_user.window)

    update_game(&game, 0.0)
    render_game(&game)
    
    plf.swap_buffers(&g_user.window)
  }
}

should_quit :: proc() -> bool
{
  return g_user.window.should_close
}
