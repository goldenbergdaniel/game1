package metagen

import "core:fmt"
import "core:os"
import "core:strings"

gen_buffer: strings.Builder

main :: proc()
{
  gen_buffer = strings.builder_make()
  strings.write_string(&gen_buffer, "package game\n\n")
}

generate_collision_map :: proc(file: string)
{

}
