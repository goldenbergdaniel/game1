#!/bin/bash
set -e

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export VK_LOADER_DEBUG=error,warn

echo "[shaders]"

glslc vk_test/shaders/shader.vert.glsl -o vk_test/shaders/out/shader.vert.spv
glslc vk_test/shaders/shader.frag.glsl -o vk_test/shaders/out/shader.frag.spv
glslc vk_test/shaders/postprocess.vert.glsl -o vk_test/shaders/out/postprocess.vert.spv
glslc vk_test/shaders/postprocess.frag.glsl -o vk_test/shaders/out/postprocess.frag.spv

echo "[vk_test]"

odin run vk_test -collection:ext=ext -o:none -extra-linker-flags:\"-fuse-ld=mold\" -keep-executable -debug
