package game

import "base:intrinsics"
import "core:fmt"
import "core:time"
import ft "ext:freetype"
import "basic"
import "basic/mem"
import "platform"
import "render"
import tt "transform_tree"

WORLD_WIDTH  :: 320.0
WORLD_HEIGHT :: 180.0
WORLD_TEXEL  :: 16.0
WORLD_STEP   :: 1.0/50

User :: struct
{
  window:      platform.Window,
  viewport:    f32x4,
  perm_arena:  mem.Arena,
  frame_arena: mem.Arena,
  show_dbgui:  bool,
}

user: User

update_start_tick, update_end_tick: time.Tick
render_start_tick, render_end_tick: time.Tick
curr_game, prev_game, res_game: Game

freetype_test :: proc()
{
  err: ft.Error
  
  library: ft.Library
  err = ft.init_free_type(&library)
  if err != nil
  {
    println("Error initializing freetype!", err)
  }

  face: ft.Face
  ft.new_face(library, "res/fonts/Jersey10.ttf", 0, &face)
  if err != nil
  {
    println("Error reading font file!", err)
  }

  // println(face)
}

main :: proc()
{
  _ = mem.arena_init_static(&user.perm_arena)
  _ = mem.arena_init_growing(&user.frame_arena)

  freetype_test()

  window_desc := platform.Window_Desc{
    title = "GAME",
    width = 960,
    height = 540,
    props = {.FULLSCREEN, .VSYNC, .RESIZEABLE},
  }

  user.window = platform.create_window(window_desc, &user.perm_arena)
  defer platform.destroy_window(&user.window)

  init_resources(&user.perm_arena)
  render.init(&user.window, {0, WORLD_WIDTH, 0, WORLD_HEIGHT}, &res.textures)
  init_audio()
  init_global()

  init_game(&curr_game)
  start_game(&curr_game)

  elapsed_time, accumulator: f64
  start_tick := time.tick_now()

  for !user.window.should_close
  {
    platform.pump_events(&user.window)

    // - Update viewport ---
    {
      window_size := basic.array_cast(platform.window_size(&user.window), f32)
      ratio := window_size.x / window_size.y
      if ratio >= WORLD_WIDTH / WORLD_HEIGHT
      {
        img_width := window_size.x / (ratio * (WORLD_HEIGHT / WORLD_WIDTH))
        user.viewport = {(window_size.x - img_width) / 2, 0, img_width, window_size.y}
      }
      else
      {
        img_height := window_size.y * (ratio / (WORLD_WIDTH / WORLD_HEIGHT))
        user.viewport = {0, (window_size.y - img_height) / 2, window_size.x, img_height}
      }
      
      render.set_viewport(basic.array_cast(user.viewport, i32))
    }

    curr_time := time.duration_seconds(time.tick_since(start_tick))
    frame_time := curr_time - elapsed_time
    elapsed_time = curr_time
    accumulator += frame_time
    
    for accumulator >= WORLD_STEP
    {
      update_start_tick = time.tick_now()
      
      copy_game(&prev_game, &curr_game)
      update_game(&curr_game, WORLD_STEP * curr_game.t_mult)
      platform.remember_prev_input()
 
      // if frame_time * 1000 > 20 do printf("%.0f ms\n", frame_time * 1000)

      curr_game.t += WORLD_STEP * curr_game.t_mult
      accumulator -= WORLD_STEP

      update_end_tick = time.tick_now()
    }

    render_start_tick = time.tick_now()

    alpha := accumulator / WORLD_STEP
    interpolate_games(&curr_game, &prev_game, &res_game, f32(alpha))
    render_game(&res_game)

    render_end_tick = time.tick_now()

    if user.show_dbgui
    {
      platform.imgui_begin()
      update_debug_gui(&curr_game, WORLD_STEP * curr_game.t_mult)
      platform.imgui_end()
    }

    platform.window_swap(&user.window)
  }
}

f32x2 :: [2]f32
f32x3 :: [3]f32
f32x4 :: [4]f32

m2f32 :: matrix[2,2]f32
m3f32 :: matrix[3,3]f32

Range :: basic.Range

range_overlap :: basic.range_overlap
array_cast    :: basic.array_cast
approc        :: basic.approx
rad_from_deg  :: basic.rad_from_deg
deg_from_rad  :: basic.deg_from_rad

print   :: fmt.print
printf  :: fmt.printf
println :: fmt.println
panicf  :: fmt.panicf
