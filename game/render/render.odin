package render

import "../basic/mem"
import "../platform"

BACKEND :: #config(RENDER_BACKEND, "opengl")

v2f32   :: [2]f32
v4f32   :: [4]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

Buffer :: struct
{
  handle: u32,
}

Shader :: struct
{
  handle:   u32,
  uniforms: map[cstring]i32,
}

Texture :: struct
{
  handle: u32,
  unit:   u32,
  pixels: []byte,
  width:  i32,
  height: i32,
}

Pipeline :: struct
{
  shader:       Shader,
  uniforms:     struct
  {
    projection: m4x4f32,
    camera:     m4x4f32,
  },
  ubo:          u32,
  ubo_idx:      u32,
}

Pass :: struct
{
  pipeline:    Pipeline,
  texture:     i32,
  vertex_buf:  Buffer,
  index_buf:   Buffer,
  projection:  m3x3f32,
  camera:      m3x3f32,
  viewport:    v4f32,
  clear_color: v4f32,
  light_color: v4f32,
}

Image_State :: enum
{
  Undefined,
  Color_Attachment,
  Depth_Attachment,
  Fragment_Shader_Read,
  Transfer_Src,
  Transfer_Dst,
  Present,
}

Renderer :: struct
{
  initialized: bool,
  pass:        Pass,
  pass_open:   bool,
  vao:         u32,
  window:      ^platform.Window,
}

renderer: Renderer

init_renderer :: #force_inline proc(window: ^platform.Window, arena: ^mem.Arena)
{
  renderer.window = window
  
  /**/ when BACKEND == "opengl" do gl_init(window, arena)
  else                          do panic("Fatal [render]: Invalid backend selected!")

  renderer.initialized = true
}

create_shader :: #force_inline proc(vsrc, fsrc: string, uniforms: []cstring) -> Shader
{
  /**/ when BACKEND == "opengl" do return gl_create_shader(vsrc, fsrc, uniforms)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

create_buffer :: #force_inline proc(size: int, kind: enum{Vertex, Index}, binding: int) -> Buffer
{
  /**/ when BACKEND == "opengl" do return gl_create_buffer(size, kind, binding)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

write_buffer :: #force_inline proc(buffer: Buffer, data: rawptr, size: int, offset: int)
{
  /**/ when BACKEND == "opengl" do gl_write_buffer(buffer, data, size, offset)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

create_texture :: #force_inline proc(data: []byte, width, height: int, format := 4) -> Texture
{
  /**/ when BACKEND == "opengl" do return gl_create_texture(data, i32(width), i32(height), format)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

create_pipeline :: #force_inline proc(shader: Shader, arena: ^mem.Arena) -> Pipeline
{
  /**/ when BACKEND == "opengl" do return gl_create_pipeline(shader, arena)
  else                          do panic("Fatal [render]: Invalid backend selected!")
}

clear :: #force_inline proc(color: v4f32)
{
  when BACKEND == "opengl" do gl_clear(color)
}

draw :: #force_inline proc(count: int)
{
  when BACKEND == "opengl" do gl_draw(count)
}

begin_pass :: proc(pass: Pass)
{
  if !renderer.initialized do panic("Fatal [render]: Renderer is not initialized!")
  if renderer.pass_open do panic("Fatal [render]: Render pass is already open!")

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

  renderer.pass = {}
  renderer.pass_open = false
}

get_pass :: proc() -> ^Pass
{
  if !renderer.initialized do panic("Fatal [render]: Renderer is not initialized!")
  if !renderer.pass_open do panic("Fatal [render]: No active render pass!")

  return &renderer.pass
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
