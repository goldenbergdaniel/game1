package game

Entity :: struct
{
  kind:   Entity_Kind,
  active: bool,

  pos:   [2]f32,
  vel:   [2]f32,
  dim:   [2]f32,
  color: [4]u8,
}

Entity_Kind :: enum
{
  SHIP,
  PROJECTILE,
}
