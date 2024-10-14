package client

import "src:basic/mem"
import rl "ext:raylib"

WIDTH  :: 960
HEIGHT :: 540

gm: Game

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
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{255, 255, 255, 1})
    rl.EndDrawing()
  }

  rl.CloseWindow()
}

Game :: struct
{
  perm_arena: mem.Arena,
  frame_arena: mem.Arena,
}
