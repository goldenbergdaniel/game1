#!/bin/bash
set -e

SHADER_SOURCES=("triangle")

# --- CONFIGURE ---------------------------------------------------------------------

MODE="debug"
if [[ $1 == "d" ]]; then MODE="dev"; fi
if [[ $1 == "r" ]]; then MODE="release"; fi

TARGET="linux_amd64"
if [[ $1 == "-target" ]]; then TARGET=$2; fi
if [[ $2 == "-target" ]]; then TARGET=$3; fi

COLLECTIONS="-collection:src=src -collection:ext=ext"

FLAGS=""
if [[ $MODE == "dev"     ]]; then FLAGS="-o:none -use-separate-modules"; fi
if [[ $MODE == "debug"   ]]; then FLAGS="-o:none -debug"; fi
if [[ $MODE == "release" ]]; then FLAGS="-o:speed -vet -no-bounds-check -no-type-assert"; fi

echo [target:$TARGET]
echo [mode:$MODE]

# --- PREPROCESS --------------------------------------------------------------------

echo [preprocess]

pushd src/draw > /dev/null
  SOKOL_SHDC="../../bin/$TARGET/sokol-shdc"
  mkdir -p generated
  for s in ${SHADER_SOURCES[@]}; do
    $SOKOL_SHDC -i shaders/$s.glsl -o generated/$s.odin -l glsl430:hlsl4:metal_macos -f sokol_odin
  done
popd > /dev/null

# --- BUILD -------------------------------------------------------------------------

echo [build]

mkdir -p out

odin build src -out:out/game -target:$TARGET $COLLECTIONS $FLAGS -define:USE_SDL=true

# --- RUN ---------------------------------------------------------------------------

if [[ $MODE == "dev" ]]; then out/game; fi
