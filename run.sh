#!/bin/bash
set -e

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export VK_LOADER_DEBUG=error,warn

glslc vk_test/shaders/shader.vert.glsl -o vk_test/shaders/out/shader.vert.spv
glslc vk_test/shaders/shader.frag.glsl -o vk_test/shaders/out/shader.frag.spv

odin run vk_test -collection:ext=ext -o:none -extra-linker-flags:\"-fuse-ld=mold\" -keep-executable -debug
