#version 450
#pragma shader_stage(vertex)

layout(location=0) out vec2 v_uv;

struct Vertex
{
  vec4 position;
  vec2 uv;
};

const Vertex vertices[6] = {
  {{-1, -1, 1, 1}, {0, 0}},
  {{ 1, -1, 1, 1}, {1, 0}},
  {{-1,  1, 1, 1}, {0, 1}},

  {{ 1, -1, 1, 1}, {1, 0}},
  {{ 1,  1, 1, 1}, {1, 1}},
  {{-1,  1, 1, 1}, {0, 1}},
};

void main()
{
  gl_Position = vertices[gl_VertexIndex].position;
  v_uv = vertices[gl_VertexIndex].uv;
}
