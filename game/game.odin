package game

import "core:math"
import "core:log"
import "core:os"
import "core:slice"
import "core:strings"
import "core:time"
import "core:reflect"
import imgui "ext:dear_imgui"
import "basic/bytes"
import "basic/mem"
import "basic/rand"
import "basic/vmath"
import "platform"
import "render"
import tt "transform_tree"
import "ui"


// Global //////////////////////////////////////////////////////////////////////////////////


global: struct
{
  frame_arena:     mem.Arena,
  ui_frame_arena:  mem.Arena,
  world_mem:       mem.Heap,
  gui_tree:        ui.Tree,
  audio:           struct
  {
    music_volume:  f32,
  },
  debug:           struct
  {
    enabled:       bool,
    target_entity: Entity_Ref,
    silence_noise: bool,
  },
  temp:            struct
  {
    noise_sources: [dynamic]Noise_Source,
  },
}

init_global :: proc()
{
  // WARN(dg): What if multiple games running on same thread? This needs to change.
  _ = mem.arena_init_growing(&global.frame_arena)
  _ = mem.arena_init_growing(&global.ui_frame_arena)
  _ = mem.heap_init(&global.world_mem, mem.default_allocator(), mem.MIB * 16)

  global.temp.noise_sources.allocator = mem.allocator(&global.frame_arena)
  global.audio.music_volume = 0.0

  ui.tree_init(&global.gui_tree, 1024, &user.perm_arena, &global.ui_frame_arena)
}


// Game //////////////////////////////////////////////////////////////////////////////////


Game :: struct
{
  started:            bool,
  t:                  f32,
  t_mult:             f32,
  interpolate:        bool,
  prev_keys:          [platform.Key_Kind]bool,
  prev_mouse_btns:    [platform.Mouse_Btn_Kind]bool,
  camera:             struct
  {
    pos:              v2f32,
    scl:              v2f32,
    rot:              f32,
  },
  transform_tree:     tt.Transform_Tree,
  entities:           [MAX_ENTITIES]Entity,
  entities_cnt:       int,
  debug_entities:     [MAX_DEBUG_ENTITIES]Debug_Entity,
  debug_entities_pos: int,
  particles:          [MAX_PARTICLES]Particle,
  particles_pos:      int,
  special_entities:   [enum{Player}]^Entity,
  tiles:              [MAX_ZONE_TILES]Tile,
  active_zone:        Zone_Name,
  weapon:             struct
  {
    kind:             Weapon_Kind,
    holstered:        bool,
    just_flipped:     bool,
  },
  player_inventory:   struct
  {
    items:            [Item_Kind]int,
  },
  light_color:        v4f32,
  selected_entity:    Entity_Ref,
}

@(private="file")
_active_game: ^Game

get_active_game :: #force_inline proc() -> ^Game
{
  return _active_game
}

set_active_game :: #force_inline proc(gm: ^Game)
{
  _active_game = gm
  tt.global_tree = &gm.transform_tree
}

game_init :: proc(gm: ^Game)
{
  gm.transform_tree = tt.create_tree(MAX_ENTITIES-1, mem.allocator(&global.world_mem))
}

game_free :: proc(gm: ^Game)
{
  mem.arena_destroy(&global.frame_arena)
  mem.heap_destroy(&global.world_mem)
  tt.destroy_tree(&gm.transform_tree)
}

game_copy :: proc(dst, src: ^Game)
{
  dst_tree := dst.transform_tree
  dst^ = src^
  dst.transform_tree = dst_tree
  tt.copy_tree(&dst.transform_tree, &src.transform_tree)
}

game_save :: proc(gm: ^Game, path: string)
{
  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)
  context.allocator = mem.allocator(scratch)

  file, open_err := os.open(path, {.Write, .Create, .Trunc})
  if open_err != nil
  {
    log.errorf("[game]: Failed to open save file '%s' for writing. (%s)", path, open_err)
    return
  }

  save_buf := bytes.make_buffer(make([]byte, size_of(Game)), .LE)
  bytes.write_u8(&save_buf, cast(u8) gm.active_zone)
  os.write(file, save_buf.data)

  file_info, _ := os.fstat(file, mem.allocator(scratch))
  log.infof("[game]: Saved data to file '%s'.\n", file_info.fullpath)
}

game_load :: proc(gm: ^Game, path: string)
{
  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)
  context.allocator = mem.allocator(scratch)

  file, open_err := os.open(path, {.Read})
  if open_err != nil
  {
    log.warnf("[game]: Failed to open save file '%s' for reading. (%s)\n", path, open_err)
    return
  }

  save_data := make([]byte, size_of(Game))
  os.read(file, save_data)
  save_buf := bytes.make_buffer(save_data, .LE)
  gm.active_zone = cast(Zone_Name) bytes.read_u8(&save_buf)

  file_info, _ := os.fstat(file, mem.allocator(scratch))
  log.infof("[game]: Loaded data from file '%s'.\n", file_info.fullpath)
}

game_start :: proc(gm: ^Game)
{
  set_active_game(gm)

  game_load(gm, "res/data/debug.dat")

  gm.t_mult = 1
  gm.camera.scl = {1, 1}
  // gm.light_color = {1.0, 1.0, 1.0, 1.0}
  gm.light_color = {1.0, 0.8, 0.8, 1.0}

  player := spawn_player()
  entity_equip_weapon(player, .Nil)

  set_active_zone(gm.active_zone, true)

  for _ in 0..<1
  {
    spawn_creature(.Deer, {170, 180})
    spawn_creature(.Rabbit, {200, 200})
    spawn_creature(.Squirrel, {230, 190})
    // spawn_creature(.Zombie, {100, 100})
    spawn_creature(.Squirrel, {50, 50})
  }

  play_sound(.Minecraft, volume=global.audio.music_volume)

  spawn_entity(.Stump, {300, 100})
  spawn_entity(.Stump, {100, 300})

  global.debug.silence_noise = true

  set_active_game(nil)
}

game_quit :: proc(gm: ^Game)
{
  game_save(gm, "res/data/debug.dat")
}

game_update :: proc(gm: ^Game, dt: f32)
{
  set_active_game(gm)

  gm.started = true

  player := gm.special_entities[.Player]
  cursor_pos := screen_to_world_space(platform.get_cursor_position())

  gm.interpolate = true

  set_music_volume(global.audio.music_volume)

  // - Resolve entity defers ---
  for &en in gm.entities do if entity_is_valid(en)
  {
    if .Marked_For_Death in en.props
    {
      free_entity(gm, &en)
      continue
    }

    if .Marked_For_Spawn in en.props
    {
      en.flags.render = true
      en.flags.update = true
      en.props -= {.Marked_For_Spawn}
    }

    if .Interpolate in en.props
    {
      en.flags.interpolate = true
    }
  }

  // - Kill debug entities ---
  for &den in gm.debug_entities
  {
    if .Marked_For_Death in den.props
    {
      pop_debug_entity(&den)
    }
  }

  // Test noise
  // printf("%.2f\n", noise_at__test(cursor_pos, 60, tt.global_pos(player)))

  // - Global keybinds ---
  {
    if key_down(.Left_Ctrl)
    {
      if key_just_down(.Backtick)
      {
        global.debug.enabled = !global.debug.enabled
      }
      else if key_just_down(.S_1)
      {
        gm.t_mult = 1
      }
      else if key_just_down(.S_2)
      {
        gm.t_mult = 0
      }
      else if key_just_down(.S_3)
      {
        gm.t_mult = 0.25
      }
      else if key_just_down(.S_4)
      {
        gm.t_mult = 0.5
      }
      else if key_just_down(.S_5)
      {
        gm.t_mult = 2
      }
      else if key_just_down(.S_6)
      {
        gm.t_mult = 3
      }
      else if key_just_down(.P)
      {
        set_active_zone(.Wilderness if gm.active_zone == .Shop else .Shop)
      }
    }
    else
    {
      if key_just_down(.S_1)
      {
        entity_equip_weapon(player, .Nil)
      }
      else if key_just_down(.S_2)
      {
        entity_equip_weapon(player, .Revolver)
      }
      else if key_just_down(.S_3)
      {
        entity_equip_weapon(player, .Rifle)
      }

      if gm.weapon.kind != .Nil
      {
        if input_just_down(res.actions[.Holster])
        {
          entity_holster_weapon(player, !gm.weapon.holstered)
        }
        else if input_just_down(res.actions[.Attack]) && gm.weapon.holstered
        {
          platform.consume_input(res.actions[.Attack])
          entity_holster_weapon(player, false)
        }
      }
    }
  }

  // - Player movement (:move, :movement) ---
  {
    EQUIPPED_MULT  :: 0.7
    BACKWARD_MULT  :: 0.7
    SNEAKING_MULT  :: 0.5
    WALKING_NOISE  :: 50
    SNEAKING_NOISE :: 35

    backward, sneaking: bool

    if platform.input_down(res.actions[.Sneak])
    {
      player.props += {.Sneaking}
      sneaking = true
    }
    else
    {
      player.props -= {.Sneaking}
      sneaking = false
    }

    if platform.input_down(res.actions[.Left]) && !platform.input_down(res.actions[.Right])
    {
      backward = cursor_pos.x > tt.local(player).pos.x
      player.input_dir.x = -1
    }
    else if platform.input_down(res.actions[.Right]) && !platform.input_down(res.actions[.Left])
    {
      backward = cursor_pos.x < tt.local(player).pos.x
      player.input_dir.x = 1
    }
    else
    {
      player.vel.x = 0
      player.input_dir.x = 0
    }

    if platform.input_down(res.actions[.Up]) && !platform.input_down(res.actions[.Down])
    {
      player.input_dir.y = -1
    }
    else if platform.input_down(res.actions[.Down]) && !platform.input_down(res.actions[.Up])
    {
      player.input_dir.y = 1
    }
    else
    {
      player.vel.y = 0
      player.input_dir.y = 0
    }

    if key_down(.Space)
    {
      entity_play_animation(player, .Harvest_Blood, looping=false)
    }
    else if player.input_dir.x != 0 || player.input_dir.y != 0
    {
      speed_mult: f32 = 1
      speed_mult *= backward ? BACKWARD_MULT : 1
      speed_mult *= sneaking ? SNEAKING_MULT : 1
      speed_mult *= !gm.weapon.holstered ? EQUIPPED_MULT : 1

      anim: Animation_State = sneaking ? .Sneak_Walk : .Walk
      entity_play_animation(player, anim, speed=speed_mult, looping=true, reverse=backward)

      noise: f32 = sneaking ? SNEAKING_NOISE : WALKING_NOISE
      emit_noise(noise, tt.global_pos(player))

      player.movement_speed = res.creatures[.Player].speed * speed_mult
      if player.vel.x != 0 && player.vel.y != 0
      {
        player.vel = vmath.normalize(player.input_dir) * player.movement_speed
      }
      else
      {
        player.vel = player.input_dir * player.movement_speed
      }
    }
    else
    {
      anim: Animation_State = sneaking ? .Sneak_Idle : .Idle
      entity_play_animation(player, anim, looping=true)
    }

    entity_flip_to_target(player, cursor_pos)
    set_audio_listener_pos(tt.global_pos(player))
  }

  // - Creature ---
  for &en in gm.entities do if en.flags.update
  {
    if .Flee_Noise in en.props
    {
      creature_desc := res.creatures[en.name]
      noise := noise_at(tt.global_pos(en))

      if noise > creature_desc.noise_threshold
      {
        if !en.flee_timer.ticking
        {
          timer_start(&en.flee_timer, creature_desc.reaction_time)
        }
      }

      if timer_timeout(&en.flee_timer)
      {
        en.flee_timer.ticking = false
        entity_set_state(&en, .Flee)
      }
    }
    
    if .Hostile in en.props && en.state != .Flee
    {
      target_en, ok := entity_from_ref(en.target_entity)
      if !ok do break

      if vmath.distance(tt.global_pos(en), tt.global_pos(target_en)) < res.creatures[en.name].view_dist
      {
        entity_set_state(&en, .Pursue)
      }
      else if en.state == .Pursue
      {
        entity_set_state(&en, .Wander)
      }
    }
  }

  // - Update state and move ---
  for &en in gm.entities do if en.flags.update
  {
    en->update_state(&{dt=dt})
    tt.local(en).pos += en.vel * dt
  }

  // - Camera follow player
  {
    bounds: [2]Range(f32)
    bounds.x.min = -ZONE_MARGIN_SIZE
    bounds.x.max = f32(res.zones[gm.active_zone].width) + ZONE_MARGIN_SIZE
    bounds.y.min = -ZONE_MARGIN_SIZE
    bounds.y.max = f32(res.zones[gm.active_zone].height) + ZONE_MARGIN_SIZE
    camera_follow_point(tt.global_pos(player), bounds)
  }

  // - Player attack (:attack, :combat) ---
  {
    weapon, _ := entity_child_at(player, 1)
    weapon_desc := &res.weapons[gm.weapon.kind]

    debug_circle(tt.global_pos(player) + weapon_desc.hold_off, 1, {1, 0, 0, 0})

    // - Rotate equipped weapon ---
    if player.equipped.weapon_kind != .Nil
    {
      pivot := tt.global_pos(player)
      pivot.x += weapon_desc.hold_off.x * -1 if .Flip_H in player.props else 1
      pivot.y += weapon_desc.hold_off.y

      diff := vmath.normalize(cursor_pos - pivot)
      angle := math.atan2(diff.y, diff.x)

      if .Flip_H in player.props
      {
        if angle < 0
        {
          angle += 2 * math.PI
        }

        weapon.props += {.Flip_V}
      }
      else
      {
        weapon.props -= {.Flip_V}
      }

      tt.local(weapon).rot = angle
    }

    // - Shoot weapon (:shoot) ---
    if gm.weapon.kind != .Nil
    {
      muzzle_flash, ok := entity_child_at(weapon, 0)
      if !ok
      {
        log.fatal("[game]: Failed to get muzzle_flash entity.")
        os.exit(1)
      }

      if !player.attack_timer.ticking
      {
        timer_start(&player.attack_timer, weapon_desc.shot_time)
      }

      can_shoot := platform.input_down(res.actions[.Attack]) &&
                   timer_timeout(&player.attack_timer) &&
                   !gm.weapon.holstered

      if can_shoot
      {
        player.attack_timer.ticking = false

        shot_point_pos := tt.global_pos(weapon.shot_point)

        proj := spawn_projectile(.Bullet, shot_point_pos)
        tt.local(proj).rot = tt.global_rot(weapon.shot_point)
        proj.vel.x = math.cos(tt.local_rot(proj)) * weapon_desc.speed
        proj.vel.y = math.sin(tt.local_rot(proj)) * weapon_desc.speed

        timer_start(&player.equipped.muzzle_timer, 0.1)
        muzzle_flash.flags.render = true

        entity_distort(weapon, .Width, tt.local(weapon).scl.x*0.8, 5*dt)
        spawn_particles(.Gun_Smoke, shot_point_pos)
        play_sound(.Gun_Shot, volume=0.1, pitch=rand.range_f32({0.8, 1.2}))
        emit_noise(60, shot_point_pos)
      }

      // - Position effects ---
      if .Flip_V in weapon.props
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_pos + {0, 3}
        tt.local(muzzle_flash).pos = weapon_desc.shot_pos + {0, 3}
      }
      else
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_pos
        tt.local(muzzle_flash).pos = weapon_desc.shot_pos
      }

      if timer_timeout(&player.equipped.muzzle_timer)
      {
        player.equipped.muzzle_timer.ticking = false
        muzzle_flash.flags.render = false
      }
    }
  }

  // - Collision detection (:collision, :collide) ---
  {
    for &en in gm.entities do if en.flags.update && en.collider != nil
    {
      entity_collider_update(&en, dt)
    }

    Collision :: struct{a, b: u32, stale: bool}

    @(static)
    collided_cache: [dynamic]Collision
    collided_cache.allocator = mem.allocator(&user.perm_arena)

    lookup_cache :: proc(a, b: Entity_Ref) -> (int, bool)
    {
      for col, i in collided_cache
      {
        if (col.a == a.id && col.b == b.id)
        {
          return i, true
        }
      }

      return -1, false
    }

    // - Set stale flag ---
    for &col, i in collided_cache
    {
      col.stale = true
    }

    for &en_a in gm.entities do if en_a.flags.update && en_a.collider != nil
    {
      // - Entity collision ---
      for &en_b in gm.entities do if en_b.flags.update && en_b.collider != nil
      {
        if entity_is_same(en_a, en_b) do continue

        if en_b.collision_layer in COLLISION_MATRIX[en_a.collision_layer]
        {
          if collider_overlap(en_a.collider, en_b.collider)
          {
            col_idx, col_in_cache := lookup_cache(en_a.ref, en_b.ref)
            if !col_in_cache
            {
              append(&collided_cache, Collision{en_a.ref.id, en_b.ref.id, false})
              en_a->resolve_collision(&en_b, .Enter)
            }
            else
            {
              collided_cache[col_idx].stale = false
              en_a->resolve_collision(&en_b, .Stay)
            }
          }
          else
          {
            col_idx, col_in_cache := lookup_cache(en_a.ref, en_b.ref)
            if col_in_cache
            {
              unordered_remove(&collided_cache, col_idx)
              en_a->resolve_collision(&en_b, .Exit)
            }
          }
        }
      }

      // - Cursor collision ---
      if circle, ok := en_a.collider.(Circle); ok
      {
        if point_in_circle(cursor_pos, circle)
        {
          if mouse_btn_just_down(.Right)
          {
            global.debug.target_entity = en_a.ref
          }
        }
      }
    }

    // - Evict stale cache ---
    for col, i in collided_cache
    {
      if col.stale
      {
        unordered_remove(&collided_cache, i)
      }
    }
  }

  // - Harvest decoration ---
  {
    RANGE :: 30.0

    closest_dist := max(f32)

    for &en in gm.entities do if .Collectable in en.props
    {
      en_pos := tt.global_pos(en)

      dist := vmath.distance_2f32(tt.global_pos(player), en_pos)
      if dist < RANGE && point_in_shape(cursor_pos, en.collider)
      {
        if dist < closest_dist
        {
          gm.selected_entity = en.ref
          closest_dist = dist
        }
      }
      else
      {
        en.props -= {.Highlighted}
      }
      
      if dist > closest_dist
      {
        en.props -= {.Highlighted}
      }
    }

    if closest_dist >= RANGE
    {
      gm.selected_entity = {}
    }

    selected := entity_from_ref(gm.selected_entity)
    if entity_is_valid(selected)
    {
      selected.props += {.Highlighted}
      if mouse_btn_just_down(.Left)
      {
        harvest_entity(selected)
      }
    }
  }

  // - Misc behavior ---
  for &en in gm.entities do if en.flags.update
  {
    if .Kill_After_Time in en.props
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

    // - Select target ---
    if .Hostile in en.props && en.target_entity.id == 0
    {
      for &candidate in gm.entities do if candidate.flags.update
      {
        if candidate.name == .Player
        {
          en.target_entity = candidate.ref
        }
      } 
    }
  }

  // - Animate entities (:animate, :animation) ---
  for &en in gm.entities do if en.flags.update
  {
    // - Update animation state ---
    {
      prev_state := en.animation.state
      en.animation.state = en.animation.next_state
      if prev_state != en.animation.next_state
      {
        en.animation.duration = 0
        en.animation.frame_idx = entity_animation_last_frame(&en) if en.animation.reverse else 0
      }
    }

    // - Equipped weapon ---
    {
      weapon, _ := entity_child_at(player, 1)

      if gm.weapon.holstered
      {
        holster_off := res.weapons[gm.weapon.kind].holster_off
        holster_off *= entity_flip_vec(player)
        holster_off.y += 1 if .Sneaking in player.props else 0

        tt.local(weapon).pos = holster_off
        tt.local(weapon).rot = res.weapons[gm.weapon.kind].holster_rot

        if .Flip_H in player.props
        {
          weapon.props += {.Flip_V}
        }
        else
        {
          weapon.props -= {.Flip_V}
        }
      }
      else
      {
        hold_off := res.weapons[gm.weapon.kind].hold_off
        hold_off *= entity_flip_vec(player)
        hold_off.y += 1 if .Sneaking in player.props else 0
        tt.local(weapon).pos = hold_off
      }
    }

    if .Flash_Color in en.props
    {
      if timer_timeout(&en.flash_color_timer)
      {
        en.color = {0, 0, 0, 0}
        en.props -= {.Flash_Color}
      }
      else
      {
        en.color = en.flash_color
      }
    }

    if .Rotate_Over_Time in en.props
    {
      tt.local(en).rot += 0.25 * math.PI * dt
    }

    if .Highlighted in en.props
    {
      en.tint.rgb = 1.3
    }
    else
    {
      en.tint.rgb = 1
    }

    // - Distort ---
    {
      for i in 0..<len(en.distort)
      {
        distort_up: bool

        distort_up = en.distort[i].target > en.distort[i].saved
        switch en.distort[i].state
        {
        case .Hold:

        case .Distort:
          if distort_up
          {
            tt.local(en).scl[i] += en.distort[i].rate
            if tt.local(en).scl[i] >= en.distort[i].target
            {
              tt.local(en).scl[i] = en.distort[i].target
              en.distort[i].state = .Return
            }
          }
          else
          {
            tt.local(en).scl[i] -= en.distort[i].rate
            if tt.local(en).scl[i] <= en.distort[i].target
            {
              tt.local(en).scl[i] = en.distort[i].target
              en.distort[i].state = .Return
            }
          }

        case .Return:
          if distort_up
          {
            tt.local(en).scl[i] -= en.distort[i].rate
            if tt.local(en).scl[i] <= en.distort[i].saved
            {
              tt.local(en).scl[i] = en.distort[i].saved
              en.distort[i].state = .Hold
            }
          }
          else
          {
            tt.local(en).scl[i] += en.distort[i].rate
            if tt.local(en).scl[i] >= en.distort[i].saved
            {
              tt.local(en).scl[i] = en.distort[i].saved
              en.distort[i].state = .Hold
            }
          }
        }
      }
    }

    // - Fade ---
    {
      for i in 0..<2
      {
        prop: ^[4]f32 = (i == 0) ? &en.color : &en.tint

        switch en.fade[i].state
        {
        case .Hold:

        case .Fade:
          if en.fade[i].rate > 0
          {
            prop.r = vmath.lerp(prop.r, en.fade[i].target.r, en.fade[i].rate) if .R in en.fade[i].comps else prop.r
            prop.g = vmath.lerp(prop.g, en.fade[i].target.g, en.fade[i].rate) if .G in en.fade[i].comps else prop.g
            prop.b = vmath.lerp(prop.b, en.fade[i].target.b, en.fade[i].rate) if .B in en.fade[i].comps else prop.b
            prop.a = vmath.lerp(prop.a, en.fade[i].target.a, en.fade[i].rate) if .A in en.fade[i].comps else prop.a
          }
          else
          {
            prop.r = en.fade[i].target.r if .R in en.fade[i].comps else prop.r
            prop.g = en.fade[i].target.g if .G in en.fade[i].comps else prop.g
            prop.b = en.fade[i].target.b if .B in en.fade[i].comps else prop.b
            prop.a = en.fade[i].target.a if .A in en.fade[i].comps else prop.a
          }

          // if .R not_in en.fade[i].comps || prop.r == en.fade[i].target.r &&
          //    .G not_in en.fade[i].comps || prop.g == en.fade[i].target.g &&
          //    .B not_in en.fade[i].comps || prop.b == en.fade[i].target.b &&
          //    .A not_in en.fade[i].comps || prop.a == en.fade[i].target.a
          // {
          //   en.fade[i].state = .Return
          //   println("Returning!")
          // }

        case .Return:
          if en.fade[i].rate > 0
          {
            prop.r = vmath.lerp(prop.r, en.fade[i].saved.r, en.fade[i].rate) if .R in en.fade[i].comps else prop.r
            prop.g = vmath.lerp(prop.g, en.fade[i].saved.g, en.fade[i].rate) if .G in en.fade[i].comps else prop.g
            prop.b = vmath.lerp(prop.b, en.fade[i].saved.b, en.fade[i].rate) if .B in en.fade[i].comps else prop.b
            prop.a = vmath.lerp(prop.a, en.fade[i].saved.a, en.fade[i].rate) if .A in en.fade[i].comps else prop.a
          }
          else
          {
            prop.r = en.fade[i].saved.r if .R in en.fade[i].comps else prop.r
            prop.g = en.fade[i].saved.g if .G in en.fade[i].comps else prop.g
            prop.b = en.fade[i].saved.b if .B in en.fade[i].comps else prop.b
            prop.a = en.fade[i].saved.a if .A in en.fade[i].comps else prop.a
          }

          if .R not_in en.fade[i].comps || prop.r == en.fade[i].saved.r &&
             .G not_in en.fade[i].comps || prop.g == en.fade[i].saved.g &&
             .B not_in en.fade[i].comps || prop.b == en.fade[i].saved.b &&
             .A not_in en.fade[i].comps || prop.a == en.fade[i].saved.a
          {
            en.fade[i].state = .Hold
          }
        }
      }
    }

    // - Animate sprite ---
    switch v in en.animation.data[en.animation.state]
    {
    case Sprite_Name:
      en.sprite = v

    case Animation_Name:
      desc := &res.animations[v]

      if len(desc.frames) <= 0 do continue

      en.animation.duration -= dt
      if en.animation.duration <= 0
      {
        en.sprite = desc.frames[en.animation.frame_idx].sprite
        en.animation.duration = desc.frames[en.animation.frame_idx].duration * (1/en.animation.speed)

        if en.animation.reverse
        {
          if entity_animation_at_end(&en)
          {
            if en.animation.looping
            {
              en.animation.frame_idx = entity_animation_last_frame(&en)
            }
          }
          else
          {
            en.animation.frame_idx -= 1
          }
        }
        else
        {
          if entity_animation_at_end(&en)
          {
            if en.animation.looping
            {
              en.animation.frame_idx = 0
            }
          }
          else
          {
            en.animation.frame_idx += 1
          }
        }
      }
    }
  }

  // - Update particles ---
  for &par in gm.particles do if .Active in par.props
  {
    particle_update(&par, dt)
  }

  gm.prev_keys = platform.input.keys
  gm.prev_mouse_btns = platform.input.mouse_btns

  clear(&global.temp.noise_sources)
  free_finished_sounds()
  free_all(mem.allocator(&global.frame_arena))

  set_active_game(nil)
}

game_render :: proc(gm: ^Game)
{
  set_active_game(gm)

  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.transform_3x3f(-gm.camera.pos, gm.camera.rot, gm.camera.scl),
    projection = vmath.orthographic(0, VIEWPORT_WIDTH, 0, VIEWPORT_HEIGHT),
    viewport = user.viewport,
    clear_color = {0, 0, 0, 1},
    light_color = gm.light_color,
  })

  // - Draw region ---
  for tile_idx in 0..<len(gm.tiles)
  {
    tile := &gm.tiles[tile_idx]
    if tile.sprite != .Nil
    {
      pos := cast(v2f32) tile_coord_from_idx(tile_idx)
      pos *= TILE_SIZE
      // pos += ({REGION_SPAN, REGION_SPAN}) * v2f32(region_coord)
      pos += {TILE_SIZE/2.0, TILE_SIZE/2.0}

      draw_sprite(tile.sprite, pos, scl={1.01, 1.01}, rot=f32(tile.rot))
    }
  }

  // TODO(dg): Have one array of render objects so that entities,
  //           particles, and other objects can be sorted together.

  @(static)
  en_targets: [MAX_ENTITIES]^Entity
  en_targets_cnt: int
  for i in 0..<MAX_ENTITIES do if gm.entities[i].flags.render
  {
    en_targets[en_targets_cnt] = &gm.entities[i]
    en_targets_cnt += 1
  }

  slice.stable_sort_by(en_targets[:en_targets_cnt], proc(i, j: ^Entity) -> bool {
    if i.z_layer == j.z_layer
    {
      return i.z_index < j.z_index
    }
    else
    {
      return i.z_layer < j.z_layer
    }
  })

  // slice.sort_by(en_targets[:en_targets_cnt], proc(i, j: ^Entity) -> bool {
  //   if i.z_layer == j.z_layer
  //   {
  //     return tt.global_pos(i).y < tt.global_pos(j).y
  //   }
  //   else
  //   {
  //     return i.z_layer < j.z_layer
  //   }
  // })

  // - Draw entities ---
  for en in en_targets[:en_targets_cnt]
  {
    flip: v2f32
    flip.x = -1 if .Flip_H in en.props else 1
    flip.y = -1 if .Flip_V in en.props else 1

    en_pos := tt.global_pos(en)
    en_scl := tt.global_scl(en)
    en_rot := tt.global_rot(en)

    draw_sprite(en.sprite, en_pos, en_scl * flip, en_rot, en.tint, en.color)
  }

  // - Draw particle ---
  for &par in gm.particles do if .Render in par.props
  {
    draw_sprite(par.sprite, par.pos, par.scl, par.rot, par.tint, par.color)
  }

  // - Draw debug entities ---
  if global.debug.enabled
  {
    for &den in gm.debug_entities do if den.flags.render
    {
      den_pos := tt.global_pos(den)
      den_scl := tt.global_scl(den)
      den_rot := tt.global_rot(den)

      draw_sprite(den.sprite, den_pos, den_scl, den_rot, den.tint, den.color)
    }
  }

  render.end_pass()

  set_active_game(nil)
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  game_copy(res_gm, curr_gm)

  if !curr_gm.interpolate do return

  curr_tt := &curr_gm.transform_tree
  prev_tt := &prev_gm.transform_tree

  res_gm.camera.pos = vmath.lerp(prev_gm.camera.pos, curr_gm.camera.pos, alpha)

  // - Interpolate entities ---
  for i in 1..<len(res_gm.entities)
  {
    curr_en := &curr_gm.entities[i]
    prev_en := &prev_gm.entities[i]

    if curr_en.gen == prev_en.gen && curr_en.flags.interpolate
    {
      lerped_pos := vmath.lerp(tt.global_pos(prev_en, prev_tt), tt.global_pos(curr_en, curr_tt), alpha)
      tt.set_global_pos(res_gm.entities[i], lerped_pos, &res_gm.transform_tree)
      
      lerped_scl := vmath.lerp(tt.global_scl(prev_en, prev_tt), tt.global_scl(curr_en, curr_tt), alpha)
      tt.set_global_scl(res_gm.entities[i], lerped_scl, &res_gm.transform_tree)

      lerped_rot := vmath.lerp_angle(tt.global_rot(prev_en, prev_tt), tt.global_rot(curr_en, curr_tt), alpha)
      tt.set_global_rot(res_gm.entities[i], lerped_rot, &res_gm.transform_tree)
    }
  }

  // - Interpolate debug entities ---
  if global.debug.enabled
  {
    for i in 0..<len(res_gm.debug_entities)
    {
      curr_den := &curr_gm.debug_entities[i]
      prev_den := &prev_gm.debug_entities[i]

      if entity_is_same(curr_den^, prev_den^) && curr_den.flags.interpolate
      {
        lerped_pos := vmath.lerp(tt.global_pos(prev_den, prev_tt), tt.global_pos(curr_den, curr_tt), alpha)
        tt.set_global_pos(res_gm.debug_entities[i], lerped_pos, &res_gm.transform_tree)
        
        lerped_scl := vmath.lerp(tt.global_scl(prev_den, prev_tt), tt.global_scl(curr_den, curr_tt), alpha)
        tt.set_global_scl(res_gm.debug_entities[i], lerped_scl, &res_gm.transform_tree)

        lerped_rot := vmath.lerp_angle(tt.global_rot(prev_den, prev_tt), tt.global_rot(curr_den, curr_tt), alpha)
        tt.set_global_rot(res_gm.debug_entities[i], lerped_rot, &res_gm.transform_tree)
      }
    }
  }

  // - Interpolate particles ---
  for i in 0..<len(res_gm.particles)
  {
    curr_par := &curr_gm.particles[i]
    prev_par := &prev_gm.particles[i]

    if curr_par.gen == prev_par.gen && curr_par.props >= {.Active, .Interpolate} && prev_par.props >= {.Active}
    {
      res_gm.particles[i].pos = vmath.lerp(prev_par.pos, curr_par.pos, alpha)
      res_gm.particles[i].scl = vmath.lerp(prev_par.scl, curr_par.scl, alpha)
      res_gm.particles[i].rot = vmath.lerp_angle(prev_par.rot, curr_par.rot, alpha)
    }
  }
}

update_debug_gui :: proc(gm: ^Game, dt: f32)
{
  set_active_game(gm)

  if true
  {
    imgui.Begin("General")

    cursor_pos := platform.get_cursor_position()
    player := gm.special_entities[.Player]
    player_pos := tt.global_pos(player)

    imgui.Text("Time elapsed: %.f s", gm.t)
    imgui.Text("Time delta: %.4f s", dt)

    imgui.PushID("Time multiplier")
    imgui.PushItemWidth(85)
    imgui.Text("Time multiplier:"); imgui.SameLine()
    imgui.InputFloat("", &gm.t_mult, 0.1, format="%.2f")
    gm.t_mult = clamp(gm.t_mult, 0, 3)
    imgui.PopItemWidth()
    imgui.PopID()

    imgui.Spacing()

    world_pos := screen_to_world_space(cursor_pos)
    imgui.Text("Cursor (Screen): (%.f, %.f)", cursor_pos.x, cursor_pos.y)
    imgui.Text("Cursor (World): (%.f, %.f)", world_pos.x, world_pos.y)
    imgui.Text("Zone: %s", res.zones[gm.active_zone].name)
    imgui.Text("Coordinates: (%.f, %.f)", player_pos.x, player_pos.y)

    imgui.Spacing()
    diff := time.tick_diff(update_start_tick, update_end_tick)
    update_durr_ms := time.duration_milliseconds(diff)
    imgui.Text("Update: %.3f ms", update_durr_ms)
    diff = time.tick_diff(render_start_tick, render_end_tick)
    render_durr_ms := time.duration_milliseconds(diff)
    imgui.Text("Render: %.3f ms", render_durr_ms)
    total_durr_ms := update_durr_ms + render_durr_ms
    imgui.Text(" Total: %.3f ms", total_durr_ms)
    imgui.Text("   FPS: %.f", 1.0/(total_durr_ms/1000))
    imgui.Spacing()

    imgui.PushID("Music volume")
    imgui.PushItemWidth(85)
    imgui.Text("Music volume:"); imgui.SameLine()
    imgui.InputFloat("", &global.audio.music_volume, 0.1, format="%.2f")
    global.audio.music_volume = clamp(global.audio.music_volume, 0, 10)
    imgui.PopItemWidth()
    imgui.PopID()

    imgui.Spacing()

    imgui.Checkbox("Show debug", &global.debug.enabled)
    imgui.Checkbox("Silence noise", &global.debug.silence_noise)
    if imgui.Button("Spawn deer")
    {
      if gm.entities_cnt < len(gm.entities)
      {
        spawn_creature(.Deer, tt.global_pos(player), deferred=true)
      }
    }

    imgui.End()
  }

  if true
  {
    imgui.Begin("Entity Inspector")

    en := entity_from_ref(global.debug.target_entity)

    imgui.Text("Ref:   [idx=%u, gen=%u]", en.ref.id, en.ref.gen)

    imgui.PushID("Pos")
    imgui.Text("Pos:  "); imgui.SameLine()
    imgui.InputFloat2("", &tt.local(en).pos)
    imgui.PopID()

    imgui.PushID("Rot")
    imgui.Text("Rot:  "); imgui.SameLine()
    imgui.InputFloat("", &tt.local(en).rot)
    imgui.PopID()

    imgui.PushID("Scale")
    imgui.Text("Scale:"); imgui.SameLine()
    imgui.InputFloat2("", &tt.local(en).scale)
    imgui.PopID()

    imgui.PushID("Vel")
    imgui.Text("Vel:  "); imgui.SameLine()
    imgui.InputFloat2("", &en.vel)
    imgui.PopID()

    imgui.PushID("Speed")
    imgui.Text("Speed:"); imgui.SameLine()
    imgui.InputFloat("", &en.movement_speed)
    imgui.PopID()

    imgui.PushID("State")
    imgui.Text("State: "); imgui.SameLine()
    text := strings.clone_to_cstring(reflect.enum_string(en.state))
    imgui.Text(text)
    delete(text)
    imgui.PopID()

    imgui.End()
  }

  set_active_game(nil)
}

camera_follow_point :: proc(point: v2f32, bounds: [2]Range(f32))
{
  gm := get_active_game()

  point := point
  point -= v2f32{VIEWPORT_WIDTH, VIEWPORT_HEIGHT}/2

  bounds := bounds
  bounds.x.max -= VIEWPORT_WIDTH
  bounds.y.max -= VIEWPORT_HEIGHT

  gm.camera.pos = range_clamp(point, bounds)
}

screen_to_world_space :: proc(pos: v2f32) -> (result: v2f32)
{
  gm := get_active_game()

  result = {
    (pos.x - user.viewport.x) * (VIEWPORT_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (VIEWPORT_HEIGHT / user.viewport.w),
  }

  return result + gm.camera.pos
}

Noise_Source :: struct
{
  value: f32,
  pos:   v2f32,
}

emit_noise :: proc(value: f32, pos: v2f32)
{
  if !global.debug.silence_noise
  {
    append(&global.temp.noise_sources, Noise_Source{value, pos})
  }
}

noise_at :: proc(pos: v2f32) -> (value: f32)
{
  for source in global.temp.noise_sources
  {
    K :: 5.0
    dist := vmath.distance(pos, source.pos)
    value += max(source.value - dist/K, 0)
  }

  return
}

noise_at__test :: proc(pos: v2f32, val: f32, pos2: v2f32) -> (value: f32)
{
  K :: 5.0
  dist := vmath.distance(pos, pos2)
  value += max(val - dist/K, 0)
  return
}

// TODO(dg): Should be deferred until the start of the next frame.
set_active_zone :: proc(zone: Zone_Name, regen := false)
{
  gm := get_active_game()
  player := gm.special_entities[.Player]

  curr_zone := gm.active_zone
  gm.active_zone = zone

  if player != nil
  {
    tt.set_global_pos(player, {30, 30})
  }

  // TODO(dg): Only touch active entities?
  for &en in gm.entities do if entity_is_valid(en)
  {
    switch en.flags.zone_change_op
    {
    case .Reset:
      free_entity(gm, &en)

    case .Persist:
      panic("[game]: Zone change operation 'Persist' not yet implemented!")

    case .Move:
      continue
    }
  }

  // generate zone
  if curr_zone != zone || regen
  {
    switch zone
    {
    case .Wilderness:
      generate_wilderness()
    case .Shop:
      generate_shop()
    }

    log.infof("[game]: Set active zone to '%s'.\n", zone)
  }
}

harvest_entity :: proc(en: ^Entity)
{
  gm := get_active_game()
  // gm.player_inventory.items[.Flower] += 1
  item := roll_loot_table(en.loot_table)
  spawn_item(item, tt.global_pos(en))
  kill_entity(en)
}


// Entity ////////////////////////////////////////////////////////////////////////////////


MAX_ENTITIES  :: 10000

Entity :: struct
{
  ref:               Entity_Ref,
  gen:               u32,
  parent:            Entity_Ref,
  children:          [4]Entity_Ref,
  flags:             bit_field u8
  {
    update:          bool | 1,
    render:          bool | 1,
    interpolate:     bool | 1,
    zone_change_op:  enum{Reset, Persist, Move} | 3,
  },
  props:             bit_set[Entity_Prop],
  name:              Entity_Name,
  kind:              Entity_Kind,
  item_kind:         Item_Kind,
  #subtype xform:    tt.Transform,
  vel:               v2f32,
  input_dir:         v2f32,
  movement_speed:    f32,
  health:            i32,
  tint:              v4f32,
  color:             v4f32,
  sprite:            Sprite_Name,
  collider:          Shape,
  collision_layer:   Collision_Layer,
  resolve_collision: proc(this, other: ^Entity, action: enum{Enter, Stay, Exit}),
  z_index:           i16,
  z_layer:           enum{Base, Enemy, Player, Projectile},
  attack_timer:      Timer,
  death_timer:       Timer,
  hurt_grace_timer:  Timer,
  flee_timer:        Timer,
  flash_color_timer: Timer,
  flash_color:       v4f32,
  state:             Entity_State,
  state_data:        Entity_State_Data,
  update_state:      proc(this: ^Entity, ctx: ^Entity_State_Context),
  animation:         struct
  {
    data:            [Animation_State]Sprite_Or_Animation,
    state:           Animation_State,
    next_state:      Animation_State,
    speed:           f32,
    duration:        f32,
    frame_idx:       u16,
    reverse:         bool,
    looping:         bool,
  },
  distort:           [2]struct
  {
    saved:           f32,
    target:          f32,
    rate:            f32,
    state:           enum{Hold, Distort, Return},
  },
  fade:              [2]struct
  {
    saved:           v4f32,
    target:          v4f32,
    rate:            f32,
    state:           enum{Hold, Fade, Return},
    comps:           bit_set[enum{R, G, B, A}],
  },
  equipped:          struct
  {
    weapon_kind:     Weapon_Kind,
    muzzle_timer:    Timer,
  },
  shot_point:        tt.Transform,
  loot_table:        Loot_Table_Name,
  target_entity:     Entity_Ref,
}

Entity_Ref :: struct
{
  id:  u32,
  gen: u32,
}

Entity_Prop :: enum
{
  Marked_For_Spawn,
  Marked_For_Death,
  Interpolate,
  Flip_H,
  Flip_V,
  Kill_After_Time,
  Rotate_Over_Time,
  Flash_Color,
  Collectable,
  Highlighted,
  Sneaking,
  Flee_Noise,
  Hostile,
  Harvesting,
}

Entity_State :: enum
{
  Idle,
  Bob,
  Expand,
  Wander,
  Flee,
  Pursue,
}

Entity_State_Data :: struct #raw_union
{
  idle:           struct{},
  expand:         struct{},
  bob:            struct
  {
    state:        enum{Up, Down},
    displacement: f32,
  },
  wander:         struct
  {
    state:        enum{Choose, Move, Wait},
    point:        v2f32,
    wait_timer:   Timer,
  },
  flee:           struct
  {
    state:        enum{Choose, Move},
    point:        v2f32,
    count:        int,
  },
  pursue:         struct{},
}

Entity_State_Context :: struct
{
  dt: f32,
}

Collision_Layer :: enum
{
  Nil,
  Player,
  Player_Projectile,
  Enemy,
  Item,
}

Entity_Kind :: enum
{
  Other,
  Creature,
  Projectile,
}

Weapon_Kind :: enum
{
  Nil,
  Revolver,
  Rifle,
}

Item_Kind :: enum
{
  Nil,
  Venison,
  Rabbit_Foot,
  Squirrel_Tail,
  Chamomile,
  Sunflower,
  Lavender,
  Brown_Mushroom,
  Red_Mushroom,
}

@(rodata)
NIL_ENTITY: Entity

@(rodata)
COLLISION_MATRIX: [Collision_Layer]bit_set[Collision_Layer] = {
  .Nil               = {},
  .Player            = {.Item},
  .Player_Projectile = {.Enemy},
  .Enemy             = {.Player_Projectile},
  .Item              = {.Player},
}

entity_is_valid :: proc
{
  entity_valid_val,
  entity_valid_ptr,
}

entity_valid_val :: #force_inline proc(en: Entity) -> bool
{
  return en.ref.id != 0
}

entity_valid_ptr :: #force_inline proc(en: ^Entity) -> bool
{
  return en != nil && en.ref.id != 0
}

entity_is_same :: #force_inline proc(en_a, en_b: $E/Entity) -> bool
{
  return en_a.ref.id == en_b.ref.id && en_a.gen == en_b.gen
}

entity_from_ref :: proc(ref: Entity_Ref) -> (^Entity, bool) #optional_ok
{
  gm := get_active_game()
  en := &gm.entities[ref.id]

  if ref.id != 0 && ref.gen == en.gen
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
    if en.ref.id == 0
    {
      en.ref.id = cast(u32) i + 1
      en.ref.gen = en.gen
      en.xform = tt.alloc_transform(&gm.transform_tree)
      en.resolve_collision = entity_resolve_collision_stub
      en.update_state = entity_state_stub

      result = &en

      gm.entities_cnt += 1
      break
    }
  }

  return result
}

free_entity :: proc(gm: ^Game, en: ^Entity)
{
  if !entity_is_valid(en) do return

  tt.free_transform(&gm.transform_tree, en.xform)
  gen := en.gen
  en^ = {}
  en.gen = gen + 1

  gm.entities_cnt -= 1
}

defer_entity_spawn :: proc(en: ^Entity)
{
  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  dfs_stack: [dynamic]Entity_Ref
  dfs_stack.allocator = mem.allocator(scratch)

  append(&dfs_stack, en.ref)

  for node in dfs_stack
  {
    node := entity_from_ref(node) or_continue
    node.flags.update = false
    node.flags.render = false
    node.props += {.Marked_For_Spawn}

    for child in node.children
    {
      if entity_is_valid(entity_from_ref(child))
      {
        append(&dfs_stack, child)
      }
    }
  }
}

kill_entity :: proc(en: ^Entity, kill_children := true)
{
  en.props += {.Marked_For_Death}

  if kill_children
  {
    for child_ref in en.children
    {
      child := entity_from_ref(child_ref) or_continue
      child.props += {.Marked_For_Death}
    }
  }
}

setup_entity :: proc(en: ^Entity, deferred: bool)
{
  en.tint = {1, 1, 1, 1}

  if deferred
  {
    defer_entity_spawn(en)
  }
  else
  {
    en.flags.update = true
    en.flags.render = true
  }
}

spawn_player :: proc() -> ^Entity
{
  gm := get_active_game()

  player := alloc_entity(gm)
  setup_entity(player, true)

  desc := &res.entities[.Player]

  player.name = .Player
  player.z_layer = .Player
  player.props += {.Interpolate}
  player.movement_speed = res.creatures[.Player].speed
  player.animation.data = desc.animations
  player.collision_layer = .Player
  player.collider = desc.collider
  player.resolve_collision = entity_resolve_collision_player

  spawn_shadow(player, .Shadow_1, {0, -0.5})

  // - Weapon ---
  {
    weapon := alloc_entity(gm)
    setup_entity(weapon, false)

    weapon.props += {.Interpolate}
    weapon.z_layer = .Player
    weapon.z_index = 1
    weapon.shot_point = tt.alloc_transform(&gm.transform_tree, weapon)

    tt.set_parent(weapon, player)

    // - Muzzle flash ---
    {
      muzzle_flash := alloc_entity(gm)
      setup_entity(muzzle_flash, false)

      muzzle_flash.props += {.Interpolate}
      muzzle_flash.z_layer = .Player
      muzzle_flash.z_index = 2
      muzzle_flash.flags.render = false
      muzzle_flash.animation.data[.Idle] = .Muzzle_Flash

      tt.set_parent(muzzle_flash, weapon)
      entity_attach_child(weapon, muzzle_flash)
    }

    entity_attach_child(player, weapon)
  }

  entity_set_zone_change_op(player, .Move)

  gm.special_entities[.Player] = player

  return player
}

spawn_entity :: proc(
  name: Entity_Name, 
  pos: v2f32, 
  sprite := Sprite_Name.Nil,
  deferred := false, 
) -> (
  ^Entity,
){
  gm := get_active_game()

  en := alloc_entity(gm)
  setup_entity(en, deferred)

  en.name = name
  en.props = res.entities[name].props
  en.animation.data = res.entities[name].animations
  en.collider = res.entities[name].collider
  en.loot_table = res.entities[name].loot_table

  if sprite != .Nil
  {
    en.sprite = sprite
  }

  tt.local(en).pos = pos

  return en
}

spawn_creature :: proc(name: Entity_Name, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_active_game()

  creature := alloc_entity(gm)
  setup_entity(creature, deferred)

  desc := &res.entities[name]

  creature.name = name
  creature.kind = desc.kind
  creature.props += {.Interpolate} + desc.props
  creature.z_layer = .Enemy
  creature.collision_layer = .Enemy
  creature.resolve_collision = entity_resolve_collision_creature
  creature.health = res.creatures[name].health
  creature.animation.data = desc.animations
  creature.collider = desc.collider

  tt.local(creature).pos = pos

  #partial switch name
  {
  case .Nil:
  
  case .Zombie:
    entity_set_state(creature, .Pursue)
    spawn_shadow(creature, .Shadow_1, {0, -0.5})

  case .Deer:
    entity_set_state(creature, .Wander)
    spawn_shadow(creature, .Shadow_3, {0, -1.5})

  case .Rabbit:
    entity_set_state(creature, .Wander)
    spawn_shadow(creature, .Shadow_2, {0.5, -1.5})

  case .Squirrel:
    entity_set_state(creature, .Idle)
    spawn_shadow(creature, .Shadow_1, {-0.5, -1.5})
  }

  return creature
}

spawn_projectile :: proc(name: Entity_Name, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_active_game()

  projectile := alloc_entity(gm)
  setup_entity(projectile, deferred)

  projectile.name = name
  projectile.kind = res.entities[name].kind
  projectile.props += {.Interpolate, .Kill_After_Time}
  projectile.z_layer = .Projectile
  projectile.animation.data[.Idle] = .Bullet
  projectile.collision_layer = .Player_Projectile
  projectile.resolve_collision = entity_resolve_collision_projectile
  projectile.collider = res.entities[name].collider

  tt.local(projectile).pos = pos

  return projectile
}

spawn_item :: proc(kind: Item_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_active_game()

  item := alloc_entity(gm)
  setup_entity(item, deferred)

  desc := &res.items[kind]

  item.name = .Item
  item.item_kind = kind
  item.props += {.Interpolate}
  item.z_index = 100
  item.collision_layer = .Item
  item.animation.data = desc.animations
  item.resolve_collision = entity_resolve_collision_item
  item.collider = res.entities[.Item].collider

  tt.local(item).pos = pos

  entity_set_state(item, .Bob)

  return item
}

spawn_corpse :: proc(owner: ^Entity, deferred := false) -> ^Entity
{
  gm := get_active_game()
  corpse := alloc_entity(gm)
  setup_entity(corpse, deferred)

  corpse.props += {.Interpolate}
  corpse.props += owner.props & {.Flip_H}
  corpse.animation.data[.Idle] = res.creatures[owner.name].corpse

  tt.local(corpse).pos = tt.global_pos(owner) + {0, 0}

  // - Blood pool ---
  {
    blood_pool := spawn_entity(res.creatures[owner.name].blood_pool, {0, 0}, deferred=deferred)
    blood_pool.props += {.Interpolate}
    blood_pool.z_index = -1
    blood_pool.collision_layer = .Item

    entity_play_animation(blood_pool, .Expand, looping=false)

    entity_attach_child(corpse, blood_pool)
    tt.attach_child(corpse, blood_pool)
  }

  return corpse
}

spawn_shadow :: proc(owner: ^Entity, sprite: Sprite_Name, offet: v2f32, deferred := false) -> ^Entity
{
  gm := get_active_game()

  shadow := alloc_entity(gm)
  setup_entity(shadow, deferred)

  shadow.props += {.Interpolate}
  shadow.color = {0.2, 0.2, 0.2, 0}
  shadow.tint.a = 0.5
  shadow.animation.data[.Idle] = sprite
  shadow.z_index = -999
  tt.local(shadow).pos = offet

  tt.set_parent(shadow, owner)
  entity_attach_child(owner, shadow)

  return shadow
}

entity_attach_child :: proc(parent, child: ^Entity) -> (ok: bool)
{
  for &slot in parent.children
  {
    if slot.id == 0
    {
      slot = child.ref
      child.parent = parent.ref
      return true
    }
  }

  return false
}

entity_child_at :: proc(en: ^Entity, idx: int) -> (res: ^Entity, ok: bool)
{
  return entity_from_ref(en.children[idx])
}

entity_play_animation :: proc(
  en:      ^Entity,
  anim:    Animation_State,
  looping: bool,
  reverse: bool = false,
  speed:   f32 = 1.0,
){
  en.animation.next_state = anim
  en.animation.looping = looping
  en.animation.reverse = reverse
  en.animation.speed = speed
}

entity_resolve_collision_stub :: proc(_, _: ^Entity, _: enum{Enter, Stay, Exit}) {}

entity_resolve_collision_player :: proc(this, other: ^Entity, action: enum{Enter, Stay, Exit})
{
  if other.name == .Blood_Pool_M || other.name == .Blood_Pool_L
  {
    switch action
    {
    case .Enter:
      printf("%s enters blood pool.\n", this.name)

    case .Stay:
      printf("%s stays in blood pool.\n", this.name)

    case .Exit:
      printf("%s exits blood pool.\n", this.name)
    }
  }
}

entity_resolve_collision_creature :: proc(this, other: ^Entity, action: enum{Enter, Stay, Exit})
{
  assert(this.kind == .Creature)

  if action == .Enter
  {
    this.health -= 1

    if this.health == 0
    {
      kill_entity(this)

      item_kind := roll_loot_table(res.creatures[this.name].loot_table)
      if item_kind != .Nil
      {
        spawn_item(item_kind, tt.global_pos(this))
      }

      corpse := spawn_corpse(this)
      corpse.props += {.Flash_Color}
      corpse.flash_color = {1, 1, 1, 0}
      timer_start(&corpse.flash_color_timer, 0.05)
    }

    spawn_particles(.Hurt_Blood, tt.global_pos(this))

    this.props += {.Flash_Color}
    this.flash_color = {1, 1, 1, 0}
    timer_start(&this.flash_color_timer, 0.05)

    if .Flee_Noise in this.props
    {
      entity_set_state(this, .Flee)
    }
  }
}

entity_resolve_collision_projectile :: proc(this, other: ^Entity, action: enum{Enter, Stay, Exit})
{
  kill_entity(this)
}

entity_resolve_collision_item :: proc(this, other: ^Entity, action: enum{Enter, Stay, Exit})
{
  gm := get_active_game()
  gm.player_inventory.items[this.item_kind] += 1
  kill_entity(this)
}

entity_animation_last_frame :: proc(en: ^Entity) -> u16
{
  anim, ok := en.animation.data[en.animation.state].(Animation_Name)
  if ok
  {
    return cast(u16) len(res.animations[anim].frames) - 1
  }
  else
  {
    return 0
  }
}

entity_animation_at_end :: proc(en: ^Entity) -> bool
{
  return (!en.animation.reverse && en.animation.frame_idx == entity_animation_last_frame(en)) ||
         (en.animation.reverse && en.animation.frame_idx == 0)
}

entity_flip_vec :: proc(en: ^Entity) -> v2f32
{
  return {
    (.Flip_H in en.props) ? -1 : 1,
    (.Flip_V in en.props) ? -1 : 1,
  }
}

entity_flip_to_target :: proc(en: ^Entity, target: v2f32)
{
  weapon, ok := entity_child_at(en, 1)
  if !ok do return

  en_pos := tt.global_pos(en)
  if en_pos.x > target.x
  {
    if weapon != nil && .Flip_H not_in en.props
    {
      weapon.flags.interpolate = false
    }

    en.props += {.Flip_H}
  }
  else
  {
    if weapon != nil && .Flip_H in en.props
    {
      weapon.flags.interpolate = false
    }

    en.props -= {.Flip_H}
  }
}

entity_xform :: proc(en: ^Entity) -> m3f32
{
  top_left :: proc(en: ^Entity) -> v2f32
  {
    pivot := res.sprites[en.sprite].pivot
    dim := tt.local(en).scl * {16, 16}
    local_pos := vmath.rotation_2x2f(tt.local(en).rot) * (-dim * pivot.xy)
    return local_pos + tt.local(en).pos
  }

  result := vmath.scale_3x3f(tt.local(en).scl)
  result = vmath.rotation_3x3f(tt.local(en).rot) * result
  result = vmath.translation_3x3f(top_left(en)) * result
  return result
}

entity_collider_update :: proc(en: ^Entity, dt: f32)
{
  switch &collider in en.collider
  {
  case Circle:
    collider.origin = tt.global_pos(en) + res.entities[en.name].collider.(Circle).origin
    debug_circle(collider.origin, collider.radius, alpha=0.25)

  case Polygon:
    col_desc := res.entities[en.name].collider.(Polygon)
    for i in 0..<len(collider.vertices)
    {
      v := entity_xform(en) * vmath.concat(col_desc.vertices[i], 1)
      collider.vertices[i] = v.xy
    }

    for vert in collider.vertices[:len(collider.vertices)]
    {
      debug_circle(vert, 1, color={0, 1, 0, 0}, alpha=0.75)
    }
  }
}

entity_move_to_point :: proc(en: ^Entity, p: v2f32, speed: f32, flip := true) -> bool
{
  pos := tt.global_pos(en)
  new_pos := move_to_point(pos, p, speed)
  tt.set_global_pos(en, new_pos)

  if flip
  {
    if pos.x > p.x
    {
      en.props += {.Flip_H}
    }
    else
    {
      en.props -= {.Flip_H}
    }
  }

  return new_pos == p
}

entity_distort :: proc(en: ^Entity, axis: enum{Width, Height}, target, rate: f32)
{
  en.distort[axis].saved = tt.local(en).scl.x
  en.distort[axis].target = target
  en.distort[axis].rate = rate
  en.distort[axis].state = .Distort
}

entity_start_fade :: proc(en: ^Entity, prop: enum{Color, Tint}, comps: bit_set[enum{R, G, B, A}], target: v4f32, rate: f32)
{
  en.fade[prop].saved = (prop == .Color) ? en.color : en.tint
  en.fade[prop].target = target
  en.fade[prop].rate = rate
  en.fade[prop].state = .Fade
  en.fade[prop].comps = comps
}

entity_stop_fade :: proc(en: ^Entity, prop: enum{Color, Tint})
{
  en.fade[prop].state = .Return
}

entity_equip_weapon :: proc(en: ^Entity, kind: Weapon_Kind)
{
  if !entity_is_valid(en) do return

  weapon, ok := entity_child_at(en, 1)
  if !ok do return

  weapon.animation.data[.Idle] = res.weapons[kind].sprite
  weapon.flags.render = kind != .Nil

  gm := get_active_game()
  gm.weapon.kind = kind

  if kind != .Nil
  {
    entity_holster_weapon(en, true)
  }
  else
  {
    gm.weapon.holstered = true
    en.equipped.weapon_kind = kind
  }
}

entity_holster_weapon :: proc(en: ^Entity, holster: bool)
{
  if !entity_is_valid(en) do return

  gm := get_active_game()
  gm.weapon.holstered = holster

  weapon, ok := entity_child_at(en, 1)
  if !ok do return

  if gm.weapon.kind != .Nil
  {
    if holster
    {
      en.equipped.weapon_kind = .Nil
      weapon.z_layer = .Base
    }
    else
    {
      en.equipped.weapon_kind = gm.weapon.kind
      weapon.z_layer = .Player
    }
  }
}

entity_set_zone_change_op :: proc(en: ^Entity, op: type_of(Entity{}.flags.zone_change_op))
{
  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  dfs_stack: [dynamic]Entity_Ref
  dfs_stack.allocator = mem.allocator(scratch)

  append(&dfs_stack, en.ref)

  for node in dfs_stack
  {
    node := entity_from_ref(node) or_continue
    node.flags.zone_change_op = op

    for child in node.children
    {
      if entity_is_valid(entity_from_ref(child))
      {
        append(&dfs_stack, child)
      }
    }
  }
}

entity_set_state :: proc(en: ^Entity, st: Entity_State, reset := false)
{
  if en.state != st || reset
  {
    en.state_data = {}
  }

  en.state = st

  switch en.state
  {
  case .Idle:   en.update_state = entity_state_idle
  case .Bob:    en.update_state = entity_state_bob
  case .Expand:
  case .Wander: en.update_state = entity_state_wander
  case .Flee:   en.update_state = entity_state_flee
  case .Pursue: en.update_state = entity_state_pursue
  }
}

entity_state_stub :: proc(this: ^Entity, ctx: ^Entity_State_Context) {}

entity_state_idle :: proc(this: ^Entity, ctx: ^Entity_State_Context)
{
  entity_play_animation(this, .Idle, looping=true)
}

entity_state_wander :: proc(en: ^Entity, ctx: ^Entity_State_Context)
{
  assert(ctx != nil)

  gm := get_active_game()
  creature_desc := &res.creatures[en.name]
  wander := &en.state_data.wander
  en_pos := tt.global_pos(en)

  switch wander.state
  {
  case .Choose:
    point: [2]f32
    attempts: int
    for attempts < 100
    {
      point = cast(v2f32) rand.range_2i32(creature_desc.wander_range)
      point.x *= -1 if rand.boolean() else 1
      point.y *= -1 if rand.boolean() else 1
      point += en_pos

      if point_in_zone_bounds(point, gm.active_zone) do break

      attempts += 1
    }

    if attempts >= 100
    {
      log.warn("[game]: Maximum attempts reached at selecting creature wander point!\n")
      point = wander.point
    }

    wander.point = point
    wander.state = .Move

  case .Move:
    entity_play_animation(en, .Walk, looping=true)
    debug_circle(wander.point, 1, color={0, 0, 1, 0})

    arrived := entity_move_to_point(en, wander.point, creature_desc.speed*ctx.dt)
    if arrived
    {
      wander.state = .Wait
    }

  case .Wait:
    entity_play_animation(en, .Idle, looping=true)

    if !wander.wait_timer.ticking
    {
      duration := rand.range_f32({0.5, 5})
      timer_start(&wander.wait_timer, duration)
    }

    if timer_timeout(&wander.wait_timer)
    {
      wander.wait_timer.ticking = false
      wander.state = .Choose
    }
  }
}

entity_state_flee :: proc(en: ^Entity, ctx: ^Entity_State_Context)
{
  assert(ctx != nil)

  gm := get_active_game()
  creature_desc := &res.creatures[en.name]
  flee := &en.state_data.flee
  en_pos := tt.global_pos(en)

  FLEE_SPEED_MULT :: 2.5

  switch flee.state
  {
  case .Choose:
    point: [2]f32
    for
    {
      point = cast(v2f32) rand.range_2i32(creature_desc.flee_range)
      point.x *= -1 if rand.boolean() else 1
      point.y *= -1 if rand.boolean() else 1
      point += en_pos

      if point_in_zone_bounds(point, gm.active_zone) do break
    }

    flee.point = point
    flee.state = .Move

  case .Move:
    speed := creature_desc.speed * FLEE_SPEED_MULT * ctx.dt
    arrived := entity_move_to_point(en, flee.point, speed)
    if arrived
    {
      flee.count += 1
      if flee.count == 3
      {
        entity_set_state(en, .Wander)
        break
      }
      else
      {
        flee.state = .Choose
      }
    }

    entity_play_animation(en, .Walk, looping=true, speed=speed)
  }
}

entity_state_pursue :: proc(en: ^Entity, ctx: ^Entity_State_Context)
{
  assert(ctx != nil)

  gm := get_active_game()
  creature_desc := &res.creatures[en.name]

  target, ok := entity_from_ref(en.target_entity)
  if !ok 
  {
    entity_set_state(en, .Wander)
    return
  }

  speed := creature_desc.speed * ctx.dt
  arrived := entity_move_to_point(en, tt.global_pos(target), speed)
  if arrived
  {
    println("HI!")
  }

  entity_play_animation(en, .Walk, looping=true, speed=speed)
}

entity_state_bob :: proc(this: ^Entity, ctx: ^Entity_State_Context)
{
  SPEED :: 4.0
  DISPLACEMENT :: 1.0

  bob := &this.state_data.bob
  dy := SPEED * ctx.dt

  switch bob.state
  {
  case .Up:
    tt.local(this).pos.y -= dy
    bob.displacement += dy
    if bob.displacement >= DISPLACEMENT
    {
      bob.state = .Down
    }

  case .Down:
    tt.local(this).pos.y += dy
    bob.displacement -= dy
    if bob.displacement <= -DISPLACEMENT
    {
      bob.state = .Up
    }
  }
}

roll_loot_table :: proc(loot_table: Loot_Table_Name) -> Item_Kind
{
  result: Item_Kind

  for entry in res.loot_tables[loot_table]
  {
    if entry.rate != 0.0
    {
      result = entry.item
      break
    }
  }

  return result
}


// Zone ///////////////////////////////////////////////////////////////////////////////////


TILE_SIZE        :: 8
ZONE_MARGIN_SIZE :: TILE_SIZE * 2
MAX_ZONE_TILES   :: 128 * 128

Zone_Name :: enum
{
  Shop,
  Wilderness,
}

Zone_Desc :: struct
{
  name:   string,
  width:  int,
  height: int,
}

Tile :: struct
{
  sprite: Sprite_Name,
  rot:    f16,
}

Tile_Coord :: distinct [2]f32

tile_idx_from_coord :: proc(coord: Tile_Coord) -> int
{
  gm := get_active_game()
  zone := res.zones[gm.active_zone]
  return int(coord.x + (coord.y * f32(zone.width / TILE_SIZE)))
}

tile_coord_from_idx :: proc(idx: int) -> Tile_Coord
{
  gm := get_active_game()
  zone := res.zones[gm.active_zone]
  return {f32(idx % (zone.width / TILE_SIZE)), f32(idx / (zone.width / TILE_SIZE))}
}

point_in_zone_bounds :: proc(point: v2f32, region: Zone_Name) -> bool
{
  gm := get_active_game()
  zone := res.zones[gm.active_zone]

  bounds := [2]Range(f32) {
    {0, f32(zone.width)},
    {0, f32(zone.height)},
  }

  return point_in_bounds(point, bounds)
}

generate_clump :: proc(kinds: []Entity_Name, count, radius: i32)
{
  gm := get_active_game()
  zone := res.zones[gm.active_zone]

  radius := min(radius, i32(zone.width/2), i32(zone.height/2))

  bounds := [2]Range(i32){
    {radius, i32(zone.width) - radius},
    {radius, i32(zone.height) - radius},
  }
  origin := rand.range_2i32(bounds)

  for _ in 0..<count
  {
    offset := rand.range_2i32({{-radius, radius}, {-radius, radius}})
    entity := spawn_entity(rand.choice_slice(kinds[:]), v2f32(origin + offset))
  }
}

generate_wilderness :: proc()
{
  gm := get_active_game()
  zone := res.zones[.Wilderness]
  size := zone.width / TILE_SIZE * zone.height / TILE_SIZE

  mem.zero(&gm.tiles[0], size_of(gm.tiles))

  for tile_idx in 0..<len(gm.tiles[:size])
  {
    sprite: Sprite_Name

    roll := rand.range_i32({1, 50})
    switch roll
    {
    case 1:
      sprite = .Tile_Grass_2
    case 2:
      sprite = .Tile_Grass_3
    case:
      sprite = .Tile_Grass_1
    }

    gm.tiles[tile_idx].sprite = sprite

    @(static)
    rotations := [4]f16{0, math.PI/2, math.PI, 3*math.PI/2}
    gm.tiles[tile_idx].rot = rotations[rand.range_i32({0, 3})]
  }

  for _ in 0..<8
  {
    @(static)
    grasses := [?]Entity_Name{.Grass}
    generate_clump(grasses[:], 16, 32)
  }

  for _ in 0..<4
  {
    @(static)
    lavenders := [?]Entity_Name{.Lavender}
    generate_clump(lavenders[:], 8, 16)
  }

  for _ in 0..<4
  {
    @(static)
    flowers := [?]Entity_Name{.Chamomile, .Sunflower}
    generate_clump(flowers[:], 8, 16)
  }

  for _ in 0..<64
  {
    bounds := [2]Range(f32){
      {0, f32(zone.width)},
      {0, f32(zone.height)},
    }

    pos := rand.range_2f32(bounds)
    choice := cast(Entity_Name) rand.range_i32({i32(Entity_Name.Chamomile), i32(Entity_Name.Red_Mushroom)})

    spawn_entity(choice, pos)
  }

  unpause_sound_group(.Ambience)
  // play_sound(.Forest_Ambience, volume=0.25)
}

generate_shop :: proc()
{
  gm := get_active_game()
  zone := res.zones[.Shop]

  mem.zero(&gm.tiles[0], size_of(gm.tiles))

  size := zone.width / TILE_SIZE * zone.height / TILE_SIZE
  for tile_idx in 0..<len(gm.tiles[:size])
  {
    sprite: Sprite_Name

    roll := rand.range_i32({1, 5})
    switch roll
    {
    case 1:
      sprite = .Tile_Plank_2
    case:
      sprite = .Tile_Plank_1
    }

    gm.tiles[tile_idx].sprite = sprite

    @(static)
    rotations := [?]f16{0}
    gm.tiles[tile_idx].rot = rotations[rand.range_i32({0, len(rotations)-1})]
  }

  pause_sound_group(.Ambience)
  reset_sound_group(.Ambience)
}


// Debug_Entity //////////////////////////////////////////////////////////////////////////

MAX_DEBUG_ENTITIES :: 512

Debug_Entity :: distinct Entity

push_debug_entity :: proc() -> ^Debug_Entity
{
  gm := get_active_game()

  result := &gm.debug_entities[gm.debug_entities_pos]
  result.flags.update = true
  result.flags.render = true
  result.props += {.Interpolate, .Marked_For_Death}

  tt.free_transform(&gm.transform_tree, result.xform)
  result.xform = tt.alloc_transform(&gm.transform_tree)

  gm.debug_entities_pos += 1
  if gm.debug_entities_pos == len(gm.debug_entities)
  {
    gm.debug_entities_pos = 0
  }

  return result
}

pop_debug_entity :: proc(den: ^Debug_Entity)
{
  gm := get_active_game()

  tt.free_transform(&gm.transform_tree, den.xform)
  den^ = {}
  gm.debug_entities_pos -= 1

  // NOTE(dg): This is not a good solution because it breaks interpolation.
  if gm.debug_entities_pos == -1
  {
    gm.debug_entities_pos = len(gm.debug_entities)-1
  }
}

debug_rect :: proc(
  pos:     v2f32,
  scale:   v2f32,
  color:   v4f32 = {1, 1, 1, 0},
  opacity: f32 = 0.5,
  sprite:  Sprite_Name = .Square,
) -> (
  ^Debug_Entity,
){
  result := push_debug_entity()
  tt.local(result).pos = pos
  tt.local(result).scale = scale
  result.color = color
  result.tint = {1, 1, 1, opacity}
  result.sprite = sprite

  return result
}

debug_circle :: proc(
  pos:    v2f32,
  radius: f32,
  color:  v4f32 = {0, 1, 0, 0},
  alpha:  f32 = 0.5,
) -> (
  ^Debug_Entity,
){
  result := push_debug_entity()
  tt.local(result).pos = pos
  tt.local(result).scl = {radius/8, radius/8}
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = .Circle

  return result
}


// Timer /////////////////////////////////////////////////////////////////////////////////


Timer :: struct
{
  end_time: f32,
  ticking:  bool,
}

timer_start :: proc(timer: ^Timer, duration: f32)
{
  timer.end_time = get_active_game().t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> bool
{
  return timer.ticking && get_active_game().t >= timer.end_time
}

timer_remaining :: proc(timer: ^Timer) -> f32
{
  return timer.end_time - get_active_game().t
}


// Input ///////////////////////////////////////////////////////////////////////////////////

key_down :: platform.key_down
key_up   :: platform.key_up

@(require_results)
key_just_down :: proc(key: platform.Key_Kind) -> bool
{
  return key_down(key) && !get_active_game().prev_keys[key]
}

@(require_results)
key_just_up :: proc(key: platform.Key_Kind) -> bool
{
  return key_up(key) && get_active_game().prev_keys[key]
}

mouse_btn_down :: platform.mouse_btn_down
mouse_btn_up   :: platform.mouse_btn_up

@(require_results)
mouse_btn_just_down :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_down(btn) && !get_active_game().prev_mouse_btns[btn]
}

@(require_results)
mouse_btn_just_up :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_up(btn) && get_active_game().prev_mouse_btns[btn]
}

input_down :: platform.input_down
input_up   :: platform.input_up

@(require_results)
input_just_down :: proc(input: platform.Input_Source) -> bool
{
  switch v in input
  {
  case platform.Key_Kind:       return key_just_down(v)
  case platform.Mouse_Btn_Kind: return mouse_btn_down(v)
  case:                         return false
  }
}

@(require_results)
input_just_up :: proc(input: platform.Input_Source) -> bool
{
  switch v in input
  {
  case platform.Key_Kind:       return key_just_up(v)
  case platform.Mouse_Btn_Kind: return mouse_btn_just_up(v)
  case:                         return false
  }
}
