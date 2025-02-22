#version 460 core

uniform sampler2D u_tex;

in vec4 fs_tint;
in vec4 fs_color;
in vec2 fs_tex_coord;

out vec4 frag_color;

void main()
{
  vec4 tex_color = texture(u_tex, fs_tex_coord);
  frag_color = (tex_color * fs_tint) + fs_color;
}
