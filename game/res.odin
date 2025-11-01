#+feature dynamic-literals
package game

import "core:image/qoi"
import "basic"
import "basic/mem"
import "platform"
import "render"

Resources :: struct
{
  actions:     [Action_Name]platform.Input_Source,
  textures:    [render.Texture_ID]render.Texture,
  sprites:     [Sprite_Name]Sprite,
  sounds:      [Sound_Name]Sound,
  animations:  [Animation_Name]Animation_Desc,
  particles:   [Particle_Name]Particle_Desc,
  player:      Player_Desc,
  creatures:   [Creature_Kind]Creature_Desc,
  weapons:     [Weapon_Kind]Weapon_Desc,
  items:       [Item_Kind]Item_Desc,
  loot_tables: [Loot_Table_Name][dynamic]Loot_Table_Entry,
}

Sprite_Name :: enum u16
{
  Nil,
  Square,
  UI_Square,
  Circle,
  Shadow_S,
  Shadow_M,
  Shadow_L,
  Player_Idle_0,
  Player_Idle_1,
  Player_Walk_0,
  Player_Walk_1,
  Player_Walk_2,
  Player_Walk_3,
  Player_Walk_4,
  Player_Sneak_0,
  Player_Sneak_1,
  Player_Sneak_2,
  Player_Sneak_3,
  Player_Sneak_4,
  Rifle,
  Shotgun,
  Muzzle_Flash,
  Bullet,
  Smoke_Particle,
  Blood_Particle,
  Item_Venison,
  Deer_Idle_0,
  Deer_Idle_1,
  Deer_Idle_2,
  Deer_Idle_3,
  Deer_Walk_0,
  Deer_Walk_1,
  Deer_Walk_2,
  Deer_Walk_3,
  Deer_Corpse,
  Rabbit_Idle_0,
  Rabbit_Idle_1,
  Rabbit_Idle_2,
  Rabbit_Walk_0,
  Rabbit_Walk_1,
  Rabbit_Walk_2,
  Rabbit_Walk_3,
  Rabbit_Corpse,
  Blood_Pool_0,
  Blood_Pool_1,
  Blood_Pool_2,
  Blood_Pool_3,
  Blood_Pool_4,
  Blood_Pool_5,
  Tile_Dirt,
  Tile_Grass_0,
  Tile_Grass_1,
  Tile_Grass_2,
  Tile_Stone_0,
  Tile_Stone_1,
  Tile_Wall,
}

Sound_Name :: enum
{
  Nil,
  Thunk,
  Gun_Shot,
  Minecraft,
}

Sound_Group :: enum
{
  Nil,
  Ambience,
  Music,
  Effect,
}

Action_Name :: enum
{
  Nil,
  Up,
  Down,
  Right,
  Left,
  Sneak,
  Attack,
  Holster,
}

Animation_Name :: enum
{
  Nil,
  Player_Walk,
  Player_Sneak_Walk,
  Deer_Idle,
  Deer_Walk,
  Rabbit_Idle,
  Rabbit_Walk,
  Blood_Pool_Expand,
}

Animation_State :: enum
{
  Idle,
  Walk,
  Sneak_Walk,
  Sneak_Idle,
  Expand,
}

Animation_Desc :: struct
{
  frames:     [dynamic]struct
  {
    sprite:   Sprite_Name,
    duration: f32,
  },
}

Sprite_Or_Animation :: union#shared_nil{Sprite_Name, Animation_Name}

Particle_Name :: enum
{
  Nil,
  Gun_Smoke,
  Hurt_Blood,
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

Player_Desc :: struct
{
  animations:   [Animation_State]Sprite_Or_Animation,
  speed: f32,
}

Creature_Desc :: struct
{
  animations:   [Animation_State]Sprite_Or_Animation,
  corpse:       Sprite_Name,
  wander_range: Range(i32),
  flee_range:   Range(i32),
  health:       i32,
  speed:        f32,
}

Weapon_Desc :: struct
{
  sprite:      Sprite_Name,
  hold_off:    f32x2,
  holster_off: f32x2,
  holster_rot: f32,
  shot_pos:    f32x2,
  shot_time:   f32,
  reload_time: f32,
  damage:      f32,
  speed:       f32,
  capacity:    u16,
}

Item_Desc :: struct
{
  name:       string,
  animations: [Animation_State]Sprite_Or_Animation,
  value:      int,
}

Loot_Table_Name :: enum
{
  Deer,
}

Loot_Table_Entry :: struct
{
  item:  Item_Kind,
  rate:  f32,
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  context.allocator = mem.allocator(arena)

  // - Actions ---
  {
    using platform

    res.actions = [Action_Name]Input_Source{
      .Nil = nil,
      .Up = Key_Kind.W,
      .Down = Key_Kind.S,
      .Right = Key_Kind.D,
      .Left = Key_Kind.A,
      .Sneak = Key_Kind.Left_Shift,
      .Attack = Mouse_Btn_Kind.Left,
      .Holster = Key_Kind.Q,
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

    res.textures[.Sprite_Map] = render.Texture{
      data = img.pixels.buf[:],
      width = cast(i32) img.width,
      height = cast(i32) img.height,
      cell = 16,
    }
  }

  // - Sprites ---
  {
    res.sprites = [Sprite_Name]Sprite{
      .Nil            = {coords={0, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .Square         = {coords={1, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .UI_Square      = {coords={1, 0},  grid={1, 1}, pivot={0.0, 0.0}},
      .Circle         = {coords={2, 0},  grid={1, 1}, pivot={8.5, 8.5}},
      .Shadow_S       = {coords={3, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .Shadow_M       = {coords={4, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .Shadow_L       = {coords={5, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .Player_Idle_0  = {coords={0, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Idle_1  = {coords={1, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_0  = {coords={2, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_1  = {coords={3, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_2  = {coords={4, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_3  = {coords={5, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_4  = {coords={6, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_0 = {coords={7, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_1 = {coords={8, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_2 = {coords={9, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_3 = {coords={10, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_4 = {coords={11, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .Rifle          = {coords={0, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .Shotgun        = {coords={1, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .Muzzle_Flash   = {coords={0, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Bullet         = {coords={1, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Smoke_Particle = {coords={2, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Blood_Particle = {coords={3, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Item_Venison   = {coords={4, 3},  grid={1, 1}, pivot={7.5, 9.0}},
      .Deer_Idle_0    = {coords={0, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_1    = {coords={1, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_2    = {coords={2, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_3    = {coords={3, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_0    = {coords={4, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_1    = {coords={5, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_2    = {coords={6, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_3    = {coords={7, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Corpse    = {coords={8, 4},  grid={2, 1}, pivot={15.0, 15.0}},
      .Rabbit_Idle_0  = {coords={0, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Idle_1  = {coords={1, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Idle_2  = {coords={2, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Walk_0  = {coords={4, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_1  = {coords={5, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_2  = {coords={6, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_3  = {coords={7, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Corpse  = {coords={8, 5},  grid={1, 1}, pivot={8.5, 15.0}},
      .Blood_Pool_0   = {coords={0, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_1   = {coords={1, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_2   = {coords={2, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_3   = {coords={3, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_4   = {coords={4, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_5   = {coords={5, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Tile_Dirt      = {coords={0, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_0   = {coords={1, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_1   = {coords={2, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_2   = {coords={3, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Stone_0   = {coords={4, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Stone_1   = {coords={5, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Wall      = {coords={6, 7},  grid={1, 1}, pivot={8.0, 8.0}},
    }

    for &sprite in res.sprites
    {
      sprite.texture = .Sprite_Map
      sprite.pivot /= basic.array_cast(sprite.grid, f32) * 16
    }
  }

  // - Sounds ---
  {
    res.sounds = {
      .Nil       = {},
      .Thunk     = {path="res/sounds/thunk.wav",     group=.Effect},
      .Gun_Shot  = {path="res/sounds/gun_shot.wav",  group=.Effect},
      .Minecraft = {path="res/sounds/minecraft.wav", group=.Music},
    }
  }

  // - Animations ---
  {
    res.animations = {
      .Nil = {},
      .Player_Walk = {
        frames = {
          {sprite=.Player_Walk_0, duration=0.08},
          {sprite=.Player_Walk_1, duration=0.08},
          {sprite=.Player_Walk_2, duration=0.08},
          {sprite=.Player_Walk_3, duration=0.08},
          {sprite=.Player_Walk_4, duration=0.08},
        },
      },
      .Player_Sneak_Walk = {
        frames = {
          {sprite=.Player_Sneak_1, duration=0.08},
          {sprite=.Player_Sneak_2, duration=0.08},
          {sprite=.Player_Sneak_3, duration=0.08},
          {sprite=.Player_Sneak_4, duration=0.08},
          {sprite=.Player_Sneak_0, duration=0.08},
        },
      },
      .Deer_Idle = {
        frames = {
          {sprite=.Deer_Idle_0, duration=0.3}, 
          {sprite=.Deer_Idle_1, duration=0.3},
          {sprite=.Deer_Idle_2, duration=0.3},
          {sprite=.Deer_Idle_3, duration=0.3},
        },
      },
      .Deer_Walk = {
        frames = {
          {sprite=.Deer_Walk_0, duration=0.15}, 
          {sprite=.Deer_Walk_1, duration=0.15},
          {sprite=.Deer_Walk_2, duration=0.15},
          {sprite=.Deer_Walk_3, duration=0.15},
        },
      },
      .Blood_Pool_Expand = {
        frames = {
          {sprite=.Blood_Pool_0, duration=0.15},
          {sprite=.Blood_Pool_1, duration=0.15},
          {sprite=.Blood_Pool_2, duration=0.15},
          {sprite=.Blood_Pool_3, duration=0.15},
          {sprite=.Blood_Pool_4, duration=0.15},
          {sprite=.Blood_Pool_5, duration=0.15},
        },
      },
      .Rabbit_Idle = {
        frames = {
          {sprite=.Rabbit_Idle_0, duration=0.3}, 
          {sprite=.Rabbit_Idle_1, duration=0.3},
          {sprite=.Rabbit_Idle_2, duration=0.3},
        },
      },
      .Rabbit_Walk = {
        frames = {
          {sprite=.Rabbit_Walk_0, duration=0.15}, 
          {sprite=.Rabbit_Walk_1, duration=0.15},
          {sprite=.Rabbit_Walk_2, duration=0.15},
          {sprite=.Rabbit_Walk_3, duration=0.15},
        },
      },
    }
  }

  // - Particles ---
  {
    res.particles = {
      .Nil = {},
      .Gun_Smoke = {
        sprite = .Smoke_Particle,
        emmision_kind = .Burst,
        colors = {{0.5, 0.5, 0.5, 0}, {0.4, 0.4, 0.4, 0}, {0.3, 0.3, 0.3, 0}},
        count = 4,
        lifetime = 3.0,
        scl = {0.7, 0.7},
        scl_dt = -{0.7, 0.7},
        vel = {48.0, 48.0},
        vel_dt = {0, -120},
      },
      .Hurt_Blood = {
        sprite = .Blood_Particle,
        emmision_kind = .Burst,
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

  // - Player ---
  {
    res.player = {
      animations = #partial {
        .Idle = .Player_Idle_0,
        .Walk = .Player_Walk,
        .Sneak_Idle = .Player_Sneak_0,
        .Sneak_Walk = .Player_Sneak_Walk,
      },
      speed = 50,
    }
  }

  // - Creature ---
  {
    res.creatures = {
      .Nil = {},
      .Deer = {
        animations = #partial {
          .Idle = .Deer_Idle,
          .Walk = .Deer_Walk,
        },
        corpse = .Deer_Corpse,
        wander_range = {10, 50},
        flee_range = {50, 100},
        health = 2,
        speed = 35,
      },
      .Rabbit = {
        animations = #partial {
          .Idle = .Rabbit_Idle,
          .Walk = .Rabbit_Walk,
        },
        corpse = .Rabbit_Corpse,
        wander_range = {10, 50},
        flee_range = {50, 100},
        health = 1,
        speed = 25,
      },
    }
  }

  // - Weapons ---
  {
    res.weapons = {
      .Nil = {},
      .Rifle = {
        sprite = .Rifle,
        hold_off = {0, 0},
        holster_off = {-2, -5},
        holster_rot = cast(f32) rad_from_deg(90.0),
        shot_pos = {11.0, 0.0},
        shot_time = 0.35,
        reload_time = 3.0,
        damage = 7,
        speed = 512.0,
        capacity = 5,
      },
    }
  }

  // - Items ---
  {
    res.items = {
      .Nil = {},
      .Venison = {
        name = "Venison",
        animations = #partial {
          .Idle = .Item_Venison,
        },
        value = 33, 
      },
    }
  }

  // - Loot tables ---
  {
    res.loot_tables = {
      .Deer = {
        {item = .Nil, rate = 0.0},
        {item = .Venison, rate = 1.0},
      },
    }

    for loot_table in res.loot_tables
    {
      sum: f32
      for entry in loot_table
      {
        sum += entry.rate
      }

      assert(sum == 1.0)
    }
  }
}
