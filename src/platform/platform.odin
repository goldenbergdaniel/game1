package platform

import mem "src:basic/mem"

@(private)
EVENT_QUEUE_CAP :: 16

Window :: struct
{
  handle:      rawptr,
  event_queue: Event_Queue,
  width:       int,
  height:      int,
  should_close: bool,
  draw_ctx: struct #raw_union
  {
    metal: struct
    {
      drawable:              rawptr,
      depth_stencil_texture: rawptr,
      msaa_color_texture:    rawptr,
    },
    d3d11: struct
    {
      render_view:        rawptr,
      resolve_view:       rawptr,
      depth_stencil_view: rawptr,
    },
    opengl: struct
    {
      framebuffer: u32,
      sdl_ctx:     rawptr,
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
  SPACE,
}

Mouse_Btn_Kind :: enum u8
{
  NONE,

  LEFT,
  RIGHT,
  MIDDLE,
}

Input :: struct
{
  keys:      [Key_Kind]bool,
  prev_keys: [Key_Kind]bool,
  mouse_pos: [2]f32,
}

@(private)
input: Input

global: struct
{
  d3d11_device_ctx: rawptr,
  d3d11_device:     rawptr,
  metal_device:     rawptr,
}

create_window :: #force_inline proc(
	title:  string, 
	width:  int, 
	height: int, 
	arena:  ^mem.Arena,
) -> Window
{
	result: Window

  when ODIN_OS == .Windows do result = windows_create_window(title, width, height, arena)
  else                     do result = sdl_create_window(title, width, height, arena)

  result.width = width
  result.height = height
	init_event_queue(&result.event_queue, arena)

	return result
}

release_resources :: proc(
  window: ^Window,
)
{
  when ODIN_OS == .Windows do windows_release_os_resources(window)
	else                     do sdl_release_os_resources(window)
}

swap_buffers :: #force_inline proc(
  window: ^Window,
)
{
  when ODIN_OS != .Windows do sdl_gl_swap_buffers(window)
}

@(private)
poll_event :: #force_inline proc(
  window: ^Window, 
  event:  ^Event,
) -> bool
{
	result: bool
  
  when ODIN_OS == .Windows do result = windows_poll_event(window, event)
	else                     do result = sdl_poll_event(event)

	return result
}

pump_events :: #force_inline proc(
  window: ^Window,
)
{
  when ODIN_OS == .Windows do windows_pump_events(window)
	else                     do sdl_pump_events()

  event: Event
  for poll_event(window, &event)
  {
    switch event.kind
    {
    case .NONE:
    case .QUIT: window.should_close = true
    case .KEY_DOWN:
      switch event.key_kind
      {
      case .NONE:
      case .ESCAPE: input.keys[.ESCAPE] = true
      case .SPACE: input.keys[.ESCAPE] = true
      }
    case .KEY_UP:
      switch event.key_kind
      {
      case .NONE:
      case .ESCAPE: input.keys[.ESCAPE] = false
      case .SPACE: input.keys[.ESCAPE] = false
      }
    }
  }
}

@(private)
Event_Queue :: struct
{
  data:  []Event,
  front: int,
  back:  int,
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

is_key_pressed :: proc(key: Key_Kind) -> bool
{
  return input.keys[key]
}

is_key_just_pressed :: proc(key: Key_Kind) -> bool
{
  return false
}

is_key_released :: proc(key: Key_Kind) -> bool
{
  return !input.keys[key]
}

is_key_just_released :: proc(key: Key_Kind) -> bool
{
  return false
}

// set_window_
