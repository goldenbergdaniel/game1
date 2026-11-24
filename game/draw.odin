package game

import "basic/vmath"
import "basic/mem"
import "platform"
import "render"
import "ui"

D_MAX_VERTEX_COUNT :: 40000
D_MAX_INDEX_COUNT  :: 60000

D_Vertex :: union
{
  D_Sprite_Vertex,
  D_GUI_Vertex,
}

D_Sprite_Vertex :: struct
{
  pos:   v2f32,
  tint:  v4f32,
  color: v4f32,
  uv:    v2f32,
}

D_GUI_Vertex :: struct
{
  pos:   v2f32,
  tint:  v4f32,
  color: v4f32,
  uv:    v2f32,
  tex:   u32,
}

D_Data :: struct
{
  sprite_vertices: [dynamic; D_MAX_VERTEX_COUNT]D_Sprite_Vertex,
  sprite_indices:  [dynamic; D_MAX_INDEX_COUNT]u16,
  gui_vertices:    [dynamic; D_MAX_VERTEX_COUNT]D_GUI_Vertex,
  gui_indices:     [dynamic; D_MAX_INDEX_COUNT]u16,
  vertex_buffer:   render.Buffer,
  index_buffer:    render.Buffer,
}

d_data: D_Data

init_draw :: proc()
{
  d_data.vertex_buffer = render.create_buffer(cap(d_data.gui_vertices) * size_of(D_GUI_Vertex), .Vertex, 0)
  d_data.index_buffer = render.create_buffer(cap(d_data.gui_indices) * size_of(u16), .Index, 0)
}

d_flush_sprite :: proc()
{
  render.write_buffer(d_data.vertex_buffer, 
                      raw_data(d_data.sprite_vertices[:]), 
                      len(d_data.sprite_vertices) * size_of(D_Sprite_Vertex), 
                      0)

  render.write_buffer(d_data.index_buffer, 
                      raw_data(d_data.sprite_indices[:]), 
                      len(d_data.sprite_indices) * size_of(u16), 
                      0)

  render.draw(len(d_data.sprite_indices))

  clear(&d_data.sprite_vertices)
  clear(&d_data.sprite_indices)
}

d_flush_gui :: proc()
{
  render.write_buffer(d_data.vertex_buffer, 
                      raw_data(d_data.gui_vertices[:]), 
                      len(d_data.gui_vertices) * size_of(D_GUI_Vertex), 
                      0)

  render.write_buffer(d_data.index_buffer, 
                      raw_data(d_data.gui_indices[:]), 
                      len(d_data.gui_indices) * size_of(u16), 
                      0)

  render.draw(len(d_data.gui_indices))

  clear(&d_data.gui_vertices)
  clear(&d_data.gui_indices)
}

d_push_vertex :: proc(vertex: D_Vertex)
{
  switch v in vertex
  {
  case D_Sprite_Vertex:
    if len(d_data.sprite_vertices) == cap(d_data.sprite_vertices)
    {
      d_flush_sprite()
    }
    append(&d_data.sprite_vertices, v)

  case D_GUI_Vertex:
    if len(d_data.gui_vertices) == cap(d_data.gui_vertices)
    {
      d_flush_gui()
    }
    append(&d_data.gui_vertices, v)
  }
}

d_push_sprite_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3, 
    1, 2, 3,
  }

  offset := cast(u16) len(d_data.sprite_vertices) - 4

  for i in layout
  {
    append(&d_data.sprite_indices, i + offset)
  }
}

d_push_gui_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3, 
    1, 2, 3,
  }

  offset := cast(u16) len(d_data.gui_vertices) - 4

  for i in layout
  {
    append(&d_data.gui_indices, i + offset)
  }
}

// Sprite /////////////////////////////////////////////////////////////////////////////////////////


Sprite :: struct
{
  coord: v2f32,
  size:  v2f32,
  pivot: v3f32,
}

draw_ground :: proc(pos, dim: v2f32)
{
  xform := vmath.translation_3x3f(pos)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  d_push_vertex(D_Sprite_Vertex{p1.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0}})
  d_push_vertex(D_Sprite_Vertex{p2.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 0}})
  d_push_vertex(D_Sprite_Vertex{p3.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 1}})
  d_push_vertex(D_Sprite_Vertex{p4.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 1}})
  d_push_sprite_indices()
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
  dim := scl * sprite_data.size
  offset := dim * sprite_data.pivot.xy

  xform := vmath.translation_3x3f(pos - offset)
  xform *= vmath.translation_3x3f(offset)
  xform *= vmath.rotation_3x3f(rot)
  xform *= vmath.translation_3x3f(-offset)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  tl, tr, br, bl := render.uv_from_texture(&res.textures[.Sprite_Atlas], 
                                           sprite_data.coord, 
                                           sprite_data.size)

  d_push_vertex(D_Sprite_Vertex{p1.xy, tint, color, tl})
  d_push_vertex(D_Sprite_Vertex{p2.xy, tint, color, tr})
  d_push_vertex(D_Sprite_Vertex{p3.xy, tint, color, br})
  d_push_vertex(D_Sprite_Vertex{p4.xy, tint, color, bl})
  d_push_sprite_indices()
}

draw_gui_quad :: proc(
  sprite: Sprite_Name,
  pos:    v2f32,
  scl:    v2f32,
  rot:    f32 = 0,
  tint:   v4f32 = {1, 1, 1, 1},
  color:  v4f32 = {0, 0, 0, 0},
){
  sprite_data := &res.sprites[sprite]
  dim := scl * sprite_data.size
  offset := dim * sprite_data.pivot.xy

  xform := vmath.translation_3x3f(pos - offset)
  xform *= vmath.translation_3x3f(offset)
  xform *= vmath.rotation_3x3f(rot)
  xform *= vmath.translation_3x3f(-offset)
  xform *= vmath.scale_3x3f(dim)

  p1 := xform * v3f32{0, 0, 1}
  p2 := xform * v3f32{1, 0, 1}
  p3 := xform * v3f32{1, 1, 1}
  p4 := xform * v3f32{0, 1, 1}

  tl, tr, br, bl := render.uv_from_texture(&res.textures[.Sprite_Atlas], 
                                           sprite_data.coord, 
                                           sprite_data.size)

  d_push_vertex(D_GUI_Vertex{p1.xy, tint, color, tl, 0})
  d_push_vertex(D_GUI_Vertex{p2.xy, tint, color, tr, 0})
  d_push_vertex(D_GUI_Vertex{p3.xy, tint, color, br, 0})
  d_push_vertex(D_GUI_Vertex{p4.xy, tint, color, bl, 0})
  d_push_gui_indices()
}

// Text //////////////////////////////////////////////////////////////////////////////////


draw_text :: proc(
  text:        string,
  pos:         v2f32,
  size:        f32 = 1,
  line_height: f32 = 1,
  color:       v4f32 = {1, 1, 1, 0},
){
  cursor: v2f32
  for r in text
  {
    if r == '\n'
    {
      cursor.x = 0
      cursor.y += 15 * line_height * size
      continue
    }

    glyph := ui.glyph_from_rune(r)
    tl, tr, br, bl := render.uv_from_texture(&res.textures[.Glyph_Atlas], 
                                             v2f32(glyph.coord), 
                                             {f32(glyph.width), f32(glyph.height)})

    offset := pos + {cursor.x + glyph.bearing.x * size, cursor.y - glyph.bearing.y * size}
    offset.y += 10 * line_height * size

    xform := vmath.translation_3x3f(offset)
    cursor += glyph.advance * size

    xform *= vmath.scale_3x3f({f32(glyph.width), f32(glyph.height)} * size)

    p1 := xform * v3f32{0, 0, 1}
    p2 := xform * v3f32{1, 0, 1}
    p3 := xform * v3f32{1, 1, 1}
    p4 := xform * v3f32{0, 1, 1}

    d_push_vertex(D_GUI_Vertex{p1.xy, {1, 1, 1, 1}, color, tl, 1})
    d_push_vertex(D_GUI_Vertex{p2.xy, {1, 1, 1, 1}, color, tr, 1})
    d_push_vertex(D_GUI_Vertex{p3.xy, {1, 1, 1, 1}, color, br, 1})
    d_push_vertex(D_GUI_Vertex{p4.xy, {1, 1, 1, 1}, color, bl, 1})
    d_push_gui_indices()
  }
}

draw_decorated_text :: proc(
  text:        ui.Decorated_String,
  pos:         v2f32,
  size:        f32 = 1,
  line_height: f32 = 1,
){
  cursor: v2f32

  for chunk in text.chunks
  {
    color := v4f32{chunk.color.r, chunk.color.g, chunk.color.b, 0}
    {
      for r in chunk.text
      {
        if r == '\n'
        {
          cursor.x = 0
          cursor.y += 15 * line_height * size
          continue
        }

        glyph := ui.glyph_from_rune(r)
        tl, tr, br, bl := render.uv_from_texture(&res.textures[.Glyph_Atlas], 
                                                v2f32(glyph.coord), 
                                                {f32(glyph.width), f32(glyph.height)})

        offset := pos + {cursor.x + glyph.bearing.x * size, cursor.y - glyph.bearing.y * size}
        offset.y += 10 * line_height * size

        xform := vmath.translation_3x3f(offset)
        cursor += glyph.advance * size

        xform *= vmath.scale_3x3f({f32(glyph.width), f32(glyph.height)} * size)

        p1 := xform * v3f32{0, 0, 1}
        p2 := xform * v3f32{1, 0, 1}
        p3 := xform * v3f32{1, 1, 1}
        p4 := xform * v3f32{0, 1, 1}

        d_push_vertex(D_GUI_Vertex{p1.xy, {1, 1, 1, 1}, color, tl, 1})
        d_push_vertex(D_GUI_Vertex{p2.xy, {1, 1, 1, 1}, color, tr, 1})
        d_push_vertex(D_GUI_Vertex{p3.xy, {1, 1, 1, 1}, color, br, 1})
        d_push_vertex(D_GUI_Vertex{p4.xy, {1, 1, 1, 1}, color, bl, 1})
        d_push_gui_indices()
      }
    }
  }
}


// UI ////////////////////////////////////////////////////////////////////////////////////


draw_ui :: proc(tree: ^ui.Tree, ref_pos: v2f32 = {0, 0}, ref_size: v2f32 = {0, 0})
{
  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  window_size := platform.window_get_size(&user.window)

  ui.tree_resolve(tree, ref_pos, ref_size)
  
  render.begin_pass({
    pipeline = res.pipelines[.GUI],
    texture = i32(Texture_Name.Sprite_Atlas),
    vertex_buf = d_data.vertex_buffer,
    index_buf = d_data.index_buffer,
    camera = vmath.translation_3x3f({0, 0}),
    projection = vmath.orthographic(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 0},
  })

  iter := ui.make_iterator_preorder(tree.root, scratch)
  for box in ui.iterate_preorder(&iter)
  {
    sprite := cast(Sprite_Name) box.sprite
    if sprite == nil
    {
      sprite = .UI_Rect
    }

    draw_gui_quad(sprite=sprite,
                  pos=box.rect_pos,
                  scl=box.rect_dim/16,
                  color=vmath.concat(box.color.rgb, 0),
                  tint={1, 1, 1, box.color.a})

    if box.decorated_text.len != 0
    {
      draw_decorated_text(text=box.decorated_text, 
                          pos=box.rect_pos, 
                          size=box.text_size, 
                          line_height=1)
    }
    else if box.text != ""
    {
      draw_text(text=box.text, 
                pos=box.rect_pos, 
                size=box.text_size, 
                line_height=1,
                color=vmath.concat(box.text_color, 0))
    }
  }

  d_flush_gui()
  render.end_pass()
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
