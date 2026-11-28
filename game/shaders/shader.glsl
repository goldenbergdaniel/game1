#version 450
#extension GL_EXT_buffer_reference : require
#extension GL_EXT_scalar_block_layout : require
#extension GL_EXT_nonuniform_qualifier : require

// COMMON /////////////////////////////////////////////////////////////////////

struct Vertex
{
	vec2 position;
	vec4 tint;
	vec4 color;
  vec2 uv;
  uint tex;
};

layout(buffer_reference, scalar) 
readonly buffer Vertex_Buffer
{
	Vertex data[];
};

layout(push_constant, scalar)
uniform Push_Data
{
  mat3 xform;
  vec4 light_color;
  Vertex_Buffer vertex_buf;
} pd;

#ifdef VS /////////////////////////////////////////////////////////////////////

out VS_Out
{
  layout(location=0) vec4 tint;
  layout(location=1) vec4 color;
  layout(location=2) vec2 uv;
  layout(location=3) flat uint tex;
  layout(location=4) flat uint inst_idx;
} vout;

void main()
{
  Vertex vert = pd.vertex_buf.data[gl_VertexIndex];

  gl_Position = vec4(pd.xform * vec3(vert.position, 1.0), 1.0);
  vout.tint = vert.tint;
  vout.color = vert.color;
  vout.uv = vert.uv;
  vout.tex = vert.tex;
  vout.inst_idx = gl_InstanceIndex;
}

#endif
#ifdef FS /////////////////////////////////////////////////////////////////////

in VS_Out
{
  layout(location=0) vec4 tint;
  layout(location=1) vec4 color;
  layout(location=2) vec2 uv;
  layout(location=3) flat uint tex;
  layout(location=4) flat uint inst_idx;
} vout;

layout(set=0, binding=0) uniform sampler2D textures[];

layout(location=0) out vec4 frag_color;

void main()
{
  vec4 texel = texture(textures[nonuniformEXT(vout.tex)], vout.uv);

  frag_color = (texel + vout.color) * vout.tint * pd.light_color;
}

#endif
