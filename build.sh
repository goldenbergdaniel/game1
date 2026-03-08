#!/bin/bash
set -e

MODE="run"
if [[ $1 == "debug" || $1 == "release" ]]; then MODE=$1; fi

if [[ $MODE == "run" || $MODE == "debug" ]]; then
  odin run game -collection:ext=ext -o:none -linker:mold
elif [[ $MODE == "release" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed -no-type-assert -no-bounds-check
fi
