#version 450
#pragma shader_stage(fragment)

layout(location=0) in vec4 v_color;
layout(location=1) in vec2 v_uv;
layout(location=2) flat in vec4 v_light;

layout(set=0, binding=1) uniform sampler2D u_texture;

layout(location=0) out vec4 f_color;

void main()
{
  vec4 texel = texture(u_texture, v_uv);
  f_color = texel * v_light;
}
