package render

import "core:fmt"
import "core:os"

import vm "src:vecmath"
import plf "src:platform"
import gl "ext:opengl"
import "core:math/linalg/glsl"

@(private="file")
GL_Renderer :: struct
{
  vertices:     [40000]Vertex,
  vertex_count: u64,
  indices:      [60000]u16,
  index_count:  u64,
  projection:   m3x3f,
  texture:      ^Texture,
  uniforms: struct
  {
    proj:       m4x4f,
  },
  window:       ^plf.Window,
  shader:       u32,
  ubo:          u32,
  ssbo:         u32,
  ibo:          u32,
}

@(private)
renderer: GL_Renderer

gl_init_renderer :: proc(window: ^plf.Window)
{
  renderer.window = window

  // - Vertex array object ---
  vao: u32
  gl.GenVertexArrays(1, &vao)
  gl.BindVertexArray(vao)

  // - Create shader program ---
  {
    vs_source := #load("shaders/triangle.vs")
    vs := gl.CreateShader(gl.VERTEX_SHADER)
    gl.ShaderSource(vs, 1, cast([^]cstring) &vs_source, nil)
    gl.CompileShader(vs)
    when ODIN_DEBUG
    {
      gl_verify_shader(vs, gl.COMPILE_STATUS)
    }
    
    fs_source := #load("shaders/triangle.fs")
    fs := gl.CreateShader(gl.FRAGMENT_SHADER)
    gl.ShaderSource(fs, 1, cast([^]cstring) &fs_source, nil)
    gl.CompileShader(fs)
    when ODIN_DEBUG
    {
      gl_verify_shader(fs, gl.COMPILE_STATUS)
    }

    renderer.shader = gl.CreateProgram()
    gl.AttachShader(renderer.shader, vs)
    gl.AttachShader(renderer.shader, fs)
    gl.LinkProgram(renderer.shader)
    when ODIN_DEBUG
    {
      // gl_verify_shader(renderer.shader, gl.LINK_STATUS)
    }

    gl.DeleteShader(vs)
    gl.DeleteShader(fs)
  }

  // - Uniform buffer ---
  gl.CreateBuffers(1, &renderer.ubo)
  gl.UniformBlockBinding(renderer.shader, 0, 0)
  gl.BindBufferBase(gl.UNIFORM_BUFFER, 0, renderer.ubo)
  gl.NamedBufferStorage(renderer.ubo, 
                        size_of(renderer.uniforms),
                        &renderer.uniforms, 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Storage buffer ---
  gl.CreateBuffers(1, &renderer.ssbo)
  gl.BindBufferBase(gl.SHADER_STORAGE_BUFFER, 1, renderer.ssbo)
  gl.NamedBufferStorage(renderer.ssbo, 
                        size_of(renderer.vertices),
                        &renderer.vertices[0], 
                        gl.DYNAMIC_STORAGE_BIT)
  gl.BindBuffer(gl.SHADER_STORAGE_BUFFER, 0)

  // - Index buffer ---
  gl.CreateBuffers(1, &renderer.ibo)
  gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, renderer.ibo)
  gl.NamedBufferData(renderer.ibo,
                     size_of(renderer.indices),
                     &renderer.indices[0],
                     gl.DYNAMIC_DRAW)
}

gl_clear :: proc()
{
  gl.ClearColor(1, 1, 1, 1)
  gl.Clear(gl.COLOR_BUFFER_BIT);
}

gl_flush :: proc()
{
  if renderer.vertex_count == 0 do return

  window_size := plf.window_size(renderer.window)

  renderer.projection = vm.orthographic_3x3(960 - f32(window_size.x), 
                                            960, 
                                            540 - f32(window_size.y), 
                                            540)

  gl.Viewport(0, 0, window_size.x, window_size.y)

  gl.NamedBufferSubData(renderer.ssbo,
                        0,
                        int(renderer.vertex_count * size_of(Vertex)),
                        &renderer.vertices[0])

  gl.NamedBufferSubData(renderer.ibo,
                        0,
                        int(renderer.index_count * size_of(u32)),
                        &renderer.indices[0])

  gl.UseProgram(renderer.shader)
  renderer.uniforms.proj = cast(m4x4f) renderer.projection
  gl.NamedBufferSubData(renderer.ubo,
                        0,
                        size_of(renderer.uniforms),
                        &renderer.uniforms)

  gl.DrawElements(gl.TRIANGLES, i32(renderer.index_count), gl.UNSIGNED_SHORT, nil)

  gl.UseProgram(0)

  renderer.vertex_count = 0
  renderer.index_count = 0
}

gl_verify_shader :: proc(id, type: u32)
{
  if (type == gl.LINK_STATUS)
  {
    gl.ValidateProgram(id);
  }

  success: i32 = 1;
  gl.GetShaderiv(id, type, &success);

  if (success != 1)
  {
    length: i32;
    gl.GetShaderiv(id, gl.INFO_LOG_LENGTH, &length);
    log: [1000]byte;
    gl.GetShaderInfoLog(id, length, &length, &log[0]);

    if (type == gl.COMPILE_STATUS)
    {
      fmt.eprintln("[ERROR]: Failed to compile shader!");
    }
    else
    {
      fmt.eprintln("[ERROR]: Failed to link shaders!");
    }

    fmt.eprintln(cast(string) log[:]);
    os.exit(1)
  }
}
