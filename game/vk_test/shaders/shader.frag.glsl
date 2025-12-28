#version 450
#pragma shader_stage(fragment)

layout(location=0) in vec4 v_color;
layout(location=1) flat in vec4 v_light;

layout(location=0) out vec4 f_color;

void main()
{
  f_color = v_color * v_light;
}
