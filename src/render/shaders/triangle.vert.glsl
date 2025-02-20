#version 460 core

struct Vertex
{
  float position[2];
  float color[4];
};

layout(binding=0)
uniform ubo
{
  mat4 proj;
};

layout(binding=1) 
readonly buffer ssbo
{
  Vertex data[];
};

out vec4 fs_color;

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

void main()
{
  gl_Position = proj * vec4(get_position().xy, 1.0, 1.0);
  fs_color = get_color();
}
