@echo off
setlocal

set OUTPUT=serialbox.exe
set SHADER_SOURCES=triangle

@REM --- CONFIGURE ------------------------------------------------------------------

set MODE=debug
if "%1%"=="d" set MODE=dev
if "%1%"=="r" set MODE=release

set TARGET=windows_amd64
if "%1%"=="-target" (
  set TARGET=%2%
)
if "%2%"=="-target" (
  set TARGET=%3%
)

set COMMON=-collection:src=src -collection:ext=ext 

if "%MODE%"=="dev"     set FLAGS=-o:none -use-separate-modules
if "%MODE%"=="debug"   set FLAGS=-o:none -debug
if "%MODE%"=="release" set FLAGS=-o:speed -no-bounds-check -no-type-assert -subsystem:window

echo [package:%SOURCE%]
echo [target:%TARGET%]
echo [mode:%MODE%]

@REM --- PREPROCESS -----------------------------------------------------------------

echo [preprocess]

pushd src\draw
  set SOKOL_SHDC=..\..\bin\%TARGET%\sokol-shdc.exe
  set PUT=..\..\bin\%TARGET%\put.exe
  if not exist generated mkdir generated
  for %%s in (%SHADER_SOURCES%) do (
    %SOKOL_SHDC% -i shaders/%%s.glsl -o generated\%%s.odin -l glsl430:hlsl4:metal_macos -f sokol_odin
  )
popd

@REM --- BUILD ----------------------------------------------------------------------

echo [build]

if not exist out mkdir out
odin build src -out:out/%OUTPUT% -target:%TARGET% %COMMON% %FLAGS% -define:USE_SDL=true
