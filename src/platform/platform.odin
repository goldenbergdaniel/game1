package platform

import mem "src:basic/mem"

USE_SDL :: #config(USE_SDL, false)

@(private)
EVENT_QUEUE_CAP :: 16

Window :: struct
{
  handle: rawptr,
  event_queue: Event_Queue,
  width: int,
  height: int,
  draw_ctx: struct #raw_union
  {
    metal: struct
    {
      drawable: rawptr,
      depth_stencil_texture: rawptr,
      msaa_color_texture: rawptr,
    },
    d3d11: struct
    {
      render_view: rawptr,
      resolve_view: rawptr,
      depth_stencil_view: rawptr,
    },
    opengl: struct
    {
      framebuffer: u32,
      sdl_ctx: rawptr,
    },
  },
}

Event :: struct
{
  kind: Event_Kind,
  key_kind: Key_Kind,
  mouse_btn_kind: Mouse_Btn_Kind,
  mouse_pos: [2]f32,
}

Event_Kind :: enum u16
{
  NONE,

  QUIT,
  KEY_DOWN,
  KEY_UP,
}

Key_Kind :: enum u8
{
  NONE,

  ESCAPE,
}

Mouse_Btn_Kind :: enum u8
{
  NONE,

  LEFT,
  RIGHT,
  MIDDLE,
}

global: struct
{
  metal_device: rawptr,
  d3d11_device: rawptr,
  d3d11_device_ctx: rawptr,
}

create_window :: #force_inline proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena
) -> Window
{
	result: Window

	when USE_SDL                  do result = sdl_create_window(title, width, height, arena)
	else when ODIN_OS == .Darwin  do result = darwin_create_window(title, width, height, arena)
  else when ODIN_OS == .Linux   do result = linux_create_window(title, width, height, arena)
  else when ODIN_OS == .Windows do result = windows_create_window(title, width, height, arena)

  result.width = width
  result.height = height
	init_event_queue(&result.event_queue, arena)

	return result
}

release_os_resources :: proc(
  window: ^Window,
)
{
	when USE_SDL                  do sdl_release_os_resources(window)
	else when ODIN_OS == .Darwin  do darwin_release_os_resources(window)
  else when ODIN_OS == .Linux   do linux_release_os_resources(window)
  else when ODIN_OS == .Windows do windows_release_os_resources(window)
}

swap_buffers :: #force_inline proc(
  window: ^Window
)
{
  when ODIN_OS == .Linux
  {
    when USE_SDL do sdl_gl_swap_buffers(window)
    else do linux_gl_swap_buffers(window)
  }
}

poll_event :: #force_inline proc(
  window: ^Window, 
  event: ^Event
) -> bool
{
	result: bool

	when USE_SDL                  do result = sdl_poll_event(window, event)
	else when ODIN_OS == .Darwin  do result = darwin_poll_event(window, event)
	else when ODIN_OS == .Linux   do result = linux_poll_event(window, event)
  else when ODIN_OS == .Windows do result = windows_poll_event(window, event)

	return result
}

pump_events :: #force_inline proc(
  window: ^Window
)
{
	when USE_SDL                  do sdl_pump_events(window)
	else when ODIN_OS == .Darwin  do darwin_pump_events(window)
  else when ODIN_OS == .Linux   do linux_pump_events(window)
  else when ODIN_OS == .Windows do windows_pump_events(window)
}

@(private)
Event_Queue :: struct
{
  data: []Event,
  front: int,
  back: int,
}

@(private)
init_event_queue :: proc(queue: ^Event_Queue, arena: ^mem.Arena)
{
  queue.data = make([]Event, EVENT_QUEUE_CAP, mem.allocator(arena))
}

@(private)
push_event :: proc(queue: ^Event_Queue, event: Event)
{
  queue.data[queue.back] = event
  queue.back += 1
}

@(private)
pop_event :: proc(queue: ^Event_Queue) -> ^Event
{
  result: ^Event

  if queue.front == queue.back
  {
    queue.front = 0
    queue.back = 0
  }
  else
  {
    result = &queue.data[queue.front]
    queue.front += 1
  }

  return result
}
