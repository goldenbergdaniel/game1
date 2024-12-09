package game

import "core:net"

import "src:basic/mem"
import "src:render"

Game :: struct
{
  ship_one:    Entity,
  ship_two:    Entity,
  projectiles: [64]Entity,

  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

init_game :: proc(gm: ^Game)
{
  gm.ship_one = Entity{
    kind = .SHIP,
    active = true,
  }

  gm.ship_two = Entity{
    kind = .SHIP,
    active = true,
  }

  for &projectile in gm.projectiles
  {
    projectile = Entity{
      kind = .PROJECTILE,
      active = true,
    }
  }
}

update_game :: proc(gm: ^Game, dt: f64)
{
  
}

render_game :: proc(gm: ^Game, usr: ^User)
{

}
