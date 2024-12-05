#+build linux
package platform

import mem "src:basic/mem"

@(private)
linux_create_window :: proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena
) -> Window
{
	result: Window

	return result
}

@(private)
linux_release_os_resources :: proc(window: ^Window)
{

}

@(private)
linux_create_draw_context :: proc(window: ^Window)
{
	
}

@(private)
linux_gl_swap_buffers :: proc(window: ^Window)
{
	
}

@(private)
linux_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool

	return result
}

@(private)
linux_pump_events :: proc(window: ^Window)
{
	
}
