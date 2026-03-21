package game

import "core:log"
import "core:strings"
import ma "ext:miniaudio"
import "basic/mem"

@(private="file")
MAX_EFFECTS :: 256

@(private="file")
WORLD_SCALE :: 0.01

Sound :: struct
{
  path:  string,
  group: Sound_Group,
}

@(private="file")
audio: struct
{
  engine:          ma.engine,
  ambience:        ma.sound,
  music:           ma.sound,
  effects:         [MAX_EFFECTS]ma.sound,
  effects_pos:     int,
  looping_effects: [dynamic]ma.sound,
  initialized:     bool,
}

init_audio :: proc()
{
  config := ma.engine_config_init()
  config.listenerCount = 1

  result := ma.engine_init(&config, &audio.engine)
  if result != .SUCCESS
  {
    log.errorf("[audio]: Failed to init miniaudio engine! (%s)", result)
    uninit_audio()
    return
  }

  audio.initialized = true
}

uninit_audio :: proc()
{
  ma.engine_uninit(&audio.engine)
}

free_finished_sounds :: proc()
{
  if !audio.initialized do return

  for &sound in audio.effects
  {
    if ma.sound_at_end(&sound)
    {
      ma.sound_uninit(&sound)
    }
  }
}

play_sound :: proc(
  name:   Sound_Name,
  volume: f32 = 1.0,
  pitch:  f32 = 1.0,
  pos:    Maybe(v2f32) = nil,
) -> (
  ok: bool,
){
  if !audio.initialized do return false

  result: ma.result
  sound: ^ma.sound
  sound_desc := res.sounds[name]
  
  switch sound_desc.group
  {
  case .Nil:
    
  case .Ambience:
    sound = &audio.ambience
    if !ma.sound_is_playing(sound) || ma.sound_at_end(sound)
    {
      ma_sound_init(sound, sound_desc.path) or_return
      ma.sound_set_looping(sound, true)
      ma.sound_set_spatialization_enabled(sound, false)
      ma.sound_set_volume(sound, volume)
      ma.sound_set_pitch(sound, pitch)
    }

  case .Music:
    sound = &audio.music
    if !ma.sound_is_playing(sound) || ma.sound_at_end(sound)
    {
      ma_sound_init(sound, sound_desc.path) or_return
      ma.sound_set_looping(sound, true)
      ma.sound_set_spatialization_enabled(sound, false)
      ma.sound_set_volume(sound, volume)
      ma.sound_set_pitch(sound, pitch)
    }
  
  case .Effect:
    sound = next_sound_effect()
    ma_sound_init(sound, sound_desc.path) or_return

    if pos != nil
    {
      pos := pos.? * WORLD_SCALE
      ma.sound_set_position(sound, pos.x, pos.y, 0)
      ma.sound_set_spatialization_enabled(sound, true)
    }
    else
    {
      ma.sound_set_spatialization_enabled(sound, false)
    }

    ma.sound_set_volume(sound, volume)
    ma.sound_set_pitch(sound, pitch)
  }

  if sound != nil
  {
    result = ma.sound_start(sound)
    if result != .SUCCESS
    {
      log.errorf("[audio]: Failed to start sound %s! (%s)", name, result)
      return false
    }
  }

  return true
}

// TODO(dg): Maybe implement this, maybe not.
play_sound_looping :: proc(
  name:   Sound_Name,
  pos:    Maybe(v2f32) = nil,
  volume: f32 = 1.0,
  pitch:  f32 = 1.0,
) -> (
  ok: bool,
){
  return false
}

pause_sound_group :: proc(group: Sound_Group)
{
  if !audio.initialized do return

  ma_result: ma.result

  switch group
  {
  case .Nil, .Effect:
    
  case .Ambience:
    ma_result = ma.sound_stop(&audio.ambience)

  case .Music:
    ma_result = ma.sound_stop(&audio.music)
  }

  if ma_result != .SUCCESS
  {
    log.errorf("[audio]: Error: Failed to pause sound group %s! (%s)", group, ma_result)
  }
}

unpause_sound_group :: proc(group: Sound_Group)
{
  if !audio.initialized do return

  ma_result: ma.result

  switch group
  {
  case .Nil, .Effect:
    
  case .Ambience:
    ma_result = ma.sound_start(&audio.ambience)

  case .Music:
    ma_result = ma.sound_start(&audio.music)
  }

  if ma_result != .SUCCESS
  {
    log.errorf("[audio]: Error: Failed to unpause sound group %s! (%s)", group, ma_result)
  }
}

reset_sound_group :: proc(group: Sound_Group)
{
  if !audio.initialized do return

  result: ma.result

  switch group
  {
  case .Nil, .Effect:

  case .Ambience:
    if ma.sound_is_playing(&audio.ambience)
    {
      result = ma.sound_seek_to_pcm_frame(&audio.ambience, 0)
    }

  case .Music:
    if ma.sound_is_playing(&audio.music)
    {
      result = ma.sound_seek_to_pcm_frame(&audio.music, 0)
    }
  }

  if result != .SUCCESS
  {
    log.errorf("[audio]: Failed to reset sound group '%s'! (%s)", group, result)
  }
}

set_audio_listener_pos :: proc(pos: v2f32)
{
  if !audio.initialized do return

  pos := pos * WORLD_SCALE
  ma.engine_listener_set_position(&audio.engine, 0, pos.x, pos.y , 0)
}

set_music_volume :: proc(volume: f32)
{
  if !audio.initialized do return

  ma.sound_set_volume(&audio.music, volume)
}

// TODO(dg): One sound file may overshadow others if too many playing.
@(private="file")
next_sound_effect :: proc() -> ^ma.sound
{
  if !audio.initialized do return nil

  result := &audio.effects[audio.effects_pos % MAX_EFFECTS]
  audio.effects_pos += 1
  return result
}

@(private="file")
ma_sound_init :: proc(ma_sound: ^ma.sound, path: string) -> bool
{
  if !audio.initialized do return false

  scratch := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(scratch)

  path_cstr := strings.clone_to_cstring(path, mem.allocator(scratch.arena))
  ma_res := ma.sound_init_from_file(&audio.engine, path_cstr, 0, nil, nil, ma_sound)
  if ma_res != .SUCCESS
  {
    log.errorf("[audio]: Failed to init sound %s! (%s)", path, ma_res)
    return false
  }

  return true
}
