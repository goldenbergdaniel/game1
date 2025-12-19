package game

import ft "ext:freetype"
import "basic/vmath"
import "platform"
import "render"

@(private="file")
global: struct
{
  library:     ft.Library,
  face:        ft.Face,
  initialized: bool,
}


// Sprite /////////////////////////////////////////////////////////////////////////////////////////


Sprite :: struct
{
  coord: v2f32,
  grid:  v2f32,
  pivot: v2f32,
}

draw_sprite :: proc(
  sprite: Sprite_Name,
  pos:    v2f32,
  scl:    v2f32,
  rot:    f32 = 0,
  tint:   v4f32 = {1, 1, 1, 1},
  color:  v4f32 = {0, 0, 0, 0},
){
  sprite_data := &res.sprites[sprite]
  texture := render.get_pass().texture
  dim := scl * sprite_data.grid

  xform := vmath.translation_3x3f(pos - dim * sprite_data.pivot)
  xform *= vmath.translation_3x3f(dim * sprite_data.pivot)
  xform *= vmath.rotation_3x3f(rot)
  xform *= vmath.translation_3x3f(-dim * sprite_data.pivot)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  tl, tr, br, bl := render.coords_from_texture(texture, sprite_data.coord, sprite_data.grid)

  render.push_vertex({p1.xy, tint, color, tl})
  render.push_vertex({p2.xy, tint, color, tr})
  render.push_vertex({p3.xy, tint, color, br})
  render.push_vertex({p4.xy, tint, color, bl})
  render.push_rectangle_indices()
}


// Text //////////////////////////////////////////////////////////////////////////////////


init_font :: proc(font: []byte) -> ft.Error
{
  ft.init_freetype(&global.library) or_return
  ft.new_memory_face(global.library, raw_data(font), i64(len(font)), 0, &global.face) or_return

  global.initialized = true

  return nil
}

draw_text :: proc(
  text:  string,
  pos:   v2f32,
  size:  int,
  color: v4f32 = {1, 1, 1, 0},
){
  ft_err: ft.Error

  dpi := cast(u32) platform.get_display_scale(&user.window) * 96
  ft_err = ft.set_char_size(global.face, 0, cast(ft.F26Dot6) (size * 64), dpi, dpi)
  if ft_err != nil
  {
    println("Error [freetype]: Failed to set character size!", ft_err)
    return
  }

  for char in text
  {
    // idx := ft.get_char_index(global.face, u64(char))
    // printf("%c: %i\n", char, idx)
  }
}


// Util //////////////////////////////////////////////////////////////////////////////////


rgba_from_hsva :: proc(hsva: v4f32) -> (rgba: v4f32)
{
  h, s, v, a := hsva[0], hsva[1], hsva[2], hsva[3]

  if s == 0 do return {v, v, v, a}

  h6 := h * 6
  if h6 >= 6 do h6 = 0

  sector := cast(int) h6
  f := h6 - cast(f32) sector

  p := v * (1 - s)
  q := v * (1 - s * f)
  t := v * (1 - s * (1 - f))

  r, g, b: f32
  switch sector
  {
  case 0: r, g, b = v, t, p
  case 1: r, g, b = q, v, p
  case 2: r, g, b = p, v, t
  case 3: r, g, b = p, q, v
  case 4: r, g, b = t, p, v
  case 5: r, g, b = v, p, q
  }

  return {r, g, b, a}
}
