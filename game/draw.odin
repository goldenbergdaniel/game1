package game

import "core:slice"
import "basic/vmath"
import "basic/mem"
import "platform"
import "render"
import "ui"

D_MAX_VERTEX_COUNT :: 40000
D_MAX_INDEX_COUNT  :: D_MAX_VERTEX_COUNT * 1.5

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
  tex:   u32,
}

D_GUI_Vertex :: struct
{
  pos:   v2f32,
  tint:  v4f32,
  color: v4f32,
  uv:    v2f32,
  tex:   u32,
}

D_State :: struct
{
  sprite_vertices:   [dynamic; D_MAX_VERTEX_COUNT]D_Sprite_Vertex,
  sprite_indices:    [dynamic; D_MAX_INDEX_COUNT]u16,
  gui_vertices:      [dynamic; D_MAX_VERTEX_COUNT]D_GUI_Vertex,
  gui_indices:       [dynamic; D_MAX_INDEX_COUNT]u16,
  sprite_vertex_buf: render.Buffer,
  sprite_index_buf:  render.Buffer,
  gui_vertex_buf:    render.Buffer,
  gui_index_buf:     render.Buffer,
  push_data:         struct
  {
    xform:           m3x3f32,
    light_color:     v4f32,
    vertex_buf:      u64,
  },  
}

d_st: D_State

init_draw :: proc()
{
  render.init_renderer(slice.enumerated_array(&res.textures))

  d_st.sprite_vertex_buf = render.create_buffer(.Storage, size_of(d_st.sprite_vertices))
  d_st.sprite_index_buf = render.create_buffer(.Index, cap(d_st.sprite_indices) * size_of(u16))

  d_st.gui_vertex_buf = render.create_buffer(.Storage, size_of(d_st.sprite_vertices))
  d_st.gui_index_buf = render.create_buffer(.Index, cap(d_st.sprite_indices) * size_of(u16))

  // res.pipelines[.Sprite] = render.create_graphics_pipeline({
  //   vert_shader_src = #load("../res/shaders/sprite.vert.glsl"),
  //   frag_shader_src = #load("../res/shaders/sprite.frag.glsl"),
  //   uniform_names = {"u_tex", "u_light"},
  // })

  // res.pipelines[.GUI] = render.create_graphics_pipeline({
  //   vert_shader_src = #load("../res/shaders/gui.vert.glsl"),
  //   frag_shader_src = #load("../res/shaders/gui.frag.glsl"),
  //   uniform_names = {"u_tex", "u_fnt"},
  // })

  res.pipelines[.Sprite] = render.create_graphics_pipeline({
    vert_shader_src = #load("shaders/out/shader.vert.spv"),
    frag_shader_src = #load("shaders/out/shader.frag.spv"),
    push_data_size = size_of(d_st.push_data),
    color_attachment_fmt = render.get_color_target().format,
    depth_test_en = false,
    stencil_test_en = false,
    blend_en = true,
  })

  res.pipelines[.GUI] = render.create_graphics_pipeline({
    vert_shader_src = #load("shaders/out/shader.vert.spv"),
    frag_shader_src = #load("shaders/out/shader.frag.spv"),
    push_data_size = size_of(d_st.push_data),
    color_attachment_fmt = render.get_color_target().format,
    depth_test_en = false,
    stencil_test_en = false,
    blend_en = true,
  })
}

d_flush_sprite :: proc()
{
  render.write_buffer(d_st.sprite_vertex_buf, 
                      raw_data(d_st.sprite_vertices[:]), 
                      len(d_st.sprite_vertices) * size_of(D_Sprite_Vertex), 
                      0)

  render.write_buffer(d_st.sprite_index_buf, 
                      raw_data(d_st.sprite_indices[:]), 
                      len(d_st.sprite_indices) * size_of(u16), 
                      0)

  render.draw_indexed(len(d_st.sprite_indices), 1, 0, 0)

  clear(&d_st.sprite_vertices)
  clear(&d_st.sprite_indices)
}

d_flush_gui :: proc()
{
  render.write_buffer(d_st.gui_vertex_buf, 
                      raw_data(d_st.gui_vertices[:]), 
                      len(d_st.gui_vertices) * size_of(D_GUI_Vertex), 
                      0)

  render.write_buffer(d_st.gui_index_buf, 
                      raw_data(d_st.gui_indices[:]), 
                      len(d_st.gui_indices) * size_of(u16), 
                      0)

  render.draw_indexed(len(d_st.gui_indices), 1, 0, 0)

  clear(&d_st.gui_vertices)
  clear(&d_st.gui_indices)
}

d_push_vertex :: proc(vertex: D_Vertex)
{
  switch v in vertex
  {
  case D_Sprite_Vertex:
    if len(d_st.sprite_vertices) == cap(d_st.sprite_vertices)
    {
      d_flush_sprite()
    }
    append(&d_st.sprite_vertices, v)

  case D_GUI_Vertex:
    if len(d_st.gui_vertices) == cap(d_st.gui_vertices)
    {
      d_flush_gui()
    }
    append(&d_st.gui_vertices, v)
  }
}

d_push_sprite_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3, 
    1, 2, 3,
  }

  offset := cast(u16) len(d_st.sprite_vertices) - 4

  for i in layout
  {
    append(&d_st.sprite_indices, i + offset)
  }
}

d_push_gui_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3, 
    1, 2, 3,
  }

  offset := cast(u16) len(d_st.gui_vertices) - 4

  for i in layout
  {
    append(&d_st.gui_indices, i + offset)
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

  d_push_vertex(D_Sprite_Vertex{p1.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0}, u32(Texture_Name.Ground)})
  d_push_vertex(D_Sprite_Vertex{p2.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 0}, u32(Texture_Name.Ground)})
  d_push_vertex(D_Sprite_Vertex{p3.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 1}, u32(Texture_Name.Ground)})
  d_push_vertex(D_Sprite_Vertex{p4.xy, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 1}, u32(Texture_Name.Ground)})
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

  tl, tr, br, bl := render.uv_from_rect(f32(res.textures[.Sprite_Atlas].width), 
                                        f32(res.textures[.Sprite_Atlas].height),
                                        sprite_data.coord, 
                                        sprite_data.size)

  d_push_vertex(D_Sprite_Vertex{p1.xy, tint, color, tl, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_Sprite_Vertex{p2.xy, tint, color, tr, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_Sprite_Vertex{p3.xy, tint, color, br, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_Sprite_Vertex{p4.xy, tint, color, bl, u32(Texture_Name.Sprite_Atlas)})
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

  tl, tr, br, bl := render.uv_from_rect(f32(res.textures[.Sprite_Atlas].width), 
                                        f32(res.textures[.Sprite_Atlas].height),
                                        sprite_data.coord, 
                                        sprite_data.size)

  d_push_vertex(D_GUI_Vertex{p1.xy, tint, color, tl, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_GUI_Vertex{p2.xy, tint, color, tr, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_GUI_Vertex{p3.xy, tint, color, br, u32(Texture_Name.Sprite_Atlas)})
  d_push_vertex(D_GUI_Vertex{p4.xy, tint, color, bl, u32(Texture_Name.Sprite_Atlas)})
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
    tl, tr, br, bl := render.uv_from_rect(f32(res.textures[.Glyph_Atlas].width), 
                                          f32(res.textures[.Glyph_Atlas].height),
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

    d_push_vertex(D_GUI_Vertex{p1.xy, {1, 1, 1, 1}, color, tl, u32(Texture_Name.Glyph_Atlas)})
    d_push_vertex(D_GUI_Vertex{p2.xy, {1, 1, 1, 1}, color, tr, u32(Texture_Name.Glyph_Atlas)})
    d_push_vertex(D_GUI_Vertex{p3.xy, {1, 1, 1, 1}, color, br, u32(Texture_Name.Glyph_Atlas)})
    d_push_vertex(D_GUI_Vertex{p4.xy, {1, 1, 1, 1}, color, bl, u32(Texture_Name.Glyph_Atlas)})
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
        tl, tr, br, bl := render.uv_from_rect(f32(res.textures[.Glyph_Atlas].width), 
                                              f32(res.textures[.Glyph_Atlas].height),
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

        d_push_vertex(D_GUI_Vertex{p1.xy, {1, 1, 1, 1}, color, tl, u32(Texture_Name.Glyph_Atlas)})
        d_push_vertex(D_GUI_Vertex{p2.xy, {1, 1, 1, 1}, color, tr, u32(Texture_Name.Glyph_Atlas)})
        d_push_vertex(D_GUI_Vertex{p3.xy, {1, 1, 1, 1}, color, br, u32(Texture_Name.Glyph_Atlas)})
        d_push_vertex(D_GUI_Vertex{p4.xy, {1, 1, 1, 1}, color, bl, u32(Texture_Name.Glyph_Atlas)})
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

  render.transition_image(render.get_color_target(), .Color_Attachment)
  
  render.begin_pass({
    pipeline = res.pipelines[.GUI],
    color_attachments = {{
      image = render.get_color_target(),
      load_op = .None,
      store_op = .Store,
    }},
    // texture = i32(Texture_Name.Sprite_Atlas),
    // vertex_buf = d_st.vertex_buffer,
    index_buf = &d_st.sprite_index_buf,
    // camera = vmath.translation_3x3f({0, 0}),
    // projection = vmath.orthographic(0, window_size.x, 0, window_size.y),
    viewport = {0, 0, window_size.x, window_size.y},
    scissor = {0, 0, window_size.x, window_size.y},
    clear_color = {0, 0, 0, 0},
  })

  d_st.push_data.xform = vmath.IDENTITY_3X3F
  d_st.push_data.xform[1][1] *= -1
  d_st.push_data.xform *= vmath.orthographic(0, window_size.x, 0, window_size.y)
  d_st.push_data.light_color = 1
  d_st.push_data.vertex_buf = d_st.gui_vertex_buf.addr
  render.push_data(&d_st.push_data, size_of(d_st.push_data))

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

// Vulkan ////////////////////////////////////////////////////////////////////////////////

VK_State :: struct
{
  vertices:   [4]D_Sprite_Vertex,
  indices:    [6]u16,
  vertex_buf: render.Buffer,
  index_buf:  render.Buffer,
  textures:   [2]render.Image,
  pipeline:   render.Pipeline,
  push_data:  struct
  {
    xform:       m3x3f32,
    light_color: v4f32,
    vertex_buf:  u64,
  },
}

vk_init :: proc(st: ^VK_State)
{
  st.vertex_buf = render.create_buffer(.Storage, size_of(st.vertices))
  st.index_buf = render.create_buffer(.Index, size_of(st.indices))

  st.vertices = {
    {{  5,   5}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0}, 0},
    {{105,   5}, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 0}, 0},
    {{105, 105}, {1, 1, 1, 1}, {0, 0, 0, 0}, {1, 1}, 0},
    {{  5, 105}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 1}, 0},
  }
  render.write_buffer(st.vertex_buf, &st.vertices[0], size_of(st.vertices), 0)

  st.indices = {
    0, 1, 3,
    1, 2, 3,
  }
  render.write_buffer(st.index_buf, &st.indices[0], size_of(st.indices), 0)

  st.pipeline = render.create_graphics_pipeline({
    vert_shader_src = #load("shaders/out/shader.vert.spv"),
    frag_shader_src = #load("shaders/out/shader.frag.spv"),
    push_data_size = size_of(st.push_data),
    color_attachment_fmt = render.get_color_target().format,
    depth_test_en = false,
    stencil_test_en = false,
    blend_en = false,
  })
}

vk_render :: proc(st: ^VK_State)
{
  window_size := platform.window_get_size(&user.window)

  render.transition_image(render.get_color_target(), .Color_Attachment)

  render.begin_pass({
    pipeline = st.pipeline,
    index_buf = &st.index_buf,
    color_attachments = {{
      image = render.get_color_target(),
      load_op = .Clear,
      store_op = .Store,
    }},
    clear_color = {0.0, 0.0, 0.0, 1.0},
    viewport = user.viewport,
    scissor = {0, 0, window_size.x, window_size.y},
  })

  st.push_data.xform = vmath.IDENTITY_3X3F
  st.push_data.xform[1][1] *= -1
  st.push_data.xform *= vmath.orthographic(0, VIEWPORT_WIDTH, 0, VIEWPORT_HEIGHT)
  st.push_data.light_color = {1, 1, 1, 1}
  st.push_data.vertex_buf = st.vertex_buf.addr
  render.push_data(&st.push_data, size_of(st.push_data))

  render.draw_indexed(len(st.indices), 1, 0, 0)

  render.end_pass()
}
