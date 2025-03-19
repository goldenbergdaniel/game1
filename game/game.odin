package game

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"

import plf "src:platform"
import r "src:render"
import vm "src:vecmath"
import "ext:basic/mem"

// Game //////////////////////////////////////////////////////////////////////////////////

@(thread_local, private="file")
global_game_frame_arena: mem.Arena
global_debug: bool

Game :: struct
{
  t:                  f32,
  t_mult:             f32,
  entities:           [128+1]Entity,
  entities_cnt:       int,
  debug_entities:     [128]Debug_Entity,
  debug_entities_pos: int,
}

@(thread_local, private="file")
_current_game: ^Game

get_current_game :: #force_inline proc() -> ^Game
{
  return _current_game
}

set_current_game :: #force_inline proc(gm: ^Game)
{
  _current_game = gm
}

sp_entities: [enum{
  PLAYER,
}]^Entity

init_game :: proc(gm: ^Game)
{
  // NOTE(dg): What if multiple games running on same thread? This needs to change. 
  mem.init_growing_arena(&global_game_frame_arena)

  gm.t_mult = 1

  player := alloc_entity(gm)
  player.flags = {.ACTIVE}
  player.props = {.WRAP_AT_WORLD_EDGES}
  player.dim = {32, 32}
  player.tint = {1, 1, 1, 1}
  player.color = {0, 0, 0, 0}
  player.sprite = .SHIP
  player.z_layer = .PLAYER
  player.collider.kind = .POLYGON

  enemy := alloc_entity(gm)
  enemy.flags = {.ACTIVE}
  enemy.props = {.WRAP_AT_WORLD_EDGES}
  enemy.pos = {WORLD_WIDTH - 70, 0}
  enemy.dim = {32, 32}
  enemy.tint = {1, 0, 0, 1}
  enemy.color = {0, 0, 0, 0}
  enemy.sprite = .ALIEN
  enemy.z_layer = .ENEMY
  enemy.col_layer = .ENEMY
  enemy.collider.kind = .POLYGON

  asteroid := alloc_entity(gm)
  asteroid.flags = {.ACTIVE}
  asteroid.pos = {WORLD_WIDTH/2, WORLD_HEIGHT/2}
  asteroid.dim = {64, 64}
  asteroid.tint = {0.57, 0.53, 0.49, 1}
  asteroid.sprite = .ASTEROID_BIG
  asteroid.z_layer = .DECORATION
  
  sp_entities[.PLAYER] = player
}

update_game :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)
  
  player := sp_entities[.PLAYER]
  window_size := plf.window_size(&user.window)
  cursor_pos := screen_to_world_pos(plf.cursor_pos())

  for &en in gm.entities
  {
    if en.idx == 0 do continue

    en.flags += {.INTERPOLATE}

    if .MARKED_FOR_DEATH in en.flags
    {
      free_entity(gm, &en)
    }
  }

  for &den in gm.debug_entities
  {
    if .MARKED_FOR_DEATH in den.flags
    {
      pop_debug_entity(&den)
    }
  }

  // - Global keybinds ---
  {
    if plf.key_pressed(.ESCAPE)
    {
      user.window.should_close = true
    }

    if plf.key_just_pressed(.ENTER) && plf.key_pressed(.LEFT_CTRL)
    {
      plf.window_toggle_fullscreen(&user.window)
    }

    if plf.key_just_pressed(.BACKSPACE)
    {
      global_debug = !global_debug
      println("Set debug render to", global_debug)
    }

    if plf.key_just_pressed(.S1) && plf.key_pressed(.LEFT_CTRL)
    {
      gm.t_mult = 1
      println("Set time multiplier to", 1.0)
    }

    if plf.key_just_pressed(.S2) && plf.key_pressed(.LEFT_CTRL)
    {
      gm.t_mult = 0.5
      println("Set time multiplier to", 0.5)
    }

    if plf.key_just_pressed(.S3) && plf.key_pressed(.LEFT_CTRL)
    {
      gm.t_mult = 0.25
      println("Set time multiplier to", 0.25)
    }

    if plf.key_just_pressed(.S4) && plf.key_pressed(.LEFT_CTRL)
    {
      gm.t_mult = 2
      println("Set time multiplier to", 2.0)
    }
  }

  // if gm.entities[2].gen == 0
  // {
  //   gm.entities[2].tint = v4f{abs(math.sin(gm.t * dt * 40)), 0, 0, 1}
  // }

  color := abs(math.sin(gm.t * dt * 40))
  gm.entities[3].rot += 2 * math.PI * dt
  
  // - Player movement ---
  {
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

    if !plf.key_pressed(.A) && !plf.key_pressed(.D)
    {
      entity_look_at_point(player, cursor_pos)
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
  }

  // - Player attack ---
  {
    if !player.attack_timer.ticking
    {
      timer_start(&player.attack_timer, 0.1)
    }

    if plf.mouse_btn_pressed(.LEFT) && timer_timeout(&player.attack_timer)
    {
      player.attack_timer.ticking = false

      proj := spawn_entity_weapon(player.pos + player.vel * dt)
      proj.vel = {math.cos(player.rot), math.sin(player.rot)} * 500
    }
  }

  if gm.entities[2].gen == 0
  {
    gm.entities[2].vel = {-50, 50}
  }

  for &en in gm.entities
  {
    if .ACTIVE not_in en.flags do continue
    
    en.pos += en.vel * dt
  }

  // - Update colliders ---
  for &en in gm.entities
  {
    if .ACTIVE not_in en.flags || en.collider.kind == .NIL do continue

    update_entity_collider(&en)
  }

  // - Collision detection ---
  for &en_a in gm.entities
  {
    if .ACTIVE not_in en_a.flags do continue

    for &en_b in gm.entities 
    {
      if .ACTIVE not_in en_b.flags ||
         en_a.idx == en_b.idx ||
         en_b.col_layer not_in COLLISION_MATRIX[en_a.col_layer]
      {
        continue
      }

      if entity_collision(&en_a, &en_b)
      {
        if en_a.weapon_kind != .NIL || en_a.weapon_kind != .NIL
        {
          kill_entity(&en_a)
          kill_entity(&en_b)
        }
      }
    }
  }

  for &en in gm.entities
  {
    if .ACTIVE not_in en.flags do continue
    
    // - Entity wrap at window edges ---
    if .WRAP_AT_WORLD_EDGES in en.props
    {
      if en.pos.x > WORLD_WIDTH
      {
        en.pos.x = -en.dim.x
        en.flags -= {.INTERPOLATE}
      }
      else if en.pos.x + en.dim.x < 0
      {
        en.pos.x = WORLD_WIDTH
        en.flags -= {.INTERPOLATE}
      }

      if en.pos.y > WORLD_HEIGHT
      {
        en.pos.y = -en.dim.y
        en.flags -= {.INTERPOLATE}
      }
      else if en.pos.y + en.dim.y < 0
      {
        en.pos.y = WORLD_HEIGHT
        en.flags -= {.INTERPOLATE}
      }
    }

    if .LOOK_AT_TARGET in en.props
    {
      entity_look_at_point(&en, player.pos)
    }

    if .KILL_AFTER_TIME in en.props
    {
      if !en.death_timer.ticking
      {
        timer_start(&en.death_timer, 2.0)
      }

      if timer_timeout(&en.death_timer)
      {
        kill_entity(&en)
      }
    }
  }

  // - Save and load game ---
  when true
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

  mem.clear_arena(&global_game_frame_arena)
}

render_game :: proc(gm: ^Game, dt: f32)
{
  en_targets: [len(gm.entities)]^Entity
  for i in 0..<len(gm.entities)
  {
    en_targets[i] = &gm.entities[i]
  }

  slice.stable_sort_by(en_targets[:], proc(i, j: ^Entity) -> bool {
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

  for en in en_targets
  {
    if .ACTIVE not_in en.flags do continue

    draw_rect(en.pos, en.dim, en.rot, en.tint, en.color, en.sprite)
  }

  if global_debug
  {
    for den in gm.debug_entities
    {
      if .ACTIVE not_in den.flags do continue

      draw_rect(den.pos, den.dim, den.rot, den.tint, den.color, den.sprite)
    }
  }

  end_draw()
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  copy_game(res_gm, curr_gm)

  // - Interpolate entities ---
  for i in 0..<len(res_gm.entities)
  {
    curr_en := &curr_gm.entities[i]
    prev_en := &prev_gm.entities[i]

    if !entity_has_flags(curr_en, {.ACTIVE, .INTERPOLATE}) ||
       !entity_has_flags(prev_en, {.ACTIVE, .INTERPOLATE})
    {
      continue
    }
    
    res_gm.entities[i].pos = vm.lerp(prev_en.pos, curr_en.pos, alpha)
    res_gm.entities[i].rot = vm.lerp_angle(prev_en.rot, curr_en.rot, alpha)
    // println("  Odin:", math.angle_lerp(prev_en.rot, curr_en.rot, alpha))
    // println("    AI:", vm.lerp_angle(prev_en.rot, curr_en.rot, alpha))
    // println("Inputs:", prev_en.rot, curr_en.rot)
    // println()
  }

  // - Interpolate debug entities ---
  if global_debug
  {
    for i in 0..<len(res_gm.debug_entities)
    {
      curr_den := &curr_gm.debug_entities[i]
      prev_den := &prev_gm.debug_entities[i]

      if !entity_has_flags(curr_den, {.ACTIVE, .INTERPOLATE}) ||
         !entity_has_flags(prev_den, {.ACTIVE, .INTERPOLATE})
      {
        continue
      }

      res_gm.debug_entities[i].pos = vm.lerp(prev_den.pos, curr_den.pos, alpha)
      res_gm.debug_entities[i].rot = vm.lerp_angle(prev_den.rot, curr_den.rot, alpha)
    }
  }
}

free_game :: proc(gm: ^Game)
{
  mem.destroy_arena(&global_game_frame_arena)
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
    (pos.x - user.viewport.x) * (WORLD_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (WORLD_HEIGHT / user.viewport.w),
  }
}

// Entity ////////////////////////////////////////////////////////////////////////////////

Entity :: struct
{
  idx:          u32,
  gen:          u32,
  flags:        bit_set[Entity_Flag],
  props:        bit_set[Entity_Prop],
  pos:          v2f,
  vel:          v2f,
  dim:          v2f,
  radius:       f32,
  rot:          f32,
  input_dir:    v2f,
  tint:         v4f,
  color:        v4f,
  sprite:       Sprite_ID,
  collider:     Collider,
  col_layer:    enum u32 {PLAYER, ENEMY},
  z_index:      i16,
  z_layer:      enum u32 {NIL, DECORATION, ENEMY, PLAYER, PROJECTILE},
  weapon_kind:  Weapon_Kind,
  attack_timer: Timer,
  death_timer:  Timer,
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
  WRAP_AT_WORLD_EDGES,
  LOOK_AT_TARGET,
  KILL_AFTER_TIME,
}

Weapon_Kind :: enum
{
  NIL,
  LASER,
}

@(rodata)
NIL_ENTITY: Entity

@(rodata)
COLLISION_MATRIX: [type_of(Entity{}.col_layer)]bit_set[type_of(Entity{}.col_layer)] = {
  .PLAYER = {.ENEMY},
  .ENEMY = {.PLAYER},
}

entity_from_ref :: #force_inline proc(ref: Entity_Ref) -> ^Entity
{
  gm := get_current_game()
  return ref.idx == 0 ? &NIL_ENTITY : &gm.entities[ref.idx]
}

ref_from_entity :: #force_inline proc(en: ^Entity) -> Entity_Ref
{
  return {en.idx, en.gen}
}

alloc_entity :: proc(gm: ^Game) -> ^Entity
{
  assert(gm.entities_cnt < len(gm.entities)-1)

  result: ^Entity = &NIL_ENTITY

  for &en, i in gm.entities[1:]
  {
    if en.idx == 0
    {
      en.idx = cast(u32) i + 1
      result = &en
      
      gm.entities_cnt += 1
      break
    }
  }

  return result
}

free_entity :: proc(gm: ^Game, en: ^Entity)
{
  assert(en != nil && en.idx != 0)

  gen := en.gen
  en^ = {}
  en.gen = gen + 1

  gm.entities_cnt -= 1
}

spawn_entity_weapon :: proc(pos: v2f) -> ^Entity
{
  gm := get_current_game()

  en := alloc_entity(gm)
  en.flags = {.ACTIVE, .INTERPOLATE}
  en.props = {.KILL_AFTER_TIME}
  en.pos = pos
  en.dim = {30, 30}
  en.tint = {0.18, 0.88, 0.18, 1}
  en.sprite = .PROJECTILE
  en.col_layer = .PLAYER
  en.collider.kind = .CIRCLE
  en.collider.radius = 4
  en.z_layer = .PROJECTILE
  en.weapon_kind = .LASER

  return en
}

kill_entity :: proc(en: ^Entity)
{
  en.flags -= {.ACTIVE}
  en.flags += {.MARKED_FOR_DEATH}
}

entity_has_flags :: #force_inline proc(en: ^$E/Entity, flags: bit_set[Entity_Flag]) -> bool
{
  return en.flags & flags == flags
}

entity_has_props :: #force_inline proc(en: ^$E/Entity, props: bit_set[Entity_Prop]) -> bool
{
  return en.props & props == props
}

entity_look_at_point :: proc(en: ^$E/Entity, target: v2f)
{
  dd := target - (en.pos + (res.sprites[en.sprite].pivot * en.dim))
  en.rot = math.atan2(dd.y, dd.x)
  if en.rot < 0
  {
    en.rot += math.TAU
  }
}

pos_tl_from_entity :: proc(en: ^Entity) -> v2f
{
  local_pos := vm.rotation_2x2f(en.rot) * v2f{-en.dim.x * 0.5, -en.dim.y * 0.5}
  return local_pos + en.pos
}

pos_tr_from_entity :: proc(en: ^Entity) -> v2f
{
  local_pos := vm.rotation_2x2f(en.rot) * v2f{+en.dim.x * 0.5, -en.dim.y * 0.5}
  return local_pos + en.pos
}

pos_br_from_entity :: proc(en: ^Entity) -> v2f
{
  local_pos := vm.rotation_2x2f(en.rot) * v2f{+en.dim.x * 0.5, +en.dim.y * 0.5}
  return local_pos + en.pos
}

pos_bl_from_entity :: proc(en: ^Entity) -> v2f
{
  local_pos := vm.rotation_2x2f(en.rot) * v2f{-en.dim.x * 0.5, +en.dim.y * 0.5}
  return local_pos + en.pos
}

entity_collider_vertex_pos :: proc(en: ^Entity, v: v2f) -> v2f
{
  local_pos := vm.rotation_2x2f(en.rot) * v * 2
  return pos_tl_from_entity(en) + local_pos
}

local_xform_from_entity :: proc(en: ^Entity) -> m3x3f
{
  result := vm.scale_3x3f({2, 2})
  result = vm.rotation_3x3f(en.rot) * result
  result = vm.translation_3x3f(pos_tl_from_entity(en)) * result
  return result
}

update_entity_collider :: proc(en: ^Entity)
{
  en.collider.vertices_cnt = cast(u8) collider_map[en.sprite].vertex_count
  for i in 0..<en.collider.vertices_cnt
  {
    v := local_xform_from_entity(en) * vm.v3f(collider_map[en.sprite].vertices[i], 1)
    en.collider.vertices[i] = v.xy
  }

  for vert in en.collider.vertices[:en.collider.vertices_cnt]
  {
    debug_circle(vert, 4, color={0, 1, 0, 0}, alpha=0.75)
  }
}

entity_collision :: proc(en_a, en_b: ^Entity) -> bool
{
  result: bool

  if en_a.collider.kind == .NIL || en_b.collider.kind == .NIL
  {
    result = false
  }
  else if en_a.collider.kind == .CIRCLE && en_b.collider.kind == .CIRCLE
  {
    result = circle_circle_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .POLYGON && en_b.collider.kind == .POLYGON
  { 
    result = polygon_polygon_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .CIRCLE && en_b.collider.kind == .POLYGON
  {
    en_a.collider.origin = en_a.pos

    result = circle_polygon_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .POLYGON && en_b.collider.kind == .CIRCLE
  {
    en_b.collider.origin = en_b.pos

    result = circle_polygon_overlap(&en_b.collider, &en_a.collider)
  }

  return result
}

// Debug_Entity //////////////////////////////////////////////////////////////////////////

Debug_Entity :: distinct Entity

push_debug_entity :: proc() -> ^Debug_Entity
{
  gm := get_current_game()

  result := &gm.debug_entities[gm.debug_entities_pos]
  result.flags += {.ACTIVE, .INTERPOLATE, .MARKED_FOR_DEATH}

  gm.debug_entities_pos += 1
  if gm.debug_entities_pos == len(gm.debug_entities)
  {
    gm.debug_entities_pos = 0
  }

  return result
}

pop_debug_entity :: proc(den: ^Debug_Entity)
{
  gm := get_current_game()
  den^ = {}
  gm.debug_entities_pos -= 1
}

debug_rect :: proc(
  pos:   v2f,
  dim:   v2f = {16, 16}, 
  color: v4f = {1, 1, 1, 1},
) -> ^Debug_Entity
{
  gm := get_current_game()

  result := push_debug_entity()
  result.pos = pos
  result.dim = dim
  result.color = color
  result.tint = {1, 1, 1, 1}
  result.sprite = .SQUARE

  return result
}

debug_circle :: proc(
  pos:    v2f,
  radius: f32, 
  color:  v4f = {0, 1, 0, 0},
  alpha:  f32 = 0.5,
) -> ^Debug_Entity
{
  gm := get_current_game()

  result := push_debug_entity()
  result.pos = pos
  result.dim = {radius, radius}
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = .CIRCLE

  return result
}

// Timer /////////////////////////////////////////////////////////////////////////////////

Timer :: struct
{
  duration: f32,
  end_time: f32,
  ticking:  bool,
}

timer_start :: proc(timer: ^Timer, duration: f32)
{
  gm := get_current_game()
  timer.end_time = gm.t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> bool
{
  gm := get_current_game()
  return timer.ticking && gm.t >= timer.end_time
}

timer_remaining :: proc(timer: ^Timer) -> f32
{
  gm := get_current_game()
  return timer.end_time - gm.t
}

// Collider //////////////////////////////////////////////////////////////////////////////

Collider :: struct
{
  origin:       v2f,
  radius:       f32,
  vertices:     [8]v2f,
  vertices_cnt: u8, 
  kind:         enum u8 {NIL, CIRCLE, POLYGON},
}

bounds_overlap :: #force_inline proc(a, b: [2]f32) -> bool
{
  return a[0] <= b[1] && a[1] >= b[0]
}

circle_circle_overlap :: proc(a, b: ^Collider) -> bool
{
  return vm.distance(a.origin, b.origin) <= a.radius + b.radius
}

polygon_polygon_overlap :: proc(a, b: ^Collider) -> bool
{
  // - Entity A ---
  for i in 0..<a.vertices_cnt
  {
    j := (i + 1) % a.vertices_cnt
    proj_axis := vm.normal(a.vertices[i], a.vertices[j])
    
    min_pa := max(f32); max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vm.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32); max_pb := min(f32)
    for k in 0..<b.vertices_cnt
    {
      p := vm.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    if !bounds_overlap({min_pa, max_pa}, {min_pb, max_pb}) do return false
  }

  // - Entity B ---
  for i in 0..<b.vertices_cnt
  {
    j := (i + 1) % b.vertices_cnt
    proj_axis := vm.normal(b.vertices[i], b.vertices[j])
    
    min_pa := max(f32); max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vm.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32); max_pb := min(f32)
    for k in 0..<b.vertices_cnt
    {
      p := vm.dot(b.vertices[k], proj_axis)
      min_pb = min(min_pb, p)
      max_pb = max(max_pb, p)
    }

    if !bounds_overlap({min_pa, max_pa}, {min_pb, max_pb}) do return false
  }

  return true
}

circle_polygon_overlap :: proc(circle, polygon: ^Collider) -> bool
{
  for i in 0..<polygon.vertices_cnt
  {
    j := (i + 1) % polygon.vertices_cnt
    vi := polygon.vertices[i]
    vj := polygon.vertices[j]

    // if vm.distance(vi, circle.origin) <= circle.radius do return true

    edge := vj - vi
    proj := vm.dot(circle.origin - vi, edge) / vm.magnitude_squared(edge)

    edge_point: v2f
    if proj <= 0
    {
      edge_point = vi
    }
    else if proj >= 1
    {
      edge_point = vj
    }
    else
    {
      edge_point = vi + edge * proj
    }
    
    dist_to_circle := vm.distance(edge_point, circle.origin)
    if dist_to_circle <= circle.radius do return true

    inside := point_in_polygon(circle.origin, polygon.vertices[:polygon.vertices_cnt])
    if inside do return true
  }

  return false
}

point_in_polygon :: proc(point: v2f, polygon: []v2f) -> bool
{
  inside: bool
  n := len(polygon)

  for i in 0..<n
  {
    j := (i + 1) % n
    vi := polygon[i]
    vj := polygon[j]

    // Check if point is between y-coordinates of edge and to the left of the edge
    if (vi.y > point.y) != (vj.y > point.y) &&
        point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x
    {
      inside = !inside
    }
  }

  return inside
}
