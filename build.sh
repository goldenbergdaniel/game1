#!/bin/bash
set -e

odin run build.odin -file -out:out/build -collection:ext=ext -o:none -- $1 $2
