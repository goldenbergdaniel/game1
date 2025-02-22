package game

import "core:image"
import "core:image/qoi"

import "src:basic/mem"
import r "src:render"

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
    sprite_atlas_img, err := qoi.load_from_file("res/textures/sprites.qoi", 
                                                allocator=mem.a(arena))
    assert(err == nil)

    res.textures[.SPRITE_ATLAS] = r.Texture{
      data = sprite_atlas_img.pixels.buf[:],
      width = cast(i32) sprite_atlas_img.width,
      height = cast(i32) sprite_atlas_img.height,
      cell = 16,
    }
  }

  // - Sprites ---
  {
    res.sprites[.NIL]        = Sprite{coords={0, 0}, dim={16, 16}, pivot={0, 0}}
    res.sprites[.SHIP_1]     = Sprite{coords={1, 0}, dim={16, 16}, pivot={0, 0}}
    res.sprites[.PROJECTILE] = Sprite{coords={2, 0}, dim={4, 4}, pivot={0.5, 0.5}}

    for &sprite in res.sprites
    {
      sprite.texture_kind = .SPRITE_ATLAS
    }
  }
}
