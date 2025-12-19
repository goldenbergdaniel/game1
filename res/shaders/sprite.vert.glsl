#version 460 core

struct Vertex
{
  float position[2];
  float tint[4];
  float color[4];
  float uv[2];
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
out vec2 v_tex_coord;

vec2 get_position()
{
  return vec2(
    vertices[gl_VertexID].position[0], 
    vertices[gl_VertexID].position[1]
  );
}

vec4 get_tint()
{
  return vec4(
    vertices[gl_VertexID].tint[0], 
    vertices[gl_VertexID].tint[1], 
    vertices[gl_VertexID].tint[2],
    vertices[gl_VertexID].tint[3]
  );
}

vec4 get_color()
{
  return vec4(
    vertices[gl_VertexID].color[0], 
    vertices[gl_VertexID].color[1], 
    vertices[gl_VertexID].color[2],
    vertices[gl_VertexID].color[3]
  );
}

vec2 get_uv()
{
  return vec2(
    vertices[gl_VertexID].uv[0],
    vertices[gl_VertexID].uv[1]
  );
}

void main()
{
  gl_Position = u_projection * u_camera * vec4(get_position().xy, 1.0, 1.0);
  v_tint = get_tint();
  v_color = get_color();
  v_tex_coord = get_uv();
}
