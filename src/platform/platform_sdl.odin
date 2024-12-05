package platform

import "core:strings"

import mem "src:basic/mem"
import gl  "ext:opengl"
import 	   "ext:sdl"

@(private)
sdl_create_window :: proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena
) -> Window
{
  result: Window

	scratch := mem.begin_temp(mem.get_scratch())
	defer mem.end_temp(scratch)

	sdl.Init({.VIDEO, .EVENTS})

	window_flags: sdl.WindowFlags
	when ODIN_OS == .Linux do window_flags += {.OPENGL}
	
  title_cstr := strings.clone_to_cstring(title, mem.allocator(scratch.arena))
	sdl_window := sdl.CreateWindow(title_cstr, 
																 sdl.WINDOWPOS_CENTERED,
																 sdl.WINDOWPOS_CENTERED,
																 i32(width),
																 i32(height),
																 window_flags)
	when ODIN_OS == .Linux
	{
		sdl.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, 4)
		sdl.GL_SetAttribute(.CONTEXT_MINOR_VERSION, 6)
		sdl.GL_SetAttribute(.RED_SIZE, 8)
		sdl.GL_SetAttribute(.GREEN_SIZE, 8)
		sdl.GL_SetAttribute(.BLUE_SIZE, 8)
		sdl.GL_SetAttribute(.DEPTH_SIZE, 8)
		sdl.GL_SetAttribute(.DOUBLEBUFFER, 1)

		gl_ctx := sdl.GL_CreateContext(sdl_window)
		sdl.GL_MakeCurrent(sdl_window, gl_ctx)

		gl.load_up_to(4, 6, sdl.gl_set_proc_address)
	}

	// window_system_info: sdl.SysWMinfo
	// sdl.GetVersion(&window_system_info.version)
	// sdl.GetWindowWMInfo(sdl_window, &window_system_info)
	
	result.handle = sdl_window
	result.draw_ctx.opengl.sdl_ctx = gl_ctx

  return result
}

@(private)
sdl_release_os_resources :: proc(window: ^Window)
{
	sdl.DestroyWindow(cast(^sdl.Window) window.handle)
}

@(private)
sdl_gl_swap_buffers :: proc(window: ^Window)
{
	sdl.GL_SwapWindow(cast(^sdl.Window) window.handle)
}

@(private)
sdl_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool

	sdl_event: sdl.Event
	result = cast(bool) sdl.PollEvent(&sdl_event)
	event^ = sdl_event_translate(&sdl_event)

	return result
}

@(private)
sdl_pump_events :: proc(window: ^Window)
{
	sdl.PumpEvents()
}

@(private="file")
sdl_event_translate :: proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: result.kind = .QUIT
  case .KEYDOWN:
    #partial switch sdl_event.key.keysym.scancode
    {
    case .ESCAPE: result.kind = .QUIT
    }
	}

	return result
}

sdl_new_event :: proc() -> ^sdl.Event
{
	return new(sdl.Event)
}
