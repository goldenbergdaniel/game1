// NOTE: Machine generated. Do not edit.
package game

Collider_Map_Entry :: struct
{
  vertices:     [6]v2f32,
  vertex_count: int,
  origin:       v2f32,
  kind:         type_of(Collider{}.kind),
}

collider_map: [Sprite_ID]Collider_Map_Entry = {
  .NIL = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .SQUARE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .CIRCLE = Collider_Map_Entry{vertices = {{1.5, 4.5}, {13.5, 8.5}, {1.5, 12.5}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 3, origin = {0, 0}, kind = .POLYGON},
  .SHADOW = Collider_Map_Entry{vertices = {{4.5, 4.5}, {10.5, 4.5}, {12.5, 9.5}, {9.5, 12.5}, {5.5, 12.5}, {2.5, 9.5}}, vertex_count = 6, origin = {0, 0}, kind = .POLYGON},
  .PLAYER_IDLE_1 = Collider_Map_Entry{vertices = {{7.5, 9.5}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7.5, 9.5}, kind = .CIRCLE},
  .PLAYER_IDLE_2 = Collider_Map_Entry{vertices = {{3.5, 3.5}, {12.5, 3.5}, {11.5, 12.5}, {3.5, 14.5}, {-1, -1}, {-1, -1}}, vertex_count = 4, origin = {0, 0}, kind = .POLYGON},
  .PLAYER_WALK_1 = Collider_Map_Entry{vertices = {{7.5, 8.5}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 1, origin = {7.5, 8.5}, kind = .CIRCLE},
  .PLAYER_WALK_2 = Collider_Map_Entry{vertices = {{5.5, 7.5}, {9.5, 7.5}, {9.5, 9.5}, {5.5, 9.5}, {-1, -1}, {-1, -1}}, vertex_count = 4, origin = {0, 0}, kind = .POLYGON},
  .PLAYER_WALK_3 = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .PLAYER_WALK_4 = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .PLAYER_WALK_5 = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .RIFLE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .BULLET = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
}
