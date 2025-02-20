package game

import "base:runtime"
import "core:fmt"
import "core:image/bmp"
import "core:net"
import "core:os"
import "core:slice"
import "core:sync"
import "core:hash"

import "src:basic/mem"
import plf "src:platform"
import r "src:render"

// Game //////////////////////////////////////////////////////////////////////////////////

@(private="file")
game_frame_arena: mem.Arena

Game :: struct
{
  ship_1:      Entity,
  ship_2:      Entity,
  projectiles: [64]Entity,
  asteroids:   [16]Entity,  
}

init_game :: proc(gm: ^Game)
{
  mem.init_growing_arena(&game_frame_arena)

  gm.ship_1 = Entity{
    kind = .SHIP,
    active = true,
    dim = {70, 70},
    color = {0, 0, 1, 1},
  }

  gm.ship_2 = Entity{
    kind = .SHIP,
    active = true,
    pos = {WINDOW_WIDTH - 70, 0},
    dim = {70, 70},
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

update_game :: proc(gm: ^Game, dt: f32)
{
  if plf.key_pressed(.ESCAPE)
  {
    user.window.should_close = true
  }

  SPEED :: 500

  if plf.key_pressed(.D) && !plf.key_pressed(.A)
  {
    gm.ship_1.vel.x = SPEED
  }

  if plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    gm.ship_1.vel.x = -SPEED
  }

  if plf.key_pressed(.W) && !plf.key_pressed(.S)
  {
    gm.ship_1.vel.y = -SPEED
  }

  if plf.key_pressed(.S) && !plf.key_pressed(.W)
  {
    gm.ship_1.vel.y = SPEED
  }

  if !plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    gm.ship_1.vel.x = 0
  }

  if !plf.key_pressed(.W) && !plf.key_pressed(.S)
  {
    gm.ship_1.vel.y = 0
  }

  gm.ship_1.pos += gm.ship_1.vel * dt
  gm.ship_2.pos += {-50, 50} * dt

  // - Save and load game ---
  {
    SAVE_PATH :: "res/saves/main"

    if plf.key_just_pressed(.K) && plf.key_pressed(.LEFT_CTRL)
    {
      save_file, open_err := os.open(SAVE_PATH, os.O_CREATE | os.O_TRUNC | os.O_RDWR, 0o644)
      defer os.close(save_file)
      if open_err == nil
      {
        save_game_to_file(save_file, gm)
      }
      else
      {
        fmt.eprintln("Error opening file for saving!", open_err)
      }
    }

    if plf.key_just_pressed(.L) && plf.key_pressed(.LEFT_CTRL)
    {
      save_file, open_err := os.open(SAVE_PATH, os.O_RDWR)
      defer os.close(save_file)
      if open_err == nil
      {
        load_game_from_file(save_file, gm)
      }
      else
      {
        fmt.eprintln("Error opening file for loading!", open_err)
      }
    }
  }

  mem.clear_arena(&game_frame_arena)
}

render_game :: proc(gm: ^Game)
{
  r.gl_clear()

  draw_rect(gm.ship_1.pos, gm.ship_1.dim, gm.ship_1.color)
  draw_rect(gm.ship_2.pos, gm.ship_2.dim, gm.ship_2.color)
  draw_rect({WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50}, {100, 100}, {0, 1, 0, 1})
  draw_tri({100, 100}, {100, 150}, {1, 1, 0, 1})

  r.gl_flush()
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  copy_game(res_gm, curr_gm)
  res_gm.ship_1.pos = (curr_gm.ship_1.pos * alpha) + (prev_gm.ship_1.pos * (1 - alpha))
  res_gm.ship_2.pos = (curr_gm.ship_2.pos * alpha) + (prev_gm.ship_2.pos * (1 - alpha))
}

free_game :: proc(gm: ^Game)
{
  mem.destroy_arena(&game_frame_arena)
}

copy_game :: proc(new_gm, old_gm: ^Game)
{
  new_gm^ = old_gm^
}

// NOTE(dg): This is a naive approach that assumes too much about Game
save_game_to_file :: proc(fd: os.Handle, gm: ^Game) -> bool
{
  buf := transmute([]byte) runtime.Raw_Slice{gm, size_of(Game)}
  _, write_err := os.write(fd, buf)
  if write_err != nil
  {
    fmt.eprintln("Error saving game to disk.", write_err)
    return false
  }

  fmt.println("Saved game to disk.")

  return true
}

// NOTE(dg): This is a naive approach that assumes too much about Game
load_game_from_file :: proc(fd: os.Handle, gm: ^Game) -> bool
{
  saved_buf: [size_of(Game)*2]byte
  saved_len, _ := os.read(fd, saved_buf[:])
  gm_bytes := saved_buf[:saved_len]

  ok: bool
  gm^, ok = slice.to_type(gm_bytes, Game)
  if !ok
  {
    fmt.eprintln("Failed to get Game from bytes!")
    return false
  }

  fmt.println("Loaded game from disk.")

  return true
}

// Entity ////////////////////////////////////////////////////////////////////////////////

Entity :: struct
{
  kind:   Entity_Kind,
  active: bool,
  pos:    v2f,
  vel:    v2f,
  dim:    v2f,
  color:  v4f,
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
