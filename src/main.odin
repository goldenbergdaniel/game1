package game

import "core:fmt"
import "core:time"

import "src:basic/mem"
import plf "src:platform"
import "src:render"

WIDTH  :: 960
HEIGHT :: 540

user: User
message_queue: Message_Queue

main :: proc()
{
  mem.init_static_arena(&user.perm_arena)
  mem.init_growing_arena(&user.frame_arena)

  user.window = plf.create_window("GAME", WIDTH, HEIGHT, &user.perm_arena)
  defer plf.release_resources(&user.window)

  game: Game
  init_game(&game)

  render.setup_scratch()

  user.should_quit = false
  for !user.should_quit
  {
    poll_user(&user)
    update_game(&game, 0.0)
    render_game(&game, &user)

    render.scratch(&user.window)
  }
}

User :: struct
{
  window:      plf.Window,
  should_quit: bool,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

poll_user :: proc(usr: ^User)
{
  plf.pump_events(&usr.window)

  event: plf.Event
  for plf.poll_event(&usr.window, &event)
  {
    switch event.kind
    {
    case .NONE:
    case .QUIT: user.should_quit = true
    case .KEY_DOWN:
      switch event.key_kind
      {
      case .NONE:
      case .ESCAPE: user.should_quit = true
      }
    }
  }
}
