package game

import "core:net"

import "src:basic/mem"

MAX_PROJECTILES :: 16

server: Server

main_server :: proc()
{
  mem.init_static_arena(&server.perm_arena)
  mem.init_growing_arena(&server.frame_arena)

  init_game_entities()

  for
  {

  }
}

Server :: struct
{
  state:       Game_State,
  player1:     Player,
  player2:     Player,
  ship1:       Entity,
  ship2:       Entity,
  projectiles: [MAX_PROJECTILES]Entity,

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
  server.ship1 = Entity{
    kind = .SHIP,
    active = true,
  }

  server.ship2 = Entity{
    kind = .SHIP,
    active = true,
  }

  for i in 0..<MAX_PROJECTILES
  {
    server.projectiles[i] = Entity{
      kind = .PROJECTILE,
      active = true,
    }
  }
}

Player :: struct
{
  tcp_socket: net.TCP_Socket,
  udp_socket: net.UDP_Socket,
  color: [4]f32,
}
