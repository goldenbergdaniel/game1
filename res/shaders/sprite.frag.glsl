#version 460 core

uniform sampler2D u_tex;
uniform vec4 u_light;

in vec4 v_tint;
in vec4 v_color;
in vec2 v_tex_coord;

out vec4 f_color;

void main()
{
  vec4 tex_color = texture(u_tex, v_tex_coord);
  f_color = (tex_color + v_color) * v_tint * u_light;
}
