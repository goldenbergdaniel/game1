package game

import "core:fmt"
import "core:net"
import "core:sync"

import "src:basic/mem"
import plf "src:platform"

Game :: struct
{
  ship_one:    Entity,
  ship_two:    Entity,
  projectiles: [64]Entity,
  asteroids:   [16]Entity,
  
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
}

init_game :: proc(gm: ^Game)
{
  mem.init_static_arena(&gm.perm_arena)
  mem.init_growing_arena(&gm.frame_arena)

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
  mem.destroy_arena(&gm.perm_arena)
  mem.destroy_arena(&gm.frame_arena)
}

copy_game :: proc(old_gm: ^Game, new_gm: ^Game)
{
  
}

update_game :: proc(gm: ^Game, dt: f64)
{
  if plf.is_key_pressed(.ESCAPE)
  {
    g_user.window.should_close = true
  }

  mem.clear_arena(&gm.frame_arena)
}

render_game :: proc(gm: ^Game)
{
  draw_rect({100, 100}, {100, 100}, {1, 0, 0, 1})
  draw_rect({200, 400}, {100, 100}, {0, 1, 0, 1})
  draw_rect({600, 300}, {100, 100}, {0, 0, 1, 1})

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
  color:  [4]u8,
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
