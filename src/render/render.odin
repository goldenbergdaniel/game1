package render

v2i   :: [2]i32
v4i   :: [4]i32
v2f   :: [2]f32
v4f   :: [4]f32
m3x3f :: matrix[3,3]f32
m4x4f :: matrix[4,4]f32

Vertex :: struct
{
  pos:   v2f,
  color: v4f,
}

Texture :: struct
{
  id:     u32,
  slot:   i32,
  cell:   i32,
  width:  i32,
  height: i32,
}

// BACKEND :: #config()

// push :: proc()
// {

// }

push_vertex :: proc{push_vertex_vert, push_vertex_vec}

push_vertex_vert :: proc(vertex: Vertex)
{
  if renderer.vertex_count == len(renderer.vertices)
  {
    gl_flush()
  }

  renderer.vertices[renderer.vertex_count] = Vertex{
    pos = vertex.pos,
    color = vertex.color,
  }

  renderer.vertex_count += 1
}

push_vertex_vec :: proc(pos: v2f, color: v4f)
{
  push_vertex_vert(Vertex{pos, color})
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
  coords:  [2]u16,
) -> (
  tl, tr, br, bl: v2f,
)
{
  size   := cast(f32) (texture.width * texture.height)
  cell   := cast(f32) texture.cell
  height := cast(f32) texture.height

  tl = v2f{
    (f32(coords.x+0) * size) / cell, 
    (f32(coords.y+1) * size) / height,
  }

  tr = v2f{
    (f32(coords.x+1) * size) / cell, 
    (f32(coords.y+1) * size) / height,
  }

  br = v2f{
    (f32(coords.x+1) * size) / cell, 
    (f32(coords.y+0) * size) / height,
  }

  bl = v2f{
    (f32(coords.x+0) * size) / cell, 
    (f32(coords.y+0) * size) / height,
  }

  return
}
