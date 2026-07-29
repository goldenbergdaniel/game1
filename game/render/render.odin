package render

import "../platform"

BACKEND :: #config(RENDER_BACKEND, "opengl")

MAX_SHADERS  :: 8
MAX_TEXTURES :: 8

v2f32   :: [2]f32
v4f32   :: [4]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

Vertex :: struct
{
  pos:   v2f32,
  tint:  v4f32,
  color: v4f32,
  uv:    v2f32,
  tex:   u32,
}

Shader :: struct
{
  id:       u32,
  uniforms: map[cstring]i32,
}

Texture :: struct
{
  id:     u32,
  pixels: []byte,
  width:  i32,
  height: i32,
}

Pass :: struct
{
  shader:      ^Shader,
  projection:  m3x3f32,
  camera:      m3x3f32,
  viewport:    v4f32,
  clear_color: v4f32,
  light_color: v4f32,
}

Renderer :: struct
{
  initialized:    bool,
  window:         ^platform.Window,
  shaders:        [MAX_SHADERS]u32,
  shaders_count:  int,
  textures:       [MAX_TEXTURES]u32,
  textures_count: int,
  vertices:       [40000]Vertex,
  vertices_count: int,
  indices:        [60000]u16,
  indices_count:  int,
  pass:           Pass,
  pass_open:      bool,
  uniforms:       struct
  {
    projection:   m4x4f32,
    camera:       m4x4f32,
  },
  ubo:            u32,
  ssbo:           u32,
  ibo:            u32,
}

renderer: ^Renderer = &{}

init_renderer :: #force_inline proc(window: ^platform.Window)
{
  renderer.window = window
  
  /**/ when BACKEND == "opengl" do gl_init(window)
  else when BACKEND == "vulkan" do vk_test(window)
  else                          do panic("Fatal [render]: Invalid backend selected!")

  renderer.initialized = true
}

create_shader :: #force_inline proc(vsrc, fsrc: string, uniforms: []cstring) -> Shader
{
  /**/ when BACKEND == "opengl" do return gl_create_shader(vsrc, fsrc, uniforms)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

create_texture :: #force_inline proc(data: []byte, width, height: int, format := 4) -> Texture
{
  /**/ when BACKEND == "opengl" do return gl_create_texture(data, i32(width), i32(height), format)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

clear :: #force_inline proc(color: v4f32)
{
  when BACKEND == "opengl" do gl_clear(color)
}

draw :: #force_inline proc()
{
  when BACKEND == "opengl" do gl_draw()
}

begin_pass :: proc(pass: Pass)
{
  if !renderer.initialized do panic("Fatal [render]: Renderer is not initialized!")
  if renderer.pass_open do panic("Fatal [render]: Render pass is already open!")

  // assert(pass.shader != nil && pass.texture != nil)

  renderer.pass = pass
  renderer.pass_open = true
  
  if pass.clear_color.a > 0
  {
    clear(pass.clear_color)
  }

  if pass.light_color.a == 0
  {
    renderer.pass.light_color = {1, 1, 1, 1}
  }
}

end_pass :: proc()
{
  if !renderer.initialized do panic("Fatal [render]: Renderer is not initialized!")
  if !renderer.pass_open do panic("Fatal [render]: Render pass is already closed!")

  draw()

  renderer.pass = {}
  renderer.pass_open = false
  renderer.vertices_count = 0
}

get_pass :: proc() -> ^Pass
{
  if !renderer.initialized do panic("Fatal [render]: Renderer is not initialized!")
  if !renderer.pass_open do panic("Fatal [render]: No active render pass!")

  return &renderer.pass
}

push_vertex :: proc(vertex: Vertex)
{
  if renderer.vertices_count == len(renderer.vertices)
  {
    draw()
  }

  renderer.vertices[renderer.vertices_count] = vertex
  renderer.vertices_count += 1
}

push_triangle :: proc(v: [3]Vertex)
{
  push_vertex(v[0])
  push_vertex(v[1])
  push_vertex(v[2])
  push_triangle_indices()
}

push_rectangle :: proc(v: [4]Vertex)
{
  push_vertex(v[0])
  push_vertex(v[1])
  push_vertex(v[2])
  push_vertex(v[3])
  push_rectangle_indices()
}

push_triangle_indices :: proc()
{
  @(static)
  layout: [3]u16 = {
    0, 1, 2,
  }

  offset := cast(u16) renderer.vertices_count - 3
  index_count := renderer.indices_count + 3
  renderer.indices_count += 3

  renderer.indices[index_count - 3] = layout[0] + offset
  renderer.indices[index_count - 2] = layout[1] + offset
  renderer.indices[index_count - 1] = layout[2] + offset
}

push_rectangle_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3,
    1, 2, 3,
  }

  offset := cast(u16) renderer.vertices_count - 4
  index_count := renderer.indices_count + 6
  renderer.indices_count += 6

  renderer.indices[index_count - 6] = layout[0] + offset
  renderer.indices[index_count - 5] = layout[1] + offset
  renderer.indices[index_count - 4] = layout[2] + offset
  renderer.indices[index_count - 3] = layout[3] + offset
  renderer.indices[index_count - 2] = layout[4] + offset
  renderer.indices[index_count - 1] = layout[5] + offset
}

uv_from_texture :: proc(texture: ^Texture, coord, size: v2f32) -> (tl, tr, br, bl: v2f32)
{
  width := cast(f32) texture.width
  height := cast(f32) texture.height

  tl = {
    coord.x / width, 
    coord.y / height,
  }

  tr = {
    (coord.x + size.x) / width, 
    coord.y / height,
  }

  br = {
    (coord.x + size.x) / width, 
    (coord.y + size.y) / height,
  }

  bl = {
    coord.x / width, 
    (coord.y + size.y) / height,
  }

  return
}
