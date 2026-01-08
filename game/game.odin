package game

import "core:math"
import "core:math/noise"
import "core:slice"
import "core:time"
import imgui "ext:dear_imgui"
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
  global.audio.music_volume = 1.0

  ui.tree_init(&global.gui_tree, 1024, &user.perm_arena, &global.ui_frame_arena)
}


// Game //////////////////////////////////////////////////////////////////////////////////


Game :: struct
{
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
  debug_entities:     [256]Debug_Entity,
  debug_entities_pos: int,
  particles:          [MAX_PARTICLES]Particle,
  particles_pos:      int,
  special_entities:   [enum{Player}]^Entity,
  regions:            [9][REGION_SPAN_TILES*REGION_SPAN_TILES]Tile,
  active_region:      Region_Coord,
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
}

@(private="file")
_current_game: ^Game

get_current_game :: #force_inline proc() -> ^Game
{
  return _current_game
}

set_current_game :: #force_inline proc(gm: ^Game)
{
  _current_game = gm
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

copy_game :: proc(dst, src: ^Game)
{
  dst_tree := dst.transform_tree
  dst^ = src^
  dst.transform_tree = dst_tree
  tt.copy_tree(&dst.transform_tree, &src.transform_tree)
}

game_start :: proc(gm: ^Game)
{
  set_current_game(gm)

  gm.t_mult = 1
  gm.camera.scl = {1, 1}

  region: Region_Coord
  generate_world_region(gm)
  set_active_region(gm, region)

  player := spawn_player()
  tt.set_global_pos(player, region_pos_to_world_pos(WORLD_WIDTH/2, region))

  gm.special_entities[.Player] = player

  for _ in 0..<1
  {
    spawn_creature(.Deer, region_pos_to_world_pos({200, 200}, region))
    spawn_creature(.Rabbit, region_pos_to_world_pos({200, 200}, region))
  }

  play_sound(.Minecraft, volume=global.audio.music_volume)
  // play_sound(.Forest_Ambience, volume=0.25)

  set_current_game(nil)
}

game_update :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)

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

  if !point_in_region_bounds(cursor_pos, gm.active_region)
  {
    debug_circle(cursor_pos, 4, {1, 0, 0, 0})
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
      else if key_just_down(.P)
      {
        generate_world_region(gm)
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

  // - Move region ---
  {
    region_pos := region_pos_to_world_pos({0, 0})
    relative_player_pos := tt.global_pos(player) - region_pos

    if gm.active_region.x < 2 && relative_player_pos.x > REGION_SPAN
    {
      // - Move right ---
      gm.active_region.x += 1
      gm.interpolate = false
    }
    else if gm.active_region.x > 0 && relative_player_pos.x < -0
    {
      // - Move left ---
      gm.active_region.x -= 1
      gm.interpolate = false
    }

    if gm.active_region.y < 2 && relative_player_pos.y > REGION_SPAN
    {
      // - Move down ---
      gm.active_region.y += 1
      gm.interpolate = false
    }
    else if gm.active_region.y > 0 && relative_player_pos.y < -0
    {
      // - Move up ---
      gm.active_region.y -= 1
      gm.interpolate = false
    }
  }

  // - Entity movement (:move, :movement) ---
  {
    // - Player movement ---
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

      if player.input_dir.x != 0 || player.input_dir.y != 0
      {
        speed_mult: f32 = 1
        speed_mult *= backward ? BACKWARD_MULT : 1
        speed_mult *= sneaking ? SNEAKING_MULT : 1
        speed_mult *= !gm.weapon.holstered ? EQUIPPED_MULT : 1

        anim: Animation_State = sneaking ? .Sneak_Walk : .Walk
        entity_play_animation(player, anim, speed=speed_mult, looping=true, reverse=backward)

        noise: f32 = sneaking ? SNEAKING_NOISE : WALKING_NOISE
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
        anim: Animation_State = sneaking ? .Sneak_Idle : .Idle
        entity_play_animation(player, anim, looping=true)
      }

      entity_flip_to_target(player, cursor_pos)
    }

    // - Entity state ---
    for &en in gm.entities do if en.flags.update
    {
      en->update_state(&{dt=dt})
    }

    // - Move ---
    for &en in gm.entities do if en.flags.update
    {
      tt.local(en).pos += en.vel * dt
    }

    set_audio_listener_pos(tt.global_pos(player))

    bounds: [2]Range(f32)
    bounds.x.min = REGION_SPAN * gm.active_region.x
    bounds.x.max = REGION_SPAN * (gm.active_region.x + 1) - WORLD_WIDTH
    bounds.y.min = REGION_SPAN * gm.active_region.y
    bounds.y.max = REGION_SPAN * (gm.active_region.y + 1) - WORLD_HEIGHT
    camera_follow_point(tt.global_pos(player), bounds)
  }

  // - Player attack (:attack, :combat) ---
  {
    weapon, _ := entity_child_at(player, 1)
    // debug_circle(tt.global_pos(weapon.shot_point), 1, {1, 0, 0, 0})

    // - Rotate equipped weapon ---
    if player.equipped.weapon_kind != .Nil
    {
      diff := cursor_pos - tt.global_pos(player)
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
      weapon_desc := &res.weapons[gm.weapon.kind]
      muzzle_flash, _ := entity_child_at(weapon, 0)

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

        proj := spawn_projectile(.Bullet, tt.global_pos(weapon.shot_point))
        tt.local(proj).rot = tt.global_rot(weapon.shot_point)
        proj.vel.x = math.cos(tt.local_rot(proj)) * weapon_desc.speed
        proj.vel.y = math.sin(tt.local_rot(proj)) * weapon_desc.speed

        timer_start(&player.equipped.muzzle_timer, 0.1)
        muzzle_flash.flags.render = true

        entity_distort(weapon, .W, tt.local(weapon).scl.x*0.8, 5*dt)
        spawn_particles(.Gun_Smoke, tt.global_pos(weapon.shot_point))
        play_sound(.Gun_Shot, volume=0.1, pitch=rand.range_f32({0.8, 1.2}))
        emit_noise(60, tt.global_pos(weapon.shot_point))
      }

      // - Position effects ---
      if .Flip_V in weapon.props
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_pos + {0, 2}
        tt.local(muzzle_flash).pos = weapon_desc.shot_pos + {2, 2}
      }
      else
      {
        tt.local(weapon.shot_point).pos = weapon_desc.shot_pos
        tt.local(muzzle_flash).pos = weapon_desc.shot_pos + + {2, 0}
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

    Collision :: struct{a, b: u32}

    @(static)
    collided_cache: [dynamic]Collision
    collided_cache.allocator = mem.allocator(&global.frame_arena)

    in_collided_cache :: proc(a, b: Entity_Ref) -> bool
    {
      for col in collided_cache
      {
        if col.a == a.idx && col.b == b.idx do return true
      }

      return false
    }

    for &en_a in gm.entities do if en_a.flags.update && en_a.collider != nil
    {
      for &en_b in gm.entities do if en_b.flags.update && en_b.collider != nil
      {
        if entity_is_same(en_a, en_b) do continue

        if en_b.col_layer in COLLISION_MATRIX[en_a.col_layer]
        {
          if !in_collided_cache(en_a.ref, en_b.ref) && collider_overlap(en_a.collider, en_b.collider)
          {
            append(&collided_cache, Collision{en_a.ref.idx, en_b.ref.idx})

            en_a->resolve_collision(&en_b)
            en_b->resolve_collision(&en_a)
          }
        }
      }

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

    clear(&collided_cache)
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

    if .Flee_Noise in en.props do if en.creature_kind != .Nil
    {
      creature_desc := res.creatures[en.creature_kind]
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
        holster_off *= entity_flip_dir(player)
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
        hold_off *= entity_flip_dir(player)
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

    // - Distort scale ---
    {
      distort_up: bool

      distort_up = en.distort[0].target > en.distort[0].saved
      switch en.distort[0].state
      {
      case .Hold:

      case .Distort:
        if distort_up
        {
          tt.local(en).scl.x += en.distort[0].rate
          if tt.local(en).scl.x >= en.distort[0].target
          {
            tt.local(en).scl.x = en.distort[0].target
            en.distort[0].state = .Return
          }
        }
        else
        {
          tt.local(en).scl.x -= en.distort[0].rate
          if tt.local(en).scl.x <= en.distort[0].target
          {
            tt.local(en).scl.x = en.distort[0].target
            en.distort[0].state = .Return
          }
        }

      case .Return:
        if distort_up
        {
          tt.local(en).scl.x -= en.distort[0].rate
          if tt.local(en).scl.x <= en.distort[0].saved
          {
            tt.local(en).scl.x = en.distort[0].saved
            en.distort[0].state = .Hold
          }
        }
        else
        {
          tt.local(en).scl.x += en.distort[0].rate
          if tt.local(en).scl.x >= en.distort[0].saved
          {
            tt.local(en).scl.x = en.distort[0].saved
            en.distort[0].state = .Hold
          }
        }
      }

      distort_up = en.distort[1].target > en.distort[1].saved
      switch en.distort[1].state
      {
      case .Hold:

      case .Distort:
        if distort_up
        {
          tt.local(en).scl.y += en.distort[1].rate
          if tt.local(en).scl.y >= en.distort[1].target
          {
            tt.local(en).scl.y = en.distort[1].target
            en.distort[1].state = .Return
          }
        }
        else
        {
          tt.local(en).scl.y -= en.distort[1].rate
          if tt.local(en).scl.y <= en.distort[1].target
          {
            tt.local(en).scl.y = en.distort[1].target
            en.distort[1].state = .Return
          }
        }

      case .Return:
        if distort_up
        {
          tt.local(en).scl.y -= en.distort[1].rate
          if tt.local(en).scl.y <= en.distort[1].saved
          {
            tt.local(en).scl.y = en.distort[1].saved
            en.distort[1].state = .Hold
          }
        }
        else
        {
          tt.local(en).scl.y += en.distort[1].rate
          if tt.local(en).scl.y >= en.distort[1].saved
          {
            tt.local(en).scl.y = en.distort[1].saved
            en.distort[1].state = .Hold
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

  gm.prev_keys = platform.global_input.keys
  gm.prev_mouse_btns = platform.global_input.mouse_btns

  clear(&global.temp.noise_sources)
  free_finished_sounds()
  free_all(mem.allocator(&global.frame_arena))

  set_current_game(nil)
}

render_scratch :: proc()
{
  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic_3x3f(0, WORLD_WIDTH, 0, WORLD_HEIGHT),
    viewport = user.viewport,
    clear_color = {0, 0, 0, 1},
  })

  @(static)
  vertices := [3]render.Vertex{
    {{WORLD_WIDTH/2-50, WORLD_HEIGHT-50}, {1, 0, 0, 1}, {0, 1, 0, 0}, {0, 1}, 0},
    {{WORLD_WIDTH/2,    50},              {1, 0, 0, 1}, {1, 0, 0, 0}, {0, 1}, 0},
    {{WORLD_WIDTH/2+50, WORLD_HEIGHT-50}, {1, 0, 0, 1}, {0, 1, 0, 0}, {0, 1}, 0},
  }

  render.push_triangle(vertices)

  draw_text("\"The light shines in the darkness,\nand the darkness has not overcome it.\"\nJohn 1:5", 
             pos={100, 100}, 
             size=0.5, 
             line_height=1,
             color={1, 1, 1, 0})

  render.end_pass()
}

game_render :: proc(gm: ^Game)
{
  set_current_game(gm)

  render.begin_pass({
    shader = &res.shaders[.Sprite],
    camera = vmath.transform_3x3f(-gm.camera.pos, gm.camera.rot, gm.camera.scl),
    projection = vmath.orthographic_3x3f(0, WORLD_WIDTH, 0, WORLD_HEIGHT),
    viewport = user.viewport,
    clear_color = {1, 1, 1, 1},
    // light_color = {1.0, 0.8, 0.8, 1.0},
  })

  draw_text("Hello, world!", {100, 100}, 32)

  // - Draw region ---
  region_coord := gm.active_region
  region_idx := region_idx_from_coord(gm.active_region)
  for tile_idx in 0..<len(gm.regions[0])
  {
    tile := &gm.regions[region_idx][tile_idx]
    if tile.sprite != .Nil
    {
      pos := array_cast(tile_coord_from_idx(tile_idx), f32)
      pos *= TILE_SIZE
      pos += ({REGION_SPAN, REGION_SPAN}) * v2f32(region_coord)
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

  // slice.sort_by(en_targets[:en_count], proc(i, j: ^Entity) -> bool {
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

  set_current_game(nil)
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

    if curr_en.gen == prev_en.gen && curr_en.flags.interpolate
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
  if global.debug.enabled
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

    if curr_par.gen == prev_par.gen              &&
       curr_par.props >= {.Active, .Interpolate} &&
       prev_par.props >= {.Active}
    {
      res_gm.particles[i].pos = vmath.lerp(prev_par.pos, curr_par.pos, alpha)
      res_gm.particles[i].scl = vmath.lerp(prev_par.scl, curr_par.scl, alpha)
      res_gm.particles[i].rot = vmath.lerp_angle(prev_par.rot, curr_par.rot, alpha)
    }
  }
}

update_debug_gui :: proc(gm: ^Game, dt: f32)
{
  set_current_game(gm)

  if true
  {
    imgui.Begin("General")

    cursor_pos := platform.get_cursor_position()
    player := gm.special_entities[.Player]
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

    en := gm.special_entities[.Player]

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

    imgui.End()
  }

  set_current_game(nil)
}

camera_follow_point :: proc(point: v2f32, bounds: [2]Range(f32))
{
  gm := get_current_game()
  point := point - {WORLD_WIDTH, WORLD_HEIGHT}/2
  gm.camera.pos.x = clamp(point.x, bounds.x.min, bounds.x.max)
  gm.camera.pos.y = clamp(point.y, bounds.y.min, bounds.y.max)
}

screen_to_world_space :: proc(pos: v2f32) -> (result: v2f32)
{
  gm := get_current_game()

  result = {
    (pos.x - user.viewport.x) * (WORLD_WIDTH / user.viewport.z),
    (pos.y - user.viewport.y) * (WORLD_HEIGHT / user.viewport.w),
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


// Entity ////////////////////////////////////////////////////////////////////////////////


MAX_ENTITIES  :: 4 << 10

Entity :: struct
{
  ref:               Entity_Ref,
  gen:               u32,
  parent:            Entity_Ref,
  children:          [2]Entity_Ref,
  flags:             bit_field u8
  {
    update:          bool | 1,
    render:          bool | 1,
    interpolate:     bool | 1,
  },
  props:             bit_set[Entity_Prop],
  creature_kind:     Creature_Kind,
  projectile_kind:   Projectile_Kind,
  item_kind:         Item_Kind,
  #subtype xform:    tt.Transform,
  vel:               v2f32,
  input_dir:         v2f32,
  movement_speed:    f32,
  health:            i32,
  tint:              v4f32,
  color:             v4f32,
  sprite:            Sprite_Name,
  collider:          Collider,
  col_layer:         Collision_Layer,
  resolve_collision: proc(this, other: ^Entity),
  z_index:           i16,
  z_layer:           enum{Nil, Decoration, Enemy, Player, Projectile},
  attack_timer:      Timer,
  death_timer:       Timer,
  flash_color_timer: Timer,
  flash_color:       v4f32,
  hurt_grace_timer:  Timer,
  flee_timer:        Timer,
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
    reverse:         bool,
    looping:         bool,
    frame_idx:       u16,
  },
  distort:           [2]struct
  {
    saved:           f32,
    target:          f32,
    rate:            f32,
    state:           enum{Hold, Distort, Return},
  },
  equipped:          struct
  {
    weapon_kind:     Weapon_Kind,
    muzzle_timer:    Timer,
  },
  shot_point:        tt.Transform,
}

Entity_Ref :: struct
{
  idx: u32,
  gen: u32,
}

Entity_Prop :: enum
{
  Marked_For_Spawn,
  Marked_For_Death,
  Interpolate,
  Flip_H,
  Flip_V,
  Is_Player,
  Kill_After_Time,
  Rotate_Over_Time,
  Sneaking,
  Flee_Noise,
  Flash_Color,
}

Entity_State :: enum
{
  Idle,
  Bob,
  Expand,
  Wander,
  Flee,
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
}

Entity_State_Context :: struct
{
  dt:     f32,
  target: v2f32,
}

Collision_Layer :: enum
{
  Nil,
  Player,
  Player_Projectile,
  Enemy,
  Item,
}

Creature_Kind :: enum
{
  Nil,
  Deer,
  Rabbit,
}

Decoration_Kind :: enum
{
  Nil,
  Corpse,
}

Weapon_Kind :: enum
{
  Nil,
  Rifle,
}

Projectile_Kind :: enum
{
  Nil,
  Bullet,
}

Item_Kind :: enum
{
  Nil,
  Venison,
  Rabbit_Foot,
}

@(rodata)
NIL_ENTITY: Entity

@(rodata)
COLLISION_MATRIX: [Collision_Layer]bit_set[Collision_Layer] = {
  .Nil               = {.Nil},
  .Player            = {.Item},
  .Player_Projectile = {.Enemy},
  .Enemy             = {.Player_Projectile},
  .Item              = {.Player},
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
  en.flags.update = false
  en.flags.render = false
  en.props += {.Marked_For_Spawn}

  for child in en.children
  {
    child := entity_from_ref(child) or_continue
    child.flags.update = false
    child.flags.render = false
    child.props += {.Marked_For_Spawn}
  }
}

kill_entity :: proc(en: ^Entity, kill_children := true)
{
  en.flags.update = false
  en.props += {.Marked_For_Death}

  if kill_children
  {
    for child_ref in en.children
    {
      child := entity_from_ref(child_ref) or_continue
      child.flags.update = false
      child.props += {.Marked_For_Death}
    }
  }
}

entity_attach_child :: proc(parent, child: ^Entity) -> (ok: bool)
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

entity_child_at :: proc(en: ^Entity, idx: int) -> (res: ^Entity, ok: bool)
{
  return entity_from_ref(en.children[idx])
}

spawn_player :: proc() -> ^Entity
{
  gm := get_current_game()
  player := alloc_entity(gm)
  desc := &res.player

  player.tint = {1, 1, 1, 1}
  player.z_layer = .Player
  player.props += {.Is_Player, .Interpolate}
  player.movement_speed = res.player.speed
  player.animation.data = desc.animations
  player.col_layer = .Player
  player.collider = Circle{
    radius = 6,
  }

  entity_set_state(player, .Idle)
  spawn_shadow(player, .Shadow_S, {0, 7})

  // - Weapon ---
  {
    weapon := alloc_entity(gm)
    weapon.flags.update = true
    weapon.flags.render = false
    weapon.props += {.Interpolate}
    weapon.tint = {1, 1, 1, 1}
    weapon.z_layer = .Player
    weapon.z_index = 1
    weapon.shot_point = tt.alloc_transform(&gm.transform_tree, weapon)
    weapon.animation.data[.Idle] = .Rifle

    tt.set_parent(weapon, player)

    // - Muzzle flash ---
    {
      muzzle_flash := alloc_entity(gm)
      muzzle_flash.flags.update = true
      muzzle_flash.flags.render = true
      muzzle_flash.props += {.Interpolate}
      muzzle_flash.tint = {1, 1, 1, 1}
      muzzle_flash.z_layer = .Player
      muzzle_flash.z_index = 2
      muzzle_flash.flags.render = false
      muzzle_flash.animation.data[.Idle] = .Muzzle_Flash

      tt.set_parent(muzzle_flash, weapon)
      entity_attach_child(weapon, muzzle_flash)
    }

    entity_attach_child(player, weapon)
  }

  entity_equip_weapon(player, .Rifle)

  player.flags.render = true
  player.flags.update = true

  return player
}

spawn_creature :: proc(kind: Creature_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()
  creature := alloc_entity(gm)
  desc := &res.creatures[kind]

  creature.creature_kind = kind
  creature.props += {.Interpolate, .Flee_Noise}
  creature.tint = {1, 1, 1, 1}
  creature.z_layer = .Enemy
  creature.col_layer = .Enemy
  creature.resolve_collision = entity_resolve_collision_creature
  creature.health = desc.health
  creature.animation.data = desc.animations
  creature.collider = res.creatures[kind].collider

  tt.local(creature).pos = pos

  switch kind
  {
  case .Nil:

  case .Deer:
    entity_set_state(creature, .Wander)
    spawn_shadow(creature, .Shadow_L, {-2, 7})

  case .Rabbit:
    entity_set_state(creature, .Idle)
    spawn_shadow(creature, .Shadow_M, {-2, 7})
  }

  if deferred
  {
    defer_entity_spawn(creature)
  }
  else
  {
    creature.flags.update = true
    creature.flags.render = true
  }

  return creature
}

spawn_projectile :: proc(kind: Projectile_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()
  projectile := alloc_entity(gm)

  projectile.projectile_kind = kind
  projectile.props += {.Interpolate, .Kill_After_Time}
  projectile.z_layer = .Projectile
  projectile.tint = {1, 1, 1, 1}
  projectile.animation.data[.Idle] = .Bullet
  projectile.col_layer = .Player_Projectile
  projectile.resolve_collision = entity_resolve_collision_projectile
  projectile.collider = Circle{
    radius = 3,
  }

  tt.local(projectile).pos = pos

  if deferred
  {
    defer_entity_spawn(projectile)
  }
  else
  {
    projectile.flags.render = true
    projectile.flags.update = true
  }

  return projectile
}

spawn_item :: proc(kind: Item_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()
  item := alloc_entity(gm)
  desc := &res.items[kind]

  item.item_kind = kind
  item.props += {.Interpolate}
  item.z_layer = .Decoration
  item.col_layer = .Item
  item.tint = {1, 1, 1, 1}
  item.animation.data = desc.animations
  item.resolve_collision = entity_resolve_collision_item
  item.collider = Circle{
    radius = 4,
  }

  tt.local(item).pos = pos

  entity_set_state(item, .Bob)

  if deferred
  {
    defer_entity_spawn(item)
  }
  else
  {
    item.flags.render = true
    item.flags.update = true
  }

  return item
}

spawn_corpse :: proc(owner: ^Entity, deferred := false) -> ^Entity
{
  assert(owner.creature_kind != .Nil)

  gm := get_current_game()
  corpse := alloc_entity(gm)
  creature_desc := &res.creatures[owner.creature_kind]

  corpse.props += {.Interpolate}
  corpse.props += owner.props & {.Flip_H}
  corpse.tint = {1, 1, 1, 1}
  corpse.animation.data[.Idle] = creature_desc.corpse

  tt.local(corpse).pos = tt.global_pos(owner) + {0, 5}

  // - Blood pool ---
  {
    blood_pool := alloc_entity(gm)
    blood_pool.flags.update = true
    blood_pool.flags.render = true
    blood_pool.props += {.Interpolate}
    blood_pool.tint = {1, 1, 1, 1}
    blood_pool.z_index = -1
    blood_pool.animation.data[.Idle] = .Blood_Pool_0
    blood_pool.animation.data[.Expand] = creature_desc.blood_pool

    entity_play_animation(blood_pool, .Expand, looping=false)

    entity_attach_child(corpse, blood_pool)
    tt.attach_child(corpse, blood_pool)
  }

  if deferred
  {
    defer_entity_spawn(corpse)
  }
  else
  {
    corpse.flags.update = true
    corpse.flags.render = true
  }

  return corpse
}

spawn_shadow :: proc(owner: ^Entity, sprite: Sprite_Or_Animation, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()

  shadow := alloc_entity(gm)
  shadow.props += {.Interpolate}
  shadow.tint = {1, 1, 1, 1}
  shadow.color = {0.2, 0.2, 0.2, 0}
  shadow.tint.a = 0.5
  shadow.animation.data[.Idle] = sprite
  shadow.z_index = -999
  tt.local(shadow).pos = pos

  tt.set_parent(shadow, owner)
  entity_attach_child(owner, shadow)

  if deferred
  {
    defer_entity_spawn(shadow)
  }
  else
  {
    shadow.flags.update = true
    shadow.flags.render = true
  }

  return shadow
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

entity_resolve_collision_stub :: proc(this, other: ^Entity) {}

entity_resolve_collision_creature :: proc(this, other: ^Entity)
{
  assert(this.creature_kind != .Nil)

  this.health -= 1

  if this.health == 0
  {
    kill_entity(this)

    item_kind := roll_loot_table(res.creatures[this.creature_kind].loot_table)
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

  entity_set_state(this, .Flee)
}

entity_resolve_collision_projectile :: proc(this, other: ^Entity)
{
  kill_entity(this)
}

entity_resolve_collision_item :: proc(this, other: ^Entity)
{
  gm := get_current_game()
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

// entity_rotate_to_target :: proc(en: ^Entity, target: v2f32)
// {
//   diff := target - tt.global_pos(en)
//   tt.local(en).rot = math.atan2(diff.y, diff.x)
//   if tt.global_rot(en) < 0
//   {
//     tt.local(en).rot += math.TAU
//   }
// }

entity_flip_dir :: proc(en: ^Entity) -> v2f32
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
    local_pos := vmath.rotation_2x2f(tt.local(en).rot) * (-dim * pivot)
    return local_pos + tt.local(en).pos
  }

  result := vmath.scale_3x3f(tt.local(en).scl)
  result = vmath.rotation_3x3f(tt.local(en).rot) * result
  result = vmath.translation_3x3f(top_left(en)) * result
  return result
}

entity_collider_update :: proc(en: ^Entity, dt: f32)
{
  // NOTE(dg): This is a stub.
  @(static)
  collider_map: [Sprite_Name]struct
  {
    origin:       [2]f32,
    vertices:     [6][2]f32,
    vertex_count: u8,
  }

  switch &collider in en.collider
  {
  case Circle:
    collider.origin = tt.global_pos(en) + res.creatures[en.creature_kind].collider.origin
    debug_circle(collider.origin, collider.radius, alpha=0.25)

  case Polygon:
    collider.number = collider_map[en.sprite].vertex_count
    for i in 0..<collider.number
    {
      v := entity_xform(en) * vmath.concat(collider_map[en.sprite].vertices[i], 1)
      collider.vertices[i] = v.xy
    }

    for vert in collider.vertices[:collider.number]
    {
      debug_circle(vert, 4, color={0, 1, 0, 0}, alpha=0.75)
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

entity_distort :: proc(en: ^Entity, axis: enum{W, H}, target, rate: f32)
{
  en.distort[axis].rate = rate
  en.distort[axis].target = target
  en.distort[axis].saved = tt.local(en).scl.x
  en.distort[axis].state = .Distort
}

entity_equip_weapon :: proc(en: ^Entity, kind: Weapon_Kind)
{
  if !entity_is_valid(en) do return

  weapon, ok := entity_child_at(en, 1)
  if !ok do return

  weapon.flags.render = kind != .Nil

  gm := get_current_game()
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

  gm := get_current_game()
  gm.weapon.holstered = holster

  weapon, ok := entity_child_at(en, 1)
  if !ok do return

  if gm.weapon.kind != .Nil
  {
    if holster
    {
      en.equipped.weapon_kind = .Nil
      weapon.z_layer = .Decoration
    }
    else
    {
      en.equipped.weapon_kind = gm.weapon.kind
      weapon.z_layer = .Player
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

  if en.creature_kind != .Nil
  {
    #partial switch en.state
    {
    case .Idle:   en.update_state = creature_state_idle
    case .Wander: en.update_state = creature_state_wander
    case .Flee:   en.update_state = creature_state_flee
    }
  }
  else if en.item_kind != .Nil
  {
    #partial switch en.state
    {
    case .Bob: en.update_state = item_state_bob
    }
  }
}

entity_state_stub :: proc(this: ^Entity, ctx: ^Entity_State_Context) {}

creature_state_idle :: proc(this: ^Entity, ctx: ^Entity_State_Context)
{
  entity_play_animation(this, .Idle, looping=true)
}

creature_state_wander :: proc(en: ^Entity, using ctx: ^Entity_State_Context)
{
  assert(ctx != nil)

  creature_desc := &res.creatures[en.creature_kind]
  wander := &en.state_data.wander
  en_pos := tt.global_pos(en)

  switch wander.state
  {
  case .Choose:
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
    wander.state = .Move

  case .Move:
    entity_play_animation(en, .Walk, looping=true)
    debug_circle(wander.point, 4)

    arrived := entity_move_to_point(en, wander.point, creature_desc.speed*dt)
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

creature_state_flee :: proc(en: ^Entity, using ctx: ^Entity_State_Context)
{
  assert(ctx != nil)

  creature_desc := &res.creatures[en.creature_kind]
  flee := &en.state_data.flee
  en_pos := tt.global_pos(en)

  FLEE_SPEED_MULT :: 2.5

  switch flee.state
  {
  case .Choose:
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
    flee.state = .Move

  case .Move:
    speed := creature_desc.speed * FLEE_SPEED_MULT * dt
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

item_state_bob :: proc(this: ^Entity, using ctx: ^Entity_State_Context)
{
  MAX_DISPLACEMENT :: 2.0

  bob := &this.state_data.bob
  dy := 5 * dt

  switch bob.state
  {
  case .Up:
    tt.local(this).pos.y -= dy
    bob.displacement += dy
    if bob.displacement >= MAX_DISPLACEMENT
    {
      bob.state = .Down
    }

  case .Down:
    tt.local(this).pos.y += dy
    bob.displacement -= dy
    if bob.displacement <= -MAX_DISPLACEMENT
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


// Debug_Entity //////////////////////////////////////////////////////////////////////////


Debug_Entity :: distinct Entity

push_debug_entity :: proc() -> ^Debug_Entity
{
  gm := get_current_game()

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
  gm := get_current_game()

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
  opacity: f32 = 0.65,
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
  alpha:  f32 = 0.65,
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


// Region ///////////////////////////////////////////////////////////////////////////////////


TILE_SIZE         :: 8
REGION_GAP_TILES  :: 2
REGION_GAP        :: REGION_GAP_TILES * TILE_SIZE
REGION_SPAN_TILES :: 64 + REGION_GAP_TILES * 2
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
  return int(coord.x + coord.y * 3)
}

region_coord_from_idx :: proc(idx: int) -> Region_Coord
{
  return {f32(idx % 3), f32(idx / 3)}
}

region_from_world_pos :: proc(pos: v2f32) -> Region_Coord
{
  return {
    f32(pos.x / REGION_SPAN),
    f32(pos.y / REGION_SPAN),
  }
}

region_pos_from_world_pos :: proc(pos: v2f32) -> v2f32
{
  gm := get_current_game()
  region_pos := region_pos_to_world_pos({0, 0})
  return {
    region_pos.x != 0 ? f32(int(pos.x) % int(region_pos.x)) : pos.x,
    region_pos.y != 0 ? f32(int(pos.y) % int(region_pos.y)) : pos.y,
  }
}

region_pos_to_world_pos :: proc(pos: v2f32, region := Region_Coord{-1, -1}) -> v2f32
{
  gm := get_current_game()

  region := region
  if region == {-1, -1}
  {
    region = gm.active_region
  }

  return pos + {REGION_SPAN, REGION_SPAN} * v2f32(region)
}

point_in_region_bounds :: proc(point: v2f32, region: Region_Coord) -> bool
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
      coord: [2]f64 = array_cast(tile_coord_from_idx(tile_idx), f64)
      noise_scale: f64 = 0.05
      noise_value: f32 = math.abs(noise.noise_2d(rand.num_i63(), coord * noise_scale))

      sprite: Sprite_Name
      switch region_idx
      {
      case 0..=4:
        if noise_value > 0.95
        {
          sprite = .Tile_Grass_2
        }
        else if noise_value > 0.9
        {
          sprite = .Tile_Grass_1
        }
        else
        {
          sprite = .Tile_Grass_0
        }

      case 5..=9:
        if noise_value > 0.9
        {
          sprite = .Tile_Stone_1
        }
        else
        {
          sprite = .Tile_Stone_0
        }
      }

      if coord.x < REGION_GAP_TILES || REGION_SPAN_TILES - coord.x <= REGION_GAP_TILES ||
         coord.y < REGION_GAP_TILES || REGION_SPAN_TILES - coord.y <= REGION_GAP_TILES
      {
        if !(coord.x == REGION_SPAN_TILES/2 || coord.y == REGION_SPAN_TILES/2)
        {
          sprite = .Tile_Dirt
        }
      }

      rot := cast(f16) rand.range_i31({0, 4}) * math.PI/2.0
      
      gm.regions[region_idx][tile_idx] = Tile{
        sprite = sprite,
        rot = rot,
      }
    }
  }
}


// Particle //////////////////////////////////////////////////////////////////////////////


MAX_PARTICLES :: 4 << 10

Particle :: struct
{
  gen:           u16,
  props:         bit_set[Particle_Prop],
  kind:          Particle_Name,
  sprite:        Sprite_Name,
  emmision_kind: Particle_Emmision_Kind,
  kill_timer:    Timer,
  tint:          v4f32,
  color:         v4f32,
  pos:           v2f32,
  scl:           v2f32,
  vel:           v2f32,
  acc:           v2f32,
  dir:           f32,
  rot:           f32,
  rot_dt:        f32,
}

Particle_Prop :: enum
{
  Active,
  Render,
  Interpolate,
  Rotate_Over_Time,
  Scale_Over_Time,
  Persist,
}

Particle_Emmision_Kind :: enum
{
  Static,
  Burst,
}

spawn_particles :: proc(kind: Particle_Name, pos: v2f32)
{
  push_particle :: proc(gm: ^Game) -> ^Particle
  {
    idx := gm.particles_pos % MAX_PARTICLES
    result := &gm.particles[idx]
    gm.particles_pos += 1

    old_gen := result.gen
    result^ = {}
    result.gen = old_gen + 1
    result.props = {.Active, .Render, .Interpolate}
    result.tint = {1, 1, 1, 1}
    result.color = {0, 0, 0, 1}

    return result
  }

  gm := get_current_game()
  desc := &res.particles[kind]

  for i in 0..<desc.count
  {
    par := push_particle(gm)
    par.kind = kind
    par.props += desc.props
    par.sprite = desc.sprite
    par.pos = pos
    par.scl = desc.scl + rand.range_f32({-desc.scl_var, desc.scl_var})
    par.rot = desc.rot
    par.rot_dt = desc.rot_dt
    par.vel = desc.vel
    par.acc = desc.vel_dt
    par.color = rand.choice_slice(desc.colors[:])

    lifetime := desc.lifetime + rand.range_f32({-desc.lifetime_var, desc.lifetime_var})
    timer_start(&par.kill_timer, lifetime)

    switch desc.emmision_kind
    {
    case .Static:

    case .Burst:
      par.dir = rand.range_f32({0, 2*math.PI})
      par.vel.x *= math.cos(par.dir)
      par.vel.y *= math.sin(par.dir)
    }
  }
}

particle_update :: proc(par: ^Particle, dt: f32)
{
  par.vel += par.acc * dt
  par.pos += par.vel * dt

  if .Rotate_Over_Time in par.props
  {
    par.rot += dt * 2
  }

  if .Scale_Over_Time in par.props
  {
    par.scl += res.particles[par.kind].scl_dt * dt
    par.scl.x = max(par.scl.x, 0)
    par.scl.y = max(par.scl.y, 0)
  }

  if timer_timeout(&par.kill_timer)
  {
    par.props -= {.Active}
  }

  if par.props & {.Active, .Persist} == nil
  {
    par.props -= {.Render}
  }
}


// Timer /////////////////////////////////////////////////////////////////////////////////


Timer :: struct
{
  end_time: f32,
  ticking:  bool,
}

timer_start :: proc(timer: ^Timer, duration: f32)
{
  timer.end_time = get_current_game().t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> bool
{
  return timer.ticking && get_current_game().t >= timer.end_time
}

timer_remaining :: proc(timer: ^Timer) -> f32
{
  return timer.end_time - get_current_game().t
}


// Input ///////////////////////////////////////////////////////////////////////////////////


key_down :: platform.key_down
key_up   :: platform.key_up

@(require_results)
key_just_down :: proc(key: platform.Key_Kind) -> bool
{
  return key_down(key) && !get_current_game().prev_keys[key]
}

@(require_results)
key_just_up :: proc(key: platform.Key_Kind) -> bool
{
  return key_up(key) && get_current_game().prev_keys[key]
}

mouse_btn_down :: platform.mouse_btn_down
mouse_btn_up   :: platform.mouse_btn_up

@(require_results)
mouse_btn_just_down :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_down(btn) && !get_current_game().prev_mouse_btns[btn]
}

@(require_results)
mouse_btn_just_up :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_up(btn) && get_current_game().prev_mouse_btns[btn]
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
