// NOTE(dg): Machine generated. Do not edit.
package game

Collider_Map_Entry :: struct
{
  vertices:     [6][2]int,
  vertex_count: int,
  origin:       [2]int,
  kind:         type_of(Collider{}.kind),
}

collider_map: [Sprite_ID]Collider_Map_Entry = {
  .NIL = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .SHIP = Collider_Map_Entry{vertices = {{2, 4}, {14, 8}, {2, 12}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 3, origin = {0, 0}, kind = .POLYGON},
  .ALIEN = Collider_Map_Entry{vertices = {{5, 4}, {11, 4}, {13, 8}, {10, 11}, {6, 11}, {3, 8}}, vertex_count = 6, origin = {0, 0}, kind = .POLYGON},
  .ASTEROID = Collider_Map_Entry{vertices = {{3, 3}, {12, 3}, {11, 10}, {3, 14}, {-1, -1}, {-1, -1}}, vertex_count = 4, origin = {0, 0}, kind = .POLYGON},
  .FOOTBALL = Collider_Map_Entry{vertices = {{7, 9}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7, 9}, kind = .CIRCLE},
  .PROJECTILE = Collider_Map_Entry{vertices = {{7, 9}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7, 9}, kind = .CIRCLE},
  .ASTEROID_BIG = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .CIRCLE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
}
