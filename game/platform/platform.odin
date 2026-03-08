package platform

import "core:fmt"
import "core:math"
import "core:strings"
import "core:os"
import "ext:sdl"
import imgui "ext:dear_imgui"
import imgui_sdl "ext:dear_imgui/imgui_impl_sdl3"
import imgui_gl "ext:dear_imgui/imgui_impl_opengl3"
import imgui_vk "ext:dear_imgui/imgui_impl_vulkan"
import "../basic/mem"

Window :: struct
{
  handle:       ^sdl.Window,
	desc:					Window_Desc,
  imio_handle:  ^imgui.IO,
  render_ctx:   struct #raw_union
  {
    gl:         struct
    {
      ctx:  		sdl.GLContext,
    },
  },
  should_close: bool,
}

Window_Props :: enum
{
	Always_On_Top,
  Borderless,
  Fullscreen,
  Resizeable,
  Maximized,
  Vsync,
}

Window_Desc :: struct #all_or_none
{
  title:  	string,
  width:  	int,
  height: 	int,
  props:  	bit_set[Window_Props],
	renderer:	enum{OpenGL, Vulkan},
}

Event :: struct
{
  kind:           Event_Kind,
  key_kind:       Key_Kind,
  mouse_btn_kind: Mouse_Btn_Kind,
  mouse_pos:      [2]f32,
}

Event_Kind :: enum
{
  Nil,
  Quit,
  Key_Down,
  Key_Up,
  Mouse_Btn_Down,
  Mouse_Btn_Up,
}

create_window :: proc(desc: Window_Desc, arena: ^mem.Arena) -> Window
{
	result: Window
	result.desc = desc

	scratch := mem.temp_begin(mem.get_scratch())
	defer mem.temp_end(scratch)

	when ODIN_OS == .Linux
	{
		deco: cstring = .Borderless in desc.props ? "0" : "1"
		sdl.SetHint("SDL_VIDEO_WAYLAND_ALLOW_LIBDECOR", deco)
		sdl.SetHint("SDL_VIDEO_DOUBLE_BUFFER", "1")
	}
	
	if !sdl.Init({.VIDEO, .EVENTS})
	{
		fmt.eprintln("[FATAL][platform]: Failed to init SDL3!")
		os.exit(1)
	}

	window_flags: sdl.WindowFlags

	when ODIN_OS == .Darwin
	{
		window_flags += {.METAL}
	}
	else
	{
		if desc.renderer == .Vulkan
		{
			window_flags += {.VULKAN}
		}
		else
		{
			window_flags += {.OPENGL}
			sdl.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, 4)
			sdl.GL_SetAttribute(.CONTEXT_MINOR_VERSION, 6)
			sdl.GL_SetAttribute(.RED_SIZE, 8)
			sdl.GL_SetAttribute(.GREEN_SIZE, 8)
			sdl.GL_SetAttribute(.BLUE_SIZE, 8)
			sdl.GL_SetAttribute(.DOUBLEBUFFER, 1)
			sdl.GL_SetAttribute(.MULTISAMPLESAMPLES, 2)
		}
	}
	
	for prop in desc.props
	{
		#partial switch prop
		{
		case .Always_On_Top:
			window_flags += {.ALWAYS_ON_TOP}
		case .Borderless:
			window_flags += {.BORDERLESS}
		case .Fullscreen:
			window_flags += {.FULLSCREEN}
		case .Maximized:
			window_flags += {.MAXIMIZED}
		case .Resizeable:
			window_flags += {.RESIZABLE}
		}
	}

  title_cstr := strings.clone_to_cstring(desc.title, mem.allocator(scratch.arena))
	sdl_window := sdl.CreateWindow(title_cstr, i32(desc.width), i32(desc.height), window_flags)

	if desc.renderer == .OpenGL
	{
		gl_ctx := sdl.GL_CreateContext(sdl_window)
		sdl.GL_MakeCurrent(sdl_window, gl_ctx)
		
		vsync: i32 = .Vsync in desc.props ? 1 : 0
		sdl.GL_SetSwapInterval(vsync)

		when false
		{
			fmt.println("    OpenGL Version:", gl.GetString(gl.VERSION))
			fmt.println("       SDL Version:", sdl.GetVersion())
			fmt.println("Dear ImGui Version:", imgui.GetVersion())
		}

		result.render_ctx.gl.ctx = gl_ctx
	}

	result.handle = sdl_window

	return result
}

destroy_window :: proc(window: ^Window)
{
	switch window.desc.renderer
	{
	case .OpenGL:
		imgui_gl.Shutdown()
		imgui_sdl.Shutdown()
		imgui.DestroyContext()

	case .Vulkan:
		// Not implemented
	}

	sdl.DestroyWindow(window.handle)
	sdl.Quit()
}

window_toggle_fullscreen :: proc(window: ^Window)
{
	fs := transmute(b64) (sdl.GetWindowFlags(window.handle) & sdl.WINDOW_FULLSCREEN)
	sdl.SetWindowFullscreen(window.handle, bool(!fs))
}

window_get_size :: proc(window: ^Window) -> [2]f32
{
	result: [2]i32

	sdl.GetWindowSize(auto_cast window.handle, &result.x, &result.y)

	return {
		cast(f32) result.x,
		cast(f32) result.y,
	}
}

window_draw :: proc(window: ^Window)
{
	sdl.GL_SwapWindow(window.handle)
}

window_pump_events :: proc(window: ^Window)
{
  poll_event :: proc(window: ^Window, event: ^Event) -> bool
  {
  	result: bool
  	sdl_event: sdl.Event
		
  	result = sdl.PollEvent(&sdl_event)
  	event^ = sdl_translate_event(&sdl_event)

		switch window.desc.renderer
		{
		case .OpenGL:
	  	imgui_sdl.ProcessEvent(&sdl_event)
	  	if window.imio_handle.WantCaptureMouse && event.mouse_btn_kind != .Nil
	  	{
	  		event.kind = .Nil
	  	}

		case .Vulkan:
			// Not implemented
		}

  	return result
  }

  event: Event
  for poll_event(window, &event)
  {
    switch event.kind
    {
    case .Nil:
    case .Quit: 
      window.should_close = true
    case .Key_Down:
      global_input.keys[event.key_kind] = true
    case .Key_Up:
      global_input.keys[event.key_kind] = false
    case .Mouse_Btn_Down:
      global_input.mouse_btns[event.mouse_btn_kind] = true
    case .Mouse_Btn_Up:
      global_input.mouse_btns[event.mouse_btn_kind] = false
    }
  }
}

window_init_imgui :: proc(window: ^Window)
{
	switch window.desc.renderer
	{
	case .OpenGL:
		imgui.CreateContext()
		imgui.StyleColorsDark()
		imgui_sdl.InitForOpenGL(window.handle, window.render_ctx.gl.ctx)
		imgui_gl.Init()
		window.imio_handle = imgui.GetIO()

	case .Vulkan:
		// imgui.CreateContext()
		// imgui.StyleColorsDark()
		// imgui_sdl.InitForVulkan(sdl_window)
		// imgui_vk.Init(&{
		// })
	}
}

window_set_relative_cursor :: proc(window: ^Window, enabled: bool) -> bool
{
	return sdl.SetWindowRelativeMouseMode(window.handle, enabled)
}

@(require_results)
get_cursor_position :: proc() -> [2]f32
{
	result: [2]f32
	_ = sdl.GetMouseState(&result.x, &result.y)
	return {math.round(result.x), math.round(result.y)}
}

@(require_results)
get_mouse_scroll :: proc() -> [2]f32
{
	return global_input.mouse_scroll
}

reset_mouse_scroll :: proc()
{
	global_input.mouse_scroll = 0	
}

@(require_results)
get_display_scale :: proc(window: ^Window) -> f32
{
	display_id := sdl.GetDisplayForWindow(window.handle)
	return sdl.GetDisplayContentScale(display_id)
}

@(require_results)
get_display_dpi :: proc(window: ^Window) -> int
{
	return cast(int) get_display_scale(window) * 96
}

@(require_results)
get_display_bounds :: proc(window: ^Window) -> [4]f32
{
	display_id := sdl.GetDisplayForWindow(window.handle)
	rect: sdl.Rect
	sdl.GetDisplayBounds(display_id, &rect)
	return {f32(rect.x), f32(rect.y), f32(rect.w), f32(rect.h)}
}

imgui_begin :: proc()
{
  imgui_gl.NewFrame()
  imgui_sdl.NewFrame()
  imgui.NewFrame()
}

imgui_end :: proc()
{
  imgui.Render()
  imgui_gl.RenderDrawData(imgui.GetDrawData())
}

gl_set_proc_address :: sdl.gl_set_proc_address
vk_get_proc_address :: sdl.Vulkan_GetVkGetInstanceProcAddr
