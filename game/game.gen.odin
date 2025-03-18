// NOTE(dg): Machine generated. Do not edit.
package game

Collider_Map_Entry :: struct
{
  vertices: [6][2]f32,
  origin:   [2]f32,
  kind:     type_of(Collider{}.kind),
}

collider_map: [Sprite_ID]Collider_Map_Entry = {
  .NIL = Collider_Map_Entry{vertices = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
  .SHIP = Collider_Map_Entry{vertices = {{2, 4}, {14, 8}, {2, 12}, {0, 0}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
  .ALIEN = Collider_Map_Entry{vertices = {{5, 4}, {11, 4}, {13, 8}, {10, 11}, {6, 11}, {3, 8}}, origin = {0, 0}, kind = .NIL},
  .ASTEROID = Collider_Map_Entry{vertices = {{3, 3}, {12, 3}, {11, 10}, {3, 14}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
  .PROJECTILE = Collider_Map_Entry{vertices = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
  .ASTEROID_BIG = Collider_Map_Entry{vertices = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
  .CIRCLE = Collider_Map_Entry{vertices = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, origin = {0, 0}, kind = .NIL},
}
