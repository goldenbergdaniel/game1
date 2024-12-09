package render

import "src:render/shaders"
import vm "src:vecmath"
import plf "src:platform"
import sg "ext:sokol/gfx"

Vertex :: struct
{
  pos:   [2]f32,
  color: [4]f32,
}

Renderer :: struct
{
  vertices:    [40000]Vertex,
  vertex_cnt:  int,
  indices:     [10000]u16,
  index_cnt:   int,
  projection:  vm.Mat3x3,
  bindings:    sg.Bindings,
  pipeline:    sg.Pipeline,
  pass_action: sg.Pass_Action,
}

renderer: Renderer

setup_scratch :: proc()
{
  ctx := context
  sg.setup({
    allocator = glue_allocator(&ctx),
    logger = glue_logger(&ctx),
    environment = glue_environment(),
  })

  vertices := [3]Vertex{
    {{ 0.0,  0.5},  {1.0, 0.0, 0.0, 1.0}},
    {{ 0.5, -0.5},  {0.0, 1.0, 0.0, 1.0}},
    {{-0.5, -0.5},  {0.0, 0.0, 1.0, 1.0}},
  }

  renderer.bindings.vertex_buffers[0] = sg.make_buffer({
    type = .VERTEXBUFFER,
    data = {ptr = &vertices, size = size_of(vertices)},
  })

  renderer.pipeline = sg.make_pipeline({
    shader = sg.make_shader(shaders.triangle_shader_desc(BACKEND)),
    layout = {
      attrs = {
        shaders.ATTR_triangle_position = {format = .FLOAT2},
        shaders.ATTR_triangle_color    = {format = .FLOAT4},
      },
    },
  })

  renderer.pass_action = {
    colors = {
      0 = {
        load_action = .LOAD,
        clear_value = {0, 0, 0, 1},
      },
    },
  }
}

scratch :: proc(window: ^plf.Window)
{
  sg.begin_pass({
    action    = renderer.pass_action,
    swapchain = glue_swapchain(window),
  })
  sg.apply_pipeline(renderer.pipeline)
  sg.apply_bindings(renderer.bindings)
  sg.draw(0, 3, 1)
  sg.end_pass()
  sg.commit()

  plf.swap_buffers(window)
}
