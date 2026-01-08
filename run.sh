#!/bin/bash
set -e

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export VK_LOADER_DEBUG=error,warn

echo "[shaders]"

glslc -fshader-stage=vert -DVS vk_test/shaders/shader.glsl -o vk_test/shaders/out/shader.vert.spv
glslc -fshader-stage=frag -DFS vk_test/shaders/shader.glsl -o vk_test/shaders/out/shader.frag.spv
glslc -fshader-stage=vert -DVS vk_test/shaders/postprocess.glsl -o vk_test/shaders/out/postprocess.vert.spv
glslc -fshader-stage=frag -DFS vk_test/shaders/postprocess.glsl -o vk_test/shaders/out/postprocess.frag.spv

# slangc vk_test/shaders/shader.slang -o vk_test/shaders/out/shader.spv -profile spirv_1_4
# slangc vk_test/shaders/postprocess.slang -o vk_test/shaders/out/postprocess.spv -profile spirv_1_4

echo "[vk_test]"

odin run vk_test -collection:ext=ext -o:none -extra-linker-flags:\"-fuse-ld=mold\" -keep-executable -debug
