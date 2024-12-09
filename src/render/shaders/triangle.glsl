@header #+vet !cast
@header package draw_generated
@header import sg "ext:sokol/gfx"

@vs vs
in vec2 position;
in vec4 color;

out vec4 f_color;

void main()
{
  gl_Position = vec4(position.xy, 0, 1);
  f_color = color;
}
@end

@fs fs
in vec4 f_color;

out vec4 frag_color;

void main()
{
  frag_color = f_color;
}
@end

@program triangle vs fs
