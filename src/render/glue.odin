package render

import "base:runtime"

import plf "src:platform"
import sg "ext:sokol/gfx"
import shelp "ext:sokol/helpers"
import slog "ext:sokol/log"

when ODIN_OS == .Darwin  do BACKEND :: sg.Backend.METAL_MACOS
when ODIN_OS == .Linux   do BACKEND :: sg.Backend.GLCORE
when ODIN_OS == .Windows do BACKEND :: sg.Backend.D3D11

glue_allocator :: #force_inline proc(ctx: ^runtime.Context) -> sg.Allocator
{
  return cast(sg.Allocator) shelp.allocator(ctx)
}

glue_logger :: #force_inline proc(ctx: ^runtime.Context) -> sg.Logger
{
  return sg.Logger{ func = slog.func },
}

glue_environment :: #force_inline proc() -> sg.Environment
{
  result: sg.Environment
  result.defaults.color_format = .RGBA8
  result.defaults.depth_format = .RGBA8
  result.defaults.sample_count = 1
  result.metal.device = plf.global.metal_device
  result.d3d11.device = plf.global.d3d11_device
  result.d3d11.device_context = plf.global.d3d11_device_ctx

  return result
}

glue_swapchain :: #force_inline proc(window: ^plf.Window, size: [2]i32) -> sg.Swapchain
{
  result: sg.Swapchain
  result.width = size.x
  result.height = size.y
  result.sample_count = 1
  result.color_format = .RGBA8
  result.depth_format = .RGBA8
  result.metal.current_drawable = window.draw_ctx.metal.drawable
  result.metal.depth_stencil_texture = window.draw_ctx.metal.depth_stencil_texture
  result.metal.msaa_color_texture = window.draw_ctx.metal.msaa_color_texture
  result.d3d11.render_view = window.draw_ctx.d3d11.render_view
  result.d3d11.resolve_view = window.draw_ctx.d3d11.resolve_view
  result.d3d11.depth_stencil_view = window.draw_ctx.d3d11.depth_stencil_view
  result.gl.framebuffer = window.draw_ctx.opengl.framebuffer

  return result
}
