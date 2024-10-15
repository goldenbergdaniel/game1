package server

import "core:net"
import "src:basic/mem"
import com "src:common"

MAX_BALLS :: 16

gm: Game

main :: proc()
{
  mem.init_arena_static(&gm.perm_arena)
  mem.init_arena_growing(&gm.frame_arena)

  init_game_entities()

  for
  {

  }
}


// Game //////////////////////////////////////////////////////////////////////////////////


Game :: struct
{
  state:   Game_State,
  player1: Player,
  player2: Player,
  paddle1: Paddle,
  paddle2: Paddle,
  balls:   [MAX_BALLS]Ball,

  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

Game_State :: enum
{
  LOBBY,
  PLAYING,
  END,
}

init_game_entities :: proc()
{
  gm.paddle1 = Paddle{
    kind = .PADDLE,
    active = true,
    color = com.COLOR_BLUE,
  }

  gm.paddle2 = Paddle{
    kind = .PADDLE,
    active = true,
    color = com.COLOR_RED,
  }

  for &ball in gm.balls
  {
    ball = Ball{
      kind = .BALL,
      active = true,
      color = com.COLOR_WHITE
    }
  }
}


// Player ////////////////////////////////////////////////////////////////////////////////


Player :: struct
{
  tcp_socket: net.TCP_Socket,
  udp_socket: net.UDP_Socket,
  color: [4]f32,
}

Entity :: com.Entity
Ball   :: com.Ball
Paddle :: com.Paddle
