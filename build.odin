package build

import "core:fmt"
import "core:os/os2"

import "metagen"

main :: proc()
{
  // - Target ---
  target := fmt.tprintf("%s_%s", ODIN_OS_STRING, ODIN_ARCH_STRING)
  fmt.printf("[target:%s]\n", target)

  // - Package ---
  pkg := "game"
  if len(os2.args) > 1
  {
    if os2.args[1] == "game" || os2.args[1] == "metagen"
    {
      pkg = os2.args[1]
    }
    else
    {
      fmt.eprintf("Failed to build. Package '%s' is invalid.\n", os2.args[1])
      os2.exit(1)
    }
  }

  // - Mode ---
  mode := "debug"
  if len(os2.args) > 2
  {
    if os2.args[2] == "debug" || os2.args[2] == "release"
    {
      mode = os2.args[2]
    }
    else
    {
      fmt.eprintf("Failed to build. Mode '%s' is invalid.\n", os2.args[2])
      os2.exit(1)
    }
  }
  fmt.printf("[mode:%s]\n", mode)

  // - Metagen ---
  fmt.println("[metagen]")
  metagen.generate_collider_map()

  // - Game ---
  if pkg == "game"
  {
    fmt.println("[game]")

    game_process_desc: os2.Process_Desc
    if mode == "debug"
    {
      game_process_desc = os2.Process_Desc{
        command={
          "odin", 
          "run", 
          "game", 
          "-out:game.bin",
          "-collection:ext=ext", 
          "-debug",
          "-extra-linker-flags:\"-fuse-ld=mold\"",
        },
      }
    }
    else if mode == "release"
    {
      game_process_desc = os2.Process_Desc{
        command={
          "odin", 
          "build", 
          "game", 
          "-out:game.bin",
          "-collection:ext=ext", 
          "-vet-style",
          "-o:speed",
          "-microarch:native",
          "-extra-linker-flags:\"-fuse-ld=mold\"",
        },
      }
    }

    // os2.make_directory("out")
    st, stdout, stderr, err := os2.process_exec(game_process_desc, context.allocator)
    if stdout != nil do fmt.println(cast(string) stdout[:len(stdout)-1])
    if stderr != nil do fmt.println(cast(string) stderr[:len(stderr)-1])
  }

  os2.remove("game1")
}
