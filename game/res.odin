#+feature dynamic-literals
package game

import "core:image/qoi"

import "basic"
import "basic/mem"
import "platform"
import "render"

Resources :: struct
{
  actions:    [Action_Name]platform.Input_Source,
  textures:   [render.Texture_ID]render.Texture,
  sprites:    [Sprite_Name]Sprite,
  sounds:     [Sound_Name]Sound,
  animations: [Animation_Name]Animation_Desc,
  particles:  [Particle_Name]Particle_Desc,
  player:     Player_Desc,
  creatures:  [Creature_Kind]Creature_Desc,
  weapons:    [Weapon_Kind]Weapon_Desc,
}

Sprite_Name :: enum u16
{
  NIL,
  SQUARE,
  CIRCLE,
  SHADOW_PLAYER,
  SHADOW_DEER,
  PLAYER_IDLE_0,
  PLAYER_IDLE_1,
  PLAYER_WALK_0,
  PLAYER_WALK_1,
  PLAYER_WALK_2,
  PLAYER_WALK_3,
  PLAYER_WALK_4,
  PLAYER_SNEAK_0,
  PLAYER_SNEAK_1,
  PLAYER_SNEAK_2,
  PLAYER_SNEAK_3,
  PLAYER_SNEAK_4,
  RIFLE,
  SHOTGUN,
  MUZZLE_FLASH,
  BULLET,
  SMOKE_PARTICLE,
  BLOOD_PARTICLE,
  DEER_IDLE_0,
  DEER_IDLE_1,
  DEER_IDLE_2,
  DEER_IDLE_3,
  DEER_WALK_0,
  DEER_WALK_1,
  DEER_WALK_2,
  DEER_WALK_3,
  DEER_CORPSE,
  BLOOD_POOL_0,
  BLOOD_POOL_1,
  BLOOD_POOL_2,
  BLOOD_POOL_3,
  BLOOD_POOL_4,
  BLOOD_POOL_5,
  TILE_DIRT,
  TILE_GRASS_0,
  TILE_GRASS_1,
  TILE_GRASS_2,
  TILE_STONE_0,
  TILE_STONE_1,
  TILE_WALL,
}

Sound_Name :: enum
{
  NIL,
  THUNK,
  GUN_SHOT,
  MINECRAFT,
}

Sound_Group :: enum
{
  NIL,
  AMBIENCE,
  MUSIC,
  EFFECT,
}

Action_Name :: enum
{
  NIL,
  UP,
  DOWN,
  RIGHT,
  LEFT,
  SNEAK,
  ATTACK,
}

Animation_Name :: enum
{
  NIL,
  PLAYER_WALK,
  PLAYER_SNEAK_WALK,
  DEER_IDLE,
  DEER_WALK,
  BLOOD_POOL_EXPAND,
}

Animation_State :: enum
{
  IDLE,
  WALK,
  SNEAK_WALK,
  SNEAK_IDLE,
  EXPAND,
}

Animation_Desc :: struct
{
  frames:     [dynamic]struct
  {
    sprite:   Sprite_Name,
    duration: f32,
  },
}

Particle_Name :: enum
{
  NIL,
  GUN_SMOKE,
  DEATH_BLOOD,
}

Particle_Desc :: struct
{
  sprite:        Sprite_Name,
  emmision_kind: Particle_Emmision_Kind,
  props:         bit_set[Particle_Prop],
  count:         u16,
  lifetime:      f32,
  spread:        f32,
  colors:        [dynamic]f32x4,
  scl:           f32x2,
  scl_dt:        f32x2,
  scl_var:       f32,
  vel:           f32x2,
  vel_dt:        f32x2,
  dir:           f32,
  dir_dt:        f32,
  rot:           f32,
  rot_dt:        f32,
}

Weapon_Desc :: struct
{
  sprite:      Sprite_Name,
  shot_point:  f32x2,
  shot_time:   f32,
  reload_time: f32,
  damage:      f32,
  speed:       f32,
  capacity:    u16,
}

Player_Desc :: struct
{
  speed: f32,
}

Creature_Desc :: struct
{
  animations:   [Animation_State]Animation_Name,
  wander_range: Range(i32),
  flee_range:   Range(i32),
  health:       int,
  speed:        f32,
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  context.allocator = mem.allocator(arena)

  // - Actions ---
  {
    using platform

    res.actions = [Action_Name]Input_Source{
      .NIL = nil,
      .UP = Key_Kind.W,
      .DOWN = Key_Kind.S,
      .RIGHT = Key_Kind.D,
      .LEFT = Key_Kind.A,
      .SNEAK = Key_Kind.LEFT_SHIFT,
      .ATTACK = Mouse_Btn_Kind.LEFT,
    }
  }

  // - Textures ---
  {
    img: ^qoi.Image
    err: qoi.Error

    img, err = qoi.load_from_file("res/textures/sprite_map.qoi")
    if err != nil
    {
      panicf("Failed to open texture file!", err)
    }

    res.textures[.SPRITE_MAP] = render.Texture{
      data = img.pixels.buf[:],
      width = cast(i32) img.width,
      height = cast(i32) img.height,
      cell = 16,
    }
  }

  // - Sprites ---
  {
    res.sprites = [Sprite_Name]Sprite{
      .NIL            = {coords={0, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .SQUARE         = {coords={1, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .CIRCLE         = {coords={2, 0},  grid={1, 1}, pivot={8.5, 8.5}},
      .SHADOW_PLAYER  = {coords={3, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .SHADOW_DEER    = {coords={4, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .PLAYER_IDLE_0  = {coords={0, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_IDLE_1  = {coords={1, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_0  = {coords={2, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_1  = {coords={3, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_2  = {coords={4, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_3  = {coords={5, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_4  = {coords={6, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_SNEAK_0 = {coords={7, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_SNEAK_1 = {coords={8, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_SNEAK_2 = {coords={9, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_SNEAK_3 = {coords={10, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_SNEAK_4 = {coords={11, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .RIFLE          = {coords={0, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .SHOTGUN        = {coords={1, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .MUZZLE_FLASH   = {coords={0, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .BULLET         = {coords={1, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .SMOKE_PARTICLE = {coords={2, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .BLOOD_PARTICLE = {coords={3, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .DEER_IDLE_0    = {coords={0, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_1    = {coords={1, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_2    = {coords={2, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_3    = {coords={3, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_0    = {coords={4, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_1    = {coords={5, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_2    = {coords={6, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_3    = {coords={7, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_CORPSE    = {coords={8, 4},  grid={2, 1}, pivot={15.0, 15.0}},
      .BLOOD_POOL_0   = {coords={0, 6},  grid={1, 1}, pivot={8, 10}},
      .BLOOD_POOL_1   = {coords={1, 6},  grid={1, 1}, pivot={8, 10}},
      .BLOOD_POOL_2   = {coords={2, 6},  grid={1, 1}, pivot={8, 10}},
      .BLOOD_POOL_3   = {coords={3, 6},  grid={1, 1}, pivot={8, 10}},
      .BLOOD_POOL_4   = {coords={4, 6},  grid={1, 1}, pivot={8, 10}},
      .BLOOD_POOL_5   = {coords={5, 6},  grid={1, 1}, pivot={8, 10}},
      .TILE_DIRT      = {coords={0, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_0   = {coords={1, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_1   = {coords={2, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_2   = {coords={3, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_STONE_0   = {coords={4, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_STONE_1   = {coords={5, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_WALL      = {coords={6, 7},  grid={1, 1}, pivot={8.0, 8.0}},
    }

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= basic.array_cast(sprite.grid, f32) * 16
    }
  }

  // - Sound ---
  {
    res.sounds = [Sound_Name]Sound{
      .NIL       = {},
      .THUNK     = {path="res/sounds/thunk.wav", group=.EFFECT},
      .GUN_SHOT  = {path="res/sounds/gun_shot.wav", group=.EFFECT},
      .MINECRAFT = {path="res/sounds/minecraft.wav", group=.MUSIC},
    }
  }

  // - Animations ---
  {
    res.animations = [Animation_Name]Animation_Desc{
      .NIL = {},
      .PLAYER_WALK = {
        frames = {
          {sprite=.PLAYER_WALK_0, duration=0.08},
          {sprite=.PLAYER_WALK_1, duration=0.08},
          {sprite=.PLAYER_WALK_2, duration=0.08},
          {sprite=.PLAYER_WALK_3, duration=0.08},
          {sprite=.PLAYER_WALK_4, duration=0.08},
        },
      },
      .PLAYER_SNEAK_WALK = {
        frames = {
          {sprite=.PLAYER_SNEAK_0, duration=0.08},
          {sprite=.PLAYER_SNEAK_1, duration=0.08},
          {sprite=.PLAYER_SNEAK_2, duration=0.08},
          {sprite=.PLAYER_SNEAK_3, duration=0.08},
          {sprite=.PLAYER_SNEAK_4, duration=0.08},
        },
      },
      .DEER_IDLE = {
        frames = {
          {sprite=.DEER_IDLE_0, duration=0.3}, 
          {sprite=.DEER_IDLE_1, duration=0.3},
          {sprite=.DEER_IDLE_2, duration=0.3},
          {sprite=.DEER_IDLE_3, duration=0.3},
        },
      },
      .DEER_WALK = {
        frames = {
          {sprite=.DEER_WALK_0, duration=0.15}, 
          {sprite=.DEER_WALK_1, duration=0.15},
          {sprite=.DEER_WALK_2, duration=0.15},
          {sprite=.DEER_WALK_3, duration=0.15},
        },
      },
      .BLOOD_POOL_EXPAND = {
        frames = {
          {sprite=.BLOOD_POOL_0, duration=0.15},
          {sprite=.BLOOD_POOL_1, duration=0.15},
          {sprite=.BLOOD_POOL_2, duration=0.15},
          {sprite=.BLOOD_POOL_3, duration=0.15},
          {sprite=.BLOOD_POOL_4, duration=0.15},
          {sprite=.BLOOD_POOL_5, duration=0.15},
        },
      },
    }
  }

  // - Particles ---
  {
    res.particles = [Particle_Name]Particle_Desc{
      .NIL = {},
      .GUN_SMOKE = {
        sprite = .SMOKE_PARTICLE,
        emmision_kind = .BURST,
        colors = {{0.5, 0.5, 0.5, 0}, {0.4, 0.4, 0.4, 0}, {0.3, 0.3, 0.3, 0}},
        count = 4,
        lifetime = 3.0,
        scl = {0.7, 0.7},
        scl_dt = -{0.7, 0.7},
        vel = {48.0, 48.0},
        vel_dt = {0, -120},
      },
      .DEATH_BLOOD = {
        sprite = .BLOOD_PARTICLE,
        emmision_kind = .BURST,
        colors = {{0.5, 0, 0, 0}, {0.4, 0, 0, 0}, {0.3, 0, 0, 0}},
        count = 10,
        lifetime = 0.3,
        scl = {0.5, 0.5},
        scl_var = 0.2,
        vel = {96, 96},
        vel_dt = {0, 256},
      },
    }
  }

  // - Player
  {
    res.player.speed = 60
  }

  // - Creature ---
  {
    res.creatures = [Creature_Kind]Creature_Desc{
      .NIL = {},
      .DEER = {
        animations = #partial {
          .IDLE = .DEER_IDLE,
          .WALK = .DEER_WALK,
        },
        wander_range = {10, 50},
        flee_range = {50, 100},
        health = 2,
        speed = 35,
      },
    }
  }

  // - Weapons ---
  {
    res.weapons = [Weapon_Kind]Weapon_Desc{
      .NIL = {},
      .RIFLE = {
        sprite = .RIFLE,
        shot_point = {11.0, 0.0},
        shot_time = 0.35,
        reload_time = 3.0,
        damage = 7,
        speed = 512.0,
        capacity = 5,
      },
    }
  }
}
