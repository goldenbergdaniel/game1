#!/bin/bash
set -e

# --- CONFIGURE --------------------------------------------------------------------------

MODE="debug"
if [[ $1 == "debug" || $1 == "release" ]]; then MODE=$1; fi

TARGET="linux_amd64"
if [[ $2 == "darwin_amd64" || $2 == "darwin_arm64" || $2 == "linux_amd64" ]]; then TARGET=$2; fi

RENDER_BACKEND="opengl"

FLAGS="-collection:src=src -collection:ext=ext 
       -vet-shadowing -vet-style -vet-cast
       -define=RENDER_BACKEND=$RENDER_BACKEND 
       -extra-linker-flags:\"-fuse-ld=mold\" 
       $3 $FLAGS"
if [[ $MODE == "debug"   ]]; then FLAGS="-o:none -debug -use-separate-modules $FLAGS"; fi
if [[ $MODE == "release" ]]; then FLAGS="-o:speed -no-bounds-check -no-type-assert $FLAGS"; fi

echo [target:$TARGET]
echo [mode:$MODE]
echo [render:$RENDER_BACKEND]

# --- BUILD ------------------------------------------------------------------------------

echo [build]

mkdir -p out
odin build src -out:out/game -target:$TARGET $FLAGS
if [[ $MODE == "debug" ]]; then out/game; fi
