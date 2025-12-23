#!/bin/bash
set -e

odin run game -collection:ext=ext -show-timings -extra-linker-flags:\"-fuse-ld=mold\"
