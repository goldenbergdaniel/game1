#+feature using-stmt
package vk_demo

import "core:fmt"
import "core:math"
import "../game/basic/vmath"
import "../game/platform"

CAMERA_FOV           :: 80
CAMERA_ZOOM_MULT     :: 4
CAMERA_MOV_SPEED     :: 0.05
CAMERA_SENSITIVITY_H :: 0.5
CAMERA_SENSITIVITY_V :: 0.5

Game :: struct
{
  prev_keys:         [platform.Key_Kind]bool,
  prev_mouse_btns:   [platform.Mouse_Btn_Kind]bool,
  prev_cursor_pos:   v2f,
  projection:        m4x4f,
  t:                 f32,
  movement_mode:     enum{Free_Fly, Grounded},
  camera:            Camera,
  player:            Entity,
  double_jump_timer: Timer,
}

Camera :: struct
{
  pos:   v3f,
  front: v3f,
  right: v3f,
  up:    v3f,
  pitch: f32,
  yaw:   f32,
  roll:  f32,
  fov:   f32,
}

Entity :: struct
{
  pos:   v3f,
  rot:   v3f,
  vel:   v3f,
  scale: v3f,
}

Timer :: struct
{
  stop_time: f32,
  ticking:   bool,
}

@(private="file")
_current_game: ^Game

cube: Entity
window_focused: bool

get_current_game :: #force_inline proc(location := #caller_location) -> ^Game
{
  assert(_current_game != nil, loc=location)
  return _current_game
}

set_current_game :: #force_inline proc(gm: ^Game)
{
  _current_game = gm
}

start :: proc(using gm: ^Game)
{
  // camera.pos = {0, 2, 0}
  camera.pos = {0, 0, 0}
  camera.yaw = -90
  camera.fov = CAMERA_FOV

  cube.pos = {0, -1, -3}
  cube.rot = {-90, 0, 0}
  cube.scale = {1.0, 1.0, 1.0}

  movement_mode = .Free_Fly
}

update :: proc(using gm: ^Game, dt: f32)
{
  set_current_game(gm)

  window_size := platform.window_get_size(&user.window)
  cursor_pos := platform.get_cursor_position()
  mouse_scroll := platform.get_mouse_scroll()

  if !window_focused && mouse_btn_down(.Left)
  {
    window_focused = true
    platform.window_set_relative_cursor(&user.window, true)
    platform.consume_mouse_btn(.Left)
  }
  else if key_just_down(.Escape)
  {
    window_focused = false
    platform.window_set_relative_cursor(&user.window, false)
    platform.consume_key(.Escape)
  }

  if window_focused
  {
    cursor_offset := cursor_pos - gm.prev_cursor_pos
    gm.camera.yaw -= (cursor_offset.x / 5) * CAMERA_SENSITIVITY_H
    gm.camera.pitch -= (cursor_offset.y / 5) * CAMERA_SENSITIVITY_V

    gm.camera.fov -= mouse_scroll.y * CAMERA_ZOOM_MULT
    gm.camera.fov = clamp(camera.fov, 1, 120)
  }

  if gm.camera.pitch > 89
  {
    gm.camera.pitch = 89
  }
  else if gm.camera.pitch < -89
  {
    gm.camera.pitch = -89
  }

  if key_down(.Q)
  {
    gm.camera.roll = 15
  }
  else if key_down(.E)
  {
    gm.camera.roll = -15
  }
  else
  {
    gm.camera.roll = 0
  }

  camera_dir: v3f
  camera_dir.x = math.cos(gm.camera.yaw/math.DEG_PER_RAD) * math.cos(gm.camera.pitch/math.DEG_PER_RAD)
  camera_dir.y = math.sin(gm.camera.pitch/math.DEG_PER_RAD)
  camera_dir.z = math.sin(gm.camera.yaw/math.DEG_PER_RAD) * math.cos(gm.camera.pitch/math.DEG_PER_RAD)
  camera.front = vmath.normalize(camera_dir)
  camera.right = vmath.normalize(vmath.cross(v3f{0, 1, 0}, gm.camera.front))
  camera.up    = vmath.cross(gm.camera.front, gm.camera.right)

  if key_just_down(.P)
  {
    if gm.movement_mode == .Free_Fly
    {
      gm.movement_mode = .Grounded
    }
    else
    {
      gm.movement_mode = .Free_Fly
    }

    fmt.println("[INFO][game]: Switched to", gm.movement_mode)
  }

  speed_mul: f32 = 1.0
  if key_down(.Left_Ctrl)
  {
    speed_mul = 2.0
  }
  else if key_down(.Left_Alt)
  {
    speed_mul = 0.5
  }

  switch gm.movement_mode
  {
  case .Grounded:
    if key_down(.W) && !key_down(.S)
    {
      dir := gm.camera.front
      dir.y = 0
      dir = vmath.normalize(dir)

      gm.camera.pos += dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.S) && !key_down(.W)
    {
      dir := gm.camera.front
      dir.y = 0
      dir = vmath.normalize(dir)

      gm.camera.pos -= dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.D) && !key_down(.A)
    {
      dir := gm.camera.right
      dir.y = 0
      dir = vmath.normalize(dir)
      gm.camera.pos += dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.A) && !key_down(.D)
    {
      dir := gm.camera.right
      dir.y = 0
      dir = vmath.normalize(dir)
      gm.camera.pos -= dir * CAMERA_MOV_SPEED * speed_mul
    }

    if camera.pos.y <= 0
    {
      player.vel.y = 0
    }

    player.vel.y -= 0.2 * dt

    if key_down(.Space) && camera.pos.y <= 0
    {
      player.vel.y += 0.7
    }

    camera.pos.y += player.vel.y * dt
    camera.pos.y = max(camera.pos.y, 0)

  case .Free_Fly:
    if key_down(.W) && !key_down(.S)
    {
      dir := gm.camera.front
      dir.y = 0
      dir = vmath.normalize(dir)

      gm.camera.pos += dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.S) && !key_down(.W)
    {
      dir := gm.camera.front
      dir.y = 0
      dir = vmath.normalize(dir)

      gm.camera.pos -= dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.D) && !key_down(.A)
    {
      dir := gm.camera.right
      dir.y = 0
      dir = vmath.normalize(dir)
      
      gm.camera.pos += dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.A) && !key_down(.D)
    {
      dir := gm.camera.right
      dir.y = 0
      dir = vmath.normalize(dir)

      gm.camera.pos -= dir * CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.Space) && !key_down(.Left_Shift)
    {
      gm.camera.pos.y += CAMERA_MOV_SPEED * speed_mul
    }

    if key_down(.Left_Shift) && !key_down(.Space)
    {
      gm.camera.pos.y -= CAMERA_MOV_SPEED * speed_mul
    }
  }

  if key_down(.R)
  {
    camera.pos = {0, 0, 0}
    camera.yaw = -90
    camera.pitch = 0
    camera.roll = 0
    camera.fov = CAMERA_FOV
  }

  // cube.rot.z += dt/2

  // print_camera(gm.camera)

  gm.projection = vmath.IDENTITY_4X4F

  gm.projection *= vmath.perspective(gm.camera.fov/math.DEG_PER_RAD, window_size.x/window_size.y, 0.1, 1000)

  gm.projection *= vmath.rotation_4x4f(gm.camera.roll/math.DEG_PER_RAD, gm.camera.front)
  gm.projection *= vmath.lookat(gm.camera.pos, gm.camera.front, gm.camera.right, gm.camera.up)

  gm.projection *= vmath.translation_4x4f(cube.pos)
  gm.projection *= vmath.scale_4x4f(cube.scale)
  gm.projection *= vmath.rotation_4x4f(cube.rot.x/math.DEG_PER_RAD, {1, 0, 0})
  gm.projection *= vmath.rotation_4x4f(cube.rot.y/math.DEG_PER_RAD, {0, 1, 0})
  gm.projection *= vmath.rotation_4x4f(cube.rot.z/math.DEG_PER_RAD, {0, 0, 1})

  gm.prev_keys = platform.global_input.keys
  gm.prev_mouse_btns = platform.global_input.mouse_btns
  gm.prev_cursor_pos = platform.get_cursor_position()
  platform.reset_mouse_scroll()

  set_current_game(nil)
}

print_camera :: proc(camera: Camera)
{
  fmt.printf("pos: <%f, %f, %f>\n", camera.pos.x, camera.pos.y, camera.pos.z)
  fmt.printf("ypr: <%f, %f, %f>\n", camera.yaw, camera.pitch, camera.roll)
  fmt.printf("fov: <%f, %f>\n", camera.fov)
  fmt.printf("f:   <%f, %f, %f>\n", camera.front.x, camera.front.y, camera.front.z)
  fmt.printf("r:   <%f, %f, %f>\n", camera.right.x, camera.right.y, camera.right.z)
  fmt.printf("u:   <%f, %f, %f>\n", camera.up.x, camera.up.y, camera.up.z)
}

// Timer ///////////////////////////////////////////////////////////////////////////////////

timer_start :: proc(timer: ^Timer, duration: f32)
{
  timer.stop_time = get_current_game().t + duration
  timer.ticking = true
}

timer_timeout :: proc(timer: ^Timer) -> bool
{
  return timer.ticking && timer.stop_time <= get_current_game().t
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
