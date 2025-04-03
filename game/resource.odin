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
    res.sprites[.SQUARE]       = {coords={0, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.CIRCLE]       = {coords={1, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.SHIP]         = {coords={2, 0}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.ALIEN]        = {coords={3, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.FOOTBALL]     = {coords={4, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.ASTEROID]     = {coords={5, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.PROJECTILE]   = {coords={6, 0}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.LASER]        = {coords={7, 0}, grid={1, 1}, pivot={7, 8}}
    res.sprites[.ASTEROID_BIG] = {coords={0, 1}, grid={2, 2}, pivot={15, 17}}

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= vm.array_cast(sprite.grid, f32) * 15
    }
  }

  // - Enemy spawns ---
  {
    res.enemy_spawns[0] = {kind=.ALIEN, time=1.0, pos={WORLD_WIDTH, 0}}
    // res.enemy_spawns[1] = {kind=.ALIEN, time=3.0, pos={WORLD_WIDTH, 0}}
    // res.enemy_spawns[2] = {kind=.ALIEN, time=3.0, pos={WORLD_WIDTH-100, 0}}
    // res.enemy_spawns[3] = {kind=.ALIEN, time=8.0, pos={WORLD_WIDTH, 0}}
  }
}
