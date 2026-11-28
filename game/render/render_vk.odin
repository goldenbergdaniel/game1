#+build linux, windows
#+private
package render

import "base:runtime"
import "core:fmt"
import "core:log"
import "core:os"
import "ext:sdl"
import vk "ext:vulkan"
import "ext:vma"
import "../basic/mem"
import "../basic/vmath"
import "../platform"

VK_Device :: struct
{
  handle:           vk.Device,
  physical:         vk.PhysicalDevice,
  limits:           vk.PhysicalDeviceLimits,
  queue:            vk.Queue,
  queue_family_idx: u32,
  surface_format:   vk.SurfaceFormatKHR,
  color_format:     vk.Format,
  depth_format:     vk.Format,
}

VK_Swapchain :: struct
{
  handle:          vk.SwapchainKHR,
  image_count:     u32,
  images:          [4]Image,
  render_finished: [4]vk.Semaphore,
  extent:          vk.Extent2D,
}

VK_Pipeline :: struct
{
  handle: vk.Pipeline, 
  layout: vk.PipelineLayout,
  kind:   vk.PipelineBindPoint,
}

VK_Buffer :: struct
{
  handle:     vk.Buffer,
  address:    vk.DeviceAddress,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
  data:       rawptr,
}

VK_Image :: struct
{
  handle:     vk.Image,
  view:       vk.ImageView,
  format:     vk.Format,
  allocation: vma.Allocation,
  info:       vma.AllocationInfo,
  state:      Image_State,
}

VK_Image_State_Info :: struct
{
  stages: vk.PipelineStageFlags2,
  access: vk.AccessFlags2,
  layout: vk.ImageLayout,
}

VK_Command_Buffer :: vk.CommandBuffer

FIRST_PASS_TEXTURE_IDX :: 0

@(private="file")
g: struct
{
  perm_arena:            mem.Arena,
  instance:              vk.Instance,
  debug_messenger:       vk.DebugUtilsMessengerEXT,
  window:                ^platform.Window,
  surface:               vk.SurfaceKHR,
  device:                VK_Device,
  swapchain:             VK_Swapchain,
  frame_arena:           ^mem.Arena,
  frame_idx:             int,
  frame_cmd_pool:        vk.CommandPool,
  frames:                [NUM_FRAMES_IN_FLIGHT]struct
  {
    fence:               vk.Fence,
    image_available_sem: vk.Semaphore,
    cmd:                 vk.CommandBuffer, 
    image_idx:           int,
    depth_image:         Image,
    bindings:            struct
    {
      pipeline:          ^VK_Pipeline,
      index_buffer:      ^VK_Buffer,
      descriptor_set:    ^vk.DescriptorSet,
    },
  },
  desc_layout:           vk.DescriptorSetLayout,
  desc_pool:             vk.DescriptorPool,
  desc_set:              vk.DescriptorSet,
  gpu_allocator:         vma.Allocator,
  burst_cmd_pool:        vk.CommandPool,
  burst_cmd:             vk.CommandBuffer,
  burst_fence:           vk.Fence,
  pipelines:             [enum{Main, Post}]VK_Pipeline,
  textures:              []VK_Image,
  sampler:               vk.Sampler,
  pass:                  Pass,
}

vk_check :: proc(result: vk.Result, location := #caller_location)
{
  if result == .TIMEOUT || result == .SUBOPTIMAL_KHR
  {
    fmt.println("\033[33m[WARN ] --- [render_vk]:", result, "at", location, "\033[0m")
  }
  else if result == .ERROR_OUT_OF_DATE_KHR
  {
    g.swapchain = vk_create_swapchain(&g.swapchain)
  }
  else if result != .SUCCESS
  {
    fmt.println("\033[31m[FATAL] --- [render_vk]:", result, "at", location, "\033[0m")
    os.exit(1)
  }
}

vk_check_swapchain :: proc(result: vk.Result, location := #caller_location)
{
  if result == .ERROR_OUT_OF_DATE_KHR
  {
    vk_recreate_swapchain()
  }
}

vk_init_device :: proc(window: ^platform.Window)
{
  g.window = window
  
  vk_init_instance()
  g.device = vk_create_device()
  g.swapchain = vk_create_swapchain(nil)

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

  // - Create burst command buffer ---
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

  vk_check(vk.CreateFence(g.device.handle, &{sType=.FENCE_CREATE_INFO}, nil, &g.burst_fence))

  vk_check(vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.RESET_COMMAND_BUFFER},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.frame_cmd_pool))
}

vk_init_renderer :: proc(textures: []Image)
{
  // - Create sampler ---
  vk_check(vk.CreateSampler(g.device.handle, &{
    sType = .SAMPLER_CREATE_INFO,
    magFilter = .NEAREST,
    minFilter = .NEAREST,
    addressModeU = .REPEAT,
    addressModeV = .REPEAT,
    addressModeW = .REPEAT,
    anisotropyEnable = true,
    maxAnisotropy = g.device.limits.maxSamplerAnisotropy,
  }, nil, &g.sampler))

  // - Create descriptors ---
  vk.CreateDescriptorSetLayout(g.device.handle, &{
    sType = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
    flags = {},
    bindingCount = 1,
    pBindings = &vk.DescriptorSetLayoutBinding{
      binding = 0,
      descriptorCount = cast(u32) len(textures),
      descriptorType = .COMBINED_IMAGE_SAMPLER,
      stageFlags = {.FRAGMENT},
    },
    pNext = &vk.DescriptorSetLayoutBindingFlagsCreateInfo{
      sType = .DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO,
      bindingCount = 1,
      pBindingFlags = &vk.DescriptorBindingFlags{.VARIABLE_DESCRIPTOR_COUNT},
    },
  }, nil, &g.desc_layout)

  vk_check(vk.CreateDescriptorPool(g.device.handle, &{
    sType = .DESCRIPTOR_POOL_CREATE_INFO,
    maxSets = cast(u32) len(textures),
    poolSizeCount = 1,
    pPoolSizes = &vk.DescriptorPoolSize{
      descriptorCount = cast(u32) len(textures),
      type = .COMBINED_IMAGE_SAMPLER,
    },
  }, nil, &g.desc_pool))

  // - Allocate and write descriptor sets ---
  variable_descriptor_count := cast(u32) len(textures)
  vk_check(vk.AllocateDescriptorSets(g.device.handle, &{
    sType = .DESCRIPTOR_SET_ALLOCATE_INFO,
    descriptorPool = g.desc_pool,
    descriptorSetCount = 1,
    pSetLayouts = &g.desc_layout,
    pNext = &vk.DescriptorSetVariableDescriptorCountAllocateInfo{
      sType = .DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO_EXT,
      descriptorSetCount = 1,
      pDescriptorCounts = &variable_descriptor_count,
    },
  }, &g.desc_set))

  scratch := mem.temp_begin(&g.perm_arena)

  descriptor_image_info: [dynamic]vk.DescriptorImageInfo
  descriptor_image_info.allocator = mem.allocator(scratch.arena)
  for texture in textures
  {
    append(&descriptor_image_info, vk.DescriptorImageInfo{
      imageView = texture.vk.view,
      sampler = g.sampler,
      imageLayout = .SHADER_READ_ONLY_OPTIMAL,
    })
  }

  vk.UpdateDescriptorSets(g.device.handle, 1, &vk.WriteDescriptorSet{
    sType = .WRITE_DESCRIPTOR_SET,
    descriptorType = .COMBINED_IMAGE_SAMPLER,
    dstSet = g.desc_set,
    dstBinding = 0,
    descriptorCount = u32(len(textures)),
    pImageInfo = raw_data(descriptor_image_info),
  }, 0, nil)

  mem.temp_end(scratch)

  // - Create frame command buffer ---
  vk_check(vk.CreateCommandPool(g.device.handle, &{
    sType = .COMMAND_POOL_CREATE_INFO,
    flags = {.RESET_COMMAND_BUFFER},
    queueFamilyIndex = g.device.queue_family_idx,
  }, nil, &g.frame_cmd_pool))

  // - Frame data ---
  for i in 0..<NUM_FRAMES_IN_FLIGHT
  {
    frame := &g.frames[i]

    vk_check(vk.CreateSemaphore(g.device.handle, &{sType=.SEMAPHORE_CREATE_INFO}, nil, &frame.image_available_sem))

    vk_check(vk.CreateFence(g.device.handle, &{sType=.FENCE_CREATE_INFO, flags={.SIGNALED}}, nil, &frame.fence))

    vk_check(vk.AllocateCommandBuffers(g.device.handle, &{
      sType = .COMMAND_BUFFER_ALLOCATE_INFO,
      commandPool = g.frame_cmd_pool,
      level = .PRIMARY,
      commandBufferCount = 1,
    }, &frame.cmd))

    frame.depth_image.vk = vk_create_image(g.swapchain.extent.width, g.swapchain.extent.height,
                                           g.device.depth_format, .UNDEFINED, 
                                           {.DEPTH}, {.DEPTH_STENCIL_ATTACHMENT})
  }
}

vk_begin_frame :: proc(arena: ^mem.Arena) -> vk.CommandBuffer
{
  g.frame_arena = arena
  frame := &g.frames[g.frame_idx]

  vk_check(vk.WaitForFences(g.device.handle, 1, &frame.fence, true, max(u64)))
  vk_check(vk.ResetFences(g.device.handle, 1, &frame.fence))

  idx: u32
  vk_check_swapchain(vk.AcquireNextImageKHR(g.device.handle, g.swapchain.handle, 
                                            max(u64), frame.image_available_sem, 0, 
                                            &idx))
  frame.image_idx = cast(int) idx

  g.swapchain.images[frame.image_idx].vk.state = .Acquired

  vk_check(vk.ResetCommandBuffer(frame.cmd, {}))
  vk_check(vk.BeginCommandBuffer(frame.cmd, &{
    sType = .COMMAND_BUFFER_BEGIN_INFO,
    flags = {.ONE_TIME_SUBMIT},
  }))

  return frame.cmd
}

vk_end_frame :: proc()
{
  frame := g.frames[g.frame_idx]

  vk_transition_image(frame.cmd, &g.swapchain.images[frame.image_idx].vk, .Present)

  vk_check(vk.EndCommandBuffer(frame.cmd))

  vk_check(vk.QueueSubmit(g.device.queue, 1, &vk.SubmitInfo{
    sType = .SUBMIT_INFO,
    commandBufferCount = 1,
    pCommandBuffers = &frame.cmd,
    waitSemaphoreCount = 1,
    pWaitSemaphores = &frame.image_available_sem,
    pWaitDstStageMask = &vk.PipelineStageFlags{.COLOR_ATTACHMENT_OUTPUT},
    signalSemaphoreCount = 1,
    pSignalSemaphores = &g.swapchain.render_finished[frame.image_idx],
  }, frame.fence))

  present_image_idx := cast(u32) frame.image_idx
  vk_check(vk.QueuePresentKHR(g.device.queue, &{
    sType = .PRESENT_INFO_KHR,
    swapchainCount = 1,
    pSwapchains = &g.swapchain.handle,
    pImageIndices = &present_image_idx,
    waitSemaphoreCount = 1,
    pWaitSemaphores = &g.swapchain.render_finished[frame.image_idx],
  }))

  g.frame_idx = (g.frame_idx + 1) % NUM_FRAMES_IN_FLIGHT
  mem.arena_clear(g.frame_arena)
}

vk_begin_pass :: proc(pass: Pass)
{
  g.pass = pass
  frame := &g.frames[g.frame_idx]

  color_attachment_infos: [dynamic]vk.RenderingAttachmentInfo
  color_attachment_infos.allocator = mem.allocator(g.frame_arena)
  for color_target in pass.color_attachments
  {
    append(&color_attachment_infos, vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = color_target.image.vk.view,
      imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
      loadOp = vk_image_load_op(color_target.load_op),
      storeOp = vk_image_store_op(color_target.store_op),
      clearValue = {color={float32=pass.clear_color}},
    })
  }

  depth_attachment_info: vk.RenderingAttachmentInfo
  has_depth_attachment := pass.depth_attachment.image != nil
  if has_depth_attachment
  {
    depth_attachment_info = vk.RenderingAttachmentInfo{
      sType = .RENDERING_ATTACHMENT_INFO,
      imageView = pass.depth_attachment.image.vk.view,
      imageLayout = .DEPTH_ATTACHMENT_OPTIMAL,
      loadOp = vk_image_load_op(pass.depth_attachment.load_op),
      storeOp = vk_image_store_op(pass.depth_attachment.store_op),
      clearValue = {depthStencil={depth=1}},
    }
  }

  vk.CmdBeginRendering(frame.cmd, &{
    sType = .RENDERING_INFO,
    renderArea = {{0, 0}, g.swapchain.extent},
    layerCount = 1,
    colorAttachmentCount = cast(u32) len(color_attachment_infos),
    pColorAttachments = raw_data(color_attachment_infos),
    pDepthAttachment = &depth_attachment_info if has_depth_attachment else nil,
  })

  vk.CmdSetViewport(frame.cmd, 0, 1, &vk.Viewport{
    x = pass.viewport[0],
    y = pass.viewport[1],
    width = pass.viewport[2],
    height = pass.viewport[3],
    minDepth = 0,
    maxDepth = 1,
  })

  vk.CmdSetScissor(frame.cmd, 0, 1, &vk.Rect2D{
    offset = {i32(pass.scissor[0]), i32(pass.scissor[1])},
    extent = {u32(pass.scissor[2]), u32(pass.scissor[3])},
  })

  pipeline := pass.pipeline.vk
  vk.CmdBindPipeline(frame.cmd, pipeline.kind, pipeline.handle)
  vk.CmdBindDescriptorSets(frame.cmd, pipeline.kind, pipeline.layout, 0, 1, &g.desc_set, 0, nil)
}

vk_end_pass :: proc()
{
  vk.CmdEndRendering(g.frames[g.frame_idx].cmd)
}

@(require_results)
vk_get_color_target :: proc() -> ^Image
{
  return &g.swapchain.images[g.frames[g.frame_idx].image_idx]
}

// @(require_results)
// vk_get_color_target_format :: proc() -> Image_Format
// {
//   return g.device.color_format
// }

@(require_results)
vk_get_depth_target :: proc() -> ^Image
{
  return &g.frames[g.frame_idx].depth_image
}

vk_push_data :: proc(data: rawptr, size, offset: int)
{
  log.assert(g.pass.pipeline.vk.handle != 0, "[render_vk]: Pipeline not provided!\n")

  cmd := g.frames[g.frame_idx].cmd
  vk.CmdPushConstants(cmd, g.pass.pipeline.vk.layout, {.VERTEX, .FRAGMENT}, 0, u32(size), data)
}

vk_draw :: proc(vertex_count, instance_count, first_vertex, first_instance: uint)
{
  cmd := g.frames[g.frame_idx].cmd
  vk.CmdDraw(cmd, u32(vertex_count),u32(instance_count), u32(first_vertex), u32(first_instance))
}

vk_draw_indexed :: proc(index_count, instance_count, first_index, first_instance: uint)
{
  log.assert(g.pass.index_buf.vk.handle != 0, "[render_vk]: Index buffer not provided!\n")

  cmd := g.frames[g.frame_idx].cmd
  vk.CmdBindIndexBuffer(cmd, g.pass.index_buf.vk.handle, 0, .UINT16)
  vk.CmdDrawIndexed(cmd, u32(index_count), u32(instance_count), u32(first_index), 0, u32(first_instance))
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
    vk.EXT_LAYER_SETTINGS_EXTENSION_NAME,
  }

  setting_value: b32 = true
  layer_settings: []vk.LayerSettingEXT = {
    {"VK_LAYER_KHRONOS_validation", "validate_sync", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "thread_safety", .BOOL32, 1, &setting_value},
    // {"VK_LAYER_KHRONOS_validation", "legacy_detection", .BOOL32, 1, &setting_value},
    {"VK_LAYER_KHRONOS_validation", "validate_best_practices", .BOOL32, 1, &setting_value},
    // {"VK_LAYER_KHRONOS_validation", "validate_best_practices_amd", .BOOL32, 1, &setting_value},
    // {"VK_LAYER_KHRONOS_validation", "validate_best_practices_nvidia", .BOOL32, 1, &setting_value},
    // {"VK_LAYER_KHRONOS_validation", "gpuav_enable", .BOOL32, 1, &setting_value},
  }
  layer_settings_ci := vk.LayerSettingsCreateInfoEXT{
    sType = .LAYER_SETTINGS_CREATE_INFO_EXT, 
    settingCount = u32(len(layer_settings)), 
    pSettings = raw_data(layer_settings),
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
      /**/ if .ERROR in severity do fmt.eprintf("\033[31m[ERROR] --- [render_vk]: %s\033[0m\n", callback_data.pMessage)
      else if .WARNING in severity do fmt.eprintf("\033[33m[WARN ] --- [render_vk]: %s\033[0m\n", callback_data.pMessage)
      else if .INFO in severity do fmt.eprintf("[INFO ] --- [render_vk]: %s\n", callback_data.pMessage)
      return false
    },
    pNext = &layer_settings_ci when ODIN_DEBUG else nil,
  }

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
    pNext = &debug_messenger_ci,
  }, nil, &g.instance)
  vk_check(result)

  vk.load_proc_addresses_instance(g.instance)
  assert(vk.DestroyInstance != nil, "[FATAL] --- [render_vk]: Failed to load Vulkan instance API.")

  result = vk.CreateDebugUtilsMessengerEXT(g.instance, &debug_messenger_ci, nil, &g.debug_messenger)
  vk_check(result)

  // - Surface ---

  sdl_ok := sdl.Vulkan_CreateSurface(g.window.handle, g.instance, nil, &g.surface)
  if !sdl_ok
  {
    fmt.println("[FATAL] --- [render_vk]: Failed to create Vulkan surface:", sdl.GetError())
    os.exit(1)
  }
}

@(require_results)
vk_create_device :: proc() -> VK_Device
{
  device: VK_Device
  result: vk.Result
  next: rawptr

  // - Physical device ---

  physical_devices: [3]vk.PhysicalDevice
  physical_devices_count: u32
  physical_device_props: [3]vk.PhysicalDeviceProperties
  physical_device_features: [3]vk.PhysicalDeviceFeatures
  physical_device_qf_props: [3][8]vk.QueueFamilyProperties
  physical_device_qf_props_count: u32

  result = vk.EnumeratePhysicalDevices(g.instance, &physical_devices_count, nil)
  vk_check(result)

  result = vk.EnumeratePhysicalDevices(g.instance, &physical_devices_count, &physical_devices[0])
  vk_check(result)

  device_loop: for dev, i in physical_devices[:physical_devices_count]
  {
    vk.GetPhysicalDeviceProperties(dev, &physical_device_props[i])
    vk.GetPhysicalDeviceFeatures(dev, &physical_device_features[i])
    vk.GetPhysicalDeviceQueueFamilyProperties(dev, &physical_device_qf_props_count, nil)
    vk.GetPhysicalDeviceQueueFamilyProperties(dev, &physical_device_qf_props_count, &physical_device_qf_props[i][0])

    for fam, j in physical_device_qf_props[i][:physical_device_qf_props_count]
    {
      vk.GetPhysicalDeviceProperties(dev, &physical_device_props[i])

      supports_present: b32
      result = vk.GetPhysicalDeviceSurfaceSupportKHR(dev, u32(j), g.surface, &supports_present)
      vk_check(result)

      if .GRAPHICS in fam.queueFlags && supports_present && physical_device_props[i].deviceType == .INTEGRATED_GPU
      {
        fmt.printf("[INFO ] --- [render_vk]: Selected device '%v'.\n", string(physical_device_props[i].deviceName[:]))
        
        device.physical = dev
        device.limits = physical_device_props[i].limits
        device.queue_family_idx = u32(j)
        break device_loop
      }
    }
  }

  assert(device.physical != nil, "[FATAL] --- [render_vk]: No suitable GPU found!")

  for format in ([]vk.Format{.D24_UNORM_S8_UINT, .D32_SFLOAT_S8_UINT, .D16_UNORM_S8_UINT})
  {
    props: vk.FormatProperties
    vk.GetPhysicalDeviceFormatProperties(device.physical, format, &props)
    if .DEPTH_STENCIL_ATTACHMENT in props.optimalTilingFeatures
    {
      fmt.printf("[INFO ] --- [render_vk]: Selected depth format '%v'.\n", format)
      device.depth_format = format
      break
    }
  }

  if device.depth_format == .UNDEFINED
  {
    fmt.printf("[ERROR] --- [render_vk]: No suitable depth format found!\n")
    os.exit(1)
  }

  // - Logical device ---

  extensions := [?]cstring{
    vk.KHR_SWAPCHAIN_EXTENSION_NAME,
  }

  features: vk.PhysicalDeviceFeatures = {
    samplerAnisotropy = true,
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
    scalarBlockLayout = true,
    descriptorIndexing = true,
    shaderSampledImageArrayNonUniformIndexing = true,
    descriptorBindingVariableDescriptorCount = true,
    runtimeDescriptorArray = true,
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
    pEnabledFeatures = &features,
  }, nil, &device.handle)
  vk_check(result)

  vk.load_proc_addresses_device(device.handle)
  assert(vk.BeginCommandBuffer != nil, "[FATAL] --- [render_vk]: Failed to load Vulkan device API.")

  vk.GetDeviceQueue(device.handle, device.queue_family_idx, 0, &device.queue)

  return device
}

vk_destroy_device :: proc(device: ^VK_Device)
{
  vk.DestroyDevice(device.handle, nil)
}

@(require_results)
vk_create_swapchain :: proc(old_swapchain: ^VK_Swapchain) -> VK_Swapchain
{
  swapchain: VK_Swapchain

  capabilities: vk.SurfaceCapabilitiesKHR
  vk_check(vk.GetPhysicalDeviceSurfaceCapabilitiesKHR(g.device.physical, g.surface, &capabilities))

  swapchain.image_count = 2
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
  when USE_MAILBOX do for mode in modes[:modes_count]
  {
    if mode == .MAILBOX
    {
      present_mode = mode
      break
    }
  }

  if old_swapchain == nil
  {
    fmt.printf("[INFO ] --- [render_vk]: Selected present mode '%v'.\n", present_mode)
  }

  formats: [128]vk.SurfaceFormatKHR
  formats_count: u32
  vk_check(vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, nil))
  vk_check(vk.GetPhysicalDeviceSurfaceFormatsKHR(g.device.physical, g.surface, &formats_count, &formats[0]))

  g.device.surface_format = formats[0]
  for format in formats[:formats_count]
  {
    if format == (vk.SurfaceFormatKHR{.B8G8R8A8_SRGB, .SRGB_NONLINEAR})
    {
      g.device.surface_format = format
      g.device.color_format = format.format
      break
    }
  }

  width, height: i32
  sdl.GetWindowSizeInPixels(g.window.handle, &width, &height)
  swapchain.extent = {u32(width), u32(height)}

  swapchain_ci := vk.SwapchainCreateInfoKHR{
    sType = .SWAPCHAIN_CREATE_INFO_KHR,
    surface = g.surface,
    minImageCount = swapchain.image_count,
    imageFormat = g.device.surface_format.format,
    imageColorSpace = g.device.surface_format.colorSpace,
    imageExtent = swapchain.extent,
    imageArrayLayers = 1,
    imageUsage = {.COLOR_ATTACHMENT, .TRANSFER_DST},
    imageSharingMode = .EXCLUSIVE,
    preTransform = capabilities.currentTransform,
    compositeAlpha = {.OPAQUE},
    presentMode = present_mode,
    clipped = true,
    oldSwapchain = old_swapchain.handle if old_swapchain != nil else 0,
  }
  vk_check(vk.CreateSwapchainKHR(g.device.handle, &swapchain_ci, nil, &swapchain.handle))

  if old_swapchain != nil
  {
    vk_destroy_swapchain(old_swapchain)
  }

  // - Swapchain images ---

  swapchain_images: [4]vk.Image
  vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, nil))
  vk_check(vk.GetSwapchainImagesKHR(g.device.handle, swapchain.handle, &swapchain.image_count, &swapchain_images[0]))

  for &image, i in swapchain_images[:swapchain.image_count]
  {
    swapchain.images[i].vk.handle = image
    swapchain.images[i].vk.format = g.device.surface_format.format

    vk.CreateImageView(g.device.handle, &{
      sType = .IMAGE_VIEW_CREATE_INFO,
      image = image,
      viewType = .D2,
      format = g.device.surface_format.format,
      subresourceRange = {
        aspectMask = {.COLOR},
        levelCount = 1,
        layerCount = 1,
      },
    }, nil, &swapchain.images[i].vk.view)
  }

  sem_ci := vk.SemaphoreCreateInfo{sType=.SEMAPHORE_CREATE_INFO}
  for i in 0..<swapchain.image_count
  {
    vk_check(vk.CreateSemaphore(g.device.handle, &sem_ci, nil, &swapchain.render_finished[i]))
  }

  if old_swapchain == nil
  {
    fmt.printf("[INFO ] --- [render_vk]: Created %v swapchain images.\n", swapchain.image_count)
  }

  return swapchain
}

vk_recreate_swapchain :: proc()
{
  if g.swapchain.handle == 0 do return

  vk.DeviceWaitIdle(g.device.handle)

  g.swapchain = vk_create_swapchain(&g.swapchain)

  for &frame in g.frames
  {
    vk_destroy_image(&frame.depth_image.vk)
    frame.depth_image.vk = vk_create_image(g.swapchain.extent.width, g.swapchain.extent.height,
                                           g.device.depth_format, .UNDEFINED, 
                                           {.DEPTH}, {.DEPTH_STENCIL_ATTACHMENT})
  }
}

vk_destroy_swapchain :: proc(swapchain: ^VK_Swapchain)
{
  for image in swapchain.images do vk.DestroyImageView(g.device.handle, image.vk.view, nil)

  for sem in swapchain.render_finished do vk.DestroySemaphore(g.device.handle, sem, nil)

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

vk_create_buffer :: proc(
  size: uint, 
  buf_flags: vk.BufferUsageFlags, 
  mem_flags: vk.MemoryPropertyFlags,
) -> (
  buffer: VK_Buffer,
){
  buffer_ci := vk.BufferCreateInfo{
    sType = .BUFFER_CREATE_INFO,
    usage = buf_flags,
    sharingMode = .EXCLUSIVE,
    size = vk.DeviceSize(size),
    queueFamilyIndexCount = 1,
    pQueueFamilyIndices = &g.device.queue_family_idx,
  }

  host_visible_flags := vma.AllocationCreateFlags{
    .MAPPED, 
    .HOST_ACCESS_ALLOW_TRANSFER_INSTEAD, 
    .HOST_ACCESS_SEQUENTIAL_WRITE,
  }
  alloc_ci := vma.AllocationCreateInfo{
    usage = .AUTO,
    flags = (.HOST_VISIBLE in mem_flags) ? host_visible_flags : {},
    preferredFlags = mem_flags,
  }

  vk_check(vma.CreateBuffer(g.gpu_allocator, &buffer_ci, &alloc_ci, &buffer.handle, &buffer.allocation, &buffer.info))

  buffer.data = buffer.info.pMappedData

  if .SHADER_DEVICE_ADDRESS in buf_flags
  {
    buffer.address = vk.GetBufferDeviceAddress(g.device.handle, &{
      sType = .BUFFER_DEVICE_ADDRESS_INFO,
      buffer = buffer.handle,
    })
  }
  
  return buffer
}

vk_destroy_buffer :: proc(buffer: ^VK_Buffer)
{
  vma.DestroyBuffer(g.gpu_allocator, buffer.handle, buffer.allocation)
}

vk_transition_image :: proc(cmd: vk.CommandBuffer, image: ^VK_Image, state: Image_State)
{
  @(static, rodata)
  state_table: [Image_State]VK_Image_State_Info = {
    .Nil = {
      stages = {},
      access = {},
      layout = .UNDEFINED,
    },
    .Acquired = {
      stages = {.COLOR_ATTACHMENT_OUTPUT},
      access = {},
      layout = .UNDEFINED,
    },
    .Color_Attachment = {
      stages = {.COLOR_ATTACHMENT_OUTPUT},
      access = {.COLOR_ATTACHMENT_WRITE},
      layout = .COLOR_ATTACHMENT_OPTIMAL,
    },
    .Depth_Attachment = {
      stages = {.EARLY_FRAGMENT_TESTS, .LATE_FRAGMENT_TESTS},
      access = {.DEPTH_STENCIL_ATTACHMENT_WRITE},
      layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    },
    .Fragment_Shader_Read = {
      stages = {.FRAGMENT_SHADER},
      access = {.SHADER_SAMPLED_READ},
      layout = .SHADER_READ_ONLY_OPTIMAL,
    },
    .Transfer_Src = {
      stages = {.TRANSFER},
      access = {.TRANSFER_READ},
      layout = .TRANSFER_SRC_OPTIMAL,
    },
    .Transfer_Dst = {
      stages = {.TRANSFER},
      access = {.TRANSFER_WRITE},
      layout = .TRANSFER_DST_OPTIMAL,
    },
    .Present = {
      stages = {},
      access = {},
      layout = .PRESENT_SRC_KHR,
    },
  }

  if image.state == state do return

  src_info := state_table[image.state]
  dst_info := state_table[state]

  aspect: vk.ImageAspectFlags = {.COLOR}
  if state == .Depth_Attachment
  {
    aspect = {.DEPTH, .STENCIL}
  }

  vk.CmdPipelineBarrier2(cmd, &{
    sType = .DEPENDENCY_INFO,
    imageMemoryBarrierCount = 1,
    pImageMemoryBarriers = &vk.ImageMemoryBarrier2{
      sType = .IMAGE_MEMORY_BARRIER_2,
      image = image.handle,
      subresourceRange = {
        aspectMask = aspect,
        layerCount = 1,
        levelCount = 1,
      },
      oldLayout = src_info.layout,
      newLayout = dst_info.layout,
      srcStageMask = src_info.stages,
      srcAccessMask = src_info.access,
      dstStageMask = dst_info.stages,
      dstAccessMask = dst_info.access,
      srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
      dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
    },
  })

  image.state = state
}

@(require_results)
vk_create_image :: proc(
  width:  u32, 
  height: u32, 
  format: vk.Format,
  layout: vk.ImageLayout,
  aspect: vk.ImageAspectFlags,
  usage:  vk.ImageUsageFlags,
) -> (
  image: VK_Image,
){
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

  image.format = format

  return image
}

@(require_results)
vk_create_texture :: proc(pixels: []byte, width, height: u32, format: vk.Format) -> VK_Image
{
  texture := vk_create_image(width, height, format, .SHADER_READ_ONLY_OPTIMAL, {.COLOR}, {.TRANSFER_DST, .SAMPLED})

  staging_buf := vk_create_buffer(len(pixels), {.TRANSFER_SRC}, {.HOST_VISIBLE, .HOST_COHERENT})
  defer vk_destroy_buffer(&staging_buf)

  mem.copy(staging_buf.data, raw_data(pixels), len(pixels))

  cmd := vk_begin_cmd_burst()

  vk_transition_image(cmd, &texture, .Transfer_Dst)

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

  vk_transition_image(cmd, &texture, .Fragment_Shader_Read)

  vk_end_cmd_burst(cmd)

  return texture
}

vk_destroy_image :: proc(texture: ^VK_Image)
{
  vk.DestroyImageView(g.device.handle, texture.view, nil)
  vma.DestroyImage(g.gpu_allocator, texture.handle, texture.allocation)
}

@(require_results)
vk_create_graphics_pipeline :: proc(desc: Graphics_Pipeline_Desc) -> VK_Pipeline
{
  pipeline: VK_Pipeline

  vs_module: vk.ShaderModule
  vk_check(vk.CreateShaderModule(g.device.handle, &{
    sType = .SHADER_MODULE_CREATE_INFO,
    codeSize = len(desc.vert_shader_src),
    pCode = cast(^u32) raw_data(desc.vert_shader_src),
  }, nil, &vs_module))
  defer vk.DestroyShaderModule(g.device.handle, vs_module, nil)

  fs_module: vk.ShaderModule
  vk_check(vk.CreateShaderModule(g.device.handle, &{
    sType = .SHADER_MODULE_CREATE_INFO,
    codeSize = len(desc.frag_shader_src),
    pCode = cast(^u32) raw_data(desc.frag_shader_src),
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
    blendEnable = cast(b32) desc.blend_en,
    colorWriteMask = {.R, .G, .B, .A},
    srcColorBlendFactor = .SRC_ALPHA,
    dstColorBlendFactor = .ONE_MINUS_SRC_ALPHA,
    srcAlphaBlendFactor = .SRC_ALPHA,
    dstAlphaBlendFactor = .ONE_MINUS_SRC_ALPHA,
    colorBlendOp = .ADD,
    alphaBlendOp = .ADD,
  }
  blend_state_ci := vk.PipelineColorBlendStateCreateInfo{
    sType = .PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    logicOpEnable = false,
    logicOp = .COPY,
    attachmentCount = 1,
    pAttachments = &blend_attach_st,
  }

  color_attachment_fmt := vk_image_format_from_base(desc.color_attachment_fmt)
  depth_attachment_fmt := vk_image_format_from_base(desc.depth_attachment_fmt)

  rendering_ci := vk.PipelineRenderingCreateInfo{
    sType = .PIPELINE_RENDERING_CREATE_INFO,
    colorAttachmentCount = 1,
    pColorAttachmentFormats = &color_attachment_fmt,
    depthAttachmentFormat = depth_attachment_fmt,
  }

  depth_stencil_ci := vk.PipelineDepthStencilStateCreateInfo{
    sType = .PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO,
    depthTestEnable = cast(b32) desc.depth_test_en,
    depthWriteEnable = cast(b32) desc.depth_test_en,
    depthCompareOp = .LESS,
    depthBoundsTestEnable = false,
    stencilTestEnable = cast(b32) desc.stencil_test_en,
  }

  dynamic_states := [2]vk.DynamicState{.VIEWPORT, .SCISSOR}
  dynamic_state_ci := vk.PipelineDynamicStateCreateInfo{
    sType = .PIPELINE_DYNAMIC_STATE_CREATE_INFO,
    dynamicStateCount = len(dynamic_states),
    pDynamicStates = raw_data(dynamic_states[:]),
  }

  vk_check(vk.CreatePipelineLayout(g.device.handle, &{
    sType = .PIPELINE_LAYOUT_CREATE_INFO,
    pushConstantRangeCount = 1,
    pPushConstantRanges = &vk.PushConstantRange{
      stageFlags = {.VERTEX, .FRAGMENT},
      size = cast(u32) desc.push_data_size,
    },
    setLayoutCount = 1,
    pSetLayouts = &g.desc_layout,
  }, nil, &pipeline.layout))

  vk_check(vk.CreateGraphicsPipelines(g.device.handle, 0, 1, &vk.GraphicsPipelineCreateInfo{
    sType = .GRAPHICS_PIPELINE_CREATE_INFO,
    pNext = &rendering_ci,
    layout = pipeline.layout,
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
  }, nil, &pipeline.handle))

  pipeline.kind = .GRAPHICS

  return pipeline
}

vk_image_format_from_base :: proc(format: Image_Format) -> vk.Format
{
  switch format
  {
    case .Undefined:          return .UNDEFINED
    case .A8_UNORM:           return .A8_UNORM
    case .B8G8R8A8_SRGB:      return .B8G8R8A8_SRGB
    case .R8G8B8A8_USCALED:   return .R8G8B8A8_USCALED
    case .R8G8B8A8_UINT:      return .R8G8B8A8_UINT
    case .R8G8B8A8_SRGB:      return .R8G8B8A8_SRGB
    case .R8G8B8A8_UNORM:     return .R8G8B8A8_UNORM
    case .D16_UNORM_S8_UINT:  return .D16_UNORM_S8_UINT
    case .D24_UNORM_S8_UINT:  return .D24_UNORM_S8_UINT
    case .D32_SFLOAT_S8_UINT: return .D32_SFLOAT_S8_UINT
  }

  return .UNDEFINED
}

vk_image_format_to_base :: proc(format: vk.Format) -> Image_Format
{
  #partial switch format
  {
    case .UNDEFINED:          return .Undefined
    case .R8_SRGB:            return .A8_UNORM
    case .B8G8R8A8_SRGB:      return .B8G8R8A8_SRGB
    case .R8G8B8A8_USCALED:   return .R8G8B8A8_USCALED
    case .R8G8B8A8_UINT:      return .R8G8B8A8_UINT
    case .R8G8B8A8_SRGB:      return .R8G8B8A8_SRGB
    case .R8G8B8A8_UNORM:     return .R8G8B8A8_UNORM
    case .D16_UNORM_S8_UINT:  return .D16_UNORM_S8_UINT
    case .D24_UNORM_S8_UINT:  return .D24_UNORM_S8_UINT
    case .D32_SFLOAT_S8_UINT: return .D32_SFLOAT_S8_UINT
  }

  return .Undefined
}

vk_image_load_op :: proc(op: Image_Load_Op) -> vk.AttachmentLoadOp
{
  switch op
  {
  case .None:      return .NONE
  case .Load:      return .LOAD
  case .Clear:     return .CLEAR
  case .Dont_Care: return .DONT_CARE
  }

  return .NONE
}

vk_image_store_op :: proc(op: Image_Store_Op) -> vk.AttachmentStoreOp
{
  switch op
  {
  case .None:      return .NONE
  case .Store:     return .STORE
  case .Dont_Care: return .DONT_CARE
  }

  return .NONE
}
