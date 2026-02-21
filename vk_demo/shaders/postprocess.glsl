#version 450

#ifdef VS /////////////////////////////////////////////////////////////////////

layout(location=0) out vec2 v_uv;

struct Vertex
{
  vec4 position;
  vec2 uv;
};

const 
Vertex vertices[6] = {
  {{-1, -1, 1, 1}, {0, 0}},
  {{ 1, -1, 1, 1}, {1, 0}},
  {{-1,  1, 1, 1}, {0, 1}},

  {{ 1, -1, 1, 1}, {1, 0}},
  {{ 1,  1, 1, 1}, {1, 1}},
  {{-1,  1, 1, 1}, {0, 1}},
};

void main()
{
  gl_Position = vertices[gl_VertexIndex].position;
  v_uv = vertices[gl_VertexIndex].uv;
}

#endif
#ifdef FS /////////////////////////////////////////////////////////////////////

layout(location=0) in vec2 v_uv;

layout(set=0, binding=2) uniform sampler2D u_texture;

layout(push_constant, std430) uniform Push_Constants
{
  uint enabled;
} constants;

layout(location=0) out vec4 f_color;

void main()
{
  vec4 texel = texture(u_texture, v_uv);

  if (constants.enabled != 0)
  {
    if (texel.rgb == vec3(0, 0, 0))
    {
      f_color = vec4(1, 1, 1, 1);
    }
    else if (texel.rgb == vec3(1, 1, 1))
    {
      f_color = vec4(0, 0, 0, 1);
    }
    else
    {
      f_color = texel;
    }
  }
  else
  {
    f_color = texel;
  }
}

#endif
