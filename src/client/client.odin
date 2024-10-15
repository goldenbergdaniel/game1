package client

// import "core:fmt"
import "core:thread"
import rl "ext:raylib"
import "src:basic/mem"
import com "src:common"

WIDTH  :: 960
HEIGHT :: 540

gm: Game
message_queue: com.Message_Queue
listen_messages_thread: thread.Thread

main :: proc()
{
  mem.init_arena_static(&gm.perm_arena)
  mem.init_arena_growing(&gm.frame_arena)

  rl.SetTraceLogLevel(.NONE)
  rl.InitWindow(WIDTH, HEIGHT, "NETPONG")
  rl.SetWindowState({.VSYNC_HINT})
  rl.SetTargetFPS(120)

  for !rl.WindowShouldClose()
  {
    handle_input()

    rl.BeginDrawing()
    draw_game()
    rl.EndDrawing()
  }

  rl.CloseWindow()
}

listen_messages_thread_proc :: proc(this: ^thread.Thread)
{
  
}


// Game //////////////////////////////////////////////////////////////////////////////////


Game :: struct
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

draw_game :: proc()
{
  rl.ClearBackground(rl.Color{255, 255, 255, 1})
}


// Messages //////////////////////////////////////////////////////////////////////////////


