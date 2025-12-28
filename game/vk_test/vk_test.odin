package vk_test

import "base:runtime"
import "core:fmt"
import "core:math"
import os "core:os/os2"
import "ext:sdl"
import vk "ext:vulkan"
import vma "ext:vma"
import "../basic/mem"
import "../basic/vmath"

USE_MAILBOX :: false

WINDOW_WIDTH  :: 960
WINDOW_HEIGHT :: 540

NUM_FRAMES_IN_FLIGHT :: 2

Device :: struct
{
  handle:           vk.Device,
  physical:         vk.PhysicalDevice,
  memory_props:     vk.PhysicalDeviceMemoryProperties,
  queue_family_idx: u32,
  queue:            vk.Queue,
}

Swapchain :: struct
{
  handle:           vk.SwapchainKHR,
  images:           [dynamic]vk.Image,
  image_views:      [dynamic]vk.ImageView,
  image_ready_sems: []vk.Semaphore,
  format:           vk.Format,
  extent:           vk.Extent2D,
}

Frame_Data :: struct
{
  fence:            vk.Fence,
  present_done_sem: vk.Semaphore,
  cmd:              vk.CommandBuffer, 
  uniform_buf:      Buffer,
}

Buffer :: struct
{
  handle:     vk.Buffer,
  address:    vk.DeviceAddress,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
}

Vertex :: struct
{
  position: [4]f32,
  color:    [4]f32,
}

g: struct
{
  instance:          vk.Instance,
  debug_messenger:   vk.DebugUtilsMessengerEXT,
  window:            ^sdl.Window,
  surface:           vk.SurfaceKHR,
  device:            Device,
  swapchain:         Swapchain,
  frame_cmd_pool:    vk.CommandPool,
  frames:            [NUM_FRAMES_IN_FLIGHT]Frame_Data,
  uniform_desc_sets: [NUM_FRAMES_IN_FLIGHT]vk.DescriptorSet,
  uniform_layouts:   [NUM_FRAMES_IN_FLIGHT]vk.DescriptorSetLayout,
  frame_idx:         int,
  gpu_allocator:     vma.Allocator,
  copy_cmd_pool:     vk.CommandPool,
  copy_cmd:          vk.CommandBuffer,
  uniform_desc_pool: vk.DescriptorPool,
  pipeline:          vk.Pipeline,
  pipeline_layout:   vk.PipelineLayout,
  viewport:          vk.Viewport,
  scissor:           vk.Rect2D,

  push_constants:    struct
  {
    transform:       matrix[4,4]f32,
    vertex_addr:     vk.DeviceAddress,
  },
  uniforms:          struct
  {
    light:           [4]f32,
  },
  vertices:          [4]Vertex,
  vertex_buf:        Buffer,
  indices:           [6]u8,
  index_buf:         Buffer,
}

vma_init :: proc()
{
  vulkan_functions := vma.create_vulkan_functions()
  allocator_ci := vma.AllocatorCreateInfo{
  	vulkanApiVersion = vk.API_VERSION_1_4,
  	pVulkanFunctions = &vulkan_functions,
  	instance = g.instance,
  	physicalDevice = g.device.physical,
  	device = g.device.handle,
    flags = {.BUFFER_DEVICE_ADDRESS},
  }

  result := vma.CreateAllocator(&allocator_ci, &g.gpu_allocator)
  vk_check(result)
}

vma_done :: proc()
{
  vma.DestroyAllocator(g.gpu_allocator)
}

vk_init :: proc()
{
  vk_init_instance()
  vk_init_device()
  vk_init_swapchain()
}

vk_init_instance :: proc()
{
  result: vk.Result
  next: rawptr

  vk.load_proc_addresses_global(rawptr(sdl.Vulkan_GetVkGetInstanceProcAddr()))
  assert(vk.CreateInstance != nil, "\033[31mFatal [render_vk]: Failed to load Vulkan API.")

  layers := [?]cstring{
    "VK_LAYER_KHRONOS_validation",
    "VK_LAYER_KHRONOS_profiles",
    "VK_LAYER_KHRONOS_synchronization2",
  }

  extensions := [?]cstring{
    vk.KHR_SURFACE_EXTENSION_NAME,
    vk.KHR_WAYLAND_SURFACE_EXTENSION_NAME,
    vk.EXT_DEBUG_UTILS_EXTENSION_NAME,
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
      /**/ if .ERROR in severity do fmt.eprintln("\033[31mError [render_vk]:\033[0m", callback_data.pMessage)
      else if .WARNING in severity do fmt.eprintln("\033[43mWarning [render_vk]:\033[0m", callback_data.pMessage)
      else if .INFO in severity do fmt.eprintln("Info [render_vk]:", callback_data.pMessage)
      return false
    },
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
    enabledLayerCount = cast(u32) len(layers),
    ppEnabledLayerNames = raw_data(layers[:]),
    enabledExtensionCount = cast(u32) len(extensions),
    ppEnabledExtensionNames = raw_data(extensions[:]),
    pNext = next,
  }, nil, &g.instance)
  vk_check(result)

  vk.load_proc_addresses_instance(g.instance)
  assert(vk.DestroyInstance != nil, "Fatal [render_vk]: Failed to load Vulkan instance API.")

  result = vk.CreateDebugUtilsMessengerEXT(g.instance, &debug_messenger_ci, nil, &g.debug_messenger)
  vk_check(result)
}

vk_init_device :: proc()
{
  result: vk.Result
  next: rawptr

  // - Surface ---

  sdl_ok := sdl.Vulkan_CreateSurface(g.window, g.instance, nil, &g.surface)
  if !sdl_ok
  {
    fmt.println("Failed to create Vulkan surface:", sdl.GetError())
    os.exit(1)
  }

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
        fmt.printf("Info [render_vk]: Selected device '%v'.\n", string(physical_device_props[i].deviceName[:]))
        
        g.device.physical = dev
        g.device.queue_family_idx = u32(j)
        break device_loop
      }
    }
  }

  assert(g.device.physical != nil, "Fatal [render_vk]: No suitable GPU found!")

  vk.GetPhysicalDeviceMemoryProperties(g.device.physical, &g.device.memory_props)

  // - Logical device ---

  extensions := [?]cstring{
    vk.KHR_PORTABILITY_SUBSET_EXTENSION_NAME,
    vk.KHR_SWAPCHAIN_EXTENSION_NAME,
  }

  next = &vk.PhysicalDeviceVulkan12Features{
    sType = .PHYSICAL_DEVICE_VULKAN_1_2_FEATURES,
    pNext = next,
    bufferDeviceAddress = true,
    descriptorIndexing = true,
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
    indexTypeUint8 = true,
  }

  queue_priority: f32 = 1.0
  queue_ci := vk.DeviceQueueCreateInfo{
    sType = .DEVICE_QUEUE_CREATE_INFO,
    queueCount = 1,
    queueFamilyIndex = g.device.queue_family_idx,
    pQueuePriorities = &queue_priority,
  }

  result = vk.CreateDevice(g.device.physical, &{
    sType = .DEVICE_CREATE_INFO,
    pNext = next,
    queueCreateInfoCount = 1,
    pQueueCreateInfos = &queue_ci,
    enabledExtensionCount = len(extensions),
    ppEnabledExtensionNames = raw_data(extensions[:]),
    pEnabledFeatures = &vk.PhysicalDeviceFeatures{},
  }, nil, &g.device.handle)
  vk_check(result)

  vk.load_proc_addresses_device(g.device.handle)
  assert(vk.BeginCommandBuffer != nil, "Fatal [render_vk]: Failed to load Vulkan device API.")

  vk.GetDeviceQueue(g.device.handle, g.device.queue_family_idx, 0, &g.device.queue)
}

vk_init_swapchain :: proc()
{
  result: vk.Result
  next: rawptr

  capabilities: vk.SurfaceCapabilitiesKHR
  result = vk.GetPhysicalDeviceSurfaceCapabilitiesKHR(g.device.physical, g.surface, &capabilities)
  vk_check(result)

  image_count: u32 = 3
  if capabilities.maxImageCount > 0
  {
    image_count = clamp(image_count, capabilities.minImageCount, capabilities.maxImageCount)
  }
  else
  {
    image_count = max(image_count, capabilities.minImageCount)
  }

  formats: [16]vk.SurfaceFormatKHR
  formats_count: u32
  result = vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, nil)
  vk_check(result)
  result = vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, &formats[0])
  vk_check(result)

  surface_format: vk.SurfaceFormatKHR = formats[0]
  for format in formats[:formats_count]
  {
    if (format == vk.SurfaceFormatKHR{.B8G8R8A8_SRGB, .SRGB_NONLINEAR})
    {
      surface_format = format
      g.swapchain.format = format.format
      break
    }
  }

  width, height: i32
  sdl.GetWindowSizeInPixels(g.window, &width, &height)

  modes: [8]vk.PresentModeKHR
  modes_count: u32
  result = vk.GetPhysicalDeviceSurfacePresentModesKHR(g.device.physical, g.surface, &modes_count, nil)
  vk_check(result)
  result = vk.GetPhysicalDeviceSurfacePresentModesKHR(g.device.physical, g.surface, &modes_count, &modes[0])
  vk_check(result)

  present_mode: vk.PresentModeKHR = .FIFO
  if USE_MAILBOX do for mode in modes[:modes_count]
  {
    if mode == .MAILBOX
    {
      present_mode = mode
      break
    }
  }

  fmt.printf("Info [render_vk]: Selected present mode '%v'.\n", present_mode)

  g.swapchain.extent = {u32(width), u32(height)}

  result = vk.CreateSwapchainKHR(g.device.handle, &{
    sType = .SWAPCHAIN_CREATE_INFO_KHR,
    surface = g.surface,
    minImageCount = image_count,
    imageFormat = surface_format.format,
    imageColorSpace = surface_format.colorSpace,
    imageExtent = g.swapchain.extent,
    imageArrayLayers = 1,
    imageUsage = {.COLOR_ATTACHMENT, .TRANSFER_DST},
    imageSharingMode = .EXCLUSIVE,
    preTransform = capabilities.currentTransform,
    compositeAlpha = {.OPAQUE},
    presentMode = present_mode,
    clipped = true,
  }, nil, &g.swapchain.handle)
  vk_check(result)

  // - Swapchain images ---

  vk.GetSwapchainImagesKHR(g.device.handle, g.swapchain.handle, &image_count, nil)
  g.swapchain.images.allocator = context.allocator
  resize(&g.swapchain.images, image_count)
  resize(&g.swapchain.image_views, image_count)
  vk.GetSwapchainImagesKHR(g.device.handle, g.swapchain.handle, &image_count, &g.swapchain.images[0])

  for image, i in g.swapchain.images
  {
    vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = image,
      viewType = .D2,
      format = g.swapchain.format,
      components = {r=.IDENTITY, g=.IDENTITY, b=.IDENTITY, a=.IDENTITY},
      subresourceRange = {
        aspectMask = {.COLOR},
        levelCount = 1,
        layerCount = 1,
      },
    }, nil, &g.swapchain.image_views[i])
  }

  g.swapchain.image_ready_sems = make([]vk.Semaphore, len(g.swapchain.images), context.allocator)
  sem_ci := vk.SemaphoreCreateInfo{sType=.SEMAPHORE_CREATE_INFO}
  for i in 0..<len(g.swapchain.image_ready_sems)
  {
    result = vk.CreateSemaphore(g.device.handle, &sem_ci, nil, &g.swapchain.image_ready_sems[i])
    vk_check(result)
  }

  fmt.printf("Info [render_vk]: Created %v swapchain images.\n", image_count)
}

vk_done :: proc()
{
  vk.DestroyPipelineLayout(g.device.handle, g.pipeline_layout, nil)
  vk.DestroyPipeline(g.device.handle, g.pipeline, nil)

  for view in g.swapchain.image_views do vk.DestroyImageView(g.device.handle, view, nil)

  for sem in g.swapchain.image_ready_sems do vk.DestroySemaphore(g.device.handle, sem, nil)

  vk.DestroySwapchainKHR(g.device.handle, g.swapchain.handle, nil)
  vk.DestroyDevice(g.device.handle, nil)
  sdl.Vulkan_DestroySurface(g.instance, g.surface, nil)
  vk.DestroyDebugUtilsMessengerEXT(g.instance, g.debug_messenger, nil)
  vk.DestroyInstance(g.instance, nil)
}

main :: proc()
{
  _ = sdl.Init({.VIDEO})
  g.window = sdl.CreateWindow("VULKAN", WINDOW_WIDTH, WINDOW_HEIGHT, {.VULKAN})

  vk_init()
  
  vma_init()

  result: vk.Result

  result = vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.TRANSIENT},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.copy_cmd_pool)
  vk_check(result)

  result = vk.AllocateCommandBuffers(g.device.handle, &{
    sType = .COMMAND_BUFFER_ALLOCATE_INFO,
    commandPool = g.copy_cmd_pool,
    level = .PRIMARY,
    commandBufferCount = 1,
  }, &g.copy_cmd)
  vk_check(result)

  result = vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.RESET_COMMAND_BUFFER},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.frame_cmd_pool)
  vk_check(result)

  result = vk.CreateDescriptorPool(g.device.handle, &{
    sType = .DESCRIPTOR_POOL_CREATE_INFO,
    maxSets = NUM_FRAMES_IN_FLIGHT,
    poolSizeCount = 1,
    pPoolSizes = &vk.DescriptorPoolSize{
      descriptorCount = 2,
      type = .UNIFORM_BUFFER,
    },
  }, nil, &g.uniform_desc_pool)

  // - Frame data ---
  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    frame := &g.frames[i]

    result = vk.CreateSemaphore(g.device.handle, &{sType=.SEMAPHORE_CREATE_INFO}, nil, &frame.present_done_sem)
    vk_check(result)

    result = vk.CreateFence(g.device.handle, &{sType=.FENCE_CREATE_INFO, flags={.SIGNALED}}, nil, &frame.fence)
    vk_check(result)

    result = vk.AllocateCommandBuffers(g.device.handle, &{
      sType = .COMMAND_BUFFER_ALLOCATE_INFO,
      commandPool = g.frame_cmd_pool,
      level = .PRIMARY,
      commandBufferCount = 1,
    }, &frame.cmd)
    vk_check(result)

    vk.CreateDescriptorSetLayout(g.device.handle, &{
      sType = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
      flags = {},
      bindingCount = 1,
      pBindings = &vk.DescriptorSetLayoutBinding{
        binding = 0,
        descriptorCount = 1,
        descriptorType = .UNIFORM_BUFFER,
        stageFlags = {.VERTEX},
      },
    }, nil, &g.uniform_layouts[i])

    frame.uniform_buf = vk_create_buffer(size_of(g.uniforms), 
                                         buf_flags={.UNIFORM_BUFFER},
                                         alloc_flags={.MAPPED},
                                         mem_flags={.HOST_VISIBLE})
  }

  result = vk.AllocateDescriptorSets(g.device.handle, &{
    sType = .DESCRIPTOR_SET_ALLOCATE_INFO,
    descriptorPool = g.uniform_desc_pool,
    descriptorSetCount = NUM_FRAMES_IN_FLIGHT,
    pSetLayouts = raw_data(g.uniform_layouts[:]),
  }, raw_data(g.uniform_desc_sets[:]))

  write_desc_sets: [NUM_FRAMES_IN_FLIGHT]vk.WriteDescriptorSet
  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    write_desc_sets[i] = {
      sType = .WRITE_DESCRIPTOR_SET,
      descriptorCount = 1,
      descriptorType = .UNIFORM_BUFFER,
      dstSet = g.uniform_desc_sets[i],
      pBufferInfo = &{
        buffer = g.frames[i].uniform_buf.handle,
        range = size_of(g.uniforms),
      },
    }
  }

  vk.UpdateDescriptorSets(g.device.handle, 2, raw_data(write_desc_sets[:]), 0, nil)

  // - Vertex and index buffer ---
  {
    vertices_size: vk.DeviceSize = len(g.vertices) * size_of(Vertex)
    indices_size: vk.DeviceSize = len(g.indices) * size_of(u8)

    staging_buf := vk_create_buffer(vertices_size + indices_size, 
                                    buf_flags={.TRANSFER_SRC}, 
                                    alloc_flags={.MAPPED}, 
                                    mem_flags={.HOST_VISIBLE})
    defer vk_destroy_buffer(&staging_buf)

    g.vertex_buf = vk_create_buffer(vertices_size, 
                                    buf_flags={.VERTEX_BUFFER, .TRANSFER_DST, .SHADER_DEVICE_ADDRESS}, 
                                    alloc_flags={}, 
                                    mem_flags={.DEVICE_LOCAL})


    g.vertex_buf.address = vk.GetBufferDeviceAddress(g.device.handle, &{
      sType = .BUFFER_DEVICE_ADDRESS_INFO,
      buffer = g.vertex_buf.handle,
    })

    g.vertices = {
      {{0, 0, 1, 1}, {1.0, 0.0, 1.0, 1.0}},
      {{1, 0, 1, 1}, {0.0, 1.0, 1.0, 1.0}},
      {{1, 1, 1, 1}, {0.0, 0.0, 1.0, 1.0}},
      {{0, 1, 1, 1}, {1.0, 1.0, 1.0, 1.0}},
    }

    mem.copy(staging_buf.info.pMappedData, raw_data(g.vertices[:]), vertices_size)

    g.index_buf = vk_create_buffer(indices_size, 
                                   buf_flags={.INDEX_BUFFER, .TRANSFER_DST}, 
                                   alloc_flags={}, 
                                   mem_flags={.DEVICE_LOCAL})

    g.indices = {
      0, 1, 3,
      1, 2, 3,
    }

    indices_offset_addr := rawptr(uintptr(staging_buf.info.pMappedData) + uintptr(vertices_size))
    mem.copy(indices_offset_addr, raw_data(g.indices[:]), indices_size)

    vk_copy_buffers(&staging_buf, {&g.vertex_buf, &g.index_buf}, {vertices_size, indices_size})
  }
  
  // - Pipeline ---
  {
    vs_data: []u8 = #load("shaders/spirv/shader.vert.spv")
    fs_data: []u8 = #load("shaders/spirv/shader.frag.spv")

    vs_module: vk.ShaderModule
    vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(vs_data),
      pCode = cast(^u32) raw_data(vs_data),
    }, nil, &vs_module)
    defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)

    fs_module: vk.ShaderModule
    vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(fs_data),
      pCode = cast(^u32) raw_data(fs_data),
    }, nil, &fs_module)
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

    push_constants_ranges := []vk.PushConstantRange{
      {
        stageFlags = {.VERTEX},
        size = size_of(g.push_constants),
      },
    }

    result = vk.CreatePipelineLayout(g.device.handle, &{
      sType = .PIPELINE_LAYOUT_CREATE_INFO,
      pushConstantRangeCount = 1,
      pPushConstantRanges = raw_data(push_constants_ranges),
      setLayoutCount = 1,
      pSetLayouts = raw_data(g.uniform_layouts[:]),
    }, nil, &g.pipeline_layout)
    vk_check(result)

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
      pColorAttachmentFormats = &g.swapchain.format,
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

    result = vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
      sType = .GRAPHICS_PIPELINE_CREATE_INFO,
      pNext = &rendering_ci,
      layout = g.pipeline_layout,
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
    }, nil, &g.pipeline)
    vk_check(result)
  }

  t: f64
  dt: f64
  space_down: bool
  r_down: bool
  should_close: bool

  for !should_close
  {
    sdl.PumpEvents()

    event: sdl.Event
    for sdl.PollEvent(&event)
    {
      #partial switch event.type
      {
      case .QUIT: 
        should_close = true
      case .KEY_DOWN:
        #partial switch event.key.scancode
        {
        case .ESCAPE:
          should_close = true
        case .SPACE:
          space_down = true
        case .R:
          r_down = true
        }
      case .KEY_UP:
        #partial switch event.key.scancode
        {
        case .SPACE:
          space_down = false
        case .R:
          r_down = false
        }
      }
    }

    frame := &g.frames[g.frame_idx]

    result = vk.WaitForFences(g.device.handle, 1, &frame.fence, true, max(u64))
    vk_check(result)
    result = vk.ResetFences(g.device.handle, 1, &frame.fence)
    vk_check(result)

    image_idx: u32
    result = vk.AcquireNextImageKHR(g.device.handle, 
                                    g.swapchain.handle, 
                                    max(u64), 
                                    frame.present_done_sem, 
                                    0, 
                                    &image_idx)
    vk_check(result)
    
    result = vk.BeginCommandBuffer(frame.cmd, &{
      sType = .COMMAND_BUFFER_BEGIN_INFO,
      flags = {.ONE_TIME_SUBMIT},
    })
    vk_check(result)

    // - BEGIN COMMAND BUFFER ---

    // g.vertices = {
      // {{0, 0, 1, 1}, {1.0, 0.0, 1.0, 1.0}},
      // {{100, 0, 1, 1}, {1.0, 0.0, 1.0, 1.0}},
      // {{100, 100, 1, 1}, {1.0, 0.0, 1.0, 1.0}},
      // {{0, 100, 1, 1}, {1.0, 0.0, 0.0, 1.0}},
    // }

    // vk.CmdUpdateBuffer(frame.cmd, g.vertex_buf.handle, 0, size_of(g.vertices), raw_data(g.vertices[:]))

    g.uniforms.light.rgb = 0.5
    g.uniforms.light.a = 1
    mem.copy(g.frames[g.frame_idx].uniform_buf.info.pMappedData, &g.uniforms, size_of(g.uniforms))

    transition_to_attachment_barrier := vk.ImageMemoryBarrier2{
      sType = .IMAGE_MEMORY_BARRIER_2,
      image = g.swapchain.images[image_idx],
      subresourceRange = {
        aspectMask = {.COLOR},
        layerCount = 1,
        levelCount = 1,
      },
      oldLayout = .UNDEFINED,
      newLayout = .COLOR_ATTACHMENT_OPTIMAL,
      srcStageMask = {.ALL_COMMANDS},
      srcAccessMask = {.MEMORY_READ},
      srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
      dstStageMask = {.COLOR_ATTACHMENT_OUTPUT},
      dstAccessMask = {.COLOR_ATTACHMENT_WRITE},
      dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
    }
    vk.CmdPipelineBarrier2(frame.cmd, &{
      sType = .DEPENDENCY_INFO,
      dependencyFlags = {},
      imageMemoryBarrierCount = 1,
      pImageMemoryBarriers = &transition_to_attachment_barrier,
    })

    color_attachment := vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = g.swapchain.image_views[image_idx],
      imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
      loadOp = .CLEAR,
      storeOp = .STORE,
      clearValue = {color={float32={0.0, 0.0, 0.0, 0.0}}},
    }
    vk.CmdBeginRendering(frame.cmd, &{
      sType = .RENDERING_INFO,
      renderArea = {{0, 0}, g.swapchain.extent},
      layerCount = 1,
      colorAttachmentCount = 1,
      pColorAttachments = &color_attachment,
    })

    // - BEGIN DRAW ---

    vk.CmdBindPipeline(frame.cmd, .GRAPHICS, g.pipeline)

    g.viewport = vk.Viewport{
      x = 0,
      y = 0,
      width = cast(f32) g.swapchain.extent.width, 
      height = cast(f32) g.swapchain.extent.height, 
      minDepth = 0,
      maxDepth = 1,
    }

    vk.CmdSetViewport(frame.cmd, 0, 1, &g.viewport)

    g.scissor = vk.Rect2D{
      offset = {0, 0},
      extent = g.swapchain.extent,
    }

    vk.CmdSetScissor(frame.cmd, 0, 1, &g.scissor)

    g.push_constants.vertex_addr = g.vertex_buf.address

    transform := vmath.orthographic_3x3f(0, WINDOW_WIDTH, WINDOW_HEIGHT, 0)
    transform *= vmath.translation_3x3f({WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50})
    transform *= vmath.translation_3x3f({50, 50})
    transform *= vmath.rotation_3x3f(f32(t))
    transform *= vmath.translation_3x3f({-50, -50})
    transform *= vmath.scale_3x3f({100, 100})

    if r_down
    {
      t = 0
      dt = 0
    }
    else if space_down
    {
      dt = clamp(dt+0.0005, 0.005, 0.2)
    }
    else
    {
      dt = clamp(dt-0.0005, 0.005, 0.2)
    }

    t += dt

    g.push_constants.transform = cast(vmath.m4f32) transform
    vk.CmdPushConstants(frame.cmd, g.pipeline_layout, {.VERTEX}, 0, size_of(g.push_constants), &g.push_constants)

    vk.CmdBindIndexBuffer(frame.cmd, g.index_buf.handle, 0, .UINT8)

    vk.CmdBindDescriptorSets2(frame.cmd, &{
      sType = .BIND_DESCRIPTOR_SETS_INFO,
      descriptorSetCount = 1,
      pDescriptorSets = &g.uniform_desc_sets[g.frame_idx],
      layout = g.pipeline_layout,
      stageFlags = {.VERTEX},
    })

    vk.CmdDrawIndexed(frame.cmd, len(g.indices), 1, 0, 0, 0)

    // - END DRAW ---

    vk.CmdEndRendering(frame.cmd)

    transition_to_present_barrier := vk.ImageMemoryBarrier2{
      sType = .IMAGE_MEMORY_BARRIER_2,
      image = g.swapchain.images[image_idx],
      subresourceRange = {
        aspectMask = {.COLOR},
        layerCount = 1,
        levelCount = 1,
      },
      oldLayout = .COLOR_ATTACHMENT_OPTIMAL,
      newLayout = .PRESENT_SRC_KHR,
      srcStageMask = {.COLOR_ATTACHMENT_OUTPUT},
      srcAccessMask = {.MEMORY_WRITE},
      srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
      dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
    }
    vk.CmdPipelineBarrier2(frame.cmd, &{
      sType = .DEPENDENCY_INFO,
      imageMemoryBarrierCount = 1,
      pImageMemoryBarriers = &transition_to_present_barrier,
    })

    // - END COMMAND BUFFER ---

    result = vk.EndCommandBuffer(frame.cmd)
    vk_check(result)

    render_done_sem := g.swapchain.image_ready_sems[image_idx]

    submit_info := vk.SubmitInfo{
      sType = .SUBMIT_INFO,
      commandBufferCount = 1,
      pCommandBuffers = &frame.cmd,
      waitSemaphoreCount = 1,
      pWaitSemaphores = &frame.present_done_sem,
      pWaitDstStageMask = &vk.PipelineStageFlags{.COLOR_ATTACHMENT_OUTPUT},
      signalSemaphoreCount = 1,
      pSignalSemaphores = &render_done_sem,
    }
    result = vk.QueueSubmit(g.device.queue, 1, &submit_info, frame.fence)
    vk_check(result)

    // - PRESENT ---

    result = vk.QueuePresentKHR(g.device.queue, &{
      sType = .PRESENT_INFO_KHR,
      waitSemaphoreCount = 1,
      pWaitSemaphores = &render_done_sem,
      swapchainCount = 1,
      pSwapchains = &g.swapchain.handle,
      pImageIndices = &image_idx,
    })
    vk_check(result)

    g.frame_idx = (g.frame_idx + 1) % NUM_FRAMES_IN_FLIGHT
  }

  vk.DeviceWaitIdle(g.device.handle)

  vk_destroy_buffer(&g.index_buf)
  vk_destroy_buffer(&g.vertex_buf)

  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    vk.DestroyDescriptorSetLayout(g.device.handle, g.uniform_layouts[i], nil)

    vk.DestroyFence(g.device.handle, g.frames[i].fence, nil)
    vk.DestroySemaphore(g.device.handle, g.frames[i].present_done_sem, nil)
    vk_destroy_buffer(&g.frames[i].uniform_buf)
  }

  vk.DestroyDescriptorPool(g.device.handle, g.uniform_desc_pool, nil)
  vk.DestroyCommandPool(g.device.handle, g.copy_cmd_pool, nil)
  vk.DestroyCommandPool(g.device.handle, g.frame_cmd_pool, nil)

  vma_done()

  vk_done()
}

vk_create_buffer :: proc(
  size:        vk.DeviceSize, 
  buf_flags:   vk.BufferUsageFlags, 
  alloc_flags: vma.AllocationCreateFlags,
  mem_flags:   vk.MemoryPropertyFlags,
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
    flags = alloc_flags,
    preferredFlags = mem_flags,
  }
  
  result := vma.CreateBuffer(g.gpu_allocator, 
                             &buffer_ci, 
                             &allocation_ci, 
                             &buffer.handle,
                             &buffer.allocation,
                             &buffer.info)
  vk_check(result)

  return buffer
}

vk_copy_buffers :: proc(src: ^Buffer, dsts: []^Buffer, sizes: []vk.DeviceSize)
{
  result := vk.BeginCommandBuffer(g.copy_cmd, &{
    sType = .COMMAND_BUFFER_BEGIN_INFO,
    flags = {.ONE_TIME_SUBMIT},
  })
  vk_check(result)

  src_offset: vk.DeviceSize
  for i in 0..<len(dsts)
  {
    vk.CmdCopyBuffer(g.copy_cmd, src.handle, dsts[i].handle, 1, &vk.BufferCopy{src_offset, 0, sizes[i]})
    src_offset += sizes[i]
  }

  vk.EndCommandBuffer(g.copy_cmd)

  result = vk.QueueSubmit(g.device.queue, 1, &vk.SubmitInfo{
    sType = .SUBMIT_INFO,
    commandBufferCount = 1,
    pCommandBuffers = &g.copy_cmd,
  }, 0)
  vk_check(result)

  vk.QueueWaitIdle(g.device.queue)
  vk.ResetCommandPool(g.device.handle, g.copy_cmd_pool, {})
}

vk_destroy_buffer :: proc(buffer: ^Buffer)
{
  vma.DestroyBuffer(g.gpu_allocator, buffer.handle, buffer.allocation)
}

vk_check :: proc(result: vk.Result, location := #caller_location)
{
  if result == .TIMEOUT || result == .SUBOPTIMAL_KHR
  {
    fmt.println("\033[33mWarning [render_vk]:\033[0m", result, "at", location)
  }
  else if result != .SUCCESS
  {
    fmt.println("\033[31mFatal [render_vk]:", result, "at", location)
    os.exit(1)
  }
}
