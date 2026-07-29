#version 460 core

struct Vertex
{
  float position[2];
  float tint[4];
  float color[4];
  float uv[2];
  uint tex;
};

layout(binding=0)
uniform ubo
{
  mat4 u_projection;
  mat4 u_camera;
};

layout(binding=1) 
readonly buffer ssbo
{
  Vertex vertices[];
};

out vec4 v_tint;
out vec4 v_color;
out uint v_tex;
out vec2 v_tex_coord;

void main()
{
  vec2 position = vec2(
    vertices[gl_VertexID].position[0], 
    vertices[gl_VertexID].position[1]
  );

  gl_Position = u_projection * u_camera * vec4(position.xy, 1.0, 1.0);

  v_tint = vec4(
    vertices[gl_VertexID].tint[0], 
    vertices[gl_VertexID].tint[1], 
    vertices[gl_VertexID].tint[2],
    vertices[gl_VertexID].tint[3]
  );

  v_color = vec4(
    vertices[gl_VertexID].color[0], 
    vertices[gl_VertexID].color[1], 
    vertices[gl_VertexID].color[2],
    vertices[gl_VertexID].color[3]
  );
  
  v_tex_coord = vec2(
    vertices[gl_VertexID].uv[0],
    vertices[gl_VertexID].uv[1]
  );

  v_tex = vertices[gl_VertexID].tex;
}
