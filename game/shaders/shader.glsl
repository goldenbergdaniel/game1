#version 450
#extension GL_EXT_buffer_reference : require

layout(set=0, binding=0) 
readonly uniform Uniform_Buffer
{
  mat4 transform;
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
  vec4 light_color;
  vec2 tiling;
  Vertex_Buffer vertex_buf;
} constants;

layout(location=0) out vec3 v_normal;
layout(location=1) out vec4 v_color;
layout(location=2) out vec2 v_uv;

void main()
{
  Vertex vertex = constants.vertex_buf.vertices[gl_VertexIndex];

  gl_Position = uniforms.transform * vec4(vertex.position, 1);
  v_normal = vertex.normal;
  v_color = vertex.color;
  v_uv = vertex.uv * constants.tiling;
}

#endif
#ifdef FS /////////////////////////////////////////////////////////////////////

layout(location=0) in vec3 v_normal;
layout(location=1) in vec4 v_color;
layout(location=2) in vec2 v_uv;

layout(set=0, binding=2) uniform sampler2D u_texture;

layout(location=0) out vec4 f_color;

const float ambient = 0.2;
const vec3 light_dir = {-0.5, 0, -0.5};

void main()
{
  vec4 texel = texture(u_texture, v_uv);

  float diffuse = 0.15 * dot(v_normal, light_dir);
  f_color = texel * (ambient + diffuse);
}

#endif
