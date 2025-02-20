package game

import r "src:render"

Resources :: struct
{
  textures: struct
  {
    sprite_atlas: r.Texture,
  },

  sprite: struct
  {
    ship_1:     Sprite,
    ship_2:     Sprite,
    projectile: Sprite,
    asteroid:   Sprite,
  },
}

g_res: Resources

init_resources :: proc()
{
  
}
