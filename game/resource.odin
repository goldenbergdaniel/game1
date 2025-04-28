#+feature dynamic-literals
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
  entity_anims: [Entity_Anim_ID]Entity_Anim_Desc,
}

Sprite_ID :: enum
{
  NIL,
  SQUARE,
  CIRCLE,
  SHADOW,
  PLAYER_IDLE_1,
  PLAYER_IDLE_2,
  PLAYER_WALK_1,
  PLAYER_WALK_2,
  PLAYER_WALK_3,
  PLAYER_WALK_4,
  PLAYER_WALK_5,
  BULLET,
  RIFLE,
}

Enemy_Desc :: struct
{
  props: bit_set[Entity_Prop],
}

Entity_Anim_ID :: enum
{
  NIL,
  PLAYER_IDLE,
  PLAYER_WALK,
}

Entity_Anim_Desc :: struct
{
  frames:          [dynamic]Sprite_ID,
  ticks_per_frame: u16,
  exit_state:      Entity_State,
}

res: Resources

init_resources :: proc(arena: ^mem.Arena)
{
  context.allocator = mem.allocator(arena)

  // - Textures ---
  {
    img: ^qoi.Image
    err: qoi.Error

    img, err = qoi.load_from_file("res/textures/sprite_map.qoi", allocator=mem.allocator(arena))
    if err != nil do panicf("Failed to open texture file!", err)

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
    res.sprites[.SHADOW]        = {coords={2, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.PLAYER_IDLE_1] = {coords={0, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_IDLE_2] = {coords={1, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_WALK_1] = {coords={2, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_WALK_2] = {coords={3, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_WALK_3] = {coords={4, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_WALK_4] = {coords={5, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.PLAYER_WALK_5] = {coords={6, 1}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.BULLET]        = {coords={0, 2}, grid={1, 1}, pivot={7, 8}}

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= vm.array_cast(sprite.grid, f32) * 15
    }
  }

  // - Entity animations ---
  {
    res.entity_anims[.PLAYER_IDLE] = Entity_Anim_Desc{
      frames = {
        .PLAYER_IDLE_1, 
        .PLAYER_IDLE_2,
      },
      ticks_per_frame = 30,
      exit_state = .NIL,
    }

    res.entity_anims[.PLAYER_WALK] = Entity_Anim_Desc{
      frames = {
        .PLAYER_WALK_1, 
        .PLAYER_WALK_2,
        .PLAYER_WALK_3,
        .PLAYER_WALK_4,
        .PLAYER_WALK_5,
      },
      ticks_per_frame = 30,
      exit_state = .NIL,
    }
  }
}
