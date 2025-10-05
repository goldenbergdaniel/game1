#+build !windows
// #+private
package platform

import "core:fmt"
import "core:strings"
import "ext:sdl"
import imgui "ext:dear_imgui"
import imgui_gl "ext:dear_imgui/imgui_impl_opengl3"
import imgui_sdl "ext:dear_imgui/imgui_impl_sdl3"

import "../basic/mem"

sdl_key_map := #partial #sparse [sdl.Scancode]Key_Kind{
	.A 				 		= .A,
	.B 				 		= .B,
	.C 				 		= .C,
	.D 				 		= .D,
	.E 				 		= .E,
	.F 				 		= .F,
	.G 				 		= .G,
	.H 				 		= .H,
	.I 				 		= .I,
	.J 				 		= .J,
	.K 				 		= .K,
	.L 				 		= .L,
	.M 				 		= .M,
	.N 				 		= .N,
	.O 				 		= .O,
	.P 				 		= .P,
	.Q 				 		= .Q,
	.R 				 		= .R,
	.S 				 		= .S,
	.T 				 		= .T,
	.U 				 		= .U,
	.V 				 		= .V,
	.W 				 		= .W,
	.X 				 		= .X,
	.Y 				 		= .Y,
	.Z 				 		= .Z,
	._0 			 		= .S_0,
	._1 			 		= .S_1,
	._2 			 		= .S_2,
	._3 			 		= .S_3,
	._4 			 		= .S_4,
	._5 			 		= .S_5,
	._6 			 		= .S_6,
	._7 			 		= .S_7,
	._8 			 		= .S_8,
	._9 			 		= .S_9,
  .LEFTBRACKET  = .Open_Bracket,
  .RIGHTBRACKET = .Close_Bracket,
  .SLASH		    = .Forward_Slash,
  .BACKSLASH    = .Backward_Slash,
  .SEMICOLON  	= .Semicolon,
  .APOSTROPHE 	= .Apostrophe,
  .COMMA     		= .Comma,
  .PERIOD    		= .Period,
	.GRAVE     		= .Backtick,
	.LALT 		 		= .Left_Alt,
	.RALT 		 		= .Right_Alt,
	.LCTRL 		 		= .Left_Ctrl,
	.RCTRL 		 		= .Right_Ctrl,
	.LSHIFT 	 		= .Left_Shift,
	.RSHIFT 	 		= .Right_Shift,
  .UP        		= .Up,
  .DOWN      		= .Down,
  .LEFT      		= .Left,
  .RIGHT     		= .Right,
  .PAGEUP    		= .Page_Up,
  .PAGEDOWN  		= .Page_Down,
	.SPACE 		 		= .Space,
	.TAB 			 		= .Tab,
	.RETURN 	 		= .Enter,
	.BACKSPACE 		= .Backspace,
	.ESCAPE    		= .Escape,
  .F1 					= .F1,
  .F2 					= .F2,
  .F3 					= .F3,
  .F4 					= .F4,
  .F5 					= .F5,
  .F6 					= .F6,
  .F7 					= .F7,
  .F8 					= .F8,
  .F9 					= .F9,
  .F10 					= .F10,
  .F11 					= .F11,
  .F12 					= .F12,
}

sdl_mouse_btn_map := [?]Mouse_Btn_Kind{
	1 = .Left,
	2 = .Middle,
	3 = .Right,
}

sdl_create_window :: proc(
	desc:	 Window_Desc,
	arena: ^mem.Arena,
) -> (
	result: Window,
){
	scratch := mem.temp_begin(mem.scratch())
	defer mem.temp_end(scratch)

	when ODIN_OS == .Linux
	{
		deco: cstring = .Borderless in desc.props ? "0" : "1"
		sdl.SetHint("SDL_VIDEO_WAYLAND_ALLOW_LIBDECOR", deco)

		sdl.SetHint("SDL_VIDEO_DOUBLE_BUFFER", "1")
	}
	
	_ = sdl.Init({.VIDEO, .EVENTS})

	window_flags: sdl.WindowFlags
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

	for prop in desc.props do #partial switch prop
	{
	case .Fullscreen:
		window_flags += {.FULLSCREEN}
	case .Maximized:
		window_flags += {.MAXIMIZED}
	case .Resizeable:
		window_flags += {.RESIZABLE}
	case .Borderless:
		window_flags += {.BORDERLESS}
	}

	window_flags += {.TRANSPARENT}
	
  title_cstr := strings.clone_to_cstring(desc.title, mem.allocator(scratch.arena))
	sdl_window := sdl.CreateWindow(title_cstr, i32(desc.width), i32(desc.height), window_flags)

	when ODIN_OS == .Linux
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
	}
	
	imgui.CreateContext()
	imgui.StyleColorsDark()
	imgui_sdl.InitForOpenGL(sdl_window, gl_ctx)
	imgui_gl.Init(nil)

	result.handle = sdl_window
	result.draw_ctx.gl.sdl_ctx = gl_ctx
	result.imio_handle = imgui.GetIO()

  return result
}

sdl_destroy_window :: proc(window: ^Window)
{
	sdl.DestroyWindow(auto_cast window.handle)
	// imgui.DestroyContext()
	// imgui_sdl.Shutdown()
	// imgui_gl.Shutdown()
	// imgui.Shutdown()
}

sdl_gl_window_swap :: proc(window: ^Window)
{
	sdl.GL_SwapWindow(auto_cast window.handle)
}

sdl_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool

	sdl_event: sdl.Event
	result = sdl.PollEvent(&sdl_event)
	event^ = sdl_translate_event(&sdl_event)

	imgui_sdl.ProcessEvent(&sdl_event)
	imio := cast(^imgui.IO) window.imio_handle
	if imio.WantCaptureMouse && event.mouse_btn_kind != .Nil
	{
		event.kind = .Nil
	}

	// if event.kind != .NIL do fmt.println(event.key_kind)

	return result
}

sdl_pump_events :: proc()
{
	sdl.PumpEvents()
}

sdl_translate_event :: proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: 
		result = Event{kind=.Quit}
  case .KEY_DOWN:
		result = Event{
			kind = .Key_Down, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}
	case .KEY_UP:
		result = Event{
			kind = .Key_Up, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}
	case .MOUSE_BUTTON_DOWN:
		result = Event{
			kind = .Mouse_Btn_Down, 
			mouse_btn_kind = sdl_mouse_btn_map[sdl_event.button.button],
		}
	case .MOUSE_BUTTON_UP:
		result = Event{
			kind = .Mouse_Btn_Up, 
			mouse_btn_kind = sdl_mouse_btn_map[sdl_event.button.button],
		}
	}

	return result
}

sdl_imgui_begin :: proc()
{
  imgui_gl.NewFrame()
  imgui_sdl.NewFrame()
  imgui.NewFrame()
}

sdl_imgui_end :: proc()
{
  imgui.Render()
  imgui_gl.RenderDrawData(imgui.GetDrawData())
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

sdl_gl_set_proc_address :: sdl.gl_set_proc_address

