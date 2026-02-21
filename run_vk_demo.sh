#!/bin/bash
set -e

source "$HOME/tools/vulkan/1.4.335.0/setup-env.sh"
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export VK_LOADER_DEBUG=error,warn

echo "[shaders]"

glslc -fshader-stage=vert -DVS vk_demo/shaders/shader.glsl -o vk_demo/shaders/out/shader.vert.spv
glslc -fshader-stage=frag -DFS vk_demo/shaders/shader.glsl -o vk_demo/shaders/out/shader.frag.spv
glslc -fshader-stage=vert -DVS vk_demo/shaders/postprocess.glsl -o vk_demo/shaders/out/postprocess.vert.spv
glslc -fshader-stage=frag -DFS vk_demo/shaders/postprocess.glsl -o vk_demo/shaders/out/postprocess.frag.spv

# slangc vk_demo/shaders/shader.slang -o vk_demo/shaders/out/shader.spv -profile spirv_1_4
# slangc vk_demo/shaders/postprocess.slang -o vk_demo/shaders/out/postprocess.spv -profile spirv_1_4

echo "[vk_demo]"

odin run vk_demo -collection:ext=ext -o:none -linker:mold -keep-executable -debug
