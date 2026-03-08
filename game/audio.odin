package game

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
    println("Failed to init miniaudio engine!", res)
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
  sound_desc := res.sounds[name]
  
  switch sound_desc.group
  {
  case .Nil:
  
  case .Ambience:
    sound := &audio.ambience
    if !ma.sound_is_playing(sound) || ma.sound_at_end(sound)
    {
      ma_sound_init(sound, sound_desc.path) or_return
      ma.sound_set_looping(sound, true)
      ma.sound_set_spatialization_enabled(sound, false)
      ma.sound_set_volume(sound, volume)
      ma.sound_set_pitch(sound, pitch)
      
      result = ma.sound_start(sound)
      if result != .SUCCESS
      {
        printf("Error: Failed to start sound %s! %s\n", name, result)
        return false
      }
    }

  case .Music:
    sound := &audio.music
    if !ma.sound_is_playing(sound) || ma.sound_at_end(sound)
    {
      ma_sound_init(sound, sound_desc.path) or_return
      ma.sound_set_looping(sound, true)
      ma.sound_set_spatialization_enabled(sound, false)
      ma.sound_set_volume(sound, volume)
      ma.sound_set_pitch(sound, pitch)

      result = ma.sound_start(sound)
      if result != .SUCCESS
      {
        printf("Error: Failed to start sound %s! %s\n", name, result)
        return false
      }
    }
  
  case .Effect:
    sound := next_sound_effect()
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

    result = ma.sound_start(sound)
    if result != .SUCCESS
    {
      printf("Error: Failed to start sound %s! %s\n", result)
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

pause_sound_group :: proc(group: Sound_Group) -> (ok: bool)
{
  if !audio.initialized do return false

  ma_result: ma.result

  switch group
  {
  case .Nil, .Effect:
    ok = false
    
  case .Ambience:
    ma_result = ma.sound_stop(&audio.ambience)
    ok = true

  case .Music:
    ma_result = ma.sound_stop(&audio.music)
    ok = true
  }

  if ma_result != .SUCCESS
  {
    printf("Error: Failed to pause sound group %s! %s\n", group, ma_result)
    ok = false
  }

  return
}

reset_sound_group :: proc(group: Sound_Group) -> (ok: bool)
{
  if !audio.initialized do return false

  result: ma.result

  switch group
  {
  case .Nil, .Effect:
    ok = false

  case .Ambience:
    result = ma.sound_seek_to_pcm_frame(&audio.ambience, 0)
    ok = true

  case .Music:
    result = ma.sound_seek_to_pcm_frame(&audio.music, 0)
    ok = true
  }

  if result != .SUCCESS
  {
    printf("Error: Failed to reset sound group %s! %s\n", group, result)
    ok = false
  }

  return
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

// TODO(dg): Currently, one sound may overshadow others if too many. 
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
    printf("Error: Failed to init sound %s! %s\n", path, ma_res)
    return false
  }

  return true
}
