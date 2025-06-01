package build

import "core:fmt"
import "core:os/os2"

main :: proc()
{
  // - Target ---
  target := fmt.tprintf("%s_%s", ODIN_OS_STRING, ODIN_ARCH_STRING)

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
  // fmt.println("[metagen]")
  // metagen.generate_collider_map()

  os2.set_env("SDL_VIDEO_DRIVER", "wayland")

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
        stdout = os2.stdout,
        stderr = os2.stderr,
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
        stdout = os2.stdout,
        stderr = os2.stderr,
      }
    }

    process, start_err := os2.process_start(game_process_desc)
    if start_err != nil do fmt.eprintln("Error:", start_err)

    _, wait_err := os2.process_wait(process)
    if wait_err != nil do fmt.eprintln("Error:", wait_err)
  }

  os2.remove("game1")
}
