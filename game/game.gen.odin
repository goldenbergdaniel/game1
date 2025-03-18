// NOTE(dg): Machine generated. Do not edit.
package game

Collider_Map_Entry :: struct
{
  vertices:     [6]v2f,
  vertex_count: int,
  origin:       v2f,
  kind:         type_of(Collider{}.kind),
}

collider_map: [Sprite_ID]Collider_Map_Entry = {
  .NIL = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .SHIP = Collider_Map_Entry{vertices = {{2.5, 4.5}, {14.5, 8.5}, {2.5, 12.5}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 3, origin = {0, 0}, kind = .POLYGON},
  .ALIEN = Collider_Map_Entry{vertices = {{5.5, 4.5}, {11.5, 4.5}, {13.5, 8.5}, {10.5, 11.5}, {6.5, 11.5}, {3.5, 8.5}}, vertex_count = 6, origin = {0, 0}, kind = .POLYGON},
  .ASTEROID = Collider_Map_Entry{vertices = {{3.5, 3.5}, {12.5, 3.5}, {11.5, 10.5}, {3.5, 14.5}, {-1, -1}, {-1, -1}}, vertex_count = 4, origin = {0, 0}, kind = .POLYGON},
  .FOOTBALL = Collider_Map_Entry{vertices = {{7.5, 9.5}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7.5, 9.5}, kind = .CIRCLE},
  .PROJECTILE = Collider_Map_Entry{vertices = {{7.5, 9.5}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7.5, 9.5}, kind = .CIRCLE},
  .ASTEROID_BIG = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .CIRCLE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
}
