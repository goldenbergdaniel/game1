package game

import "core:fmt"
import "core:net"
import "core:sync"

import "src:basic/mem"
import plf "src:platform"

Game :: struct
{
  ship_1:      Entity,
  ship_2:      Entity,
  projectiles: [64]Entity,
  asteroids:   [16]Entity,
  
  frame_arena: mem.Arena,
}

init_game :: proc(gm: ^Game)
{
  mem.init_growing_arena(&gm.frame_arena)

  gm.ship_1 = Entity{
    kind = .SHIP,
    active = true,
    dim = {100, 100},
    color = {0, 0, 1, 1},
  }

  gm.ship_2 = Entity{
    kind = .SHIP,
    active = true,
    dim = {100, 100},
    color = {1, 0, 0, 1},
  }
  
  for &projectile in gm.projectiles
  {
    projectile = Entity{
      kind = .PROJECTILE,
    }
  }

  for &asteroid in gm.asteroids
  {
    asteroid = Entity{
      kind = .ASTEROID,
    }
  }
}

free_game :: proc(gm: ^Game)
{
  mem.destroy_arena(&gm.frame_arena)
}

copy_game :: proc(new_gm, old_gm: ^Game)
{
  new_gm^ = old_gm^
}

update_game :: proc(gm: ^Game, dt: f32)
{
  if plf.is_key_pressed(.ESCAPE)
  {
    g_user.window.should_close = true
  }

  SPEED :: 500

  if plf.is_key_pressed(.D) && !plf.is_key_pressed(.A)
  {
    gm.ship_1.vel.x = SPEED
  }

  if plf.is_key_pressed(.A) && !plf.is_key_pressed(.D)
  {
    gm.ship_1.vel.x = -SPEED
  }

  if plf.is_key_pressed(.W) && !plf.is_key_pressed(.S)
  {
    gm.ship_1.vel.y = -SPEED
  }

  if plf.is_key_pressed(.S) && !plf.is_key_pressed(.W)
  {
    gm.ship_1.vel.y = SPEED
  }

  if !plf.is_key_pressed(.A) && !plf.is_key_pressed(.D)
  {
    gm.ship_1.vel.x = 0
  }

  if !plf.is_key_pressed(.W) && !plf.is_key_pressed(.S)
  {
    gm.ship_1.vel.y = 0
  }

  gm.ship_1.pos += gm.ship_1.vel * dt

  mem.clear_arena(&gm.frame_arena)
}

render_game :: proc(curr_gm, prev_gm: ^Game, alpha: f32)
{
  ship_1_pos := (curr_gm.ship_1.pos * alpha) + (prev_gm.ship_1.pos * (1 - alpha))
  draw_rect(ship_1_pos, curr_gm.ship_1.dim, curr_gm.ship_1.color)
  // draw_rect(curr_gm.ship_1.pos, curr_gm.ship_1.dim, curr_gm.ship_1.color)
  draw_rect(curr_gm.ship_2.pos, curr_gm.ship_2.dim, curr_gm.ship_2.color)
  draw_rect({600, 300}, {100, 100}, {0, 1, 0, 1})

  r_flush()
}

// Entity ////////////////////////////////////////////////////////////////////////////////

Entity :: struct
{
  kind:   Entity_Kind,
  active: bool,
  pos:    [2]f32,
  vel:    [2]f32,
  dim:    [2]f32,
  color:  [4]f32,
}

Entity_Kind :: enum
{
  SHIP,
  PROJECTILE,
  ASTEROID,
}

// Message ///////////////////////////////////////////////////////////////////////////////

Message :: struct
{
  kind: Message_Kind,
  next: ^Message,
}

Message_Kind :: enum
{
  PLAYER_JOINED,
  PLAYER_LEFT,
}

Message_Queue :: struct
{
  head: ^Message,
  tail: ^Message,
  lock: sync.Mutex,
}

push_message :: proc(queue: ^Message_Queue, msg: Message)
{
  sync.mutex_guard(&queue.lock)

  new_msg := new_clone(msg)
  if queue.head == nil
  {
    queue.head = new_msg
    queue.tail = new_msg
  }
  else
  {
    queue.tail.next = new_msg
    queue.tail = new_msg
  }
}

pop_message :: proc(queue: ^Message_Queue) -> Message
{
  sync.mutex_guard(&queue.lock)

  old_head := queue.head
  queue.head = old_head.next
  result := old_head^

  if old_head.next == nil
  {
    queue.tail = nil
  }

  free(old_head)

  return result
}

peek_message :: #force_inline proc(queue: ^Message_Queue) -> Message
{
  return queue.head^
}
