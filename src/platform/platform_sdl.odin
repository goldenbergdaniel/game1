#+build !windows
#+private
package platform

import "core:fmt"
import "core:strings"

import mem "src:basic/mem"
import gl  "ext:opengl"
import sdl "ext:sdl3"

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

	window_flags := sdl.WindowFlags{.RESIZABLE}
	when ODIN_OS == .Linux
	{
		window_flags += {.OPENGL}

		sdl.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, 4)
		sdl.GL_SetAttribute(.CONTEXT_MINOR_VERSION, 6)
		// sdl.GL_SetAttribute(.RED_SIZE, 8)
		// sdl.GL_SetAttribute(.GREEN_SIZE, 8)
		// sdl.GL_SetAttribute(.BLUE_SIZE, 8)
    // sdl.GL_SetAttribute(.DEPTH_SIZE, 8)
		// sdl.GL_SetAttribute(.DOUBLEBUFFER, 1)
		// sdl.GL_SetAttribute(.MULTISAMPLESAMPLES, 2)
	}
	else when ODIN_OS == .DARWIN
	{
		window_flags += {.METAL}
	}
	
  title_cstr := strings.clone_to_cstring(title, mem.a(scratch.arena))
	sdl_window := sdl.CreateWindow(title_cstr, i32(width), i32(height), window_flags)

	when ODIN_OS == .Linux
	{
		gl_ctx := sdl.GL_CreateContext(sdl_window)
		sdl.GL_MakeCurrent(sdl_window, gl_ctx)

		gl.load_up_to(4, 6, sdl.gl_set_proc_address)
		sdl.GL_SetSwapInterval(0)
		// fmt.println(gl.GetString(gl.VERSION))
	}

	// window_system_info: sdl.SysWMinfo
	// sdl.GetVersion(&window_system_info.version)
	// sdl.GetWindowWMInfo(sdl_window, &window_system_info)
	
	result.handle = sdl_window
	result.draw_ctx.opengl.sdl_ctx = gl_ctx

  return result
}

sdl_release_os_resources :: proc(window: ^Window)
{
	sdl.DestroyWindow(auto_cast window.handle)
}

sdl_gl_swap_buffers :: proc(window: ^Window)
{
	sdl.GL_SwapWindow(auto_cast window.handle)
}

sdl_poll_event :: proc(event: ^Event) -> bool
{
	result: bool

	sdl_event: sdl.Event
	result = sdl.PollEvent(&sdl_event)
	event^ = sdl_translate_event(&sdl_event)

	return result
}

sdl_pump_events :: proc()
{
	sdl.PumpEvents()
}

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
		case .K:			result = Event{kind = .KEY_DOWN, key_kind = .K}
		case .L:			result = Event{kind = .KEY_DOWN, key_kind = .L}
		case .S:			result = Event{kind = .KEY_DOWN, key_kind = .S}
		case .W:			result = Event{kind = .KEY_DOWN, key_kind = .W}
    case .LCTRL: 	result = Event{kind = .KEY_DOWN, key_kind = .LEFT_CTRL}
    case .ESCAPE: result = Event{kind = .KEY_DOWN, key_kind = .ESCAPE}
    case .SPACE:  result = Event{kind = .KEY_DOWN, key_kind = .SPACE}
    }
	case .KEY_UP:
    #partial switch sdl_event.key.scancode
    {
		case .A:			result = Event{kind = .KEY_UP, key_kind = .A}
		case .D:			result = Event{kind = .KEY_UP, key_kind = .D}
		case .K:			result = Event{kind = .KEY_UP, key_kind = .K}
		case .L:			result = Event{kind = .KEY_UP, key_kind = .L}
		case .S:			result = Event{kind = .KEY_UP, key_kind = .S}
		case .W:			result = Event{kind = .KEY_UP, key_kind = .W}
    case .LCTRL: 	result = Event{kind = .KEY_UP, key_kind = .LEFT_CTRL}
    case .ESCAPE: result = Event{kind = .KEY_UP, key_kind = .ESCAPE}
    case .SPACE:  result = Event{kind = .KEY_UP, key_kind = .SPACE}
    }
	case .MOUSE_BUTTON_DOWN:
		#partial switch sdl_event.button.type
		{
			
		}
	}

	return result
}

sdl_window_size :: proc(window: ^Window) -> [2]i32
{
	result: [2]i32
	sdl.GetWindowSize(auto_cast window.handle, &result.x, &result.y)
	return result
}

sdl_cursor_pos :: proc() -> [2]f32
{
	result: [2]f32
	_ = sdl.GetMouseState(&result.x, &result.y)
	return result
}
