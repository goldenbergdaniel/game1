package render

import "core:log"
import "core:math"

import plf "src:platform"
import vm "src:vecmath"
import sg "ext:sokol/gfx"

@(private="file")
SG_Renderer :: struct
{
  vertices:     [40000]Vertex,
  vertex_count: u64,
  indices:      [60000]u16,
  index_count:  u64,
  projection:   m3x3f,
  texture:      ^Texture,
  uniforms: struct
  {
    proj:       m4x4f,
  },
  bindings:     sg.Bindings,
  pipeline:     sg.Pipeline,
  pass_action:  sg.Pass_Action,
  window:       ^plf.Window,
}

@(private="file")
renderer: SG_Renderer

sg_init_renderer :: proc(window: ^plf.Window)
{
  ctx := context

  sg.setup({
    allocator = glue_allocator(&ctx),
    logger = glue_logger(&ctx),
    environment = glue_environment(),
  })

  renderer.window = window

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
    shader = sg.make_shader(triangle_shader_desc(BACKEND)),
    layout = {
      attrs = {
        ATTR_triangle_position = {format = .FLOAT2},
        ATTR_triangle_color    = {format = .FLOAT4},
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

sg_flush :: proc()
{
  if renderer.vertex_count == 0 do return

  window_size := plf.window_size(renderer.window)

  renderer.projection = vm.orthographic_3x3(960 - f32(window_size.x), 
                                            960, 
                                            540 - f32(window_size.y), 
                                            540)

  sg.begin_pass(sg.Pass{
    action = renderer.pass_action,
    swapchain = glue_swapchain(renderer.window, window_size),
  })

  sg.apply_viewport(0, 0, window_size.x, window_size.y, origin_top_left=true)

  sg.apply_pipeline(renderer.pipeline)

  sg.update_buffer(renderer.bindings.vertex_buffers[0], 
                  sg.Range{&renderer.vertices, renderer.vertex_count * size_of(Vertex)})

  sg.update_buffer(renderer.bindings.index_buffer,
                  sg.Range{&renderer.indices, renderer.index_count * size_of(u16)})
  
  sg.apply_bindings(renderer.bindings)
  
  renderer.uniforms.proj = cast(m4x4f) renderer.projection
  sg.apply_uniforms(UB_params, 
                    sg.Range{&renderer.uniforms, size_of(&renderer.uniforms)})

  sg.draw(0, renderer.index_count, 1)
  sg.end_pass()
  sg.commit()

  renderer.vertex_count = 0
  renderer.index_count = 0
}
