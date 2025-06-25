package game

import "core:fmt"
import "core:strings"

import ma "ext:miniaudio"
import sdl "ext:sdl"

import "basic/mem"

AUDIO_CHANNELS    :: 2
AUDIO_SAMPLE_FREQ :: 48000

Sound :: struct
{
  handle: ma.sound,
}

@(thread_local, private="file")
global_engine: ma.engine

@(thread_local, private="file")
global_node_graph: ^ma.node_graph

init_audio :: proc()
{
  when false
  {
    sdl_res := sdl.InitSubSystem(sdl.INIT_AUDIO)
    if !sdl_res
    {
      panic("Failed to init SDL audio subsytem!")
    }

    desired_spec := sdl.AudioSpec{
      format = .F32,
      channels = AUDIO_CHANNELS,
      freq = AUDIO_SAMPLE_FREQ,
    }

    device := sdl.OpenAudioDevice(sdl.AUDIO_DEVICE_DEFAULT_PLAYBACK, &desired_spec)
    sdl.ResumeAudioDevice(device)
  }

  res: ma.result

  // config := ma.engine_config_init()
  // config.channels = AUDIO_CHANNELS
  // config.sampleRate = AUDIO_SAMPLE_FREQ

  res = ma.engine_init(nil, &global_engine)
  if res != .SUCCESS
  {
    fmt.panicf("Failed to init miniaudio engine!", res)
  }

  global_node_graph = cast(^ma.node_graph) &global_engine
}

uninit_audio :: proc()
{
  ma.engine_uninit(&global_engine)
}

set_audio_listener_pos :: proc(pos: f32x2)
{
  ma.engine_listener_set_position(&global_engine, 0, pos.x, pos.y, 0)
}

sound_play :: proc(
  name:   Sound_Name,
  pos:    Maybe(f32x2) = nil,
  volume: f32 = 1.0,
  pitch:  f32 = 1.0,
) -> (
  played: bool,
){
  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)

  ma_res: ma.result

  path_cstr := strings.clone_to_cstring(path, mem.allocator(scratch.arena))
  ma_res = ma.sound_init_from_file(&global_engine, path_cstr, 0, nil, nil, &sound.handle)
  if ma_res != .SUCCESS
  {
    fmt.panicf("Error: Failed to init sound!", ma_res)
  }

  ma_res = ma.sound_start(&sound.handle)
  if ma_res != .SUCCESS
  {
    fmt.panicf("Error: Failed to start sound!", ma_res)
  }
  
  return
}
