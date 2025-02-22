package render

import plf "src:platform"

v2i   :: [2]i32
v4i   :: [4]i32
v2f   :: [2]f32
v4f   :: [4]f32
m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

Vertex :: struct
{
  pos:   v2f,
  tint:  v4f,
  color: v4f,
  uv:    v2f,
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
  SPRITE_ATLAS,
}

@(private="file")
BACKEND :: #config(RENDER_BACKEND, "opengl")

when BACKEND == "opengl"
{
  @(private="file")
  renderer := &gl_renderer
}

init :: #force_inline proc(window: ^plf.Window, textures: ^[Texture_ID]Texture)
{
  /**/ when BACKEND == "opengl" do gl_init(window, textures)
  else                          do panic("Invalid render backend selected!")
}

clear :: #force_inline proc(color: v4f)
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

push_vertex_vec :: proc(pos: v2f, tint: v4f, color: v4f, uv: v2f)
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

coords_from_texture :: proc(
  texture: ^Texture,
  coords:  v2i,
) -> (
  tl, tr, br, bl: v2f,
)
{
  cell := cast(f32) texture.cell
  width := cast(f32) texture.width
  height := cast(f32) texture.height

  tl = v2f{
    (f32(coords.x+0) * cell) / width, 
    (f32(coords.y+0) * cell) / height,
  }

  tr = v2f{
    (f32(coords.x+1) * cell) / width, 
    (f32(coords.y+0) * cell) / height,
  }

  br = v2f{
    (f32(coords.x+1) * cell) / width, 
    (f32(coords.y+1) * cell) / height,
  }

  bl = v2f{
    (f32(coords.x+0) * cell) / width, 
    (f32(coords.y+1) * cell) / height,
  }

  return
}
