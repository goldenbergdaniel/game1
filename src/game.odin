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
  t:        f32,
  entities: [1024]Entity,
}

init_game :: proc(gm: ^Game)
{
  mem.init_growing_arena(&game_frame_arena)

  gm.entities[0] = Entity{
    props = {.WRAP_AT_WINDOW_EDGES},
    active = true,
    rot = math.PI,
    dim = {50, 50},
    tint = {1, 1, 1, 1},
    color = {0, 0, 0, 0},
    sprite = .SHIP_1,
  }

  gm.entities[1] = Entity{
    props = {.WRAP_AT_WINDOW_EDGES},
    active = true,
    pos = {WINDOW_WIDTH - 70, 0},
    dim = {50, 50},
    tint = {1, 0, 0, 1},
    color = {0, 0, 0, 0},
    sprite = .SHIP_1,
  }

  gm.entities[2].active = true
  gm.entities[2].pos = {WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50}
  gm.entities[2].dim = { 70, 70}
  gm.entities[2].sprite = .ASTEROID
  gm.entities[2].tint = {0.57, 0.53, 0.49, 1}
}

update_game :: proc(gm: ^Game, dt: f32)
{
  player := &gm.entities[0]
  window_size := plf.window_size(&user.window)

  if plf.key_pressed(.ESCAPE)
  {
    user.window.should_close = true
  }

  for &en in gm.entities
  {
    en.interpolate = true
  }

  gm.entities[1].tint = v4f{abs(math.sin(gm.t * dt * 40)), 0, 0, 1}

  color := abs(math.sin(gm.t * dt * 40))
  gm.entities[2].rot = gm.t * dt * 5 * math.PI

  if !plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    entity_look_at_point(player, plf.cursor_pos())
  }
  
  entity_look_at_point(&gm.entities[1], player.pos)

  SPEED :: 600.0
  ACC   :: 400.0
  DRAG  :: 1.5

  if plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    player.rot += -2 * dt
  }

  if plf.key_pressed(.D) && !plf.key_pressed(.A)
  {
    player.rot += 2 * dt
  }

  if plf.key_pressed(.W) && !plf.key_pressed(.S)
  {
    acc: f32 = plf.key_pressed(.SPACE) ? ACC*2 : ACC

    player.vel.x += math.cos(player.rot - math.PI/2) * acc * dt
    player.vel.x = clamp(player.vel.x, -SPEED, SPEED)

    player.vel.y += math.sin(player.rot - math.PI/2) * acc * dt
    player.vel.y = clamp(player.vel.y, -SPEED, SPEED)
  }

  if !plf.key_pressed(.W)
  {
    drag: f32 = plf.key_pressed(.S) ? DRAG*2 : DRAG

    player.vel.x = math.lerp(player.vel.x, 0, drag * dt)
    player.vel.x = to_zero(player.vel.x, 1)

    player.vel.y = math.lerp(player.vel.y, 0, drag * dt)
    player.vel.y = to_zero(player.vel.y, 1)
  }

  player.pos += player.vel * dt

  gm.entities[1].pos += v2f{-50, 50} * dt

  // - Entity wrap at window edges ---
  for &en in gm.entities
  {
    if !en.active do continue
    if .WRAP_AT_WINDOW_EDGES not_in en.props do continue

    if i32(en.pos.x) > window_size.x
    {
      en.pos.x = -en.dim.x
      en.interpolate = false
    }
    else if i32(en.pos.x + en.dim.x) < 0
    {
      en.pos.x = cast(f32) window_size.x
      en.interpolate = false
    }

    if i32(en.pos.y) > window_size.y
    {
      en.pos.y = -en.dim.x
      en.interpolate = false
    }
    else if i32(en.pos.y + en.dim.y) < 0
    {
      en.pos.y = cast(f32) window_size.y
      en.interpolate = false
    }
  }

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

  for &en in gm.entities
  {
    if !en.active do continue

    draw_rect(pos=en.pos, 
              dim=en.dim,
              rot=en.rot, 
              tint=en.tint,
              color=en.color, 
              sprite=en.sprite)
  }

  end_draw()
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  copy_game(res_gm, curr_gm)

  for i in 0..<len(res_gm.entities)
  {
    curr_en := &curr_gm.entities[i]
    prev_en := &prev_gm.entities[i]
    
    if !curr_en.active || !prev_en.active do continue
    if !curr_en.interpolate || !prev_en.interpolate do continue
    
    res_gm.entities[i].pos = (curr_en.pos * alpha) + (prev_en.pos * (1 - alpha))
    res_gm.entities[i].rot = math.angle_lerp(prev_en.rot, curr_en.rot, alpha)
  }
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
  gm_bytes := transmute([]byte) runtime.Raw_Slice{gm, size_of(Game)}
  _, write_err := os.write(fd, gm_bytes)
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
  props:       bit_set[Entity_Prop],
  active:      bool,
  pos:         v2f,
  vel:         v2f,
  dim:         v2f,
  rot:         f32,
  input_dir:   v2f,
  tint:        v4f,
  color:       v4f,
  sprite:      Sprite_ID,
  interpolate: bool,
}

Entity_Prop :: enum u64
{
  WRAP_AT_WINDOW_EDGES,
}

entity_look_at_point :: proc(en: ^Entity, target: v2f)
{
  dd := target - (en.pos + (res.sprites[en.sprite].pivot * en.dim))
  en.rot = math.atan2(dd.y, dd.x) + math.PI/2
}
