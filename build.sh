#!/bin/bash
set -e

source "$HOME/tools/vulkan/1.4.357.1/setup-env.sh"
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json

MODE="debug"
if [[ $1 == "check" || $1 == "debug" || $1 == "release" || $1 == "dist" ]]; then MODE=$1; fi

echo "[game]"
echo "[mode:$MODE]"

echo "[shaders]"

glslc -fshader-stage=vert -DVS game/shaders/shader.glsl -o game/shaders/out/shader.vert.spv
glslc -fshader-stage=frag -DFS game/shaders/shader.glsl -o game/shaders/out/shader.frag.spv

if [[ $MODE == "check" ]]; then
  odin check game -collection:ext=ext
elif [[ $MODE == "debug" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:none -debug -define:RENDER_BACKEND=vulkan
  ./game.bin
elif [[ $MODE == "release" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed -define:RENDER_BACKEND=vulkan
  ./game.bin
elif [[ $MODE == "dist" ]]; then
  odin build game -collection:ext=ext -linker:mold -o:speed -no-type-assert -no-bounds-check
  mkdir -p dist/
  cp -f game.bin dist/game.bin
  cp -rf res/ dist/res
fi
