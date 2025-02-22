#version 460 core

struct Vertex
{
  float position[2];
  float color[4];
  float uv[2];
};

layout(binding=0)
uniform ubo
{
  mat4 u_proj;
};

layout(binding=1) 
readonly buffer ssbo
{
  Vertex data[];
};

out vec4 fs_color;
out vec2 fs_tex_coord;

vec2 get_position()
{
  return vec2(
    data[gl_VertexID].position[0], 
    data[gl_VertexID].position[1]
  );
}

vec4 get_color()
{
  return vec4(
    data[gl_VertexID].color[0], 
    data[gl_VertexID].color[1], 
    data[gl_VertexID].color[2],
    data[gl_VertexID].color[3]
  );
}

vec2 get_uv()
{
  return vec2(
    data[gl_VertexID].uv[0],
    data[gl_VertexID].uv[1]
  );
}

void main()
{
  gl_Position = u_proj * vec4(get_position().xy, 1.0, 1.0);
  fs_color = get_color();
  fs_tex_coord = get_uv();
}
