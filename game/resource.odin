package game

import "core:image/qoi"

import "basic/mem"

import r "render"
import vm "vecmath"

Resources :: struct
{
  textures:     [r.Texture_ID]r.Texture,
  sprites:      [Sprite_ID]Sprite,
  enemies:      [Enemy_Kind]Enemy_Desc,
  enemy_spawns: [1]Enemy_Spawn_Desc,
  entity_anims: [Entity_Anim_ID]Entity_Anim_Desc,
}

Enemy_Desc :: struct
{
  props: bit_set[Entity_Prop],
}

Enemy_Spawn_Desc :: struct
{
  kind: Enemy_Kind,
  time: f32,
  pos:  v2f32,
}

Entity_Anim_ID :: enum
{
  NIL,
  PLAYER_IDLE,
}

Entity_Anim_Desc :: struct
{
  frames:          [16]Sprite_ID,
  frame_count:     u16,
  ticks_per_frame: u16,
  exit_state:      Entity_Anim_State,
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  // - Textures ---
  {
    img: ^qoi.Image
    err: qoi.Error

    img, err = qoi.load_from_file("res/textures/sprite_map.qoi", allocator=mem.a(arena))
    if err != nil do panic("Game: Error opening texture file.")

    res.textures[.SPRITE_MAP] = r.Texture{
      data = img.pixels.buf[:],
      width = cast(i32) img.width,
      height = cast(i32) img.height,
      cell = 16,
    }
  }

  // - Sprites ---
  {
    res.sprites[.SQUARE]        = {coords={0, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.CIRCLE]        = {coords={1, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.PLAYER_IDLE_1] = {coords={2, 0}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_IDLE_2] = {coords={3, 0}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.BULLET]        = {coords={6, 0}, grid={1, 1}, pivot={7, 8}}

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= vm.array_cast(sprite.grid, f32) * 15
    }
  }

  // - Enemy spawns ---
  {
    res.enemy_spawns[0] = Enemy_Spawn_Desc{kind=.ALIEN, time=1.0, pos={WORLD_WIDTH, 0}}
    // res.enemy_spawns[1] = Enemy_Spawn_Desc{kind=.ALIEN, time=3.0, pos={WORLD_WIDTH, 0}}
    // res.enemy_spawns[2] = Enemy_Spawn_Desc{kind=.ALIEN, time=3.0, pos={WORLD_WIDTH-100, 0}}
    // res.enemy_spawns[3] = Enemy_Spawn_Desc{kind=.ALIEN, time=8.0, pos={WORLD_WIDTH, 0}}
  }

  // - Entity animations ---
  {
    res.entity_anims[.PLAYER_IDLE] = Entity_Anim_Desc{
      frames = {
        0 = .PLAYER_IDLE_1, 
        1 = .PLAYER_IDLE_2,
      },
      frame_count = 2,
      ticks_per_frame = 30,
      exit_state = .IDLE,
    }
  }
}
