#+feature dynamic-literals
package game

import "core:image/qoi"
import "basic/mem"
import "platform"
import "render"
import "ui"

Resources :: struct
{
  player:       struct
  {
    animations: [Animation_State]Sprite_Or_Animation,
    speed:      f32,
  },
  actions:      [Action_Name]platform.Input_Source,
  shaders:      [Shader_Name]render.Shader,
  textures:     [Texture_Name]render.Texture,
  sprites:      [Sprite_Name]Sprite,
  sounds:       [Sound_Name]Sound,
  animations:   [Animation_Name]Animation_Desc,
  particles:    [Particle_Name]Particle_Desc,
  creatures:    [Creature_Kind]Creature_Desc,
  weapons:      [Weapon_Kind]Weapon_Desc,
  items:        [Item_Kind]Item_Desc,
  loot_tables:  [Loot_Table_Name][dynamic]Loot_Table_Entry,
}

Texture_Name :: enum
{
  Sprite_Atlas,
  Glyph_Atlas,
}

Shader_Name :: enum
{
  Sprite,
}

Sprite_Name :: enum
{
  Nil,
  Rect,
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
  Item_Rabbit_Foot,
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
  Rabbit_Idle_3,
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
  Forest_Ambience,
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
  Blood_Pool_Expand_M,
  Blood_Pool_Expand_L,
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

Sprite_Or_Animation :: union #shared_nil
{
  Sprite_Name,
  Animation_Name,
}

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
  lifetime_var:  f32,
  spread:        f32,
  colors:        [dynamic]v4f32,
  scl:           v2f32,
  scl_dt:        v2f32,
  scl_var:       f32,
  vel:           v2f32,
  vel_dt:        v2f32,
  dir:           f32,
  dir_dt:        f32,
  rot:           f32,
  rot_dt:        f32,
}

Creature_Desc :: struct #all_or_none
{
  animations:      [Animation_State]Sprite_Or_Animation,
  collider:        Circle,
  corpse:          Sprite_Name,
  blood_pool:      Animation_Name,
  wander_range:    Range(i32),
  flee_range:      Range(i32),
  noise_threshold: f32,
  reaction_time:   f32,
  health:          i32,
  speed:           f32,
  loot_table:      Loot_Table_Name,
}

Weapon_Desc :: struct #all_or_none
{
  sprite:      Sprite_Name,
  hold_off:    v2f32,
  holster_off: v2f32,
  holster_rot: f32,
  shot_pos:    v2f32,
  shot_time:   f32,
  reload_time: f32,
  damage:      f32,
  speed:       f32,
  capacity:    u16,
}

Item_Desc :: struct #all_or_none
{
  name:       string,
  animations: [Animation_State]Sprite_Or_Animation,
  value:      int,
}

Loot_Table_Name :: enum
{
  Nil,
  Deer,
  Rabbit,
}

Loot_Table_Entry :: struct #all_or_none
{
  item: Item_Kind,
  rate: f32,
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  context.allocator = mem.allocator(arena)

  // - Actions ---
  {
    res.actions = [Action_Name]platform.Input_Source{
      .Nil = platform.Key_Kind.Nil,
      .Up = platform.Key_Kind.W,
      .Down = platform.Key_Kind.S,
      .Right = platform.Key_Kind.D,
      .Left = platform.Key_Kind.A,
      .Sneak = platform.Key_Kind.Left_Shift,
      .Attack = platform.Mouse_Btn_Kind.Left,
      .Holster = platform.Key_Kind.Q,
    }
  }

  // - Shaders ---
  {
    res.shaders[.Sprite] = render.create_shader(#load("../res/shaders/sprite.vert.glsl"),
                                                #load("../res/shaders/sprite.frag.glsl"))
  }

  // - Sprites ---
  {
    img: ^qoi.Image
    err: qoi.Error

    img, err = qoi.load_from_file("res/textures/sprite_map.qoi")
    if err != nil
    {
      panicf("Failed to open texture file!", err)
    }

    res.textures[.Sprite_Atlas] = render.create_texture(img.pixels.buf[:], img.width, img.height)

    CELL_SIZE :: 16

    res.sprites = {
      .Nil              = {coord={0, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .Rect             = {coord={1, 0},  grid={1, 1}, pivot={0, 0}},
      .Square           = {coord={1, 0},  grid={1, 1}, pivot={7.5, 7.5}},
      .UI_Square        = {coord={1, 0},  grid={1, 1}, pivot={0.0, 0.0}},
      .Circle           = {coord={2, 0},  grid={1, 1}, pivot={8.5, 8.5}},

      .Shadow_S         = {coord={3, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .Shadow_M         = {coord={4, 0},  grid={1, 1}, pivot={7.5, 14.5}},
      .Shadow_L         = {coord={5, 0},  grid={1, 1}, pivot={7.5, 14.5}},

      .Player_Idle_0    = {coord={0, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Idle_1    = {coord={1, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_0    = {coord={2, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_1    = {coord={3, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_2    = {coord={4, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_3    = {coord={5, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Walk_4    = {coord={6, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_0   = {coord={7, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_1   = {coord={8, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_2   = {coord={9, 1},  grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_3   = {coord={10, 1}, grid={1, 1}, pivot={7.5, 8.5}},
      .Player_Sneak_4   = {coord={11, 1}, grid={1, 1}, pivot={7.5, 8.5}},

      .Rifle            = {coord={0, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .Shotgun          = {coord={1, 2},  grid={1, 1}, pivot={4.5, 8.5}},
      .Muzzle_Flash     = {coord={0, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Bullet           = {coord={1, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Smoke_Particle   = {coord={2, 3},  grid={1, 1}, pivot={8.5, 8.5}},
      .Blood_Particle   = {coord={3, 3},  grid={1, 1}, pivot={8.5, 8.5}},

      .Item_Venison     = {coord={4, 3},  grid={1, 1}, pivot={7.5, 9.0}},
      .Item_Rabbit_Foot = {coord={5, 3},  grid={1, 1}, pivot={7.5, 9.0}},

      .Deer_Idle_0      = {coord={0, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_1      = {coord={1, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_2      = {coord={2, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Idle_3      = {coord={3, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_0      = {coord={4, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_1      = {coord={5, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_2      = {coord={6, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Walk_3      = {coord={7, 4},  grid={1, 1}, pivot={7.5, 8.5}},
      .Deer_Corpse      = {coord={8, 4},  grid={2, 1}, pivot={15.0, 15.0}},

      .Rabbit_Idle_0    = {coord={0, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Idle_1    = {coord={1, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Idle_2    = {coord={2, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Idle_3    = {coord={3, 5},  grid={1, 1}, pivot={9.5, 9.5}},
      .Rabbit_Walk_0    = {coord={4, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_1    = {coord={5, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_2    = {coord={6, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Walk_3    = {coord={7, 5},  grid={1, 1}, pivot={7.5, 8.5}},
      .Rabbit_Corpse    = {coord={8, 5},  grid={1, 1}, pivot={8.5, 15.0}},
      
      .Blood_Pool_0     = {coord={0, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_1     = {coord={1, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_2     = {coord={2, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_3     = {coord={3, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_4     = {coord={4, 6},  grid={1, 1}, pivot={8.0, 10.0}},
      .Blood_Pool_5     = {coord={5, 6},  grid={1, 1}, pivot={8.0, 10.0}},

      .Tile_Dirt        = {coord={0, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_0     = {coord={1, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_1     = {coord={2, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Grass_2     = {coord={3, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Stone_0     = {coord={4, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Stone_1     = {coord={5, 7},  grid={1, 1}, pivot={8.0, 8.0}},
      .Tile_Wall        = {coord={6, 7},  grid={1, 1}, pivot={8.0, 8.0}},
    }

    for &sprite in res.sprites
    {
      sprite.coord *= CELL_SIZE
      sprite.grid *= CELL_SIZE
      sprite.pivot /= sprite.grid
    }
  }

  // - Sounds ---
  {
    res.sounds = {
      .Nil             = {},
      .Thunk           = {path="res/sounds/thunk.wav",           group=.Effect},
      .Gun_Shot        = {path="res/sounds/gun_shot.wav",        group=.Effect},
      .Minecraft       = {path="res/sounds/minecraft.wav",       group=.Music},
      .Forest_Ambience = {path="res/sounds/forest_ambient.flac", group=.Ambience},
    }
  }

  // - Fonts ---
  {
    ui.set_dpi(uint(platform.get_display_dpi(&user.window)))

    // NOTE(dg): Size for Jersey10 must be [14, 28, 42, 56, 70, 84, 98]
    font, err := ui.load_font("res/fonts/Jersey10.ttf", 14, arena)
    if err == nil
    {
      res.textures[.Glyph_Atlas] = render.create_texture(font.pixels, font.width, font.height, format=1)
    }
    else
    {
      println("Error [freetype]:", err)
    }

    // os2.exit(0)
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
      .Blood_Pool_Expand_M = {
        frames = {
          {sprite=.Blood_Pool_0, duration=0.25},
          {sprite=.Blood_Pool_1, duration=0.25},
          {sprite=.Blood_Pool_2, duration=0.25},
        },
      },
      .Blood_Pool_Expand_L = {
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
          {sprite=.Rabbit_Idle_3, duration=0.3},
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

  // - :particles ---
  {
    res.particles = {
      .Nil = {},
      .Gun_Smoke = {
        sprite = .Smoke_Particle,
        emmision_kind = .Burst,
        props = {},
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
        props = {.Persist},
        colors = {{0.5, 0, 0, 0}, {0.4, 0, 0, 0}, {0.3, 0, 0, 0}},
        count = 5,
        lifetime = 0.1,
        lifetime_var = 0.05,
        scl = {0.3, 0.3},
        scl_var = 0.2,
        vel = {96, 96},
        vel_dt = {0, 256},
      },
    }
  }

  // - :player ---
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

  // - Creatures ---
  {
    res.creatures = {
      .Nil = {},
      .Deer = {
        animations = #partial {
          .Idle = .Deer_Idle,
          .Walk = .Deer_Walk,
        },
        collider = Circle{
          origin = {0, 0},
          radius = 6,
        },
        corpse = .Deer_Corpse,
        blood_pool = .Blood_Pool_Expand_L,
        wander_range = {10, 50},
        flee_range = {50, 100},
        noise_threshold = 30,
        reaction_time = 0.2,
        health = 2,
        speed = 35,
        loot_table = .Deer,
      },
      .Rabbit = {
        animations = #partial {
          .Idle = .Rabbit_Idle,
          .Walk = .Rabbit_Walk,
        },
        collider = Circle{
          origin = {-1, 4},
          radius = 4,
        },
        corpse = .Rabbit_Corpse,
        blood_pool = .Blood_Pool_Expand_M,
        wander_range = {10, 50},
        flee_range = {50, 100},
        noise_threshold = 35,
        reaction_time = 0.1,
        health = 1,
        speed = 25,
        loot_table = .Rabbit,
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
        holster_rot = rad_from_deg(f32(90.0)),
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
        value = 3,
      },
      .Rabbit_Foot = {
        name = "Rabbit's Foot",
        animations = #partial {
          .Idle = .Item_Rabbit_Foot,
        },
        value = 5,
      },
    }
  }

  // - Loot tables ---
  {
    res.loot_tables = {
      .Nil = {
        {item = .Nil, rate = 1.0},
      },
      .Deer = {
        {item = .Venison, rate = 1.0},
      },
      .Rabbit = {
        {item = .Rabbit_Foot, rate = 1.0},
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
