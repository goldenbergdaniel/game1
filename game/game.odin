package game

import "core:math"
import "core:math/noise"
import "core:reflect"
import "core:slice"
import "core:time"

import imgui "ext:dear_imgui"
import fnl "ext:fast_noise_lite"
import "basic"
import "basic/mem"
import "basic/rand"
import vmath "basic/vector_math"
import "platform"
import "render"
import tt "transform_tree"

@(thread_local, private="file")
global: struct
{
  frame_arena:         mem.Arena,
  world_mem:           mem.Heap,
  debug_enabled:       bool,
  debug_target_entity: Entity_Ref,
  temp:                struct
  {
    noise_sources:     [dynamic]Noise_Source,
  },
}

init_global_game_memory :: proc()
{
  // WARN(dg): What if multiple games running on same thread? This needs to change.
  _ = mem.arena_init_growing(&global.frame_arena)
  _ = mem.heap_init(&global.world_mem, mem.default_allocator(), mem.MIB * 16)

  global.temp.noise_sources.allocator = mem.allocator(&global.frame_arena)

  fnl.noise_2d(fnl.State{}, expand_values([2]f32{1, 1}))
}

// Game //////////////////////////////////////////////////////////////////////////////////

Game :: struct
{
  t:                  f32,
  t_mult:             f32,
  interpolate:        bool,

  camera:             struct
  {
    pos:              f32x2,
    scl:              f32x2,
    rot:              f32,
  },
  regions:            [9][REGION_SPAN_TILES*REGION_SPAN_TILES]Tile,
  active_region:      Region_Coord,
  transform_tree:     tt.Transform_Tree,
  entities:           [MAX_ENTITIES]Entity,
  entities_cnt:       int,
  debug_entities:     [256]Debug_Entity,
  debug_entities_pos: int,
  particles:          [MAX_PARTICLES]Particle,
  particles_pos:      int,

  special_entities:   [enum{PLAYER}]^Entity,
  weapon:             struct
  {
    kind:             Weapon_Kind,
  },
}

@(thread_local, private="file")
_current_game: ^Game

current_game :: #force_inline proc() -> ^Game
{
  return _current_game
}

set_current_game :: #force_inline proc(gm: ^Game)
{
  _current_game = gm
  tt.global_tree = &gm.transform_tree
}

init_game :: proc(gm: ^Game)
{
  gm.transform_tree = tt.create_tree(MAX_ENTITIES-1, mem.allocator(&global.world_mem))
}

free_game :: proc(gm: ^Game)
{
  mem.arena_destroy(&global.frame_arena)
  mem.heap_destroy(&global.world_mem)
  tt.destroy_tree(&gm.transform_tree)
}

copy_game :: proc(dst, src: ^Game)
{
  dst_tree := dst.transform_tree
  dst^ = src^
  dst.transform_tree = dst_tree
  tt.copy_tree(&dst.transform_tree, &src.transform_tree)
}

start_game :: proc(gm: ^Game)
{
  set_current_game(gm)
  defer set_current_game(nil)

  gm.t_mult = 1
  gm.camera.scl = {1, 1}

  region: Region_Coord
  generate_world_region(gm)
  set_active_region(gm, region)

  player := spawn_player()
  tt.set_global_pos(player, region_pos_to_world_pos(WORLD_WIDTH/2, region))

  gm.special_entities[.PLAYER] = player

  for _ in 0..<9
  {
    spawn_creature(.DEER, region_pos_to_world_pos({200, 200}, region))
  }

  // play_sound(.MINECRAFT, volume=1)
}

update_game :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)
  defer set_current_game(nil)

  player := gm.special_entities[.PLAYER]
  cursor_pos := screen_to_world_space(platform.cursor_position())

  gm.interpolate = true

  // - Kill entities ---
  for &en in gm.entities do if (en.ref != {})
  {
    if .INTERPOLATE in en.props
    {
      en.flags.interpolate = true
    }

    if .MARKED_FOR_DEATH in en.props
    {
      free_entity(gm, &en)
    }
  }

  // - Kill debug entities ---
  for &den in gm.debug_entities
  {
    if .MARKED_FOR_DEATH in den.props
    {
      pop_debug_entity(&den)
    }
  }

  if !point_in_region_bounds(cursor_pos, gm.active_region)
  {
    debug_circle(cursor_pos, 4, {1, 0, 0, 0})
  }

  // printf("%.2f\n", noise_at_test(cursor_pos, 60, tt.global_pos(player)))

  // - Global keybinds ---
  {
    if platform.key_pressed(.ESCAPE)
    {
      user.window.should_close = true
    }

    if platform.key_just_pressed(.TAB) && !platform.key_pressed(.LEFT_CTRL)
    {
      user.show_dbgui = !user.show_dbgui
    }

    if platform.key_pressed(.LEFT_CTRL)
    {
      if platform.key_just_pressed(.ENTER)
      {
        platform.window_toggle_fullscreen(&user.window)
      }
      else if platform.key_just_pressed(.BACKTICK)
      {
        global.debug_enabled = !global.debug_enabled
      }
      else if platform.key_just_pressed(.S_1)
      {
        gm.t_mult = 1
      }
      else if platform.key_just_pressed(.S_2)
      {
        gm.t_mult = 0
      }
      else if platform.key_just_pressed(.S_3)
      {
        gm.t_mult = 0.25
      }
      else if platform.key_just_pressed(.S_4)
      {
        gm.t_mult = 0.5
      }
      else if platform.key_just_pressed(.S_5)
      {
        gm.t_mult = 2
      }
      else if platform.key_just_pressed(.P)
      {
        generate_world_region(gm)
      }
    }
    else
    {
      if platform.key_just_pressed(.Q)
      {
        if player.equipped.weapon_kind == .NIL
        {
          entity_equip_weapon(player, .RIFLE)
        }
        else
        {
          entity_equip_weapon(player, .NIL)
        }
      }
    }
  }

  // - Move region ---
  {
    region_pos := region_pos_to_world_pos({0, 0})
    relative_player_pos := tt.global_pos(player) - region_pos

    if gm.active_region.x < 2 && relative_player_pos.x > REGION_SPAN
    {
      // - Move right ---
      gm.active_region.x += 1
      // gm.camera.pos.x += WORLD_WIDTH - REGION_GAP
      gm.interpolate = false
    }
    else if gm.active_region.x > 0 && relative_player_pos.x < -0
    {
      // - Move left ---
      gm.active_region.x -= 1
      // gm.camera.pos.x -= WORLD_WIDTH - REGION_GAP
      gm.interpolate = false
    }

    if gm.active_region.y < 2 && relative_player_pos.y > REGION_SPAN
    {
      // - Move down ---
      gm.active_region.y += 1
      gm.camera.pos.y += WORLD_HEIGHT + REGION_GAP
      gm.interpolate = false
    }
    else if gm.active_region.y > 0 && relative_player_pos.y < -0
    {
      // - Move up ---
      gm.active_region.y -= 1
      gm.camera.pos.y -= WORLD_HEIGHT - REGION_GAP
      gm.interpolate = false
    }
  }

  // - Entity movement ---
  {
    // - Player movement ---
    {
      BACKWARD_MULT :: 0.7
      SNEAKING_MULT :: 0.5

      backward, sneaking: bool

      if platform.input_pressed(res.actions[.SNEAK])
      {
        player.props += {.SNEAKING}
        sneaking = true
      }
      else
      {
        player.props -= {.SNEAKING}
        sneaking = false
      }

      if platform.input_pressed(res.actions[.LEFT]) && !platform.input_pressed(res.actions[.RIGHT])
      {
        backward = cursor_pos.x > tt.local(player).pos.x
        player.input_dir.x = -1
      }
      else if platform.input_pressed(res.actions[.RIGHT]) && !platform.input_pressed(res.actions[.LEFT])
      {
        backward = cursor_pos.x < tt.local(player).pos.x
        player.input_dir.x = 1
      }
      else
      {
        player.vel.x = 0
        player.input_dir.x = 0
      }

      if platform.input_pressed(res.actions[.UP]) && !platform.input_pressed(res.actions[.DOWN])
      {
        player.input_dir.y = -1
      }
      else if platform.input_pressed(res.actions[.DOWN]) && !platform.input_pressed(res.actions[.UP])
      {
        player.input_dir.y = 1
      }
      else
      {
        player.vel.y = 0
        player.input_dir.y = 0
      }

      if player.input_dir.x != 0 || player.input_dir.y != 0
      {
        speed_mult: f32 = 1
        speed_mult *= backward ? BACKWARD_MULT : 1
        speed_mult *= sneaking ? SNEAKING_MULT : 1

        anim: Animation_State = sneaking ? .SNEAK_WALK : .WALK
        entity_play_animation(player, anim, speed=speed_mult, looping=true, reverse=backward)

        noise: f32 = sneaking ? 35 : 50
        emit_noise(noise, tt.local_position(player))

        player.movement_speed = res.player.speed * speed_mult
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
        anim: Animation_State = sneaking ? .SNEAK_IDLE : .IDLE
        entity_play_animation(player, anim, looping=true)
      }

      entity_flip_to_target(player, cursor_pos)
    }

    // - Enemy movement ---
    for &en in gm.entities do if en.flags.update
    {
      ACC  :: 400.0
      DRAG :: 3.0

      if .FOLLOW_ENTITY in en.props
      {
        en_pos := tt.global_pos(en)
        target := entity_from_ref(en.targetting.target_en)
        target_pos := tt.global_pos(target)

        dir := vmath.normalize(target_pos - en_pos)
        dist_to_target := vmath.abs(en_pos - target_pos)

        if dist_to_target.x >= en.targetting.min_dist &&
           dist_to_target.x <= en.targetting.max_dist
        {
          en.vel.x += dir.x * ACC * dt
          en.vel.x = clamp(en.vel.x, -en.movement_speed, en.movement_speed)
        }
        else
        {
          en.vel.x = math.lerp(en.vel.x, 0, DRAG * dt)
          en.vel.x = basic.approx(en.vel.x, 0, 1)
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
          en.vel.y = basic.approx(en.vel.y, 0, 1)
        }
      }
    }

    // - Creature movement ---
    for &en in gm.entities do if en.flags.update && en.creature_kind != .NIL
    {
      switch en.creature_kind
      {
      case .NIL:
      case .DEER:
        #partial switch en.state
        {
        case .IDLE:
          entity_creature_idle(&en)
        case .WANDER:
          entity_creature_wander(&en, dt)
        case .FLEE:
          entity_creature_flee(&en, tt.global_pos(player), dt)
        }
      }
    }

    // - Move ---
    for &en in gm.entities do if en.flags.update
    {
      tt.local(en).pos += en.vel * dt
    }

    camera_follow_point_bounded(tt.global_pos(player))

    set_audio_listener_pos(tt.global_pos(player))
  }

  // - Player attack ---
  {
    weapon := entity_child_at(player, 1)
    // debug_circle(tt.global_pos(weapon.shot_point), 4, {1, 0, 0, 0})

    // - Rotate equipped weapon ---
    if player.equipped.weapon_kind != .NIL
    {
      diff := cursor_pos - tt.global_pos(player)
      angle := math.atan2(diff.y, diff.x)
      if .FLIP_H in player.props
      {
        if angle < 0
        {
          angle += 2*math.PI
        }

        weapon.props += {.FLIP_V}
      }
      else
      {
        weapon.props -= {.FLIP_V}
      }

      tt.local(weapon).rot = angle
    }

    // - Shoot weapon ---
    {
      weapon_desc := &res.weapons[gm.weapon.kind]
      muzzle_flash := entity_child_at(weapon, 0)

      if !player.attack_timer.ticking
      {
        timer_start(&player.attack_timer, weapon_desc.shot_time)
      }

      should_shoot := platform.input_pressed(res.actions[.ATTACK]) &&
                      timer_timeout(&player.attack_timer) &&
                      gm.weapon.kind != .NIL
      if should_shoot
      {
        player.attack_timer.ticking = false

        proj := spawn_projectile(.BULLET)
        tt.local(proj).pos = tt.global_pos(weapon.shot_point)
        tt.local(proj).rot = tt.global_rot(weapon.shot_point)
        proj.vel.x = math.cos(tt.local_rot(proj)) * weapon_desc.speed
        proj.vel.y = math.sin(tt.local_rot(proj)) * weapon_desc.speed

        timer_start(&player.equipped.muzzle_timer, 0.1)
        muzzle_flash.flags.render = true
        entity_distort_h(weapon, tt.local(weapon).scl.x*0.8, 5*dt)
        spawn_particles(.GUN_SMOKE, tt.global_pos(weapon.shot_point))

        pitch := rand.range_f32({0.8, 1.2})
        play_sound(.GUN_SHOT, volume=0.1, pitch=pitch)
        emit_noise(60, tt.global_pos(weapon.shot_point))
      }

      // - Position effects ---
      if .FLIP_V in weapon.props
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_point + {0, 2}
        tt.local(muzzle_flash).pos = weapon_desc.shot_point + {2, 2}
      }
      else
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_point
        tt.local(muzzle_flash).pos = weapon_desc.shot_point + + {2, 0}
      }

      if timer_timeout(&player.equipped.muzzle_timer)
      {
        muzzle_flash.flags.render = false
      }
    }
  }

  // - Update colliders ---
  for &en in gm.entities do if en.flags.update && en.collider != nil
  {
    entity_update_collider(&en, dt)
  }

  // - Collision detection ---
  for &en_a in gm.entities do if en_a.flags.update
  {
    if en_a.collider == nil do continue

    for &en_b in gm.entities
    {
      if en_b.collider == nil ||
         entity_is_same(en_a, en_b) ||
         en_b.col_layer not_in COLLISION_MATRIX[en_a.col_layer]
      {
        continue
      }

      // if !get_entities_collided_cache(en_a.ref, en_b.ref) && entity_collision(&en_a, &en_b)
      if entity_collision(&en_a, &en_b)
      {
        // set_entities_collided_cache(en_a.ref, en_b.ref)

        if en_a.projectile_kind != .NIL || en_b.projectile_kind != .NIL
        {
          kill_entity(&en_a)
          kill_entity(&en_b)

          spawn_particles(.DEATH_BLOOD, tt.global_pos(&en_a))
          spawn_corpse(&en_a)
          spawn_corpse(&en_b)

          break
        }
      }
    }

    if circle, ok := en_a.collider.(Circle); ok
    {
      if point_in_circle(cursor_pos, circle)
      {
        if platform.mouse_btn_just_pressed(.RIGHT)
        {
          global.debug_target_entity = en_a.ref
        }
      }
    }
  }

  for &en in gm.entities do if en.flags.update
  {
    if .LOOK_AT_TARGET in en.props
    {
      target_pos: f32x2
      target_en := entity_from_ref(en.targetting.target_en) or_break
      target_pos = tt.global_pos(target_en)

      // entity_flip_to_target(&en, target_pos)
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

    if .FLEE_NOISE in en.props
    {
      noise := noise_at(tt.global_pos(en))
      if noise > 30
      {
        if !en.flee_timer.ticking
        {
          timer_start(&en.flee_timer, 0.1)
        }
      }

      if timer_timeout(&en.flee_timer)
      {
        en.flee_timer.ticking = false
        entity_set_state(&en, .FLEE)
      }
    }
  }

  // - Animate entities ---
  for &en in gm.entities do if en.flags.update
  {
    // - Update animation state ---
    {
      prev_state := en.anim.state
      en.anim.state = en.anim.next_state
      if prev_state != en.anim.next_state
      {
        en.anim.duration = 0
        en.anim.frame_idx = entity_animation_last_frame(&en) if en.anim.reverse else 0
      }
    }

    if .ROTATE_OVER_TIME in en.props
    {
      tt.local(en).rot += 0.25 * math.PI * dt
    }

    // - Distort scale ---
    {
      distort_up: bool

      distort_up = en.distort_h.target > en.distort_h.saved
      switch en.distort_h.state
      {
      case .HOLD:

      case .DISTORT:
        if distort_up
        {
          tt.local(en).scl.x += en.distort_h.rate
          if tt.local(en).scl.x >= en.distort_h.target
          {
            tt.local(en).scl.x = en.distort_h.target
            en.distort_h.state = .RETURN
          }
        }
        else
        {
          tt.local(en).scl.x -= en.distort_h.rate
          if tt.local(en).scl.x <= en.distort_h.target
          {
            tt.local(en).scl.x = en.distort_h.target
            en.distort_h.state = .RETURN
          }
        }

      case .RETURN:
        if distort_up
        {
          tt.local(en).scl.x -= en.distort_h.rate
          if tt.local(en).scl.x <= en.distort_h.saved
          {
            tt.local(en).scl.x = en.distort_h.saved
            en.distort_h.state = .HOLD
          }
        }
        else
        {
          tt.local(en).scl.x += en.distort_h.rate
          if tt.local(en).scl.x >= en.distort_h.saved
          {
            tt.local(en).scl.x = en.distort_h.saved
            en.distort_h.state = .HOLD
          }
        }
      }

      distort_up = en.distort_v.target > en.distort_v.saved
      switch en.distort_v.state
      {
      case .HOLD:

      case .DISTORT:
        if distort_up
        {
          tt.local(en).scl.y += en.distort_v.rate
          if tt.local(en).scl.y >= en.distort_v.target
          {
            tt.local(en).scl.y = en.distort_v.target
            en.distort_v.state = .RETURN
          }
        }
        else
        {
          tt.local(en).scl.y -= en.distort_v.rate
          if tt.local(en).scl.y <= en.distort_v.target
          {
            tt.local(en).scl.y = en.distort_v.target
            en.distort_v.state = .RETURN
          }
        }

      case .RETURN:
        if distort_up
        {
          tt.local(en).scl.y -= en.distort_v.rate
          if tt.local(en).scl.y <= en.distort_v.saved
          {
            tt.local(en).scl.y = en.distort_v.saved
            en.distort_v.state = .HOLD
          }
        }
        else
        {
          tt.local(en).scl.y += en.distort_v.rate
          if tt.local(en).scl.y >= en.distort_v.saved
          {
            tt.local(en).scl.y = en.distort_v.saved
            en.distort_v.state = .HOLD
          }
        }
      }
    }

    // - Animate sprite ---
    switch v in en.anim.data[en.anim.state]
    {
    case Sprite_Name:
      en.sprite = v
    
    case Animation_Name:
      desc := &res.animations[v]

      if len(desc.frames) <= 0 do continue

      en.anim.duration -= dt
      if en.anim.duration <= 0
      {
        en.sprite = desc.frames[en.anim.frame_idx].sprite
        en.anim.duration = desc.frames[en.anim.frame_idx].duration * (1/en.anim.speed)
      
        if en.anim.reverse
        {
          if entity_animation_at_end(&en)
          {
            if en.anim.looping
            {
              en.anim.frame_idx = entity_animation_last_frame(&en)
            }
          }
          else
          {
            en.anim.frame_idx -= 1
          }
        }
        else
        {
          if entity_animation_at_end(&en)
          {
            if en.anim.looping
            {
              en.anim.frame_idx = 0
            }
          }
          else
          {
            en.anim.frame_idx += 1
          }
        }
      }
    }
  }

  // - Update particles ---
  for &par in gm.particles do if .ACTIVE in par.props
  {
    update_particle(&par, dt)
  }

  // reset_entity_collision_cache()
  clear(&global.temp.noise_sources)
  clean_audio()
  free_all(mem.allocator(&global.frame_arena))
}

update_debug_gui :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)
  defer set_current_game(nil)

  if true
  {
    imgui.Begin("General")

    cursor_pos := platform.cursor_position()
    player := gm.special_entities[.PLAYER]
    player_pos := tt.global_pos(player)
    player_pos_local := region_pos_from_world_pos(player_pos)

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
    imgui.Text("Cursor (World): (%.f, %.f)", world_pos.x, world_pos.y)
    imgui.Text("Region: (%.f, %.f)", gm.active_region.x, gm.active_region.y)
    imgui.Text("Coordinates (World): (%.f, %.f)", player_pos.x, player_pos.y)
    imgui.Text("Coordinates (Region): (%.f, %.f)", player_pos_local.x, player_pos_local.y)

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

    // imgui.Checkbox("Show debug", &global.debug_enabled)
    // if imgui.Button("Spawn enemy")
    // {
    //   if gm.entities_cnt < len(gm.entities)
    //   {
    //     spawn_creature(.NIL)
    //   }
    // }

    imgui.End()
  }

  if true
  {
    imgui.Begin("Entity Inspector")

    en := entity_from_ref(global.debug_target_entity)

    imgui.Text("Ref:   [idx=%u, gen=%u]", en.ref.idx, en.ref.gen)

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

    imgui.End()
  }

  if true
  {
    imgui.Begin("Player Inspector")

    en := gm.special_entities[.PLAYER]

    imgui.PushID("Pos")
    imgui.Text("Pos:  "); imgui.SameLine()
    imgui.InputFloat2("", &tt.local(en).pos)
    imgui.PopID()

    imgui.PushID("Vel")
    imgui.Text("Vel:  "); imgui.SameLine()
    imgui.InputFloat2("", &en.vel)
    imgui.PopID()

    imgui.PushID("Speed")
    imgui.Text("Speed:"); imgui.SameLine()
    imgui.InputFloat("", &en.movement_speed)
    imgui.PopID()

    anim_state_strings := []string{"NONE", "IDLE", "WALK"}
    imgui.PushID("Animation")
    imgui.Text("Animation: %s", anim_state_strings[int(en.anim.state)])
    imgui.PopID()

    imgui.End()
  }
}

render_game :: proc(gm: ^Game)
{
  set_current_game(gm)
  defer set_current_game(nil)

  render.clear({0, 0, 0, 1})

  camera := vmath.translation_3x3f(-gm.camera.pos)
  camera *= vmath.rotation_3x3f(gm.camera.rot)
  camera *= vmath.scale_3x3f(gm.camera.scl)
  render.set_camera(camera)

  // - Draw world region ---
  render_world_region(gm, region_idx_from_coord(gm.active_region))

  // - Draw entities ---
  @(static)
  en_targets: [len(gm.entities)]^Entity
  en_count: int
  for i in 0..<len(gm.entities) do if gm.entities[i].flags.render
  {
    en_targets[en_count] = &gm.entities[i]
    en_count += 1
  }

  // slice.sort_by(en_targets[:en_count], proc(i, j: ^Entity) -> bool {
  slice.stable_sort_by(en_targets[:en_count], proc(i, j: ^Entity) -> bool {
    if i.z_layer == j.z_layer
    {
      return i.z_index < j.z_index
    }
    else
    {
      return i.z_layer < j.z_layer
    }
    // return tt.global_pos(i).y < tt.global_pos(j).y
  })

  // - Draw entities ---
  for en in en_targets[:en_count]
  {
    flip: f32x2
    flip.x = -1 if .FLIP_H in en.props else 1
    flip.y = -1 if .FLIP_V in en.props else 1

    en_pos := tt.global_pos(en)
    en_scl := tt.global_scl(en)
    en_rot := tt.global_rot(en)
    draw_sprite(en_pos, en_scl * flip, en_rot, en.tint, en.color, en.sprite)
  }

  // - Draw particles ---
  for &par in gm.particles do if .ACTIVE in par.props
  {
    draw_sprite(par.pos, par.scl, par.rot, par.tint, par.color, par.sprite)
  }

  // - Draw debug entities ---
  if global.debug_enabled
  {
    for &den in gm.debug_entities do if den.flags.render
    {
      den_pos := tt.global_pos(den)
      den_scl := tt.global_scl(den)
      den_rot := tt.global_rot(den)
      draw_sprite(den_pos, den_scl, den_rot, den.tint, den.color, den.sprite)
    }
  }

  render.flush()
}

interpolate_games :: proc(curr_gm, prev_gm, res_gm: ^Game, alpha: f32)
{
  copy_game(res_gm, curr_gm)

  if !curr_gm.interpolate do return

  curr_tt := &curr_gm.transform_tree
  prev_tt := &prev_gm.transform_tree

  res_gm.camera.pos = vmath.lerp(prev_gm.camera.pos, curr_gm.camera.pos, alpha)

  // - Interpolate entities ---
  for i in 1..<len(res_gm.entities)
  {
    curr_en := &curr_gm.entities[i]
    prev_en := &prev_gm.entities[i]

    if curr_en.gen == prev_en.gen &&
       curr_en.flags.interpolate
    {
      tt.set_global_pos(res_gm.entities[i],
                        vmath.lerp(tt.global_pos(prev_en, prev_tt),
                                   tt.global_pos(curr_en, curr_tt),
                                   alpha),
                        &res_gm.transform_tree)

      tt.set_global_scl(res_gm.entities[i],
                        vmath.lerp(tt.global_scl(prev_en, prev_tt),
                                   tt.global_scl(curr_en, curr_tt),
                                   alpha),
                        &res_gm.transform_tree)

      tt.set_global_rot(res_gm.entities[i],
                        vmath.lerp_angle(tt.global_rot(prev_en, prev_tt),
                                         tt.global_rot(curr_en, curr_tt),
                                         alpha),
                        &res_gm.transform_tree)
    }
  }

  // - Interpolate debug entities ---
  if global.debug_enabled
  {
    for i in 0..<len(res_gm.debug_entities)
    {
      curr_den := &curr_gm.debug_entities[i]
      prev_den := &prev_gm.debug_entities[i]

      if entity_is_same(curr_den^, prev_den^) && curr_den.flags.interpolate
      {
        tt.set_global_pos(res_gm.debug_entities[i],
                          vmath.lerp(tt.global_pos(prev_den, prev_tt),
                                  tt.global_pos(curr_den, curr_tt),
                                  alpha),
                          &res_gm.transform_tree)

        tt.set_global_scl(res_gm.debug_entities[i],
                          vmath.lerp(tt.global_scl(prev_den, prev_tt),
                                  tt.global_scl(curr_den, curr_tt),
                                  alpha),
                          &res_gm.transform_tree)

        tt.set_global_rot(res_gm.debug_entities[i],
                          vmath.lerp_angle(tt.global_rot(prev_den, prev_tt),
                                        tt.global_rot(curr_den, curr_tt),
                                        alpha),
                          &res_gm.transform_tree)
      }
    }
  }

  // - Interpolate particles ---
  for i in 0..<len(res_gm.particles)
  {
    curr_par := &curr_gm.particles[i]
    prev_par := &prev_gm.particles[i]

    if curr_par.gen == prev_par.gen &&
       particle_has_props(curr_par^, {.ACTIVE, .INTERPOLATE}) &&
       particle_has_props(prev_par^, {.ACTIVE})
    {
      res_gm.particles[i].pos = vmath.lerp(prev_par.pos, curr_par.pos, alpha)
      res_gm.particles[i].scl = vmath.lerp(prev_par.scl, curr_par.scl, alpha)
      res_gm.particles[i].rot = vmath.lerp_angle(prev_par.rot, curr_par.rot, alpha)
    }
  }
}

camera_follow_point_bounded :: proc(point: f32x2)
{
  gm := current_game()
  point := point - {WORLD_WIDTH, WORLD_HEIGHT}/2
  bounds_min, bounds_max: [2]f32

  bounds_min.x = REGION_SPAN * gm.active_region.x
  bounds_max.x = REGION_SPAN * (gm.active_region.x + 1) - WORLD_WIDTH
  gm.camera.pos.x = clamp(point.x, bounds_min.x, bounds_max.x)

  bounds_min.y = REGION_SPAN * gm.active_region.y
  bounds_max.y = REGION_SPAN * (gm.active_region.y + 1) - WORLD_HEIGHT
  gm.camera.pos.y = clamp(point.y, bounds_min.y, bounds_max.y)
}

screen_to_world_space :: proc(pos: f32x2) -> (result: f32x2)
{
  gm := current_game()

  result = {
    (pos.x - user.viewport.x) * (WORLD_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (WORLD_HEIGHT / user.viewport.w),
  }

  return result + gm.camera.pos
}

Noise_Source :: struct
{
  value: f32,
  pos:   f32x2,
}

emit_noise :: proc(value: f32, pos: f32x2)
{
  append(&global.temp.noise_sources, Noise_Source{
    value = value,
    pos = pos,
  })
}

noise_at :: proc(pos: f32x2) -> (value: f32)
{
  for source in global.temp.noise_sources
  {
    K :: 5.0
    dist := vmath.distance(pos, source.pos)
    value += max(source.value - dist/K, 0)
  }

  return
}

noise_at_test :: proc(pos: f32x2, val: f32, pos2: f32x2) -> (value: f32)
{
  K :: 5.0
  dist := vmath.distance(pos, pos2)
  value += max(val - dist/K, 0)
  return
}

// Entity ////////////////////////////////////////////////////////////////////////////////

MAX_ENTITIES  :: 4 << 10

Entity :: struct
{
  ref:              Entity_Ref,
  gen:              u32,
  parent:           Entity_Ref,
  children:         [4]Entity_Ref,
  flags:            bit_field u8
  {
    update:         bool | 1,
    render:         bool | 1,
    interpolate:    bool | 1,
  },
  props:            bit_set[Entity_Prop],
  #subtype xform:   tt.Transform,
  vel:              f32x2,
  radius:           f32,
  input_dir:        f32x2,
  movement_speed:   f32,
  tint:             f32x4,
  color:            f32x4,
  sprite:           Sprite_Name,
  collider:         Collider,
  col_layer:        Collision_Layer,
  z_index:          i16,
  z_layer:          enum{NIL, DECORATION, ENEMY, PLAYER, PROJECTILE},
  attack_timer:     Timer,
  death_timer:      Timer,
  hurt_timer:       Timer,
  hurt_grace_timer: Timer,
  flee_timer:       Timer,

  state:            Entity_State,
  state_data:       Entity_State_Data,
  creature_kind:    Creature_Kind,
  decoration_kind:  Decoration_Kind,
  weapon_kind:      Weapon_Kind,
  projectile_kind:  Projectile_Kind,

  anim:             struct
  {
    data:           [Animation_State]union#shared_nil{Sprite_Name, Animation_Name},
    state:          Animation_State,
    next_state:     Animation_State,
    speed:          f32,
    duration:       f32,
    reverse:        bool,
    looping:        bool,
    frame_idx:      u16,
  },
  distort_h:        struct
  {
    saved:          f32,
    target:         f32,
    rate:           f32,
    state:          enum{HOLD, DISTORT, RETURN},
  },
  distort_v:        struct
  {
    saved:          f32,
    target:         f32,
    rate:           f32,
    state:          enum{HOLD, DISTORT, RETURN},
  },

  equipped:         struct
  {
    weapon_kind:    Weapon_Kind,
    muzzle_timer:   Timer,
  },
  targetting:       struct
  {
    target_en:      Entity_Ref,
    target_pos:     f32x2,
    min_dist:       f32,
    max_dist:       f32,
  },
  shot_point:       tt.Transform,
}

Entity_Ref :: struct
{
  idx: u32,
  gen: u32,
}

Entity_Prop :: enum
{
  MARKED_FOR_DEATH,
  INTERPOLATE,
  FLIP_H,
  FLIP_V,
  LOOK_AT_TARGET,
  KILL_AFTER_TIME,
  FOLLOW_ENTITY,
  ROTATE_OVER_TIME,
  SNEAKING,
  FLEE_NOISE,
}

Entity_State :: enum
{
  IDLE,
  EXPAND,
  WANDER,
  FLEE,
}

Entity_State_Data :: struct #raw_union
{
  wander:       struct
  {
    state:      enum{CHOOSE, MOVE, WAIT},
    point:      f32x2,
    wait_timer: Timer,
  },
  flee:         struct
  {
    state:      enum{CHOOSE, MOVE},
    point:      f32x2,
    count:      int,
  },
}

Collision_Layer :: enum
{
  NIL,
  PLAYER,
  ENEMY,
}

Creature_Kind :: enum
{
  NIL,
  DEER,
}

Decoration_Kind :: enum
{
  NIL,
  CORPSE,
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

@(rodata)
NIL_ENTITY: Entity

@(rodata)
COLLISION_MATRIX: [Collision_Layer]bit_set[Collision_Layer] = {
  .NIL    = {.NIL},
  .PLAYER = {.ENEMY},
  .ENEMY  = {.PLAYER},
}

entity_is_valid :: proc
{
  entity_is_valid_val,
  entity_is_valid_ptr,
}

entity_is_valid_val :: #force_inline proc(en: Entity) -> bool
{
  return en.ref.idx != 0
}

entity_is_valid_ptr :: #force_inline proc(en: ^Entity) -> bool
{
  return en != nil && en.ref.idx != 0
}

entity_is_same :: #force_inline proc(en_a, en_b: $E/Entity) -> bool
{
  return en_a.ref.idx == en_b.ref.idx && en_a.gen == en_b.gen
}

entity_from_ref :: proc(ref: Entity_Ref) -> (^Entity, bool) #optional_ok
{
  gm := current_game()
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

entity_has_props :: proc(en: $E/Entity, props: bit_set[Entity_Prop]) -> bool
{
  return en.props & props == props
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
      en.flags.update = true
      en.xform = tt.alloc_transform(&gm.transform_tree)

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

  tt.free_transform(&gm.transform_tree, en.xform)
  gen := en.gen
  en^ = {}
  en.gen = gen + 1

  gm.entities_cnt -= 1
}

kill_entity :: proc(en: ^Entity)
{
  en.flags.update = false
  en.props += {.MARKED_FOR_DEATH}

  for child in en.children
  {
    child := entity_from_ref(child) or_continue
    child.flags.update = false
    child.props += {.MARKED_FOR_DEATH}
  }
}

entity_attach_child :: proc(parent, child: ^Entity) -> bool
{
  for &slot in parent.children
  {
    if slot.idx == 0
    {
      slot = child.ref
      child.parent = parent.ref
      return true
    }
  }

  return false
}

entity_child_at :: proc(en: ^Entity, idx: int) -> ^Entity
{
  return entity_from_ref(en.children[idx])
}

spawn_player :: proc() -> ^Entity
{
  gm := current_game()

  en := alloc_entity(gm)
  en.flags.render = true
  en.props += {.INTERPOLATE}
  en.tint = {1, 1, 1, 1}
  // en.props += {.INTERPOLATE}
  en.z_layer = .PLAYER
  en.movement_speed = res.player.speed
  en.anim.state = .IDLE
  en.anim.data[.IDLE] = .PLAYER_IDLE_0
  en.anim.data[.WALK] = .PLAYER_WALK
  en.anim.data[.SNEAK_IDLE] = .PLAYER_IDLE_1
  en.anim.data[.SNEAK_WALK] = .PLAYER_SNEAK_WALK

  // - Shadow ---
  {
    shadow := alloc_entity(gm)
    shadow.flags.render = true
    shadow.props += {.INTERPOLATE}
    shadow.tint = {1, 1, 1, 1}
    shadow.color = {0.2, 0.2, 0.2, 0}
    shadow.tint.a = 0.5
    shadow.anim.data[.IDLE] = .SHADOW_PLAYER
    
    tt.set_parent(shadow, en)
    tt.local(shadow).pos = {0, 7}
    entity_attach_child(en, shadow)
  }

  // - Weapon ---
  {
    weapon := alloc_entity(gm)
    weapon.flags.render = true
    weapon.props += {.INTERPOLATE}
    weapon.tint = {1, 1, 1, 1}
    weapon.weapon_kind = .RIFLE
    weapon.z_layer = .PLAYER
    weapon.z_index = 1
    weapon.shot_point = tt.alloc_transform(&gm.transform_tree, weapon)
    weapon.anim.data[.IDLE] = .RIFLE

    tt.set_parent(weapon, en)

    // - Muzzle flash ---
    {
      muzzle_flash := alloc_entity(gm)
      muzzle_flash.flags.render = true
      muzzle_flash.props += {.INTERPOLATE}
      muzzle_flash.tint = {1, 1, 1, 1}
      muzzle_flash.z_layer = .PLAYER
      muzzle_flash.z_index = 2
      muzzle_flash.flags.render = false
      muzzle_flash.anim.data[.IDLE] = .MUZZLE_FLASH

      tt.set_parent(muzzle_flash, weapon)
      entity_attach_child(weapon, muzzle_flash)
    }

    en.equipped.weapon_kind = .RIFLE

    entity_attach_child(en, weapon)
    entity_equip_weapon(en, .RIFLE)
  }

  return en
}

spawn_creature :: proc(kind: Creature_Kind, pos: f32x2) -> ^Entity
{
  gm := current_game()

  en := alloc_entity(gm)
  en.creature_kind = kind
  en.props += {.FOLLOW_ENTITY, .FLEE_NOISE}
  en.tint = {1, 1, 1, 1}
  en.z_layer = .ENEMY
  en.col_layer = .ENEMY
  en.targetting.target_en = gm.special_entities[.PLAYER].ref
  en.targetting.min_dist = 8
  en.targetting.max_dist = 1000
  entity_set_state(en, .WANDER)
  tt.local(en).pos = pos

  switch kind
  {
  case .NIL:
  case .DEER:
    en.flags.render = true
    en.props += {.INTERPOLATE}
    en.tint = {1, 1, 1, 1}
    en.anim.state = .IDLE
    en.anim.data[.IDLE] = .DEER_IDLE
    en.anim.data[.WALK] = .DEER_WALK

    en.collider = Circle{
      radius = 5,
    }

    // - Shadow ---
    {
      shadow := alloc_entity(gm)
      shadow.flags.render = true
      shadow.props += {.INTERPOLATE}
      shadow.tint = {1, 1, 1, 1}
      tt.local(shadow).pos = {-2, 7}
      shadow.color = {0.3, 0.3, 0.3, 0}
      shadow.tint.a = 0.5
      shadow.anim.data[.IDLE] = .SHADOW_DEER

      tt.set_parent(shadow, en)
      entity_attach_child(en, shadow)
    }
  }

  return en
}

spawn_projectile :: proc(kind: Projectile_Kind) -> ^Entity
{
  gm := current_game()

  en := alloc_entity(gm)
  en.projectile_kind = kind
  en.props += {.KILL_AFTER_TIME}
  en.z_layer = .PROJECTILE
  en.col_layer = .PLAYER

  collider_radius: f32

  switch kind
  {
  case .BULLET:
    en.flags.render = true
    en.props += {.INTERPOLATE}
    en.tint = {1, 1, 1, 1}
    en.anim.data[.IDLE] = .BULLET

    collider_radius = 2
  case .NIL:
  }

  en.collider = Circle{
    radius = collider_radius,
  }

  return en
}

spawn_corpse :: proc(en: ^Entity) -> ^Entity
{
  if en.creature_kind == .NIL do return nil

  gm := current_game()

  corpse := alloc_entity(gm)
  corpse.flags.render = true
  corpse.props += {.INTERPOLATE}
  corpse.tint = {1, 1, 1, 1}
  tt.local(corpse).pos = tt.global_pos(en) + {0, 5}
  corpse.props += en.props & {.FLIP_H}

  switch en.creature_kind
  {
  case .NIL:
  case .DEER: corpse.anim.data[.IDLE] = .DEER_CORPSE
  }

  // - Blood pool ---
  {
    blood_pool := alloc_entity(gm)
    blood_pool.flags.render = true
    blood_pool.props += {.INTERPOLATE}
    blood_pool.tint = {1, 1, 1, 1}
    blood_pool.z_index = -1
    blood_pool.anim.state = .IDLE
    blood_pool.anim.data[.IDLE] = .BLOOD_POOL_0
    blood_pool.anim.data[.EXPAND] = .BLOOD_POOL_EXPAND

    entity_play_animation(blood_pool, .EXPAND, looping=false)

    entity_attach_child(corpse, blood_pool)
    tt.attach_child(corpse, blood_pool)
  }

  return corpse
}

entity_play_animation :: proc(
  en:      ^Entity,
  anim:    Animation_State,
  looping: bool,
  reverse: bool = false,
  speed:   f32 = 1.0,
){
  en.anim.next_state = anim
  en.anim.looping = looping
  en.anim.reverse = reverse
  en.anim.speed = speed
}

entity_animation_last_frame :: proc(en: ^Entity) -> u16
{
  anim, ok := en.anim.data[en.anim.state].(Animation_Name)
  if !ok do return 0
  return cast(u16) len(res.animations[anim].frames) - 1
}

entity_animation_at_end :: proc(en: ^Entity) -> bool
{
  return (!en.anim.reverse && en.anim.frame_idx == entity_animation_last_frame(en)) ||
         (en.anim.reverse && en.anim.frame_idx == 0)
}

entity_rotate_to_target :: proc(en: ^Entity, target: f32x2)
{
  diff := target - tt.global_pos(en)
  tt.local(en).rot = math.atan2(diff.y, diff.x)
  if tt.global_rot(en) < 0
  {
    tt.local(en).rot += math.TAU
  }
}

entity_flip_to_target :: proc(en: ^Entity, target: f32x2)
{
  en_pos := tt.global_pos(en)
  if en_pos.x > target.x
  {
    en.props += {.FLIP_H}
  }
  else
  {
    en.props -= {.FLIP_H}
  }
}

entity_top_left :: proc(en: ^Entity) -> f32x2
{
  pivot := res.sprites[en.sprite].pivot
  dim := dim_from_entity(en)
  local_pos := vmath.rotation_2x2f(tt.local(en).rot) * (f32x2{-dim.x, -dim.y} * pivot)
  return local_pos + tt.local(en).pos
}

dim_from_entity :: proc(en: ^Entity) -> f32x2
{
  return tt.local(en).scl * f32x2{16, 16}
}

xform_from_entity :: proc(en: ^Entity) -> m3f32
{
  result := vmath.scale_3x3f(tt.local(en).scl)
  result = vmath.rotation_3x3f(tt.local(en).rot) * result
  result = vmath.translation_3x3f(entity_top_left(en)) * result
  return result
}

entity_collider_vertex_pos :: proc(en: ^Entity, v: f32x2) -> f32x2
{
  local_pos := vmath.rotation_2x2f(tt.local(en).rot) * v * 2
  return entity_top_left(en) + local_pos
}

entity_update_collider :: proc(en: ^Entity, dt: f32)
{
  switch &collider in en.collider
  {
  case Circle:
    collider.origin = tt.global_pos(en)
    debug_circle(collider.origin, collider.radius, alpha=0.25)
  case Polygon:
    // en.collider.vertices_cnt = cast(u8) collider_map[en.sprite].vertex_count
    // for i in 0..<en.collider.vertices_cnt
    // {
    //   v := xform_from_entity(en) * vmath.concat(collider_map[en.sprite].vertices[i], 1)
    //   en.collider.vertices[i] = v.xy
    // }

    // for vert in en.collider.vertices[:en.collider.vertices_cnt]
    // {
    //   debug_circle(vert, 4, color={0, 1, 0, 0}, alpha=0.75)
    // }
  }
}

entity_collision :: proc(en_a, en_b: ^Entity) -> bool
{
  switch &a in en_a.collider
  {
  case Circle:
    switch &b in en_b.collider
    {
    case Polygon: return circle_polygon_overlap(a, b)
    case Circle:  return circle_circle_overlap(a, b)
    }
  case Polygon:
    switch &b in en_b.collider
    {
    case Polygon: return polygon_polygon_overlap(a, b)
    case Circle:  return circle_polygon_overlap(b, a)
    }
  }

  panic("Unhandled collision for collider types!")
}

// @(thread_local, private="file")
// _entity_collision_cache: [MAX_ENTITIES*2]bool

// get_entities_collided_cache :: proc(a, b: Entity_Ref) -> bool
// {
//   return _entity_collision_cache[a.idx] && _entity_collision_cache[b.idx]
// }

// set_entities_collided_cache :: proc(a, b: Entity_Ref)
// {
//   _entity_collision_cache[a.idx] = true
//   _entity_collision_cache[int(b.idx) + MAX_ENTITIES] = true
// }

// reset_entity_collision_cache :: proc()
// {
  // mem.set(&_entity_collision_cache, 0, MAX_ENTITIES * MAX_ENTITIES)
// }

entity_move_to_point :: proc(
  en:    ^Entity,
  p:     f32x2,
  speed: f32,
  flip:  bool = true
) -> (
  done: bool,
){
  en_pos := tt.global_pos(en)
  new_pos := move_to_point(en_pos, p, speed)
  tt.set_global_pos(en, new_pos)

  if flip
  {
    if en_pos.x > p.x
    {
      en.props += {.FLIP_H}
    }
    else
    {
      en.props -= {.FLIP_H}
    }
  }

  return new_pos == p
}

entity_distort_h :: proc(en: ^Entity, target, rate: f32)
{
  en.distort_h.rate = rate
  en.distort_h.target = target
  en.distort_h.saved = tt.local(en).scl.x
  en.distort_h.state = .DISTORT
}

entity_distort_v :: proc(en: ^Entity, target, rate: f32)
{
  en.distort_v.rate = rate
  en.distort_v.target = target
  en.distort_h.saved = tt.local(en).scl.y
  en.distort_v.state = .DISTORT
}

entity_equip_weapon :: proc(en: ^Entity, kind: Weapon_Kind)
{
  if !entity_is_valid(en) do return

  en.equipped.weapon_kind = kind
  weapon := entity_child_at(en, 1)
  weapon.weapon_kind = kind
  if kind == .NIL
  {
    weapon.flags.render = false
  }
  else
  {
    weapon.flags.render = true
  }

  gm := current_game()
  gm.weapon.kind = kind
}

entity_set_state :: proc(en: ^Entity, st: Entity_State, reset := false)
{
  if en.state != st || reset
  {
    en.state_data = {}
  }

  en.state = st
}

entity_creature_idle :: proc(en: ^Entity)
{
  entity_play_animation(en, .IDLE, looping=true)
}

entity_creature_wander :: proc(en: ^Entity, dt: f32)
{
  creature_desc := &res.creatures[en.creature_kind]
  wander := &en.state_data.wander
  en_pos := tt.global_pos(en)

  switch wander.state
  {
  case .CHOOSE:
    point: [2]f32
    for
    {
      point = array_cast(rand.range_2i31(creature_desc.wander_range), f32)
      point.x *= -1 if rand.boolean() else 1
      point.y *= -1 if rand.boolean() else 1
      point += en_pos

      if point_in_region_bounds(point, region_from_world_pos(en_pos)) do break
    }

    wander.point = point
    wander.state = .MOVE

  case .MOVE:
    entity_play_animation(en, .WALK, looping=true)
    debug_circle(wander.point, 4)

    arrived := entity_move_to_point(en, wander.point, creature_desc.speed*dt)
    if arrived
    {
      wander.state = .WAIT
    }

  case .WAIT:
    entity_play_animation(en, .IDLE, looping=true)

    if !wander.wait_timer.ticking
    {
      duration := rand.range_f32({0.5, 5})
      timer_start(&wander.wait_timer, duration)
    }

    if timer_timeout(&wander.wait_timer)
    {
      wander.wait_timer.ticking = false
      wander.state = .CHOOSE
    }
  }
}

entity_creature_flee :: proc(en: ^Entity, target_pos: f32x2, dt: f32)
{
  creature_desc := &res.creatures[en.creature_kind]
  flee := &en.state_data.flee
  en_pos := tt.global_pos(en)

  FLEE_SPEED_MULT :: 2.5

  switch flee.state
  {
  case .CHOOSE:
    point: [2]f32
    for
    {
      point = array_cast(rand.range_2i31(creature_desc.flee_range), f32)
      point.x *= -1 if rand.boolean() else 1
      point.y *= -1 if rand.boolean() else 1
      point += en_pos

      if point_in_region_bounds(point, region_from_world_pos(en_pos)) do break
    }

    flee.point = point
    flee.state = .MOVE

  case .MOVE:
    speed := creature_desc.speed * FLEE_SPEED_MULT * dt
    arrived := entity_move_to_point(en, flee.point, speed)
    if arrived
    {
      flee.count += 1

      if flee.count == 3
      {
        entity_set_state(en, .WANDER)
        break
      }
      else
      {
        flee.state = .CHOOSE
      }
    }

    entity_play_animation(en, .WALK, looping=true, speed=speed)
  }
}

// Debug_Entity //////////////////////////////////////////////////////////////////////////

Debug_Entity :: distinct Entity

push_debug_entity :: proc() -> ^Debug_Entity
{
  gm := current_game()

  result := &gm.debug_entities[gm.debug_entities_pos]
  result.flags.update = true
  result.flags.render = true
  result.props += {.INTERPOLATE, .MARKED_FOR_DEATH}

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
  gm := current_game()

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
  pos:    f32x2,
  scale:  f32x2,
  color:  f32x4 = {1, 1, 1, 0},
  alpha:  f32 = 0.65,
  sprite: Sprite_Name = .SQUARE,
) -> (
  ^Debug_Entity,
){
  result := push_debug_entity()
  tt.local(result).pos = pos
  tt.local(result).scale = scale
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = sprite

  return result
}

debug_circle :: proc(
  pos:    f32x2,
  radius: f32,
  color:  f32x4 = {0, 1, 0, 0},
  alpha:  f32 = 0.65,
) -> (
  ^Debug_Entity,
){
  result := push_debug_entity()
  tt.local(result).pos = pos
  tt.local(result).scl = {radius/8, radius/8}
  result.color = color
  result.tint = {1, 1, 1, alpha}
  result.sprite = .CIRCLE

  return result
}

// Region ///////////////////////////////////////////////////////////////////////////////////

TILE_SIZE         :: 8
REGION_GAP_TILES  :: 2
REGION_GAP        :: REGION_GAP_TILES * TILE_SIZE
REGION_SPAN_TILES :: 64 + REGION_GAP_TILES*2
REGION_SPAN       :: REGION_SPAN_TILES * TILE_SIZE

Tile :: struct
{
  sprite: Sprite_Name,
  rot:    f16,
}

Tile_Coord   :: distinct [2]f32
Region_Coord :: distinct [2]f32

tile_idx_from_coord :: proc(coord: Tile_Coord) -> int
{
  return int(coord.x + (coord.y * f32(REGION_SPAN_TILES)))
}

tile_coord_from_idx :: proc(idx: int) -> Tile_Coord
{
  return {f32(idx % REGION_SPAN_TILES), f32(idx / REGION_SPAN_TILES)}
}

region_idx_from_coord :: proc(coord: Region_Coord) -> int
{
  return int(coord.x + (coord.y * 3))
}

region_coord_from_idx :: proc(idx: int) -> Region_Coord
{
  return {f32(idx % 3), f32(idx / 3)}
}

region_from_world_pos :: proc(pos: f32x2) -> Region_Coord
{
  return {
    f32(int(pos.x) / REGION_SPAN),
    f32(int(pos.y) / REGION_SPAN),
  }
}

region_pos_from_world_pos :: proc(pos: f32x2) -> f32x2
{
  gm := current_game()
  region_pos := region_pos_to_world_pos({0, 0})

  return {
    region_pos.x != 0 ? f32(int(pos.x) % int(region_pos.x)) : pos.x,
    region_pos.y != 0 ? f32(int(pos.y) % int(region_pos.y)) : pos.y,
  }
}

region_pos_to_world_pos :: proc(pos: f32x2, region: Region_Coord = {-1, -1}) -> f32x2
{
  gm := current_game()

  region := region
  if region == {-1, -1}
  {
    region = gm.active_region
  }

  return pos + {REGION_SPAN, REGION_SPAN} * f32x2(region)
}

point_in_region_bounds :: proc(point: f32x2, region: Region_Coord) -> bool
{
  region_pos := region_pos_from_world_pos(point)
  return point_in_bounds(region_pos, Range(f32){REGION_GAP, REGION_SPAN-REGION_GAP})
}

set_active_region :: proc(gm: ^Game, coord: Region_Coord)
{
  gm.active_region = coord
  gm.camera.pos = {WORLD_WIDTH * coord.x, WORLD_HEIGHT * coord.y}
}

generate_world_region :: proc(gm: ^Game)
{
  for region_idx in 0..<len(gm.regions)
  {
    for tile_idx in 0..<len(gm.regions[0])
    {
      coord: [2]f64 = basic.array_cast(tile_coord_from_idx(tile_idx), f64)
      noise_scale: f64 = 0.05
      noise_value: f32 = math.abs(noise.noise_2d(rand.num_i63(), coord * noise_scale))

      sprite: Sprite_Name
      switch region_idx
      {
      case 0..=4:
        if noise_value > 0.95
        {
          sprite = .TILE_GRASS_2
        }
        else if noise_value > 0.9
        {
          sprite = .TILE_GRASS_1
        }
        else
        {
          sprite = .TILE_GRASS_0
        }
      case 5..=9:
        if noise_value > 0.9
        {
          sprite = .TILE_STONE_1
        }
        else
        {
          sprite = .TILE_STONE_0
        }
      }

      if coord.x < REGION_GAP_TILES || REGION_SPAN_TILES - coord.x <= REGION_GAP_TILES ||
         coord.y < REGION_GAP_TILES || REGION_SPAN_TILES - coord.y <= REGION_GAP_TILES
      {
        if !(coord.x == REGION_SPAN_TILES/2 || coord.y == REGION_SPAN_TILES/2)
        {
          sprite = .TILE_DIRT
        }
      }

      rot: f16
      rot_roll := rand.range_i31({0, 4})
      rot = cast(f16) i32(rot_roll) * math.PI/2.0

      gm.regions[region_idx][tile_idx] = Tile{
        sprite = sprite,
        rot = rot,
      }
    }
  }
}

render_world_region :: proc(gm: ^Game, region_idx: int)
{
  region_coord := region_coord_from_idx(region_idx)

  for tile_idx in 0..<len(gm.regions[0])
  {
    tile := &gm.regions[region_idx][tile_idx]
    if tile.sprite != .NIL
    {
      pos: f32x2 = basic.array_cast(tile_coord_from_idx(tile_idx), f32)
      pos *= TILE_SIZE
      pos += ({REGION_SPAN, REGION_SPAN}) * f32x2(region_coord)
      pos += {TILE_SIZE/2.0, TILE_SIZE/2.0}
      draw_sprite(pos, scl={1.01, 1.01}, rot=f32(tile.rot), sprite=tile.sprite)
    }
  }
}

// Particle //////////////////////////////////////////////////////////////////////////////

MAX_PARTICLES :: 8 << 10

Particle :: struct
{
  gen:           u16,
  kind:          Particle_Name,
  kill_timer:    Timer,
  tint:          f32x4,
  color:         f32x4,
  pos:           f32x2,
  scl:           f32x2,
  vel:           f32x2,
  acc:           f32x2,
  dir:           f32,
  rot:           f32,
  rot_dt:        f32,
  sprite:        Sprite_Name,
  emmision_kind: Particle_Emmision_Kind,
  props:         bit_set[Particle_Prop],
}

Particle_Prop :: enum
{
  ACTIVE,
  INTERPOLATE,
  KILL_AFTER_TIME,
  ROTATE_OVER_TIME,
  SCALE_OVER_TIME,
}

Particle_Emmision_Kind :: enum
{
  STATIC,
  LINEAR,
  BURST,
}

particle_has_props :: proc(par: Particle, props: bit_set[Particle_Prop]) -> bool
{
  return par.props & props == props
}

push_particle :: proc(gm: ^Game) -> ^Particle
{
  idx := gm.particles_pos % len(gm.particles)
  result := &gm.particles[idx]
  gm.particles_pos += 1

  old_gen := result.gen
  result^ = {}
  result.gen = old_gen + 1
  result.props += {.ACTIVE, .INTERPOLATE}
  result.tint = {1, 1, 1, 1}
  result.color = {0, 0, 0, 1}

  return result
}

kill_particle :: proc(par: ^Particle)
{
  par.props -= {.ACTIVE}
}

spawn_particles :: proc(kind: Particle_Name, pos: f32x2)
{
  gm := current_game()
  desc := &res.particles[kind]

  for i in 0..<desc.count
  {
    par := push_particle(gm)
    par.kind = kind
    par.props = {.ACTIVE, .INTERPOLATE, .KILL_AFTER_TIME}
    par.sprite = desc.sprite
    par.pos = pos
    par.scl = desc.scl + rand.range_f32(Range(f32){-desc.scl_var, desc.scl_var})
    par.rot = desc.rot
    par.rot_dt = desc.rot_dt
    par.vel = desc.vel
    par.acc = desc.vel_dt
    par.color = rand.choice_slice(desc.colors[:])

    timer_start(&par.kill_timer, desc.lifetime)

    switch desc.emmision_kind
    {
    case .STATIC:
    case .LINEAR:
    case .BURST:
      par.dir = rand.range_f32({0, 2*math.PI})
      par.vel.x *= math.cos(par.dir)
      par.vel.y *= math.sin(par.dir)
    }
  }
}

update_particle :: proc(par: ^Particle, dt: f32)
{
  par.vel += par.acc * dt
  par.pos += par.vel * dt

  if .ROTATE_OVER_TIME in par.props
  {
    par.rot += dt * 2
  }

  if timer_timeout(&par.kill_timer)
  {
    kill_particle(par)
  }

  par.scl += res.particles[par.kind].scl_dt * dt
  par.scl.x = max(par.scl.x, 0)
  par.scl.y = max(par.scl.y, 0)
}

// Timer /////////////////////////////////////////////////////////////////////////////////

Timer :: struct
{
  end_time: f32,
  ticking:  b32,
}

timer_start :: proc(timer: ^Timer, duration: f32)
{
  gm := current_game()
  timer.end_time = gm.t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> b32
{
  gm := current_game()
  return timer.ticking && gm.t >= timer.end_time
}

timer_remaining :: proc(timer: ^Timer) -> f32
{
  gm := current_game()
  return timer.end_time - gm.t
}
