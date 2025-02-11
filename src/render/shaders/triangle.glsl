@header #+vet !cast !style
@header package render
@header import sg "ext:sokol/gfx"

@vs vs

layout(binding=0) 
uniform params {
  mat4 proj;
};

in vec2 position;
in vec4 color;

out vec4 f_color;

void main()
{
  gl_Position = proj * vec4(position.xy, 1, 1);
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
