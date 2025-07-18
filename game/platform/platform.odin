package platform

import "../basic/mem"

@(private)
EVENT_QUEUE_CAP :: 16

Window :: struct
{
  handle:       rawptr,
  imio_handle:  rawptr,
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

Window_Props :: enum
{
  FULLSCREEN,
  RESIZEABLE,
  MAXIMIZED,
}

Window_Desc :: struct
{
  title:  string,
  width:  int,
  height: int,
  props:  bit_set[Window_Props],
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
  OPEN_BRACKET,
  CLOSE_BRACKET,
  FWD_SLASH,
  BWD_SLASH,
  SEMICOLON,
  APOSTROPHE,
  COMMA,
  PERIOD,
  BACKTICK,
  LEFT_ALT,
  RIGHT_ALT,
  LEFT_CTRL,
  RIGHT_CTRL,
  LEFT_SHIFT,
  RIGHT_SHIFT,
  UP,
  DOWN,
  LEFT,
  RIGHT,
  PAGE_UP,
  PAGE_DOWN,
  SPACE,
  TAB,
  ENTER,
  BACKSPACE,
  ESCAPE,
  F1,
  F2,
  F3,
  F4,
  F5,
  F6,
  F7,
  F8,
  F9,
  F10,
  F11,
  F12,
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

Input_Source :: union
{
  Key_Kind,
  Mouse_Btn_Kind,
}

global_input: ^Input = &{}

// global: struct
// {
//   d3d11_device_ctx: rawptr,
//   d3d11_device:     rawptr,
//   metal_device:     rawptr,
// }

create_window :: #force_inline proc(
	desc:  Window_Desc,
	arena: ^mem.Arena,
) -> (
  result: Window,
){
  when ODIN_OS == .Windows
  {
    result = windows_create_window(desc.title, desc.width, desc.height, arena)
	  init_event_queue(&result.event_queue, arena)
  }
  else
  {
    result = sdl_create_window(desc, arena)
  }

	return result
}

destroy_window :: #force_inline proc(window: ^Window)
{
  when ODIN_OS == .Windows do windows_release_os_resources(window)
	else                     do sdl_destroy_window(window)
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

window_swap :: #force_inline proc(window: ^Window)
{
  when ODIN_OS != .Windows do sdl_gl_window_swap(window)
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
      global_input.keys[event.key_kind] = true
    case .KEY_UP:
      global_input.keys[event.key_kind] = false
    case .MOUSE_BTN_DOWN:
      global_input.mouse_btns[event.mouse_btn_kind] = true
    case .MOUSE_BTN_UP:
      global_input.mouse_btns[event.mouse_btn_kind] = false
    }
  }
}

imgui_begin :: #force_inline proc()
{
  when ODIN_OS == .Windows do windows_imgui_begin()
  else                     do sdl_imgui_begin()
}

imgui_end :: #force_inline proc()
{
  when ODIN_OS == .Windows do windows_imgui_end()
  else                     do sdl_imgui_end()
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

save_input :: proc()
{
  for key in Key_Kind
  {
    global_input.prev_keys[key] = global_input.keys[key]
  }

  for btn in Mouse_Btn_Kind
  {
    global_input.prev_mouse_btns[btn] = global_input.mouse_btns[btn]
  }
}

key_pressed :: #force_inline proc(key: Key_Kind) -> bool
{
  return global_input.keys[key]
}

key_just_pressed :: #force_inline proc(key: Key_Kind) -> bool
{
  return global_input.keys[key] && !global_input.prev_keys[key]
}

key_released :: #force_inline proc(key: Key_Kind) -> bool
{
  return !global_input.keys[key]
}

key_just_released :: #force_inline proc(key: Key_Kind) -> bool
{
  return !global_input.keys[key] && global_input.prev_keys[key]
}

mouse_btn_pressed :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return global_input.mouse_btns[btn]
}

mouse_btn_just_pressed :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return global_input.mouse_btns[btn] && !global_input.prev_mouse_btns[btn]
}

mouse_btn_released :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return !global_input.mouse_btns[btn]
}

mouse_btn_just_released :: #force_inline proc(btn: Mouse_Btn_Kind) -> bool
{
  return !global_input.mouse_btns[btn] && global_input.prev_mouse_btns[btn]
}

input_pressed :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case:                return false
  case Key_Kind:       return key_pressed(v)
  case Mouse_Btn_Kind: return mouse_btn_pressed(v)
  }
}

input_just_pressed :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case:                return false
  case Key_Kind:       return key_just_pressed(v)
  case Mouse_Btn_Kind: return mouse_btn_just_pressed(v)
  }
}

input_released :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case:                return false
  case Key_Kind:       return key_released(v)
  case Mouse_Btn_Kind: return mouse_btn_released(v)
  }
}

input_just_released :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case:                return false
  case Key_Kind:       return key_just_released(v)
  case Mouse_Btn_Kind: return mouse_btn_just_released(v)
  }
}

cursor_position :: #force_inline proc() -> [2]f32
{
  result: [2]f32

  when ODIN_OS == .Windows do result = windows_cursor_pos()
	else                     do result = sdl_cursor_pos()

  return result
}

gl_set_proc_address :: sdl_gl_set_proc_address
