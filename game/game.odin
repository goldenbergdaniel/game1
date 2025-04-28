package game

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:mem/tlsf"
import "core:math/rand"
import "core:os"
import "core:slice"
import "core:time"
import "ext:imgui"

import "basic/mem"

import plf "platform"
import r "render"
import vm "vecmath"

@(thread_local, private="file")
global: struct
{
  frame_arena:         mem.Arena,
  world_mem:           tlsf.Allocator,
  debug_mode:          bool,
  debug_target_entity: Entity_Ref,
}

@(thread_local, private="file")
special_entities: [enum{
  PLAYER,
}]^Entity

// Game //////////////////////////////////////////////////////////////////////////////////

Game :: struct
{
  t:                  f32,
  t_mult:             f32,
  entities:           [MAX_ENTITIES_COUNT]Entity,
  entities_cnt:       int,
  debug_entities:     [128]Debug_Entity,
  debug_entities_pos: int,
  regions:            [9][64*64]Tile,
  active_region:      int,
  particles:          [MAX_PARTICLES_COUNT]Particle,
  particles_pos:      int,
  enemy_to_spawn_idx: int,
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

init_game :: proc(gm: ^Game)
{
  set_current_game(gm)
  defer set_current_game(nil)

  // NOTE(dg): What if multiple games running on same thread? This needs to change. 
  _ = mem.init_growing_arena(&global.frame_arena)
  _ = tlsf.init_from_allocator(&global.world_mem, runtime.default_allocator(), mem.MIB * 16)

  gm.t_mult = 1

  player := alloc_entity(gm)
  setup_player(player)
  special_entities[.PLAYER] = player
}

update_game :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)
  
  player := special_entities[.PLAYER]
  window_size := plf.window_size(&user.window)
  cursor_pos := screen_to_world_pos(plf.cursor_pos())
  
  for &en in gm.entities
  {
    if en.ref == {} do continue

    en.props += {.INTERPOLATE}

    // - Kill entities
    if .MARKED_FOR_DEATH in en.props
    {
      free_entity(gm, &en)
    }
  }

  for &den in gm.debug_entities
  {
    if .MARKED_FOR_DEATH in den.props
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

    if plf.key_just_pressed(.TAB) && !plf.key_pressed(.L_CTRL)
    {
      user.show_imgui = !user.show_imgui
    }

    if plf.key_pressed(.L_CTRL)
    {
      if plf.key_just_pressed(.ENTER)
      {
        plf.window_toggle_fullscreen(&user.window)
      }
      else if plf.key_just_pressed(.BACKTICK)
      {
        global.debug_mode = !global.debug_mode
      }
      else if plf.key_just_pressed(.S_1)
      {
        gm.t_mult = 1
      }
      else if plf.key_just_pressed(.S_2)
      {
        gm.t_mult = 0
      }
      else if plf.key_just_pressed(.S_3)
      {
        gm.t_mult = 0.25
      }
      else if plf.key_just_pressed(.S_4)
      {
        gm.t_mult = 0.5
      }
      else if plf.key_just_pressed(.S_5)
      {
        gm.t_mult = 2
      }
    }
  }

  // - Player movement ---
  {
    ACC  :: 250.0
    DRAG :: 1.25

    player.vel = {}

    if plf.key_pressed(.A) && !plf.key_pressed(.D)
    {
      player.vel.x = -player.movement_speed
    }

    if plf.key_pressed(.D) && !plf.key_pressed(.A)
    {
      player.vel.x = player.movement_speed;
    }

    if plf.key_pressed(.W) && !plf.key_pressed(.S)
    {
      player.vel.y = -player.movement_speed;
    }

    if plf.key_pressed(.S) && !plf.key_pressed(.W)
    {
      player.vel.y = player.movement_speed;
    }

    if player.vel.x != 0 && player.vel.y != 0
    {
      player.vel = vm.normalize(player.vel) * player.movement_speed
    }

    player.pos += player.vel * dt
  }

  // NOTE(dg): temporary!
  {
    shadow := entity_from_ref(player.children[0])
    shadow.pos = player.pos
  }

  // - Enemy movement ---
  for &en in gm.entities
  {
    if .ACTIVE not_in en.props || en.enemy_kind == .NIL do continue

    ACC  :: 400.0
    DRAG :: 3

    if .FOLLOW_ENTITY in en.props
    {
      target := entity_from_ref(en.targetting.target_en)
      dir := vm.normalize(target.pos - en.pos)

      dist_to_target := vm.abs(en.pos - target.pos)

      if dist_to_target.x >= en.targetting.min_dist && 
         dist_to_target.x <= en.targetting.max_dist
      {
        en.vel.x += dir.x * ACC * dt
        en.vel.x = clamp(en.vel.x, -en.movement_speed, en.movement_speed)
      }
      else
      {
        en.vel.x = math.lerp(en.vel.x, 0, DRAG * dt)
        en.vel.x = approx(en.vel.x, 0, 1)
      }

      if dist_to_target.y >= en.targetting.min_dist && 
         dist_to_target.y <= en.targetting.max_dist
      {
        en.vel.y += dir.y * ACC * dt
        en.vel.y = clamp(en.vel.y, -en.movement_speed, en.movement_speed)
      }
      else
      {
        en.vel.y = math.lerp(en.vel.y, 0, DRAG * dt)
        en.vel.y = approx(en.vel.y, 0, 1)
      }
    }

    en.pos += en.vel * dt
  }

  // - Player attack ---
  {
    if !player.attack_timer.ticking
    {
      timer_start(&player.attack_timer, 0.2)
    }

    if plf.mouse_btn_pressed(.LEFT) && timer_timeout(&player.attack_timer)
    {
      player.attack_timer.ticking = false

      proj := spawn_projectile(.BULLET)
      proj.pos = player.pos + player.vel * dt
      proj.vel = 500
      proj.rot = player.rot
    }
  }

  // - Update colliders ---
  for &en in gm.entities
  {
    if .ACTIVE not_in en.props || en.collider.kind == .NIL do continue
    update_entity_collider(&en)
  }

  // - Collision detection ---
  for &en_a in gm.entities
  {
    if .ACTIVE not_in en_a.props do continue

    for &en_b in gm.entities 
    {
      if .ACTIVE not_in en_b.props ||
         en_a.ref.idx == en_b.ref.idx ||
         en_b.col_layer not_in COLLISION_MATRIX[en_a.col_layer]
      {
        continue
      }

      if entity_collision(&en_a, &en_b) && !get_entities_collided_cache(en_a.ref, en_b.ref)
      {
        set_entities_collided_cache(en_a.ref, en_b.ref)

        if en_a.projectile_kind != .NIL || en_b.projectile_kind != .NIL
        {
          kill_entity(&en_a)
          kill_entity(&en_b)
        }
      }
    }

    if point_in_polygon(cursor_pos, en_a.collider.vertices[:])
    {
      if plf.mouse_btn_just_pressed(.RIGHT)
      {
        global.debug_target_entity = en_a.ref
      }
    }
  }

  for &en in gm.entities
  {
    if .ACTIVE not_in en.props do continue
    
    // - Entity wrap at window edges ---
    if .WRAP_AT_WORLD_EDGES in en.props
    {
      if en.pos.x > WORLD_WIDTH
      {
        en.pos.x = -en.scale.x
        en.props -= {.INTERPOLATE}
      }
      else if en.pos.x + en.scale.x < 0
      {
        en.pos.x = WORLD_WIDTH
        en.props -= {.INTERPOLATE}
      }

      if en.pos.y > WORLD_HEIGHT
      {
        en.pos.y = -en.scale.y
        en.props -= {.INTERPOLATE}
      }
      else if en.pos.y + en.scale.y < 0
      {
        en.pos.y = WORLD_HEIGHT
        en.props -= {.INTERPOLATE}
      }
    }

    if .LOOK_AT_TARGET in en.props
    {
      target_pos: v2f32
      target_en, ok := entity_from_ref(en.targetting.target_en)
      if ok
      {
        target_pos = target_en.pos 
      }
      else
      {
        target_pos = cursor_pos
      }

      if en.pos.x > target_pos.x 
      {
        en.props += {.FLIP_X}
      }
      else
      {
        en.props -= {.FLIP_X}
      }
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

  // - Animate entities ---
  for &en in gm.entities
  {
    if .ACTIVE not_in en.props do continue

    if .ROTATE_OVER_TIME in en.props
    {
      en.rot += 0.25 * math.PI * dt
    }
    
    anim := en.anim.data[en.anim.state]
    desc := &res.entity_anims[en.anim.data[en.anim.state]]

    if len(desc.frames) > 0
    {
      en.sprite = desc.frames[en.anim.frame_idx]

      if len(desc.frames) > 1
      {
        en.anim.counter += 1

        if en.anim.counter % desc.ticks_per_frame == 0
        {
          en.anim.frame_idx += 1
          if en.anim.frame_idx == u16(len(desc.frames))
          {
            en.anim.frame_idx = 0
          }
        }
      }
    }
  }

  // - Update particles --- 
  for &par in gm.particles
  {
    if .ACTIVE not_in par.props do continue

    if .ROTATE_OVER_TIME in par.props
    {
      par.rot += dt * 2
    }
  }

  // - Save and load game ---
  when false
  {
    SAVE_PATH :: "res/saves/main"

    if plf.key_just_pressed(.K) && plf.key_pressed(.L_CTRL)
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

    if plf.key_just_pressed(.L) && plf.key_pressed(.L_CTRL)
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

  reset_entity_collision_cache()

  mem.clear_arena(&global.frame_arena)
}

update_debug_ui :: proc(gm: ^Game, dt: f32)
{
  // im.ShowDemoWindow()

  imgui.Begin("General")
  {
    imgui.Text("Time elapsed: %.f s", gm.t)
    imgui.PushItemWidth(80)
    imgui.InputFloat("Time multiplier", &gm.t_mult, 0.25, format="%.2f")
    gm.t_mult = clamp(gm.t_mult, 0, 3)
    imgui.PopItemWidth()

    imgui.Text("Cursor: (%.f, %.f)", plf.cursor_pos().x, plf.cursor_pos().y)
    imgui.Text("Entities: %i", gm.entities_cnt)
    imgui.Text("Debug Entities: %i", gm.debug_entities_pos)

    imgui.Spacing()
    diff := time.tick_diff(update_start_tick, update_end_tick)
    durr_us := time.duration_microseconds(diff)
    imgui.Text("Update: %.f us", durr_us)
    imgui.Spacing()
    imgui.Spacing()

    imgui.Checkbox("Show colliders", &global.debug_mode)
    if imgui.Button("Spawn enemy")
    {
      if gm.entities_cnt < len(gm.entities)
      {
        spawn_enemy(.ALIEN)
      }
    }
  }
  imgui.End()

  imgui.Begin("Entity Inspector")
  {
    en := entity_from_ref(global.debug_target_entity)

    imgui.Text("Ref:   [idx=%u, gen=%u]", en.ref.idx, en.ref.gen)

    imgui.PushID("Pos")
    imgui.Text("Pos:  "); imgui.SameLine()
    imgui.InputFloat2("", &en.pos)
    imgui.PopID()

    imgui.PushID("Rot")
    imgui.Text("Rot:  "); imgui.SameLine()
    imgui.InputFloat("", &en.rot)
    imgui.PopID()

    imgui.PushID("Scale")
    imgui.Text("Scale:"); imgui.SameLine()
    imgui.InputFloat2("", &en.scale)
    imgui.PopID()

    imgui.PushID("Vel")
    imgui.Text("Vel:  "); imgui.SameLine()
    imgui.InputFloat2("", &en.vel)
    imgui.PopID()

    imgui.PushID("Speed")
    imgui.Text("Speed:"); imgui.SameLine()
    imgui.InputFloat("", &en.movement_speed)
    imgui.PopID()
  }
  imgui.End()
}

render_game :: proc(gm: ^Game, dt: f32)
{
  begin_draw({77, 125, 53, 255}/255)

  // - Draw particles ---
  for &par in gm.particles
  {
    if .ACTIVE not_in par.props do continue
    
    draw_sprite(par.pos, par.scale, par.rot, par.tint, par.color, par.sprite)
  }

  // - Draw entities ---
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

  // - Draw entities ---
  for en in en_targets
  {
    if .RENDER not_in en.props do continue

    flip: v2f32
    flip.x = -1 if .FLIP_X in en.props else 1
    flip.y = -1 if .FLIP_Y in en.props else 1
    draw_sprite(en.pos, en.scale * flip, en.rot, en.tint, en.color, en.sprite)
  }

  // - Draw debug entities ---
  if global.debug_mode
  {
    for &den in gm.debug_entities
    {
      if .RENDER not_in den.props do continue
      draw_sprite(den.pos, den.scale, den.rot, den.tint, den.color, den.sprite)
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

    if !entity_has_props(curr_en, {.ACTIVE, .INTERPOLATE}) ||
       !entity_has_props(prev_en, {.ACTIVE, .INTERPOLATE})
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
  if global.debug_mode
  {
    for i in 0..<len(res_gm.debug_entities)
    {
      curr_den := &curr_gm.debug_entities[i]
      prev_den := &prev_gm.debug_entities[i]

      if !entity_has_props(curr_den, {.ACTIVE, .INTERPOLATE}) ||
         !entity_has_props(prev_den, {.ACTIVE, .INTERPOLATE})
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
  mem.destroy_arena(&global.frame_arena)
  tlsf.destroy(&global.world_mem)
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
  saved_buf := make([]u8, size_of(Game)*2, mem.allocator(&global.frame_arena))
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

screen_to_world_pos :: proc(pos: v2f32) -> v2f32
{
  return {
    (pos.x - user.viewport.x) * (WORLD_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (WORLD_HEIGHT / user.viewport.w),
  }
}

// Entity ////////////////////////////////////////////////////////////////////////////////

MAX_ENTITIES_COUNT  :: 128 + 1

Entity :: struct
{
  ref:              Entity_Ref,
  gen:              u32,
  props:            bit_set[Entity_Prop],
  parent:           Entity_Ref,
  children:         [dynamic]Entity_Ref,
  pos:              v2f32,
  vel:              v2f32,
  scale:            v2f32,
  radius:           f32,
  rot:              f32,
  input_dir:        v2f32,
  movement_speed:   f32,
  tint:             v4f32,
  color:            v4f32,
  sprite:           Sprite_ID,
  collider:         Collider,
  col_layer:        enum u16 {NIL, PLAYER, ENEMY},
  z_index:          i16,
  z_layer:          enum u16 {NIL, DECORATION, ENEMY, PLAYER, PROJECTILE},
  enemy_kind:       Enemy_Kind,
  weapon_kind:      Weapon_Kind,
  projectile_kind:  Projectile_Kind,
  attack_timer:     Timer,
  death_timer:      Timer,
  hurt_timer:       Timer,
  hurt_grace_timer: Timer,
  targetting:       struct
  {   
    target_en:      Entity_Ref,
    target_pos:     v2f32,
    min_dist:       f32,
    max_dist:       f32,
  },
  anim:             struct
  {
    data:           [Entity_State]Entity_Anim_ID,
    state:          Entity_State,
    frame_idx:      u16,
    counter:        u16,
  },
}

Entity_Ref :: struct
{
  idx: u32,
  gen: u32,
}

Entity_Prop :: enum u64
{
  ACTIVE,
  RENDER,
  MARKED_FOR_DEATH,
  INTERPOLATE,
  FLIP_X,
  FLIP_Y,
  WRAP_AT_WORLD_EDGES,
  LOOK_AT_TARGET,
  KILL_AFTER_TIME,
  FOLLOW_ENTITY,
  ROTATE_OVER_TIME,
}

Enemy_Kind :: enum
{
  NIL,
  ALIEN,
}

Weapon_Kind :: enum
{
  NIL,
  RIFLE,
}

Projectile_Kind :: enum
{
  NIL,
  BULLET,
}

Entity_State :: enum
{
  NIL,
  IDLE,
  WALK,
}

@(rodata)
NIL_ENTITY: Entity

@(rodata)
COLLISION_MATRIX: [type_of(Entity{}.col_layer)]bit_set[type_of(Entity{}.col_layer)] = {
  .NIL    = {.NIL},
  .PLAYER = {.ENEMY},
  .ENEMY  = {.PLAYER},
}

entity_is_valid :: #force_inline proc(en: ^Entity) -> bool
{
  assert(en != nil)
  return en.ref.idx != 0
}

entity_from_ref :: #force_inline proc(ref: Entity_Ref) -> (^Entity, bool) #optional_ok
{
  gm := get_current_game()
  en := &gm.entities[ref.idx]

  if ref.idx != 0 && ref.gen == en.gen
  {
    return en, true
  }
  else
  {
    return &NIL_ENTITY, false
  }
}

alloc_entity :: proc(gm: ^Game) -> ^Entity
{
  assert(gm.entities_cnt < len(gm.entities)-1)

  result := &NIL_ENTITY

  for &en, i in gm.entities[1:]
  {
    if en.ref.idx == 0
    {
      en.ref.idx = cast(u32) i + 1
      en.ref.gen = en.gen
      en.props += {.ACTIVE, .RENDER}
      en.children = make([dynamic]Entity_Ref, tlsf.allocator(&global.world_mem))

      result = &en
      
      gm.entities_cnt += 1
      break
    }
  }

  return result
}

free_entity :: proc(gm: ^Game, en: ^Entity)
{
  assert(entity_is_valid(en))

  gen := en.gen
  
  delete(en.children)
  en^ = {}
  en.gen = gen + 1

  gm.entities_cnt -= 1
}

attach_entity_child :: proc(parent, child: ^Entity)
{
  has_free: bool

  for &slot in parent.children
  {
    if slot.idx == 0
    {
      slot = child.ref
      child.parent = parent.ref
      has_free = true
    }
  }

  if !has_free
  {
    append(&parent.children, child.ref)
    child.parent = parent.ref
  }
}

setup_sprite_entity :: proc(en: ^Entity, sprite: Sprite_ID)
{
  en.sprite = sprite
  en.tint = {1, 1, 1, 1}
  en.scale = {SPRITE_SIZE, SPRITE_SIZE}
}

setup_player :: proc(en: ^Entity)
{
  gm := get_current_game()

  setup_sprite_entity(en, .PLAYER_IDLE_1)
  en.props += {.WRAP_AT_WORLD_EDGES, .LOOK_AT_TARGET}
  en.z_layer = .PLAYER
  en.collider.kind = .POLYGON
  en.pos = {WORLD_WIDTH/2, WORLD_HEIGHT/2}
  en.movement_speed = 200

  en.anim.state = .IDLE
  en.anim.data[.IDLE] = .PLAYER_IDLE
  
  shadow := alloc_entity(gm)
  setup_sprite_entity(shadow, .SHADOW)
  shadow.pos = en.pos
  shadow.color = {0.3, 0.3, 0.3, 0}
  shadow.tint.a = 0.3
  attach_entity_child(en, shadow)
}

spawn_enemy :: proc(kind: Enemy_Kind) -> ^Entity
{
  gm := get_current_game()

  en := alloc_entity(gm)
  en.enemy_kind = kind
  en.props += {.FOLLOW_ENTITY}
  en.scale = {SPRITE_SIZE, SPRITE_SIZE}
  en.tint = {1, 1, 1, 1}
  en.z_layer = .ENEMY
  en.col_layer = .ENEMY
  en.targetting.target_en = special_entities[.PLAYER].ref
  en.targetting.min_dist = 8
  en.targetting.max_dist = 1000

  switch kind
  {
  case .ALIEN:
    en.sprite = .NIL
  case .NIL:
  }

  en.collider.kind = collider_map[en.sprite].kind

  return en
}

spawn_weapon :: proc(kind: Weapon_Kind) -> ^Entity
{
  gm := get_current_game()

  en := alloc_entity(gm)
  en.weapon_kind = kind
  en.scale = {SPRITE_SIZE, SPRITE_SIZE}
  en.tint = {1, 1, 1, 1}
  en.z_layer = .DECORATION

  switch kind
  {
  case .RIFLE:
    en.sprite = .RIFLE
  case .NIL:
  }

  return en
}

spawn_projectile :: proc(kind: Projectile_Kind) -> ^Entity
{
  gm := get_current_game()

  en := alloc_entity(gm)
  en.projectile_kind = kind
  en.props += {.INTERPOLATE, .KILL_AFTER_TIME}
  en.scale = {SPRITE_SIZE, SPRITE_SIZE}
  en.z_layer = .PROJECTILE
  en.col_layer = .PLAYER

  switch kind
  {
  case .BULLET:
    en.sprite = .BULLET
    en.collider.radius = 4
  case .NIL:
  }

  en.collider.kind = collider_map[en.sprite].kind

  return en
}

kill_entity :: proc(en: ^Entity)
{
  en.props -= {.ACTIVE}
  en.props += {.MARKED_FOR_DEATH}
}

entity_has_props :: #force_inline proc(en: ^$E/Entity, props: bit_set[Entity_Prop]) -> bool
{
  return en.props & props == props
}

entity_look_at_point :: proc(en: ^$E/Entity, target: v2f32)
{
  dd := target - en.pos
  en.rot = math.atan2(dd.y, dd.x)
  if en.rot < 0
  {
    en.rot += math.TAU
  }
}

tl_from_entity :: proc(en: ^Entity) -> v2f32
{
  pivot := res.sprites[en.sprite].pivot
  dim := dim_from_entity(en)
  local_pos := vm.rotation_2x2f(en.rot) * (v2f32{-dim.x, -dim.y} * pivot)
  return local_pos + en.pos
}

dim_from_entity :: proc(en: ^Entity) -> v2f32
{
  return en.scale * {16, 16}
}

entity_collider_vertex_pos :: proc(en: ^Entity, v: v2f32) -> v2f32
{
  local_pos := vm.rotation_2x2f(en.rot) * v * 2
  return tl_from_entity(en) + local_pos
}

xform_from_entity :: proc(en: ^Entity) -> m3x3f32
{
  result := vm.scale_3x3f(en.scale)
  result = vm.rotation_3x3f(en.rot) * result
  result = vm.translation_3x3f(tl_from_entity(en)) * result
  return result
}

update_entity_collider :: proc(en: ^Entity)
{
  switch en.collider.kind
  {
  case .CIRCLE:
    origin := xform_from_entity(en) * vm.combine(collider_map[en.sprite].origin, 1)
    en.collider.origin = origin.xy
    debug_circle(en.collider.origin, en.collider.radius, alpha=0.25)
  case .POLYGON:
    en.collider.vertices_cnt = cast(u8) collider_map[en.sprite].vertex_count
    for i in 0..<en.collider.vertices_cnt
    {
      v := xform_from_entity(en) * vm.combine(collider_map[en.sprite].vertices[i], 1)
      en.collider.vertices[i] = v.xy
    }

    for vert in en.collider.vertices[:en.collider.vertices_cnt]
    {
      debug_circle(vert, 4, color={0, 1, 0, 0}, alpha=0.75)
    }
  case .NIL:
  }
}

entity_collision :: proc(en_a, en_b: ^Entity) -> bool
{
  result: bool

  if en_a.collider.kind == .CIRCLE && en_b.collider.kind == .CIRCLE
  {
    result = circle_circle_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .POLYGON && en_b.collider.kind == .POLYGON
  { 
    result = polygon_polygon_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .CIRCLE && en_b.collider.kind == .POLYGON
  {
    result = circle_polygon_overlap(&en_a.collider, &en_b.collider)
  }
  else if en_a.collider.kind == .POLYGON && en_b.collider.kind == .CIRCLE
  {
    result = circle_polygon_overlap(&en_b.collider, &en_a.collider)
  }

  return result
}

@(thread_local, private="file")
_entity_collision_cache: [MAX_ENTITIES_COUNT][MAX_ENTITIES_COUNT]bool

get_entities_collided_cache :: proc(a, b: Entity_Ref) -> bool
{
  return _entity_collision_cache[a.idx][b.idx] && _entity_collision_cache[b.idx][a.idx]
}

set_entities_collided_cache :: proc(a, b: Entity_Ref)
{
  _entity_collision_cache[a.idx][b.idx] = true
  _entity_collision_cache[b.idx][a.idx] = true
}

reset_entity_collision_cache :: proc()
{
  mem.set(&_entity_collision_cache, 0, MAX_ENTITIES_COUNT * MAX_ENTITIES_COUNT)
}

// Debug_Entity //////////////////////////////////////////////////////////////////////////

Debug_Entity :: distinct Entity

push_debug_entity :: proc() -> ^Debug_Entity
{
  gm := get_current_game()

  result := &gm.debug_entities[gm.debug_entities_pos]
  result.props += {.ACTIVE, .RENDER, .INTERPOLATE, .MARKED_FOR_DEATH}

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

  // NOTE(dg): This is not a good solution because it breaks interpolation. 
  if gm.debug_entities_pos == -1
  {
    gm.debug_entities_pos = len(gm.debug_entities)-1
  }
}

debug_rect :: proc(
  pos:    v2f32,
  scale:  v2f32, 
  color:  v4f32 = {1, 1, 1, 0},
  alpha:  f32 = 0.5,
  sprite: Sprite_ID = .SQUARE,
) -> ^Debug_Entity
{
  gm := get_current_game()

  result := push_debug_entity()
  result.pos = pos
  result.scale = scale
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = sprite

  return result
}

debug_circle :: proc(
  pos:    v2f32,
  radius: f32, 
  color:  v4f32 = {0, 1, 0, 0},
  alpha:  f32 = 0.5,
) -> ^Debug_Entity
{
  gm := get_current_game()

  result := push_debug_entity()
  result.pos = pos
  result.scale = {radius/16, radius/16}
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = .CIRCLE

  return result
}

// Tile ///////////////////////////////////////////////////////////////////////////////////

Tile :: struct
{
  kind: Tile_Kind,
}

Tile_Kind :: enum
{
  NIL,
  DIRT,
  GRASS,
}

generate_region_tiles :: proc(gm: ^Game, rows, columns: int)
{
  for r in 0..<rows
  {
    for c in 0..<columns
    {

    }
  }
}

// Particle //////////////////////////////////////////////////////////////////////////////

MAX_PARTICLES_COUNT :: 1024

Particle :: struct
{
  props:      bit_set[Particle_Prop],
  rot:        f32,
  pos:        v2f32,
  vel:        v2f32,
  scale:      v2f32,
  tint:       v4f32,
  color:      v4f32,
  kill_timer: Timer, 
  sprite:     Sprite_ID,
}

Particle_Prop :: enum u16
{
  ACTIVE,
  INTERPOLATE,
  KILL_AFTER_TIME,
  ROTATE_OVER_TIME,
  SCALE_OVER_TIME,
}

particle_has_props :: proc(par: ^Particle, props: bit_set[Particle_Prop]) -> bool
{
  return par.props & props == props
}

push_particle :: proc(gm: ^Game) -> ^Particle
{
  result := &gm.particles[gm.particles_pos]
  result.props += {.ACTIVE, .INTERPOLATE}
  result.tint = {1, 1, 1, 1}
  result.color = {0, 0, 0, 1}

  gm.particles_pos += 1
  if gm.particles_pos == len(gm.particles)
  {
    gm.particles_pos = 0
  }

  return result
}

// Timer /////////////////////////////////////////////////////////////////////////////////

Timer :: struct
{
  ticking:  bool,
  duration: f32,
  end_time: f32,
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
  origin:       v2f32,
  radius:       f32,
  vertices:     [8]v2f32,
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
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vm.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
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
    
    min_pa := max(f32)
    max_pa := min(f32)
    for k in 0..<a.vertices_cnt
    {
      p := vm.dot(a.vertices[k], proj_axis)
      min_pa = min(min_pa, p)
      max_pa = max(max_pa, p)
    }

    min_pb := max(f32)
    max_pb := min(f32)
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

    edge := vj - vi
    proj := vm.dot(circle.origin - vi, edge) / vm.magnitude_squared(edge)

    edge_point: v2f32
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

point_in_polygon :: proc(point: v2f32, polygon: []v2f32) -> bool
{
  inside: bool

  for i in 0..<len(polygon)
  {
    j := (i + 1) % len(polygon)
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
