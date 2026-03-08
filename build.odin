package build

import "core:fmt"
import "core:os"

PACKAGE :: "game"

main :: proc()
{
  // - Target ---
  target := fmt.tprintf("%s_%s", ODIN_OS_STRING, ODIN_ARCH_STRING)

  // - Mode ---
  mode := "run"
  if len(os.args) > 1
  {
    mode = os.args[1]
  }
  
  // fmt.printf("[target:%s]\n", target)
  // fmt.printf("[mode:%s]\n", mode)

  // - Game ---
  game_process_desc: os.Process_Desc
  if mode == "run" || mode == "debug"
  {
    game_process_desc = os.Process_Desc{
      command = {
        "odin", 
        "run", 
        "game", 
        fmt.tprintf("-out:%s.bin", PACKAGE),
        "-collection:ext=ext", 
        "-debug" if mode == "debug" else "",
        "-keep-executable" if mode == "debug" else "",
        "-linker:mold",
        // "-sanitize:address",
      },
      stdout = os.stdout,
      stderr = os.stderr,
    }
  }
  else if mode == "release"
  {
    game_process_desc = os.Process_Desc{
      command = {
        "odin", 
        "build", 
        "game", 
        fmt.tprintf("-out:%s.bin", PACKAGE),
        "-collection:ext=ext", 
        "-vet-style",
        "-o:speed",
        "-linker:mold",
      },
      stdout = os.stdout,
      stderr = os.stderr,
    }
  }
  else
  {
    fmt.eprintf("Failed to build. Mode '%s' is invalid.\n", mode)
    os.exit(1)
  }

  fmt.printf("[%s]\n", PACKAGE)

  process, start_err := os.process_start(game_process_desc)
  if start_err != nil do fmt.panicf("Error: %s\n", start_err)
  _, _ = os.process_wait(process)

  // - Strip ---
  if mode == "release"
  {
    process_desc := os.Process_Desc{
      command = {
        "strip",
        "game.bin",
        "--strip-all",
      },
      stdout = os.stdout,
      stderr = os.stderr,
    }

    process, start_err := os.process_start(process_desc)
    _, _ = os.process_wait(process)
  }
}
