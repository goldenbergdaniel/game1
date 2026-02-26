#version 450
#extension GL_EXT_buffer_reference : require

layout(set=0, binding=0) 
readonly uniform Uniform_Buffer
{
  vec4 light_color;
} uniforms;

#ifdef VS /////////////////////////////////////////////////////////////////////

struct Vertex
{
	vec3 position;
  vec3 normal;
	vec4 color;
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

layout(location=0) out vec3 v_normal;
layout(location=1) out vec4 v_color;
layout(location=2) out vec2 v_uv;

void main()
{
  Vertex vertex = constants.vertex_buf.vertices[gl_VertexIndex];

  gl_Position = constants.transform * vec4(vertex.position, 1);
  v_normal = vertex.normal;
  v_color = vertex.color;
  v_uv = vertex.uv;
}

#endif
#ifdef FS /////////////////////////////////////////////////////////////////////

layout(location=0) in vec3 v_normal;
layout(location=1) in vec4 v_color;
layout(location=2) in vec2 v_uv;

layout(set=0, binding=1) uniform sampler2D u_texture;

layout(location=0) out vec4 f_color;

const float ambient = 0.1;
const vec3 light_dir = {-0.5, -0.5, -0.5};

void main()
{
  // vec4 texel = texture(u_texture, v_uv);

  // if (v_color.a != 0)
  // {
  //   f_color = vec4(texel.rgb + v_color.rgb, texel.a) * uniforms.light_color;
  // }
  // else
  // {
  //   f_color = vec4(texel.rgb * v_color.rgb, texel.a) * uniforms.light_color;
  // }

  float diffuse = 0.15 * dot(v_normal, light_dir);
  f_color = v_color * (ambient + diffuse);
}

#endif
