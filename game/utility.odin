package game

import "platform"


// Timer /////////////////////////////////////////////////////////////////////////////////


Timer :: struct
{
  end_time: f32,
  ticking:  bool,
}

timer_start :: proc(timer: ^Timer, duration: f32)
{
  timer.end_time = get_current_game().t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> bool
{
  return timer.ticking && get_current_game().t >= timer.end_time
}

timer_remaining :: proc(timer: ^Timer) -> f32
{
  return timer.end_time - get_current_game().t
}


// Input ///////////////////////////////////////////////////////////////////////////////////


key_down :: platform.key_down
key_up   :: platform.key_up

@(require_results)
key_just_down :: proc(key: platform.Key_Kind) -> bool
{
  return key_down(key) && !get_current_game().prev_keys[key]
}

@(require_results)
key_just_up :: proc(key: platform.Key_Kind) -> bool
{
  return key_up(key) && get_current_game().prev_keys[key]
}

mouse_btn_down :: platform.mouse_btn_down
mouse_btn_up   :: platform.mouse_btn_up

@(require_results)
mouse_btn_just_down :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_down(btn) && !get_current_game().prev_mouse_btns[btn]
}

@(require_results)
mouse_btn_just_up :: proc(btn: platform.Mouse_Btn_Kind) -> bool
{
  return mouse_btn_up(btn) && get_current_game().prev_mouse_btns[btn]
}

input_down :: platform.input_down
input_up   :: platform.input_up

@(require_results)
input_just_down :: proc(input: platform.Input_Source) -> bool
{
  switch v in input
  {
  case platform.Key_Kind:       return key_just_down(v)
  case platform.Mouse_Btn_Kind: return mouse_btn_down(v)
  case:                         return false
  }
}

@(require_results)
input_just_up :: proc(input: platform.Input_Source) -> bool
{
  switch v in input
  {
  case platform.Key_Kind:       return key_just_up(v)
  case platform.Mouse_Btn_Kind: return mouse_btn_just_up(v)
  case:                         return false
  }
}
