#+build linux, windows
#+private
package render

import "core:fmt"
import "core:log"
import "core:os"
import gl "ext:opengl"
import "../basic/mem"
import "../platform"

GL_Buffer :: struct
{
  handle: u32,
}

GL_Image :: struct
{
  handle: u32,
  unit:   u32,
}

GL_Shader :: struct
{
  handle:   u32,
  uniforms: map[cstring]i32,
}

GL_Pipeline :: struct
{
  shader:       GL_Shader,
  uniforms:     struct
  {
    projection: m4x4f32,
    camera:     m4x4f32,
  },
  ubo:          u32,
  ubo_idx:      u32,
}

@(private="file")
g: struct
{
  vao: u32,
}

gl_init_device :: proc()
{
  gl.load_up_to(4, 6, platform.gl_set_proc_address)
}

gl_init_renderer :: proc()
{
  // - Features ---
  gl.Disable(gl.DEPTH_TEST)
  gl.DepthMask(false)
  gl.Disable(gl.STENCIL_TEST)
  gl.Enable(gl.MULTISAMPLE)
  gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
  gl.Enable(gl.BLEND)
  
  // - Vertex array object ---
  gl.GenVertexArrays(1, &g.vao)
  gl.BindVertexArray(g.vao)
}

gl_clear :: proc(color: v4f32)
{
  gl.ClearColor(color.r, color.g, color.b, color.a)
  gl.Clear(gl.COLOR_BUFFER_BIT)
}

gl_draw :: proc(count: int)
{
  pip := &renderer.pass.pipeline.gl

  gl.Viewport(**([4]i32)(renderer.pass.viewport))

  pip.uniforms.projection = cast(m4x4f32) renderer.pass.projection
  pip.uniforms.camera = cast(m4x4f32) renderer.pass.camera
  gl.NamedBufferSubData(pip.ubo, 0, size_of(pip.uniforms), &pip.uniforms)

  gl.VertexArrayElementBuffer(g.vao, renderer.pass.index_buf.gl.handle)

  program := pip.shader.handle
  gl.UseProgram(program)
  gl.UniformBlockBinding(program, 0, pip.ubo_idx)

  for uniform in pip.shader.uniforms
  {
    switch uniform
    {
      case "u_tex":   gl.Uniform1i(pip.shader.uniforms[uniform], renderer.pass.texture)
      case "u_fnt":   gl.Uniform1i(pip.shader.uniforms[uniform], 2)
      case "u_light": gl.Uniform4f(pip.shader.uniforms[uniform], **renderer.pass.light_color)
    }
  }

  gl.DrawElements(gl.TRIANGLES, i32(count), gl.UNSIGNED_SHORT, nil)
}

gl_create_buffer :: proc(size: int, kind: enum{Storage, Index}, binding: int) -> GL_Buffer
{
  result: GL_Buffer

  gl.CreateBuffers(1, &result.handle)

  switch kind
  {
  case .Storage:
    gl.BindBufferBase(gl.SHADER_STORAGE_BUFFER, u32(binding), result.handle)
    gl.NamedBufferStorage(result.handle, size, nil, gl.DYNAMIC_STORAGE_BIT)

  case .Index:
    gl.VertexArrayElementBuffer(g.vao, result.handle)
    gl.NamedBufferData(result.handle, size, nil, gl.DYNAMIC_DRAW)
    gl.VertexArrayElementBuffer(g.vao, 0)
  }

  return result
}

gl_write_buffer :: proc(buffer: GL_Buffer, data: rawptr, size: int, offset: int)
{
  gl.NamedBufferSubData(buffer.handle, offset, size, data)
}

gl_create_pipeline :: proc(desc: Graphics_Pipeline_Desc) -> GL_Pipeline
{
  @(static)
  ubo_idx: u32

  result: GL_Pipeline
  result.ubo_idx = ubo_idx
  ubo_idx += 1

  result.shader = gl_create_shader(desc.vert_shader_src, desc.frag_shader_src, desc.uniform_names)

  gl.CreateBuffers(1, &result.ubo)
  gl.BindBufferBase(gl.UNIFORM_BUFFER, result.ubo_idx, result.ubo)
  gl.NamedBufferStorage(result.ubo, size_of(result.uniforms), &result.uniforms, gl.DYNAMIC_STORAGE_BIT)

  return result
}

gl_create_shader :: proc(vsrc, fsrc: []u8, uniforms: []cstring) -> GL_Shader
{
  result: GL_Shader
  vsrc, fsrc := vsrc, fsrc

  verify_shader :: proc(id, type: u32)
  {
    success: i32 = 1
    log_buf: [1000]byte

    if type == gl.COMPILE_STATUS
    {
      gl.GetShaderiv(id, type, &success);
      if success != 1
      {
        length: i32
        gl.GetShaderiv(id, gl.INFO_LOG_LENGTH, &length)
        gl.GetShaderInfoLog(id, length, &length, &log_buf[0])
        log.fatalf("[render_gl]: Shader compile error!\n%s", cast(string) log_buf[:])
        os.exit(1)
      }
    }
    else if type == gl.LINK_STATUS
    {
      gl.ValidateProgram(id);
      gl.GetProgramiv(id, type, &success)
      if success != 1
      {
        length: i32
        gl.GetProgramiv(id, gl.INFO_LOG_LENGTH, &length)
        gl.GetProgramInfoLog(id, length, &length, &log_buf[0])
        log.fatalf("[render_gl]: Shader link error!\n%s", cast(string) log_buf[:])
        os.exit(1)
      }
    }
  }

  vs := gl.CreateShader(gl.VERTEX_SHADER)
  defer gl.DeleteShader(vs)
  gl.ShaderSource(vs, 1, cast([^]cstring) &vsrc, nil)
  gl.CompileShader(vs)
  verify_shader(vs, gl.COMPILE_STATUS)
  
  fs := gl.CreateShader(gl.FRAGMENT_SHADER)
  defer gl.DeleteShader(fs)
  gl.ShaderSource(fs, 1, cast([^]cstring) &fsrc, nil)
  gl.CompileShader(fs)
  verify_shader(fs, gl.COMPILE_STATUS)

  program := gl.CreateProgram()
  gl.AttachShader(program, vs)
  gl.AttachShader(program, fs)
  gl.LinkProgram(program)
  verify_shader(program, gl.LINK_STATUS)

  result.handle = program

  for uniform in uniforms
  {
    result.uniforms[uniform] = gl.GetUniformLocation(program, uniform)
    if result.uniforms[uniform] == -1
    {
      log.warnf("[render_gl]: Shader uniform '%s' not found!\n", uniform)
    }
  }

  return result
}

gl_create_texture :: proc(pixels: []byte, width, height: i32, format: int) -> GL_Image
{
  result: GL_Image

  @(static)
  unit: u32
  result.unit = unit
  unit += 1

  gl.CreateTextures(gl.TEXTURE_2D, 1, &result.handle)
  gl.TextureStorage2D(result.handle, 1, gl.RGBA8 if format == 4 else gl.R8, width, height)
  gl.TextureSubImage2D(texture=result.handle, 
                       level=0, 
                       xoffset=0, 
                       yoffset=0, 
                       width=width, 
                       height=height, 
                       format=gl.RGBA if format == 4 else gl.RED,
                       type=gl.UNSIGNED_BYTE, 
                       pixels=raw_data(pixels))
  gl.TextureParameteri(result.handle, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
  gl.TextureParameteri(result.handle, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
  gl.BindTextureUnit(result.unit, result.handle)

  if format == 1
  {
    gl.TextureParameteri(result.handle, gl.TEXTURE_SWIZZLE_R, gl.ZERO)
    gl.TextureParameteri(result.handle, gl.TEXTURE_SWIZZLE_G, gl.ZERO)
    gl.TextureParameteri(result.handle, gl.TEXTURE_SWIZZLE_B, gl.ZERO)
    gl.TextureParameteri(result.handle, gl.TEXTURE_SWIZZLE_A, gl.RED)
  }

  return result
}
