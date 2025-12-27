#!/bin/bash
set -e

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export VK_LOADER_DEBUG=error,warn

glslc game/vk_test/shaders/shader.vert.glsl -o game/vk_test/shaders/spirv/shader.vert.spv
glslc game/vk_test/shaders/shader.frag.glsl -o game/vk_test/shaders/spirv/shader.frag.spv

odin run game/vk_test -collection:ext=ext -extra-linker-flags:\"-fuse-ld=mold\" -keep-executable -debug
