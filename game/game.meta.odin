// NOTE: Machine generated. Do not edit.
package game

Collider_Map_Entry :: struct
{
  vertices:     [6]v2f32,
  vertex_count: int,
  origin:       v2f32,
  kind:         type_of(Collider{}.kind),
}

collider_map := #partial [Sprite_ID]Collider_Map_Entry{
  .SQUARE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
  .CIRCLE = Collider_Map_Entry{vertices = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}}, vertex_count = 0, origin = {0, 0}, kind = .POLYGON},
}
