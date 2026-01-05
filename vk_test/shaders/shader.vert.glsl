#version 450
#pragma shader_stage(vertex)
#extension GL_EXT_buffer_reference : require
// #extension GL_EXT_scalar_block_layout : require

struct Vertex
{
	vec3 position;
	vec4 color;
  vec2 uv;
};

layout(set=0, binding=0) 
readonly uniform Uniform_Buffer
{
  vec4 light;
} uniforms;

layout(buffer_reference, std430) 
readonly buffer Vertex_Buffer
{
	Vertex vertices[];
};

layout(push_constant, std430) 
uniform Push_Constants
{
  mat4 transform;
  Vertex_Buffer vertex_buf;
} constants;

layout(location=0) out vec4 v_color;
layout(location=1) out vec2 v_uv;
layout(location=2) out vec4 v_light;

void main()
{
  Vertex vertex = constants.vertex_buf.vertices[gl_VertexIndex];

  gl_Position = constants.transform * vec4(vertex.position, 1);
  v_color = vertex.color;
  v_uv = vertex.uv;
  v_light = uniforms.light;
}
