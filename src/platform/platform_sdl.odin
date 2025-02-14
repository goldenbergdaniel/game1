package platform

import "core:strings"

import mem "src:basic/mem"
import gl  "ext:opengl"
import sdl "ext:sdl3"

@(private)
sdl_create_window :: proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena,
) -> Window
{
  result: Window

	scratch := mem.begin_temp(mem.get_scratch())
	defer mem.end_temp(scratch)

	when ODIN_OS == .Linux
	{
		sdl.SetHint("SDL_VIDEO_WAYLAND_ALLOW_LIBDECOR", "1")
	}
	
	_ = sdl.Init({.VIDEO, .EVENTS})

	window_flags: sdl.WindowFlags
	when ODIN_OS == .Linux
	{
		window_flags += {.OPENGL, .RESIZABLE}
	}
	
  title_cstr := strings.clone_to_cstring(title, mem.allocator(scratch.arena))
	sdl_window := sdl.CreateWindow(title_cstr, i32(width), i32(height), window_flags)

	when ODIN_OS == .Linux
	{
		sdl.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, 4)
		sdl.GL_SetAttribute(.CONTEXT_MINOR_VERSION, 6)
		sdl.GL_SetAttribute(.RED_SIZE, 8)
		sdl.GL_SetAttribute(.GREEN_SIZE, 8)
		sdl.GL_SetAttribute(.BLUE_SIZE, 8)
		sdl.GL_SetAttribute(.DEPTH_SIZE, 8)
		sdl.GL_SetAttribute(.DOUBLEBUFFER, 1)
		sdl.GL_SetAttribute(.MULTISAMPLEBUFFERS, 1)
		sdl.GL_SetAttribute(.MULTISAMPLESAMPLES, 4)
	
		gl_ctx := sdl.GL_CreateContext(sdl_window)
		sdl.GL_MakeCurrent(sdl_window, gl_ctx)

		gl.load_up_to(4, 6, sdl.gl_set_proc_address)
		gl.Enable(gl.MULTISAMPLE)
	}

	// sdl.GL_SetSwapInterval(0)

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
sdl_poll_event :: proc(event: ^Event) -> bool
{
	result: bool

	sdl_event: sdl.Event
	result = sdl.PollEvent(&sdl_event)
	event^ = sdl_translate_event(&sdl_event)

	return result
}

@(private)
sdl_pump_events :: proc()
{
	sdl.PumpEvents()
}

@(private="file")
sdl_translate_event :: #force_inline proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: 
		result.kind = .QUIT
  case .KEY_DOWN:
    #partial switch sdl_event.key.scancode
    {
		case .A:			result = Event{kind = .KEY_DOWN, key_kind = .A}
		case .D:			result = Event{kind = .KEY_DOWN, key_kind = .D}
		case .S:			result = Event{kind = .KEY_DOWN, key_kind = .S}
		case .W:			result = Event{kind = .KEY_DOWN, key_kind = .W}
    case .ESCAPE: result = Event{kind = .KEY_DOWN, key_kind = .ESCAPE}
    case .SPACE:  result = Event{kind = .KEY_DOWN, key_kind = .SPACE}
    }
	case .KEY_UP:
    #partial switch sdl_event.key.scancode
    {
		case .A:			result = Event{kind = .KEY_UP, key_kind = .A}
		case .D:			result = Event{kind = .KEY_UP, key_kind = .D}
		case .S:			result = Event{kind = .KEY_UP, key_kind = .S}
		case .W:			result = Event{kind = .KEY_UP, key_kind = .W}
    case .ESCAPE: result = Event{kind = .KEY_UP, key_kind = .ESCAPE}
    case .SPACE:  result = Event{kind = .KEY_UP, key_kind = .SPACE}
    }
	}

	return result
}
