#+feature dynamic-literals
package game

import "core:image/qoi"

import "basic"
import "basic/mem"
import "render"

Resources :: struct
{
  textures:   [render.Texture_ID]render.Texture,
  sprites:    [Sprite_Name]Sprite,
  animations: [Animation_Name]Animation_Desc,
  particles:  [Particle_Name]Particle_Desc,
  creatures:  [Creature_Kind]Creature_Desc,
  weapons:    [Weapon_Kind]Weapon_Desc,
}

Sprite :: struct
{
  coords:  [2]f32,
  grid:    [2]f32,
  pivot:   v2f32,
  texture: render.Texture_ID,
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
  RIFLE,
  SHOTGUN,
  MUZZLE_FLASH,
  BULLET,
  SMOKE_PARTICLE,
  DEER_IDLE_0,
  DEER_IDLE_1,
  DEER_IDLE_2,
  DEER_IDLE_3,
  DEER_WALK_0,
  DEER_WALK_1,
  DEER_WALK_2,
  DEER_WALK_3,
  TILE_DIRT,
  TILE_GRASS_0,
  TILE_GRASS_1,
  TILE_GRASS_2,
  TILE_STONE_0,
  TILE_STONE_1,
  TILE_WALL,
}

Animation_Name :: enum
{
  NIL,
  PLAYER_IDLE,
  PLAYER_WALK,
  DEER_IDLE,
  DEER_WALK,
}

Animation_State :: enum
{
  NIL,
  IDLE,
  WALK,
}

Animation_Desc :: struct
{
  frames:     [dynamic]struct
  {
    sprite:   Sprite_Name,
    ticks:    u16,
  },
}

Particle_Name :: enum
{
  NIL,
  GUN_SMOKE,
}

Particle_Desc :: struct
{
  sprite:        Sprite_Name,
  emmision_kind: Particle_Emmision_Kind,
  props:         bit_set[Particle_Prop],
  count:         u16,
  lifetime:      f32,
  spread:        f32,
  color_a:       v4f32,
  color_b:       v4f32,
  speed:         f32,
  speed_dt:      f32,
  scl:           v2f32,
  scl_dt:        v2f32,
  dir:           f32,
  dir_dt:        f32,
  rot:           f32,
  rot_dt:        f32,
}

Weapon_Desc :: struct
{
  sprite:      Sprite_Name,
  shot_point:  v2f32,
  shot_time:   f32,
  reload_time: f32,
  damage:      f32,
  speed:       f32,
  capacity:    u16,
}

Creature_Desc :: struct
{
  animations:   [Animation_State]Animation_Name,
  wander_range: Range(i32),
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  context.allocator = mem.allocator(arena)

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
      .NIL            = {coords={0, 0}, grid={1, 1}, pivot={7.5, 7.5}},
      .SQUARE         = {coords={1, 0}, grid={1, 1}, pivot={7.5, 7.5}},
      .CIRCLE         = {coords={2, 0}, grid={1, 1}, pivot={8.5, 8.5}},
      .SHADOW_PLAYER  = {coords={3, 0}, grid={1, 1}, pivot={7.5, 14.5}},
      .SHADOW_DEER    = {coords={4, 0}, grid={1, 1}, pivot={7.5, 14.5}},
      .PLAYER_IDLE_0  = {coords={0, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_IDLE_1  = {coords={1, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_0  = {coords={2, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_1  = {coords={3, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_2  = {coords={4, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_3  = {coords={5, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .PLAYER_WALK_4  = {coords={6, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .RIFLE          = {coords={0, 2}, grid={1, 1}, pivot={4.5, 8.5}},
      .SHOTGUN        = {coords={1, 2}, grid={1, 1}, pivot={4.5, 8.5}},
      .MUZZLE_FLASH   = {coords={0, 3}, grid={1, 1}, pivot={8.5, 8.5}},
      .BULLET         = {coords={1, 3}, grid={1, 1}, pivot={8.5, 8.5}},
      .SMOKE_PARTICLE = {coords={2, 3}, grid={1, 1}, pivot={8.5, 8.5}},
      .DEER_IDLE_0    = {coords={0, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_1    = {coords={1, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_2    = {coords={2, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_IDLE_3    = {coords={3, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_0    = {coords={4, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_1    = {coords={5, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_2    = {coords={6, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .DEER_WALK_3    = {coords={7, 4}, grid={1, 1}, pivot={7.5, 8.5}},
      .TILE_DIRT      = {coords={0, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_0   = {coords={1, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_1   = {coords={2, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_GRASS_2   = {coords={3, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_STONE_0   = {coords={4, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_STONE_1   = {coords={5, 6}, grid={1, 1}, pivot={8.0, 8.0}},
      .TILE_WALL      = {coords={6, 6}, grid={1, 1}, pivot={8.0, 8.0}},
    }

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= basic.array_cast(sprite.grid, f32) * 16
    }
  }

  // - Animations ---
  {
    res.animations = [Animation_Name]Animation_Desc{
      .NIL = {},
      .PLAYER_IDLE = {
        frames = {
          {sprite=.PLAYER_IDLE_0, ticks=30}, 
          {sprite=.PLAYER_IDLE_1, ticks=30},
        },
      },
      .PLAYER_WALK = {
        frames = {
          {sprite=.PLAYER_WALK_0, ticks=30},
          {sprite=.PLAYER_WALK_1, ticks=30},
          {sprite=.PLAYER_WALK_2, ticks=30},
          {sprite=.PLAYER_WALK_3, ticks=30},
          {sprite=.PLAYER_WALK_4, ticks=30},
        },
      },
      .DEER_IDLE = {
        frames = {
          {sprite=.DEER_IDLE_0, ticks=8}, 
          {sprite=.DEER_IDLE_1, ticks=8},
          {sprite=.DEER_IDLE_2, ticks=8},
          {sprite=.DEER_IDLE_3, ticks=8},
        },
      },
      .DEER_WALK = {
        frames = {
          {sprite=.DEER_WALK_0, ticks=10}, 
          {sprite=.DEER_WALK_1, ticks=10},
          {sprite=.DEER_WALK_2, ticks=10},
          {sprite=.DEER_WALK_3, ticks=10},
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
        color_a = {0.4, 0.4, 0.4, 0},
        count = 3,
        lifetime = 3.0,
        scl = {0.7, 0.7},
        scl_dt = -{0.7, 0.7},
        speed = 48.0,
        emmision_kind = .BURST,
      },
    }
  }

  // - Creature ---
  {
    res.creatures = [Creature_Kind]Creature_Desc{
      .NIL = {},
      .DEER = {
        animations = #partial {
          .NIL = .NIL,
          .IDLE = .DEER_IDLE,
          .WALK = .DEER_WALK,
        },
        wander_range = {10, 50},
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
