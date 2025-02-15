package game

import "core:log"
import "core:math"

import plf "src:platform"
import r "src:render"
import vm "src:vecmath"
import sg "ext:sokol/gfx"

Vertex :: struct
{
  pos:   v2f,
  color: v4f,
}

Uniforms :: struct
{
  proj: m4x4,
}

Texture :: struct
{
  id:     u32,
  slot:   i32,
  width:  i32,
  height: i32,
}

Sprite :: struct
{
  uv:    v2i,
  dim:   v2i,
  pivot: v2f,
}

@(private="file")
Renderer :: struct
{
  vertices:     [40000]Vertex,
  vertex_count: u64,
  indices:      [60000]u16,
  index_count:  u64,
  projection:   m3x3,
  texture:      ^Texture,
  uniforms:     Uniforms,
  bindings:     sg.Bindings,
  pipeline:     sg.Pipeline,
  pass_action:  sg.Pass_Action,
}

@(private="file")
renderer: Renderer

draw_tri :: proc(
  pos:   v2f,
  dim:   v2f,
  color: v4f = {0, 0, 0, 0},
)
{
  r_push_vertex(pos + v2f{0, 0}, color)
  r_push_vertex(pos + v2f{-dim.x/2, dim.y}, color)
  r_push_vertex(pos + v2f{dim.x/2, dim.y}, color)
  r_push_tri_indices()
}

draw_rect :: proc(
  pos:    v2f,
  dim:    v2f,
  color:  v4f = {0, 0, 0, 0},
  sprite: Sprite = {},
)
{
  r_push_vertex(pos + v2f{0, 0}, color)
  r_push_vertex(pos + v2f{dim.x, 0}, color)
  r_push_vertex(pos + v2f{dim.x, dim.y}, color)
  r_push_vertex(pos + v2f{0, dim.y}, color)
  r_push_rect_indices()
}

r_init_renderer :: proc()
{
  ctx := context

  sg.setup({
    allocator = r.glue_allocator(&ctx),
    logger = r.glue_logger(&ctx),
    environment = r.glue_environment(),
  })

  renderer.bindings.vertex_buffers[0] = sg.make_buffer(sg.Buffer_Desc{
    type = .VERTEXBUFFER,
    usage = .DYNAMIC, 
    size = u64(size_of(renderer.vertices)),
  })

  renderer.bindings.index_buffer = sg.make_buffer(sg.Buffer_Desc{
    type = .INDEXBUFFER,
    usage = .DYNAMIC,
    size = u64(size_of(renderer.indices)),
  })

  renderer.pipeline = sg.make_pipeline(sg.Pipeline_Desc{
    primitive_type = .TRIANGLES,
    index_type = .UINT16,
    shader = sg.make_shader(r.triangle_shader_desc(r.BACKEND)),
    layout = {
      attrs = {
        r.ATTR_triangle_position = {format = .FLOAT2},
        r.ATTR_triangle_color    = {format = .FLOAT4},
      },
    },
  })

  renderer.pass_action = sg.Pass_Action{
    colors = {
      0 = {
        load_action = .CLEAR,
        clear_value = {0, 0, 0, 1},
      },
    },
  }
}

r_flush :: proc()
{
  if renderer.vertex_count == 0 do return

  window := &g_user.window
  window_size := plf.window_size(window)

  renderer.projection = vm.orthographic_3x3(WIDTH - f32(window_size.x), 
                                            WIDTH, 
                                            HEIGHT - f32(window_size.y), 
                                            HEIGHT)

  sg.begin_pass(sg.Pass{
    action = renderer.pass_action,
    swapchain = r.glue_swapchain(window, window_size),
  })

  sg.apply_viewport(0, 0, window_size.x, window_size.y, true)

  sg.apply_pipeline(renderer.pipeline)

  sg.update_buffer(renderer.bindings.vertex_buffers[0], 
                  sg.Range{&renderer.vertices, renderer.vertex_count * size_of(Vertex)})

  sg.update_buffer(renderer.bindings.index_buffer,
                  sg.Range{&renderer.indices, renderer.index_count * size_of(u16)})
  
  sg.apply_bindings(renderer.bindings)
  
  renderer.uniforms.proj = cast(vm.m4x4) renderer.projection
  sg.apply_uniforms(r.UB_params, sg.Range{&renderer.uniforms, size_of(Uniforms)})

  sg.draw(0, renderer.index_count, 1)
  sg.end_pass()
  sg.commit()

  renderer.vertex_count = 0
  renderer.index_count = 0
}

r_push_vertex :: proc{r_push_vertex_vert, r_push_vertex_vec}

r_push_vertex_vert :: proc(vertex: Vertex)
{
  if renderer.vertex_count == len(renderer.vertices)
  {
    r_flush()
  }

  renderer.vertices[renderer.vertex_count] = Vertex{
    pos = vertex.pos,
    color = vertex.color,
  }

  renderer.vertex_count += 1
}

r_push_vertex_vec :: proc(pos: v2f, color: v4f)
{
  r_push_vertex_vert(Vertex{pos, color})
}

r_push_tri_indices :: proc()
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

r_push_rect_indices :: proc()
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

r_uv_coords_for_texture :: proc(coords: [2]u16) -> (tl, tr, br, bl: v2f)
{
  size   :: 256
  cell   :: 16
  height :: 32

  tl = v2f{
    f32((coords.x+0) * size) / cell, 
    f32((coords.y+1) * size) / height,
  }

  tr = v2f{
    f32((coords.x+1) * size) / cell, 
    f32((coords.y+1) * size) / height,
  }

  br = v2f{
    f32((coords.x+1) * size) / cell, 
    f32((coords.y+0) * size) / height,
  }

  bl = v2f{
    f32((coords.x+0) * size) / cell, 
    f32((coords.y+0) * size) / height,
  }

  return
}
