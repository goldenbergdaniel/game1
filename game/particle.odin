package game

import "core:math"
import "basic/rand"

MAX_PARTICLES :: 4 << 10

Particle :: struct
{
  gen:           u16,
  props:         bit_set[Particle_Prop],
  kind:          Particle_Name,
  sprite:        Sprite_Name,
  emmision_kind: Particle_Emmision_Kind,
  kill_timer:    Timer,
  tint:          v4f32,
  color:         v4f32,
  pos:           v2f32,
  scl:           v2f32,
  vel:           v2f32,
  acc:           v2f32,
  dir:           f32,
  rot:           f32,
  rot_dt:        f32,
}

Particle_Prop :: enum
{
  Active,
  Render,
  Interpolate,
  Rotate_Over_Time,
  Scale_Over_Time,
  Persist,
}

Particle_Emmision_Kind :: enum
{
  Static,
  Burst,
}

spawn_particles :: proc(kind: Particle_Name, pos: v2f32)
{
  push_particle :: proc(gm: ^Game) -> ^Particle
  {
    idx := gm.particles_pos % MAX_PARTICLES
    result := &gm.particles[idx]
    gm.particles_pos += 1

    old_gen := result.gen
    result^ = {}
    result.gen = old_gen + 1
    result.props = {.Active, .Render, .Interpolate}
    result.tint = {1, 1, 1, 1}
    result.color = {0, 0, 0, 1}

    return result
  }

  gm := get_active_game()
  desc := &res.particles[kind]

  for i in 0..<desc.count
  {
    par := push_particle(gm)
    par.kind = kind
    par.props += desc.props
    par.sprite = desc.sprite
    par.pos = pos
    par.scl = desc.scl + rand.range_f32({-desc.scl_var, desc.scl_var})
    par.rot = desc.rot
    par.rot_dt = desc.rot_dt
    par.vel = desc.vel
    par.acc = desc.vel_dt
    par.color = rand.choice_slice(desc.colors[:])

    lifetime := desc.lifetime + rand.range_f32({-desc.lifetime_var, desc.lifetime_var})
    timer_start(&par.kill_timer, lifetime)

    switch desc.emmision_kind
    {
    case .Static:

    case .Burst:
      par.dir = rand.range_f32({0, 2*math.PI})
      par.vel.x *= math.cos(par.dir)
      par.vel.y *= math.sin(par.dir)
    }
  }
}

particle_update :: proc(par: ^Particle, dt: f32)
{
  par.vel += par.acc * dt
  par.pos += par.vel * dt

  if .Rotate_Over_Time in par.props
  {
    par.rot += dt * 2
  }

  if .Scale_Over_Time in par.props
  {
    par.scl += res.particles[par.kind].scl_dt * dt
    par.scl.x = max(par.scl.x, 0)
    par.scl.y = max(par.scl.y, 0)
  }

  if timer_timeout(&par.kill_timer)
  {
    par.props -= {.Active}
  }

  if par.props & {.Active, .Persist} == nil
  {
    par.props -= {.Render}
  }
}
