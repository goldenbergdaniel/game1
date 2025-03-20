package game

import "core:image/qoi"

import "ext:basic/mem"
import r "src:render"
import vm "src:vecmath"

Resources :: struct
{
  textures: [r.Texture_ID]r.Texture,
  sprites:  [Sprite_ID]Sprite,
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
    res.sprites[.LASER]        = {coords={7, 0}, grid={1, 1}, pivot={7, 7}}
    res.sprites[.ASTEROID_BIG] = {coords={0, 1}, grid={2, 2}, pivot={15, 17}}

    for &sprite in res.sprites
    {
      sprite.texture = .SPRITE_MAP
      sprite.pivot /= vm.array_cast(sprite.grid, f32) * 15
    }
  }
}
