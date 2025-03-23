@echo off
setlocal

odin run . -out:out/build -collection:src=game -collection:ext=ext -o:none -- %1%
rm out/build
