#!/bin/bash
set -e

SHADERS=("triangle")

# --- CONFIGURE ---------------------------------------------------------------------

MODE="dev"
if [[ $1 != "" ]]; then MODE=$1; fi

TARGET="linux_amd64"
if [[ $2 != "" ]]; then TARGET=$2; fi

EXTRA=$3
FLAGS="-collection:src=src -collection:ext=ext -define:USE_SDL=true $EXTRA"
if [[ $MODE == "dev"     ]]; then FLAGS="-o:none -use-separate-modules $FLAGS"; fi
if [[ $MODE == "debug"   ]]; then FLAGS="-o:none -debug $FLAGS"; fi
if [[ $MODE == "release" ]]; then FLAGS="-o:speed -microarch:native -no-bounds-check $FLAGS"; fi

echo [target:$TARGET]
echo [mode:$MODE]

# --- PREPROCESS --------------------------------------------------------------------

echo [preprocess]

pushd src/render > /dev/null
  SOKOL_SHDC="../../bin/$TARGET/sokol-shdc"
  mkdir -p generated
  for s in ${SHADERS[@]}; do
    $SOKOL_SHDC -i shaders/$s.glsl -o shaders/$s.odin -l glsl430 -f sokol_odin
  done
popd > /dev/null

# --- BUILD -------------------------------------------------------------------------

echo [build]

mkdir -p out
odin build src -out:out/game -target:$TARGET $FLAGS
if [[ $MODE == "dev" ]]; then out/game; fi
