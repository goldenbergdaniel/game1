#+build !windows
#+private
package platform

import "core:fmt"
import "core:strings"
import gl "ext:opengl"
import sdl "ext:sdl3"
import im "ext:imgui"
import im_gl "ext:imgui/imgui_impl_opengl3"
import im_sdl "ext:imgui/imgui_impl_sdl3"

import "../basic/mem"

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
		sdl.SetHint("SDL_VIDEO_DOUBLE_BUFFER", "1")
	}
	
	_ = sdl.Init({.VIDEO, .EVENTS})

	window_flags := sdl.WindowFlags{.RESIZABLE}
	when ODIN_OS == .Linux
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
		sdl.GL_SetSwapInterval(1)

		when false
		{
			fmt.println("    OpenGL Version:", gl.GetString(gl.VERSION))
			fmt.println("       SDL Version:", sdl.GetVersion())
			fmt.println("Dear ImGui Version:", im.GetVersion())
		}
	}

	// window_system_info: sdl.SysWMinfo
	// sdl.GetVersion(&window_system_info.version)
	// sdl.GetWindowWMInfo(sdl_window, &window_system_info)

	im.CreateContext()
	imio := im.GetIO()
	// imio.ConfigFlags += {.NoKeyboard}

	im.StyleColorsDark()

	im_sdl.InitForOpenGL(sdl_window, gl_ctx)
	im_gl.Init(nil)

	result.handle = sdl_window
	result.draw_ctx.gl.sdl_ctx = gl_ctx
	result.imio_handle = imio

  return result
}

sdl_release_os_resources :: proc(window: ^Window)
{
	sdl.DestroyWindow(auto_cast window.handle)
	// im.DestroyContext()
	// im_sdl.Shutdown()
	// im_gl.Shutdown()
	// im.Shutdown()
}

sdl_gl_swap_buffers :: proc(window: ^Window)
{
	sdl.GL_SwapWindow(auto_cast window.handle)
}

sdl_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool

	sdl_event: sdl.Event
	result = sdl.PollEvent(&sdl_event)
	event^ = sdl_translate_event(&sdl_event)
   
	im_sdl.ProcessEvent(&sdl_event)
	imio := cast(^im.IO) window.imio_handle
	if imio.WantCaptureMouse && event.mouse_btn_kind != .NIL
	{
		event.kind = .NIL
	}

	return result
}

sdl_pump_events :: proc()
{
	sdl.PumpEvents()
}

// TODO(dg): The event codes should be mapped in an array.
sdl_translate_event :: proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: 
		result.kind = .QUIT
  case .KEY_DOWN:
    #partial switch sdl_event.key.scancode
    {
		case .A:				 result = Event{kind = .KEY_DOWN, key_kind = .A}
		case .B:				 result = Event{kind = .KEY_DOWN, key_kind = .B}
		case .C:				 result = Event{kind = .KEY_DOWN, key_kind = .C}
		case .D:				 result = Event{kind = .KEY_DOWN, key_kind = .D}
		case .E:				 result = Event{kind = .KEY_DOWN, key_kind = .E}
		case .F:				 result = Event{kind = .KEY_DOWN, key_kind = .F}
		case .G:				 result = Event{kind = .KEY_DOWN, key_kind = .G}
		case .H:				 result = Event{kind = .KEY_DOWN, key_kind = .H}
		case .I:				 result = Event{kind = .KEY_DOWN, key_kind = .I}
		case .J:				 result = Event{kind = .KEY_DOWN, key_kind = .J}
		case .K:				 result = Event{kind = .KEY_DOWN, key_kind = .K}
		case .L:				 result = Event{kind = .KEY_DOWN, key_kind = .L}
		case .M:				 result = Event{kind = .KEY_DOWN, key_kind = .M}
		case .N:				 result = Event{kind = .KEY_DOWN, key_kind = .N}
		case .O:				 result = Event{kind = .KEY_DOWN, key_kind = .O}
		case .P:				 result = Event{kind = .KEY_DOWN, key_kind = .P}
		case .Q:				 result = Event{kind = .KEY_DOWN, key_kind = .Q}
		case .R:				 result = Event{kind = .KEY_DOWN, key_kind = .R}
		case .S:				 result = Event{kind = .KEY_DOWN, key_kind = .S}
		case .T:				 result = Event{kind = .KEY_DOWN, key_kind = .T}
		case .U:				 result = Event{kind = .KEY_DOWN, key_kind = .U}
		case .V:				 result = Event{kind = .KEY_DOWN, key_kind = .V}
		case .W:				 result = Event{kind = .KEY_DOWN, key_kind = .W}
		case .X:				 result = Event{kind = .KEY_DOWN, key_kind = .X}
		case .Y:				 result = Event{kind = .KEY_DOWN, key_kind = .Y}
		case .Z:				 result = Event{kind = .KEY_DOWN, key_kind = .Z}
		case ._0:				 result = Event{kind = .KEY_DOWN, key_kind = .S_0}
		case ._1:				 result = Event{kind = .KEY_DOWN, key_kind = .S_1}
		case ._2:				 result = Event{kind = .KEY_DOWN, key_kind = .S_2}
		case ._3:				 result = Event{kind = .KEY_DOWN, key_kind = .S_3}
		case ._4:				 result = Event{kind = .KEY_DOWN, key_kind = .S_4}
		case ._5:				 result = Event{kind = .KEY_DOWN, key_kind = .S_5}
		case ._6:				 result = Event{kind = .KEY_DOWN, key_kind = .S_6}
		case ._7:				 result = Event{kind = .KEY_DOWN, key_kind = .S_7}
		case ._8:				 result = Event{kind = .KEY_DOWN, key_kind = .S_8}
		case ._9:				 result = Event{kind = .KEY_DOWN, key_kind = .S_9}
    case .LALT: 		 result = Event{kind = .KEY_DOWN, key_kind = .L_ALT}
    case .RALT: 		 result = Event{kind = .KEY_DOWN, key_kind = .R_ALT}
    case .LCTRL: 		 result = Event{kind = .KEY_DOWN, key_kind = .L_CTRL}
    case .RCTRL: 		 result = Event{kind = .KEY_DOWN, key_kind = .R_CTRL}
    case .LSHIFT: 	 result = Event{kind = .KEY_DOWN, key_kind = .L_SHIFT}
    case .RSHIFT: 	 result = Event{kind = .KEY_DOWN, key_kind = .R_SHIFT}
    case .SPACE:  	 result = Event{kind = .KEY_DOWN, key_kind = .SPACE}
		case .TAB:			 result = Event{kind = .KEY_DOWN, key_kind = .TAB}
    case .RETURN: 	 result = Event{kind = .KEY_DOWN, key_kind = .ENTER}
  	case .BACKSPACE: result = Event{kind = .KEY_DOWN, key_kind = .BACKSPACE}
		case .GRAVE:		 result = Event{kind = .KEY_DOWN, key_kind = .BACKTICK}
    case .ESCAPE: 	 result = Event{kind = .KEY_DOWN, key_kind = .ESCAPE}
    }
	case .KEY_UP:
    #partial switch sdl_event.key.scancode
    {
		case .A:				 result = Event{kind = .KEY_UP, key_kind = .A}
		case .B:				 result = Event{kind = .KEY_UP, key_kind = .B}
		case .C:				 result = Event{kind = .KEY_UP, key_kind = .C}
		case .D:				 result = Event{kind = .KEY_UP, key_kind = .D}
		case .E:				 result = Event{kind = .KEY_UP, key_kind = .E}
		case .F:				 result = Event{kind = .KEY_UP, key_kind = .F}
		case .G:				 result = Event{kind = .KEY_UP, key_kind = .G}
		case .H:				 result = Event{kind = .KEY_UP, key_kind = .H}
		case .I:				 result = Event{kind = .KEY_UP, key_kind = .I}
		case .J:				 result = Event{kind = .KEY_UP, key_kind = .J}
		case .K:				 result = Event{kind = .KEY_UP, key_kind = .K}
		case .L:				 result = Event{kind = .KEY_UP, key_kind = .L}
		case .M:				 result = Event{kind = .KEY_UP, key_kind = .M}
		case .N:				 result = Event{kind = .KEY_UP, key_kind = .N}
		case .O:				 result = Event{kind = .KEY_UP, key_kind = .O}
		case .P:				 result = Event{kind = .KEY_UP, key_kind = .P}
		case .Q:				 result = Event{kind = .KEY_UP, key_kind = .Q}
		case .R:				 result = Event{kind = .KEY_UP, key_kind = .R}
		case .S:				 result = Event{kind = .KEY_UP, key_kind = .S}
		case .T:				 result = Event{kind = .KEY_UP, key_kind = .T}
		case .U:				 result = Event{kind = .KEY_UP, key_kind = .U}
		case .V:				 result = Event{kind = .KEY_UP, key_kind = .V}
		case .W:				 result = Event{kind = .KEY_UP, key_kind = .W}
		case .X:				 result = Event{kind = .KEY_UP, key_kind = .X}
		case .Y:				 result = Event{kind = .KEY_UP, key_kind = .Y}
		case .Z:				 result = Event{kind = .KEY_UP, key_kind = .Z}
		case ._0:				 result = Event{kind = .KEY_UP, key_kind = .S_0}
		case ._1:				 result = Event{kind = .KEY_UP, key_kind = .S_1}
		case ._2:				 result = Event{kind = .KEY_UP, key_kind = .S_2}
		case ._3:				 result = Event{kind = .KEY_UP, key_kind = .S_3}
		case ._4:				 result = Event{kind = .KEY_UP, key_kind = .S_4}
		case ._5:				 result = Event{kind = .KEY_UP, key_kind = .S_5}
		case ._6:				 result = Event{kind = .KEY_UP, key_kind = .S_6}
		case ._7:				 result = Event{kind = .KEY_UP, key_kind = .S_7}
		case ._8:				 result = Event{kind = .KEY_UP, key_kind = .S_8}
		case ._9:				 result = Event{kind = .KEY_UP, key_kind = .S_9}
    case .LALT: 		 result = Event{kind = .KEY_UP, key_kind = .L_ALT}
    case .RALT: 		 result = Event{kind = .KEY_UP, key_kind = .R_ALT}
    case .LCTRL: 		 result = Event{kind = .KEY_UP, key_kind = .L_CTRL}
    case .RCTRL: 		 result = Event{kind = .KEY_UP, key_kind = .R_CTRL}
		case .LSHIFT: 	 result = Event{kind = .KEY_UP, key_kind = .L_SHIFT}
    case .RSHIFT: 	 result = Event{kind = .KEY_UP, key_kind = .R_SHIFT}
    case .SPACE:  	 result = Event{kind = .KEY_UP, key_kind = .SPACE}
		case .TAB:			 result = Event{kind = .KEY_UP, key_kind = .TAB}
    case .RETURN: 	 result = Event{kind = .KEY_UP, key_kind = .ENTER}
  	case .BACKSPACE: result = Event{kind = .KEY_UP, key_kind = .BACKSPACE}
		case .GRAVE:		 result = Event{kind = .KEY_UP, key_kind = .BACKTICK}
    case .ESCAPE: 	 result = Event{kind = .KEY_UP, key_kind = .ESCAPE}
    }
	case .MOUSE_BUTTON_DOWN:
		switch sdl_event.button.button
		{
		case 1: result = Event{kind = .MOUSE_BTN_DOWN, mouse_btn_kind = .LEFT}
		case 2: result = Event{kind = .MOUSE_BTN_DOWN, mouse_btn_kind = .MIDDLE}
		case 3: result = Event{kind = .MOUSE_BTN_DOWN, mouse_btn_kind = .RIGHT}
		}
	case .MOUSE_BUTTON_UP:
		switch sdl_event.button.button
		{
		case 1: result = Event{kind = .MOUSE_BTN_UP, mouse_btn_kind = .LEFT}
		case 2: result = Event{kind = .MOUSE_BTN_UP, mouse_btn_kind = .MIDDLE}
		case 3: result = Event{kind = .MOUSE_BTN_UP, mouse_btn_kind = .RIGHT}
		}
	}

	return result
}

sdl_imgui_begin :: proc()
{
  im_gl.NewFrame()
  im_sdl.NewFrame()
  im.NewFrame()
}

sdl_imgui_end :: proc()
{
  im.Render()
  im_gl.RenderDrawData(im.GetDrawData())
}

sdl_window_toggle_fullscreen :: proc(window: ^Window)
{
	sdl_window := cast(^sdl.Window) window.handle
	fs := transmute(b64) (sdl.GetWindowFlags(sdl_window) & sdl.WINDOW_FULLSCREEN)
	sdl.SetWindowFullscreen(sdl_window, bool(!fs))
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
