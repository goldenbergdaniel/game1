#+build !windows
#+private
package platform

import "core:fmt"
import "core:strings"
import gl "ext:opengl"
import "ext:sdl"
import "ext:imgui"
import imgui_gl "ext:imgui/imgui_impl_opengl3"
import imgui_sdl "ext:imgui/imgui_impl_sdl3"

import "../basic/mem"

sdl_key_map: #sparse [sdl.Scancode]Key_Kind = #partial {
	.A 				 = .A,
	.B 				 = .B,
	.C 				 = .C,
	.D 				 = .D,
	.E 				 = .E,
	.F 				 = .F,
	.G 				 = .G,
	.H 				 = .H,
	.I 				 = .I,
	.J 				 = .J,
	.K 				 = .K,
	.L 				 = .L,
	.M 				 = .M,
	.N 				 = .N,
	.O 				 = .O,
	.P 				 = .P,
	.Q 				 = .Q,
	.R 				 = .R,
	.S 				 = .S,
	.T 				 = .T,
	.U 				 = .U,
	.V 				 = .V,
	.W 				 = .W,
	.X 				 = .X,
	.Y 				 = .Y,
	.Z 				 = .Z,
	._0 			 = .S_0,
	._1 			 = .S_1,
	._2 			 = .S_2,
	._3 			 = .S_3,
	._4 			 = .S_4,
	._5 			 = .S_5,
	._6 			 = .S_6,
	._7 			 = .S_7,
	._8 			 = .S_8,
	._9 			 = .S_9,
	.LALT 		 = .L_ALT,
	.RALT 		 = .R_ALT,
	.LCTRL 		 = .L_CTRL,
	.RCTRL 		 = .R_CTRL,
	.LSHIFT 	 = .L_SHIFT,
	.RSHIFT 	 = .R_SHIFT,
	.SPACE 		 = .SPACE,
	.TAB 			 = .TAB,
	.RETURN 	 = .ENTER,
	.BACKSPACE = .BACKSPACE,
	.GRAVE     = .BACKTICK,
	.ESCAPE    = .ESCAPE,
}

sdl_mouse_btn_map := [?]Mouse_Btn_Kind{
	1 = .LEFT,
	2 = .MIDDLE,
	3 = .RIGHT,
}

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
			fmt.println("Dear ImGui Version:", imgui.GetVersion())
		}
	}

	// window_system_info: sdl.SysWMinfo
	// sdl.GetVersion(&window_system_info.version)
	// sdl.GetWindowWMInfo(sdl_window, &window_system_info)

	imgui.CreateContext()
	imio := imgui.GetIO()
	// imio.ConfigFlags += {.NoKeyboard}

	imgui.StyleColorsDark()

	imgui_sdl.InitForOpenGL(sdl_window, gl_ctx)
	imgui_gl.Init(nil)

	result.handle = sdl_window
	result.draw_ctx.gl.sdl_ctx = gl_ctx
	result.imio_handle = imio

  return result
}

sdl_release_os_resources :: proc(window: ^Window)
{
	sdl.DestroyWindow(auto_cast window.handle)
	// imgui.DestroyContext()
	// imgui_sdl.Shutdown()
	// imgui_gl.Shutdown()
	// imgui.Shutdown()
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

	imgui_sdl.ProcessEvent(&sdl_event)
	imio := cast(^imgui.IO) window.imio_handle
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

sdl_translate_event :: proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: 
		result = Event{kind=.QUIT}
  case .KEY_DOWN:
		result = Event{
			kind = .KEY_DOWN, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}
	case .KEY_UP:
		result = Event{
			kind = .KEY_UP, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}
	case .MOUSE_BUTTON_DOWN:
		result = Event{
			kind = .MOUSE_BTN_DOWN, 
			mouse_btn_kind = sdl_mouse_btn_map[sdl_event.button.button],
		}
	case .MOUSE_BUTTON_UP:
		result = Event{
			kind = .MOUSE_BTN_UP, 
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
