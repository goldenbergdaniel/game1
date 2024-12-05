package game

import "core:fmt"
import "core:thread"

import "src:basic/mem"
import "src:draw"
import plf "src:platform"

WIDTH  :: 960
HEIGHT :: 540

client: Client
message_queue: Message_Queue
listen_messages_thread: thread.Thread

main :: proc()
{
  mem.init_static_arena(&client.perm_arena)
  mem.init_growing_arena(&client.frame_arena)

  window := plf.create_window("GAME", 960, 540, &client.perm_arena) 

  draw.setup_scratch()

  should_quit := false
  for !should_quit
  {
    plf.pump_events(&window)

    event: plf.Event
    for plf.poll_event(&window, &event)
    {
      #partial switch event.kind
      {
      case .QUIT: should_quit = true
      }
    }

    draw.scratch(&window)
  }

  plf.release_os_resources(&window)
}

listen_messages_thread_proc :: proc(this: ^thread.Thread)
{
  
}

Client :: struct
{
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

handle_input :: proc()
{

}

send_state :: proc()
{

}
