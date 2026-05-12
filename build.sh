#!/bin/bash
set -e

MODE="debug"
if [[ $1 == "check" || $1 == "debug" || $1 == "release" || $1 == "dist" ]]; then MODE=$1; fi

echo "[game]"
echo "[mode:$MODE]"

if [[ $MODE == "check" ]]; then
  odin check game -collection:ext=ext
elif [[ $MODE == "debug" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:none -debug
  ./game.bin
elif [[ $MODE == "release" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed
  ./game.bin
elif [[ $MODE == "dist" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed -no-type-assert -no-bounds-check
  mkdir -p dist/
  cp -f game.bin dist/game.bin
  cp -rf res/ dist/res
fi
