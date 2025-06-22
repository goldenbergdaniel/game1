package render

import "../platform"

when ODIN_OS == .Darwin  do BACKEND :: "metal"
when ODIN_OS == .Linux   do BACKEND :: "opengl"
when ODIN_OS == .Windows do BACKEND :: "dx11"

@(private="file")
BACKEND :: #config(RENDER_BACKEND, "opengl")

i32x2   :: [2]i32
i32x4   :: [4]i32
f32x2   :: [2]f32
f32x4   :: [4]f32
m3x3f32 :: matrix[3,3]f32
m4x4f32 :: matrix[4,4]f32

Vertex :: struct
{
  pos:   f32x2,
  tint:  f32x4,
  color: f32x4,
  uv:    f32x2,
}

Texture :: struct
{
  data:   []byte,
  width:  i32,
  height: i32,
  cell:   i32,
}

Texture_ID :: enum
{
  SPRITE_MAP,
}

when BACKEND == "opengl"
{
  @(private="file")
  renderer := &gl_renderer
}

init :: #force_inline proc(
  window: ^platform.Window, 
  projection: f32x4,
  textures: ^[Texture_ID]Texture,
){
  /**/ when BACKEND == "opengl" do gl_init(window, projection, textures)
  else                          do panic("Invalid render backend selected!")
}

clear :: #force_inline proc(color: f32x4)
{
  when BACKEND == "opengl" do gl_clear(color)
}

flush :: #force_inline proc()
{
  /**/ when BACKEND == "opengl" do gl_flush()
  else                          do panic("Invalid render backend selected!")
}

push_vertex :: proc{push_vertex_vert, push_vertex_vec}

push_vertex_vert :: proc(vertex: Vertex)
{
  if renderer.vertex_count == len(renderer.vertices)
  {
    flush()
  }

  renderer.vertices[renderer.vertex_count] = Vertex{
    pos = vertex.pos,
    tint = vertex.tint,
    color = vertex.color,
    uv = vertex.uv,
  }

  renderer.vertex_count += 1
}

push_vertex_vec :: proc(pos: f32x2, tint: f32x4, color: f32x4, uv: f32x2)
{
  push_vertex_vert(Vertex{pos, tint, color, uv})
}

push_tri_indices :: proc()
{
  @(static)
  layout: [3]u16 = {
    0, 1, 2,
  }

  offset := cast(u16) renderer.vertex_count - 3
  index_count := renderer.index_count + 3
  renderer.index_count += 3

  renderer.indices[index_count - 3] = layout[0] + offset
  renderer.indices[index_count - 2] = layout[1] + offset
  renderer.indices[index_count - 1] = layout[2] + offset
}

push_rect_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3,
    1, 2, 3,
  }

  offset := cast(u16) renderer.vertex_count - 4
  index_count := renderer.index_count + 6
  renderer.index_count += 6

  renderer.indices[index_count - 6] = layout[0] + offset
  renderer.indices[index_count - 5] = layout[1] + offset
  renderer.indices[index_count - 4] = layout[2] + offset
  renderer.indices[index_count - 3] = layout[3] + offset
  renderer.indices[index_count - 2] = layout[4] + offset
  renderer.indices[index_count - 1] = layout[5] + offset
}

coords_from_texture :: proc(texture: ^Texture, coords, grid: f32x2) -> (tl, tr, br, bl: f32x2)
{
  cell := cast(f32) texture.cell
  width := cast(f32) texture.width
  height := cast(f32) texture.height

  tl = f32x2{
    (f32(coords.x) * cell) / width, 
    (f32(coords.y) * cell) / height,
  }

  tr = f32x2{
    (f32(coords.x+(grid.x)) * cell) / width, 
    (f32(coords.y) * cell) / height,
  }

  br = f32x2{
    (f32(coords.x+(grid.x)) * cell) / width, 
    (f32(coords.y+(grid.y)) * cell) / height,
  }

  bl = f32x2{
    (f32(coords.x) * cell) / width, 
    (f32(coords.y+(grid.y)) * cell) / height,
  }

  return
}

set_viewport :: #force_inline proc(viewport: i32x4)
{
  renderer.viewport = viewport
}

set_camera :: #force_inline proc(camera: m3x3f32)
{
  renderer.camera = camera
}
