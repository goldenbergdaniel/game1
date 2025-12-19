package ui

Glyph :: struct
{
  offset: [2]f32,
}

glyph_table := [256]Glyph{
  'a' = Glyph{},
  'ä' = Glyph{},
}
