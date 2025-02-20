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

@(private)
sg_renderer: SG_Renderer

sg_init_renderer :: proc(window: ^plf.Window)
{
  ctx := context

  sg.setup({
    allocator = glue_allocator(&ctx),
    logger = glue_logger(&ctx),
    environment = glue_environment(),
  })

  sg_renderer.window = window

  sg_renderer.bindings.vertex_buffers[0] = sg.make_buffer(sg.Buffer_Desc{
    type = .VERTEXBUFFER,
    usage = .DYNAMIC, 
    size = u64(size_of(sg_renderer.vertices)),
  })

  sg_renderer.bindings.index_buffer = sg.make_buffer(sg.Buffer_Desc{
    type = .INDEXBUFFER,
    usage = .DYNAMIC,
    size = u64(size_of(sg_renderer.indices)),
  })

  sg_renderer.pipeline = sg.make_pipeline(sg.Pipeline_Desc{
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

  sg_renderer.pass_action = sg.Pass_Action{
    colors = {
      0 = {
        load_action = .CLEAR,
        clear_value = {1, 1, 1, 1},
      },
    },
  }
}

sg_flush :: proc()
{
  if sg_renderer.vertex_count == 0 do return

  window_size := plf.window_size(sg_renderer.window)

  sg_renderer.projection = vm.orthographic_3x3(960 - f32(window_size.x), 
                                            960, 
                                            540 - f32(window_size.y), 
                                            540)

  sg.begin_pass(sg.Pass{
    action = sg_renderer.pass_action,
    swapchain = glue_swapchain(sg_renderer.window, window_size),
  })

  sg.apply_viewport(0, 0, window_size.x, window_size.y, origin_top_left=true)

  sg.apply_pipeline(sg_renderer.pipeline)

  sg.update_buffer(sg_renderer.bindings.vertex_buffers[0], 
                  sg.Range{&sg_renderer.vertices, sg_renderer.vertex_count * size_of(Vertex)})

  sg.update_buffer(sg_renderer.bindings.index_buffer,
                  sg.Range{&sg_renderer.indices, sg_renderer.index_count * size_of(u16)})
  
  sg.apply_bindings(sg_renderer.bindings)
  
  sg_renderer.uniforms.proj = cast(m4x4f) sg_renderer.projection
  sg.apply_uniforms(UB_params, 
                    sg.Range{&sg_renderer.uniforms, size_of(sg_renderer.uniforms)})

  sg.draw(0, sg_renderer.index_count, 1)
  sg.end_pass()
  sg.commit()

  sg_renderer.vertex_count = 0
  sg_renderer.index_count = 0
}
