package game

import "core:fmt"
import "core:log"
import "core:math"

import r "src:render"
import vm "src:vecmath"
import sg "ext:sokol/gfx"

Vertex :: struct
{
  pos:   [2]f32,
  color: [4]f32,
}

Uniforms :: struct
{
  proj: vm.Mat4x4,
}

Shader :: struct
{
  id: u32,
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
  uv:    [2]u16,
  dim:   [2]u16,
  pivot: [2]f32,
}

@(private="file")
Renderer :: struct
{
  vertices:     [40000]Vertex,
  vertex_count: u64,
  indices:      [60000]u16,
  index_count:  u64,
  projection:   vm.Mat3x3,
  shader:       ^Shader,
  texture:      ^Texture,
  uniforms:     Uniforms,
  bindings:     sg.Bindings,
  pipeline:     sg.Pipeline,
  pass_action:  sg.Pass_Action,
}

g_renderer: Renderer

draw_tri :: proc(
  pos:   [2]f32,
  dim:   [2]f32,
  color: [4]f32 = {0, 0, 0, 0},
)
{
  r_push_vertex(pos + [2]f32{0, 0}, color)
  r_push_vertex(pos + [2]f32{0, 0}, color)
  r_push_vertex(pos + [2]f32{0, 0}, color)
  r_push_tri_indices()
}

draw_rect :: proc(
  pos:    [2]f32,
  dim:    [2]f32,
  color:  [4]f32 = {0, 0, 0, 0},
  sprite: Sprite = {},
)
{
  r_push_vertex(pos + [2]f32{0, 0}, color)
  r_push_vertex(pos + [2]f32{dim.x, 0}, color)
  r_push_vertex(pos + [2]f32{dim.x, dim.y}, color)
  r_push_vertex(pos + [2]f32{0, dim.y}, color)
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

  g_renderer.projection = vm.orthographic_3x3(0, WIDTH, 0, HEIGHT)

  g_renderer.bindings.vertex_buffers[0] = sg.make_buffer(sg.Buffer_Desc{
    type = .VERTEXBUFFER,
    usage = .DYNAMIC, 
    size = u64(size_of(g_renderer.vertices)),
  })

  g_renderer.bindings.index_buffer = sg.make_buffer(sg.Buffer_Desc{
    type = .INDEXBUFFER,
    usage = .DYNAMIC,
    size = u64(size_of(g_renderer.indices)),
  })

  g_renderer.pipeline = sg.make_pipeline(sg.Pipeline_Desc{
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

  g_renderer.pass_action = sg.Pass_Action{
    colors = {
      0 = {
        load_action = .CLEAR,
        clear_value = {1, 1, 1, 1},
      },
    },
  }
}

r_flush :: proc()
{
  if g_renderer.vertex_count == 0 do return

  window := &g_user.window

  sg.begin_pass(sg.Pass{
    action = g_renderer.pass_action,
    swapchain = r.glue_swapchain(window),
  })

  sg.apply_viewport(0, 0, i32(window.width), i32(window.height), true)

  sg.apply_pipeline(g_renderer.pipeline)

  sg.update_buffer(g_renderer.bindings.vertex_buffers[0], 
                  sg.Range{&g_renderer.vertices, g_renderer.vertex_count * size_of(Vertex)})

  sg.update_buffer(g_renderer.bindings.index_buffer,
                  sg.Range{&g_renderer.indices, g_renderer.index_count * size_of(u16)})
  
  sg.apply_bindings(g_renderer.bindings)
  
  g_renderer.uniforms.proj = cast(vm.Mat4x4) g_renderer.projection
  sg.apply_uniforms(r.UB_params, sg.Range{&g_renderer.uniforms, size_of(Uniforms)})

  sg.draw(0, g_renderer.index_count, 1)
  sg.end_pass()
  sg.commit()

  g_renderer.vertex_count = 0
  g_renderer.index_count = 0
}

r_push_vertex :: proc{r_push_vertex_vert, r_push_vertex_vec}

r_push_vertex_vert :: proc(vertex: Vertex)
{
  if g_renderer.vertex_count == len(g_renderer.vertices)
  {
    r_flush()
  }

  g_renderer.vertices[g_renderer.vertex_count] = Vertex{
    pos = vertex.pos,
    color = vertex.color,
  }

  g_renderer.vertex_count += 1
}

r_push_vertex_vec :: proc(pos: [2]f32, color: [4]f32)
{
  r_push_vertex_vert(Vertex{pos, color})
}

r_push_tri_indices :: proc()
{
  @(static)
  layout: [3]u16 = {
    0, 1, 2,
  }

  offset := cast(u16) g_renderer.vertex_count - 3
  index_count := g_renderer.index_count + 3
  g_renderer.index_count += 3

  g_renderer.indices[index_count - 3] = layout[0] + offset
  g_renderer.indices[index_count - 2] = layout[1] + offset
  g_renderer.indices[index_count - 1] = layout[2] + offset
}

r_push_rect_indices :: proc()
{
  @(static)
  layout: [6]u16 = {
    0, 1, 3,
    1, 2, 3,
  }

  offset := cast(u16) g_renderer.vertex_count - 4
  index_count := g_renderer.index_count + 6
  g_renderer.index_count += 6

  g_renderer.indices[index_count - 6] = layout[0] + offset
  g_renderer.indices[index_count - 5] = layout[1] + offset
  g_renderer.indices[index_count - 4] = layout[2] + offset
  g_renderer.indices[index_count - 3] = layout[3] + offset
  g_renderer.indices[index_count - 2] = layout[4] + offset
  g_renderer.indices[index_count - 1] = layout[5] + offset
}

r_uv_positions_for_texture :: proc(coords: [2]u16) -> (tl, tr, br, bl: [2]f32)
{
  size   :: 256
  cell   :: 16
  height :: 32

  tl = [2]f32{
    f32((coords.x+0) * size) / cell, 
    f32((coords.y+1) * size) / height,
  }

  tr = [2]f32{
    f32((coords.x+1) * size) / cell, 
    f32((coords.y+1) * size) / height,
  }

  br = [2]f32{
    f32((coords.x+1) * size) / cell, 
    f32((coords.y+0) * size) / height,
  }

  bl = [2]f32{
    f32((coords.x+0) * size) / cell, 
    f32((coords.y+0) * size) / height,
  }

  return
}
