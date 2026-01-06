package vk_test

import "base:runtime"
import "core:fmt"
import "core:image/qoi"
import os "core:os/os2"
import "ext:sdl"
import vk "ext:vulkan"
import "ext:vma"
import "../game/basic/mem"
import "../game/basic/vmath"

WINDOW_WIDTH  :: 960
WINDOW_HEIGHT :: 540

USE_MAILBOX :: false

NUM_FRAMES_IN_FLIGHT :: 2

Device :: struct
{
  handle:           vk.Device,
  physical:         vk.PhysicalDevice,
  queue:            vk.Queue,
  queue_family_idx: u32,
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

Buffer :: struct
{
  handle:     vk.Buffer,
  address:    vk.DeviceAddress,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
}

Texture :: struct
{
  image:      vk.Image,
  view:       vk.ImageView,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
}

Pipeline :: struct
{
  handle:        vk.Pipeline,
  layout:        vk.PipelineLayout,
  
}

Vertex :: struct
{
  position: [3]f32,
  _:        [1]f32,
  color:    [4]f32,
  uv:       [2]f32,
  _:        [2]f32,
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
  frames:            [NUM_FRAMES_IN_FLIGHT]struct
  {
    fence:           vk.Fence,
    present_sem:     vk.Semaphore,
    cmd:             vk.CommandBuffer, 
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
  pipelines:         [enum{Main, Post}]Pipeline,
  textures:          [enum{Smile, Screen}]Texture,
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
  vertices:          [4]Vertex,
  vertex_buf:        Buffer,
  indices:           [6]u8,
  index_buf:         Buffer,
}

vma_init :: proc()
{
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
    pNext = &layer_settings_ci,
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

  // - Surface ---

  sdl_ok := sdl.Vulkan_CreateSurface(g.window, g.instance, nil, &g.surface)
  if !sdl_ok
  {
    fmt.println("Failed to create Vulkan surface:", sdl.GetError())
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
        fmt.printf("Info [render_vk]: Selected device '%v'.\n", string(physical_device_props[i].deviceName[:]))
        
        device.physical = dev
        device.queue_family_idx = u32(j)
        break device_loop
      }
    }
  }

  assert(device.physical != nil, "Fatal [render_vk]: No suitable GPU found!")

  // - Logical device ---

  extensions := [?]cstring{
    vk.KHR_SWAPCHAIN_EXTENSION_NAME,
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
    indexTypeUint8 = true,
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
  assert(vk.BeginCommandBuffer != nil, "Fatal [render_vk]: Failed to load Vulkan device API.")

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

  surface_format := formats[0]
  for format in formats[:formats_count]
  {
    if (format == vk.SurfaceFormatKHR{.B8G8R8A8_SRGB, .SRGB_NONLINEAR})
    {
      surface_format = format
      swapchain.format = format.format
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

  swapchain.extent = {u32(width), u32(height)}

  result = vk.CreateSwapchainKHR(g.device.handle, &{
    sType = .SWAPCHAIN_CREATE_INFO_KHR,
    surface = g.surface,
    minImageCount = image_count,
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
  }, nil, &swapchain.handle)
  vk_check(result)

  // - Swapchain images ---

  vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &image_count, nil)
  swapchain.images.allocator = context.allocator
  resize(&swapchain.images, image_count)
  resize(&swapchain.image_views, image_count)
  vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &image_count, &swapchain.images[0])

  for image, i in swapchain.images
  {
    vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = image,
      viewType = .D2,
      format = swapchain.format,
      components = {r=.IDENTITY, g=.IDENTITY, b=.IDENTITY, a=.IDENTITY},
      subresourceRange = {
        aspectMask = {.COLOR},
        levelCount = 1,
        layerCount = 1,
      },
    }, nil, &swapchain.image_views[i])
  }

  swapchain.image_ready_sems = make([]vk.Semaphore, len(swapchain.images), context.allocator)
  sem_ci := vk.SemaphoreCreateInfo{sType=.SEMAPHORE_CREATE_INFO}
  for i in 0..<len(swapchain.image_ready_sems)
  {
    result = vk.CreateSemaphore(g.device.handle, &sem_ci, nil, &swapchain.image_ready_sems[i])
    vk_check(result)
  }

  fmt.printf("Info [render_vk]: Created %v swapchain images.\n", image_count)

  return swapchain
}

vk_destroy_swapchain :: proc(swapchain: ^Swapchain)
{
  for view in swapchain.image_views do vk.DestroyImageView(g.device.handle, view, nil)

  for sem in swapchain.image_ready_sems do vk.DestroySemaphore(g.device.handle, sem, nil)

  vk.DestroySwapchainKHR(g.device.handle, swapchain.handle, nil)
}

main :: proc()
{
  if !sdl.Init({.VIDEO})
  {
    panic("FATAL [platform]: Failed to init SDL!")
  }

  g.window = sdl.CreateWindow("VULKAN", WINDOW_WIDTH, WINDOW_HEIGHT, {.VULKAN})

  vk_init_instance()
  g.device = vk_create_device()
  g.swapchain = vk_create_swapchain()
  
  vma_init()

  result: vk.Result

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

    layout_bindings := [?]vk.DescriptorSetLayoutBinding{
      {
        binding = 0,
        descriptorCount = 1,
        descriptorType = .UNIFORM_BUFFER,
        stageFlags = {.VERTEX},
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

    frame.uniform_buf = vk_create_buffer(size_of(g.uniforms), 
                                         buf_flags={.UNIFORM_BUFFER, .TRANSFER_DST},
                                         mem_flags={.DEVICE_LOCAL})
  }

  vk_check(vk.AllocateDescriptorSets(g.device.handle, &{
    sType = .DESCRIPTOR_SET_ALLOCATE_INFO,
    descriptorPool = g.desc_pool,
    descriptorSetCount = len(g.desc_sets),
    pSetLayouts = raw_data(g.desc_layouts[:]),
  }, raw_data(g.desc_sets[:])))

  // - Vertex and index buffer ---
  {
    vertices_size: vk.DeviceSize = len(g.vertices) * size_of(Vertex)
    indices_size: vk.DeviceSize = len(g.indices) * size_of(u8)

    staging_buf := vk_create_buffer(vertices_size + indices_size, 
                                    buf_flags={.TRANSFER_SRC}, 
                                    mem_flags={.HOST_VISIBLE})
    defer vk_destroy_buffer(&staging_buf)

    g.vertex_buf = vk_create_buffer(vertices_size, 
                                    buf_flags={.VERTEX_BUFFER, .TRANSFER_DST, .SHADER_DEVICE_ADDRESS}, 
                                    mem_flags={.DEVICE_LOCAL})

    g.vertex_buf.address = vk.GetBufferDeviceAddress(g.device.handle, &{
      sType = .BUFFER_DEVICE_ADDRESS_INFO,
      buffer = g.vertex_buf.handle,
    })

    g.vertices = {
      {position={0, 0, 1}, color={1.0, 0.0, 1.0, 1.0}, uv={0, 0}},
      {position={1, 0, 1}, color={0.0, 1.0, 1.0, 1.0}, uv={1, 0}},
      {position={1, 1, 1}, color={0.0, 0.0, 1.0, 1.0}, uv={1, 1}},
      {position={0, 1, 1}, color={1.0, 1.0, 1.0, 1.0}, uv={0, 1}},
    }

    mem.copy(staging_buf.info.pMappedData, raw_data(g.vertices[:]), vertices_size)

    g.index_buf = vk_create_buffer(indices_size, 
                                   buf_flags={.INDEX_BUFFER, .TRANSFER_DST}, 
                                   mem_flags={.DEVICE_LOCAL})

    g.indices = {
      0, 1, 3,
      1, 2, 3,
    }

    indices_offset_addr := rawptr(uintptr(staging_buf.info.pMappedData) + uintptr(vertices_size))
    mem.copy(indices_offset_addr, raw_data(g.indices[:]), indices_size)

    vk_copy_to_buffers(&staging_buf, {&g.vertex_buf, &g.index_buf}, {vertices_size, indices_size})
  }

  // - Texture ---
  {
    img, err := qoi.load_from_file("res/textures/smile.qoi")
    if err != nil
    {
      fmt.panicf("[FATAL][render_vk]: Failed to load 'smile.qoi'!", err)
    }

    g.textures[.Smile] = vk_create_texture(img.pixels.buf[:], 
                                           u32(img.width), 
                                           u32(img.height), 
                                           .R8G8B8A8_SRGB,
                                           .SHADER_READ_ONLY_OPTIMAL)

    img, err = qoi.load_from_file("res/textures/screen.qoi")
    if err != nil
    {
      fmt.panicf("[FATAL][render_vk]: Failed to load 'screen.qoi'!", err)
    }

    g.textures[.Screen] = vk_create_texture(img.pixels.buf[:], 
                                            u32(img.width), 
                                            u32(img.height), 
                                            .R8G8B8A8_UNORM,
                                            .COLOR_ATTACHMENT_OPTIMAL,
                                            {.COLOR_ATTACHMENT})

    vk_check(vk.CreateSampler(g.device.handle, &{
      sType = .SAMPLER_CREATE_INFO,
      magFilter = .NEAREST,
      minFilter = .NEAREST,
      addressModeU = .REPEAT,
      addressModeV = .REPEAT,
      addressModeW = .REPEAT,
    }, nil, &g.sampler))
  }

  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
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
  }

  // - Main pipeline ---
  {
    vs_data: []u8 = #load("shaders/out/shader.vert.spv")
    fs_data: []u8 = #load("shaders/out/shader.frag.spv")

    vs_module: vk.ShaderModule
    result = vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(vs_data),
      pCode = cast(^u32) raw_data(vs_data),
    }, nil, &vs_module)
    defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)
    vk_check(result)

    fs_module: vk.ShaderModule
    result = vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(fs_data),
      pCode = cast(^u32) raw_data(fs_data),
    }, nil, &fs_module)
    defer vk.DestroyShaderModule(g.device.handle, fs_module, nil)
    vk_check(result)

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

    format := vk.Format.R8G8B8A8_UNORM
    rendering_ci := vk.PipelineRenderingCreateInfo{
      sType = .PIPELINE_RENDERING_CREATE_INFO,
      colorAttachmentCount = 1,
      pColorAttachmentFormats = &format,
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
        stageFlags = {.VERTEX},
        size = size_of(g.main_constants),
      },
    }

    result = vk.CreatePipelineLayout(g.device.handle, &{
      sType = .PIPELINE_LAYOUT_CREATE_INFO,
      pushConstantRangeCount = 1,
      pPushConstantRanges = raw_data(push_constants_ranges),
      setLayoutCount = len(g.desc_layouts),
      pSetLayouts = raw_data(g.desc_layouts[:]),
    }, nil, &g.pipelines[.Main].layout)
    vk_check(result)

    result = vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
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
    }, nil, &g.pipelines[.Main].handle)
    vk_check(result)
  }

  // - Postprocessor pipeline ---
  {
    vs_data: []u8 = #load("shaders/out/postprocess.vert.spv")
    fs_data: []u8 = #load("shaders/out/postprocess.frag.spv")

    vs_module: vk.ShaderModule
    result = vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(vs_data),
      pCode = cast(^u32) raw_data(vs_data),
    }, nil, &vs_module)
    defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)
    vk_check(result)

    fs_module: vk.ShaderModule
    result = vk.CreateShaderModule(g.device.handle, &{
      sType = .SHADER_MODULE_CREATE_INFO,
      codeSize = len(fs_data),
      pCode = cast(^u32) raw_data(fs_data),
    }, nil, &fs_module)
    defer vk.DestroyShaderModule(g.device.handle, fs_module, nil)
    vk_check(result)

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

    push_constants_ranges := []vk.PushConstantRange{
      {
        stageFlags = {.FRAGMENT},
        size = size_of(g.post_constants),
      },
    }

    result = vk.CreatePipelineLayout(g.device.handle, &{
      sType = .PIPELINE_LAYOUT_CREATE_INFO,
      pushConstantRangeCount = 1,
      pPushConstantRanges = raw_data(push_constants_ranges),
      setLayoutCount = len(g.desc_layouts),
      pSetLayouts = raw_data(g.desc_layouts[:]),
    }, nil, &g.pipelines[.Post].layout)
    vk_check(result)

    result = vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
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
    }, nil, &g.pipelines[.Post].handle)
    vk_check(result)
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

  t, dt: f64
  space_down, r_down: bool
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

    // - BEGIN UPDATE ---

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

    g.uniforms.light.a = 1

    // - END UPDATE ---

    frame := &g.frames[g.frame_idx]

    vk_check(vk.WaitForFences(g.device.handle, 1, &frame.fence, true, max(u64)))
    vk_check(vk.ResetFences(g.device.handle, 1, &frame.fence))

    image_idx: u32
    vk_check(vk.AcquireNextImageKHR(g.device.handle, g.swapchain.handle, max(u64), frame.present_sem, 0, &image_idx))
    
    vk_check(vk.BeginCommandBuffer(frame.cmd, &{
      sType = .COMMAND_BUFFER_BEGIN_INFO,
      flags = {.ONE_TIME_SUBMIT},
    }))

    // - BEGIN COMMAND BUFFER ---

    g.uniforms.light.rgb = 1
    vk.CmdUpdateBuffer(frame.cmd, g.frames[g.frame_idx].uniform_buf.handle, 0, size_of(g.uniforms), &g.uniforms)
    vk_cmd_buffer_barrier(frame.cmd, g.vertex_buf.handle,
                          src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                          dst_stages={.VERTEX_SHADER}, dst_access={.SHADER_READ})

    vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].image,
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
        imageView = g.textures[.Screen].view,
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp = .CLEAR,
        storeOp = .STORE,
        clearValue = {color={float32={0.0, 0.0, 0.0, 0.0}}},
      },
    })

    // - BEGIN DRAW PASS 1 ---

    vk.CmdBindPipeline(frame.cmd, .GRAPHICS, g.pipelines[.Main].handle)
    vk.CmdBindIndexBuffer(frame.cmd, g.index_buf.handle, 0, .UINT8)
    vk.CmdBindDescriptorSets(frame.cmd, .GRAPHICS, g.pipelines[.Main].layout, 0, 1, &g.desc_sets[g.frame_idx], 0, nil)

    vk.CmdSetViewport(frame.cmd, 0, 1, &g.viewport)
    vk.CmdSetScissor(frame.cmd, 0, 1, &g.scissor)

    g.main_constants.vertex_addr = g.vertex_buf.address
    g.main_constants.transform = cast(vmath.m4f32) transform
    vk.CmdPushConstants(frame.cmd, g.pipelines[.Main].layout, {.VERTEX}, 0, 
                        size_of(g.main_constants), &g.main_constants)

    vk.CmdDrawIndexed(frame.cmd, len(g.indices), 1, 0, 0, 0)

    // - END DRAW PASS 1 ---

    vk.CmdEndRendering(frame.cmd)

    vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].image,
                         src_stages={.COLOR_ATTACHMENT_OUTPUT}, src_access={.MEMORY_WRITE},
                         dst_stages={.ALL_COMMANDS}, dst_access={})

    for &vert in g.vertices
    {
      vert.position.xy -= 0.5
    }

    vk.CmdUpdateBuffer(frame.cmd, g.vertex_buf.handle, 0, len(g.vertices)*size_of(Vertex), &g.vertices)
    vk_cmd_buffer_barrier(frame.cmd, g.vertex_buf.handle,
                          src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                          dst_stages={.VERTEX_ATTRIBUTE_INPUT}, dst_access={.VERTEX_ATTRIBUTE_READ})

    g.uniforms.light.rgb = 0.1
    vk.CmdUpdateBuffer(frame.cmd, g.frames[g.frame_idx].uniform_buf.handle, 0, size_of(g.uniforms), &g.uniforms)
    vk_cmd_buffer_barrier(frame.cmd, g.frames[g.frame_idx].uniform_buf.handle,
                          src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                          dst_stages={.VERTEX_SHADER}, dst_access={.SHADER_READ})

    vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].image,
                         src_stages={.ALL_COMMANDS}, src_access={.MEMORY_READ},
                         dst_stages={.COLOR_ATTACHMENT_OUTPUT}, dst_access={.MEMORY_WRITE})

    vk.CmdBeginRendering(frame.cmd, &{
      sType = .RENDERING_INFO,
      renderArea = {{0, 0}, g.swapchain.extent},
      layerCount = 1,
      colorAttachmentCount = 1,
      pColorAttachments = &vk.RenderingAttachmentInfo{
        sType = .RENDERING_ATTACHMENT_INFO,
        imageView = g.textures[.Screen].view,
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp = .LOAD,
        storeOp = .STORE,
      },
    })

    // - BEGIN DRAW PASS 2 ---

    g.main_constants.transform = cast(vmath.m4f32) (transform * vmath.scale_3x3f(0.5))
    vk.CmdPushConstants(frame.cmd, g.pipelines[.Main].layout, {.VERTEX}, 0, size_of(g.main_constants), &g.main_constants)

    vk.CmdDrawIndexed(frame.cmd, len(g.indices), 1, 0, 0, 0)

    // - END DRAW PASS 2 ---

    vk.CmdEndRendering(frame.cmd)

    vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].image,
                         src_stages={.COLOR_ATTACHMENT_OUTPUT}, src_access={.MEMORY_WRITE},
                         dst_stages={.ALL_COMMANDS}, dst_access={})

    for &vert in g.vertices
    {
      vert.position.xy += 0.5
    }

    vk.CmdUpdateBuffer(frame.cmd, g.vertex_buf.handle, 0, len(g.vertices)*size_of(Vertex), &g.vertices)
    vk_cmd_buffer_barrier(frame.cmd, g.vertex_buf.handle,
                          src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                          dst_stages={.VERTEX_ATTRIBUTE_INPUT}, dst_access={.VERTEX_ATTRIBUTE_READ})

    vk_cmd_image_barrier(frame.cmd, g.textures[.Screen].image,
                         old_layout=.COLOR_ATTACHMENT_OPTIMAL, new_layout=.SHADER_READ_ONLY_OPTIMAL,
                         src_stages={.COLOR_ATTACHMENT_OUTPUT}, src_access={.MEMORY_WRITE},
                         dst_stages={.FRAGMENT_SHADER}, dst_access={.SHADER_READ})

    vk_cmd_image_barrier(frame.cmd, g.swapchain.images[image_idx],
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

    // - BEGIN DRAW PASS 3 ---
    
    vk.CmdBindDescriptorSets(frame.cmd, .GRAPHICS, g.pipelines[.Post].layout, 0, 1, &g.desc_sets[g.frame_idx], 0, nil)
    vk.CmdBindPipeline(frame.cmd, .GRAPHICS, g.pipelines[.Post].handle)

    g.post_constants.enabled = true
    vk.CmdPushConstants(frame.cmd, g.pipelines[.Post].layout, {.FRAGMENT}, 0, 
                        size_of(g.post_constants), &g.post_constants)

    vk.CmdDraw(frame.cmd, 6, 1, 0, 0)

    // - END DRAW PASS 3 ---

    vk.CmdEndRendering(frame.cmd)

    vk_cmd_image_barrier(frame.cmd, g.swapchain.images[image_idx],
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
  
  // - CLEANUP ---

  vk.DeviceWaitIdle(g.device.handle)

  vk.DestroySampler(g.device.handle, g.sampler, nil)

  for &tex in g.textures do vk_destroy_texture(&tex)

  vk_destroy_buffer(&g.index_buf)
  vk_destroy_buffer(&g.vertex_buf)

  vk.DestroyFence(g.device.handle, g.burst_fence, nil)

  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    vk.DestroyDescriptorSetLayout(g.device.handle, g.desc_layouts[i], nil)

    vk.DestroyFence(g.device.handle, g.frames[i].fence, nil)
    vk.DestroySemaphore(g.device.handle, g.frames[i].present_sem, nil)
    vk_destroy_buffer(&g.frames[i].uniform_buf)
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
        aspectMask = {.COLOR},
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

vk_create_texture :: proc(
  pixels:      []byte, 
  width:       u32, 
  height:      u32, 
  format:      vk.Format,
  layout:      vk.ImageLayout = .SHADER_READ_ONLY_OPTIMAL,
  usage_flags: vk.ImageUsageFlags = {}
) -> Texture
{
  texture: Texture
  result: vk.Result

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
    usage = usage_flags + {.TRANSFER_DST, .SAMPLED},
    tiling = .OPTIMAL,
    initialLayout = .UNDEFINED,
  }
  allocation_ci := vma.AllocationCreateInfo{
    usage = .AUTO,
    preferredFlags = {.DEVICE_LOCAL},
  }
  result = vma.CreateImage(g.gpu_allocator, 
                           &image_ci, 
                           &allocation_ci, 
                           &texture.image, 
                           &texture.allocation, 
                           &texture.info)
  vk_check(result)

  // - Write pixels ---
  {
    staging_buf := vk_create_buffer(vk.DeviceSize(len(pixels)), 
                                    buf_flags={.TRANSFER_SRC}, 
                                    mem_flags={.HOST_VISIBLE})
    defer vk_destroy_buffer(&staging_buf)

    mem.copy(staging_buf.info.pMappedData, raw_data(pixels), len(pixels))

    cmd := vk_begin_cmd_burst()

    vk_cmd_image_barrier(cmd, texture.image, 
                         old_layout=.UNDEFINED, new_layout=.TRANSFER_DST_OPTIMAL,
                         src_stages={.TOP_OF_PIPE}, src_access={},
                         dst_stages={.TRANSFER}, dst_access={.TRANSFER_WRITE})

    vk.CmdCopyBufferToImage(cmd, staging_buf.handle, texture.image,
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

    vk_cmd_image_barrier(cmd, texture.image, 
                         old_layout=.TRANSFER_DST_OPTIMAL, new_layout=layout,
                         src_stages={.TRANSFER}, src_access={.TRANSFER_WRITE},
                         dst_stages={.FRAGMENT_SHADER}, dst_access={.SHADER_READ})

    vk_end_cmd_burst(cmd)
  }

  result = vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = texture.image,
      viewType = .D2,
      format = format,
      components = {r = .IDENTITY, g = .IDENTITY, b = .IDENTITY, a = .IDENTITY},
      subresourceRange = {
        aspectMask = {.COLOR},
        levelCount = 1,
        layerCount = 1,
      },
  }, nil, &texture.view)
  vk_check(result)

  return texture
}

vk_destroy_texture :: proc(texture: ^Texture)
{
  vk.DestroyImageView(g.device.handle, texture.view, nil)
  vma.DestroyImage(g.gpu_allocator, texture.image, texture.allocation)
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
