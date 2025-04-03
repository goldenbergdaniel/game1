package platform

import "../basic/mem"

@(private)
EVENT_QUEUE_CAP :: 16

Window :: struct
{
  handle:       rawptr,
  imio_handle: rawptr,
  event_queue:  Event_Queue,
  should_close: bool,
  draw_ctx:     struct #raw_union
  {
    gl:         struct
    {
      sdl_ctx:  rawptr,
    },
  },
}

Event :: struct
{
  kind:           Event_Kind,
  key_kind:       Key_Kind,
  mouse_btn_kind: Mouse_Btn_Kind,
  mouse_pos:      [2]f32,
}

Event_Kind :: enum
{
  NIL,
  QUIT,
  KEY_DOWN,
  KEY_UP,
  MOUSE_BTN_DOWN,
  MOUSE_BTN_UP,
}

Key_Kind :: enum
{
  NIL,
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z,
  S_0,
  S_1,
  S_2,
  S_3,
  S_4,
  S_5,
  S_6,
  S_7,
  S_8,
  S_9,
  L_ALT,
  R_ALT,
  L_CTRL,
  R_CTRL,
  L_SHIFT,
  R_SHIFT,
  SPACE,
  TAB,
  ENTER,
  BACKSPACE,
  BACKTICK,
  ESCAPE,
}

Mouse_Btn_Kind :: enum
{
  NIL,
  LEFT,
  RIGHT,
  MIDDLE,
}

Input :: struct
{
  keys:            [Key_Kind]bool,
  prev_keys:       [Key_Kind]bool,
  mouse_btns:      [Mouse_Btn_Kind]bool,
  prev_mouse_btns: [Mouse_Btn_Kind]bool,
  mouse_pos:       [2]f32,
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

  when ODIN_OS == .Windows
  {
    result = windows_create_window(title, width, height, arena)
	  init_event_queue(&result.event_queue, arena)
  }
  else
  {
    result = sdl_create_window(title, width, height, arena)
  }

	return result
}

release_resources :: #force_inline proc(window: ^Window)
{
  when ODIN_OS == .Windows do windows_release_os_resources(window)
	else                     do sdl_release_os_resources(window)
}

swap_buffers :: #force_inline proc(window: ^Window)
{
  when ODIN_OS != .Windows do sdl_gl_swap_buffers(window)
}

@(private)
poll_event :: #force_inline proc(window: ^Window, event:  ^Event) -> bool
{
	result: bool
  
  when ODIN_OS == .Windows do result = windows_poll_event(window, event)
	else                     do result = sdl_poll_event(window, event)

	return result
}

pump_events :: #force_inline proc(window: ^Window)
{
  when ODIN_OS == .Windows do windows_pump_events(window)
	else                     do sdl_pump_events()

  event: Event
  for poll_event(window, &event)
  {
    switch event.kind
    {
    case .NIL:
    case .QUIT: 
      window.should_close = true
    case .KEY_DOWN:
      input.keys[event.key_kind] = true
    case .KEY_UP:
      input.keys[event.key_kind] = false
    case .MOUSE_BTN_DOWN:
      input.mouse_btns[event.mouse_btn_kind] = true
    case .MOUSE_BTN_UP:
      input.mouse_btns[event.mouse_btn_kind] = false
    }
  }
}

imgui_begin :: #force_inline proc()
{
  sdl_imgui_begin()
}

imgui_end :: #force_inline proc()
{
  sdl_imgui_end()
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
  queue.data = make([]Event, EVENT_QUEUE_CAP, mem.a(arena))
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

remember_prev_input :: proc()
{
  for key in Key_Kind
  {
    input.prev_keys[key] = input.keys[key]
  }

  for btn in Mouse_Btn_Kind
  {
    input.prev_mouse_btns[btn] = input.mouse_btns[btn]
  }
}

key_pressed :: #force_inline proc(key: Key_Kind) -> bool
{
  return input.keys[key]
}

key_just_pressed :: #force_inline proc(key: Key_Kind) -> bool
{
  return input.keys[key] && !input.prev_keys[key]
}

key_released :: #force_inline proc(key: Key_Kind) -> bool
{
  return !input.keys[key]
}

key_just_released :: #force_inline proc(key: Key_Kind) -> bool
{
  return !input.keys[key] && input.prev_keys[key]
}

mouse_btn_pressed :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return input.mouse_btns[btn]
}

mouse_btn_just_pressed :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return input.mouse_btns[btn] && !input.prev_mouse_btns[btn]
}

mouse_btn_released :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return !input.mouse_btns[btn]
}

mouse_btn_just_released :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return !input.mouse_btns[btn] && input.prev_mouse_btns[btn]
}

window_toggle_fullscreen :: proc(window: ^Window)
{
  when ODIN_OS == .Windows do return
  else                     do sdl_window_toggle_fullscreen(window)
}

window_size :: #force_inline proc(window: ^Window) -> [2]i32
{
  result: [2]i32

  when ODIN_OS == .Windows do result = windows_window_size(window)
	else                     do result = sdl_window_size(window)

  return result
}

cursor_pos :: #force_inline proc() -> [2]f32
{
  result: [2]f32

  when ODIN_OS == .Windows do result = windows_cursor_pos()
	else                     do result = sdl_cursor_pos()

  return result
}
