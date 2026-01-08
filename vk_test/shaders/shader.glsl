#version 450
#extension GL_EXT_buffer_reference : require

layout(set=0, binding=0) 
readonly uniform Uniform_Buffer
{
  vec4 light;
} uniforms;

#ifdef VS /////////////////////////////////////////////////////////////////////

struct Vertex
{
	vec3 position;
	vec4 color;
	vec4 tint;
  vec2 uv;
};

layout(buffer_reference) 
readonly buffer Vertex_Buffer
{
	Vertex vertices[];
};

layout(push_constant) 
uniform Push_Constants
{
  mat4 transform;
  Vertex_Buffer vertex_buf;
} constants;

layout(location=0) out vec4 v_color;
layout(location=1) out vec4 v_tint;
layout(location=2) out vec2 v_uv;

void main()
{
  Vertex vertex = constants.vertex_buf.vertices[gl_VertexIndex];

  vec4 pos = constants.transform * vec4(vertex.position, 1);
  // pos.z = -pos.z;

  gl_Position = pos;
  v_color = vertex.color;
  v_tint = vertex.tint;
  v_uv = vertex.uv;
}

#endif
#ifdef FS /////////////////////////////////////////////////////////////////////

layout(location=0) in vec4 v_color;
layout(location=1) in vec4 v_tint;
layout(location=2) in vec2 v_uv;

layout(set=0, binding=1) uniform sampler2D u_texture;

layout(location=0) out vec4 f_color;

void main()
{
  if (v_color.a != 0)
  {
    f_color = v_color * uniforms.light;
  }
  else
  {
    vec4 texel = texture(u_texture, v_uv);
    f_color = texel * v_tint * uniforms.light;
  }
}

#endif
