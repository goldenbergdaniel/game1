#version 460 core

uniform sampler2D u_tex;
uniform sampler2D u_fnt;

in vec4 v_tint;
in vec4 v_color;
in flat uint v_tex;
in vec2 v_tex_coord;

out vec4 f_color;

void main()
{
  vec4 tex_color;
  switch (v_tex)
  {
  case 0:
    tex_color = texture(u_tex, v_tex_coord);
    break;
  case 1:
    tex_color = texture(u_fnt, v_tex_coord);
    break;
  }

  f_color = (tex_color + v_color) * v_tint;
}
