package game

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"

import "src:basic/mem"
import plf "src:platform"
import r "src:render"
import vm "src:vecmath"

// Game //////////////////////////////////////////////////////////////////////////////////

@(private="file")
game_frame_arena: mem.Arena

Game :: struct
{
  t:           f32,
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
    rot = math.PI,
    dim = {70, 70},
    tint = {1, 1, 1, 1},
    color = {0, 0, 0, 0},
    sprite = .SHIP_1,
  }

  gm.ship_2 = Entity{
    kind = .SHIP,
    active = true,
    pos = {WINDOW_WIDTH - 70, 0},
    dim = {70, 70},
    tint = {1, 0, 0, 1},
    color = {0, 0, 0, 0},
    sprite = .SHIP_1,
  }

  for &projectile in gm.projectiles
  {
    projectile = Entity{
      kind = .PROJECTILE,
    }
  }

  // for &asteroid in gm.asteroids
  // {
  //   asteroid = Entity{
  //     kind = .ASTEROID,
  //   }
  // }

  gm.asteroids[0].pos = {WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50}
  gm.asteroids[0].dim = { 70, 70}
  gm.asteroids[0].sprite = .ASTEROID
}

update_game :: proc(gm: ^Game, dt: f32)
{
  if plf.key_pressed(.ESCAPE)
  {
    user.window.should_close = true
  }

  gm.ship_2.tint = v4f{abs(math.sin(gm.t * dt * 40)), 0, 0, 1}

  color := abs(math.sin(gm.t * dt * 40))
  gm.asteroids[0].tint = v4f{color, color, color, 1}
  gm.asteroids[0].rot = gm.t * dt * 5 * math.PI

  // entity_look_at_point(&gm.ship_1, plf.cursor_pos())
  entity_look_at_point(&gm.ship_2, gm.ship_1.pos)

  SPEED :: 500
  ACC   :: 10
  FRIC  :: 5

  if plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    gm.ship_1.rot += -2 * dt
  }

  if plf.key_pressed(.D) && !plf.key_pressed(.A)
  {
    gm.ship_1.rot += 2 * dt
  }

  if plf.key_pressed(.W)
  {
    gm.ship_1.vel.x += math.cos(gm.ship_1.rot - math.PI/2) * ACC
    gm.ship_1.vel.y += math.sin(gm.ship_1.rot - math.PI/2) * ACC

    gm.ship_1.vel.x = clamp(gm.ship_1.vel.x, -SPEED, SPEED)
    gm.ship_1.vel.y = clamp(gm.ship_1.vel.y, -SPEED, SPEED)
  }

  if !plf.key_pressed(.W)
  {
    if gm.ship_1.vel.x > 0
    {
      gm.ship_1.vel.x -= FRIC
      gm.ship_1.vel.x = max(gm.ship_1.vel.x, 0)
    }
    else
    {
      gm.ship_1.vel.x += FRIC
      gm.ship_1.vel.x = min(gm.ship_1.vel.x, 0)
    }

    if gm.ship_1.vel.y > 0
    {
      gm.ship_1.vel.y -= FRIC
      gm.ship_1.vel.y = max(gm.ship_1.vel.y, 0)
    }
    else
    {
      gm.ship_1.vel.y += FRIC
      gm.ship_1.vel.y = min(gm.ship_1.vel.y, 0)
    }
  }

  // if gm.ship_1.input_dir.x != 0 || gm.ship_1.input_dir.y != 0
  // {
  //   gm.ship_1.input_dir = vm.normalize(gm.ship_1.input_dir)
  // }

  // // - X Acceleration ---
  // if gm.ship_1.input_dir.x != 0
  // {
  //   gm.ship_1.vel.x += ACC * dir(gm.ship_1.input_dir.x) * dt
  //   bound: f32 = SPEED * abs(gm.ship_1.input_dir.x) * dt
  //   gm.ship_1.vel.x = clamp(gm.ship_1.vel.x, -bound, bound)
  // }
  // else
  // {
  //   gm.ship_1.vel.x = math.lerp(gm.ship_1.vel.x, 0, FRIC * dt)
  //   gm.ship_1.vel.x = to_zero(gm.ship_1.vel.x, 0.1)
  // }

  // // - Y Acceleration ---
  // if gm.ship_1.input_dir.y != 0
  // {
  //   gm.ship_1.vel.y += ACC * dir(gm.ship_1.input_dir.y) * dt
  //   bound: f32 = SPEED * abs(gm.ship_1.input_dir.y) * dt
  //   gm.ship_1.vel.y = clamp(gm.ship_1.vel.y, -bound, bound)
  // }
  // else
  // {
  //   gm.ship_1.vel.y = math.lerp(gm.ship_1.vel.y, 0, FRIC * dt)
  //   bound: f32 = SPEED * abs(gm.ship_1.input_dir.y) * dt
  //   gm.ship_1.vel.y = to_zero(gm.ship_1.vel.y, 0.1)
  // }

  // gm.ship_1.vel = gm.ship_1.input_dir * SPEED
  gm.ship_1.pos += gm.ship_1.vel * dt

  gm.ship_2.pos += {-50, 50} * dt

  // - Save and load game ---
  {
    SAVE_PATH :: "res/saves/main"

    if plf.key_just_pressed(.K) && plf.key_pressed(.LEFT_CTRL)
    {
      file_flags := os.O_CREATE | os.O_TRUNC | os.O_RDWR
      save_file, open_err := os.open(SAVE_PATH, file_flags, 0o644)
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

render_game :: proc(gm: ^Game, dt: f32)
{
  begin_draw({0.07, 0.07, 0.07, 1})

  draw_rect(pos=gm.ship_1.pos, 
            dim=gm.ship_1.dim,
            rot=gm.ship_1.rot, 
            tint=gm.ship_1.tint,
            color=gm.ship_1.color, 
            sprite=gm.ship_1.sprite)

  draw_rect(pos=gm.ship_2.pos, 
            dim=gm.ship_2.dim, 
            rot=gm.ship_2.rot, 
            tint=gm.ship_2.tint,
            color=gm.ship_2.color, 
            sprite=gm.ship_2.sprite)

  draw_rect(pos=gm.asteroids[0].pos, 
            dim=gm.asteroids[0].dim, 
            rot=gm.asteroids[0].rot, 
            tint=gm.asteroids[0].tint,
            color=gm.asteroids[0].color, 
            sprite=gm.asteroids[0].sprite)

  end_draw()
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  copy_game(res_gm, curr_gm)
  res_gm.ship_1.pos = (curr_gm.ship_1.pos * alpha) + (prev_gm.ship_1.pos * (1 - alpha))
  // res_gm.ship_1.rot = (curr_gm.ship_1.rot * alpha) + (prev_gm.ship_1.rot * (1 - alpha))

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
  kind:      Entity_Kind,
  active:    bool,
  pos:       v2f,
  vel:       v2f,
  dim:       v2f,
  rot:       f32,
  input_dir: v2f,
  tint:      v4f,
  color:     v4f,
  sprite:    Sprite_ID,
}

Entity_Kind :: enum
{
  SHIP,
  PROJECTILE,
  ASTEROID,
}

entity_look_at_point :: proc(en: ^Entity, target: v2f)
{
  dd := target - (en.pos + (res.sprites[en.sprite].pivot * en.dim))
  en.rot = math.atan2(dd.y, dd.x) + math.PI/2
}
