package draw

import vm "src:vecmath"
import sg "ext:sokol/gfx"

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
