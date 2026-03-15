package game

import tt "transform_tree"

/*

- SPAWN ENTITY TEMPLATE ---

spawn_ :: proc(pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()

  en := alloc_entity(gm)
  setup(en, deferred)

  return en
}

*/

@(private="file")
setup :: proc(en: ^Entity, deferred: bool)
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
  gm := get_current_game()

  player := alloc_entity(gm)
  setup(player, true)

  desc := &res.player

  player.z_layer = .Player
  player.props += {.Is_Player, .Interpolate}
  player.movement_speed = res.player.speed
  player.animation.data = desc.animations
  player.col_layer = .Player
  player.collider = Circle{
    radius = 6,
  }

  entity_set_state(player, .Idle)
  spawn_shadow(player, .Shadow_1, {0, -0.5})

  // - Weapon ---
  {
    weapon := alloc_entity(gm)
    setup(weapon, true)
    
    weapon.props += {.Interpolate}
    weapon.z_layer = .Player
    weapon.z_index = 1
    weapon.shot_point = tt.alloc_transform(&gm.transform_tree, weapon)
    weapon.animation.data[.Idle] = .Rifle

    tt.set_parent(weapon, player)

    // - Muzzle flash ---
    {
      muzzle_flash := alloc_entity(gm)
      setup(muzzle_flash, false)

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

  entity_equip_weapon(player, .Rifle)

  return player
}

spawn_creature :: proc(kind: Creature_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()

  creature := alloc_entity(gm)
  setup(creature, deferred)

  desc := &res.creatures[kind]

  creature.creature_kind = kind
  creature.props += {.Interpolate, .Flee_Noise}
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
    entity_set_state(creature, .Idle)
    spawn_shadow(creature, .Shadow_3, {0, -1.5})

  case .Rabbit:
    entity_set_state(creature, .Idle)
    spawn_shadow(creature, .Shadow_2, {0.5, -1.5})

  case .Squirrel:
    entity_set_state(creature, .Idle)
    spawn_shadow(creature, .Shadow_1, {-0.5, -1.5})
  }

  return creature
}

spawn_projectile :: proc(kind: Projectile_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()

  projectile := alloc_entity(gm)
  setup(projectile, deferred)

  projectile.projectile_kind = kind
  projectile.props += {.Interpolate, .Kill_After_Time}
  projectile.z_layer = .Projectile
  projectile.animation.data[.Idle] = .Bullet
  projectile.col_layer = .Player_Projectile
  projectile.resolve_collision = entity_resolve_collision_projectile
  projectile.collider = Circle{
    radius = 3,
  }

  tt.local(projectile).pos = pos

  return projectile
}

spawn_item :: proc(kind: Item_Kind, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()
  
  item := alloc_entity(gm)
  setup(item, deferred)

  desc := &res.items[kind]

  item.item_kind = kind
  item.props += {.Interpolate}
  item.z_index = 100
  item.col_layer = .Item
  item.animation.data = desc.animations
  item.resolve_collision = entity_resolve_collision_item
  item.collider = Circle{
    radius = 4,
  }

  tt.local(item).pos = pos

  entity_set_state(item, .Bob)

  return item
}

spawn_corpse :: proc(owner: ^Entity, deferred := false) -> ^Entity
{
  assert(owner.creature_kind != .Nil)

  gm := get_current_game()
  corpse := alloc_entity(gm)
  setup(corpse, deferred)

  creature_desc := &res.creatures[owner.creature_kind]

  corpse.props += {.Interpolate}
  corpse.props += owner.props & {.Flip_H}
  corpse.animation.data[.Idle] = creature_desc.corpse

  tt.local(corpse).pos = tt.global_pos(owner) + {0, 0}

  // - Blood pool ---
  {
    blood_pool := alloc_entity(gm)
    setup(blood_pool, false)

    blood_pool.props += {.Interpolate}
    blood_pool.z_index = -1
    blood_pool.animation.data[.Idle] = .Blood_Pool_1
    blood_pool.animation.data[.Expand] = creature_desc.blood_pool

    entity_play_animation(blood_pool, .Expand, looping=false)

    entity_attach_child(corpse, blood_pool)
    tt.attach_child(corpse, blood_pool)
  }

  return corpse
}

spawn_shadow :: proc(owner: ^Entity, sprite: Sprite_Or_Animation, pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()

  shadow := alloc_entity(gm)
  setup(shadow, deferred)

  shadow.props += {.Interpolate}
  shadow.color = {0.2, 0.2, 0.2, 0}
  shadow.tint.a = 0.5
  shadow.animation.data[.Idle] = sprite
  shadow.z_index = -999
  tt.local(shadow).pos = pos

  tt.set_parent(shadow, owner)
  entity_attach_child(owner, shadow)

  return shadow
}

spawn_grass :: proc(pos: v2f32, deferred := false) -> ^Entity
{
  gm := get_current_game()
  
  grass := alloc_entity(gm)
  setup(grass, deferred)

  grass.sprite = .Grass
  tt.local(grass).pos = pos

  return grass 
}
