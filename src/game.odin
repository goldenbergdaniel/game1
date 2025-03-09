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

@(thread_local, private="file")
game_frame_arena: mem.Arena

Game :: struct
{
  t:        f32,
  entities: [1024+1]Entity,
}

sp_entities: [enum{
  PLAYER,
}]^Entity

init_game :: proc(gm: ^Game)
{
  // NOTE(dg): What if multiple games running on same thread? This needs to change. 
  mem.init_growing_arena(&game_frame_arena)

  player := alloc_entity(gm)
  player.flags = {.ACTIVE}
  player.props = {.WRAP_AT_WINDOW_EDGES}
  player.dim = {30, 30}
  player.tint = {1, 1, 1, 1}
  player.color = {0, 0, 0, 0}
  player.sprite = .SHIP
  player.z_layer = .PLAYER

  enemy := alloc_entity(gm)
  enemy.flags = {.ACTIVE}
  enemy.props = {.WRAP_AT_WINDOW_EDGES}
  enemy.pos = {WINDOW_WIDTH - 70, 0}
  enemy.dim = {30, 30}
  enemy.tint = {1, 0, 0, 1}
  enemy.color = {0, 0, 0, 0}
  enemy.sprite = .ALIEN
  enemy.z_layer = .ENEMY

  asteroid := alloc_entity(gm)
  asteroid.flags = {.ACTIVE}
  asteroid.pos = {WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50}
  asteroid.dim = {60, 60}
  asteroid.tint = {0.57, 0.53, 0.49, 1}
  asteroid.sprite = .ASTEROID_BIG
  asteroid.z_layer = .DECORATION

  sp_entities[.PLAYER] = player
}

update_game :: proc(gm: ^Game, dt: f32)
{
  player := sp_entities[.PLAYER]
  window_size := plf.window_size(&user.window)

  if plf.key_pressed(.ESCAPE)
  {
    user.window.should_close = true
  }

  for &en in gm.entities
  {
    if en.idx == 0 do continue

    en.flags += {.INTERPOLATE}

    if .MARKED_FOR_DEATH in en.flags
    {
      free_entity(gm, &en)
    }
  }

  gm.entities[2].tint = v4f{abs(math.sin(gm.t * dt * 40)), 0, 0, 1}

  color := abs(math.sin(gm.t * dt * 40))
  gm.entities[3].rot = gm.t * dt * 5 * math.PI

  if !plf.key_pressed(.A) && !plf.key_pressed(.D)
  {
    entity_look_at_point(player, screen_to_world_pos(plf.cursor_pos()))
  }
  
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

    player.vel.x += math.cos(player.rot) * acc * dt
    player.vel.x = clamp(player.vel.x, -SPEED, SPEED)

    player.vel.y += math.sin(player.rot) * acc * dt
    player.vel.y = clamp(player.vel.y, -SPEED, SPEED)
  }

  if !plf.key_pressed(.W)
  {
    drag: f32 = plf.key_pressed(.S) ? DRAG*2 : DRAG

    player.vel.x = math.lerp(player.vel.x, 0, drag * dt)
    player.vel.x = approx(player.vel.x, 0, 1)

    player.vel.y = math.lerp(player.vel.y, 0, drag * dt)
    player.vel.y = approx(player.vel.y, 0, 1)
  }

  player.pos += player.vel * dt

  gm.entities[2].pos += v2f{-50, 50} * dt

  for &en in gm.entities
  {
    if .ACTIVE not_in en.flags do continue
    
    // - Entity wrap at window edges ---
    if .WRAP_AT_WINDOW_EDGES in en.props
    {
      window_in_world_space := v2f{WINDOW_WIDTH, WINDOW_HEIGHT}

      if en.pos.x > window_in_world_space.x
      {
        en.pos.x = -en.dim.x
        en.flags -= {.INTERPOLATE}
      }
      else if en.pos.x + en.dim.x < 0
      {
        en.pos.x = window_in_world_space.x
        en.flags -= {.INTERPOLATE}
      }

      if en.pos.y > window_in_world_space.y
      {
        en.pos.y = -en.dim.y
        en.flags -= {.INTERPOLATE}
      }
      else if en.pos.y + en.dim.y < 0
      {
        en.pos.y = window_in_world_space.y
        en.flags -= {.INTERPOLATE}
      }
    }

    if .LOOK_AT_TARGET in en.props
    {
      entity_look_at_point(&en, player.pos)
    }
  }

  // println(player.rot)

  // - Save and load game ---
  when false
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
  targets: [len(gm.entities)]^Entity
  for i in 0..<len(gm.entities)
  {
    targets[i] = &gm.entities[i]
  }

  slice.stable_sort_by(targets[:], proc(i, j: ^Entity) -> bool {
    if i.z_layer == j.z_layer
    {
      return i.z_index < j.z_index
    }
    else
    {
      return i.z_layer < j.z_layer
    }
  })

  begin_draw({0.07, 0.07, 0.07, 1})

  for &en in targets
  {
    if .ACTIVE not_in en.flags do continue

    draw_rect(en.pos, en.dim, en.rot, en.tint, en.color, en.sprite)
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

    if !entity_has_flags(curr_en, {.ACTIVE, .INTERPOLATE}) ||
       !entity_has_flags(prev_en, {.ACTIVE, .INTERPOLATE})
    {
      continue
    }
      
    res_gm.entities[i].pos = (curr_en.pos * alpha) + (prev_en.pos * (1 - alpha))
    res_gm.entities[i].rot = math.angle_lerp(prev_en.rot, curr_en.rot, alpha)
    
    // if i == 0 do fmt.printfln("%f = %f <> %f", 
    //                           res_gm.entities[i].rot, prev_en.rot, curr_en.rot)
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

// NOTE(dg): This assumes that Game is contiguous and stores no pointers.
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

// NOTE(dg): This assumes that Game is contiguous and stores no pointers.
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

screen_to_world_pos :: proc(pos: v2f) -> v2f
{
  return {
    (pos.x - user.viewport.x) * (WINDOW_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (WINDOW_HEIGHT / user.viewport.w),
  }
}

// Entity ////////////////////////////////////////////////////////////////////////////////

Entity :: struct
{
  idx:       u32,
  gen:       u32,
  flags:     bit_set[Entity_Flag],
  props:     bit_set[Entity_Prop],
  pos:       v2f,
  vel:       v2f,
  dim:       v2f,
  rot:       f32,
  input_dir: v2f,
  tint:      v4f,
  color:     v4f,
  sprite:    Sprite_ID,
  z_index:   i16,
  z_layer:   enum u8
  {
    NIL,
    DECORATION,
    ENEMY,
    PLAYER,
    PROJECTILE,
  },
}

Entity_Ref :: struct
{
  idx: u32,
  gen: u32,
}

Entity_Flag :: enum u32
{
  ACTIVE,
  MARKED_FOR_DEATH,
  INTERPOLATE,
}

Entity_Prop :: enum u64
{
  WRAP_AT_WINDOW_EDGES,
  LOOK_AT_TARGET,
}

@(rodata)
NIL_ENTITY: Entity

entity_from_ref :: #force_inline proc(gm: ^Game, ref: Entity_Ref) -> ^Entity
{
  return ref.idx == 0 ? &NIL_ENTITY : &gm.entities[ref.idx]
}

ref_from_entity :: #force_inline proc(en: ^Entity) -> Entity_Ref
{
  return {en.idx, en.gen}
}

alloc_entity :: proc(gm: ^Game) -> ^Entity
{
  result: ^Entity = &NIL_ENTITY

  for &en, i in gm.entities[1:]
  {
    if en.idx == 0
    {
      en.idx = cast(u32) i + 1
      en.gen += 1
      result = &en
      break
    }
  }

  return result
}

free_entity :: proc(gm: ^Game, en: ^Entity)
{
  assert(en != nil)

  gen := en.gen
  en^ = {}
  en.gen = gen
}

kill_entity :: proc(en: ^Entity)
{
  en.flags -= {.ACTIVE}
  en.flags += {.MARKED_FOR_DEATH}
}

entity_has_flags :: #force_inline proc(en: ^Entity, flags: bit_set[Entity_Flag]) -> bool
{
  return en.flags & flags == flags
}

entity_has_props :: #force_inline proc(en: ^Entity, props: bit_set[Entity_Prop]) -> bool
{
  return en.props & props == props
}

entity_look_at_point :: proc(en: ^Entity, target: v2f)
{
  dd := target - (en.pos + (res.sprites[en.sprite].pivot * en.dim))
  en.rot = math.atan2(dd.y, dd.x)
  if en.rot < 0 do en.rot += math.PI * 2
}
