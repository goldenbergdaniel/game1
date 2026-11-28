package render

import "core:log"
import "../basic/mem"
import "../platform"

BACKEND :: #config(RENDER_BACKEND, "vulkan")
#assert(BACKEND == "opengl" || BACKEND == "vulkan")

USE_MAILBOX          :: false
NUM_FRAMES_IN_FLIGHT :: 2
MAX_INSTANCES        :: 10000

v2f32   :: [2]f32
v4f32   :: [4]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

Command_Buffer :: struct #raw_union
{
  vk: VK_Command_Buffer,
}

Buffer :: struct
{
  data:    rawptr,
  addr:    u64,
  using _: struct #raw_union
  {
    gl:    GL_Buffer,
    vk:    VK_Buffer,
  },
}

Image :: struct
{
  width:   int,
  height:  int,
  format:  Image_Format,
  using _: struct #raw_union
  {
    gl:    GL_Image,
    vk:    VK_Image,
  },
}

Pipeline :: struct #raw_union
{
  gl: GL_Pipeline,
  vk: VK_Pipeline,
}

Graphics_Pipeline_Desc :: struct
{
  vert_shader_src:      []u8,
  frag_shader_src:      []u8,
  color_attachment_fmt: Image_Format,
  depth_attachment_fmt: Image_Format,
  push_data_size:       int,
  depth_test_en:        bool,
  stencil_test_en:      bool,
  blend_en:             bool,
  uniform_names:        []cstring, // NOTE(dg): OpenGL
}

Pass :: struct
{
  pipeline:          Pipeline,
  texture:           i32,
  vertex_buf:        Buffer,
  index_buf:         ^Buffer,
  color_attachments: [dynamic; 4]struct
  {
    image:           ^Image,
    load_op:         Image_Load_Op,
    store_op:        Image_Store_Op,
  },
  depth_attachment:  struct
  {
    image:           ^Image,
    load_op:         Image_Load_Op,
    store_op:        Image_Store_Op,
  },
  projection:        m3x3f32,
  camera:            m3x3f32,
  viewport:          v4f32,
  scissor:           v4f32,
  clear_color:       v4f32,
  light_color:       v4f32,
}

Image_State :: enum
{
  Nil,
  Acquired,
  Color_Attachment,
  Depth_Attachment,
  Fragment_Shader_Read,
  Transfer_Src,
  Transfer_Dst,
  Present,
}

Image_Format :: enum
{
  Undefined,
  A8_UNORM,
  B8G8R8A8_SRGB,
  R8G8B8A8_USCALED,
  R8G8B8A8_UINT,
  R8G8B8A8_SRGB,
  R8G8B8A8_UNORM,
  D16_UNORM_S8_UINT,
  D24_UNORM_S8_UINT,
  D32_SFLOAT_S8_UINT,
}

Image_Load_Op :: enum
{
  None,
  Load,
  Clear,
  Dont_Care,
}

Image_Store_Op :: enum
{
  None,
  Store,
  Dont_Care,
}

Bind_Point :: enum
{
  Graphics,
  Compute,
}

Renderer :: struct
{
  pass:        Pass,
  pass_open:   bool,
  initialized: bool,
  window:      ^platform.Window,
  frame_cmd:   Command_Buffer,
  perm_arena:  ^mem.Arena,
  frame_arena: ^mem.Arena,
}

renderer: Renderer

init_device :: proc(window: ^platform.Window, perm_arena, frame_arena: ^mem.Arena)
{
  renderer.window = window
  renderer.perm_arena = perm_arena
  renderer.frame_arena = frame_arena

  when BACKEND == "opengl"
  {
    gl_init_device(window)
  }
  else when BACKEND == "vulkan"
  {
    vk_init_device(window)
  }
}

init_renderer :: proc(textures: []Image)
{
  when BACKEND == "opengl"
  {
    gl_init_renderer()
  }
  else when BACKEND == "vulkan"
  {
    vk_init_renderer(textures)
  }

  renderer.initialized = true
}

recreate_swapchain :: proc()
{
  when BACKEND == "vulkan"
  {
    vk_recreate_swapchain()
  }
}

@(require_results)
create_buffer :: proc(kind: enum{Storage, Index}, size: uint) -> Buffer
{
  result: Buffer

  when BACKEND == "opengl"
  {
    result.gl = gl_create_buffer(int(size), kind, 0)
  }
  else when BACKEND == "vulkan"
  {
    if kind == .Storage
    {
      result.vk = vk_create_buffer(size, 
                                   {.STORAGE_BUFFER, .SHADER_DEVICE_ADDRESS},
                                   {.HOST_VISIBLE, .HOST_COHERENT})
    }
    else if kind == .Index
    {
      result.vk = vk_create_buffer(size,
                                   {.INDEX_BUFFER},
                                   {.HOST_VISIBLE, .HOST_COHERENT})
    }

    result.data = result.vk.data
    result.addr = cast(u64) result.vk.address
  }

  return result
}

write_buffer :: proc(buffer: Buffer, data: rawptr, size, offset: int)
{
  when BACKEND == "opengl"
  {
    gl_write_buffer(buffer.gl, data, size, offset)
  }
  else when BACKEND == "vulkan"
  {
    mem.copy(buffer.data, rawptr(uintptr(data) + uintptr(offset)), size)
  }
}

@(require_results)
create_texture :: proc(data: []byte, width, height: int, format: Image_Format) -> Image
{
  result: Image
  result.width = width
  result.height = height
  result.format = format

  when BACKEND == "opengl"
  {
    image_format := 4 if format == .R8G8B8A8_SRGB else 1 if format == .R8_SRGB else 0
    result.gl = gl_create_texture(data, i32(width), i32(height), image_format)
  }
  else when BACKEND == "vulkan"
  {
    result.vk = vk_create_texture(data, u32(width), u32(height), vk_image_format_from_base(format))
  }
  
  return result
}

@(require_results)
create_graphics_pipeline :: proc(desc: Graphics_Pipeline_Desc) -> Pipeline
{
  result: Pipeline

  when BACKEND == "opengl"
  {
    result.gl = gl_create_pipeline(desc)
  }
  else when BACKEND == "vulkan"
  {
    result.vk = vk_create_graphics_pipeline(desc)
  }

  return result
}

draw :: proc(vertex_count, instance_count, first_vertex, first_instance: uint)
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if !renderer.pass_open do log.panic("[render]: No active render pass!\n")
  
  when BACKEND == "opengl"
  {
    gl_draw(count)
  }
  else when BACKEND == "vulkan"
  {
    vk_draw(vertex_count, instance_count, first_vertex, first_instance)
  }
}

draw_indexed :: proc(index_count, instance_count, first_index, first_instance: uint)
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if !renderer.pass_open do log.panic("[render]: No active render pass!\n")

  when BACKEND == "vulkan"
  {
    vk_draw_indexed(index_count, instance_count, first_index, first_instance)
  }
}

begin_frame :: proc()
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")

  when BACKEND == "vulkan"
  {
    renderer.frame_cmd.vk = vk_begin_frame(renderer.frame_arena)
  }
}

end_frame :: proc()
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")

  when BACKEND == "vulkan"
  {
    vk_end_frame()
  }

  mem.arena_clear(renderer.frame_arena)
}

begin_pass :: proc(pass: Pass)
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if renderer.pass_open do log.panic("[render]: Render pass is already open!\n")

  renderer.pass_open = true
  renderer.pass = pass

  if pass.light_color.a == 0
  {
    renderer.pass.light_color = {1, 1, 1, 1}
  }

  when BACKEND == "opengl"
  {
    if pass.clear_color.a > 0
    {
      gl_clear(pass.clear_color)
    }
  }
  else when BACKEND == "vulkan"
  {
    vk_begin_pass(renderer.pass)
  }
}

end_pass :: proc()
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if !renderer.pass_open do log.panic("[render]: Render pass is already closed!\n")

  renderer.pass = {}
  renderer.pass_open = false

  when BACKEND == "vulkan"
  {
    vk_end_pass()
  }
}

get_pass :: proc() -> ^Pass
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if !renderer.pass_open do log.panic("[render]: No active render pass!\n")

  return &renderer.pass
}

get_color_target :: proc() -> ^Image
{
  image: ^Image

  when BACKEND == "vulkan"
  {
    image = vk_get_color_target()
    image.format = vk_image_format_to_base(image.vk.format)
  }

  return image
}

get_depth_target :: proc() -> ^Image
{
  image: ^Image

  when BACKEND == "vulkan"
  {
    image = vk_get_depth_target()
  }

  return image
}

push_data :: proc(data: rawptr, size: int)
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")
  if !renderer.pass_open do log.panic("[render]: No active render pass!\n")

  when BACKEND == "vulkan"
  {
    vk_push_data(data, size, 0)
  }
}

transition_image :: proc(image: ^Image, state: Image_State)
{
  if !renderer.initialized do log.panic("[render]: Renderer is not initialized!\n")

  when BACKEND == "vulkan"
  {
    vk_transition_image(renderer.frame_cmd.vk, &image.vk, state)
  }
}

uv_from_rect :: proc(width, height: f32, coord, size: v2f32) -> (tl, tr, br, bl: v2f32)
{
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
