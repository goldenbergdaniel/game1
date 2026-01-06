#version 450
#pragma shader_stage(fragment)

layout(location=0) in vec2 v_uv;

layout(set=0, binding=2) uniform sampler2D u_texture;

layout(push_constant, std430) uniform Push_Constants
{
  bool enabled;
} constants;

layout(location=0) out vec4 f_color;

void main()
{
  vec4 texel = texture(u_texture, v_uv);

  if (constants.enabled)
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
