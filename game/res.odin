#+feature dynamic-literals
package game

import "base:runtime"
import "core:image"
import "core:image/tga"
import "core:log"
import "core:os"
import "core:strings"
import "core:reflect"
import "basic/mem"
import "platform"
import "render"
import "ui"

Resources :: struct
{
  actions:     [Action_Name]platform.Input_Source,
  shaders:     [Shader_Name]render.Shader,
  textures:    [Texture_Name]render.Texture,
  sprites:     [Sprite_Name]Sprite,
  sounds:      [Sound_Name]Sound,
  animations:  [Animation_Name]Animation_Desc,
  entities:    [Entity_Name]Entity_Desc,
  zones:       [Zone_Name]Zone_Desc,
  particles:   [Particle_Name]Particle_Desc,
  creatures:   [Entity_Name]Creature_Desc,
  weapons:     [Weapon_Kind]Weapon_Desc,
  items:       [Item_Kind]Item_Desc,
  loot_tables: [Loot_Table_Name][dynamic]Loot_Table_Entry,
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

  Shadow_1,
  Shadow_2,
  Shadow_3,

  Player_Idle_Unarmed_1,
  Player_Idle_Unarmed_2,
  Player_Idle_One_Handed_1,
  Player_Idle_One_Handed_2,
  Player_Idle_Two_Handed_1,
  Player_Idle_Two_Handed_2,
  Player_Walk_Unarmed_1,
  Player_Walk_Unarmed_2,
  Player_Walk_Unarmed_3,
  Player_Walk_Unarmed_4,
  Player_Walk_Unarmed_5,
  Player_Walk_One_Handed_1,
  Player_Walk_One_Handed_2,
  Player_Walk_One_Handed_3,
  Player_Walk_One_Handed_4,
  Player_Walk_One_Handed_5,
  Player_Walk_Two_Handed_1,
  Player_Walk_Two_Handed_2,
  Player_Walk_Two_Handed_3,
  Player_Walk_Two_Handed_4,
  Player_Walk_Two_Handed_5,
  Player_Sneak_Unarmed_1,
  Player_Sneak_Unarmed_2,
  Player_Sneak_Unarmed_3,
  Player_Sneak_Unarmed_4,
  Player_Sneak_Unarmed_5,
  Player_Sneak_One_Handed_1,
  Player_Sneak_One_Handed_2,
  Player_Sneak_One_Handed_3,
  Player_Sneak_One_Handed_4,
  Player_Sneak_One_Handed_5,
  Player_Sneak_Two_Handed_1,
  Player_Sneak_Two_Handed_2,
  Player_Sneak_Two_Handed_3,
  Player_Sneak_Two_Handed_4,
  Player_Sneak_Two_Handed_5,
  Player_Harvest_Blood_1,
  Player_Harvest_Blood_2,
  Player_Harvest_Blood_3,
  Player_Harvest_Blood_4,
  Player_Harvest_Blood_5,
  Player_Harvest_Blood_6,
  Player_Harvest_Blood_7,
  Player_Harvest_Blood_8,

  Zombie_Idle_1,
  Zombie_Idle_2,
  Zombie_Walk_1,
  Zombie_Walk_2,
  Zombie_Walk_3,
  Zombie_Walk_4,
  Zombie_Walk_5,
  Zombie_Melee_1,
  Zombie_Melee_2,
  Zombie_Corpse,

  Revolver,
  Rifle,
  Shotgun,
  Muzzle_Flash,
  Bullet,
  Smoke_Particle,
  Blood_Particle,

  Item_Venison,
  Item_Rabbit_Foot,
  Item_Squirrel_Tail,

  Deer_Idle_1,
  Deer_Idle_2,
  Deer_Idle_3,
  Deer_Idle_4,
  Deer_Walk_1,
  Deer_Walk_2,
  Deer_Walk_3,
  Deer_Walk_4,
  Deer_Corpse,

  Rabbit_Idle_1,
  Rabbit_Idle_2,
  Rabbit_Idle_3,
  Rabbit_Idle_4,
  Rabbit_Walk_1,
  Rabbit_Walk_2,
  Rabbit_Walk_3,
  Rabbit_Walk_4,
  Rabbit_Corpse,

  Squirrel_Idle_1,
  Squirrel_Idle_2,
  Squirrel_Idle_3,
  Squirrel_Idle_4,
  Squirrel_Walk_1,
  Squirrel_Walk_2,
  Squirrel_Walk_3,
  Squirrel_Walk_4,
  Squirrel_Corpse,

  Blood_Pool_1,
  Blood_Pool_2,
  Blood_Pool_3,
  Blood_Pool_4,
  Blood_Pool_5,
  Blood_Pool_6,

  Grass,
  Chamomile,
  Sunflower,
  Lavender,
  Brown_Mushroom,
  Red_Mushroom,
  Stump,

  Tile_Dirt,
  Tile_Grass_1,
  Tile_Grass_2,
  Tile_Grass_3,
  Tile_Stone_1,
  Tile_Stone_2,
  Tile_Wall,
  Tile_Plank_1,
  Tile_Plank_2,
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

Animation_Name :: enum
{
  Nil,

  Player_Idle_Unarmed,
  Player_Idle_One_Handed,
  Player_Idle_Two_Handed,
  Player_Walk_Unarmed,
  Player_Walk_One_Handed,
  Player_Walk_Two_Handed,
  Player_Sneak_Walk_Unarmed,
  Player_Sneak_Walk_One_Handed,
  Player_Sneak_Walk_Two_Handed,
  Player_Harvest_Blood,

  Zombie_Idle,
  Zombie_Walk,
  Zombie_Melee,

  Deer_Idle,
  Deer_Walk,

  Rabbit_Idle,
  Rabbit_Walk,

  Squirrel_Idle,
  Squirrel_Walk,

  Blood_Pool_Expand_M,
  Blood_Pool_Expand_L,
}

Animation_State :: enum
{
  Idle,
  Idle_Unarmed,
  Idle_One_Handed,
  Idle_Two_Handed,
  Walk,
  Walk_Unarmed,
  Walk_One_Handed,
  Walk_Two_Handed,
  Sneak_Idle_Unarmed,
  Sneak_Idle_One_Handed,
  Sneak_Idle_Two_Handed,
  Sneak_Walk_Unarmed,
  Sneak_Walk_One_Handed,
  Sneak_Walk_Two_Handed,
  Harvest_Blood,
  Expand,
}

Sprite_Or_Animation :: union #shared_nil
{
  Sprite_Name,
  Animation_Name,
}

Entity_Name :: enum u64
{
  Nil,

  Player,
  Item,
  Bullet,

  Blood_Pool_M,
  Blood_Pool_L,

  Zombie,
  Deer,
  Rabbit,
  Squirrel,

  Grass,
  Chamomile,
  Sunflower,
  Lavender,
  Brown_Mushroom,
  Red_Mushroom,
  Stump,
}

Loot_Table_Name :: enum
{
  Nil,
  Deer,
  Rabbit,
  Squirrel,
  Chamomile,
  Sunflower,
  Lavender,
  Brown_Mushroom,
  Red_Mushroom,
}

Particle_Name :: enum
{
  Nil,
  Gun_Smoke,
  Hurt_Blood,
}

Animation_Desc :: struct
{
  frames:     [dynamic]struct
  {
    sprite:   Sprite_Name,
    duration: f32,
  },
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
  colors:        [dynamic; 8]v4f32,
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

Entity_Desc :: struct
{
  animations: [Animation_State]Sprite_Or_Animation,
  props:      bit_set[Entity_Prop],
  kind:       Entity_Kind,
  color:      v4f32,
  tint:       v4f32,
  collider:   Shape,
  loot_table: Loot_Table_Name,
}

Creature_Desc :: struct
{
  corpse:          Sprite_Name,
  blood_pool:      Entity_Name,
  wander_range:    Range(i32),
  flee_range:      Range(i32),
  noise_threshold: f32,
  reaction_time:   f32,
  health:          i32,
  speed:           f32,
  view_dist:       f32,
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
  handedness:  enum{One_Handed, Two_Handed},
}

Item_Desc :: struct #all_or_none
{
  name:       string,
  animations: [Animation_State]Sprite_Or_Animation,
  value:      int,
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
    sprite_atlas_path := "res/gen/sprite_atlas.tga"
    build_sprite_atlas("res/textures/", sprite_atlas_path)

    img, err := tga.load(sprite_atlas_path)
    if err != nil
    {
      panicf("Failed to open texture file!", err)
    }

    res.textures[.Sprite_Atlas] = render.create_texture(img.pixels.buf[:], img.width, img.height)

    for &sprite in res.sprites
    {
      sprite.pivot.xy = sprite.size * 0.5
    }

    res.sprites[.UI_Square] = res.sprites[.Rect]
    res.sprites[.UI_Square].pivot = {0.0, 0.0, 1}

    res.sprites[.Shadow_1].pivot = {3.5, 0.5, 0}
    res.sprites[.Shadow_2].pivot = {5.5, 0.5, 0}
    res.sprites[.Shadow_3].pivot = {7.5, 0.5, 0}

    res.sprites[.Blood_Pool_1].pivot = {3.5, 1.0, 0}
    res.sprites[.Blood_Pool_2].pivot = {3.5, 2.0, 0}
    res.sprites[.Blood_Pool_3].pivot = {5.0, 3.0, 0}
    res.sprites[.Blood_Pool_4].pivot = {6.0, 4.0, 0}
    res.sprites[.Blood_Pool_5].pivot = {7.0, 5.0, 0}
    res.sprites[.Blood_Pool_6].pivot = {8.0, 6.0, 0}

    res.sprites[.Player_Idle_Unarmed_1    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Idle_Unarmed_2    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Idle_One_Handed_1 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Idle_One_Handed_2 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Unarmed_1    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Idle_Two_Handed_1 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Idle_Two_Handed_2 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Unarmed_2    ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Walk_Unarmed_3    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Unarmed_4    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Unarmed_5    ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_One_Handed_1 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_One_Handed_2 ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Walk_One_Handed_3 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_One_Handed_4 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_One_Handed_5 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Two_Handed_1 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Two_Handed_2 ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Walk_Two_Handed_3 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Two_Handed_4 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Walk_Two_Handed_5 ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Unarmed_1   ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Sneak_Unarmed_2   ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Unarmed_3   ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Unarmed_4   ].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Unarmed_5   ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Sneak_One_Handed_1].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Sneak_One_Handed_2].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_One_Handed_3].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_One_Handed_4].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_One_Handed_5].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Sneak_Two_Handed_1].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Sneak_Two_Handed_2].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Two_Handed_3].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Two_Handed_4].pivot = {2.5, 14.0, 0}
    res.sprites[.Player_Sneak_Two_Handed_5].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Harvest_Blood_1   ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Harvest_Blood_2   ].pivot = {2.5, 12.0, 0}
    res.sprites[.Player_Harvest_Blood_3   ].pivot = {2.5, 12.0, 0}
    res.sprites[.Player_Harvest_Blood_4   ].pivot = {2.5, 12.0, 0}
    res.sprites[.Player_Harvest_Blood_5   ].pivot = {2.5, 12.0, 0}
    res.sprites[.Player_Harvest_Blood_6   ].pivot = {2.5, 12.0, 0}
    res.sprites[.Player_Harvest_Blood_7   ].pivot = {2.5, 13.0, 0}
    res.sprites[.Player_Harvest_Blood_8   ].pivot = {2.5, 13.0, 0}

    res.sprites[.Zombie_Idle_1].pivot = {2.5, 13.0, 0}
    res.sprites[.Zombie_Idle_2].pivot = {2.5, 12.0, 0}
    res.sprites[.Zombie_Walk_1].pivot = {2.5, 13.0, 0}
    res.sprites[.Zombie_Walk_2].pivot = {2.5, 12.0, 0}
    res.sprites[.Zombie_Walk_3].pivot = {2.5, 13.0, 0}
    res.sprites[.Zombie_Walk_4].pivot = {2.5, 13.0, 0}
    res.sprites[.Zombie_Walk_5].pivot = {2.5, 13.0, 0}

    res.sprites[.Revolver    ].pivot = {0.0, 3.0, 0}
    res.sprites[.Rifle       ].pivot = {4.0, 3.0, 0}
    res.sprites[.Muzzle_Flash].pivot = {0.0, 1.5, 0}
    res.sprites[.Bullet      ].pivot = {2.0, 0.5, 0}

    res.sprites[.Deer_Idle_1].pivot = {5.5, 13.0, 0}
    res.sprites[.Deer_Idle_2].pivot = {6.5, 13.0, 0}
    res.sprites[.Deer_Idle_3].pivot = {5.5, 12.0, 0}
    res.sprites[.Deer_Idle_4].pivot = {5.5, 12.0, 0}
    res.sprites[.Deer_Walk_1].pivot = {5.0, 13.0, 0}
    res.sprites[.Deer_Walk_2].pivot = {5.0, 14.0, 0}
    res.sprites[.Deer_Walk_3].pivot = {5.0, 14.0, 0}
    res.sprites[.Deer_Walk_4].pivot = {5.0, 13.0, 0}
    res.sprites[.Deer_Corpse].pivot = {0.5, 1.0, 1}

    res.sprites[.Rabbit_Idle_1].pivot = {4.0, 8.0, 0}
    res.sprites[.Rabbit_Idle_2].pivot = {4.0, 8.0, 0}
    res.sprites[.Rabbit_Idle_3].pivot = {4.0, 7.0, 0}
    res.sprites[.Rabbit_Idle_4].pivot = {4.0, 7.0, 0}
    res.sprites[.Rabbit_Walk_1].pivot = {4.0, 9.0, 0}
    res.sprites[.Rabbit_Walk_2].pivot = {5.0, 9.0, 0}
    res.sprites[.Rabbit_Walk_3].pivot = {5.0, 10.0, 0}
    res.sprites[.Rabbit_Walk_4].pivot = {4.0, 10.0, 0}
    res.sprites[.Rabbit_Corpse].pivot = {5.5, 4.0, 0}

    res.sprites[.Squirrel_Idle_1].pivot = {6.0, 7.0, 0}
    res.sprites[.Squirrel_Idle_2].pivot = {6.0, 7.0, 0}
    res.sprites[.Squirrel_Idle_3].pivot = {6.0, 6.0, 0}
    res.sprites[.Squirrel_Idle_4].pivot = {6.0, 7.0, 0}
    res.sprites[.Squirrel_Walk_1].pivot = {4.0, 9.0, 0}
    res.sprites[.Squirrel_Walk_2].pivot = {5.0, 9.0, 0}
    res.sprites[.Squirrel_Walk_3].pivot = {5.0, 10.0, 0}
    res.sprites[.Squirrel_Walk_4].pivot = {4.0, 10.0, 0}
    res.sprites[.Squirrel_Corpse].pivot = {6.5, 4.0, 0}

    for &sprite in res.sprites
    {
      sprite.pivot.xy /= sprite.size if sprite.pivot.z == 0 else 1
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
    font, err := ui.load_font("res/fonts/Jersey10.ttf", 14, {}, arena)
    if err == nil
    {
      res.textures[.Glyph_Atlas] = render.create_texture(font.pixels, font.width, font.height, format=1)
    }
    else
    {
      log.errorf("[ui]: Failed to read font (%v)\n", err)
    }
  }

  // - Zones ---
  {
    res.zones = {
      .Wilderness = {
        name = "The Wilderness",
        width = 96 * TILE_SIZE,
        height = 96 * TILE_SIZE,
      },
      .Shop = {
        name = "The Shop",
        width = 28 * TILE_SIZE,
        height = 14 * TILE_SIZE,
      },
    }

    for zone in res.zones
    {
      assert(zone.width * zone.height <= MAX_ZONE_TILES * TILE_SIZE * TILE_SIZE)
    }
  }

  // - Animations ---
  {
    res.animations = {
      .Nil = {},

      .Player_Idle_Unarmed = {
        frames = {
          {sprite=.Player_Idle_Unarmed_1, duration=4.0},
          {sprite=.Player_Idle_Unarmed_2, duration=0.1},
        },
      },
      .Player_Idle_One_Handed = {
        frames = {
          {sprite=.Player_Idle_One_Handed_1, duration=4.0},
          {sprite=.Player_Idle_One_Handed_2, duration=0.1},
        },
      },
      .Player_Idle_Two_Handed = {
        frames = {
          {sprite=.Player_Idle_Two_Handed_1, duration=4.0},
          {sprite=.Player_Idle_Two_Handed_2, duration=0.1},
        },
      },
      .Player_Walk_Unarmed = {
        frames = {
          {sprite=.Player_Walk_Unarmed_1, duration=0.08},
          {sprite=.Player_Walk_Unarmed_2, duration=0.08},
          {sprite=.Player_Walk_Unarmed_3, duration=0.08},
          {sprite=.Player_Walk_Unarmed_4, duration=0.08},
          {sprite=.Player_Walk_Unarmed_5, duration=0.08},
        },
      },
      .Player_Walk_One_Handed = {
        frames = {
          {sprite=.Player_Walk_One_Handed_1, duration=0.08},
          {sprite=.Player_Walk_One_Handed_2, duration=0.08},
          {sprite=.Player_Walk_One_Handed_3, duration=0.08},
          {sprite=.Player_Walk_One_Handed_4, duration=0.08},
          {sprite=.Player_Walk_One_Handed_5, duration=0.08},
        },
      },
      .Player_Walk_Two_Handed = {
        frames = {
          {sprite=.Player_Walk_Two_Handed_1, duration=0.08},
          {sprite=.Player_Walk_Two_Handed_2, duration=0.08},
          {sprite=.Player_Walk_Two_Handed_3, duration=0.08},
          {sprite=.Player_Walk_Two_Handed_4, duration=0.08},
          {sprite=.Player_Walk_Two_Handed_5, duration=0.08},
        },
      },
      .Player_Sneak_Walk_Unarmed = {
        frames = {
          {sprite=.Player_Sneak_Unarmed_1, duration=0.08},
          {sprite=.Player_Sneak_Unarmed_2, duration=0.08},
          {sprite=.Player_Sneak_Unarmed_3, duration=0.08},
          {sprite=.Player_Sneak_Unarmed_4, duration=0.08},
          {sprite=.Player_Sneak_Unarmed_5, duration=0.08},
        },
      },
      .Player_Sneak_Walk_One_Handed = {
        frames = {
          {sprite=.Player_Sneak_One_Handed_1, duration=0.08},
          {sprite=.Player_Sneak_One_Handed_2, duration=0.08},
          {sprite=.Player_Sneak_One_Handed_3, duration=0.08},
          {sprite=.Player_Sneak_One_Handed_4, duration=0.08},
          {sprite=.Player_Sneak_One_Handed_5, duration=0.08},
        },
      },
      .Player_Sneak_Walk_Two_Handed = {
        frames = {
          {sprite=.Player_Sneak_Two_Handed_1, duration=0.08},
          {sprite=.Player_Sneak_Two_Handed_2, duration=0.08},
          {sprite=.Player_Sneak_Two_Handed_3, duration=0.08},
          {sprite=.Player_Sneak_Two_Handed_4, duration=0.08},
          {sprite=.Player_Sneak_Two_Handed_5, duration=0.08},
        },
      },
      .Player_Harvest_Blood = {
        frames = {
          {sprite=.Player_Harvest_Blood_1, duration=0.3},
          {sprite=.Player_Harvest_Blood_2, duration=0.3},
          {sprite=.Player_Harvest_Blood_3, duration=0.3},
          {sprite=.Player_Harvest_Blood_4, duration=0.3},
          {sprite=.Player_Harvest_Blood_5, duration=0.3},
          {sprite=.Player_Harvest_Blood_6, duration=0.3},
          {sprite=.Player_Harvest_Blood_7, duration=0.3},
          {sprite=.Player_Harvest_Blood_8, duration=0.3},
        },
      },

      .Blood_Pool_Expand_M = {
        frames = {
          {sprite=.Blood_Pool_1, duration=0.25},
          {sprite=.Blood_Pool_2, duration=0.25},
          {sprite=.Blood_Pool_3, duration=0.25},
        },
      },
      .Blood_Pool_Expand_L = {
        frames = {
          {sprite=.Blood_Pool_1, duration=0.15},
          {sprite=.Blood_Pool_2, duration=0.15},
          {sprite=.Blood_Pool_3, duration=0.15},
          {sprite=.Blood_Pool_4, duration=0.15},
          {sprite=.Blood_Pool_5, duration=0.15},
          {sprite=.Blood_Pool_6, duration=0.15},
        },
      },

      .Deer_Idle = {
        frames = {
          {sprite=.Deer_Idle_1, duration=0.3},
          {sprite=.Deer_Idle_2, duration=0.3},
          {sprite=.Deer_Idle_3, duration=0.3},
          {sprite=.Deer_Idle_4, duration=0.3},
        },
      },
      .Deer_Walk = {
        frames = {
          {sprite=.Deer_Walk_1, duration=0.2},
          {sprite=.Deer_Walk_2, duration=0.2},
          {sprite=.Deer_Walk_3, duration=0.2},
          {sprite=.Deer_Walk_4, duration=0.2},
        },
      },

      .Rabbit_Idle = {
        frames = {
          {sprite=.Rabbit_Idle_1, duration=0.3},
          {sprite=.Rabbit_Idle_2, duration=0.3},
          {sprite=.Rabbit_Idle_3, duration=0.3},
          {sprite=.Rabbit_Idle_4, duration=0.3},
        },
      },
      .Rabbit_Walk = {
        frames = {
          {sprite=.Rabbit_Walk_1, duration=0.2},
          {sprite=.Rabbit_Walk_2, duration=0.2},
          {sprite=.Rabbit_Walk_3, duration=0.2},
          {sprite=.Rabbit_Walk_4, duration=0.2},
        },
      },

      .Squirrel_Idle = {
        frames = {
          {sprite=.Squirrel_Idle_1, duration=0.3},
          {sprite=.Squirrel_Idle_2, duration=0.3},
          {sprite=.Squirrel_Idle_3, duration=0.3},
          {sprite=.Squirrel_Idle_4, duration=0.3},
        },
      },
      .Squirrel_Walk = {
        frames = {
          {sprite=.Squirrel_Walk_1, duration=0.2},
          {sprite=.Squirrel_Walk_2, duration=0.2},
          {sprite=.Squirrel_Walk_3, duration=0.2},
          {sprite=.Squirrel_Walk_4, duration=0.2},
        },
      },

      .Zombie_Idle = {
        frames = {
          {sprite=.Zombie_Idle_1, duration=0.5},
          {sprite=.Zombie_Idle_2, duration=0.5},
        },
      },
      .Zombie_Walk = {
        frames = {
          {sprite=.Zombie_Walk_1, duration=0.1},
          {sprite=.Zombie_Walk_2, duration=0.1},
          {sprite=.Zombie_Walk_3, duration=0.1},
          {sprite=.Zombie_Walk_4, duration=0.1},
          {sprite=.Zombie_Walk_5, duration=0.1},
        },
      },
      .Zombie_Melee = {
        frames = {
          {sprite=.Zombie_Melee_1, duration=0.5},
          {sprite=.Zombie_Melee_2, duration=0.5},
        },
      },
    }
  }

  // - Entities ---
  {
    for &en in res.entities
    {
      en.tint = {1, 1, 1, 1}
    }

    res.entities = {
      .Nil = {},

      .Player = {
        animations = #partial {
          .Idle_Unarmed = .Player_Idle_Unarmed,
          .Idle_One_Handed = .Player_Idle_One_Handed,
          .Idle_Two_Handed = .Player_Idle_Two_Handed,
          .Walk_Unarmed = .Player_Walk_Unarmed,
          .Walk_One_Handed = .Player_Walk_One_Handed,
          .Walk_Two_Handed = .Player_Walk_Two_Handed,
          .Sneak_Idle_Unarmed = .Player_Sneak_Unarmed_1,
          .Sneak_Idle_One_Handed = .Player_Sneak_One_Handed_1,
          .Sneak_Idle_Two_Handed = .Player_Sneak_Two_Handed_1,
          .Sneak_Walk_Unarmed = .Player_Sneak_Walk_Unarmed,
          .Sneak_Walk_One_Handed = .Player_Sneak_Walk_One_Handed,
          .Sneak_Walk_Two_Handed = .Player_Sneak_Walk_Two_Handed,
          .Harvest_Blood = .Player_Harvest_Blood,
        },
        collider = Circle{
          radius = 4,
        },
      },

      .Item = {
        collider = Circle{
          radius = 3,
        },
      },

      .Bullet = {
        kind = .Projectile, 
        collider = Circle{
          radius = 3,
        },
      },

      .Blood_Pool_M = {
        animations = #partial {
          .Idle = .Blood_Pool_1,
          .Expand = .Blood_Pool_Expand_M,
        },
        collider = Circle{
          radius = 5,
        },
      },

      .Blood_Pool_L = {
        animations = #partial {
          .Idle = .Blood_Pool_1,
          .Expand = .Blood_Pool_Expand_L,
        },
        collider = Circle{
          radius = 7,
        },
      },

      .Deer = {
        kind = .Creature,
        props = {.Flee_Noise},
        animations = #partial {
          .Idle = .Deer_Idle,
          .Walk = .Deer_Walk,
        },
        collider = Circle{
          origin = {0, -5},
          radius = 6,
        },
      },
      .Rabbit = {
        kind = .Creature,
        props = {.Flee_Noise},
        animations = #partial {
          .Idle = .Rabbit_Idle,
          .Walk = .Rabbit_Walk,
        },
        collider = Circle{
          origin = {0, -2},
          radius = 4,
        },
      },
      .Squirrel = {
        kind = .Creature,
        props = {.Flee_Noise},
        animations = #partial {
          .Idle = .Squirrel_Idle,
          .Walk = .Squirrel_Walk,
        },
        collider = Circle{
          origin = {0, -2},
          radius = 4,
        },
      },
      .Zombie = {
        kind = .Creature,
        props = {.Hostile},
        animations = #partial {
          .Idle = .Zombie_Idle,
          .Walk = .Zombie_Walk,
        },
        collider = Circle{
          origin = {0, -5},
          radius = 6,
        },
      },

      .Grass = {
        animations = #partial {.Idle = .Grass},
      },
      .Lavender = {
        props = {.Collectable},
        animations = #partial {.Idle = .Lavender},
        collider = Circle{
          radius = 4,
        },
        loot_table = .Lavender,
      },
      .Chamomile = {
        animations = #partial {.Idle = .Chamomile},
        props = {.Collectable},
        collider = Circle{
          radius = 3,
        },
        loot_table = .Chamomile,
      },
      .Sunflower = {
        animations = #partial {.Idle = .Sunflower},
        props = {.Collectable},
        collider = Circle{
          radius = 3,
        },
        loot_table = .Sunflower,
      },
      .Brown_Mushroom = {
        animations = #partial {.Idle = .Brown_Mushroom},
        props = {.Collectable},
        collider = Circle{
          radius = 3,
        },
        loot_table = .Brown_Mushroom,
      },
      .Red_Mushroom = {
        animations = #partial {.Idle = .Red_Mushroom},
        props = {.Collectable},
        collider = Circle{
          radius = 3,
        },
        loot_table = .Red_Mushroom,
      },
      .Stump = {
        animations = #partial {.Idle = .Stump},
        collider = Circle{
          radius = 4,
        },
      },
    }
  }

  // - Creatures ---
  {
    res.creatures = #partial {
      .Nil = {},
      .Player = {
        speed = 40,
      },
      .Zombie = {
        corpse = .Zombie_Corpse,
        blood_pool = .Blood_Pool_L,
        wander_range = {50, 100},
        noise_threshold = 30,
        reaction_time = 0.2,
        health = 10,
        speed = 15,
        view_dist = 300,
        loot_table = .Nil,
      },
      .Deer = {
        corpse = .Deer_Corpse,
        blood_pool = .Blood_Pool_L,
        wander_range = {10, 50},
        flee_range = {50, 100},
        noise_threshold = 30,
        reaction_time = 0.2,
        health = 3,
        speed = 35,
        loot_table = .Deer,
      },
      .Rabbit = {
        corpse = .Rabbit_Corpse,
        blood_pool = .Blood_Pool_M,
        wander_range = {10, 50},
        flee_range = {50, 100},
        noise_threshold = 35,
        reaction_time = 0.1,
        health = 1,
        speed = 25,
        loot_table = .Rabbit,
      },
      .Squirrel = {
        corpse = .Squirrel_Corpse,
        blood_pool = .Blood_Pool_M,
        wander_range = {10, 50},
        flee_range = {50, 100},
        noise_threshold = 35,
        reaction_time = 0.1,
        health = 1,
        speed = 20,
        loot_table = .Squirrel,
      },
    }
  }

  // - Weapons ---
  {
    res.weapons = {
      .Nil = {},
      .Revolver = {
        sprite = .Revolver,
        hold_off = {2.5, -6},
        holster_off = {-2.5, -6},
        holster_rot = rad_from_deg(f32(90.0)),
        shot_pos = {6.0, -1.5},
        shot_time = 0.35,
        reload_time = 3.0,
        damage = 1,
        speed = 512.0,
        capacity = 6,
        handedness = .One_Handed,
      },
      .Rifle = {
        sprite = .Rifle,
        hold_off = {0.5, -6},
        holster_off = {-2.5, -12},
        holster_rot = rad_from_deg(f32(90.0)),
        shot_pos = {12.0, -1.5},
        shot_time = 1.0,
        reload_time = 5.0,
        damage = 2,
        speed = 512.0,
        capacity = 5,
        handedness = .Two_Handed,
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
      .Squirrel_Tail = {
        name = "Squirrel Tail",
        animations = #partial {
          .Idle = .Item_Squirrel_Tail,
        },
        value = 1,
      },
      .Chamomile = {
        name = "Chamomile",
        animations = #partial {
          .Idle = .Chamomile, 
        },
        value = 1,
      },
      .Sunflower = {
        name = "Sunflower",
        animations = #partial {
          .Idle = .Sunflower, 
        },
        value = 1,
      },
      .Lavender = {
        name = "Lavender",
        animations = #partial {
          .Idle = .Lavender, 
        },
        value = 1,
      },
      .Brown_Mushroom = {
        name = "Brown Mushroom",
        animations = #partial {
          .Idle = .Brown_Mushroom, 
        },
        value = 1,
      },
      .Red_Mushroom = {
        name = "Red Mushroom",
        animations = #partial {
          .Idle = .Red_Mushroom, 
        },
        value = 1,
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
      .Squirrel = {
        {item = .Squirrel_Tail, rate = 1.0},
      },
      .Chamomile = {
        {item = .Chamomile, rate = 1.0},
      },
      .Sunflower = {
        {item = .Sunflower, rate = 1.0},
      },
      .Lavender = {
        {item = .Lavender, rate = 1.0},
      },
      .Brown_Mushroom = {
        {item = .Brown_Mushroom, rate = 1.0},
      },
      .Red_Mushroom = {
        {item = .Red_Mushroom, rate = 1.0},
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

  // - Particles ---
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
        scl_dt = {-0.7, -0.7},
        vel = {48.0, 48.0},
        vel_dt = {0, -120},
      },
      .Hurt_Blood = {
        sprite = .Blood_Particle,
        emmision_kind = .Burst,
        props = {.Persist},
        colors = {{0.5, 0, 0, 0}, {0.4, 0, 0, 0}, {0.3, 0, 0, 0}},
        count = 4,
        lifetime = 0.1,
        lifetime_var = 0.05,
        scl = {0.3, 0.3},
        scl_var = 0.2,
        vel = {48, 48},
        vel_dt = {0, 256},
      },
    }
  }


}

build_sprite_atlas :: proc(textures_path, atlas_path: string)
{
  MAX_ATLAS_WIDTH :: 128
  PADDING         :: 1

  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  walker: os.Walker
  defer os.walker_destroy(&walker)

  atlas_width, atlas_height: int
  max_sprite_height: int
  num_rows := 1

  // - First pass ---

  os.walker_init(&walker, textures_path)
  for fi in os.walker_walk(&walker)
  {
    if fi.name[len(fi.name)-4:] != ".tga" do continue

    sprite_name_str: string
    for i in 0..<len(fi.name)-3
    {
      if fi.name[i:i+4] == ".tga"
      {
        sprite_name_str = fi.name[:i]
        break
      }
    }

    sprite_name := sprite_name_from_string(sprite_name_str)
    if sprite_name == nil && sprite_name_str != "nil" do continue

    sprite_img, err := tga.load(fi.fullpath, allocator=mem.allocator(scratch))
    defer tga.destroy(sprite_img)
    if err != nil
    {
      log.fatalf("[game]: Failed to open texture '%s'\n", fi.name)
      os.exit(1)
    }

    if atlas_width + sprite_img.width + PADDING > MAX_ATLAS_WIDTH
    {
      atlas_width = 0
      num_rows += 1
    }

    atlas_width += sprite_img.width + 1
    max_sprite_height = max(max_sprite_height, sprite_img.height)
  }

  max_sprite_height += PADDING

  atlas_width = MAX_ATLAS_WIDTH
  atlas_height = max_sprite_height * num_rows

  atlas_pixels := make([]image.RGBA_Pixel, atlas_width * atlas_height, context.allocator)
  atlas_pos: [enum{Abs, Rel}][2]int

  // - Second pass ---

  os.walker_init(&walker, textures_path)
  for fi in os.walker_walk(&walker)
  {
    if fi.name[len(fi.name)-4:] != ".tga" do continue

    sprite_name_str: string
    for i in 0..<len(fi.name)-3
    {
      if fi.name[i:i+4] == ".tga"
      {
        sprite_name_str = fi.name[:i]
        break
      }
    }

    sprite_name := sprite_name_from_string(sprite_name_str)
    if sprite_name == nil && sprite_name_str != "nil" do continue

    sprite_img, err := tga.load(fi.fullpath)
    defer tga.destroy(sprite_img)
    if err != nil
    {
      log.fatalf("[game]: Failed to open texture '%s'", fi.name)
      os.exit(1)
    }

    sprite_pos: int

    if atlas_pos[.Abs].x + sprite_img.width + PADDING > MAX_ATLAS_WIDTH
    {
      atlas_pos[.Abs].x = 0
      atlas_pos[.Abs].y += max_sprite_height
    }

    for r in 0..<sprite_img.height
    {
      for c in 0..<sprite_img.width
      {
        pos := atlas_pos[.Abs] + atlas_pos[.Rel]
        atlas_pixels[pos.x + (pos.y * atlas_width)].r = sprite_img.pixels.buf[sprite_pos+0]
        atlas_pixels[pos.x + (pos.y * atlas_width)].g = sprite_img.pixels.buf[sprite_pos+1]
        atlas_pixels[pos.x + (pos.y * atlas_width)].b = sprite_img.pixels.buf[sprite_pos+2]
        atlas_pixels[pos.x + (pos.y * atlas_width)].a = sprite_img.pixels.buf[sprite_pos+3]
        sprite_pos += 4
        atlas_pos[.Rel].x += 1
      }

      atlas_pos[.Rel].x = 0
      atlas_pos[.Rel].y += 1
    }

    res.sprites[sprite_name].coord = cast(v2f32) atlas_pos[.Abs]
    res.sprites[sprite_name].size = cast(v2f32) [2]int{sprite_img.width, sprite_img.height}

    atlas_pos[.Rel].y = 0
    atlas_pos[.Abs].x += sprite_img.width + PADDING
  }

  atlas, ok := image.pixels_to_image(atlas_pixels[:], atlas_width, atlas_height)
  if ok
  {
    err := tga.save_to_file(atlas_path, &atlas)
    if err != nil
    {
      log.errorf("[game]: Failed to save sprite atlas to file. (%s)\n", err)
    }
  }
  else
  {
    log.error("[game]: Failed to make sprite atlas image from pixels.")
  }
}

sprite_name_from_string :: proc(str: string) -> Sprite_Name
{
  for field in reflect.enum_fields_zipped(Sprite_Name)
  {
    if strings.equal_fold(field.name, str)
    {
      return Sprite_Name(field.value)
    }
  }

  return .Nil
}
