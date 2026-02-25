package vk_demo

import "base:runtime"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:image/qoi"
import "core:image/png"
import os "core:os/os2"
import "ext:cgltf"
import "ext:sdl"
import vk "ext:vulkan"
import "ext:vma"
import "../game/basic/mem"
import "../game/platform"

USE_MAILBOX          :: false
NUM_FRAMES_IN_FLIGHT :: 2

Device :: struct
{
  handle:           vk.Device,
  physical:         vk.PhysicalDevice,
  queue:            vk.Queue,
  queue_family_idx: u32,
  color_format:     vk.Format,
  depth_format:     vk.Format,
}

Swapchain :: struct
{
  handle:           vk.SwapchainKHR,
  image_count:      u32,
  images:           [4]vk.Image,
  image_views:      [4]vk.ImageView,
  image_ready_sems: [4]vk.Semaphore,
  extent:           vk.Extent2D,
  ci:               vk.SwapchainCreateInfoKHR,
}

Buffer :: struct
{
  handle:     vk.Buffer,
  address:    vk.DeviceAddress,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
}

Image :: struct
{
  handle:     vk.Image,
  view:       vk.ImageView,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
}

Vertex :: struct
{
  position: [3]f32,
  _:        [1]f32,
  normal:   [3]f32,
  _:        [1]f32,
  color:    [4]f32,
  uv:       [2]f32,
  _:        [2]f32,
}

Model :: struct
{
  vertices: []Vertex,
  indices:  []u16,
}

@(private="file")
g: struct
{
  perm_arena:        mem.Arena,
  instance:          vk.Instance,
  debug_messenger:   vk.DebugUtilsMessengerEXT,
  window:            ^platform.Window,
  surface:           vk.SurfaceKHR,
  device:            Device,
  swapchain:         Swapchain,
  frame_cmd_pool:    vk.CommandPool,
  frames:            [NUM_FRAMES_IN_FLIGHT]struct
  {
    fence:           vk.Fence,
    present_sem:     vk.Semaphore,
    cmd:             vk.CommandBuffer, 
    depth_image:     Image,
    uniform_buf:     Buffer,
  },
  desc_pool:         vk.DescriptorPool,
  desc_sets:         [NUM_FRAMES_IN_FLIGHT]vk.DescriptorSet,
  desc_layouts:      [NUM_FRAMES_IN_FLIGHT]vk.DescriptorSetLayout,
  frame_idx:         int,
  gpu_allocator:     vma.Allocator,
  burst_cmd_pool:    vk.CommandPool,
  burst_cmd:         vk.CommandBuffer,
  burst_fence:       vk.Fence,
  pipelines:         [enum{Main, Post}]struct
  {
    handle:          vk.Pipeline, 
    layout:          vk.PipelineLayout,
  },
  textures:          [enum{Smile, Screen}]Image,
  sampler:           vk.Sampler,
  viewport:          vk.Viewport,
  scissor:           vk.Rect2D,

  main_constants:    struct
  {
    transform:       matrix[4,4]f32,
    vertex_addr:     vk.DeviceAddress,
  },
  post_constants:    struct
  {
    enabled:         b32,
  },
  uniforms:          struct
  {
    light:           [4]f32,
  },
  vertices:          [24]Vertex,
  vertex_buf:        Buffer,
  indices:           [36]u8,
  index_buf:         Buffer,
  model:             Model,
}

vk_init :: proc(window: ^platform.Window)
{
  _ = mem.arena_init_growing(&g.perm_arena)

  g.window = window
  
  vk_init_instance()
  g.device = vk_create_device()
  g.swapchain = vk_create_swapchain()
  
  vulkan_functions := vma.create_vulkan_functions()
  result := vma.CreateAllocator(&{
  	vulkanApiVersion = vk.API_VERSION_1_4,
  	pVulkanFunctions = &vulkan_functions,
  	instance = g.instance,
  	physicalDevice = g.device.physical,
  	device = g.device.handle,
    flags = {.BUFFER_DEVICE_ADDRESS},
  }, &g.gpu_allocator)
  vk_check(result)

  vk_check(vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.TRANSIENT},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.burst_cmd_pool))

  vk_check(vk.AllocateCommandBuffers(g.device.handle, &{
    sType = .COMMAND_BUFFER_ALLOCATE_INFO,
    commandPool = g.burst_cmd_pool,
    level = .PRIMARY,
    commandBufferCount = 1,
  }, &g.burst_cmd))

  vk_check(vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.RESET_COMMAND_BUFFER},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.frame_cmd_pool))

  desc_pool_sizes := [2]vk.DescriptorPoolSize{
    {
      descriptorCount = NUM_FRAMES_IN_FLIGHT,
      type = .UNIFORM_BUFFER,
    },
    {
      descriptorCount = NUM_FRAMES_IN_FLIGHT * 2,
      type = .COMBINED_IMAGE_SAMPLER,
    },
  }

  vk_check(vk.CreateDescriptorPool(g.device.handle, &{
    sType = .DESCRIPTOR_POOL_CREATE_INFO,
    maxSets = NUM_FRAMES_IN_FLIGHT,
    poolSizeCount = len(desc_pool_sizes),
    pPoolSizes = raw_data(desc_pool_sizes[:]),
  }, nil, &g.desc_pool))

  vk_check(vk.CreateFence(g.device.handle, &{sType=.FENCE_CREATE_INFO}, nil, &g.burst_fence))

  // - Allocate descriptor sets ---
  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    layout_bindings := [?]vk.DescriptorSetLayoutBinding{
      {
        binding = 0,
        descriptorCount = 1,
        descriptorType = .UNIFORM_BUFFER,
        stageFlags = {.VERTEX, .FRAGMENT},
      },
      {
        binding = 1,
        descriptorCount = 1,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        stageFlags = {.FRAGMENT},
      },
      {
        binding = 2,
        descriptorCount = 1,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        stageFlags = {.FRAGMENT},
      },
    }
    vk.CreateDescriptorSetLayout(g.device.handle, &{
      sType = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
      flags = {},
      bindingCount = len(layout_bindings),
      pBindings = &layout_bindings[0],
    }, nil, &g.desc_layouts[i])
  }

  vk_check(vk.AllocateDescriptorSets(g.device.handle, &{
    sType = .DESCRIPTOR_SET_ALLOCATE_INFO,
    descriptorPool = g.desc_pool,
    descriptorSetCount = len(g.desc_sets),
    pSetLayouts = raw_data(g.desc_layouts[:]),
  }, raw_data(g.desc_sets[:])))

  // - Vertex and index buffer ---
  {
    model, model_load_err := load_model("res/models/cornell_box.glb", &g.perm_arena)
    if model_load_err != nil
    {
      fmt.panicf("[FATAL][render_vk]: Failed to load model:", model_load_err)
    }

    g.model = model
    
    vertices_size := vk.DeviceSize(len(g.model.vertices) * size_of(Vertex))
    indices_size := vk.DeviceSize(len(g.model.indices) * size_of(u16))

    staging_buf := vk_create_buffer(vertices_size + indices_size, {.TRANSFER_SRC}, {.HOST_VISIBLE})
    defer vk_destroy_buffer(&staging_buf)

    g.vertex_buf = vk_create_buffer(vertices_size, 
                                    {.VERTEX_BUFFER, .TRANSFER_DST, .SHADER_DEVICE_ADDRESS}, 
                                    {.DEVICE_LOCAL})

    g.vertex_buf.address = vk.GetBufferDeviceAddress(g.device.handle, &{
      sType = .BUFFER_DEVICE_ADDRESS_INFO,
      buffer = g.vertex_buf.handle,
    })

    mem.copy(staging_buf.info.pMappedData, raw_data(model.vertices[:]), vertices_size)

    g.index_buf = vk_create_buffer(indices_size, {.INDEX_BUFFER, .TRANSFER_DST}, {.DEVICE_LOCAL})

    indices_offset_addr := rawptr(uintptr(staging_buf.info.pMappedData) + uintptr(vertices_size))
    mem.copy(indices_offset_addr, raw_data(g.model.indices[:]), indices_size)

    vk_copy_to_buffers(&staging_buf, {&g.vertex_buf, &g.index_buf}, {vertices_size, indices_size})
  }

  // - Texture ---
  {
    // img, img_load_err := qoi.load_from_file("res/textures/smile.qoi", allocator=mem.allocator(&g.perm_arena))
    img, img_load_err := png.load_from_file("res/textures/joseph_smith.png", allocator=mem.allocator(&g.perm_arena))
    if img_load_err != nil
    {
      fmt.panicf("[FATAL][render_vk]: Failed to load image", img_load_err)
    }

    g.textures[.Smile] = vk_create_texture(img.pixels.buf[:], 
                                           u32(img.width), 
                                           u32(img.height), 
                                           .R8G8B8A8_SRGB,
                                           .SHADER_READ_ONLY_OPTIMAL)

    img, img_load_err = qoi.load_from_file("res/textures/screen.qoi", allocator=mem.allocator(&g.perm_arena))
    if img_load_err != nil
    {
      fmt.panicf("[FATAL][render_vk]: Failed to load image!", img_load_err)
    }

    g.textures[.Screen] = vk_create_image(g.swapchain.extent.width, g.swapchain.extent.height, 
                                          .R8G8B8A8_UNORM, .COLOR_ATTACHMENT_OPTIMAL,
                                          {.COLOR}, {.COLOR_ATTACHMENT, .SAMPLED})

    vk_check(vk.CreateSampler(g.device.handle, &{
      sType = .SAMPLER_CREATE_INFO,
      magFilter = .NEAREST,
      minFilter = .NEAREST,
      addressModeU = .REPEAT,
      addressModeV = .REPEAT,
      addressModeW = .REPEAT,
    }, nil, &g.sampler))
  }

  // - Frame data ---
  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    frame := &g.frames[i]

    vk_check(vk.CreateSemaphore(g.device.handle, &{sType=.SEMAPHORE_CREATE_INFO}, nil, &frame.present_sem))
    vk_check(vk.CreateFence(g.device.handle, &{sType=.FENCE_CREATE_INFO, flags={.SIGNALED}}, nil, &frame.fence))

    vk_check(vk.AllocateCommandBuffers(g.device.handle, &{
      sType = .COMMAND_BUFFER_ALLOCATE_INFO,
      commandPool = g.frame_cmd_pool,
      level = .PRIMARY,
      commandBufferCount = 1,
    }, &frame.cmd))

    frame.uniform_buf = vk_create_buffer(size_of(g.uniforms), {.UNIFORM_BUFFER, .TRANSFER_DST}, {.DEVICE_LOCAL})

    write_desc_sets := [?]vk.WriteDescriptorSet{
      {
        sType = .WRITE_DESCRIPTOR_SET,
        descriptorCount = 1,
        descriptorType = .UNIFORM_BUFFER,
        dstSet = g.desc_sets[i],
        dstBinding = 0,
        pBufferInfo = &{
          buffer = g.frames[i].uniform_buf.handle,
          range = size_of(g.uniforms),
        },
      },
      {
        sType = .WRITE_DESCRIPTOR_SET,
        descriptorCount = 1,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        dstSet = g.desc_sets[i],
        dstBinding = 1,
        pImageInfo = &{
          imageView = g.textures[.Smile].view,
          sampler = g.sampler,
          imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        },
      },
      {
        sType = .WRITE_DESCRIPTOR_SET,
        descriptorCount = 1,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        dstSet = g.desc_sets[i],
        dstBinding = 2,
        pImageInfo = &{
          imageView = g.textures[.Screen].view,
          sampler = g.sampler,
          imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        },
      },
    }
    vk.UpdateDescriptorSets(g.device.handle, len(write_desc_sets), &write_desc_sets[0], 0, nil)

    frame.depth_image = vk_create_image(g.swapchain.extent.width, g.swapchain.extent.height,
                                        g.device.depth_format, .UNDEFINED, 
                                        {.DEPTH}, {.DEPTH_STENCIL_ATTACHMENT})
  }

  // - Main pipeline ---
  {
    vs_data: []u8 = #load("shaders/out/shader.vert.spv")
    fs_data: []u8 = #load("shaders/out/shader.frag.spv")

    vs_module: vk.ShaderModule
    vk_check(vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(vs_data),
      pCode = cast(^u32) raw_data(vs_data),
    }, nil, &vs_module))
    defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)

    fs_module: vk.ShaderModule
    vk_check(vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(fs_data),
      pCode = cast(^u32) raw_data(fs_data),
    }, nil, &fs_module))
    defer vk.DestroyShaderModule(g.device.handle, fs_module, nil)

    shader_stage_cis := [2]vk.PipelineShaderStageCreateInfo{
      {
        sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
        stage = {.VERTEX},
        module = vs_module,
        pName = "main",
      },
      {
        sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
        stage = {.FRAGMENT},
        module = fs_module,
        pName = "main",
      },
    }

    vertex_input_ci := vk.PipelineVertexInputStateCreateInfo{
      sType = .PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
    }

    input_assembly_ci := vk.PipelineInputAssemblyStateCreateInfo{
      sType = .PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
      topology = .TRIANGLE_LIST,
      primitiveRestartEnable = false,
    }

    viewport_state_ci := vk.PipelineViewportStateCreateInfo{
      sType = .PIPELINE_VIEWPORT_STATE_CREATE_INFO,
      viewportCount = 1,
      scissorCount = 1,
    }

    rasterization_state_ci := vk.PipelineRasterizationStateCreateInfo{
      sType = .PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
      polygonMode = .FILL,
      cullMode = {},
      frontFace = .COUNTER_CLOCKWISE,
      lineWidth = 1.0,
    }

    multisampling_ci := vk.PipelineMultisampleStateCreateInfo{
      sType = .PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
      rasterizationSamples = {._1},
      sampleShadingEnable = false,
      minSampleShading = 1.0,
    }

    blend_attach_st := vk.PipelineColorBlendAttachmentState{
      blendEnable = false,
      colorWriteMask = {.R, .G, .B, .A},
    }

    blend_state_ci := vk.PipelineColorBlendStateCreateInfo{
      sType = .PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
      logicOpEnable = false,
      logicOp = .COPY,
      attachmentCount = 1,
      pAttachments = &blend_attach_st,
    }

    format := vk.Format.R8G8B8A8_UNORM
    rendering_ci := vk.PipelineRenderingCreateInfo{
      sType = .PIPELINE_RENDERING_CREATE_INFO,
      colorAttachmentCount = 1,
      pColorAttachmentFormats = &format,
      depthAttachmentFormat = g.device.depth_format,
    }

    depth_stencil_ci := vk.PipelineDepthStencilStateCreateInfo{
      sType = .PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO,
      depthTestEnable = true,
      depthWriteEnable = true,
      depthCompareOp = .LESS,
      depthBoundsTestEnable = false,
    }

    dynamic_states := [2]vk.DynamicState{.VIEWPORT, .SCISSOR}
    dynamic_state_ci := vk.PipelineDynamicStateCreateInfo{
      sType = .PIPELINE_DYNAMIC_STATE_CREATE_INFO,
      dynamicStateCount = len(dynamic_states),
      pDynamicStates = raw_data(dynamic_states[:]),
    }

    push_constants_ranges := []vk.PushConstantRange{
      {
        stageFlags = {.VERTEX},
        size = size_of(g.main_constants),
      },
    }

    vk_check(vk.CreatePipelineLayout(g.device.handle, &{
      sType = .PIPELINE_LAYOUT_CREATE_INFO,
      pushConstantRangeCount = 1,
      pPushConstantRanges = raw_data(push_constants_ranges),
      setLayoutCount = len(g.desc_layouts),
      pSetLayouts = raw_data(g.desc_layouts[:]),
    }, nil, &g.pipelines[.Main].layout))

    vk_check(vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
      sType = .GRAPHICS_PIPELINE_CREATE_INFO,
      pNext = &rendering_ci,
      layout = g.pipelines[.Main].layout,
      stageCount = len(shader_stage_cis),
      pStages = raw_data(shader_stage_cis[:]),
      pVertexInputState = &vertex_input_ci,
      pInputAssemblyState = &input_assembly_ci,
      pViewportState = &viewport_state_ci,
      pRasterizationState = &rasterization_state_ci,
      pMultisampleState = &multisampling_ci,
      pColorBlendState = &blend_state_ci,
      pDepthStencilState = &depth_stencil_ci,
      pDynamicState = &dynamic_state_ci,
    }, nil, &g.pipelines[.Main].handle))
  }

  // - Post-processing pipeline ---
  {
    vs_data: []u8 = #load("shaders/out/postprocess.vert.spv")
    fs_data: []u8 = #load("shaders/out/postprocess.frag.spv")

    vs_module: vk.ShaderModule
    vk_check(vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(vs_data),
      pCode = cast(^u32) raw_data(vs_data),
    }, nil, &vs_module))
    defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)

    fs_module: vk.ShaderModule
    vk_check(vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(fs_data),
      pCode = cast(^u32) raw_data(fs_data),
    }, nil, &fs_module))
    defer vk.DestroyShaderModule(g.device.handle, fs_module, nil)

    shader_stage_cis := [2]vk.PipelineShaderStageCreateInfo{
      {
        sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
        stage = {.VERTEX},
        module = vs_module,
        pName = "main",
      },
      {
        sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
        stage = {.FRAGMENT},
        module = fs_module,
        pName = "main",
      },
    }

    vertex_input_ci := vk.PipelineVertexInputStateCreateInfo{
      sType = .PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
    }

    input_assembly_ci := vk.PipelineInputAssemblyStateCreateInfo{
      sType = .PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
      topology = .TRIANGLE_LIST,
      primitiveRestartEnable = false,
    }

    viewport_state_ci := vk.PipelineViewportStateCreateInfo{
      sType = .PIPELINE_VIEWPORT_STATE_CREATE_INFO,
      viewportCount = 1,
      scissorCount = 1,
    }

    rasterization_state_ci := vk.PipelineRasterizationStateCreateInfo{
      sType = .PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
      polygonMode = .FILL,
      cullMode = {.BACK},
      frontFace = .CLOCKWISE,
      lineWidth = 1.0,
    }

    multisampling_ci := vk.PipelineMultisampleStateCreateInfo{
      sType = .PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
      rasterizationSamples = {._1},
      sampleShadingEnable = false,
      minSampleShading = 1.0,
    }

    blend_attach_st := vk.PipelineColorBlendAttachmentState{
      blendEnable = false,
      colorWriteMask = {.R, .G, .B, .A},
    }

    blend_state_ci := vk.PipelineColorBlendStateCreateInfo{
      sType = .PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
      logicOpEnable = false,
      logicOp = .COPY,
      attachmentCount = 1,
      pAttachments = &blend_attach_st,
    }
    
    rendering_ci := vk.PipelineRenderingCreateInfo{
      sType = .PIPELINE_RENDERING_CREATE_INFO,
      colorAttachmentCount = 1,
      pColorAttachmentFormats = &g.device.color_format,
    }

    depth_stencil_ci := vk.PipelineDepthStencilStateCreateInfo{
      sType = .PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO,
      depthTestEnable = false,
      stencilTestEnable = false,
    }

    dynamic_states := [2]vk.DynamicState{.VIEWPORT, .SCISSOR}
    dynamic_state_ci := vk.PipelineDynamicStateCreateInfo{
      sType = .PIPELINE_DYNAMIC_STATE_CREATE_INFO,
      dynamicStateCount = len(dynamic_states),
      pDynamicStates = raw_data(dynamic_states[:]),
    }

    push_constants_ranges := []vk.PushConstantRange{
      {
        stageFlags = {.FRAGMENT},
        size = size_of(g.post_constants),
      },
    }

    vk_check(vk.CreatePipelineLayout(g.device.handle, &{
      sType = .PIPELINE_LAYOUT_CREATE_INFO,
      pushConstantRangeCount = 1,
      pPushConstantRanges = raw_data(push_constants_ranges),
      setLayoutCount = len(g.desc_layouts),
      pSetLayouts = raw_data(g.desc_layouts[:]),
    }, nil, &g.pipelines[.Post].layout))

    vk_check(vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
      sType = .GRAPHICS_PIPELINE_CREATE_INFO,
      pNext = &rendering_ci,
      layout = g.pipelines[.Post].layout,
      stageCount = len(shader_stage_cis),
      pStages = raw_data(shader_stage_cis[:]),
      pVertexInputState = &vertex_input_ci,
      pInputAssemblyState = &input_assembly_ci,
      pViewportState = &viewport_state_ci,
      pRasterizationState = &rasterization_state_ci,
      pMultisampleState = &multisampling_ci,
      pColorBlendState = &blend_state_ci,
      pDepthStencilState = &depth_stencil_ci,
      pDynamicState = &dynamic_state_ci,
    }, nil, &g.pipelines[.Post].handle))
  }

  g.viewport = vk.Viewport{
    x = 0,
    y = 0,
    width = cast(f32) g.swapchain.extent.width, 
    height = cast(f32) g.swapchain.extent.height, 
    minDepth = 0,
    maxDepth = 1,
  }

  g.scissor = vk.Rect2D{
    offset = {0, 0},
    extent = g.swapchain.extent,
  }
}

vk_render :: proc(gm:^ Game)
{
  frame := &g.frames[g.frame_idx]

  g.uniforms.light = 1.0

  vk_check(vk.WaitForFences(g.device.handle, 1, &frame.fence, true, max(u64)))
  vk_check(vk.ResetFences(g.device.handle, 1, &frame.fence))

  image_idx: u32
  vk_check(vk.AcquireNextImageKHR(g.device.handle, g.swapchain.handle, max(u64), frame.present_sem, 0, &image_idx))
  
  vk_check(vk.BeginCommandBuffer(frame.cmd, &{
    sType = .COMMAND_BUFFER_BEGIN_INFO,
    flags = {.ONE_TIME_SUBMIT},
  }))

  // - BEGIN COMMAND BUFFER ---

  vk.CmdUpdateBuffer(frame.cmd, g.frames[g.frame_idx].uniform_buf.handle, 0, size_of(g.uniforms), &g.uniforms)
  vk_cmd_buffer_barrier(frame.cmd, g.vertex_buf.handle,
                        src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                        dst_stages={.VERTEX_SHADER}, dst_access={.SHADER_READ})

  vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].handle, aspect={.COLOR},
                        old_layout=.UNDEFINED, new_layout=.COLOR_ATTACHMENT_OPTIMAL,
                        src_stages={.ALL_COMMANDS}, src_access={.MEMORY_READ},
                        dst_stages={.COLOR_ATTACHMENT_OUTPUT}, dst_access={.COLOR_ATTACHMENT_WRITE})

  vk_cmd_image_barrier(frame.cmd, frame.depth_image.handle, aspect={.DEPTH},
                        old_layout=.UNDEFINED, new_layout=.DEPTH_ATTACHMENT_OPTIMAL,
                        src_stages={.EARLY_FRAGMENT_TESTS, .LATE_FRAGMENT_TESTS}, 
                        src_access={.DEPTH_STENCIL_ATTACHMENT_WRITE},
                        dst_stages={.EARLY_FRAGMENT_TESTS, .LATE_FRAGMENT_TESTS}, 
                        dst_access={.DEPTH_STENCIL_ATTACHMENT_WRITE})

  vk.CmdBeginRendering(frame.cmd, &{
    sType = .RENDERING_INFO,
    renderArea = {{0, 0}, g.swapchain.extent},
    layerCount = 1,
    colorAttachmentCount = 1,
    pColorAttachments = &vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = g.textures[.Screen].view,
      imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
      loadOp = .CLEAR,
      storeOp = .STORE,
      clearValue = {color={float32={0.0, 0.3, 0.7, 0.0}}},
    },
    pDepthAttachment = &vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = frame.depth_image.view,
      imageLayout = .DEPTH_ATTACHMENT_OPTIMAL,
      loadOp = .CLEAR,
      storeOp = .DONT_CARE,
      clearValue = {depthStencil={depth=1}},
    },
  })

  // - BEGIN DRAW PASS 1 ---

  vk.CmdBindPipeline(frame.cmd, .GRAPHICS, g.pipelines[.Main].handle)
  vk.CmdBindIndexBuffer(frame.cmd, g.index_buf.handle, 0, .UINT16)
  vk.CmdBindDescriptorSets(frame.cmd, .GRAPHICS, g.pipelines[.Main].layout, 0, 1, &g.desc_sets[g.frame_idx], 0, nil)

  vk.CmdSetViewport(frame.cmd, 0, 1, &g.viewport)
  vk.CmdSetScissor(frame.cmd, 0, 1, &g.scissor)

  g.main_constants.vertex_addr = g.vertex_buf.address
  g.main_constants.transform = gm.projection

  vk.CmdPushConstants(frame.cmd, g.pipelines[.Main].layout, {.VERTEX}, 0, 
                      size_of(g.main_constants), &g.main_constants)

  vk.CmdDrawIndexed(frame.cmd, u32(len(g.model.indices)), 1, 0, 0, 0)
  // vk.CmdDraw(frame.cmd, u32(len(g.model.vertices)), 1, 0, 0)

  // - END DRAW PASS 1 ---

  vk.CmdEndRendering(frame.cmd)

  vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].handle, aspect={.COLOR},
                        old_layout=.COLOR_ATTACHMENT_OPTIMAL, new_layout=.SHADER_READ_ONLY_OPTIMAL,
                        src_stages={.COLOR_ATTACHMENT_OUTPUT}, src_access={.MEMORY_WRITE},
                        dst_stages={.FRAGMENT_SHADER}, dst_access={.SHADER_READ})

  vk_cmd_image_barrier(frame.cmd, g.swapchain.images[image_idx], aspect={.COLOR},
                        old_layout=.UNDEFINED, new_layout=.COLOR_ATTACHMENT_OPTIMAL,
                        src_stages={.ALL_COMMANDS}, src_access={.MEMORY_READ},
                        dst_stages={.COLOR_ATTACHMENT_OUTPUT}, dst_access={.COLOR_ATTACHMENT_WRITE})

  vk.CmdBeginRendering(frame.cmd, &{
    sType = .RENDERING_INFO,
    renderArea = {{0, 0}, g.swapchain.extent},
    layerCount = 1,
    colorAttachmentCount = 1,
    pColorAttachments = &vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = g.swapchain.image_views[image_idx],
      imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
      loadOp = .CLEAR,
      storeOp = .STORE,
      clearValue = {color={float32={0.0, 0.0, 0.0, 0.0}}},
    },
  })

  // - BEGIN DRAW PASS 2 ---
  
  vk.CmdBindDescriptorSets(frame.cmd, .GRAPHICS, g.pipelines[.Post].layout, 0, 1, &g.desc_sets[g.frame_idx], 0, nil)
  vk.CmdBindPipeline(frame.cmd, .GRAPHICS, g.pipelines[.Post].handle)

  g.post_constants.enabled = false
  vk.CmdPushConstants(frame.cmd, g.pipelines[.Post].layout, {.FRAGMENT}, 0, 
                      size_of(g.post_constants), &g.post_constants)

  vk.CmdDraw(frame.cmd, 6, 1, 0, 0)

  // - END DRAW PASS 2 ---

  vk.CmdEndRendering(frame.cmd)

  vk_cmd_image_barrier(frame.cmd, g.swapchain.images[image_idx],
                        {.COLOR},
                        old_layout=.COLOR_ATTACHMENT_OPTIMAL, new_layout=.PRESENT_SRC_KHR,
                        src_stages={.COLOR_ATTACHMENT_OUTPUT}, src_access={.MEMORY_WRITE},
                        dst_stages={}, dst_access={})

  // - END COMMAND BUFFER ---

  vk_check(vk.EndCommandBuffer(frame.cmd))

  render_done_sem := g.swapchain.image_ready_sems[image_idx]

  vk_check(vk.QueueSubmit(g.device.queue, 1, &vk.SubmitInfo{
    sType = .SUBMIT_INFO,
    commandBufferCount = 1,
    pCommandBuffers = &frame.cmd,
    waitSemaphoreCount = 1,
    pWaitSemaphores = &frame.present_sem,
    pWaitDstStageMask = &vk.PipelineStageFlags{.COLOR_ATTACHMENT_OUTPUT},
    signalSemaphoreCount = 1,
    pSignalSemaphores = &render_done_sem,
  }, frame.fence))

  // - PRESENT ---

  vk_check(vk.QueuePresentKHR(g.device.queue, &{
    sType = .PRESENT_INFO_KHR,
    swapchainCount = 1,
    pSwapchains = &g.swapchain.handle,
    pImageIndices = &image_idx,
    waitSemaphoreCount = 1,
    pWaitSemaphores = &render_done_sem,
  }))

  g.frame_idx = (g.frame_idx + 1) % NUM_FRAMES_IN_FLIGHT
}

vk_done :: proc()
{
  vk.DeviceWaitIdle(g.device.handle)

  vk.DestroySampler(g.device.handle, g.sampler, nil)

  for &tex in g.textures do vk_destroy_image(&tex)

  vk_destroy_buffer(&g.index_buf)
  vk_destroy_buffer(&g.vertex_buf)

  vk.DestroyFence(g.device.handle, g.burst_fence, nil)

  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    vk_destroy_buffer(&g.frames[i].uniform_buf)

    vk.DestroyImageView(g.device.handle, g.frames[i].depth_image.view, nil)
    vma.DestroyImage(g.gpu_allocator, g.frames[i].depth_image.handle, g.frames[i].depth_image.allocation)

    vk.DestroyDescriptorSetLayout(g.device.handle, g.desc_layouts[i], nil)

    vk.DestroyFence(g.device.handle, g.frames[i].fence, nil)
    vk.DestroySemaphore(g.device.handle, g.frames[i].present_sem, nil)
  }

  vma.DestroyAllocator(g.gpu_allocator)

  vk.DestroyDescriptorPool(g.device.handle, g.desc_pool, nil)
  vk.DestroyCommandPool(g.device.handle, g.burst_cmd_pool, nil)
  vk.DestroyCommandPool(g.device.handle, g.frame_cmd_pool, nil)

  for pip in g.pipelines
  {
    vk.DestroyPipelineLayout(g.device.handle, pip.layout, nil)
    vk.DestroyPipeline(g.device.handle, pip.handle, nil)
  }

  vk_destroy_swapchain(&g.swapchain)
  vk_destroy_device(&g.device)

  sdl.Vulkan_DestroySurface(g.instance, g.surface, nil)

  vk.DestroyDebugUtilsMessengerEXT(g.instance, g.debug_messenger, nil)
  vk.DestroyInstance(g.instance, nil)
}

vk_init_instance :: proc()
{
  result: vk.Result
  next: rawptr

  vk.load_proc_addresses_global(rawptr(sdl.Vulkan_GetVkGetInstanceProcAddr()))
  assert(vk.CreateInstance != nil, "\033[31mFatal [render_vk]: Failed to load Vulkan API.")

  layers := [?]cstring{
    "VK_LAYER_KHRONOS_validation",
    "VK_LAYER_KHRONOS_synchronization2",
  }

  extensions := [?]cstring{
    vk.KHR_SURFACE_EXTENSION_NAME,
    vk.KHR_WAYLAND_SURFACE_EXTENSION_NAME,
    vk.EXT_DEBUG_UTILS_EXTENSION_NAME,
  }

  setting_value := true
  layer_settings: []vk.LayerSettingEXT = {
    {"VK_LAYER_KHRONOS_validation", "validate_sync", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "thread_safety", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "legacy_detection", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "validate_best_practices", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "validate_best_practices_nvidia", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "gpuav_enable", .BOOL32, 1, &setting_value},
  }
  layer_settings_ci := vk.LayerSettingsCreateInfoEXT{
    sType = .LAYER_SETTINGS_CREATE_INFO_EXT, 
    settingCount = u32(len(layer_settings)), 
    pSettings = &layer_settings[0],
  }

  debug_messenger_ci := vk.DebugUtilsMessengerCreateInfoEXT{
    sType = .DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
    messageSeverity = {.WARNING, .ERROR},
    messageType = {.GENERAL, .VALIDATION, .PERFORMANCE},
    pfnUserCallback = proc "system" (
      severity: vk.DebugUtilsMessageSeverityFlagsEXT, 
      types: vk.DebugUtilsMessageTypeFlagsEXT, 
      callback_data: ^vk.DebugUtilsMessengerCallbackDataEXT, 
      user_data: rawptr,
    ) -> b32 {
      context = runtime.default_context()
      /**/ if .ERROR in severity do fmt.eprintln("\033[31m[ERROR][render_vk]:\033[0m", callback_data.pMessage)
      else if .WARNING in severity do fmt.eprintln("\033[43m[WARNING][render_vk]:\033[0m", callback_data.pMessage)
      else if .INFO in severity do fmt.eprintln("[INFO][render_vk]:", callback_data.pMessage)
      return false
    },
    pNext = &layer_settings_ci when ODIN_DEBUG else nil,
  }

  next = &debug_messenger_ci

  result = vk.CreateInstance(&{
    sType = .INSTANCE_CREATE_INFO,
    pApplicationInfo = &{
      sType = .APPLICATION_INFO,
      pApplicationName = "VULKAN",
      applicationVersion = vk.MAKE_VERSION(1, 0, 0),
      engineVersion = vk.MAKE_VERSION(1, 0, 0),
      apiVersion = vk.API_VERSION_1_4,
    },
    enabledLayerCount = cast(u32) len(layers) when ODIN_DEBUG else 0,
    ppEnabledLayerNames = raw_data(layers[:]) when ODIN_DEBUG else nil,
    enabledExtensionCount = cast(u32) len(extensions),
    ppEnabledExtensionNames = raw_data(extensions[:]),
    pNext = next,
  }, nil, &g.instance)
  vk_check(result)

  vk.load_proc_addresses_instance(g.instance)
  assert(vk.DestroyInstance != nil, "[FATAL][render_vk]: Failed to load Vulkan instance API.")

  result = vk.CreateDebugUtilsMessengerEXT(g.instance, &debug_messenger_ci, nil, &g.debug_messenger)
  vk_check(result)

  // - Surface ---

  sdl_ok := sdl.Vulkan_CreateSurface(g.window.handle, g.instance, nil, &g.surface)
  if !sdl_ok
  {
    fmt.println("[FATAL][render_vk]: Failed to create Vulkan surface:", sdl.GetError())
    os.exit(1)
  }
}

vk_create_device :: proc() -> Device
{
  device: Device
  result: vk.Result
  next: rawptr

  // - Physical device ---

  physical_devices: [4]vk.PhysicalDevice
  physical_devices_count: u32
  physical_device_props: [4]vk.PhysicalDeviceProperties
  physical_device_qf_props: [4][8]vk.QueueFamilyProperties
  physical_device_qf_props_count: u32
  
  result = vk.EnumeratePhysicalDevices(g.instance, &physical_devices_count, nil)
  vk_check(result)

  result = vk.EnumeratePhysicalDevices(g.instance, &physical_devices_count, &physical_devices[0])
  vk_check(result)

  device_loop: for dev, i in physical_devices[:physical_devices_count]
  {
    vk.GetPhysicalDeviceProperties(dev, &physical_device_props[i])
    vk.GetPhysicalDeviceQueueFamilyProperties(dev, &physical_device_qf_props_count, nil)
    vk.GetPhysicalDeviceQueueFamilyProperties(dev, &physical_device_qf_props_count, &physical_device_qf_props[i][0])

    for fam, j in physical_device_qf_props[i][:physical_device_qf_props_count]
    {
      vk.GetPhysicalDeviceProperties(dev, &physical_device_props[i])

      supports_present: b32
      result = vk.GetPhysicalDeviceSurfaceSupportKHR(dev, u32(j), g.surface, &supports_present)
      vk_check(result)

      if .GRAPHICS in fam.queueFlags && supports_present
      {
        fmt.printf("[INFO][render_vk]: Selected device '%v'.\n", string(physical_device_props[i].deviceName[:]))
        
        device.physical = dev
        device.queue_family_idx = u32(j)
        break device_loop
      }
    }
  }

  assert(device.physical != nil, "[FATAL][render_vk]: No suitable GPU found!")

  for format in ([]vk.Format{.D32_SFLOAT, .D32_SFLOAT_S8_UINT, .D24_UNORM_S8_UINT})
  {
    props: vk.FormatProperties
    vk.GetPhysicalDeviceFormatProperties(device.physical, format, &props)
    if .DEPTH_STENCIL_ATTACHMENT in props.optimalTilingFeatures
    {
      fmt.printf("[INFO][render_vk]: Selected depth format '%v'.\n", format)
      device.depth_format = format
      break
    }
  }

  // - Logical device ---

  extensions := [?]cstring{
    vk.KHR_SWAPCHAIN_EXTENSION_NAME,
  }

  next = &vk.PhysicalDeviceVulkan11Features{
    sType = .PHYSICAL_DEVICE_VULKAN_1_1_FEATURES,
    pNext = next,
    shaderDrawParameters = true,
  }

  next = &vk.PhysicalDeviceVulkan12Features{
    sType = .PHYSICAL_DEVICE_VULKAN_1_2_FEATURES,
    pNext = next,
    bufferDeviceAddress = true,
    descriptorIndexing = true,
    // scalarBlockLayout = true,
  }

  next = &vk.PhysicalDeviceVulkan13Features{
    sType = .PHYSICAL_DEVICE_VULKAN_1_3_FEATURES,
    pNext = next,
    dynamicRendering = true,
    synchronization2 = true,
  }

  next = &vk.PhysicalDeviceVulkan14Features{
    sType = .PHYSICAL_DEVICE_VULKAN_1_4_FEATURES,
    pNext = next,
  }

  queue_priority: f32 = 1.0
  queue_ci := vk.DeviceQueueCreateInfo{
    sType = .DEVICE_QUEUE_CREATE_INFO,
    queueCount = 1,
    queueFamilyIndex = device.queue_family_idx,
    pQueuePriorities = &queue_priority,
  }

  result = vk.CreateDevice(device.physical, &{
    sType = .DEVICE_CREATE_INFO,
    pNext = next,
    queueCreateInfoCount = 1,
    pQueueCreateInfos = &queue_ci,
    enabledExtensionCount = len(extensions),
    ppEnabledExtensionNames = raw_data(extensions[:]),
    pEnabledFeatures = &vk.PhysicalDeviceFeatures{},
  }, nil, &device.handle)
  vk_check(result)

  vk.load_proc_addresses_device(device.handle)
  assert(vk.BeginCommandBuffer != nil, "[FATAL][render_vk]: Failed to load Vulkan device API.")

  vk.GetDeviceQueue(device.handle, device.queue_family_idx, 0, &device.queue)

  return device
}

vk_destroy_device :: proc(device: ^Device)
{
  vk.DestroyDevice(device.handle, nil)
}

vk_create_swapchain :: proc() -> Swapchain
{
  swapchain: Swapchain
  next: rawptr

  capabilities: vk.SurfaceCapabilitiesKHR
  vk_check(vk.GetPhysicalDeviceSurfaceCapabilitiesKHR(g.device.physical, g.surface, &capabilities))

  swapchain.image_count = 3
  if capabilities.maxImageCount > 0
  {
    swapchain.image_count = clamp(swapchain.image_count, capabilities.minImageCount, capabilities.maxImageCount)
  }
  else
  {
    swapchain.image_count = max(swapchain.image_count, capabilities.minImageCount)
  }

  modes: [8]vk.PresentModeKHR
  modes_count: u32
  vk_check(vk.GetPhysicalDeviceSurfacePresentModesKHR(g.device.physical, g.surface, &modes_count, nil))
  vk_check(vk.GetPhysicalDeviceSurfacePresentModesKHR(g.device.physical, g.surface, &modes_count, &modes[0]))

  present_mode: vk.PresentModeKHR = .FIFO
  if USE_MAILBOX do for mode in modes[:modes_count]
  {
    if mode == .MAILBOX
    {
      present_mode = mode
      break
    }
  }

  fmt.printf("[INFO][render_vk]: Selected present mode '%v'.\n", present_mode)

  formats: [16]vk.SurfaceFormatKHR
  formats_count: u32
  vk_check(vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, nil))
  vk_check(vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, &formats[0]))

  surface_format := formats[0]
  for format in formats[:formats_count]
  {
    if (format == vk.SurfaceFormatKHR{.B8G8R8A8_SRGB, .SRGB_NONLINEAR})
    {
      surface_format = format
      g.device.color_format = format.format
      break
    }
  }

  width, height: i32
  sdl.GetWindowSizeInPixels(g.window.handle, &width, &height)
  swapchain.extent = {u32(width), u32(height)}

  swapchain.ci = {
    sType = .SWAPCHAIN_CREATE_INFO_KHR,
    surface = g.surface,
    minImageCount = swapchain.image_count,
    imageFormat = surface_format.format,
    imageColorSpace = surface_format.colorSpace,
    imageExtent = swapchain.extent,
    imageArrayLayers = 1,
    imageUsage = {.COLOR_ATTACHMENT, .TRANSFER_DST},
    imageSharingMode = .EXCLUSIVE,
    preTransform = capabilities.currentTransform,
    compositeAlpha = {.OPAQUE},
    presentMode = present_mode,
    clipped = true,
  }

  vk_check(vk.CreateSwapchainKHR(g.device.handle, &swapchain.ci, nil, &swapchain.handle))

  // - Swapchain images ---

  vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, nil))
  vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, &swapchain.images[0]))

  for image, i in swapchain.images[:swapchain.image_count]
  {
    vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = image,
      viewType = .D2,
      format = surface_format.format,
      subresourceRange = {
        aspectMask = {.COLOR},
        levelCount = 1,
        layerCount = 1,
      },
    }, nil, &swapchain.image_views[i])
  }

  sem_ci := vk.SemaphoreCreateInfo{sType=.SEMAPHORE_CREATE_INFO}
  for i in 0..<swapchain.image_count
  {
    vk_check(vk.CreateSemaphore(g.device.handle, &sem_ci, nil, &swapchain.image_ready_sems[i]))
  }

  fmt.printf("[INFO][render_vk]: Created %v swapchain images.\n", swapchain.image_count)

  return swapchain
}

// vk_recreate_swapchain :: proc()
// {
//   vk.DeviceWaitIdle(g.device.handle)

//   new_swapchain: vk.SwapchainKHR
//   new_swapchain_ci := g.swapchain.ci
//   new_swapchain_ci.imageExtent = 
//   vk.CreateSwapchainKHR(g.device.handle, &g.swapchain.ci, nil, &new_swapchain)

//   vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, nil))
//   vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, &swapchain.images[0]))

//   for image, i in swapchain.images[:swapchain.image_count]
//   {
//     vk.CreateImageView(g.device.handle, &{
//       sType = .IMAGE_VIEW_CREATE_INFO,
//       image = image,
//       viewType = .D2,
//       format = surface_format.format,
//       subresourceRange = {
//         aspectMask = {.COLOR},
//         levelCount = 1,
//         layerCount = 1,
//       },
//     }, nil, &swapchain.image_views[i])
//   }

//   sem_ci := vk.SemaphoreCreateInfo{sType=.SEMAPHORE_CREATE_INFO}
//   for i in 0..<swapchain.image_count
//   {
//     vk_check(vk.CreateSemaphore(g.device.handle, &sem_ci, nil, &swapchain.image_ready_sems[i]))
//   }

//   fmt.printf("[INFO][render_vk]: Created %v swapchain images.\n", swapchain.image_count)
// }

vk_destroy_swapchain :: proc(swapchain: ^Swapchain)
{
  for view in swapchain.image_views do vk.DestroyImageView(g.device.handle, view, nil)

  for sem in swapchain.image_ready_sems do vk.DestroySemaphore(g.device.handle, sem, nil)

  vk.DestroySwapchainKHR(g.device.handle, swapchain.handle, nil)
}

@(require_results)
vk_begin_cmd_burst :: proc() -> vk.CommandBuffer
{
  vk_check(vk.BeginCommandBuffer(g.burst_cmd, &{
    sType = .COMMAND_BUFFER_BEGIN_INFO,
    flags = {.ONE_TIME_SUBMIT},
  }))

  return g.burst_cmd
}

vk_end_cmd_burst :: proc(cmd: vk.CommandBuffer)
{
  vk_check(vk.EndCommandBuffer(cmd))

  vk_check(vk.QueueSubmit(g.device.queue, 1, &vk.SubmitInfo{
    sType = .SUBMIT_INFO,
    commandBufferCount = 1,
    pCommandBuffers = raw_data([]vk.CommandBuffer{cmd}),
  }, g.burst_fence))

  vk_check(vk.WaitForFences(g.device.handle, 1, &g.burst_fence, true, max(u64)))
  vk_check(vk.ResetFences(g.device.handle, 1, &g.burst_fence))
  vk_check(vk.ResetCommandPool(g.device.handle, g.burst_cmd_pool, {}))
}

vk_cmd_buffer_barrier :: proc(
  cmd:        vk.CommandBuffer, 
  buffer:     vk.Buffer,
	src_stages: vk.PipelineStageFlags2,
	src_access: vk.AccessFlags2,
	dst_stages: vk.PipelineStageFlags2,
	dst_access: vk.AccessFlags2,
)
{
  vk.CmdPipelineBarrier2(cmd, &{
    sType = .DEPENDENCY_INFO,
    bufferMemoryBarrierCount = 1,
    pBufferMemoryBarriers = &vk.BufferMemoryBarrier2{
      sType = .BUFFER_MEMORY_BARRIER_2,
      buffer = buffer,
      offset = 0,
      size = vk.DeviceSize(vk.WHOLE_SIZE),
      srcStageMask = src_stages,
      srcAccessMask = src_access,
      dstStageMask = dst_stages,
      dstAccessMask = dst_access,
      srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
      dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
    },
  })
}

vk_cmd_image_barrier :: proc(
  cmd:        vk.CommandBuffer, 
  image:      vk.Image,
  aspect:     vk.ImageAspectFlags, 
	src_stages: vk.PipelineStageFlags2,
	src_access: vk.AccessFlags2,
	dst_stages: vk.PipelineStageFlags2,
	dst_access: vk.AccessFlags2,
  old_layout: vk.ImageLayout = {},
  new_layout: vk.ImageLayout = {},
)
{
  vk.CmdPipelineBarrier2(cmd, &{
    sType = .DEPENDENCY_INFO,
    imageMemoryBarrierCount = 1,
    pImageMemoryBarriers = &vk.ImageMemoryBarrier2{
      sType = .IMAGE_MEMORY_BARRIER_2,
      image = image,
      subresourceRange = {
        aspectMask = aspect,
        layerCount = 1,
        levelCount = 1,
      },
      oldLayout = old_layout,
      newLayout = new_layout,
      srcStageMask = src_stages,
      srcAccessMask = src_access,
      dstStageMask = dst_stages,
      dstAccessMask = dst_access,
      srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
      dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
    },
  })
}

vk_create_buffer :: proc(
  size:      vk.DeviceSize, 
  buf_flags: vk.BufferUsageFlags, 
  mem_flags: vk.MemoryPropertyFlags,
) -> Buffer 
{
  buffer: Buffer

  buffer_ci := vk.BufferCreateInfo{
    sType = .BUFFER_CREATE_INFO,
    usage = buf_flags,
    sharingMode = .EXCLUSIVE,
    size = size,
    queueFamilyIndexCount = 1,
    pQueueFamilyIndices = &g.device.queue_family_idx,
  }
  allocation_ci := vma.AllocationCreateInfo{
    usage = .AUTO,
    flags = (.HOST_VISIBLE in mem_flags) ? {.MAPPED} : {},
    preferredFlags = mem_flags,
  }
  vk_check(vma.CreateBuffer(g.gpu_allocator, 
                            &buffer_ci, 
                            &allocation_ci, 
                            &buffer.handle,
                            &buffer.allocation,
                            &buffer.info))
  
  return buffer
}

vk_copy_to_buffers :: proc(src: ^Buffer, dsts: []^Buffer, sizes: []vk.DeviceSize)
{
  cmd := vk_begin_cmd_burst()

  src_offset: vk.DeviceSize
  for i in 0..<len(dsts)
  {
    vk.CmdCopyBuffer(g.burst_cmd, src.handle, dsts[i].handle, 1, &vk.BufferCopy{src_offset, 0, sizes[i]})
    src_offset += sizes[i]
  }

  vk_end_cmd_burst(cmd)
}

vk_destroy_buffer :: proc(buffer: ^Buffer)
{
  vma.DestroyBuffer(g.gpu_allocator, buffer.handle, buffer.allocation)
}

vk_create_image :: proc(
  width:  u32, 
  height: u32, 
  format: vk.Format,
  layout: vk.ImageLayout,
  aspect: vk.ImageAspectFlags,
  usage:  vk.ImageUsageFlags,
) -> Image
{
  image: Image

  image_ci := vk.ImageCreateInfo{
    sType = .IMAGE_CREATE_INFO,
    format = format,
    extent = {
      width = width,
      height = height,
      depth = 1,
    },
    imageType = .D2,
    mipLevels = 1,
    arrayLayers = 1,
    samples = {._1},
    usage = usage,
    tiling = .OPTIMAL,
    initialLayout = .UNDEFINED,
  }
  allocation_ci := vma.AllocationCreateInfo{
    usage = .AUTO,
    preferredFlags = {.DEVICE_LOCAL},
  }
  vk_check(vma.CreateImage(g.gpu_allocator, 
                           &image_ci, 
                           &allocation_ci, 
                           &image.handle, 
                           &image.allocation, 
                           &image.info))

  vk_check(vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = image.handle,
      viewType = .D2,
      format = format,
      subresourceRange = {
        aspectMask = aspect,
        levelCount = 1,
        layerCount = 1,
      },
  }, nil, &image.view))

  return image
}

vk_create_texture :: proc(
  pixels: []byte, 
  width:  u32, 
  height: u32, 
  format: vk.Format,
  layout: vk.ImageLayout = .SHADER_READ_ONLY_OPTIMAL,
  usage:  vk.ImageUsageFlags = {}
) -> Image
{
  texture := vk_create_image(width, height, format, layout, {.COLOR}, usage + {.TRANSFER_DST, .SAMPLED})

  staging_buf := vk_create_buffer(vk.DeviceSize(len(pixels)), 
                                  buf_flags={.TRANSFER_SRC}, 
                                  mem_flags={.HOST_VISIBLE})
  defer vk_destroy_buffer(&staging_buf)

  mem.copy(staging_buf.info.pMappedData, raw_data(pixels), len(pixels))

  cmd := vk_begin_cmd_burst()

  vk_cmd_image_barrier(cmd, texture.handle, 
                        {.COLOR},
                        old_layout=.UNDEFINED, new_layout=.TRANSFER_DST_OPTIMAL,
                        src_stages={.TOP_OF_PIPE}, src_access={},
                        dst_stages={.TRANSFER}, dst_access={.TRANSFER_WRITE})

  vk.CmdCopyBufferToImage(cmd, staging_buf.handle, texture.handle,
                          dstImageLayout=.TRANSFER_DST_OPTIMAL,
                          regionCount=1,
                          pRegions=&vk.BufferImageCopy{
                            imageExtent = {
                              width = width,
                              height = height,
                              depth = 1,
                            },
                            imageSubresource = {
                              aspectMask = {.COLOR},
                              layerCount = 1,
                            },
                          })

  vk_cmd_image_barrier(cmd, texture.handle, 
                        {.COLOR},
                        old_layout=.TRANSFER_DST_OPTIMAL, new_layout=layout,
                        src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                        dst_stages={.FRAGMENT_SHADER}, dst_access={.SHADER_READ})

  vk_end_cmd_burst(cmd)

  return texture
}

vk_destroy_image :: proc(texture: ^Image)
{
  vk.DestroyImageView(g.device.handle, texture.view, nil)
  vma.DestroyImage(g.gpu_allocator, texture.handle, texture.allocation)
}

load_model :: proc(path: string, arena: ^mem.Arena) -> (model: Model, result: cgltf.result)
{
  scratch := mem.temp_begin(mem.get_scratch(arena))
  defer mem.temp_end(scratch)

  path_cstr := strings.clone_to_cstring(path, mem.allocator(arena))

  data := cgltf.parse_file({}, path_cstr) or_return
  defer cgltf.free(data)

  cgltf.load_buffers({file=data.file}, data, path_cstr) or_return

  vertices: [dynamic]Vertex
  vertices.allocator = mem.allocator(arena)
  vertex_idx: int

  indices: [dynamic]u16
  indices.allocator = mem.allocator(arena)
  index_idx: int

  for &mesh, mesh_idx in data.meshes
  {
    for &prim, prim_idx in mesh.primitives
    {
      prim_vertex_count := int(prim.attributes[0].data.count)

      resize(&vertices, len(vertices) + prim_vertex_count)

      for &attr, attr_idx in prim.attributes
      {
        // fmt.println(mesh_idx, prim_idx, attr.type, attr.data.count, prim.indices.count)
        #partial switch attr.type
        {
        case .position:
          for i in 0..<prim_vertex_count
          {
            ok := cgltf.accessor_read_float(attr.data, uint(i), &vertices[vertex_idx + i].position[0], 3)
            if !ok do return {}, .invalid_options
          }
        
        case .normal:
          for i in 0..<prim_vertex_count
          {
            ok := cgltf.accessor_read_float(attr.data, uint(i), &vertices[vertex_idx + i].normal[0], 3)
            if !ok do return {}, .invalid_options
          }

        case .color:
          for i in 0..<prim_vertex_count
          {
            ok := cgltf.accessor_read_float(attr.data, uint(i), &vertices[vertex_idx + i].color[0], 4)
            if !ok do return {}, .invalid_options
          }

        case .texcoord:
          for i in 0..<prim_vertex_count
          {
            ok := cgltf.accessor_read_float(attr.data, uint(i), &vertices[vertex_idx + i].uv[0], 2)
            if !ok do return {}, .invalid_options
          }
        }
      }

      for i in 0..<prim_vertex_count
      {
        vertices[vertex_idx + i].color = prim.material.pbr_metallic_roughness.base_color_factor
      }

      if prim.indices != nil
      {
        prim_index_count := int(prim.indices.count)

        resize(&indices, len(indices) + prim_index_count)

        for i in 0..<int(prim.indices.count)
        {
          index := cgltf.accessor_read_index(prim.indices, uint(i))
          indices[index_idx + i] = u16(vertex_idx) + u16(index)
        }

        index_idx += prim_index_count
      }

      vertex_idx += prim_vertex_count
    }
  }

  model.vertices = vertices[:]
  model.indices = indices[:]

  return model, .success
}

vk_check :: proc(result: vk.Result, location := #caller_location)
{
  if result == .TIMEOUT || result == .SUBOPTIMAL_KHR
  {
    fmt.println("\033[33m[WARNING][render_vk]:\033[0m", result, "at", location)
  }
  else if result != .SUCCESS
  {
    fmt.println("\033[31m[FATAL][render_vk]:\033[0m", result, "at", location)
    os.exit(1)
  }
}

rgba_from_hsva :: proc(hsva: [4]f32) -> (rgba: [4]f32)
{
  h, s, v, a := hsva[0], hsva[1], hsva[2], hsva[3]

  if s == 0 do return {v, v, v, a}

  h6 := h * 6
  if h6 >= 6 do h6 = 0

  sector := cast(int) h6
  f := h6 - cast(f32) sector

  p := v * (1 - s)
  q := v * (1 - s * f)
  t := v * (1 - s * (1 - f))

  r, g, b: f32
  switch sector
  {
  case 0: r, g, b = v, t, p
  case 1: r, g, b = q, v, p
  case 2: r, g, b = p, v, t
  case 3: r, g, b = p, q, v
  case 4: r, g, b = t, p, v
  case 5: r, g, b = v, p, q
  }

  return {r, g, b, a}
}
