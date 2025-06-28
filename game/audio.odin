package game

import "core:strings"

import ma "ext:miniaudio"
// import sdl "ext:sdl"

import "basic/mem"

// AUDIO_CHANNELS    :: 2
// AUDIO_SAMPLE_FREQ :: 48000

AUDIO_MAX_EFFECTS :: 512
AUDIO_WORLD_SCALE :: 0.01

Sound :: struct
{
  path:  string,
  group: Sound_Group,
}

Audio_Data :: struct
{
  engine:      ma.engine,
  enabled:     bool,

  ambience:    ma.sound,
  music:       ma.sound,
  effects:     [AUDIO_MAX_EFFECTS]ma.sound,
  effects_pos: int,
}

global_audio: Audio_Data

init_audio :: proc()
{
  // sdl_res := sdl.InitSubSystem(sdl.INIT_AUDIO)
  // if !sdl_res
  // {
  //   println("Failed to init SDL audio subsystem!")
  //   return
  // }

  // desired_spec := sdl.AudioSpec{
  //   format = .F32,
  //   channels = AUDIO_CHANNELS,
  //   freq = AUDIO_SAMPLE_FREQ,
  // }

  // device := sdl.OpenAudioDevice(sdl.AUDIO_DEVICE_DEFAULT_PLAYBACK, &desired_spec)
  // sdl.ResumeAudioDevice(device)

  result: ma.result

  config := ma.engine_config_init()
  config.listenerCount = 1
  // config.channels = AUDIO_CHANNELS
  // config.sampleRate = AUDIO_SAMPLE_FREQ

  result = ma.engine_init(&config, &global_audio.engine)
  if result != .SUCCESS
  {
    println("Failed to init miniaudio engine!", res)
    return
  }

  global_audio.enabled = true
}

uninit_audio :: proc()
{
  ma.engine_uninit(&global_audio.engine)
}

clean_audio :: proc()
{
  if !global_audio.enabled do return

  for &sound in global_audio.effects
  {
    if ma.sound_at_end(&sound)
    {
      ma.sound_uninit(&sound)
    }
  }
}

play_sound :: proc(
  name:   Sound_Name,
  pos:    Maybe(f32x2) = nil,
  volume: f32 = 1.0,
  pitch:  f32 = 1.0,
) -> (
  ok: bool,
){
  if !global_audio.enabled do return false

  result: ma.result

  sound_desc := res.sounds[name]
  switch sound_desc.group
  {
  case .NIL:
  
  case .AMBIENCE, .MUSIC:
    sound: ^ma.sound
    #partial switch sound_desc.group
    {
    case .AMBIENCE: sound = &global_audio.ambience
    case .MUSIC:    sound = &global_audio.music
    }

    if !ma.sound_is_playing(sound) && !ma.sound_at_end(sound)
    {
      ma_sound_init(sound, res.sounds[name].path) or_return
      ma.sound_set_looping(sound, true)
      ma.sound_set_spatialization_enabled(sound, false)

      result = ma.sound_start(sound)
      if result != .SUCCESS
      {
        printf("Error: Failed to start sound %s! %s\n", name, result)
        return false
      }
    }
  
  case .EFFECT:
    sound := next_sound_effect()
    ma_sound_init(sound, res.sounds[name].path) or_return

    if pos != nil
    {
      pos := pos.? * AUDIO_WORLD_SCALE
      ma.sound_set_position(sound, pos.x, pos.y, 0)
      ma.sound_set_spatialization_enabled(sound, true)
    }
    else
    {
      ma.sound_set_spatialization_enabled(sound, false)
    }

    ma.sound_set_volume(sound, volume)
    ma.sound_set_pitch(sound, pitch)

    result = ma.sound_start(sound)
    if result != .SUCCESS
    {
      printf("Error: Failed to start sound %s! %s\n", result)
      return false
    }
  }

  return true
}

pause_sound :: proc(
  name: Sound_Name,
) -> (
  ok: bool,
){
  if !global_audio.enabled do return false

  result: ma.result

  sound_desc := res.sounds[name]
  switch sound_desc.group
  {
  case .NIL, .EFFECT:
    ok = false
  case .AMBIENCE:
    result = ma.sound_stop(&global_audio.ambience)
    ok = true
  case .MUSIC:
    result = ma.sound_stop(&global_audio.music)
    ok = true
  }

  if result != .SUCCESS
  {
    printf("Error: Failed to pause sound %s! %s\n", name, result)
    ok = false
  }

  return
}

reset_sound :: proc(
  name: Sound_Name, 
) -> (
  ok: bool,
){
  if !global_audio.enabled do return false

  result: ma.result

  sound_desc := res.sounds[name]
  switch sound_desc.group
  {
  case .NIL, .EFFECT:
    ok = false
  case .AMBIENCE:
    result = ma.sound_seek_to_pcm_frame(&global_audio.ambience, 0)
    ok = true
  case .MUSIC:
    result = ma.sound_seek_to_pcm_frame(&global_audio.music, 0)
    ok = true
  }

  if result != .SUCCESS
  {
    printf("Error: Failed to reset sound %s! %s\n", name, result)
    ok = false
  }

  return
}

set_audio_listener_pos :: proc(pos: f32x2)
{
  if !global_audio.enabled do return

  pos := pos * AUDIO_WORLD_SCALE
  ma.engine_listener_set_position(&global_audio.engine, 0, pos.x, pos.y , 0)
}

@(private="file")
next_sound_effect :: proc() -> ^ma.sound
{
  idx := global_audio.effects_pos % len(global_audio.effects)
  result := &global_audio.effects[idx]
  global_audio.effects_pos += 1
  result^ = {}
  return result
}

@(private="file")
ma_sound_init :: proc(ma_sound: ^ma.sound, path: string) -> (ok: bool)
{
  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)

  path_cstr := strings.clone_to_cstring(path, mem.allocator(scratch.arena))
  ma_res := ma.sound_init_from_file(&global_audio.engine, path_cstr, 0, nil, nil, ma_sound)
  if ma_res != .SUCCESS
  {
    printf("Error: Failed to init sound %s! %s\n", path, ma_res)
    return false
  }

  return true
}
