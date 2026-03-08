package platform

import "ext:sdl"

Input :: struct
{
  keys:           [Key_Kind]bool,
  mouse_btns:     [Mouse_Btn_Kind]bool,
  key_down:       bool,
  mouse_btn_down: bool,
  mouse_scroll:   [2]f32,
}

Input_Source :: union
{
  Key_Kind,
  Mouse_Btn_Kind,
}

Key_Kind :: enum
{
  Nil,
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
  Open_Bracket,
  Close_Bracket,
  Forward_Slash,
  Backward_Slash,
  Semicolon,
  Apostrophe,
  Comma,
  Period,
  Backtick,
  Left_Alt,
  Right_Alt,
  Left_Ctrl,
  Right_Ctrl,
  Left_Shift,
  Right_Shift,
  Up,
  Down,
  Left,
  Right,
  Page_Up,
  Page_Down,
  Space,
  Tab,
  Enter,
  Backspace,
  Escape,
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
  Nil,
  Left,
  Right,
  Middle,
}

global_input: ^Input = &{}

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

sdl_translate_event :: proc(sdl_event: ^sdl.Event) -> Event
{
	result: Event

	#partial switch sdl_event.type
	{
	case .QUIT: 
		result = Event{kind=.Quit}

  case .KEY_DOWN:
    global_input.key_down = true
		result = Event{
			kind = .Key_Down, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}

	case .KEY_UP:
    global_input.key_down = false
		result = Event{
			kind = .Key_Up, 
			key_kind = sdl_key_map[sdl_event.key.scancode],
		}

	case .MOUSE_BUTTON_DOWN:
    global_input.mouse_btn_down = true
		result = Event{
			kind = .Mouse_Btn_Down, 
			mouse_btn_kind = sdl_mouse_btn_map[sdl_event.button.button],
		}

	case .MOUSE_BUTTON_UP:
    global_input.mouse_btn_down = false
		result = Event{
			kind = .Mouse_Btn_Up, 
			mouse_btn_kind = sdl_mouse_btn_map[sdl_event.button.button],
		}

  case .MOUSE_WHEEL:
    global_input.mouse_scroll.x += sdl_event.wheel.x
    global_input.mouse_scroll.y += sdl_event.wheel.y
	}

	return result
}

@(require_results)
any_key_down :: proc() -> bool
{
  return global_input.key_down
}

@(require_results)
any_mouse_btn_down :: proc() -> bool
{
  return global_input.mouse_btn_down
}

@(require_results)
key_down :: proc(key: Key_Kind) -> bool
{
  return global_input.keys[key]
}

@(require_results)
key_up :: proc(key: Key_Kind) -> bool
{
  return !global_input.keys[key]
}

consume_key :: proc(key: Key_Kind)
{
  global_input.keys[key] = false
}

@(require_results)
mouse_btn_down :: proc(btn: Mouse_Btn_Kind) -> bool
{
  return global_input.mouse_btns[btn]
}

@(require_results)
mouse_btn_up :: proc(btn: Mouse_Btn_Kind) -> bool
{
  return !global_input.mouse_btns[btn]
}

consume_mouse_btn :: proc(btn: Mouse_Btn_Kind)
{
  global_input.mouse_btns[btn] = false
}

@(require_results)
input_down :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case Key_Kind:       return key_down(v)
  case Mouse_Btn_Kind: return mouse_btn_down(v)
  case:                return false
  }
}

@(require_results)
input_up :: proc(input: Input_Source) -> bool
{
  switch v in input
  {
  case Key_Kind:       return key_up(v)
  case Mouse_Btn_Kind: return mouse_btn_up(v)
  case:                return false
  }
}

consume_input :: proc(input: Input_Source)
{
  switch v in input
  {
  case Key_Kind:       consume_key(v)
  case Mouse_Btn_Kind: consume_mouse_btn(v)
  }
}
