#+build darwin
package platform

import ns "core:sys/darwin/Foundation"

import mem "src:basic/mem"

@(private)
darwin_create_window :: proc(
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
darwin_release_os_resources :: proc(window: ^Window)
{

}

@(private)
darwin_create_draw_context :: proc(window: ^Window)
{
	
}

@(private)
darwin_poll_event :: proc(window: ^Window, event: ^Event) -> bool
{
	result: bool

  return result
}

@(private)
darwin_pump_events :: proc(window: ^Window)
{

}
