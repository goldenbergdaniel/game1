#!/bin/bash
set -e

# --- CONFIGURE --------------------------------------------------------------------------

PACKAGE="game"
if [[ $1 == "game" || $1 == "metagen" ]] then PACKAGE=$1; fi

MODE="debug"
if [[ $2 == "debug" || $2 == "release" ]]; then MODE=$2; fi

TARGET="linux_amd64"
if [[ $3 == "darwin_amd64" || $3 == "darwin_arm64" || $3 == "linux_amd64" ]]; then TARGET=$3; fi

RENDER_BACKEND="opengl"

FLAGS="-collection:src=game -collection:ext=ext -define=RENDER_BACKEND=$RENDER_BACKEND 
       -vet-style -vet-cast -extra-linker-flags:\"-fuse-ld=mold\" $4"
if [[ $MODE == "debug"   ]]; then FLAGS="-o:none -debug $FLAGS"; fi
if [[ $MODE == "release" ]]; then FLAGS="-o:speed -microarch:native -no-bounds-check $FLAGS"; fi

echo [package:$PACKAGE]
echo [target:$TARGET]
echo [mode:$MODE]

# --- PREPROCESS -------------------------------------------------------------------------

# echo [proprocess]
if [[ $PACKAGE == "game" ]]; then out/metagen; fi

# --- BUILD ------------------------------------------------------------------------------

# echo [build]

mkdir -p out
odin build $PACKAGE -out:out/$PACKAGE -target:$TARGET $FLAGS
if [[ $MODE == "debug" ]]; then out/$PACKAGE; fi
