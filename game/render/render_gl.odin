#+build linux, windows
#+private
package render

import "core:fmt"
import "core:os"
import gl "ext:opengl"
import "../basic"
import "../platform"

gl_init :: proc(window: ^platform.Window)
{
  gl.load_up_to(4, 6, platform.gl_set_proc_address)

  // - Features ---
  gl.Disable(gl.DEPTH_TEST)
  gl.DepthMask(false)
  gl.Disable(gl.STENCIL_TEST)
  gl.Enable(gl.MULTISAMPLE)
  gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
  gl.Enable(gl.BLEND)
  
  // - Vertex array object ---
  vao: u32
  gl.GenVertexArrays(1, &vao)
  gl.BindVertexArray(vao)

  // - Uniform buffer ---
  gl.CreateBuffers(1, &renderer.ubo)
  gl.BindBufferBase(gl.UNIFORM_BUFFER, 0, renderer.ubo)
  gl.NamedBufferStorage(renderer.ubo, 
                        size_of(renderer.uniforms), 
                        &renderer.uniforms, 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Shader storage buffer ---
  gl.CreateBuffers(1, &renderer.ssbo)
  gl.BindBufferBase(gl.SHADER_STORAGE_BUFFER, 1, renderer.ssbo)
  gl.NamedBufferStorage(renderer.ssbo, 
                        size_of(renderer.vertices),
                        raw_data(&renderer.vertices), 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Index buffer ---
  gl.CreateBuffers(1, &renderer.ibo)
  gl.VertexArrayElementBuffer(vao, renderer.ibo)
  gl.NamedBufferData(renderer.ibo,
                     size_of(renderer.indices),
                     raw_data(&renderer.indices),
                     gl.DYNAMIC_DRAW)

  // - Textures ---
  gl.CreateTextures(gl.TEXTURE_2D, MAX_TEXTURES, &renderer.textures[0])
}

gl_clear :: proc(color: v4f32)
{
  gl.ClearColor(color.r, color.g, color.b, color.a)
  gl.Clear(gl.COLOR_BUFFER_BIT)
}

gl_draw :: proc()
{
  if renderer.vertices_count == 0 do return

  renderer.uniforms.projection = cast(m4x4f32) renderer.pass.projection
  renderer.uniforms.camera = cast(m4x4f32) renderer.pass.camera

  gl.Viewport(expand_values(basic.array_cast(renderer.pass.viewport, i32)))

  gl.NamedBufferSubData(buffer=renderer.ssbo,
                        offset=0,
                        size=renderer.vertices_count * size_of(Vertex),
                        data=&renderer.vertices[0])

  gl.NamedBufferSubData(buffer=renderer.ibo,
                        offset=0,
                        size=renderer.indices_count * size_of(u16),
                        data=&renderer.indices[0])
  
  program := renderer.shaders[renderer.pass.shader.id]
  gl.UseProgram(program)
  gl.UniformBlockBinding(program, 0, 0)
  gl.Uniform1i(renderer.pass.shader.uniforms.tex, i32(renderer.pass.texture.id))
  gl.Uniform4f(renderer.pass.shader.uniforms.light, expand_values(renderer.pass.light_color))

  gl.NamedBufferSubData(buffer=renderer.ubo,
                        offset=0,
                        size=size_of(renderer.uniforms),
                        data=&renderer.uniforms)

  gl.DrawElements(gl.TRIANGLES, i32(renderer.indices_count), gl.UNSIGNED_SHORT, nil)

  gl.UseProgram(0)

  renderer.vertices_count = 0
  renderer.indices_count = 0
}

gl_create_shader :: proc(vsrc, fsrc: string) -> Shader
{
  assert(renderer.shaders_count < MAX_SHADERS)

  result: Shader
  vsrc, fsrc := vsrc, fsrc

  verify_shader :: proc(id, type: u32)
  {
    success: i32 = 1
    log: [1000]byte

    if type == gl.COMPILE_STATUS
    {
      gl.GetShaderiv(id, type, &success);
      if success != 1
      {
        length: i32
        gl.GetShaderiv(id, gl.INFO_LOG_LENGTH, &length)
        gl.GetShaderInfoLog(id, length, &length, &log[0])

        fmt.eprintln("[ERROR]: Shader compile error!")
        fmt.eprintln(cast(string) log[:])

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
        gl.GetProgramInfoLog(id, length, &length, &log[0])

        fmt.eprintln("[ERROR]: Shader link error!")
        fmt.eprintln(cast(string) log[:length])
        
        os.exit(1)
      }
    }
  }

  vs := gl.CreateShader(gl.VERTEX_SHADER)
  defer gl.DeleteShader(vs)
  gl.ShaderSource(vs, 1, cast([^]cstring) &vsrc, nil)
  gl.CompileShader(vs)
  when ODIN_DEBUG
  {
    verify_shader(vs, gl.COMPILE_STATUS)
  }
  
  fs := gl.CreateShader(gl.FRAGMENT_SHADER)
  defer gl.DeleteShader(fs)
  gl.ShaderSource(fs, 1, cast([^]cstring) &fsrc, nil)
  gl.CompileShader(fs)
  when ODIN_DEBUG
  {
    verify_shader(fs, gl.COMPILE_STATUS)
  }

  program := gl.CreateProgram()
  gl.AttachShader(program, vs)
  gl.AttachShader(program, fs)
  gl.LinkProgram(program)
  when ODIN_DEBUG
  {
    verify_shader(program, gl.LINK_STATUS)
  }

  renderer.shaders[renderer.shaders_count] = program
  result.id = cast(u32) renderer.shaders_count
  renderer.shaders_count += 1

  tex_loc := gl.GetUniformLocation(program, "u_tex")
  if tex_loc != -1
  {
    result.uniforms.tex = tex_loc
  }
  else
  {
    fmt.eprintln("Warning [render]: Shader uniform 'u_tex' not found!")
  }

  light_loc := gl.GetUniformLocation(program, "u_light")
  if light_loc != -1
  {
    result.uniforms.light = light_loc
  }
  else
  {
    fmt.eprintln("Warning [render]: Shader uniform 'u_light' not found!")
  }

  return result
}

gl_create_texture :: proc(data: []byte, width, height: i32) -> Texture
{
  assert(renderer.textures_count < MAX_TEXTURES)

  result: Texture
  result.data = data
  result.width = width
  result.height = height
  result.id = cast(u32) renderer.textures_count

  tex := renderer.textures[result.id]

  gl.TextureStorage2D(tex, 1, gl.RGBA8, width, height)
  gl.TextureSubImage2D(texture=tex, 
                       level=0, 
                       xoffset=0, 
                       yoffset=0, 
                       width=width, 
                       height=height, 
                       format=gl.RGBA, 
                       type=gl.UNSIGNED_BYTE, 
                       pixels=raw_data(data))
  gl.TextureParameteri(tex, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
  gl.TextureParameteri(tex, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
  gl.BindTextureUnit(result.id, tex)

  renderer.textures_count += 1

  return result
}
