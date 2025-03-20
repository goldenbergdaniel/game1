#!/bin/bash
set -e

# --- CONFIGURATION ----------------------------------------------------------------------

PACKAGE="all"
if [[ $1 != "" ]]; then PACKAGE=$1; fi
if [[ $PACKAGE != "game" && $PACKAGE != "metagen" && $PACKAGE != "all" ]] then 
  echo "Failed to build. '$PACKAGE' is not valid package."; exit 1
fi

MODE="debug"
if [[ $2 != "" ]]; then MODE=$2; fi
if [[ $MODE != "debug" && $MODE != "release" ]]; then
  echo "Failed to build. '$MODE' is not valid mode."; exit 1
fi

TARGET="linux_amd64"
if [[ $3 != "" ]]; then TARGET=$3; fi
if [[ $TARGET != "darwin_amd64" && $TARGET != "darwin_arm64" && $TARGET != "linux_amd64" ]]; then
  echo "Failed to build. '$TARGET' is not valid target."; exit 1
fi

FLAGS="-collection:src=game -collection:ext=ext -vet-style -vet-cast -extra-linker-flags:\"-fuse-ld=mold\" $4"

mkdir -p out

echo [target:$TARGET]
echo [mode:$MODE]

# --- METAGEN ----------------------------------------------------------------------------

echo [metagen]

if [[ $PACKAGE == "metagen" || $PACKAGE == "all" ]]; then
  odin build metagen -out:out/metagen -target:$TARGET $FLAGS
fi

out/metagen

# --- GAME -------------------------------------------------------------------------------

if [[ $MODE == "debug"   ]]; then FLAGS="-o:none -debug $FLAGS"; fi
if [[ $MODE == "release" ]]; then FLAGS="-o:speed -microarch:native -no-bounds-check $FLAGS"; fi

if [[ $PACKAGE == "game" || $PACKAGE == "all" ]]; then
  echo [game]
  odin build game -out:out/game -target:$TARGET $FLAGS
  if [[ $MODE == "debug" ]]; then out/game; fi
fi
