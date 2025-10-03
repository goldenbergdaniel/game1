#+build linux
#+private
package render

import "core:fmt"
import "core:os"

import gl "ext:opengl"
import vmath "../basic/vector_math"
import "../platform"

gl_init :: proc(
  window:     ^platform.Window, 
  projection: f32x4,
  textures:   ^[Texture_ID]Texture,
){
  gl.load_up_to(4, 6, platform.gl_set_proc_address)

  renderer.window = window
  renderer.projection = vmath.orthographic_3x3f(expand_values(projection))

  // - Vertex array object ---
  vao: u32
  gl.GenVertexArrays(1, &vao)
  gl.BindVertexArray(vao)

  // - Textures ---
  {
    gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
    gl.Enable(gl.BLEND)
		gl.Enable(gl.MULTISAMPLE)

    gl.CreateTextures(gl.TEXTURE_2D, len(renderer.textures), raw_data(&renderer.textures))

    for tex, id in renderer.textures
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

    renderer.shader = gl.CreateProgram()
    gl.AttachShader(renderer.shader, vs)
    gl.AttachShader(renderer.shader, fs)
    gl.LinkProgram(renderer.shader)
    gl_verify_shader(renderer.shader, gl.LINK_STATUS)
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
                        raw_data(&renderer.vertices), 
                        gl.DYNAMIC_STORAGE_BIT)

  // - Index buffer ---
  gl.CreateBuffers(1, &renderer.ibo)
  gl.VertexArrayElementBuffer(vao, renderer.ibo)
  gl.NamedBufferData(renderer.ibo,
                     size_of(renderer.indices),
                     raw_data(&renderer.indices),
                     gl.DYNAMIC_DRAW)
}

gl_clear :: proc(color: f32x4)
{
  gl.ClearColor(color.r, color.g, color.b, color.a)
  gl.Clear(gl.COLOR_BUFFER_BIT);
}

gl_flush :: proc()
{
  if renderer.vertex_count == 0 do return

  renderer.uniforms.projection = cast(m4x4f32) renderer.projection
  renderer.uniforms.camera = cast(m4x4f32) renderer.camera

  gl.Viewport(expand_values(renderer.viewport))

  gl.NamedBufferSubData(buffer=renderer.ssbo,
                        offset=0,
                        size=renderer.vertex_count * size_of(Vertex),
                        data=&renderer.vertices[0])

  gl.NamedBufferSubData(buffer=renderer.ibo,
                        offset=0,
                        size=renderer.index_count * size_of(u16),
                        data=&renderer.indices[0])

  gl.UseProgram(renderer.shader)

  u_tex_loc := gl.GetUniformLocation(renderer.shader, "u_tex")
  gl.Uniform1i(u_tex_loc, i32(Texture_ID.SPRITE_MAP))
  gl.NamedBufferSubData(buffer=renderer.ubo,
                        offset=0,
                        size=size_of(renderer.uniforms),
                        data=&renderer.uniforms)

  gl.DrawElements(gl.TRIANGLES, i32(renderer.index_count), gl.UNSIGNED_SHORT, nil)

  gl.UseProgram(0)

  renderer.vertex_count = 0
  renderer.index_count = 0
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
