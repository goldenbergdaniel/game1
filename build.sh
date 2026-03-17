#!/bin/bash
set -e

MODE="debug"
if [[ $1 == "check" || $1 == "debug" || $1 == "release" ]]; then MODE=$1; fi

echo "[game]"

if [[ $MODE == "check" ]]; then
  odin check game -collection:ext=ext
elif [[ $MODE == "debug" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:none -debug
  ./game.bin
elif [[ $MODE == "release" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed -no-type-assert -no-bounds-check
fi
