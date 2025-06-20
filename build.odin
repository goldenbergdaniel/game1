package build

import "core:fmt"
import "core:os/os2"

PACKAGE :: "game"

main :: proc()
{
  // - Target ---
  target := fmt.tprintf("%s_%s", ODIN_OS_STRING, ODIN_ARCH_STRING)

  // - Mode ---
  mode := "debug"
  if len(os2.args) > 1
  {
    mode = os2.args[1]
  }

  // - Metagen ---
  // fmt.println("[metagen]")
  // metagen.generate_collider_map()

  // - Game ---
  game_process_desc: os2.Process_Desc
  if mode == "debug"
  {
    game_process_desc = os2.Process_Desc{
      command={
        "odin", 
        "run", 
        "game", 
        fmt.tprintf("-out:%s.bin", PACKAGE),
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
        fmt.tprintf("-out:%s.bin", PACKAGE),
        "-collection:ext=ext", 
        "-vet-style",
        "-o:speed",
        "-microarch:native",
        "-ignore-unknown-attributes",
        "-extra-linker-flags:\"-fuse-ld=mold\"",
      },
      stdout = os2.stdout,
      stderr = os2.stderr,
    }
  }
  else
  {
    fmt.eprintf("Failed to build. Mode '%s' is invalid.\n", mode)
    os2.exit(1)
  }

  fmt.printf("[target:%s]\n", target)
  fmt.printf("[mode:%s]\n", mode)
  fmt.printf("[%s]\n", PACKAGE)

  os2.set_env("SDL_VIDEO_DRIVER", "wayland")

  process, start_err := os2.process_start(game_process_desc)
  if start_err != nil do fmt.eprintln("Error:", start_err)

  _, _ = os2.process_wait(process)
}
