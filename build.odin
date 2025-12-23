package build

import "core:fmt"
import "core:os/os2"

PACKAGE :: "game"

main :: proc()
{
  // - Target ---
  target := fmt.tprintf("%s_%s", ODIN_OS_STRING, ODIN_ARCH_STRING)

  // - Mode ---
  mode := "run"
  if len(os2.args) > 1
  {
    mode = os2.args[1]
  }

  // - Metagen ---
  // fmt.println("[metagen]")
  // metagen.generate_collider_map()

  // - Game ---
  game_process_desc: os2.Process_Desc
  if mode == "run" || mode == "debug"
  {
    game_process_desc = os2.Process_Desc{
      command = {
        "odin", 
        "run", 
        "game", 
        fmt.tprintf("-out:%s.bin", PACKAGE),
        "-collection:ext=ext", 
        "-debug" if mode == "debug" else "",
        "-keep-executable" if mode == "debug" else "",
        "-extra-linker-flags:\"-fuse-ld=mold\"",
        // "-sanitize:address",
      },
      stdout = os2.stdout,
      stderr = os2.stderr,
    }
  }
  else if mode == "release"
  {
    game_process_desc = os2.Process_Desc{
      command = {
        "odin", 
        "build", 
        "game", 
        fmt.tprintf("-out:%s.bin", PACKAGE),
        "-collection:ext=ext", 
        "-vet-style",
        "-o:speed",
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

  process, start_err := os2.process_start(game_process_desc)
  if start_err != nil do fmt.panicf("Error: %s\n", start_err)
  _, _ = os2.process_wait(process)

  // - Strip ---
  if mode == "release"
  {
    process_desc := os2.Process_Desc{
      command = {
        "strip",
        "game.bin",
        "--strip-all" 
      },
      stdout = os2.stdout,
      stderr = os2.stderr,
    }

    process, start_err := os2.process_start(process_desc)
    _, _ = os2.process_wait(process)
  }
}
