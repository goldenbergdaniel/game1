#+build linux
#+private
package render

import "core:fmt"
import "core:os"

import vm "src:vecmath"
import plf "src:platform"
import gl "ext:opengl"

GL_Renderer :: struct
{
  vertices:     [40000]Vertex,
  vertex_count: int,
  indices:      [60000]u16,
  index_count:  int,
  projection:   m3x3f,
  viewport:     v4i,
  texture:      ^Texture,
  uniforms:     struct
  {
    proj:       m4x4f,
  },
  window:       ^plf.Window,
  shader:       u32,
  textures:     [Texture_ID]u32,
  ubo:          u32,
  ssbo:         u32,
  ibo:          u32,
}

gl_renderer: GL_Renderer

gl_init :: proc(window: ^plf.Window, textures: ^[Texture_ID]Texture)
{
  gl_renderer.window = window

  // - Vertex array object ---
  vao: u32
  gl.GenVertexArrays(1, &vao)
  gl.BindVertexArray(vao)

  // - Textures ---
  {
    gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
    gl.Enable(gl.BLEND)
		gl.Enable(gl.MULTISAMPLE)

    gl.CreateTextures(gl.TEXTURE_2D, 
                      len(gl_renderer.textures), 
                      raw_data(&gl_renderer.textures))

    for tex, id in gl_renderer.textures
    {
      gl.TextureStorage2D(tex, 1, gl.RGBA8, textures[id].width, textures[id].height)
      gl.TextureSubImage2D(tex, 
                           level=0, 
                           xoffset=0, 
                           yoffset=0, 
                           width=textures[id].width, 
                           height=textures[id].height,
                           format=gl.RGBA,
                           type=gl.UNSIGNED_BYTE,
                           pixels=raw_data(textures[id].data))
      gl.TextureParameteri(tex, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
      gl.TextureParameteri(tex, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
      gl.BindTextureUnit(u32(id), tex)
    }
  }

  // - Shaders ---
  {
    vs_source := #load("shaders/triangle.vert.glsl")
    vs := gl.CreateShader(gl.VERTEX_SHADER); defer gl.DeleteShader(vs)
    gl.ShaderSource(vs, 1, cast([^]cstring) &vs_source, nil)
    gl.CompileShader(vs)
    gl_verify_shader(vs, gl.COMPILE_STATUS)
    
    fs_source := #load("shaders/triangle.frag.glsl")
    fs := gl.CreateShader(gl.FRAGMENT_SHADER); defer gl.DeleteShader(fs)
    gl.ShaderSource(fs, 1, cast([^]cstring) &fs_source, nil)
    gl.CompileShader(fs)
    gl_verify_shader(fs, gl.COMPILE_STATUS)

    gl_renderer.shader = gl.CreateProgram()
    gl.AttachShader(gl_renderer.shader, vs)
    gl.AttachShader(gl_renderer.shader, fs)
    gl.LinkProgram(gl_renderer.shader)
    gl_verify_shader(gl_renderer.shader, gl.LINK_STATUS)
  }

  // - Uniform buffer ---
  gl.CreateBuffers(1, &gl_renderer.ubo)
  gl.UniformBlockBinding(gl_renderer.shader, 0, 0)
  gl.BindBufferBase(gl.UNIFORM_BUFFER, 0, gl_renderer.ubo)
  gl.NamedBufferStorage(gl_renderer.ubo, 
                        size_of(gl_renderer.uniforms),
                        &gl_renderer.uniforms, 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Storage buffer ---
  gl.CreateBuffers(1, &gl_renderer.ssbo)
  gl.BindBufferBase(gl.SHADER_STORAGE_BUFFER, 1, gl_renderer.ssbo)
  gl.NamedBufferStorage(gl_renderer.ssbo, 
                        size_of(gl_renderer.vertices),
                        raw_data(&gl_renderer.vertices), 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Index buffer ---
  gl.CreateBuffers(1, &gl_renderer.ibo)
  gl.VertexArrayElementBuffer(vao, gl_renderer.ibo)
  gl.NamedBufferData(gl_renderer.ibo,
                     size_of(gl_renderer.indices),
                     raw_data(&gl_renderer.indices),
                     gl.DYNAMIC_DRAW)
}

gl_clear :: proc(color: v4f)
{
  gl.ClearColor(color.r, color.g, color.b, color.a)
  gl.Clear(gl.COLOR_BUFFER_BIT);
}

gl_flush :: proc()
{
  if gl_renderer.vertex_count == 0 do return

  window_size := plf.window_size(gl_renderer.window)

  gl_renderer.projection = vm.orthographic_3x3f(0, 
                                               960,
                                               0, 
                                               540)
  gl_renderer.uniforms.proj = cast(m4x4f) gl_renderer.projection

  gl.Viewport(expand_values(gl_renderer.viewport))

  gl.NamedBufferSubData(buffer=gl_renderer.ssbo,
                        offset=0,
                        size=gl_renderer.vertex_count * size_of(Vertex),
                        data=&gl_renderer.vertices[0])

  gl.NamedBufferSubData(buffer=gl_renderer.ibo,
                        offset=0,
                        size=gl_renderer.index_count * size_of(u16),
                        data=&gl_renderer.indices[0])

  gl.UseProgram(gl_renderer.shader)

  u_tex_loc := gl.GetUniformLocation(gl_renderer.shader, "u_tex")
  gl.Uniform1i(u_tex_loc, i32(Texture_ID.SPRITE_MAP))
  gl.NamedBufferSubData(buffer=gl_renderer.ubo,
                        offset=0,
                        size=size_of(gl_renderer.uniforms),
                        data=&gl_renderer.uniforms)

  gl.DrawElements(gl.TRIANGLES, i32(gl_renderer.index_count), gl.UNSIGNED_SHORT, nil)

  gl.UseProgram(0)

  gl_renderer.vertex_count = 0
  gl_renderer.index_count = 0
}

gl_verify_shader :: proc(id, type: u32)
{
  when ODIN_DEBUG
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
}
