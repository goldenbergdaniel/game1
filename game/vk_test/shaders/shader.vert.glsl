#version 450
#pragma shader_stage(vertex)
#extension GL_EXT_buffer_reference : require

struct Vertex
{
	vec4 position;
	vec4 color;
}; 

layout(location=0) out vec4 v_color;

layout(buffer_reference, std430) readonly buffer Vertex_Buffer
{
	Vertex vertices[];
};

layout(push_constant) uniform Push_Constants
{
  Vertex_Buffer vertex_buf;
} constants;

void main()
{
  Vertex vertex = constants.vertex_buf.vertices[gl_VertexIndex];

  gl_Position = vec4(vertex.position.xy, 0, 1);
  v_color = vertex.color;
}
