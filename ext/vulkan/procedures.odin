package vulkan

import "core:c"

// Loader Procedure Types
ProcCreateInstance                       :: #type proc "system" (pCreateInfo: ^InstanceCreateInfo, pAllocator: ^AllocationCallbacks, pInstance: ^Instance) -> Result
ProcDebugUtilsMessengerCallbackEXT       :: #type proc "system" (messageSeverity: DebugUtilsMessageSeverityFlagsEXT, messageTypes: DebugUtilsMessageTypeFlagsEXT, pCallbackData: ^DebugUtilsMessengerCallbackDataEXT, pUserData: rawptr) -> b32
ProcDeviceMemoryReportCallbackEXT        :: #type proc "system" (pCallbackData: ^DeviceMemoryReportCallbackDataEXT, pUserData: rawptr)
ProcEnumerateInstanceExtensionProperties :: #type proc "system" (pLayerName: cstring, pPropertyCount: ^u32, pProperties: [^]ExtensionProperties) -> Result
ProcEnumerateInstanceLayerProperties     :: #type proc "system" (pPropertyCount: ^u32, pProperties: [^]LayerProperties) -> Result
ProcEnumerateInstanceVersion             :: #type proc "system" (pApiVersion: ^u32) -> Result
ProcGetExternalComputeQueueDataNV        :: #type proc "system" (externalQueue: ExternalComputeQueueNV, params: [^]ExternalComputeQueueDataParamsNV, pData: rawptr)

// Misc Procedure Types
ProcAllocationFunction             :: #type proc "system" (pUserData: rawptr, size: int, alignment: int, allocationScope: SystemAllocationScope) -> rawptr
ProcDebugReportCallbackEXT         :: #type proc "system" (flags: DebugReportFlagsEXT, objectType: DebugReportObjectTypeEXT, object: u64, location: int, messageCode: i32, pLayerPrefix: cstring, pMessage: cstring, pUserData: rawptr) -> b32
ProcFreeFunction                   :: #type proc "system" (pUserData: rawptr, pMemory: rawptr)
ProcInternalAllocationNotification :: #type proc "system" (pUserData: rawptr, size: int, allocationType: InternalAllocationType, allocationScope: SystemAllocationScope)
ProcInternalFreeNotification       :: #type proc "system" (pUserData: rawptr, size: int, allocationType: InternalAllocationType, allocationScope: SystemAllocationScope)
ProcReallocationFunction           :: #type proc "system" (pUserData: rawptr, pOriginal: rawptr, size: int, alignment: int, allocationScope: SystemAllocationScope) -> rawptr
ProcVoidFunction                   :: #type proc "system" ()

// Instance Procedure Types
ProcAcquireDrmDisplayEXT                                               :: #type proc "system" (physicalDevice: PhysicalDevice, drmFd: i32, display: DisplayKHR) -> Result
ProcAcquireWinrtDisplayNV                                              :: #type proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR) -> Result
ProcCreateAndroidSurfaceKHR                                            :: #type proc "system" (instance: Instance, pCreateInfo: ^AndroidSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateDebugReportCallbackEXT                                       :: #type proc "system" (instance: Instance, pCreateInfo: ^DebugReportCallbackCreateInfoEXT, pAllocator: ^AllocationCallbacks, pCallback: ^DebugReportCallbackEXT) -> Result
ProcCreateDebugUtilsMessengerEXT                                       :: #type proc "system" (instance: Instance, pCreateInfo: ^DebugUtilsMessengerCreateInfoEXT, pAllocator: ^AllocationCallbacks, pMessenger: ^DebugUtilsMessengerEXT) -> Result
ProcCreateDevice                                                       :: #type proc "system" (physicalDevice: PhysicalDevice, pCreateInfo: ^DeviceCreateInfo, pAllocator: ^AllocationCallbacks, pDevice: ^Device) -> Result
ProcCreateDisplayModeKHR                                               :: #type proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pCreateInfo: ^DisplayModeCreateInfoKHR, pAllocator: ^AllocationCallbacks, pMode: ^DisplayModeKHR) -> Result
ProcCreateDisplayPlaneSurfaceKHR                                       :: #type proc "system" (instance: Instance, pCreateInfo: ^DisplaySurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateHeadlessSurfaceEXT                                           :: #type proc "system" (instance: Instance, pCreateInfo: ^HeadlessSurfaceCreateInfoEXT, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateIOSSurfaceMVK                                                :: #type proc "system" (instance: Instance, pCreateInfo: ^IOSSurfaceCreateInfoMVK, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateMacOSSurfaceMVK                                              :: #type proc "system" (instance: Instance, pCreateInfo: ^MacOSSurfaceCreateInfoMVK, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateMetalSurfaceEXT                                              :: #type proc "system" (instance: Instance, pCreateInfo: ^MetalSurfaceCreateInfoEXT, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateWaylandSurfaceKHR                                            :: #type proc "system" (instance: Instance, pCreateInfo: ^WaylandSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateWin32SurfaceKHR                                              :: #type proc "system" (instance: Instance, pCreateInfo: ^Win32SurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateXcbSurfaceKHR                                                :: #type proc "system" (instance: Instance, pCreateInfo: ^XcbSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcCreateXlibSurfaceKHR                                               :: #type proc "system" (instance: Instance, pCreateInfo: ^XlibSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result
ProcDebugReportMessageEXT                                              :: #type proc "system" (instance: Instance, flags: DebugReportFlagsEXT, objectType: DebugReportObjectTypeEXT, object: u64, location: int, messageCode: i32, pLayerPrefix: cstring, pMessage: cstring)
ProcDestroyDebugReportCallbackEXT                                      :: #type proc "system" (instance: Instance, callback: DebugReportCallbackEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyDebugUtilsMessengerEXT                                      :: #type proc "system" (instance: Instance, messenger: DebugUtilsMessengerEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyInstance                                                    :: #type proc "system" (instance: Instance, pAllocator: ^AllocationCallbacks)
ProcDestroySurfaceKHR                                                  :: #type proc "system" (instance: Instance, surface: SurfaceKHR, pAllocator: ^AllocationCallbacks)
ProcEnumerateDeviceExtensionProperties                                 :: #type proc "system" (physicalDevice: PhysicalDevice, pLayerName: cstring, pPropertyCount: ^u32, pProperties: [^]ExtensionProperties) -> Result
ProcEnumerateDeviceLayerProperties                                     :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]LayerProperties) -> Result
ProcEnumeratePhysicalDeviceGroups                                      :: #type proc "system" (instance: Instance, pPhysicalDeviceGroupCount: ^u32, pPhysicalDeviceGroupProperties: [^]PhysicalDeviceGroupProperties) -> Result
ProcEnumeratePhysicalDeviceGroupsKHR                                   :: #type proc "system" (instance: Instance, pPhysicalDeviceGroupCount: ^u32, pPhysicalDeviceGroupProperties: [^]PhysicalDeviceGroupProperties) -> Result
ProcEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM   :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pCounterCount: ^u32, pCounters: [^]PerformanceCounterARM, pCounterDescriptions: [^]PerformanceCounterDescriptionARM) -> Result
ProcEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR      :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pCounterCount: ^u32, pCounters: [^]PerformanceCounterKHR, pCounterDescriptions: [^]PerformanceCounterDescriptionKHR) -> Result
ProcEnumeratePhysicalDeviceShaderInstrumentationMetricsARM             :: #type proc "system" (physicalDevice: PhysicalDevice, pDescriptionCount: ^u32, pDescriptions: [^]ShaderInstrumentationMetricDescriptionARM) -> Result
ProcEnumeratePhysicalDevices                                           :: #type proc "system" (instance: Instance, pPhysicalDeviceCount: ^u32, pPhysicalDevices: [^]PhysicalDevice) -> Result
ProcGetDisplayModeProperties2KHR                                       :: #type proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pPropertyCount: ^u32, pProperties: [^]DisplayModeProperties2KHR) -> Result
ProcGetDisplayModePropertiesKHR                                        :: #type proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pPropertyCount: ^u32, pProperties: [^]DisplayModePropertiesKHR) -> Result
ProcGetDisplayPlaneCapabilities2KHR                                    :: #type proc "system" (physicalDevice: PhysicalDevice, pDisplayPlaneInfo: ^DisplayPlaneInfo2KHR, pCapabilities: [^]DisplayPlaneCapabilities2KHR) -> Result
ProcGetDisplayPlaneCapabilitiesKHR                                     :: #type proc "system" (physicalDevice: PhysicalDevice, mode: DisplayModeKHR, planeIndex: u32, pCapabilities: [^]DisplayPlaneCapabilitiesKHR) -> Result
ProcGetDisplayPlaneSupportedDisplaysKHR                                :: #type proc "system" (physicalDevice: PhysicalDevice, planeIndex: u32, pDisplayCount: ^u32, pDisplays: [^]DisplayKHR) -> Result
ProcGetDrmDisplayEXT                                                   :: #type proc "system" (physicalDevice: PhysicalDevice, drmFd: i32, connectorId: u32, display: ^DisplayKHR) -> Result
ProcGetInstanceProcAddr                                                :: #type proc "system" (instance: Instance, pName: cstring) -> ProcVoidFunction
ProcGetInstanceProcAddrLUNARG                                          :: #type proc "system" (instance: Instance, pName: cstring) -> ProcVoidFunction
ProcGetPhysicalDeviceCalibrateableTimeDomainsEXT                       :: #type proc "system" (physicalDevice: PhysicalDevice, pTimeDomainCount: ^u32, pTimeDomains: [^]TimeDomainKHR) -> Result
ProcGetPhysicalDeviceCalibrateableTimeDomainsKHR                       :: #type proc "system" (physicalDevice: PhysicalDevice, pTimeDomainCount: ^u32, pTimeDomains: [^]TimeDomainKHR) -> Result
ProcGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV   :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixFlexibleDimensionsPropertiesNV) -> Result
ProcGetPhysicalDeviceCooperativeMatrixPropertiesKHR                    :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixPropertiesKHR) -> Result
ProcGetPhysicalDeviceCooperativeMatrixPropertiesNV                     :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixPropertiesNV) -> Result
ProcGetPhysicalDeviceCooperativeVectorPropertiesNV                     :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeVectorPropertiesNV) -> Result
ProcGetPhysicalDeviceDescriptorSizeEXT                                 :: #type proc "system" (physicalDevice: PhysicalDevice, descriptorType: DescriptorType) -> DeviceSize
ProcGetPhysicalDeviceDisplayPlaneProperties2KHR                        :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPlaneProperties2KHR) -> Result
ProcGetPhysicalDeviceDisplayPlanePropertiesKHR                         :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPlanePropertiesKHR) -> Result
ProcGetPhysicalDeviceDisplayProperties2KHR                             :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayProperties2KHR) -> Result
ProcGetPhysicalDeviceDisplayPropertiesKHR                              :: #type proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPropertiesKHR) -> Result
ProcGetPhysicalDeviceExternalBufferProperties                          :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalBufferInfo: ^PhysicalDeviceExternalBufferInfo, pExternalBufferProperties: [^]ExternalBufferProperties)
ProcGetPhysicalDeviceExternalBufferPropertiesKHR                       :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalBufferInfo: ^PhysicalDeviceExternalBufferInfo, pExternalBufferProperties: [^]ExternalBufferProperties)
ProcGetPhysicalDeviceExternalFenceProperties                           :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalFenceInfo: ^PhysicalDeviceExternalFenceInfo, pExternalFenceProperties: [^]ExternalFenceProperties)
ProcGetPhysicalDeviceExternalFencePropertiesKHR                        :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalFenceInfo: ^PhysicalDeviceExternalFenceInfo, pExternalFenceProperties: [^]ExternalFenceProperties)
ProcGetPhysicalDeviceExternalImageFormatPropertiesNV                   :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, tiling: ImageTiling, usage: ImageUsageFlags, flags: ImageCreateFlags, externalHandleType: ExternalMemoryHandleTypeFlagsNV, pExternalImageFormatProperties: [^]ExternalImageFormatPropertiesNV) -> Result
ProcGetPhysicalDeviceExternalSemaphoreProperties                       :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalSemaphoreInfo: ^PhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: [^]ExternalSemaphoreProperties)
ProcGetPhysicalDeviceExternalSemaphorePropertiesKHR                    :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalSemaphoreInfo: ^PhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: [^]ExternalSemaphoreProperties)
ProcGetPhysicalDeviceExternalTensorPropertiesARM                       :: #type proc "system" (physicalDevice: PhysicalDevice, pExternalTensorInfo: ^PhysicalDeviceExternalTensorInfoARM, pExternalTensorProperties: [^]ExternalTensorPropertiesARM)
ProcGetPhysicalDeviceFeatures                                          :: #type proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures)
ProcGetPhysicalDeviceFeatures2                                         :: #type proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures2)
ProcGetPhysicalDeviceFeatures2KHR                                      :: #type proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures2)
ProcGetPhysicalDeviceFormatProperties                                  :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties)
ProcGetPhysicalDeviceFormatProperties2                                 :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties2)
ProcGetPhysicalDeviceFormatProperties2KHR                              :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties2)
ProcGetPhysicalDeviceFragmentShadingRatesKHR                           :: #type proc "system" (physicalDevice: PhysicalDevice, pFragmentShadingRateCount: ^u32, pFragmentShadingRates: [^]PhysicalDeviceFragmentShadingRateKHR) -> Result
ProcGetPhysicalDeviceImageFormatProperties                             :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, tiling: ImageTiling, usage: ImageUsageFlags, flags: ImageCreateFlags, pImageFormatProperties: [^]ImageFormatProperties) -> Result
ProcGetPhysicalDeviceImageFormatProperties2                            :: #type proc "system" (physicalDevice: PhysicalDevice, pImageFormatInfo: ^PhysicalDeviceImageFormatInfo2, pImageFormatProperties: [^]ImageFormatProperties2) -> Result
ProcGetPhysicalDeviceImageFormatProperties2KHR                         :: #type proc "system" (physicalDevice: PhysicalDevice, pImageFormatInfo: ^PhysicalDeviceImageFormatInfo2, pImageFormatProperties: [^]ImageFormatProperties2) -> Result
ProcGetPhysicalDeviceMemoryProperties                                  :: #type proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties)
ProcGetPhysicalDeviceMemoryProperties2                                 :: #type proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties2)
ProcGetPhysicalDeviceMemoryProperties2KHR                              :: #type proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties2)
ProcGetPhysicalDeviceMultisamplePropertiesEXT                          :: #type proc "system" (physicalDevice: PhysicalDevice, samples: SampleCountFlags, pMultisampleProperties: [^]MultisamplePropertiesEXT)
ProcGetPhysicalDeviceOpticalFlowImageFormatsNV                         :: #type proc "system" (physicalDevice: PhysicalDevice, pOpticalFlowImageFormatInfo: ^OpticalFlowImageFormatInfoNV, pFormatCount: ^u32, pImageFormatProperties: [^]OpticalFlowImageFormatPropertiesNV) -> Result
ProcGetPhysicalDevicePresentRectanglesKHR                              :: #type proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pRectCount: ^u32, pRects: [^]Rect2D) -> Result
ProcGetPhysicalDeviceProperties                                        :: #type proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties)
ProcGetPhysicalDeviceProperties2                                       :: #type proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties2)
ProcGetPhysicalDeviceProperties2KHR                                    :: #type proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties2)
ProcGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM  :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM, pProperties: [^]BaseOutStructure) -> Result
ProcGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM    :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM, pOpticalFlowImageFormatInfo: ^DataGraphOpticalFlowImageFormatInfoARM, pFormatCount: ^u32, pImageFormatProperties: [^]DataGraphOpticalFlowImageFormatPropertiesARM) -> Result
ProcGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM :: #type proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyDataGraphProcessingEngineInfo: ^PhysicalDeviceQueueFamilyDataGraphProcessingEngineInfoARM, pQueueFamilyDataGraphProcessingEngineProperties: [^]QueueFamilyDataGraphProcessingEnginePropertiesARM)
ProcGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM                 :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphPropertyCount: ^u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM) -> Result
ProcGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR              :: #type proc "system" (physicalDevice: PhysicalDevice, pPerformanceQueryCreateInfo: ^QueryPoolPerformanceCreateInfoKHR, pNumPasses: [^]u32)
ProcGetPhysicalDeviceQueueFamilyProperties                             :: #type proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties)
ProcGetPhysicalDeviceQueueFamilyProperties2                            :: #type proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties2)
ProcGetPhysicalDeviceQueueFamilyProperties2KHR                         :: #type proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties2)
ProcGetPhysicalDeviceSparseImageFormatProperties                       :: #type proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, samples: SampleCountFlags, usage: ImageUsageFlags, tiling: ImageTiling, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties)
ProcGetPhysicalDeviceSparseImageFormatProperties2                      :: #type proc "system" (physicalDevice: PhysicalDevice, pFormatInfo: ^PhysicalDeviceSparseImageFormatInfo2, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties2)
ProcGetPhysicalDeviceSparseImageFormatProperties2KHR                   :: #type proc "system" (physicalDevice: PhysicalDevice, pFormatInfo: ^PhysicalDeviceSparseImageFormatInfo2, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties2)
ProcGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV    :: #type proc "system" (physicalDevice: PhysicalDevice, pCombinationCount: ^u32, pCombinations: [^]FramebufferMixedSamplesCombinationNV) -> Result
ProcGetPhysicalDeviceSurfaceCapabilities2EXT                           :: #type proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceCapabilities: [^]SurfaceCapabilities2EXT) -> Result
ProcGetPhysicalDeviceSurfaceCapabilities2KHR                           :: #type proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pSurfaceCapabilities: [^]SurfaceCapabilities2KHR) -> Result
ProcGetPhysicalDeviceSurfaceCapabilitiesKHR                            :: #type proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceCapabilities: [^]SurfaceCapabilitiesKHR) -> Result
ProcGetPhysicalDeviceSurfaceFormats2KHR                                :: #type proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pSurfaceFormatCount: ^u32, pSurfaceFormats: [^]SurfaceFormat2KHR) -> Result
ProcGetPhysicalDeviceSurfaceFormatsKHR                                 :: #type proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceFormatCount: ^u32, pSurfaceFormats: [^]SurfaceFormatKHR) -> Result
ProcGetPhysicalDeviceSurfacePresentModes2EXT                           :: #type proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pPresentModeCount: ^u32, pPresentModes: [^]PresentModeKHR) -> Result
ProcGetPhysicalDeviceSurfacePresentModesKHR                            :: #type proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pPresentModeCount: ^u32, pPresentModes: [^]PresentModeKHR) -> Result
ProcGetPhysicalDeviceSurfaceSupportKHR                                 :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, surface: SurfaceKHR, pSupported: ^b32) -> Result
ProcGetPhysicalDeviceToolProperties                                    :: #type proc "system" (physicalDevice: PhysicalDevice, pToolCount: ^u32, pToolProperties: [^]PhysicalDeviceToolProperties) -> Result
ProcGetPhysicalDeviceToolPropertiesEXT                                 :: #type proc "system" (physicalDevice: PhysicalDevice, pToolCount: ^u32, pToolProperties: [^]PhysicalDeviceToolProperties) -> Result
ProcGetPhysicalDeviceVideoCapabilitiesKHR                              :: #type proc "system" (physicalDevice: PhysicalDevice, pVideoProfile: ^VideoProfileInfoKHR, pCapabilities: [^]VideoCapabilitiesKHR) -> Result
ProcGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR              :: #type proc "system" (physicalDevice: PhysicalDevice, pQualityLevelInfo: ^PhysicalDeviceVideoEncodeQualityLevelInfoKHR, pQualityLevelProperties: [^]VideoEncodeQualityLevelPropertiesKHR) -> Result
ProcGetPhysicalDeviceVideoFormatPropertiesKHR                          :: #type proc "system" (physicalDevice: PhysicalDevice, pVideoFormatInfo: ^PhysicalDeviceVideoFormatInfoKHR, pVideoFormatPropertyCount: ^u32, pVideoFormatProperties: [^]VideoFormatPropertiesKHR) -> Result
ProcGetPhysicalDeviceWaylandPresentationSupportKHR                     :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, display: ^wl_display) -> b32
ProcGetPhysicalDeviceWin32PresentationSupportKHR                       :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32) -> b32
ProcGetPhysicalDeviceXcbPresentationSupportKHR                         :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, connection: ^xcb_connection_t, visual_id: xcb_visualid_t) -> b32
ProcGetPhysicalDeviceXlibPresentationSupportKHR                        :: #type proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, dpy: ^XlibDisplay, visualID: XlibVisualID) -> b32
ProcGetWinrtDisplayNV                                                  :: #type proc "system" (physicalDevice: PhysicalDevice, deviceRelativeId: u32, pDisplay: ^DisplayKHR) -> Result
ProcReleaseDisplayEXT                                                  :: #type proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR) -> Result
ProcSubmitDebugUtilsMessageEXT                                         :: #type proc "system" (instance: Instance, messageSeverity: DebugUtilsMessageSeverityFlagsEXT, messageTypes: DebugUtilsMessageTypeFlagsEXT, pCallbackData: ^DebugUtilsMessengerCallbackDataEXT)

// Device Procedure Types
ProcAcquireFullScreenExclusiveModeEXT                      :: #type proc "system" (device: Device, swapchain: SwapchainKHR) -> Result
ProcAcquireNextImage2KHR                                   :: #type proc "system" (device: Device, pAcquireInfo: ^AcquireNextImageInfoKHR, pImageIndex: ^u32) -> Result
ProcAcquireNextImageKHR                                    :: #type proc "system" (device: Device, swapchain: SwapchainKHR, timeout: u64, semaphore: Semaphore, fence: Fence, pImageIndex: ^u32) -> Result
ProcAcquirePerformanceConfigurationINTEL                   :: #type proc "system" (device: Device, pAcquireInfo: ^PerformanceConfigurationAcquireInfoINTEL, pConfiguration: ^PerformanceConfigurationINTEL) -> Result
ProcAcquireProfilingLockKHR                                :: #type proc "system" (device: Device, pInfo: ^AcquireProfilingLockInfoKHR) -> Result
ProcAllocateCommandBuffers                                 :: #type proc "system" (device: Device, pAllocateInfo: ^CommandBufferAllocateInfo, pCommandBuffers: [^]CommandBuffer) -> Result
ProcAllocateDescriptorSets                                 :: #type proc "system" (device: Device, pAllocateInfo: ^DescriptorSetAllocateInfo, pDescriptorSets: [^]DescriptorSet) -> Result
ProcAllocateMemory                                         :: #type proc "system" (device: Device, pAllocateInfo: ^MemoryAllocateInfo, pAllocator: ^AllocationCallbacks, pMemory: ^DeviceMemory) -> Result
ProcAntiLagUpdateAMD                                       :: #type proc "system" (device: Device, pData: ^AntiLagDataAMD)
ProcBeginCommandBuffer                                     :: #type proc "system" (commandBuffer: CommandBuffer, pBeginInfo: ^CommandBufferBeginInfo) -> Result
ProcBindAccelerationStructureMemoryNV                      :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindAccelerationStructureMemoryInfoNV) -> Result
ProcBindBufferMemory                                       :: #type proc "system" (device: Device, buffer: Buffer, memory: DeviceMemory, memoryOffset: DeviceSize) -> Result
ProcBindBufferMemory2                                      :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindBufferMemoryInfo) -> Result
ProcBindBufferMemory2KHR                                   :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindBufferMemoryInfo) -> Result
ProcBindDataGraphPipelineSessionMemoryARM                  :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindDataGraphPipelineSessionMemoryInfoARM) -> Result
ProcBindImageMemory                                        :: #type proc "system" (device: Device, image: Image, memory: DeviceMemory, memoryOffset: DeviceSize) -> Result
ProcBindImageMemory2                                       :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindImageMemoryInfo) -> Result
ProcBindImageMemory2KHR                                    :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindImageMemoryInfo) -> Result
ProcBindOpticalFlowSessionImageNV                          :: #type proc "system" (device: Device, session: OpticalFlowSessionNV, bindingPoint: OpticalFlowSessionBindingPointNV, view: ImageView, layout: ImageLayout) -> Result
ProcBindTensorMemoryARM                                    :: #type proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindTensorMemoryInfoARM) -> Result
ProcBindVideoSessionMemoryKHR                              :: #type proc "system" (device: Device, videoSession: VideoSessionKHR, bindSessionMemoryInfoCount: u32, pBindSessionMemoryInfos: [^]BindVideoSessionMemoryInfoKHR) -> Result
ProcBuildAccelerationStructuresKHR                         :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: ^[^]AccelerationStructureBuildRangeInfoKHR) -> Result
ProcBuildMicromapsEXT                                      :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, infoCount: u32, pInfos: [^]MicromapBuildInfoEXT) -> Result
ProcClearShaderInstrumentationMetricsARM                   :: #type proc "system" (device: Device, instrumentation: ShaderInstrumentationARM)
ProcCmdBeginConditionalRendering2EXT                       :: #type proc "system" (commandBuffer: CommandBuffer, pConditionalRenderingBegin: ^ConditionalRenderingBeginInfo2EXT)
ProcCmdBeginConditionalRenderingEXT                        :: #type proc "system" (commandBuffer: CommandBuffer, pConditionalRenderingBegin: ^ConditionalRenderingBeginInfoEXT)
ProcCmdBeginCustomResolveEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, pBeginCustomResolveInfo: ^BeginCustomResolveInfoEXT)
ProcCmdBeginDebugUtilsLabelEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, pLabelInfo: ^DebugUtilsLabelEXT)
ProcCmdBeginGpaSampleAMD                                   :: #type proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD, pGpaSampleBeginInfo: ^GpaSampleBeginInfoAMD, pSampleID: ^u32) -> Result
ProcCmdBeginGpaSessionAMD                                  :: #type proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD) -> Result
ProcCmdBeginPerTileExecutionQCOM                           :: #type proc "system" (commandBuffer: CommandBuffer, pPerTileBeginInfo: ^PerTileBeginInfoQCOM)
ProcCmdBeginQuery                                          :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, flags: QueryControlFlags)
ProcCmdBeginQueryIndexedEXT                                :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, flags: QueryControlFlags, index: u32)
ProcCmdBeginRenderPass                                     :: #type proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, contents: SubpassContents)
ProcCmdBeginRenderPass2                                    :: #type proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, pSubpassBeginInfo: ^SubpassBeginInfo)
ProcCmdBeginRenderPass2KHR                                 :: #type proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, pSubpassBeginInfo: ^SubpassBeginInfo)
ProcCmdBeginRendering                                      :: #type proc "system" (commandBuffer: CommandBuffer, pRenderingInfo: ^RenderingInfo)
ProcCmdBeginRenderingKHR                                   :: #type proc "system" (commandBuffer: CommandBuffer, pRenderingInfo: ^RenderingInfo)
ProcCmdBeginShaderInstrumentationARM                       :: #type proc "system" (commandBuffer: CommandBuffer, instrumentation: ShaderInstrumentationARM)
ProcCmdBeginTransformFeedback2EXT                          :: #type proc "system" (commandBuffer: CommandBuffer, firstCounterRange: u32, counterRangeCount: u32, pCounterInfos: [^]BindTransformFeedbackBuffer2InfoEXT)
ProcCmdBeginTransformFeedbackEXT                           :: #type proc "system" (commandBuffer: CommandBuffer, firstCounterBuffer: u32, counterBufferCount: u32, pCounterBuffers: [^]Buffer, pCounterBufferOffsets: [^]DeviceSize)
ProcCmdBeginVideoCodingKHR                                 :: #type proc "system" (commandBuffer: CommandBuffer, pBeginInfo: ^VideoBeginCodingInfoKHR)
ProcCmdBindDescriptorBufferEmbeddedSamplers2EXT            :: #type proc "system" (commandBuffer: CommandBuffer, pBindDescriptorBufferEmbeddedSamplersInfo: ^BindDescriptorBufferEmbeddedSamplersInfoEXT)
ProcCmdBindDescriptorBufferEmbeddedSamplersEXT             :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32)
ProcCmdBindDescriptorBuffersEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, bufferCount: u32, pBindingInfos: [^]DescriptorBufferBindingInfoEXT)
ProcCmdBindDescriptorSets                                  :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, firstSet: u32, descriptorSetCount: u32, pDescriptorSets: [^]DescriptorSet, dynamicOffsetCount: u32, pDynamicOffsets: [^]u32)
ProcCmdBindDescriptorSets2                                 :: #type proc "system" (commandBuffer: CommandBuffer, pBindDescriptorSetsInfo: ^BindDescriptorSetsInfo)
ProcCmdBindDescriptorSets2KHR                              :: #type proc "system" (commandBuffer: CommandBuffer, pBindDescriptorSetsInfo: ^BindDescriptorSetsInfo)
ProcCmdBindIndexBuffer                                     :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, indexType: IndexType)
ProcCmdBindIndexBuffer2                                    :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, size: DeviceSize, indexType: IndexType)
ProcCmdBindIndexBuffer2KHR                                 :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, size: DeviceSize, indexType: IndexType)
ProcCmdBindIndexBuffer3KHR                                 :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^BindIndexBuffer3InfoKHR)
ProcCmdBindInvocationMaskHUAWEI                            :: #type proc "system" (commandBuffer: CommandBuffer, imageView: ImageView, imageLayout: ImageLayout)
ProcCmdBindPipeline                                        :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline)
ProcCmdBindPipelineShaderGroupNV                           :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline, groupIndex: u32)
ProcCmdBindResourceHeapEXT                                 :: #type proc "system" (commandBuffer: CommandBuffer, pBindInfo: ^BindHeapInfoEXT)
ProcCmdBindSamplerHeapEXT                                  :: #type proc "system" (commandBuffer: CommandBuffer, pBindInfo: ^BindHeapInfoEXT)
ProcCmdBindShadersEXT                                      :: #type proc "system" (commandBuffer: CommandBuffer, stageCount: u32, pStages: [^]ShaderStageFlags, pShaders: [^]ShaderEXT)
ProcCmdBindShadingRateImageNV                              :: #type proc "system" (commandBuffer: CommandBuffer, imageView: ImageView, imageLayout: ImageLayout)
ProcCmdBindTileMemoryQCOM                                  :: #type proc "system" (commandBuffer: CommandBuffer, pTileMemoryBindInfo: ^TileMemoryBindInfoQCOM)
ProcCmdBindTransformFeedbackBuffers2EXT                    :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBindingInfos: [^]BindTransformFeedbackBuffer2InfoEXT)
ProcCmdBindTransformFeedbackBuffersEXT                     :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize)
ProcCmdBindVertexBuffers                                   :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize)
ProcCmdBindVertexBuffers2                                  :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize, pStrides: [^]DeviceSize)
ProcCmdBindVertexBuffers2EXT                               :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize, pStrides: [^]DeviceSize)
ProcCmdBindVertexBuffers3KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBindingInfos: [^]BindVertexBuffer3InfoKHR)
ProcCmdBlitImage                                           :: #type proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageBlit, filter: Filter)
ProcCmdBlitImage2                                          :: #type proc "system" (commandBuffer: CommandBuffer, pBlitImageInfo: ^BlitImageInfo2)
ProcCmdBlitImage2KHR                                       :: #type proc "system" (commandBuffer: CommandBuffer, pBlitImageInfo: ^BlitImageInfo2)
ProcCmdBuildAccelerationStructureNV                        :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^AccelerationStructureInfoNV, instanceData: Buffer, instanceOffset: DeviceSize, update: b32, dst: AccelerationStructureNV, src: AccelerationStructureNV, scratch: Buffer, scratchOffset: DeviceSize)
ProcCmdBuildAccelerationStructuresIndirectKHR              :: #type proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, pIndirectDeviceAddresses: [^]DeviceAddress, pIndirectStrides: [^]u32, ppMaxPrimitiveCounts: ^[^]u32)
ProcCmdBuildAccelerationStructuresKHR                      :: #type proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: ^[^]AccelerationStructureBuildRangeInfoKHR)
ProcCmdBuildClusterAccelerationStructureIndirectNV         :: #type proc "system" (commandBuffer: CommandBuffer, pCommandInfos: [^]ClusterAccelerationStructureCommandsInfoNV)
ProcCmdBuildMicromapsEXT                                   :: #type proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]MicromapBuildInfoEXT)
ProcCmdBuildPartitionedAccelerationStructuresNV            :: #type proc "system" (commandBuffer: CommandBuffer, pBuildInfo: ^BuildPartitionedAccelerationStructureInfoNV)
ProcCmdClearAttachments                                    :: #type proc "system" (commandBuffer: CommandBuffer, attachmentCount: u32, pAttachments: [^]ClearAttachment, rectCount: u32, pRects: [^]ClearRect)
ProcCmdClearColorImage                                     :: #type proc "system" (commandBuffer: CommandBuffer, image: Image, imageLayout: ImageLayout, pColor: ^ClearColorValue, rangeCount: u32, pRanges: [^]ImageSubresourceRange)
ProcCmdClearDepthStencilImage                              :: #type proc "system" (commandBuffer: CommandBuffer, image: Image, imageLayout: ImageLayout, pDepthStencil: ^ClearDepthStencilValue, rangeCount: u32, pRanges: [^]ImageSubresourceRange)
ProcCmdControlVideoCodingKHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pCodingControlInfo: ^VideoCodingControlInfoKHR)
ProcCmdConvertCooperativeVectorMatrixNV                    :: #type proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]ConvertCooperativeVectorMatrixInfoNV)
ProcCmdCopyAccelerationStructureKHR                        :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyAccelerationStructureInfoKHR)
ProcCmdCopyAccelerationStructureNV                         :: #type proc "system" (commandBuffer: CommandBuffer, dst: AccelerationStructureNV, src: AccelerationStructureNV, mode: CopyAccelerationStructureModeKHR)
ProcCmdCopyAccelerationStructureToMemoryKHR                :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyAccelerationStructureToMemoryInfoKHR)
ProcCmdCopyBuffer                                          :: #type proc "system" (commandBuffer: CommandBuffer, srcBuffer: Buffer, dstBuffer: Buffer, regionCount: u32, pRegions: [^]BufferCopy)
ProcCmdCopyBuffer2                                         :: #type proc "system" (commandBuffer: CommandBuffer, pCopyBufferInfo: ^CopyBufferInfo2)
ProcCmdCopyBuffer2KHR                                      :: #type proc "system" (commandBuffer: CommandBuffer, pCopyBufferInfo: ^CopyBufferInfo2)
ProcCmdCopyBufferToImage                                   :: #type proc "system" (commandBuffer: CommandBuffer, srcBuffer: Buffer, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]BufferImageCopy)
ProcCmdCopyBufferToImage2                                  :: #type proc "system" (commandBuffer: CommandBuffer, pCopyBufferToImageInfo: ^CopyBufferToImageInfo2)
ProcCmdCopyBufferToImage2KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pCopyBufferToImageInfo: ^CopyBufferToImageInfo2)
ProcCmdCopyGpaSessionResultsAMD                            :: #type proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD)
ProcCmdCopyImage                                           :: #type proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageCopy)
ProcCmdCopyImage2                                          :: #type proc "system" (commandBuffer: CommandBuffer, pCopyImageInfo: ^CopyImageInfo2)
ProcCmdCopyImage2KHR                                       :: #type proc "system" (commandBuffer: CommandBuffer, pCopyImageInfo: ^CopyImageInfo2)
ProcCmdCopyImageToBuffer                                   :: #type proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstBuffer: Buffer, regionCount: u32, pRegions: [^]BufferImageCopy)
ProcCmdCopyImageToBuffer2                                  :: #type proc "system" (commandBuffer: CommandBuffer, pCopyImageToBufferInfo: ^CopyImageToBufferInfo2)
ProcCmdCopyImageToBuffer2KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pCopyImageToBufferInfo: ^CopyImageToBufferInfo2)
ProcCmdCopyImageToMemoryKHR                                :: #type proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryImageInfoKHR)
ProcCmdCopyMemoryIndirectKHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pCopyMemoryIndirectInfo: ^CopyMemoryIndirectInfoKHR)
ProcCmdCopyMemoryIndirectNV                                :: #type proc "system" (commandBuffer: CommandBuffer, copyBufferAddress: DeviceAddress, copyCount: u32, stride: u32)
ProcCmdCopyMemoryKHR                                       :: #type proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryInfoKHR)
ProcCmdCopyMemoryToAccelerationStructureKHR                :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMemoryToAccelerationStructureInfoKHR)
ProcCmdCopyMemoryToImageIndirectKHR                        :: #type proc "system" (commandBuffer: CommandBuffer, pCopyMemoryToImageIndirectInfo: ^CopyMemoryToImageIndirectInfoKHR)
ProcCmdCopyMemoryToImageIndirectNV                         :: #type proc "system" (commandBuffer: CommandBuffer, copyBufferAddress: DeviceAddress, copyCount: u32, stride: u32, dstImage: Image, dstImageLayout: ImageLayout, pImageSubresources: [^]ImageSubresourceLayers)
ProcCmdCopyMemoryToImageKHR                                :: #type proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryImageInfoKHR)
ProcCmdCopyMemoryToMicromapEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMemoryToMicromapInfoEXT)
ProcCmdCopyMicromapEXT                                     :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMicromapInfoEXT)
ProcCmdCopyMicromapToMemoryEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMicromapToMemoryInfoEXT)
ProcCmdCopyQueryPoolResults                                :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32, dstBuffer: Buffer, dstOffset: DeviceSize, stride: DeviceSize, flags: QueryResultFlags)
ProcCmdCopyQueryPoolResultsToMemoryKHR                     :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32, pDstRange: ^StridedDeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, queryResultFlags: QueryResultFlags)
ProcCmdCopyTensorARM                                       :: #type proc "system" (commandBuffer: CommandBuffer, pCopyTensorInfo: ^CopyTensorInfoARM)
ProcCmdCuLaunchKernelNVX                                   :: #type proc "system" (commandBuffer: CommandBuffer, pLaunchInfo: ^CuLaunchInfoNVX)
ProcCmdCudaLaunchKernelNV                                  :: #type proc "system" (commandBuffer: CommandBuffer, pLaunchInfo: ^CudaLaunchInfoNV)
ProcCmdDebugMarkerBeginEXT                                 :: #type proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^DebugMarkerMarkerInfoEXT)
ProcCmdDebugMarkerEndEXT                                   :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdDebugMarkerInsertEXT                                :: #type proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^DebugMarkerMarkerInfoEXT)
ProcCmdDecodeVideoKHR                                      :: #type proc "system" (commandBuffer: CommandBuffer, pDecodeInfo: ^VideoDecodeInfoKHR)
ProcCmdDecompressMemoryEXT                                 :: #type proc "system" (commandBuffer: CommandBuffer, pDecompressMemoryInfoEXT: ^DecompressMemoryInfoEXT)
ProcCmdDecompressMemoryIndirectCountEXT                    :: #type proc "system" (commandBuffer: CommandBuffer, decompressionMethod: MemoryDecompressionMethodFlagsEXT, indirectCommandsAddress: DeviceAddress, indirectCommandsCountAddress: DeviceAddress, maxDecompressionCount: u32, stride: u32)
ProcCmdDecompressMemoryIndirectCountNV                     :: #type proc "system" (commandBuffer: CommandBuffer, indirectCommandsAddress: DeviceAddress, indirectCommandsCountAddress: DeviceAddress, stride: u32)
ProcCmdDecompressMemoryNV                                  :: #type proc "system" (commandBuffer: CommandBuffer, decompressRegionCount: u32, pDecompressMemoryRegions: [^]DecompressMemoryRegionNV)
ProcCmdDispatch                                            :: #type proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32)
ProcCmdDispatchBase                                        :: #type proc "system" (commandBuffer: CommandBuffer, baseGroupX: u32, baseGroupY: u32, baseGroupZ: u32, groupCountX: u32, groupCountY: u32, groupCountZ: u32)
ProcCmdDispatchBaseKHR                                     :: #type proc "system" (commandBuffer: CommandBuffer, baseGroupX: u32, baseGroupY: u32, baseGroupZ: u32, groupCountX: u32, groupCountY: u32, groupCountZ: u32)
ProcCmdDispatchDataGraphARM                                :: #type proc "system" (commandBuffer: CommandBuffer, session: DataGraphPipelineSessionARM, pInfo: ^DataGraphPipelineDispatchInfoARM)
ProcCmdDispatchGraphAMDX                                   :: #type proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, pCountInfo: ^DispatchGraphCountInfoAMDX)
ProcCmdDispatchGraphIndirectAMDX                           :: #type proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, pCountInfo: ^DispatchGraphCountInfoAMDX)
ProcCmdDispatchGraphIndirectCountAMDX                      :: #type proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, countInfo: DeviceAddress)
ProcCmdDispatchIndirect                                    :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize)
ProcCmdDispatchIndirect2KHR                                :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DispatchIndirect2InfoKHR)
ProcCmdDispatchTileQCOM                                    :: #type proc "system" (commandBuffer: CommandBuffer, pDispatchTileInfo: ^DispatchTileInfoQCOM)
ProcCmdDraw                                                :: #type proc "system" (commandBuffer: CommandBuffer, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32)
ProcCmdDrawClusterHUAWEI                                   :: #type proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32)
ProcCmdDrawClusterIndirectHUAWEI                           :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize)
ProcCmdDrawIndexed                                         :: #type proc "system" (commandBuffer: CommandBuffer, indexCount: u32, instanceCount: u32, firstIndex: u32, vertexOffset: i32, firstInstance: u32)
ProcCmdDrawIndexedIndirect                                 :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32)
ProcCmdDrawIndexedIndirect2KHR                             :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR)
ProcCmdDrawIndexedIndirectCount                            :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawIndexedIndirectCount2KHR                        :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR)
ProcCmdDrawIndexedIndirectCountAMD                         :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawIndexedIndirectCountKHR                         :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawIndirect                                        :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32)
ProcCmdDrawIndirect2KHR                                    :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR)
ProcCmdDrawIndirectByteCount2EXT                           :: #type proc "system" (commandBuffer: CommandBuffer, instanceCount: u32, firstInstance: u32, pCounterInfo: ^BindTransformFeedbackBuffer2InfoEXT, counterOffset: u32, vertexStride: u32)
ProcCmdDrawIndirectByteCountEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, instanceCount: u32, firstInstance: u32, counterBuffer: Buffer, counterBufferOffset: DeviceSize, counterOffset: u32, vertexStride: u32)
ProcCmdDrawIndirectCount                                   :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawIndirectCount2KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR)
ProcCmdDrawIndirectCountAMD                                :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawIndirectCountKHR                                :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawMeshTasksEXT                                    :: #type proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32)
ProcCmdDrawMeshTasksIndirect2EXT                           :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR)
ProcCmdDrawMeshTasksIndirectCount2EXT                      :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR)
ProcCmdDrawMeshTasksIndirectCountEXT                       :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawMeshTasksIndirectCountNV                        :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32)
ProcCmdDrawMeshTasksIndirectEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32)
ProcCmdDrawMeshTasksIndirectNV                             :: #type proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32)
ProcCmdDrawMeshTasksNV                                     :: #type proc "system" (commandBuffer: CommandBuffer, taskCount: u32, firstTask: u32)
ProcCmdDrawMultiEXT                                        :: #type proc "system" (commandBuffer: CommandBuffer, drawCount: u32, pVertexInfo: ^MultiDrawInfoEXT, instanceCount: u32, firstInstance: u32, stride: u32)
ProcCmdDrawMultiIndexedEXT                                 :: #type proc "system" (commandBuffer: CommandBuffer, drawCount: u32, pIndexInfo: ^MultiDrawIndexedInfoEXT, instanceCount: u32, firstInstance: u32, stride: u32, pVertexOffset: ^i32)
ProcCmdEncodeVideoKHR                                      :: #type proc "system" (commandBuffer: CommandBuffer, pEncodeInfo: ^VideoEncodeInfoKHR)
ProcCmdEndConditionalRenderingEXT                          :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndDebugUtilsLabelEXT                               :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndGpaSampleAMD                                     :: #type proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD, sampleID: u32)
ProcCmdEndGpaSessionAMD                                    :: #type proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD) -> Result
ProcCmdEndPerTileExecutionQCOM                             :: #type proc "system" (commandBuffer: CommandBuffer, pPerTileEndInfo: ^PerTileEndInfoQCOM)
ProcCmdEndQuery                                            :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32)
ProcCmdEndQueryIndexedEXT                                  :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, index: u32)
ProcCmdEndRenderPass                                       :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndRenderPass2                                      :: #type proc "system" (commandBuffer: CommandBuffer, pSubpassEndInfo: ^SubpassEndInfo)
ProcCmdEndRenderPass2KHR                                   :: #type proc "system" (commandBuffer: CommandBuffer, pSubpassEndInfo: ^SubpassEndInfo)
ProcCmdEndRendering                                        :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndRendering2EXT                                    :: #type proc "system" (commandBuffer: CommandBuffer, pRenderingEndInfo: ^RenderingEndInfoKHR)
ProcCmdEndRendering2KHR                                    :: #type proc "system" (commandBuffer: CommandBuffer, pRenderingEndInfo: ^RenderingEndInfoKHR)
ProcCmdEndRenderingKHR                                     :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndShaderInstrumentationARM                         :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdEndTransformFeedback2EXT                            :: #type proc "system" (commandBuffer: CommandBuffer, firstCounterRange: u32, counterRangeCount: u32, pCounterInfos: [^]BindTransformFeedbackBuffer2InfoEXT)
ProcCmdEndTransformFeedbackEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, firstCounterBuffer: u32, counterBufferCount: u32, pCounterBuffers: [^]Buffer, pCounterBufferOffsets: [^]DeviceSize)
ProcCmdEndVideoCodingKHR                                   :: #type proc "system" (commandBuffer: CommandBuffer, pEndCodingInfo: ^VideoEndCodingInfoKHR)
ProcCmdExecuteCommands                                     :: #type proc "system" (commandBuffer: CommandBuffer, commandBufferCount: u32, pCommandBuffers: [^]CommandBuffer)
ProcCmdExecuteGeneratedCommandsEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, isPreprocessed: b32, pGeneratedCommandsInfo: ^GeneratedCommandsInfoEXT)
ProcCmdExecuteGeneratedCommandsNV                          :: #type proc "system" (commandBuffer: CommandBuffer, isPreprocessed: b32, pGeneratedCommandsInfo: ^GeneratedCommandsInfoNV)
ProcCmdFillBuffer                                          :: #type proc "system" (commandBuffer: CommandBuffer, dstBuffer: Buffer, dstOffset: DeviceSize, size: DeviceSize, data: u32)
ProcCmdFillMemoryKHR                                       :: #type proc "system" (commandBuffer: CommandBuffer, pDstRange: ^DeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, data: u32)
ProcCmdInitializeGraphScratchMemoryAMDX                    :: #type proc "system" (commandBuffer: CommandBuffer, executionGraph: Pipeline, scratch: DeviceAddress, scratchSize: DeviceSize)
ProcCmdInsertDebugUtilsLabelEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, pLabelInfo: ^DebugUtilsLabelEXT)
ProcCmdNextSubpass                                         :: #type proc "system" (commandBuffer: CommandBuffer, contents: SubpassContents)
ProcCmdNextSubpass2                                        :: #type proc "system" (commandBuffer: CommandBuffer, pSubpassBeginInfo: ^SubpassBeginInfo, pSubpassEndInfo: ^SubpassEndInfo)
ProcCmdNextSubpass2KHR                                     :: #type proc "system" (commandBuffer: CommandBuffer, pSubpassBeginInfo: ^SubpassBeginInfo, pSubpassEndInfo: ^SubpassEndInfo)
ProcCmdOpticalFlowExecuteNV                                :: #type proc "system" (commandBuffer: CommandBuffer, session: OpticalFlowSessionNV, pExecuteInfo: ^OpticalFlowExecuteInfoNV)
ProcCmdPipelineBarrier                                     :: #type proc "system" (commandBuffer: CommandBuffer, srcStageMask: PipelineStageFlags, dstStageMask: PipelineStageFlags, dependencyFlags: DependencyFlags, memoryBarrierCount: u32, pMemoryBarriers: [^]MemoryBarrier, bufferMemoryBarrierCount: u32, pBufferMemoryBarriers: [^]BufferMemoryBarrier, imageMemoryBarrierCount: u32, pImageMemoryBarriers: [^]ImageMemoryBarrier)
ProcCmdPipelineBarrier2                                    :: #type proc "system" (commandBuffer: CommandBuffer, pDependencyInfo: ^DependencyInfo)
ProcCmdPipelineBarrier2KHR                                 :: #type proc "system" (commandBuffer: CommandBuffer, pDependencyInfo: ^DependencyInfo)
ProcCmdPreprocessGeneratedCommandsEXT                      :: #type proc "system" (commandBuffer: CommandBuffer, pGeneratedCommandsInfo: ^GeneratedCommandsInfoEXT, stateCommandBuffer: CommandBuffer)
ProcCmdPreprocessGeneratedCommandsNV                       :: #type proc "system" (commandBuffer: CommandBuffer, pGeneratedCommandsInfo: ^GeneratedCommandsInfoNV)
ProcCmdPushConstants                                       :: #type proc "system" (commandBuffer: CommandBuffer, layout: PipelineLayout, stageFlags: ShaderStageFlags, offset: u32, size: u32, pValues: rawptr)
ProcCmdPushConstants2                                      :: #type proc "system" (commandBuffer: CommandBuffer, pPushConstantsInfo: ^PushConstantsInfo)
ProcCmdPushConstants2KHR                                   :: #type proc "system" (commandBuffer: CommandBuffer, pPushConstantsInfo: ^PushConstantsInfo)
ProcCmdPushDataEXT                                         :: #type proc "system" (commandBuffer: CommandBuffer, pPushDataInfo: ^PushDataInfoEXT)
ProcCmdPushDescriptorSet                                   :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet)
ProcCmdPushDescriptorSet2                                  :: #type proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetInfo: ^PushDescriptorSetInfo)
ProcCmdPushDescriptorSet2KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetInfo: ^PushDescriptorSetInfo)
ProcCmdPushDescriptorSetKHR                                :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet)
ProcCmdPushDescriptorSetWithTemplate                       :: #type proc "system" (commandBuffer: CommandBuffer, descriptorUpdateTemplate: DescriptorUpdateTemplate, layout: PipelineLayout, set: u32, pData: rawptr)
ProcCmdPushDescriptorSetWithTemplate2                      :: #type proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetWithTemplateInfo: ^PushDescriptorSetWithTemplateInfo)
ProcCmdPushDescriptorSetWithTemplate2KHR                   :: #type proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetWithTemplateInfo: ^PushDescriptorSetWithTemplateInfo)
ProcCmdPushDescriptorSetWithTemplateKHR                    :: #type proc "system" (commandBuffer: CommandBuffer, descriptorUpdateTemplate: DescriptorUpdateTemplate, layout: PipelineLayout, set: u32, pData: rawptr)
ProcCmdResetEvent                                          :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags)
ProcCmdResetEvent2                                         :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags2)
ProcCmdResetEvent2KHR                                      :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags2)
ProcCmdResetQueryPool                                      :: #type proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32)
ProcCmdResolveImage                                        :: #type proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageResolve)
ProcCmdResolveImage2                                       :: #type proc "system" (commandBuffer: CommandBuffer, pResolveImageInfo: ^ResolveImageInfo2)
ProcCmdResolveImage2KHR                                    :: #type proc "system" (commandBuffer: CommandBuffer, pResolveImageInfo: ^ResolveImageInfo2)
ProcCmdSetAlphaToCoverageEnableEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, alphaToCoverageEnable: b32)
ProcCmdSetAlphaToOneEnableEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, alphaToOneEnable: b32)
ProcCmdSetAttachmentFeedbackLoopEnableEXT                  :: #type proc "system" (commandBuffer: CommandBuffer, aspectMask: ImageAspectFlags)
ProcCmdSetBlendConstants                                   :: #type proc "system" (commandBuffer: CommandBuffer, blendConstants: ^[4]f32)
ProcCmdSetCheckpointNV                                     :: #type proc "system" (commandBuffer: CommandBuffer, pCheckpointMarker: rawptr)
ProcCmdSetCoarseSampleOrderNV                              :: #type proc "system" (commandBuffer: CommandBuffer, sampleOrderType: CoarseSampleOrderTypeNV, customSampleOrderCount: u32, pCustomSampleOrders: [^]CoarseSampleOrderCustomNV)
ProcCmdSetColorBlendAdvancedEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendAdvanced: ^ColorBlendAdvancedEXT)
ProcCmdSetColorBlendEnableEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendEnables: [^]b32)
ProcCmdSetColorBlendEquationEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendEquations: [^]ColorBlendEquationEXT)
ProcCmdSetColorWriteEnableEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, attachmentCount: u32, pColorWriteEnables: [^]b32)
ProcCmdSetColorWriteMaskEXT                                :: #type proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorWriteMasks: [^]ColorComponentFlags)
ProcCmdSetComputeOccupancyPriorityNV                       :: #type proc "system" (commandBuffer: CommandBuffer, pParameters: [^]ComputeOccupancyPriorityParametersNV)
ProcCmdSetConservativeRasterizationModeEXT                 :: #type proc "system" (commandBuffer: CommandBuffer, conservativeRasterizationMode: ConservativeRasterizationModeEXT)
ProcCmdSetCoverageModulationModeNV                         :: #type proc "system" (commandBuffer: CommandBuffer, coverageModulationMode: CoverageModulationModeNV)
ProcCmdSetCoverageModulationTableEnableNV                  :: #type proc "system" (commandBuffer: CommandBuffer, coverageModulationTableEnable: b32)
ProcCmdSetCoverageModulationTableNV                        :: #type proc "system" (commandBuffer: CommandBuffer, coverageModulationTableCount: u32, pCoverageModulationTable: [^]f32)
ProcCmdSetCoverageReductionModeNV                          :: #type proc "system" (commandBuffer: CommandBuffer, coverageReductionMode: CoverageReductionModeNV)
ProcCmdSetCoverageToColorEnableNV                          :: #type proc "system" (commandBuffer: CommandBuffer, coverageToColorEnable: b32)
ProcCmdSetCoverageToColorLocationNV                        :: #type proc "system" (commandBuffer: CommandBuffer, coverageToColorLocation: u32)
ProcCmdSetCullMode                                         :: #type proc "system" (commandBuffer: CommandBuffer, cullMode: CullModeFlags)
ProcCmdSetCullModeEXT                                      :: #type proc "system" (commandBuffer: CommandBuffer, cullMode: CullModeFlags)
ProcCmdSetDepthBias                                        :: #type proc "system" (commandBuffer: CommandBuffer, depthBiasConstantFactor: f32, depthBiasClamp: f32, depthBiasSlopeFactor: f32)
ProcCmdSetDepthBias2EXT                                    :: #type proc "system" (commandBuffer: CommandBuffer, pDepthBiasInfo: ^DepthBiasInfoEXT)
ProcCmdSetDepthBiasEnable                                  :: #type proc "system" (commandBuffer: CommandBuffer, depthBiasEnable: b32)
ProcCmdSetDepthBiasEnableEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, depthBiasEnable: b32)
ProcCmdSetDepthBounds                                      :: #type proc "system" (commandBuffer: CommandBuffer, minDepthBounds: f32, maxDepthBounds: f32)
ProcCmdSetDepthBoundsTestEnable                            :: #type proc "system" (commandBuffer: CommandBuffer, depthBoundsTestEnable: b32)
ProcCmdSetDepthBoundsTestEnableEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, depthBoundsTestEnable: b32)
ProcCmdSetDepthClampEnableEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, depthClampEnable: b32)
ProcCmdSetDepthClampRangeEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, depthClampMode: DepthClampModeEXT, pDepthClampRange: ^DepthClampRangeEXT)
ProcCmdSetDepthClipEnableEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, depthClipEnable: b32)
ProcCmdSetDepthClipNegativeOneToOneEXT                     :: #type proc "system" (commandBuffer: CommandBuffer, negativeOneToOne: b32)
ProcCmdSetDepthCompareOp                                   :: #type proc "system" (commandBuffer: CommandBuffer, depthCompareOp: CompareOp)
ProcCmdSetDepthCompareOpEXT                                :: #type proc "system" (commandBuffer: CommandBuffer, depthCompareOp: CompareOp)
ProcCmdSetDepthTestEnable                                  :: #type proc "system" (commandBuffer: CommandBuffer, depthTestEnable: b32)
ProcCmdSetDepthTestEnableEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, depthTestEnable: b32)
ProcCmdSetDepthWriteEnable                                 :: #type proc "system" (commandBuffer: CommandBuffer, depthWriteEnable: b32)
ProcCmdSetDepthWriteEnableEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, depthWriteEnable: b32)
ProcCmdSetDescriptorBufferOffsets2EXT                      :: #type proc "system" (commandBuffer: CommandBuffer, pSetDescriptorBufferOffsetsInfo: ^SetDescriptorBufferOffsetsInfoEXT)
ProcCmdSetDescriptorBufferOffsetsEXT                       :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, firstSet: u32, setCount: u32, pBufferIndices: [^]u32, pOffsets: [^]DeviceSize)
ProcCmdSetDeviceMask                                       :: #type proc "system" (commandBuffer: CommandBuffer, deviceMask: u32)
ProcCmdSetDeviceMaskKHR                                    :: #type proc "system" (commandBuffer: CommandBuffer, deviceMask: u32)
ProcCmdSetDiscardRectangleEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, firstDiscardRectangle: u32, discardRectangleCount: u32, pDiscardRectangles: [^]Rect2D)
ProcCmdSetDiscardRectangleEnableEXT                        :: #type proc "system" (commandBuffer: CommandBuffer, discardRectangleEnable: b32)
ProcCmdSetDiscardRectangleModeEXT                          :: #type proc "system" (commandBuffer: CommandBuffer, discardRectangleMode: DiscardRectangleModeEXT)
ProcCmdSetDispatchParametersARM                            :: #type proc "system" (commandBuffer: CommandBuffer, pDispatchParameters: [^]DispatchParametersARM)
ProcCmdSetEvent                                            :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags)
ProcCmdSetEvent2                                           :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, pDependencyInfo: ^DependencyInfo)
ProcCmdSetEvent2KHR                                        :: #type proc "system" (commandBuffer: CommandBuffer, event: Event, pDependencyInfo: ^DependencyInfo)
ProcCmdSetExclusiveScissorEnableNV                         :: #type proc "system" (commandBuffer: CommandBuffer, firstExclusiveScissor: u32, exclusiveScissorCount: u32, pExclusiveScissorEnables: [^]b32)
ProcCmdSetExclusiveScissorNV                               :: #type proc "system" (commandBuffer: CommandBuffer, firstExclusiveScissor: u32, exclusiveScissorCount: u32, pExclusiveScissors: [^]Rect2D)
ProcCmdSetExtraPrimitiveOverestimationSizeEXT              :: #type proc "system" (commandBuffer: CommandBuffer, extraPrimitiveOverestimationSize: f32)
ProcCmdSetFragmentShadingRateEnumNV                        :: #type proc "system" (commandBuffer: CommandBuffer, shadingRate: FragmentShadingRateNV, combinerOps: ^[2]FragmentShadingRateCombinerOpKHR)
ProcCmdSetFragmentShadingRateKHR                           :: #type proc "system" (commandBuffer: CommandBuffer, pFragmentSize: ^Extent2D, combinerOps: ^[2]FragmentShadingRateCombinerOpKHR)
ProcCmdSetFrontFace                                        :: #type proc "system" (commandBuffer: CommandBuffer, frontFace: FrontFace)
ProcCmdSetFrontFaceEXT                                     :: #type proc "system" (commandBuffer: CommandBuffer, frontFace: FrontFace)
ProcCmdSetLineRasterizationModeEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, lineRasterizationMode: LineRasterizationModeEXT)
ProcCmdSetLineStipple                                      :: #type proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16)
ProcCmdSetLineStippleEXT                                   :: #type proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16)
ProcCmdSetLineStippleEnableEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, stippledLineEnable: b32)
ProcCmdSetLineStippleKHR                                   :: #type proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16)
ProcCmdSetLineWidth                                        :: #type proc "system" (commandBuffer: CommandBuffer, lineWidth: f32)
ProcCmdSetLogicOpEXT                                       :: #type proc "system" (commandBuffer: CommandBuffer, logicOp: LogicOp)
ProcCmdSetLogicOpEnableEXT                                 :: #type proc "system" (commandBuffer: CommandBuffer, logicOpEnable: b32)
ProcCmdSetPatchControlPointsEXT                            :: #type proc "system" (commandBuffer: CommandBuffer, patchControlPoints: u32)
ProcCmdSetPerformanceMarkerINTEL                           :: #type proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^PerformanceMarkerInfoINTEL) -> Result
ProcCmdSetPerformanceOverrideINTEL                         :: #type proc "system" (commandBuffer: CommandBuffer, pOverrideInfo: ^PerformanceOverrideInfoINTEL) -> Result
ProcCmdSetPerformanceStreamMarkerINTEL                     :: #type proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^PerformanceStreamMarkerInfoINTEL) -> Result
ProcCmdSetPolygonModeEXT                                   :: #type proc "system" (commandBuffer: CommandBuffer, polygonMode: PolygonMode)
ProcCmdSetPrimitiveRestartEnable                           :: #type proc "system" (commandBuffer: CommandBuffer, primitiveRestartEnable: b32)
ProcCmdSetPrimitiveRestartEnableEXT                        :: #type proc "system" (commandBuffer: CommandBuffer, primitiveRestartEnable: b32)
ProcCmdSetPrimitiveRestartIndexEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, primitiveRestartIndex: u32)
ProcCmdSetPrimitiveTopology                                :: #type proc "system" (commandBuffer: CommandBuffer, primitiveTopology: PrimitiveTopology)
ProcCmdSetPrimitiveTopologyEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, primitiveTopology: PrimitiveTopology)
ProcCmdSetProvokingVertexModeEXT                           :: #type proc "system" (commandBuffer: CommandBuffer, provokingVertexMode: ProvokingVertexModeEXT)
ProcCmdSetRasterizationSamplesEXT                          :: #type proc "system" (commandBuffer: CommandBuffer, rasterizationSamples: SampleCountFlags)
ProcCmdSetRasterizationStreamEXT                           :: #type proc "system" (commandBuffer: CommandBuffer, rasterizationStream: u32)
ProcCmdSetRasterizerDiscardEnable                          :: #type proc "system" (commandBuffer: CommandBuffer, rasterizerDiscardEnable: b32)
ProcCmdSetRasterizerDiscardEnableEXT                       :: #type proc "system" (commandBuffer: CommandBuffer, rasterizerDiscardEnable: b32)
ProcCmdSetRayTracingPipelineStackSizeKHR                   :: #type proc "system" (commandBuffer: CommandBuffer, pipelineStackSize: u32)
ProcCmdSetRenderingAttachmentLocations                     :: #type proc "system" (commandBuffer: CommandBuffer, pLocationInfo: ^RenderingAttachmentLocationInfo)
ProcCmdSetRenderingAttachmentLocationsKHR                  :: #type proc "system" (commandBuffer: CommandBuffer, pLocationInfo: ^RenderingAttachmentLocationInfo)
ProcCmdSetRenderingInputAttachmentIndices                  :: #type proc "system" (commandBuffer: CommandBuffer, pInputAttachmentIndexInfo: ^RenderingInputAttachmentIndexInfo)
ProcCmdSetRenderingInputAttachmentIndicesKHR               :: #type proc "system" (commandBuffer: CommandBuffer, pInputAttachmentIndexInfo: ^RenderingInputAttachmentIndexInfo)
ProcCmdSetRepresentativeFragmentTestEnableNV               :: #type proc "system" (commandBuffer: CommandBuffer, representativeFragmentTestEnable: b32)
ProcCmdSetSampleLocationsEXT                               :: #type proc "system" (commandBuffer: CommandBuffer, pSampleLocationsInfo: ^SampleLocationsInfoEXT)
ProcCmdSetSampleLocationsEnableEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, sampleLocationsEnable: b32)
ProcCmdSetSampleMaskEXT                                    :: #type proc "system" (commandBuffer: CommandBuffer, samples: SampleCountFlags, pSampleMask: ^SampleMask)
ProcCmdSetScissor                                          :: #type proc "system" (commandBuffer: CommandBuffer, firstScissor: u32, scissorCount: u32, pScissors: [^]Rect2D)
ProcCmdSetScissorWithCount                                 :: #type proc "system" (commandBuffer: CommandBuffer, scissorCount: u32, pScissors: [^]Rect2D)
ProcCmdSetScissorWithCountEXT                              :: #type proc "system" (commandBuffer: CommandBuffer, scissorCount: u32, pScissors: [^]Rect2D)
ProcCmdSetShadingRateImageEnableNV                         :: #type proc "system" (commandBuffer: CommandBuffer, shadingRateImageEnable: b32)
ProcCmdSetStencilCompareMask                               :: #type proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, compareMask: u32)
ProcCmdSetStencilOp                                        :: #type proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, failOp: StencilOp, passOp: StencilOp, depthFailOp: StencilOp, compareOp: CompareOp)
ProcCmdSetStencilOpEXT                                     :: #type proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, failOp: StencilOp, passOp: StencilOp, depthFailOp: StencilOp, compareOp: CompareOp)
ProcCmdSetStencilReference                                 :: #type proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, reference: u32)
ProcCmdSetStencilTestEnable                                :: #type proc "system" (commandBuffer: CommandBuffer, stencilTestEnable: b32)
ProcCmdSetStencilTestEnableEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, stencilTestEnable: b32)
ProcCmdSetStencilWriteMask                                 :: #type proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, writeMask: u32)
ProcCmdSetTessellationDomainOriginEXT                      :: #type proc "system" (commandBuffer: CommandBuffer, domainOrigin: TessellationDomainOrigin)
ProcCmdSetVertexInputEXT                                   :: #type proc "system" (commandBuffer: CommandBuffer, vertexBindingDescriptionCount: u32, pVertexBindingDescriptions: [^]VertexInputBindingDescription2EXT, vertexAttributeDescriptionCount: u32, pVertexAttributeDescriptions: [^]VertexInputAttributeDescription2EXT)
ProcCmdSetViewport                                         :: #type proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewports: [^]Viewport)
ProcCmdSetViewportShadingRatePaletteNV                     :: #type proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pShadingRatePalettes: [^]ShadingRatePaletteNV)
ProcCmdSetViewportSwizzleNV                                :: #type proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewportSwizzles: [^]ViewportSwizzleNV)
ProcCmdSetViewportWScalingEnableNV                         :: #type proc "system" (commandBuffer: CommandBuffer, viewportWScalingEnable: b32)
ProcCmdSetViewportWScalingNV                               :: #type proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewportWScalings: [^]ViewportWScalingNV)
ProcCmdSetViewportWithCount                                :: #type proc "system" (commandBuffer: CommandBuffer, viewportCount: u32, pViewports: [^]Viewport)
ProcCmdSetViewportWithCountEXT                             :: #type proc "system" (commandBuffer: CommandBuffer, viewportCount: u32, pViewports: [^]Viewport)
ProcCmdSubpassShadingHUAWEI                                :: #type proc "system" (commandBuffer: CommandBuffer)
ProcCmdTraceRaysIndirect2KHR                               :: #type proc "system" (commandBuffer: CommandBuffer, indirectDeviceAddress: DeviceAddress)
ProcCmdTraceRaysIndirectKHR                                :: #type proc "system" (commandBuffer: CommandBuffer, pRaygenShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pMissShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pHitShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pCallableShaderBindingTable: [^]StridedDeviceAddressRegionKHR, indirectDeviceAddress: DeviceAddress)
ProcCmdTraceRaysKHR                                        :: #type proc "system" (commandBuffer: CommandBuffer, pRaygenShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pMissShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pHitShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pCallableShaderBindingTable: [^]StridedDeviceAddressRegionKHR, width: u32, height: u32, depth: u32)
ProcCmdTraceRaysNV                                         :: #type proc "system" (commandBuffer: CommandBuffer, raygenShaderBindingTableBuffer: Buffer, raygenShaderBindingOffset: DeviceSize, missShaderBindingTableBuffer: Buffer, missShaderBindingOffset: DeviceSize, missShaderBindingStride: DeviceSize, hitShaderBindingTableBuffer: Buffer, hitShaderBindingOffset: DeviceSize, hitShaderBindingStride: DeviceSize, callableShaderBindingTableBuffer: Buffer, callableShaderBindingOffset: DeviceSize, callableShaderBindingStride: DeviceSize, width: u32, height: u32, depth: u32)
ProcCmdUpdateBuffer                                        :: #type proc "system" (commandBuffer: CommandBuffer, dstBuffer: Buffer, dstOffset: DeviceSize, dataSize: DeviceSize, pData: rawptr)
ProcCmdUpdateMemoryKHR                                     :: #type proc "system" (commandBuffer: CommandBuffer, pDstRange: ^DeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, dataSize: DeviceSize, pData: rawptr)
ProcCmdUpdatePipelineIndirectBufferNV                      :: #type proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline)
ProcCmdWaitEvents                                          :: #type proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, srcStageMask: PipelineStageFlags, dstStageMask: PipelineStageFlags, memoryBarrierCount: u32, pMemoryBarriers: [^]MemoryBarrier, bufferMemoryBarrierCount: u32, pBufferMemoryBarriers: [^]BufferMemoryBarrier, imageMemoryBarrierCount: u32, pImageMemoryBarriers: [^]ImageMemoryBarrier)
ProcCmdWaitEvents2                                         :: #type proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, pDependencyInfos: [^]DependencyInfo)
ProcCmdWaitEvents2KHR                                      :: #type proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, pDependencyInfos: [^]DependencyInfo)
ProcCmdWriteAccelerationStructuresPropertiesKHR            :: #type proc "system" (commandBuffer: CommandBuffer, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureKHR, queryType: QueryType, queryPool: QueryPool, firstQuery: u32)
ProcCmdWriteAccelerationStructuresPropertiesNV             :: #type proc "system" (commandBuffer: CommandBuffer, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureNV, queryType: QueryType, queryPool: QueryPool, firstQuery: u32)
ProcCmdWriteBufferMarker2AMD                               :: #type proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, dstBuffer: Buffer, dstOffset: DeviceSize, marker: u32)
ProcCmdWriteBufferMarkerAMD                                :: #type proc "system" (commandBuffer: CommandBuffer, pipelineStage: PipelineStageFlags, dstBuffer: Buffer, dstOffset: DeviceSize, marker: u32)
ProcCmdWriteMarkerToMemoryAMD                              :: #type proc "system" (commandBuffer: CommandBuffer, pInfo: ^MemoryMarkerInfoAMD)
ProcCmdWriteMicromapsPropertiesEXT                         :: #type proc "system" (commandBuffer: CommandBuffer, micromapCount: u32, pMicromaps: [^]MicromapEXT, queryType: QueryType, queryPool: QueryPool, firstQuery: u32)
ProcCmdWriteTimestamp                                      :: #type proc "system" (commandBuffer: CommandBuffer, pipelineStage: PipelineStageFlags, queryPool: QueryPool, query: u32)
ProcCmdWriteTimestamp2                                     :: #type proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, queryPool: QueryPool, query: u32)
ProcCmdWriteTimestamp2KHR                                  :: #type proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, queryPool: QueryPool, query: u32)
ProcCompileDeferredNV                                      :: #type proc "system" (device: Device, pipeline: Pipeline, shader: u32) -> Result
ProcConvertCooperativeVectorMatrixNV                       :: #type proc "system" (device: Device, pInfo: ^ConvertCooperativeVectorMatrixInfoNV) -> Result
ProcCopyAccelerationStructureKHR                           :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyAccelerationStructureInfoKHR) -> Result
ProcCopyAccelerationStructureToMemoryKHR                   :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyAccelerationStructureToMemoryInfoKHR) -> Result
ProcCopyImageToImage                                       :: #type proc "system" (device: Device, pCopyImageToImageInfo: ^CopyImageToImageInfo) -> Result
ProcCopyImageToImageEXT                                    :: #type proc "system" (device: Device, pCopyImageToImageInfo: ^CopyImageToImageInfo) -> Result
ProcCopyImageToMemory                                      :: #type proc "system" (device: Device, pCopyImageToMemoryInfo: ^CopyImageToMemoryInfo) -> Result
ProcCopyImageToMemoryEXT                                   :: #type proc "system" (device: Device, pCopyImageToMemoryInfo: ^CopyImageToMemoryInfo) -> Result
ProcCopyMemoryToAccelerationStructureKHR                   :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMemoryToAccelerationStructureInfoKHR) -> Result
ProcCopyMemoryToImage                                      :: #type proc "system" (device: Device, pCopyMemoryToImageInfo: ^CopyMemoryToImageInfo) -> Result
ProcCopyMemoryToImageEXT                                   :: #type proc "system" (device: Device, pCopyMemoryToImageInfo: ^CopyMemoryToImageInfo) -> Result
ProcCopyMemoryToMicromapEXT                                :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMemoryToMicromapInfoEXT) -> Result
ProcCopyMicromapEXT                                        :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMicromapInfoEXT) -> Result
ProcCopyMicromapToMemoryEXT                                :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMicromapToMemoryInfoEXT) -> Result
ProcCreateAccelerationStructure2KHR                        :: #type proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfo2KHR, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureKHR) -> Result
ProcCreateAccelerationStructureKHR                         :: #type proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfoKHR, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureKHR) -> Result
ProcCreateAccelerationStructureNV                          :: #type proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfoNV, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureNV) -> Result
ProcCreateBuffer                                           :: #type proc "system" (device: Device, pCreateInfo: ^BufferCreateInfo, pAllocator: ^AllocationCallbacks, pBuffer: ^Buffer) -> Result
ProcCreateBufferView                                       :: #type proc "system" (device: Device, pCreateInfo: ^BufferViewCreateInfo, pAllocator: ^AllocationCallbacks, pView: ^BufferView) -> Result
ProcCreateCommandPool                                      :: #type proc "system" (device: Device, pCreateInfo: ^CommandPoolCreateInfo, pAllocator: ^AllocationCallbacks, pCommandPool: ^CommandPool) -> Result
ProcCreateComputePipelines                                 :: #type proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]ComputePipelineCreateInfo, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateCuFunctionNVX                                    :: #type proc "system" (device: Device, pCreateInfo: ^CuFunctionCreateInfoNVX, pAllocator: ^AllocationCallbacks, pFunction: ^CuFunctionNVX) -> Result
ProcCreateCuModuleNVX                                      :: #type proc "system" (device: Device, pCreateInfo: ^CuModuleCreateInfoNVX, pAllocator: ^AllocationCallbacks, pModule: ^CuModuleNVX) -> Result
ProcCreateCudaFunctionNV                                   :: #type proc "system" (device: Device, pCreateInfo: ^CudaFunctionCreateInfoNV, pAllocator: ^AllocationCallbacks, pFunction: ^CudaFunctionNV) -> Result
ProcCreateCudaModuleNV                                     :: #type proc "system" (device: Device, pCreateInfo: ^CudaModuleCreateInfoNV, pAllocator: ^AllocationCallbacks, pModule: ^CudaModuleNV) -> Result
ProcCreateDataGraphPipelineSessionARM                      :: #type proc "system" (device: Device, pCreateInfo: ^DataGraphPipelineSessionCreateInfoARM, pAllocator: ^AllocationCallbacks, pSession: ^DataGraphPipelineSessionARM) -> Result
ProcCreateDataGraphPipelinesARM                            :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]DataGraphPipelineCreateInfoARM, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateDeferredOperationKHR                             :: #type proc "system" (device: Device, pAllocator: ^AllocationCallbacks, pDeferredOperation: ^DeferredOperationKHR) -> Result
ProcCreateDescriptorPool                                   :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorPoolCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorPool: ^DescriptorPool) -> Result
ProcCreateDescriptorSetLayout                              :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pAllocator: ^AllocationCallbacks, pSetLayout: ^DescriptorSetLayout) -> Result
ProcCreateDescriptorUpdateTemplate                         :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorUpdateTemplateCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorUpdateTemplate: ^DescriptorUpdateTemplate) -> Result
ProcCreateDescriptorUpdateTemplateKHR                      :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorUpdateTemplateCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorUpdateTemplate: ^DescriptorUpdateTemplate) -> Result
ProcCreateEvent                                            :: #type proc "system" (device: Device, pCreateInfo: ^EventCreateInfo, pAllocator: ^AllocationCallbacks, pEvent: ^Event) -> Result
ProcCreateExecutionGraphPipelinesAMDX                      :: #type proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]ExecutionGraphPipelineCreateInfoAMDX, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateExternalComputeQueueNV                           :: #type proc "system" (device: Device, pCreateInfo: ^ExternalComputeQueueCreateInfoNV, pAllocator: ^AllocationCallbacks, pExternalQueue: ^ExternalComputeQueueNV) -> Result
ProcCreateFence                                            :: #type proc "system" (device: Device, pCreateInfo: ^FenceCreateInfo, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result
ProcCreateFramebuffer                                      :: #type proc "system" (device: Device, pCreateInfo: ^FramebufferCreateInfo, pAllocator: ^AllocationCallbacks, pFramebuffer: ^Framebuffer) -> Result
ProcCreateGpaSessionAMD                                    :: #type proc "system" (device: Device, pCreateInfo: ^GpaSessionCreateInfoAMD, pAllocator: ^AllocationCallbacks, pGpaSession: ^GpaSessionAMD) -> Result
ProcCreateGraphicsPipelines                                :: #type proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]GraphicsPipelineCreateInfo, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateImage                                            :: #type proc "system" (device: Device, pCreateInfo: ^ImageCreateInfo, pAllocator: ^AllocationCallbacks, pImage: ^Image) -> Result
ProcCreateImageView                                        :: #type proc "system" (device: Device, pCreateInfo: ^ImageViewCreateInfo, pAllocator: ^AllocationCallbacks, pView: ^ImageView) -> Result
ProcCreateIndirectCommandsLayoutEXT                        :: #type proc "system" (device: Device, pCreateInfo: ^IndirectCommandsLayoutCreateInfoEXT, pAllocator: ^AllocationCallbacks, pIndirectCommandsLayout: ^IndirectCommandsLayoutEXT) -> Result
ProcCreateIndirectCommandsLayoutNV                         :: #type proc "system" (device: Device, pCreateInfo: ^IndirectCommandsLayoutCreateInfoNV, pAllocator: ^AllocationCallbacks, pIndirectCommandsLayout: ^IndirectCommandsLayoutNV) -> Result
ProcCreateIndirectExecutionSetEXT                          :: #type proc "system" (device: Device, pCreateInfo: ^IndirectExecutionSetCreateInfoEXT, pAllocator: ^AllocationCallbacks, pIndirectExecutionSet: ^IndirectExecutionSetEXT) -> Result
ProcCreateMicromapEXT                                      :: #type proc "system" (device: Device, pCreateInfo: ^MicromapCreateInfoEXT, pAllocator: ^AllocationCallbacks, pMicromap: ^MicromapEXT) -> Result
ProcCreateOpticalFlowSessionNV                             :: #type proc "system" (device: Device, pCreateInfo: ^OpticalFlowSessionCreateInfoNV, pAllocator: ^AllocationCallbacks, pSession: ^OpticalFlowSessionNV) -> Result
ProcCreatePipelineBinariesKHR                              :: #type proc "system" (device: Device, pCreateInfo: ^PipelineBinaryCreateInfoKHR, pAllocator: ^AllocationCallbacks, pBinaries: [^]PipelineBinaryHandlesInfoKHR) -> Result
ProcCreatePipelineCache                                    :: #type proc "system" (device: Device, pCreateInfo: ^PipelineCacheCreateInfo, pAllocator: ^AllocationCallbacks, pPipelineCache: ^PipelineCache) -> Result
ProcCreatePipelineLayout                                   :: #type proc "system" (device: Device, pCreateInfo: ^PipelineLayoutCreateInfo, pAllocator: ^AllocationCallbacks, pPipelineLayout: ^PipelineLayout) -> Result
ProcCreatePrivateDataSlot                                  :: #type proc "system" (device: Device, pCreateInfo: ^PrivateDataSlotCreateInfo, pAllocator: ^AllocationCallbacks, pPrivateDataSlot: ^PrivateDataSlot) -> Result
ProcCreatePrivateDataSlotEXT                               :: #type proc "system" (device: Device, pCreateInfo: ^PrivateDataSlotCreateInfo, pAllocator: ^AllocationCallbacks, pPrivateDataSlot: ^PrivateDataSlot) -> Result
ProcCreateQueryPool                                        :: #type proc "system" (device: Device, pCreateInfo: ^QueryPoolCreateInfo, pAllocator: ^AllocationCallbacks, pQueryPool: ^QueryPool) -> Result
ProcCreateRayTracingPipelinesKHR                           :: #type proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]RayTracingPipelineCreateInfoKHR, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateRayTracingPipelinesNV                            :: #type proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]RayTracingPipelineCreateInfoNV, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result
ProcCreateRenderPass                                       :: #type proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result
ProcCreateRenderPass2                                      :: #type proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo2, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result
ProcCreateRenderPass2KHR                                   :: #type proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo2, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result
ProcCreateSampler                                          :: #type proc "system" (device: Device, pCreateInfo: ^SamplerCreateInfo, pAllocator: ^AllocationCallbacks, pSampler: ^Sampler) -> Result
ProcCreateSamplerYcbcrConversion                           :: #type proc "system" (device: Device, pCreateInfo: ^SamplerYcbcrConversionCreateInfo, pAllocator: ^AllocationCallbacks, pYcbcrConversion: ^SamplerYcbcrConversion) -> Result
ProcCreateSamplerYcbcrConversionKHR                        :: #type proc "system" (device: Device, pCreateInfo: ^SamplerYcbcrConversionCreateInfo, pAllocator: ^AllocationCallbacks, pYcbcrConversion: ^SamplerYcbcrConversion) -> Result
ProcCreateSemaphore                                        :: #type proc "system" (device: Device, pCreateInfo: ^SemaphoreCreateInfo, pAllocator: ^AllocationCallbacks, pSemaphore: ^Semaphore) -> Result
ProcCreateShaderInstrumentationARM                         :: #type proc "system" (device: Device, pCreateInfo: ^ShaderInstrumentationCreateInfoARM, pAllocator: ^AllocationCallbacks, pInstrumentation: ^ShaderInstrumentationARM) -> Result
ProcCreateShaderModule                                     :: #type proc "system" (device: Device, pCreateInfo: ^ShaderModuleCreateInfo, pAllocator: ^AllocationCallbacks, pShaderModule: ^ShaderModule) -> Result
ProcCreateShadersEXT                                       :: #type proc "system" (device: Device, createInfoCount: u32, pCreateInfos: [^]ShaderCreateInfoEXT, pAllocator: ^AllocationCallbacks, pShaders: [^]ShaderEXT) -> Result
ProcCreateSharedSwapchainsKHR                              :: #type proc "system" (device: Device, swapchainCount: u32, pCreateInfos: [^]SwapchainCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSwapchains: [^]SwapchainKHR) -> Result
ProcCreateSwapchainKHR                                     :: #type proc "system" (device: Device, pCreateInfo: ^SwapchainCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSwapchain: ^SwapchainKHR) -> Result
ProcCreateTensorARM                                        :: #type proc "system" (device: Device, pCreateInfo: ^TensorCreateInfoARM, pAllocator: ^AllocationCallbacks, pTensor: ^TensorARM) -> Result
ProcCreateTensorViewARM                                    :: #type proc "system" (device: Device, pCreateInfo: ^TensorViewCreateInfoARM, pAllocator: ^AllocationCallbacks, pView: ^TensorViewARM) -> Result
ProcCreateValidationCacheEXT                               :: #type proc "system" (device: Device, pCreateInfo: ^ValidationCacheCreateInfoEXT, pAllocator: ^AllocationCallbacks, pValidationCache: ^ValidationCacheEXT) -> Result
ProcCreateVideoSessionKHR                                  :: #type proc "system" (device: Device, pCreateInfo: ^VideoSessionCreateInfoKHR, pAllocator: ^AllocationCallbacks, pVideoSession: ^VideoSessionKHR) -> Result
ProcCreateVideoSessionParametersKHR                        :: #type proc "system" (device: Device, pCreateInfo: ^VideoSessionParametersCreateInfoKHR, pAllocator: ^AllocationCallbacks, pVideoSessionParameters: [^]VideoSessionParametersKHR) -> Result
ProcDebugMarkerSetObjectNameEXT                            :: #type proc "system" (device: Device, pNameInfo: ^DebugMarkerObjectNameInfoEXT) -> Result
ProcDebugMarkerSetObjectTagEXT                             :: #type proc "system" (device: Device, pTagInfo: ^DebugMarkerObjectTagInfoEXT) -> Result
ProcDeferredOperationJoinKHR                               :: #type proc "system" (device: Device, operation: DeferredOperationKHR) -> Result
ProcDestroyAccelerationStructureKHR                        :: #type proc "system" (device: Device, accelerationStructure: AccelerationStructureKHR, pAllocator: ^AllocationCallbacks)
ProcDestroyAccelerationStructureNV                         :: #type proc "system" (device: Device, accelerationStructure: AccelerationStructureNV, pAllocator: ^AllocationCallbacks)
ProcDestroyBuffer                                          :: #type proc "system" (device: Device, buffer: Buffer, pAllocator: ^AllocationCallbacks)
ProcDestroyBufferView                                      :: #type proc "system" (device: Device, bufferView: BufferView, pAllocator: ^AllocationCallbacks)
ProcDestroyCommandPool                                     :: #type proc "system" (device: Device, commandPool: CommandPool, pAllocator: ^AllocationCallbacks)
ProcDestroyCuFunctionNVX                                   :: #type proc "system" (device: Device, function: CuFunctionNVX, pAllocator: ^AllocationCallbacks)
ProcDestroyCuModuleNVX                                     :: #type proc "system" (device: Device, module: CuModuleNVX, pAllocator: ^AllocationCallbacks)
ProcDestroyCudaFunctionNV                                  :: #type proc "system" (device: Device, function: CudaFunctionNV, pAllocator: ^AllocationCallbacks)
ProcDestroyCudaModuleNV                                    :: #type proc "system" (device: Device, module: CudaModuleNV, pAllocator: ^AllocationCallbacks)
ProcDestroyDataGraphPipelineSessionARM                     :: #type proc "system" (device: Device, session: DataGraphPipelineSessionARM, pAllocator: ^AllocationCallbacks)
ProcDestroyDeferredOperationKHR                            :: #type proc "system" (device: Device, operation: DeferredOperationKHR, pAllocator: ^AllocationCallbacks)
ProcDestroyDescriptorPool                                  :: #type proc "system" (device: Device, descriptorPool: DescriptorPool, pAllocator: ^AllocationCallbacks)
ProcDestroyDescriptorSetLayout                             :: #type proc "system" (device: Device, descriptorSetLayout: DescriptorSetLayout, pAllocator: ^AllocationCallbacks)
ProcDestroyDescriptorUpdateTemplate                        :: #type proc "system" (device: Device, descriptorUpdateTemplate: DescriptorUpdateTemplate, pAllocator: ^AllocationCallbacks)
ProcDestroyDescriptorUpdateTemplateKHR                     :: #type proc "system" (device: Device, descriptorUpdateTemplate: DescriptorUpdateTemplate, pAllocator: ^AllocationCallbacks)
ProcDestroyDevice                                          :: #type proc "system" (device: Device, pAllocator: ^AllocationCallbacks)
ProcDestroyEvent                                           :: #type proc "system" (device: Device, event: Event, pAllocator: ^AllocationCallbacks)
ProcDestroyExternalComputeQueueNV                          :: #type proc "system" (device: Device, externalQueue: ExternalComputeQueueNV, pAllocator: ^AllocationCallbacks)
ProcDestroyFence                                           :: #type proc "system" (device: Device, fence: Fence, pAllocator: ^AllocationCallbacks)
ProcDestroyFramebuffer                                     :: #type proc "system" (device: Device, framebuffer: Framebuffer, pAllocator: ^AllocationCallbacks)
ProcDestroyGpaSessionAMD                                   :: #type proc "system" (device: Device, gpaSession: GpaSessionAMD, pAllocator: ^AllocationCallbacks)
ProcDestroyImage                                           :: #type proc "system" (device: Device, image: Image, pAllocator: ^AllocationCallbacks)
ProcDestroyImageView                                       :: #type proc "system" (device: Device, imageView: ImageView, pAllocator: ^AllocationCallbacks)
ProcDestroyIndirectCommandsLayoutEXT                       :: #type proc "system" (device: Device, indirectCommandsLayout: IndirectCommandsLayoutEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyIndirectCommandsLayoutNV                        :: #type proc "system" (device: Device, indirectCommandsLayout: IndirectCommandsLayoutNV, pAllocator: ^AllocationCallbacks)
ProcDestroyIndirectExecutionSetEXT                         :: #type proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyMicromapEXT                                     :: #type proc "system" (device: Device, micromap: MicromapEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyOpticalFlowSessionNV                            :: #type proc "system" (device: Device, session: OpticalFlowSessionNV, pAllocator: ^AllocationCallbacks)
ProcDestroyPipeline                                        :: #type proc "system" (device: Device, pipeline: Pipeline, pAllocator: ^AllocationCallbacks)
ProcDestroyPipelineBinaryKHR                               :: #type proc "system" (device: Device, pipelineBinary: PipelineBinaryKHR, pAllocator: ^AllocationCallbacks)
ProcDestroyPipelineCache                                   :: #type proc "system" (device: Device, pipelineCache: PipelineCache, pAllocator: ^AllocationCallbacks)
ProcDestroyPipelineLayout                                  :: #type proc "system" (device: Device, pipelineLayout: PipelineLayout, pAllocator: ^AllocationCallbacks)
ProcDestroyPrivateDataSlot                                 :: #type proc "system" (device: Device, privateDataSlot: PrivateDataSlot, pAllocator: ^AllocationCallbacks)
ProcDestroyPrivateDataSlotEXT                              :: #type proc "system" (device: Device, privateDataSlot: PrivateDataSlot, pAllocator: ^AllocationCallbacks)
ProcDestroyQueryPool                                       :: #type proc "system" (device: Device, queryPool: QueryPool, pAllocator: ^AllocationCallbacks)
ProcDestroyRenderPass                                      :: #type proc "system" (device: Device, renderPass: RenderPass, pAllocator: ^AllocationCallbacks)
ProcDestroySampler                                         :: #type proc "system" (device: Device, sampler: Sampler, pAllocator: ^AllocationCallbacks)
ProcDestroySamplerYcbcrConversion                          :: #type proc "system" (device: Device, ycbcrConversion: SamplerYcbcrConversion, pAllocator: ^AllocationCallbacks)
ProcDestroySamplerYcbcrConversionKHR                       :: #type proc "system" (device: Device, ycbcrConversion: SamplerYcbcrConversion, pAllocator: ^AllocationCallbacks)
ProcDestroySemaphore                                       :: #type proc "system" (device: Device, semaphore: Semaphore, pAllocator: ^AllocationCallbacks)
ProcDestroyShaderEXT                                       :: #type proc "system" (device: Device, shader: ShaderEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyShaderInstrumentationARM                        :: #type proc "system" (device: Device, instrumentation: ShaderInstrumentationARM, pAllocator: ^AllocationCallbacks)
ProcDestroyShaderModule                                    :: #type proc "system" (device: Device, shaderModule: ShaderModule, pAllocator: ^AllocationCallbacks)
ProcDestroySwapchainKHR                                    :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pAllocator: ^AllocationCallbacks)
ProcDestroyTensorARM                                       :: #type proc "system" (device: Device, tensor: TensorARM, pAllocator: ^AllocationCallbacks)
ProcDestroyTensorViewARM                                   :: #type proc "system" (device: Device, tensorView: TensorViewARM, pAllocator: ^AllocationCallbacks)
ProcDestroyValidationCacheEXT                              :: #type proc "system" (device: Device, validationCache: ValidationCacheEXT, pAllocator: ^AllocationCallbacks)
ProcDestroyVideoSessionKHR                                 :: #type proc "system" (device: Device, videoSession: VideoSessionKHR, pAllocator: ^AllocationCallbacks)
ProcDestroyVideoSessionParametersKHR                       :: #type proc "system" (device: Device, videoSessionParameters: VideoSessionParametersKHR, pAllocator: ^AllocationCallbacks)
ProcDeviceWaitIdle                                         :: #type proc "system" (device: Device) -> Result
ProcDisplayPowerControlEXT                                 :: #type proc "system" (device: Device, display: DisplayKHR, pDisplayPowerInfo: ^DisplayPowerInfoEXT) -> Result
ProcEndCommandBuffer                                       :: #type proc "system" (commandBuffer: CommandBuffer) -> Result
ProcExportMetalObjectsEXT                                  :: #type proc "system" (device: Device, pMetalObjectsInfo: ^ExportMetalObjectsInfoEXT)
ProcFlushMappedMemoryRanges                                :: #type proc "system" (device: Device, memoryRangeCount: u32, pMemoryRanges: [^]MappedMemoryRange) -> Result
ProcFreeCommandBuffers                                     :: #type proc "system" (device: Device, commandPool: CommandPool, commandBufferCount: u32, pCommandBuffers: [^]CommandBuffer)
ProcFreeDescriptorSets                                     :: #type proc "system" (device: Device, descriptorPool: DescriptorPool, descriptorSetCount: u32, pDescriptorSets: [^]DescriptorSet) -> Result
ProcFreeMemory                                             :: #type proc "system" (device: Device, memory: DeviceMemory, pAllocator: ^AllocationCallbacks)
ProcGetAccelerationStructureBuildSizesKHR                  :: #type proc "system" (device: Device, buildType: AccelerationStructureBuildTypeKHR, pBuildInfo: ^AccelerationStructureBuildGeometryInfoKHR, pMaxPrimitiveCounts: [^]u32, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR)
ProcGetAccelerationStructureDeviceAddressKHR               :: #type proc "system" (device: Device, pInfo: ^AccelerationStructureDeviceAddressInfoKHR) -> DeviceAddress
ProcGetAccelerationStructureHandleNV                       :: #type proc "system" (device: Device, accelerationStructure: AccelerationStructureNV, dataSize: int, pData: rawptr) -> Result
ProcGetAccelerationStructureMemoryRequirementsNV           :: #type proc "system" (device: Device, pInfo: ^AccelerationStructureMemoryRequirementsInfoNV, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetAccelerationStructureOpaqueCaptureDescriptorDataEXT :: #type proc "system" (device: Device, pInfo: ^AccelerationStructureCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result
ProcGetAndroidHardwareBufferPropertiesANDROID              :: #type proc "system" (device: Device, buffer: ^AHardwareBuffer, pProperties: [^]AndroidHardwareBufferPropertiesANDROID) -> Result
ProcGetBufferDeviceAddress                                 :: #type proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress
ProcGetBufferDeviceAddressEXT                              :: #type proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress
ProcGetBufferDeviceAddressKHR                              :: #type proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress
ProcGetBufferMemoryRequirements                            :: #type proc "system" (device: Device, buffer: Buffer, pMemoryRequirements: [^]MemoryRequirements)
ProcGetBufferMemoryRequirements2                           :: #type proc "system" (device: Device, pInfo: ^BufferMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetBufferMemoryRequirements2KHR                        :: #type proc "system" (device: Device, pInfo: ^BufferMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetBufferOpaqueCaptureAddress                          :: #type proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> u64
ProcGetBufferOpaqueCaptureAddressKHR                       :: #type proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> u64
ProcGetBufferOpaqueCaptureDescriptorDataEXT                :: #type proc "system" (device: Device, pInfo: ^BufferCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result
ProcGetCalibratedTimestampsEXT                             :: #type proc "system" (device: Device, timestampCount: u32, pTimestampInfos: [^]CalibratedTimestampInfoKHR, pTimestamps: [^]u64, pMaxDeviation: ^u64) -> Result
ProcGetCalibratedTimestampsKHR                             :: #type proc "system" (device: Device, timestampCount: u32, pTimestampInfos: [^]CalibratedTimestampInfoKHR, pTimestamps: [^]u64, pMaxDeviation: ^u64) -> Result
ProcGetClusterAccelerationStructureBuildSizesNV            :: #type proc "system" (device: Device, pInfo: ^ClusterAccelerationStructureInputInfoNV, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR)
ProcGetCudaModuleCacheNV                                   :: #type proc "system" (device: Device, module: CudaModuleNV, pCacheSize: ^int, pCacheData: rawptr) -> Result
ProcGetDataGraphPipelineAvailablePropertiesARM             :: #type proc "system" (device: Device, pPipelineInfo: ^DataGraphPipelineInfoARM, pPropertiesCount: ^u32, pProperties: [^]DataGraphPipelinePropertyARM) -> Result
ProcGetDataGraphPipelinePropertiesARM                      :: #type proc "system" (device: Device, pPipelineInfo: ^DataGraphPipelineInfoARM, propertiesCount: u32, pProperties: [^]DataGraphPipelinePropertyQueryResultARM) -> Result
ProcGetDataGraphPipelineSessionBindPointRequirementsARM    :: #type proc "system" (device: Device, pInfo: ^DataGraphPipelineSessionBindPointRequirementsInfoARM, pBindPointRequirementCount: ^u32, pBindPointRequirements: [^]DataGraphPipelineSessionBindPointRequirementARM) -> Result
ProcGetDataGraphPipelineSessionMemoryRequirementsARM       :: #type proc "system" (device: Device, pInfo: ^DataGraphPipelineSessionMemoryRequirementsInfoARM, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDeferredOperationMaxConcurrencyKHR                  :: #type proc "system" (device: Device, operation: DeferredOperationKHR) -> u32
ProcGetDeferredOperationResultKHR                          :: #type proc "system" (device: Device, operation: DeferredOperationKHR) -> Result
ProcGetDescriptorEXT                                       :: #type proc "system" (device: Device, pDescriptorInfo: ^DescriptorGetInfoEXT, dataSize: int, pDescriptor: rawptr)
ProcGetDescriptorSetHostMappingVALVE                       :: #type proc "system" (device: Device, descriptorSet: DescriptorSet, ppData: ^rawptr)
ProcGetDescriptorSetLayoutBindingOffsetEXT                 :: #type proc "system" (device: Device, layout: DescriptorSetLayout, binding: u32, pOffset: ^DeviceSize)
ProcGetDescriptorSetLayoutHostMappingInfoVALVE             :: #type proc "system" (device: Device, pBindingReference: ^DescriptorSetBindingReferenceVALVE, pHostMapping: ^DescriptorSetLayoutHostMappingInfoVALVE)
ProcGetDescriptorSetLayoutSizeEXT                          :: #type proc "system" (device: Device, layout: DescriptorSetLayout, pLayoutSizeInBytes: [^]DeviceSize)
ProcGetDescriptorSetLayoutSupport                          :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pSupport: ^DescriptorSetLayoutSupport)
ProcGetDescriptorSetLayoutSupportKHR                       :: #type proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pSupport: ^DescriptorSetLayoutSupport)
ProcGetDeviceAccelerationStructureCompatibilityKHR         :: #type proc "system" (device: Device, pVersionInfo: ^AccelerationStructureVersionInfoKHR, pCompatibility: ^AccelerationStructureCompatibilityKHR)
ProcGetDeviceBufferMemoryRequirements                      :: #type proc "system" (device: Device, pInfo: ^DeviceBufferMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDeviceBufferMemoryRequirementsKHR                   :: #type proc "system" (device: Device, pInfo: ^DeviceBufferMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDeviceCombinedImageSamplerIndexNVX                  :: #type proc "system" (device: Device, imageViewIndex: u64, samplerIndex: u64) -> u64
ProcGetDeviceFaultDebugInfoKHR                             :: #type proc "system" (device: Device, pDebugInfo: ^DeviceFaultDebugInfoKHR) -> Result
ProcGetDeviceFaultInfoEXT                                  :: #type proc "system" (device: Device, pFaultCounts: [^]DeviceFaultCountsEXT, pFaultInfo: ^DeviceFaultInfoEXT) -> Result
ProcGetDeviceFaultReportsKHR                               :: #type proc "system" (device: Device, timeout: u64, pFaultCounts: [^]u32, pFaultInfo: ^DeviceFaultInfoKHR) -> Result
ProcGetDeviceGroupPeerMemoryFeatures                       :: #type proc "system" (device: Device, heapIndex: u32, localDeviceIndex: u32, remoteDeviceIndex: u32, pPeerMemoryFeatures: [^]PeerMemoryFeatureFlags)
ProcGetDeviceGroupPeerMemoryFeaturesKHR                    :: #type proc "system" (device: Device, heapIndex: u32, localDeviceIndex: u32, remoteDeviceIndex: u32, pPeerMemoryFeatures: [^]PeerMemoryFeatureFlags)
ProcGetDeviceGroupPresentCapabilitiesKHR                   :: #type proc "system" (device: Device, pDeviceGroupPresentCapabilities: [^]DeviceGroupPresentCapabilitiesKHR) -> Result
ProcGetDeviceGroupSurfacePresentModes2EXT                  :: #type proc "system" (device: Device, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pModes: [^]DeviceGroupPresentModeFlagsKHR) -> Result
ProcGetDeviceGroupSurfacePresentModesKHR                   :: #type proc "system" (device: Device, surface: SurfaceKHR, pModes: [^]DeviceGroupPresentModeFlagsKHR) -> Result
ProcGetDeviceImageMemoryRequirements                       :: #type proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDeviceImageMemoryRequirementsKHR                    :: #type proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDeviceImageSparseMemoryRequirements                 :: #type proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2)
ProcGetDeviceImageSparseMemoryRequirementsKHR              :: #type proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2)
ProcGetDeviceImageSubresourceLayout                        :: #type proc "system" (device: Device, pInfo: ^DeviceImageSubresourceInfo, pLayout: ^SubresourceLayout2)
ProcGetDeviceImageSubresourceLayoutKHR                     :: #type proc "system" (device: Device, pInfo: ^DeviceImageSubresourceInfo, pLayout: ^SubresourceLayout2)
ProcGetDeviceMemoryCommitment                              :: #type proc "system" (device: Device, memory: DeviceMemory, pCommittedMemoryInBytes: [^]DeviceSize)
ProcGetDeviceMemoryOpaqueCaptureAddress                    :: #type proc "system" (device: Device, pInfo: ^DeviceMemoryOpaqueCaptureAddressInfo) -> u64
ProcGetDeviceMemoryOpaqueCaptureAddressKHR                 :: #type proc "system" (device: Device, pInfo: ^DeviceMemoryOpaqueCaptureAddressInfo) -> u64
ProcGetDeviceMicromapCompatibilityEXT                      :: #type proc "system" (device: Device, pVersionInfo: ^MicromapVersionInfoEXT, pCompatibility: ^AccelerationStructureCompatibilityKHR)
ProcGetDeviceProcAddr                                      :: #type proc "system" (device: Device, pName: cstring) -> ProcVoidFunction
ProcGetDeviceQueue                                         :: #type proc "system" (device: Device, queueFamilyIndex: u32, queueIndex: u32, pQueue: ^Queue)
ProcGetDeviceQueue2                                        :: #type proc "system" (device: Device, pQueueInfo: ^DeviceQueueInfo2, pQueue: ^Queue)
ProcGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI          :: #type proc "system" (device: Device, renderpass: RenderPass, pMaxWorkgroupSize: ^Extent2D) -> Result
ProcGetDeviceTensorMemoryRequirementsARM                   :: #type proc "system" (device: Device, pInfo: ^DeviceTensorMemoryRequirementsARM, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetDynamicRenderingTilePropertiesQCOM                  :: #type proc "system" (device: Device, pRenderingInfo: ^RenderingInfo, pProperties: [^]TilePropertiesQCOM) -> Result
ProcGetEncodedVideoSessionParametersKHR                    :: #type proc "system" (device: Device, pVideoSessionParametersInfo: ^VideoEncodeSessionParametersGetInfoKHR, pFeedbackInfo: ^VideoEncodeSessionParametersFeedbackInfoKHR, pDataSize: ^int, pData: rawptr) -> Result
ProcGetEventStatus                                         :: #type proc "system" (device: Device, event: Event) -> Result
ProcGetExecutionGraphPipelineNodeIndexAMDX                 :: #type proc "system" (device: Device, executionGraph: Pipeline, pNodeInfo: ^PipelineShaderStageNodeCreateInfoAMDX, pNodeIndex: ^u32) -> Result
ProcGetExecutionGraphPipelineScratchSizeAMDX               :: #type proc "system" (device: Device, executionGraph: Pipeline, pSizeInfo: ^ExecutionGraphPipelineScratchSizeAMDX) -> Result
ProcGetFenceFdKHR                                          :: #type proc "system" (device: Device, pGetFdInfo: ^FenceGetFdInfoKHR, pFd: ^c.int) -> Result
ProcGetFenceStatus                                         :: #type proc "system" (device: Device, fence: Fence) -> Result
ProcGetFenceWin32HandleKHR                                 :: #type proc "system" (device: Device, pGetWin32HandleInfo: ^FenceGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result
ProcGetFramebufferTilePropertiesQCOM                       :: #type proc "system" (device: Device, framebuffer: Framebuffer, pPropertiesCount: ^u32, pProperties: [^]TilePropertiesQCOM) -> Result
ProcGetGeneratedCommandsMemoryRequirementsEXT              :: #type proc "system" (device: Device, pInfo: ^GeneratedCommandsMemoryRequirementsInfoEXT, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetGeneratedCommandsMemoryRequirementsNV               :: #type proc "system" (device: Device, pInfo: ^GeneratedCommandsMemoryRequirementsInfoNV, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetGpaDeviceClockInfoAMD                               :: #type proc "system" (device: Device, pInfo: ^GpaDeviceGetClockInfoAMD) -> Result
ProcGetGpaSessionResultsAMD                                :: #type proc "system" (device: Device, gpaSession: GpaSessionAMD, sampleID: u32, pSizeInBytes: [^]int, pData: rawptr) -> Result
ProcGetGpaSessionStatusAMD                                 :: #type proc "system" (device: Device, gpaSession: GpaSessionAMD) -> Result
ProcGetImageDrmFormatModifierPropertiesEXT                 :: #type proc "system" (device: Device, image: Image, pProperties: [^]ImageDrmFormatModifierPropertiesEXT) -> Result
ProcGetImageMemoryRequirements                             :: #type proc "system" (device: Device, image: Image, pMemoryRequirements: [^]MemoryRequirements)
ProcGetImageMemoryRequirements2                            :: #type proc "system" (device: Device, pInfo: ^ImageMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetImageMemoryRequirements2KHR                         :: #type proc "system" (device: Device, pInfo: ^ImageMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetImageOpaqueCaptureDataEXT                           :: #type proc "system" (device: Device, imageCount: u32, pImages: [^]Image, pDatas: [^]HostAddressRangeEXT) -> Result
ProcGetImageOpaqueCaptureDescriptorDataEXT                 :: #type proc "system" (device: Device, pInfo: ^ImageCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result
ProcGetImageSparseMemoryRequirements                       :: #type proc "system" (device: Device, image: Image, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements)
ProcGetImageSparseMemoryRequirements2                      :: #type proc "system" (device: Device, pInfo: ^ImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2)
ProcGetImageSparseMemoryRequirements2KHR                   :: #type proc "system" (device: Device, pInfo: ^ImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2)
ProcGetImageSubresourceLayout                              :: #type proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource, pLayout: ^SubresourceLayout)
ProcGetImageSubresourceLayout2                             :: #type proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2)
ProcGetImageSubresourceLayout2EXT                          :: #type proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2)
ProcGetImageSubresourceLayout2KHR                          :: #type proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2)
ProcGetImageViewAddressNVX                                 :: #type proc "system" (device: Device, imageView: ImageView, pProperties: [^]ImageViewAddressPropertiesNVX) -> Result
ProcGetImageViewHandle64NVX                                :: #type proc "system" (device: Device, pInfo: ^ImageViewHandleInfoNVX) -> u64
ProcGetImageViewHandleNVX                                  :: #type proc "system" (device: Device, pInfo: ^ImageViewHandleInfoNVX) -> u32
ProcGetImageViewOpaqueCaptureDescriptorDataEXT             :: #type proc "system" (device: Device, pInfo: ^ImageViewCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result
ProcGetLatencyTimingsNV                                    :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pLatencyMarkerInfo: ^GetLatencyMarkerInfoNV)
ProcGetMemoryAndroidHardwareBufferANDROID                  :: #type proc "system" (device: Device, pInfo: ^MemoryGetAndroidHardwareBufferInfoANDROID, pBuffer: ^^AHardwareBuffer) -> Result
ProcGetMemoryFdKHR                                         :: #type proc "system" (device: Device, pGetFdInfo: ^MemoryGetFdInfoKHR, pFd: ^c.int) -> Result
ProcGetMemoryFdPropertiesKHR                               :: #type proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, fd: c.int, pMemoryFdProperties: [^]MemoryFdPropertiesKHR) -> Result
ProcGetMemoryHostPointerPropertiesEXT                      :: #type proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, pHostPointer: rawptr, pMemoryHostPointerProperties: [^]MemoryHostPointerPropertiesEXT) -> Result
ProcGetMemoryMetalHandleEXT                                :: #type proc "system" (device: Device, pGetMetalHandleInfo: ^MemoryGetMetalHandleInfoEXT, pHandle: ^rawptr) -> Result
ProcGetMemoryMetalHandlePropertiesEXT                      :: #type proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, pHandle: rawptr, pMemoryMetalHandleProperties: [^]MemoryMetalHandlePropertiesEXT) -> Result
ProcGetMemoryRemoteAddressNV                               :: #type proc "system" (device: Device, pMemoryGetRemoteAddressInfo: ^MemoryGetRemoteAddressInfoNV, pAddress: [^]RemoteAddressNV) -> Result
ProcGetMemoryWin32HandleKHR                                :: #type proc "system" (device: Device, pGetWin32HandleInfo: ^MemoryGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result
ProcGetMemoryWin32HandleNV                                 :: #type proc "system" (device: Device, memory: DeviceMemory, handleType: ExternalMemoryHandleTypeFlagsNV, pHandle: ^HANDLE) -> Result
ProcGetMemoryWin32HandlePropertiesKHR                      :: #type proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, handle: HANDLE, pMemoryWin32HandleProperties: [^]MemoryWin32HandlePropertiesKHR) -> Result
ProcGetMicromapBuildSizesEXT                               :: #type proc "system" (device: Device, buildType: AccelerationStructureBuildTypeKHR, pBuildInfo: ^MicromapBuildInfoEXT, pSizeInfo: ^MicromapBuildSizesInfoEXT)
ProcGetPartitionedAccelerationStructuresBuildSizesNV       :: #type proc "system" (device: Device, pInfo: ^PartitionedAccelerationStructureInstancesInputNV, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR)
ProcGetPastPresentationTimingEXT                           :: #type proc "system" (device: Device, pPastPresentationTimingInfo: ^PastPresentationTimingInfoEXT, pPastPresentationTimingProperties: [^]PastPresentationTimingPropertiesEXT) -> Result
ProcGetPastPresentationTimingGOOGLE                        :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pPresentationTimingCount: ^u32, pPresentationTimings: [^]PastPresentationTimingGOOGLE) -> Result
ProcGetPerformanceParameterINTEL                           :: #type proc "system" (device: Device, parameter: PerformanceParameterTypeINTEL, pValue: ^PerformanceValueINTEL) -> Result
ProcGetPipelineBinaryDataKHR                               :: #type proc "system" (device: Device, pInfo: ^PipelineBinaryDataInfoKHR, pPipelineBinaryKey: ^PipelineBinaryKeyKHR, pPipelineBinaryDataSize: ^int, pPipelineBinaryData: rawptr) -> Result
ProcGetPipelineCacheData                                   :: #type proc "system" (device: Device, pipelineCache: PipelineCache, pDataSize: ^int, pData: rawptr) -> Result
ProcGetPipelineExecutableInternalRepresentationsKHR        :: #type proc "system" (device: Device, pExecutableInfo: ^PipelineExecutableInfoKHR, pInternalRepresentationCount: ^u32, pInternalRepresentations: [^]PipelineExecutableInternalRepresentationKHR) -> Result
ProcGetPipelineExecutablePropertiesKHR                     :: #type proc "system" (device: Device, pPipelineInfo: ^PipelineInfoKHR, pExecutableCount: ^u32, pProperties: [^]PipelineExecutablePropertiesKHR) -> Result
ProcGetPipelineExecutableStatisticsKHR                     :: #type proc "system" (device: Device, pExecutableInfo: ^PipelineExecutableInfoKHR, pStatisticCount: ^u32, pStatistics: [^]PipelineExecutableStatisticKHR) -> Result
ProcGetPipelineIndirectDeviceAddressNV                     :: #type proc "system" (device: Device, pInfo: ^PipelineIndirectDeviceAddressInfoNV) -> DeviceAddress
ProcGetPipelineIndirectMemoryRequirementsNV                :: #type proc "system" (device: Device, pCreateInfo: ^ComputePipelineCreateInfo, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetPipelineKeyKHR                                      :: #type proc "system" (device: Device, pPipelineCreateInfo: ^PipelineCreateInfoKHR, pPipelineKey: ^PipelineBinaryKeyKHR) -> Result
ProcGetPipelinePropertiesEXT                               :: #type proc "system" (device: Device, pPipelineInfo: ^PipelineInfoKHR, pPipelineProperties: [^]BaseOutStructure) -> Result
ProcGetPrivateData                                         :: #type proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, pData: ^u64)
ProcGetPrivateDataEXT                                      :: #type proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, pData: ^u64)
ProcGetQueryPoolResults                                    :: #type proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32, dataSize: int, pData: rawptr, stride: DeviceSize, flags: QueryResultFlags) -> Result
ProcGetQueueCheckpointData2NV                              :: #type proc "system" (queue: Queue, pCheckpointDataCount: ^u32, pCheckpointData: ^CheckpointData2NV)
ProcGetQueueCheckpointDataNV                               :: #type proc "system" (queue: Queue, pCheckpointDataCount: ^u32, pCheckpointData: ^CheckpointDataNV)
ProcGetRayTracingCaptureReplayShaderGroupHandlesKHR        :: #type proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result
ProcGetRayTracingShaderGroupHandlesKHR                     :: #type proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result
ProcGetRayTracingShaderGroupHandlesNV                      :: #type proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result
ProcGetRayTracingShaderGroupStackSizeKHR                   :: #type proc "system" (device: Device, pipeline: Pipeline, group: u32, groupShader: ShaderGroupShaderKHR) -> DeviceSize
ProcGetRefreshCycleDurationGOOGLE                          :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pDisplayTimingProperties: [^]RefreshCycleDurationGOOGLE) -> Result
ProcGetRenderAreaGranularity                               :: #type proc "system" (device: Device, renderPass: RenderPass, pGranularity: ^Extent2D)
ProcGetRenderingAreaGranularity                            :: #type proc "system" (device: Device, pRenderingAreaInfo: ^RenderingAreaInfo, pGranularity: ^Extent2D)
ProcGetRenderingAreaGranularityKHR                         :: #type proc "system" (device: Device, pRenderingAreaInfo: ^RenderingAreaInfo, pGranularity: ^Extent2D)
ProcGetSamplerOpaqueCaptureDescriptorDataEXT               :: #type proc "system" (device: Device, pInfo: ^SamplerCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result
ProcGetSemaphoreCounterValue                               :: #type proc "system" (device: Device, semaphore: Semaphore, pValue: ^u64) -> Result
ProcGetSemaphoreCounterValueKHR                            :: #type proc "system" (device: Device, semaphore: Semaphore, pValue: ^u64) -> Result
ProcGetSemaphoreFdKHR                                      :: #type proc "system" (device: Device, pGetFdInfo: ^SemaphoreGetFdInfoKHR, pFd: ^c.int) -> Result
ProcGetSemaphoreWin32HandleKHR                             :: #type proc "system" (device: Device, pGetWin32HandleInfo: ^SemaphoreGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result
ProcGetShaderBinaryDataEXT                                 :: #type proc "system" (device: Device, shader: ShaderEXT, pDataSize: ^int, pData: rawptr) -> Result
ProcGetShaderInfoAMD                                       :: #type proc "system" (device: Device, pipeline: Pipeline, shaderStage: ShaderStageFlags, infoType: ShaderInfoTypeAMD, pInfoSize: ^int, pInfo: rawptr) -> Result
ProcGetShaderInstrumentationValuesARM                      :: #type proc "system" (device: Device, instrumentation: ShaderInstrumentationARM, pMetricBlockCount: ^u32, pMetricValues: rawptr, flags: ShaderInstrumentationValuesFlagsARM) -> Result
ProcGetShaderModuleCreateInfoIdentifierEXT                 :: #type proc "system" (device: Device, pCreateInfo: ^ShaderModuleCreateInfo, pIdentifier: ^ShaderModuleIdentifierEXT)
ProcGetShaderModuleIdentifierEXT                           :: #type proc "system" (device: Device, shaderModule: ShaderModule, pIdentifier: ^ShaderModuleIdentifierEXT)
ProcGetSwapchainCounterEXT                                 :: #type proc "system" (device: Device, swapchain: SwapchainKHR, counter: SurfaceCounterFlagsEXT, pCounterValue: ^u64) -> Result
ProcGetSwapchainImagesKHR                                  :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainImageCount: ^u32, pSwapchainImages: [^]Image) -> Result
ProcGetSwapchainStatusKHR                                  :: #type proc "system" (device: Device, swapchain: SwapchainKHR) -> Result
ProcGetSwapchainTimeDomainPropertiesEXT                    :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainTimeDomainProperties: [^]SwapchainTimeDomainPropertiesEXT, pTimeDomainsCounter: ^u64) -> Result
ProcGetSwapchainTimingPropertiesEXT                        :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainTimingProperties: [^]SwapchainTimingPropertiesEXT, pSwapchainTimingPropertiesCounter: ^u64) -> Result
ProcGetTensorMemoryRequirementsARM                         :: #type proc "system" (device: Device, pInfo: ^TensorMemoryRequirementsInfoARM, pMemoryRequirements: [^]MemoryRequirements2)
ProcGetTensorOpaqueCaptureDataARM                          :: #type proc "system" (device: Device, tensorCount: u32, pTensors: [^]TensorARM, pDatas: [^]HostAddressRangeEXT) -> Result
ProcGetTensorOpaqueCaptureDescriptorDataARM                :: #type proc "system" (device: Device, pInfo: ^TensorCaptureDescriptorDataInfoARM, pData: rawptr) -> Result
ProcGetTensorViewOpaqueCaptureDescriptorDataARM            :: #type proc "system" (device: Device, pInfo: ^TensorViewCaptureDescriptorDataInfoARM, pData: rawptr) -> Result
ProcGetValidationCacheDataEXT                              :: #type proc "system" (device: Device, validationCache: ValidationCacheEXT, pDataSize: ^int, pData: rawptr) -> Result
ProcGetVideoSessionMemoryRequirementsKHR                   :: #type proc "system" (device: Device, videoSession: VideoSessionKHR, pMemoryRequirementsCount: ^u32, pMemoryRequirements: [^]VideoSessionMemoryRequirementsKHR) -> Result
ProcImportFenceFdKHR                                       :: #type proc "system" (device: Device, pImportFenceFdInfo: ^ImportFenceFdInfoKHR) -> Result
ProcImportFenceWin32HandleKHR                              :: #type proc "system" (device: Device, pImportFenceWin32HandleInfo: ^ImportFenceWin32HandleInfoKHR) -> Result
ProcImportSemaphoreFdKHR                                   :: #type proc "system" (device: Device, pImportSemaphoreFdInfo: ^ImportSemaphoreFdInfoKHR) -> Result
ProcImportSemaphoreWin32HandleKHR                          :: #type proc "system" (device: Device, pImportSemaphoreWin32HandleInfo: ^ImportSemaphoreWin32HandleInfoKHR) -> Result
ProcInitializePerformanceApiINTEL                          :: #type proc "system" (device: Device, pInitializeInfo: ^InitializePerformanceApiInfoINTEL) -> Result
ProcInvalidateMappedMemoryRanges                           :: #type proc "system" (device: Device, memoryRangeCount: u32, pMemoryRanges: [^]MappedMemoryRange) -> Result
ProcLatencySleepNV                                         :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pSleepInfo: ^LatencySleepInfoNV) -> Result
ProcMapMemory                                              :: #type proc "system" (device: Device, memory: DeviceMemory, offset: DeviceSize, size: DeviceSize, flags: MemoryMapFlags, ppData: ^rawptr) -> Result
ProcMapMemory2                                             :: #type proc "system" (device: Device, pMemoryMapInfo: ^MemoryMapInfo, ppData: ^rawptr) -> Result
ProcMapMemory2KHR                                          :: #type proc "system" (device: Device, pMemoryMapInfo: ^MemoryMapInfo, ppData: ^rawptr) -> Result
ProcMergePipelineCaches                                    :: #type proc "system" (device: Device, dstCache: PipelineCache, srcCacheCount: u32, pSrcCaches: [^]PipelineCache) -> Result
ProcMergeValidationCachesEXT                               :: #type proc "system" (device: Device, dstCache: ValidationCacheEXT, srcCacheCount: u32, pSrcCaches: [^]ValidationCacheEXT) -> Result
ProcQueueBeginDebugUtilsLabelEXT                           :: #type proc "system" (queue: Queue, pLabelInfo: ^DebugUtilsLabelEXT)
ProcQueueBindSparse                                        :: #type proc "system" (queue: Queue, bindInfoCount: u32, pBindInfo: ^BindSparseInfo, fence: Fence) -> Result
ProcQueueEndDebugUtilsLabelEXT                             :: #type proc "system" (queue: Queue)
ProcQueueInsertDebugUtilsLabelEXT                          :: #type proc "system" (queue: Queue, pLabelInfo: ^DebugUtilsLabelEXT)
ProcQueueNotifyOutOfBandNV                                 :: #type proc "system" (queue: Queue, pQueueTypeInfo: ^OutOfBandQueueTypeInfoNV)
ProcQueuePresentKHR                                        :: #type proc "system" (queue: Queue, pPresentInfo: ^PresentInfoKHR) -> Result
ProcQueueSetPerformanceConfigurationINTEL                  :: #type proc "system" (queue: Queue, configuration: PerformanceConfigurationINTEL) -> Result
ProcQueueSubmit                                            :: #type proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo, fence: Fence) -> Result
ProcQueueSubmit2                                           :: #type proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo2, fence: Fence) -> Result
ProcQueueSubmit2KHR                                        :: #type proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo2, fence: Fence) -> Result
ProcQueueWaitIdle                                          :: #type proc "system" (queue: Queue) -> Result
ProcRegisterCustomBorderColorEXT                           :: #type proc "system" (device: Device, pBorderColor: ^SamplerCustomBorderColorCreateInfoEXT, requestIndex: b32, pIndex: ^u32) -> Result
ProcRegisterDeviceEventEXT                                 :: #type proc "system" (device: Device, pDeviceEventInfo: ^DeviceEventInfoEXT, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result
ProcRegisterDisplayEventEXT                                :: #type proc "system" (device: Device, display: DisplayKHR, pDisplayEventInfo: ^DisplayEventInfoEXT, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result
ProcReleaseCapturedPipelineDataKHR                         :: #type proc "system" (device: Device, pInfo: ^ReleaseCapturedPipelineDataInfoKHR, pAllocator: ^AllocationCallbacks) -> Result
ProcReleaseFullScreenExclusiveModeEXT                      :: #type proc "system" (device: Device, swapchain: SwapchainKHR) -> Result
ProcReleasePerformanceConfigurationINTEL                   :: #type proc "system" (device: Device, configuration: PerformanceConfigurationINTEL) -> Result
ProcReleaseProfilingLockKHR                                :: #type proc "system" (device: Device)
ProcReleaseSwapchainImagesEXT                              :: #type proc "system" (device: Device, pReleaseInfo: ^ReleaseSwapchainImagesInfoKHR) -> Result
ProcReleaseSwapchainImagesKHR                              :: #type proc "system" (device: Device, pReleaseInfo: ^ReleaseSwapchainImagesInfoKHR) -> Result
ProcResetCommandBuffer                                     :: #type proc "system" (commandBuffer: CommandBuffer, flags: CommandBufferResetFlags) -> Result
ProcResetCommandPool                                       :: #type proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolResetFlags) -> Result
ProcResetDescriptorPool                                    :: #type proc "system" (device: Device, descriptorPool: DescriptorPool, flags: DescriptorPoolResetFlags) -> Result
ProcResetEvent                                             :: #type proc "system" (device: Device, event: Event) -> Result
ProcResetFences                                            :: #type proc "system" (device: Device, fenceCount: u32, pFences: [^]Fence) -> Result
ProcResetGpaSessionAMD                                     :: #type proc "system" (device: Device, gpaSession: GpaSessionAMD) -> Result
ProcResetQueryPool                                         :: #type proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32)
ProcResetQueryPoolEXT                                      :: #type proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32)
ProcSetDebugUtilsObjectNameEXT                             :: #type proc "system" (device: Device, pNameInfo: ^DebugUtilsObjectNameInfoEXT) -> Result
ProcSetDebugUtilsObjectTagEXT                              :: #type proc "system" (device: Device, pTagInfo: ^DebugUtilsObjectTagInfoEXT) -> Result
ProcSetDeviceMemoryPriorityEXT                             :: #type proc "system" (device: Device, memory: DeviceMemory, priority: f32)
ProcSetEvent                                               :: #type proc "system" (device: Device, event: Event) -> Result
ProcSetGpaDeviceClockModeAMD                               :: #type proc "system" (device: Device, pInfo: ^GpaDeviceClockModeInfoAMD) -> Result
ProcSetHdrMetadataEXT                                      :: #type proc "system" (device: Device, swapchainCount: u32, pSwapchains: [^]SwapchainKHR, pMetadata: ^HdrMetadataEXT)
ProcSetLatencyMarkerNV                                     :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pLatencyMarkerInfo: ^SetLatencyMarkerInfoNV)
ProcSetLatencySleepModeNV                                  :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pSleepModeInfo: ^LatencySleepModeInfoNV) -> Result
ProcSetLocalDimmingAMD                                     :: #type proc "system" (device: Device, swapChain: SwapchainKHR, localDimmingEnable: b32)
ProcSetPrivateData                                         :: #type proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, data: u64) -> Result
ProcSetPrivateDataEXT                                      :: #type proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, data: u64) -> Result
ProcSetSwapchainPresentTimingQueueSizeEXT                  :: #type proc "system" (device: Device, swapchain: SwapchainKHR, size: u32) -> Result
ProcSignalSemaphore                                        :: #type proc "system" (device: Device, pSignalInfo: ^SemaphoreSignalInfo) -> Result
ProcSignalSemaphoreKHR                                     :: #type proc "system" (device: Device, pSignalInfo: ^SemaphoreSignalInfo) -> Result
ProcTransitionImageLayout                                  :: #type proc "system" (device: Device, transitionCount: u32, pTransitions: [^]HostImageLayoutTransitionInfo) -> Result
ProcTransitionImageLayoutEXT                               :: #type proc "system" (device: Device, transitionCount: u32, pTransitions: [^]HostImageLayoutTransitionInfo) -> Result
ProcTrimCommandPool                                        :: #type proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolTrimFlags)
ProcTrimCommandPoolKHR                                     :: #type proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolTrimFlags)
ProcUninitializePerformanceApiINTEL                        :: #type proc "system" (device: Device)
ProcUnmapMemory                                            :: #type proc "system" (device: Device, memory: DeviceMemory)
ProcUnmapMemory2                                           :: #type proc "system" (device: Device, pMemoryUnmapInfo: ^MemoryUnmapInfo) -> Result
ProcUnmapMemory2KHR                                        :: #type proc "system" (device: Device, pMemoryUnmapInfo: ^MemoryUnmapInfo) -> Result
ProcUnregisterCustomBorderColorEXT                         :: #type proc "system" (device: Device, index: u32)
ProcUpdateDescriptorSetWithTemplate                        :: #type proc "system" (device: Device, descriptorSet: DescriptorSet, descriptorUpdateTemplate: DescriptorUpdateTemplate, pData: rawptr)
ProcUpdateDescriptorSetWithTemplateKHR                     :: #type proc "system" (device: Device, descriptorSet: DescriptorSet, descriptorUpdateTemplate: DescriptorUpdateTemplate, pData: rawptr)
ProcUpdateDescriptorSets                                   :: #type proc "system" (device: Device, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet, descriptorCopyCount: u32, pDescriptorCopies: [^]CopyDescriptorSet)
ProcUpdateIndirectExecutionSetPipelineEXT                  :: #type proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, executionSetWriteCount: u32, pExecutionSetWrites: [^]WriteIndirectExecutionSetPipelineEXT)
ProcUpdateIndirectExecutionSetShaderEXT                    :: #type proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, executionSetWriteCount: u32, pExecutionSetWrites: [^]WriteIndirectExecutionSetShaderEXT)
ProcUpdateVideoSessionParametersKHR                        :: #type proc "system" (device: Device, videoSessionParameters: VideoSessionParametersKHR, pUpdateInfo: ^VideoSessionParametersUpdateInfoKHR) -> Result
ProcWaitForFences                                          :: #type proc "system" (device: Device, fenceCount: u32, pFences: [^]Fence, waitAll: b32, timeout: u64) -> Result
ProcWaitForPresent2KHR                                     :: #type proc "system" (device: Device, swapchain: SwapchainKHR, pPresentWait2Info: ^PresentWait2InfoKHR) -> Result
ProcWaitForPresentKHR                                      :: #type proc "system" (device: Device, swapchain: SwapchainKHR, presentId: u64, timeout: u64) -> Result
ProcWaitSemaphores                                         :: #type proc "system" (device: Device, pWaitInfo: ^SemaphoreWaitInfo, timeout: u64) -> Result
ProcWaitSemaphoresKHR                                      :: #type proc "system" (device: Device, pWaitInfo: ^SemaphoreWaitInfo, timeout: u64) -> Result
ProcWriteAccelerationStructuresPropertiesKHR               :: #type proc "system" (device: Device, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureKHR, queryType: QueryType, dataSize: int, pData: rawptr, stride: int) -> Result
ProcWriteMicromapsPropertiesEXT                            :: #type proc "system" (device: Device, micromapCount: u32, pMicromaps: [^]MicromapEXT, queryType: QueryType, dataSize: int, pData: rawptr, stride: int) -> Result
ProcWriteResourceDescriptorsEXT                            :: #type proc "system" (device: Device, resourceCount: u32, pResources: [^]ResourceDescriptorInfoEXT, pDescriptors: [^]HostAddressRangeEXT) -> Result
ProcWriteSamplerDescriptorsEXT                             :: #type proc "system" (device: Device, samplerCount: u32, pSamplers: [^]SamplerCreateInfo, pDescriptors: [^]HostAddressRangeEXT) -> Result


// Loader Procedures
PtrCreateInstance:                       ProcCreateInstance
PtrDebugUtilsMessengerCallbackEXT:       ProcDebugUtilsMessengerCallbackEXT
PtrDeviceMemoryReportCallbackEXT:        ProcDeviceMemoryReportCallbackEXT
PtrEnumerateInstanceExtensionProperties: ProcEnumerateInstanceExtensionProperties
PtrEnumerateInstanceLayerProperties:     ProcEnumerateInstanceLayerProperties
PtrEnumerateInstanceVersion:             ProcEnumerateInstanceVersion
PtrGetExternalComputeQueueDataNV:        ProcGetExternalComputeQueueDataNV
PtrGetInstanceProcAddr:                  ProcGetInstanceProcAddr

// Instance Procedures
PtrAcquireDrmDisplayEXT:                                               ProcAcquireDrmDisplayEXT
PtrAcquireWinrtDisplayNV:                                              ProcAcquireWinrtDisplayNV
PtrCreateAndroidSurfaceKHR:                                            ProcCreateAndroidSurfaceKHR
PtrCreateDebugReportCallbackEXT:                                       ProcCreateDebugReportCallbackEXT
PtrCreateDebugUtilsMessengerEXT:                                       ProcCreateDebugUtilsMessengerEXT
PtrCreateDevice:                                                       ProcCreateDevice
PtrCreateDisplayModeKHR:                                               ProcCreateDisplayModeKHR
PtrCreateDisplayPlaneSurfaceKHR:                                       ProcCreateDisplayPlaneSurfaceKHR
PtrCreateHeadlessSurfaceEXT:                                           ProcCreateHeadlessSurfaceEXT
PtrCreateIOSSurfaceMVK:                                                ProcCreateIOSSurfaceMVK
PtrCreateMacOSSurfaceMVK:                                              ProcCreateMacOSSurfaceMVK
PtrCreateMetalSurfaceEXT:                                              ProcCreateMetalSurfaceEXT
PtrCreateWaylandSurfaceKHR:                                            ProcCreateWaylandSurfaceKHR
PtrCreateWin32SurfaceKHR:                                              ProcCreateWin32SurfaceKHR
PtrCreateXcbSurfaceKHR:                                                ProcCreateXcbSurfaceKHR
PtrCreateXlibSurfaceKHR:                                               ProcCreateXlibSurfaceKHR
PtrDebugReportMessageEXT:                                              ProcDebugReportMessageEXT
PtrDestroyDebugReportCallbackEXT:                                      ProcDestroyDebugReportCallbackEXT
PtrDestroyDebugUtilsMessengerEXT:                                      ProcDestroyDebugUtilsMessengerEXT
PtrDestroyInstance:                                                    ProcDestroyInstance
PtrDestroySurfaceKHR:                                                  ProcDestroySurfaceKHR
PtrEnumerateDeviceExtensionProperties:                                 ProcEnumerateDeviceExtensionProperties
PtrEnumerateDeviceLayerProperties:                                     ProcEnumerateDeviceLayerProperties
PtrEnumeratePhysicalDeviceGroups:                                      ProcEnumeratePhysicalDeviceGroups
PtrEnumeratePhysicalDeviceGroupsKHR:                                   ProcEnumeratePhysicalDeviceGroupsKHR
PtrEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM:   ProcEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM
PtrEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR:      ProcEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR
PtrEnumeratePhysicalDeviceShaderInstrumentationMetricsARM:             ProcEnumeratePhysicalDeviceShaderInstrumentationMetricsARM
PtrEnumeratePhysicalDevices:                                           ProcEnumeratePhysicalDevices
PtrGetDisplayModeProperties2KHR:                                       ProcGetDisplayModeProperties2KHR
PtrGetDisplayModePropertiesKHR:                                        ProcGetDisplayModePropertiesKHR
PtrGetDisplayPlaneCapabilities2KHR:                                    ProcGetDisplayPlaneCapabilities2KHR
PtrGetDisplayPlaneCapabilitiesKHR:                                     ProcGetDisplayPlaneCapabilitiesKHR
PtrGetDisplayPlaneSupportedDisplaysKHR:                                ProcGetDisplayPlaneSupportedDisplaysKHR
PtrGetDrmDisplayEXT:                                                   ProcGetDrmDisplayEXT
PtrGetInstanceProcAddrLUNARG:                                          ProcGetInstanceProcAddrLUNARG
PtrGetPhysicalDeviceCalibrateableTimeDomainsEXT:                       ProcGetPhysicalDeviceCalibrateableTimeDomainsEXT
PtrGetPhysicalDeviceCalibrateableTimeDomainsKHR:                       ProcGetPhysicalDeviceCalibrateableTimeDomainsKHR
PtrGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV:   ProcGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV
PtrGetPhysicalDeviceCooperativeMatrixPropertiesKHR:                    ProcGetPhysicalDeviceCooperativeMatrixPropertiesKHR
PtrGetPhysicalDeviceCooperativeMatrixPropertiesNV:                     ProcGetPhysicalDeviceCooperativeMatrixPropertiesNV
PtrGetPhysicalDeviceCooperativeVectorPropertiesNV:                     ProcGetPhysicalDeviceCooperativeVectorPropertiesNV
PtrGetPhysicalDeviceDescriptorSizeEXT:                                 ProcGetPhysicalDeviceDescriptorSizeEXT
PtrGetPhysicalDeviceDisplayPlaneProperties2KHR:                        ProcGetPhysicalDeviceDisplayPlaneProperties2KHR
PtrGetPhysicalDeviceDisplayPlanePropertiesKHR:                         ProcGetPhysicalDeviceDisplayPlanePropertiesKHR
PtrGetPhysicalDeviceDisplayProperties2KHR:                             ProcGetPhysicalDeviceDisplayProperties2KHR
PtrGetPhysicalDeviceDisplayPropertiesKHR:                              ProcGetPhysicalDeviceDisplayPropertiesKHR
PtrGetPhysicalDeviceExternalBufferProperties:                          ProcGetPhysicalDeviceExternalBufferProperties
PtrGetPhysicalDeviceExternalBufferPropertiesKHR:                       ProcGetPhysicalDeviceExternalBufferPropertiesKHR
PtrGetPhysicalDeviceExternalFenceProperties:                           ProcGetPhysicalDeviceExternalFenceProperties
PtrGetPhysicalDeviceExternalFencePropertiesKHR:                        ProcGetPhysicalDeviceExternalFencePropertiesKHR
PtrGetPhysicalDeviceExternalImageFormatPropertiesNV:                   ProcGetPhysicalDeviceExternalImageFormatPropertiesNV
PtrGetPhysicalDeviceExternalSemaphoreProperties:                       ProcGetPhysicalDeviceExternalSemaphoreProperties
PtrGetPhysicalDeviceExternalSemaphorePropertiesKHR:                    ProcGetPhysicalDeviceExternalSemaphorePropertiesKHR
PtrGetPhysicalDeviceExternalTensorPropertiesARM:                       ProcGetPhysicalDeviceExternalTensorPropertiesARM
PtrGetPhysicalDeviceFeatures:                                          ProcGetPhysicalDeviceFeatures
PtrGetPhysicalDeviceFeatures2:                                         ProcGetPhysicalDeviceFeatures2
PtrGetPhysicalDeviceFeatures2KHR:                                      ProcGetPhysicalDeviceFeatures2KHR
PtrGetPhysicalDeviceFormatProperties:                                  ProcGetPhysicalDeviceFormatProperties
PtrGetPhysicalDeviceFormatProperties2:                                 ProcGetPhysicalDeviceFormatProperties2
PtrGetPhysicalDeviceFormatProperties2KHR:                              ProcGetPhysicalDeviceFormatProperties2KHR
PtrGetPhysicalDeviceFragmentShadingRatesKHR:                           ProcGetPhysicalDeviceFragmentShadingRatesKHR
PtrGetPhysicalDeviceImageFormatProperties:                             ProcGetPhysicalDeviceImageFormatProperties
PtrGetPhysicalDeviceImageFormatProperties2:                            ProcGetPhysicalDeviceImageFormatProperties2
PtrGetPhysicalDeviceImageFormatProperties2KHR:                         ProcGetPhysicalDeviceImageFormatProperties2KHR
PtrGetPhysicalDeviceMemoryProperties:                                  ProcGetPhysicalDeviceMemoryProperties
PtrGetPhysicalDeviceMemoryProperties2:                                 ProcGetPhysicalDeviceMemoryProperties2
PtrGetPhysicalDeviceMemoryProperties2KHR:                              ProcGetPhysicalDeviceMemoryProperties2KHR
PtrGetPhysicalDeviceMultisamplePropertiesEXT:                          ProcGetPhysicalDeviceMultisamplePropertiesEXT
PtrGetPhysicalDeviceOpticalFlowImageFormatsNV:                         ProcGetPhysicalDeviceOpticalFlowImageFormatsNV
PtrGetPhysicalDevicePresentRectanglesKHR:                              ProcGetPhysicalDevicePresentRectanglesKHR
PtrGetPhysicalDeviceProperties:                                        ProcGetPhysicalDeviceProperties
PtrGetPhysicalDeviceProperties2:                                       ProcGetPhysicalDeviceProperties2
PtrGetPhysicalDeviceProperties2KHR:                                    ProcGetPhysicalDeviceProperties2KHR
PtrGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM:  ProcGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM
PtrGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM:    ProcGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM
PtrGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM: ProcGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM
PtrGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM:                 ProcGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM
PtrGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR:              ProcGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR
PtrGetPhysicalDeviceQueueFamilyProperties:                             ProcGetPhysicalDeviceQueueFamilyProperties
PtrGetPhysicalDeviceQueueFamilyProperties2:                            ProcGetPhysicalDeviceQueueFamilyProperties2
PtrGetPhysicalDeviceQueueFamilyProperties2KHR:                         ProcGetPhysicalDeviceQueueFamilyProperties2KHR
PtrGetPhysicalDeviceSparseImageFormatProperties:                       ProcGetPhysicalDeviceSparseImageFormatProperties
PtrGetPhysicalDeviceSparseImageFormatProperties2:                      ProcGetPhysicalDeviceSparseImageFormatProperties2
PtrGetPhysicalDeviceSparseImageFormatProperties2KHR:                   ProcGetPhysicalDeviceSparseImageFormatProperties2KHR
PtrGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV:    ProcGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV
PtrGetPhysicalDeviceSurfaceCapabilities2EXT:                           ProcGetPhysicalDeviceSurfaceCapabilities2EXT
PtrGetPhysicalDeviceSurfaceCapabilities2KHR:                           ProcGetPhysicalDeviceSurfaceCapabilities2KHR
PtrGetPhysicalDeviceSurfaceCapabilitiesKHR:                            ProcGetPhysicalDeviceSurfaceCapabilitiesKHR
PtrGetPhysicalDeviceSurfaceFormats2KHR:                                ProcGetPhysicalDeviceSurfaceFormats2KHR
PtrGetPhysicalDeviceSurfaceFormatsKHR:                                 ProcGetPhysicalDeviceSurfaceFormatsKHR
PtrGetPhysicalDeviceSurfacePresentModes2EXT:                           ProcGetPhysicalDeviceSurfacePresentModes2EXT
PtrGetPhysicalDeviceSurfacePresentModesKHR:                            ProcGetPhysicalDeviceSurfacePresentModesKHR
PtrGetPhysicalDeviceSurfaceSupportKHR:                                 ProcGetPhysicalDeviceSurfaceSupportKHR
PtrGetPhysicalDeviceToolProperties:                                    ProcGetPhysicalDeviceToolProperties
PtrGetPhysicalDeviceToolPropertiesEXT:                                 ProcGetPhysicalDeviceToolPropertiesEXT
PtrGetPhysicalDeviceVideoCapabilitiesKHR:                              ProcGetPhysicalDeviceVideoCapabilitiesKHR
PtrGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR:              ProcGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR
PtrGetPhysicalDeviceVideoFormatPropertiesKHR:                          ProcGetPhysicalDeviceVideoFormatPropertiesKHR
PtrGetPhysicalDeviceWaylandPresentationSupportKHR:                     ProcGetPhysicalDeviceWaylandPresentationSupportKHR
PtrGetPhysicalDeviceWin32PresentationSupportKHR:                       ProcGetPhysicalDeviceWin32PresentationSupportKHR
PtrGetPhysicalDeviceXcbPresentationSupportKHR:                         ProcGetPhysicalDeviceXcbPresentationSupportKHR
PtrGetPhysicalDeviceXlibPresentationSupportKHR:                        ProcGetPhysicalDeviceXlibPresentationSupportKHR
PtrGetWinrtDisplayNV:                                                  ProcGetWinrtDisplayNV
PtrReleaseDisplayEXT:                                                  ProcReleaseDisplayEXT
PtrSubmitDebugUtilsMessageEXT:                                         ProcSubmitDebugUtilsMessageEXT

// Device Procedures
PtrAcquireFullScreenExclusiveModeEXT:                      ProcAcquireFullScreenExclusiveModeEXT
PtrAcquireNextImage2KHR:                                   ProcAcquireNextImage2KHR
PtrAcquireNextImageKHR:                                    ProcAcquireNextImageKHR
PtrAcquirePerformanceConfigurationINTEL:                   ProcAcquirePerformanceConfigurationINTEL
PtrAcquireProfilingLockKHR:                                ProcAcquireProfilingLockKHR
PtrAllocateCommandBuffers:                                 ProcAllocateCommandBuffers
PtrAllocateDescriptorSets:                                 ProcAllocateDescriptorSets
PtrAllocateMemory:                                         ProcAllocateMemory
PtrAntiLagUpdateAMD:                                       ProcAntiLagUpdateAMD
PtrBeginCommandBuffer:                                     ProcBeginCommandBuffer
PtrBindAccelerationStructureMemoryNV:                      ProcBindAccelerationStructureMemoryNV
PtrBindBufferMemory:                                       ProcBindBufferMemory
PtrBindBufferMemory2:                                      ProcBindBufferMemory2
PtrBindBufferMemory2KHR:                                   ProcBindBufferMemory2KHR
PtrBindDataGraphPipelineSessionMemoryARM:                  ProcBindDataGraphPipelineSessionMemoryARM
PtrBindImageMemory:                                        ProcBindImageMemory
PtrBindImageMemory2:                                       ProcBindImageMemory2
PtrBindImageMemory2KHR:                                    ProcBindImageMemory2KHR
PtrBindOpticalFlowSessionImageNV:                          ProcBindOpticalFlowSessionImageNV
PtrBindTensorMemoryARM:                                    ProcBindTensorMemoryARM
PtrBindVideoSessionMemoryKHR:                              ProcBindVideoSessionMemoryKHR
PtrBuildAccelerationStructuresKHR:                         ProcBuildAccelerationStructuresKHR
PtrBuildMicromapsEXT:                                      ProcBuildMicromapsEXT
PtrClearShaderInstrumentationMetricsARM:                   ProcClearShaderInstrumentationMetricsARM
PtrCmdBeginConditionalRendering2EXT:                       ProcCmdBeginConditionalRendering2EXT
PtrCmdBeginConditionalRenderingEXT:                        ProcCmdBeginConditionalRenderingEXT
PtrCmdBeginCustomResolveEXT:                               ProcCmdBeginCustomResolveEXT
PtrCmdBeginDebugUtilsLabelEXT:                             ProcCmdBeginDebugUtilsLabelEXT
PtrCmdBeginGpaSampleAMD:                                   ProcCmdBeginGpaSampleAMD
PtrCmdBeginGpaSessionAMD:                                  ProcCmdBeginGpaSessionAMD
PtrCmdBeginPerTileExecutionQCOM:                           ProcCmdBeginPerTileExecutionQCOM
PtrCmdBeginQuery:                                          ProcCmdBeginQuery
PtrCmdBeginQueryIndexedEXT:                                ProcCmdBeginQueryIndexedEXT
PtrCmdBeginRenderPass:                                     ProcCmdBeginRenderPass
PtrCmdBeginRenderPass2:                                    ProcCmdBeginRenderPass2
PtrCmdBeginRenderPass2KHR:                                 ProcCmdBeginRenderPass2KHR
PtrCmdBeginRendering:                                      ProcCmdBeginRendering
PtrCmdBeginRenderingKHR:                                   ProcCmdBeginRenderingKHR
PtrCmdBeginShaderInstrumentationARM:                       ProcCmdBeginShaderInstrumentationARM
PtrCmdBeginTransformFeedback2EXT:                          ProcCmdBeginTransformFeedback2EXT
PtrCmdBeginTransformFeedbackEXT:                           ProcCmdBeginTransformFeedbackEXT
PtrCmdBeginVideoCodingKHR:                                 ProcCmdBeginVideoCodingKHR
PtrCmdBindDescriptorBufferEmbeddedSamplers2EXT:            ProcCmdBindDescriptorBufferEmbeddedSamplers2EXT
PtrCmdBindDescriptorBufferEmbeddedSamplersEXT:             ProcCmdBindDescriptorBufferEmbeddedSamplersEXT
PtrCmdBindDescriptorBuffersEXT:                            ProcCmdBindDescriptorBuffersEXT
PtrCmdBindDescriptorSets:                                  ProcCmdBindDescriptorSets
PtrCmdBindDescriptorSets2:                                 ProcCmdBindDescriptorSets2
PtrCmdBindDescriptorSets2KHR:                              ProcCmdBindDescriptorSets2KHR
PtrCmdBindIndexBuffer:                                     ProcCmdBindIndexBuffer
PtrCmdBindIndexBuffer2:                                    ProcCmdBindIndexBuffer2
PtrCmdBindIndexBuffer2KHR:                                 ProcCmdBindIndexBuffer2KHR
PtrCmdBindIndexBuffer3KHR:                                 ProcCmdBindIndexBuffer3KHR
PtrCmdBindInvocationMaskHUAWEI:                            ProcCmdBindInvocationMaskHUAWEI
PtrCmdBindPipeline:                                        ProcCmdBindPipeline
PtrCmdBindPipelineShaderGroupNV:                           ProcCmdBindPipelineShaderGroupNV
PtrCmdBindResourceHeapEXT:                                 ProcCmdBindResourceHeapEXT
PtrCmdBindSamplerHeapEXT:                                  ProcCmdBindSamplerHeapEXT
PtrCmdBindShadersEXT:                                      ProcCmdBindShadersEXT
PtrCmdBindShadingRateImageNV:                              ProcCmdBindShadingRateImageNV
PtrCmdBindTileMemoryQCOM:                                  ProcCmdBindTileMemoryQCOM
PtrCmdBindTransformFeedbackBuffers2EXT:                    ProcCmdBindTransformFeedbackBuffers2EXT
PtrCmdBindTransformFeedbackBuffersEXT:                     ProcCmdBindTransformFeedbackBuffersEXT
PtrCmdBindVertexBuffers:                                   ProcCmdBindVertexBuffers
PtrCmdBindVertexBuffers2:                                  ProcCmdBindVertexBuffers2
PtrCmdBindVertexBuffers2EXT:                               ProcCmdBindVertexBuffers2EXT
PtrCmdBindVertexBuffers3KHR:                               ProcCmdBindVertexBuffers3KHR
PtrCmdBlitImage:                                           ProcCmdBlitImage
PtrCmdBlitImage2:                                          ProcCmdBlitImage2
PtrCmdBlitImage2KHR:                                       ProcCmdBlitImage2KHR
PtrCmdBuildAccelerationStructureNV:                        ProcCmdBuildAccelerationStructureNV
PtrCmdBuildAccelerationStructuresIndirectKHR:              ProcCmdBuildAccelerationStructuresIndirectKHR
PtrCmdBuildAccelerationStructuresKHR:                      ProcCmdBuildAccelerationStructuresKHR
PtrCmdBuildClusterAccelerationStructureIndirectNV:         ProcCmdBuildClusterAccelerationStructureIndirectNV
PtrCmdBuildMicromapsEXT:                                   ProcCmdBuildMicromapsEXT
PtrCmdBuildPartitionedAccelerationStructuresNV:            ProcCmdBuildPartitionedAccelerationStructuresNV
PtrCmdClearAttachments:                                    ProcCmdClearAttachments
PtrCmdClearColorImage:                                     ProcCmdClearColorImage
PtrCmdClearDepthStencilImage:                              ProcCmdClearDepthStencilImage
PtrCmdControlVideoCodingKHR:                               ProcCmdControlVideoCodingKHR
PtrCmdConvertCooperativeVectorMatrixNV:                    ProcCmdConvertCooperativeVectorMatrixNV
PtrCmdCopyAccelerationStructureKHR:                        ProcCmdCopyAccelerationStructureKHR
PtrCmdCopyAccelerationStructureNV:                         ProcCmdCopyAccelerationStructureNV
PtrCmdCopyAccelerationStructureToMemoryKHR:                ProcCmdCopyAccelerationStructureToMemoryKHR
PtrCmdCopyBuffer:                                          ProcCmdCopyBuffer
PtrCmdCopyBuffer2:                                         ProcCmdCopyBuffer2
PtrCmdCopyBuffer2KHR:                                      ProcCmdCopyBuffer2KHR
PtrCmdCopyBufferToImage:                                   ProcCmdCopyBufferToImage
PtrCmdCopyBufferToImage2:                                  ProcCmdCopyBufferToImage2
PtrCmdCopyBufferToImage2KHR:                               ProcCmdCopyBufferToImage2KHR
PtrCmdCopyGpaSessionResultsAMD:                            ProcCmdCopyGpaSessionResultsAMD
PtrCmdCopyImage:                                           ProcCmdCopyImage
PtrCmdCopyImage2:                                          ProcCmdCopyImage2
PtrCmdCopyImage2KHR:                                       ProcCmdCopyImage2KHR
PtrCmdCopyImageToBuffer:                                   ProcCmdCopyImageToBuffer
PtrCmdCopyImageToBuffer2:                                  ProcCmdCopyImageToBuffer2
PtrCmdCopyImageToBuffer2KHR:                               ProcCmdCopyImageToBuffer2KHR
PtrCmdCopyImageToMemoryKHR:                                ProcCmdCopyImageToMemoryKHR
PtrCmdCopyMemoryIndirectKHR:                               ProcCmdCopyMemoryIndirectKHR
PtrCmdCopyMemoryIndirectNV:                                ProcCmdCopyMemoryIndirectNV
PtrCmdCopyMemoryKHR:                                       ProcCmdCopyMemoryKHR
PtrCmdCopyMemoryToAccelerationStructureKHR:                ProcCmdCopyMemoryToAccelerationStructureKHR
PtrCmdCopyMemoryToImageIndirectKHR:                        ProcCmdCopyMemoryToImageIndirectKHR
PtrCmdCopyMemoryToImageIndirectNV:                         ProcCmdCopyMemoryToImageIndirectNV
PtrCmdCopyMemoryToImageKHR:                                ProcCmdCopyMemoryToImageKHR
PtrCmdCopyMemoryToMicromapEXT:                             ProcCmdCopyMemoryToMicromapEXT
PtrCmdCopyMicromapEXT:                                     ProcCmdCopyMicromapEXT
PtrCmdCopyMicromapToMemoryEXT:                             ProcCmdCopyMicromapToMemoryEXT
PtrCmdCopyQueryPoolResults:                                ProcCmdCopyQueryPoolResults
PtrCmdCopyQueryPoolResultsToMemoryKHR:                     ProcCmdCopyQueryPoolResultsToMemoryKHR
PtrCmdCopyTensorARM:                                       ProcCmdCopyTensorARM
PtrCmdCuLaunchKernelNVX:                                   ProcCmdCuLaunchKernelNVX
PtrCmdCudaLaunchKernelNV:                                  ProcCmdCudaLaunchKernelNV
PtrCmdDebugMarkerBeginEXT:                                 ProcCmdDebugMarkerBeginEXT
PtrCmdDebugMarkerEndEXT:                                   ProcCmdDebugMarkerEndEXT
PtrCmdDebugMarkerInsertEXT:                                ProcCmdDebugMarkerInsertEXT
PtrCmdDecodeVideoKHR:                                      ProcCmdDecodeVideoKHR
PtrCmdDecompressMemoryEXT:                                 ProcCmdDecompressMemoryEXT
PtrCmdDecompressMemoryIndirectCountEXT:                    ProcCmdDecompressMemoryIndirectCountEXT
PtrCmdDecompressMemoryIndirectCountNV:                     ProcCmdDecompressMemoryIndirectCountNV
PtrCmdDecompressMemoryNV:                                  ProcCmdDecompressMemoryNV
PtrCmdDispatch:                                            ProcCmdDispatch
PtrCmdDispatchBase:                                        ProcCmdDispatchBase
PtrCmdDispatchBaseKHR:                                     ProcCmdDispatchBaseKHR
PtrCmdDispatchDataGraphARM:                                ProcCmdDispatchDataGraphARM
PtrCmdDispatchGraphAMDX:                                   ProcCmdDispatchGraphAMDX
PtrCmdDispatchGraphIndirectAMDX:                           ProcCmdDispatchGraphIndirectAMDX
PtrCmdDispatchGraphIndirectCountAMDX:                      ProcCmdDispatchGraphIndirectCountAMDX
PtrCmdDispatchIndirect:                                    ProcCmdDispatchIndirect
PtrCmdDispatchIndirect2KHR:                                ProcCmdDispatchIndirect2KHR
PtrCmdDispatchTileQCOM:                                    ProcCmdDispatchTileQCOM
PtrCmdDraw:                                                ProcCmdDraw
PtrCmdDrawClusterHUAWEI:                                   ProcCmdDrawClusterHUAWEI
PtrCmdDrawClusterIndirectHUAWEI:                           ProcCmdDrawClusterIndirectHUAWEI
PtrCmdDrawIndexed:                                         ProcCmdDrawIndexed
PtrCmdDrawIndexedIndirect:                                 ProcCmdDrawIndexedIndirect
PtrCmdDrawIndexedIndirect2KHR:                             ProcCmdDrawIndexedIndirect2KHR
PtrCmdDrawIndexedIndirectCount:                            ProcCmdDrawIndexedIndirectCount
PtrCmdDrawIndexedIndirectCount2KHR:                        ProcCmdDrawIndexedIndirectCount2KHR
PtrCmdDrawIndexedIndirectCountAMD:                         ProcCmdDrawIndexedIndirectCountAMD
PtrCmdDrawIndexedIndirectCountKHR:                         ProcCmdDrawIndexedIndirectCountKHR
PtrCmdDrawIndirect:                                        ProcCmdDrawIndirect
PtrCmdDrawIndirect2KHR:                                    ProcCmdDrawIndirect2KHR
PtrCmdDrawIndirectByteCount2EXT:                           ProcCmdDrawIndirectByteCount2EXT
PtrCmdDrawIndirectByteCountEXT:                            ProcCmdDrawIndirectByteCountEXT
PtrCmdDrawIndirectCount:                                   ProcCmdDrawIndirectCount
PtrCmdDrawIndirectCount2KHR:                               ProcCmdDrawIndirectCount2KHR
PtrCmdDrawIndirectCountAMD:                                ProcCmdDrawIndirectCountAMD
PtrCmdDrawIndirectCountKHR:                                ProcCmdDrawIndirectCountKHR
PtrCmdDrawMeshTasksEXT:                                    ProcCmdDrawMeshTasksEXT
PtrCmdDrawMeshTasksIndirect2EXT:                           ProcCmdDrawMeshTasksIndirect2EXT
PtrCmdDrawMeshTasksIndirectCount2EXT:                      ProcCmdDrawMeshTasksIndirectCount2EXT
PtrCmdDrawMeshTasksIndirectCountEXT:                       ProcCmdDrawMeshTasksIndirectCountEXT
PtrCmdDrawMeshTasksIndirectCountNV:                        ProcCmdDrawMeshTasksIndirectCountNV
PtrCmdDrawMeshTasksIndirectEXT:                            ProcCmdDrawMeshTasksIndirectEXT
PtrCmdDrawMeshTasksIndirectNV:                             ProcCmdDrawMeshTasksIndirectNV
PtrCmdDrawMeshTasksNV:                                     ProcCmdDrawMeshTasksNV
PtrCmdDrawMultiEXT:                                        ProcCmdDrawMultiEXT
PtrCmdDrawMultiIndexedEXT:                                 ProcCmdDrawMultiIndexedEXT
PtrCmdEncodeVideoKHR:                                      ProcCmdEncodeVideoKHR
PtrCmdEndConditionalRenderingEXT:                          ProcCmdEndConditionalRenderingEXT
PtrCmdEndDebugUtilsLabelEXT:                               ProcCmdEndDebugUtilsLabelEXT
PtrCmdEndGpaSampleAMD:                                     ProcCmdEndGpaSampleAMD
PtrCmdEndGpaSessionAMD:                                    ProcCmdEndGpaSessionAMD
PtrCmdEndPerTileExecutionQCOM:                             ProcCmdEndPerTileExecutionQCOM
PtrCmdEndQuery:                                            ProcCmdEndQuery
PtrCmdEndQueryIndexedEXT:                                  ProcCmdEndQueryIndexedEXT
PtrCmdEndRenderPass:                                       ProcCmdEndRenderPass
PtrCmdEndRenderPass2:                                      ProcCmdEndRenderPass2
PtrCmdEndRenderPass2KHR:                                   ProcCmdEndRenderPass2KHR
PtrCmdEndRendering:                                        ProcCmdEndRendering
PtrCmdEndRendering2EXT:                                    ProcCmdEndRendering2EXT
PtrCmdEndRendering2KHR:                                    ProcCmdEndRendering2KHR
PtrCmdEndRenderingKHR:                                     ProcCmdEndRenderingKHR
PtrCmdEndShaderInstrumentationARM:                         ProcCmdEndShaderInstrumentationARM
PtrCmdEndTransformFeedback2EXT:                            ProcCmdEndTransformFeedback2EXT
PtrCmdEndTransformFeedbackEXT:                             ProcCmdEndTransformFeedbackEXT
PtrCmdEndVideoCodingKHR:                                   ProcCmdEndVideoCodingKHR
PtrCmdExecuteCommands:                                     ProcCmdExecuteCommands
PtrCmdExecuteGeneratedCommandsEXT:                         ProcCmdExecuteGeneratedCommandsEXT
PtrCmdExecuteGeneratedCommandsNV:                          ProcCmdExecuteGeneratedCommandsNV
PtrCmdFillBuffer:                                          ProcCmdFillBuffer
PtrCmdFillMemoryKHR:                                       ProcCmdFillMemoryKHR
PtrCmdInitializeGraphScratchMemoryAMDX:                    ProcCmdInitializeGraphScratchMemoryAMDX
PtrCmdInsertDebugUtilsLabelEXT:                            ProcCmdInsertDebugUtilsLabelEXT
PtrCmdNextSubpass:                                         ProcCmdNextSubpass
PtrCmdNextSubpass2:                                        ProcCmdNextSubpass2
PtrCmdNextSubpass2KHR:                                     ProcCmdNextSubpass2KHR
PtrCmdOpticalFlowExecuteNV:                                ProcCmdOpticalFlowExecuteNV
PtrCmdPipelineBarrier:                                     ProcCmdPipelineBarrier
PtrCmdPipelineBarrier2:                                    ProcCmdPipelineBarrier2
PtrCmdPipelineBarrier2KHR:                                 ProcCmdPipelineBarrier2KHR
PtrCmdPreprocessGeneratedCommandsEXT:                      ProcCmdPreprocessGeneratedCommandsEXT
PtrCmdPreprocessGeneratedCommandsNV:                       ProcCmdPreprocessGeneratedCommandsNV
PtrCmdPushConstants:                                       ProcCmdPushConstants
PtrCmdPushConstants2:                                      ProcCmdPushConstants2
PtrCmdPushConstants2KHR:                                   ProcCmdPushConstants2KHR
PtrCmdPushDataEXT:                                         ProcCmdPushDataEXT
PtrCmdPushDescriptorSet:                                   ProcCmdPushDescriptorSet
PtrCmdPushDescriptorSet2:                                  ProcCmdPushDescriptorSet2
PtrCmdPushDescriptorSet2KHR:                               ProcCmdPushDescriptorSet2KHR
PtrCmdPushDescriptorSetKHR:                                ProcCmdPushDescriptorSetKHR
PtrCmdPushDescriptorSetWithTemplate:                       ProcCmdPushDescriptorSetWithTemplate
PtrCmdPushDescriptorSetWithTemplate2:                      ProcCmdPushDescriptorSetWithTemplate2
PtrCmdPushDescriptorSetWithTemplate2KHR:                   ProcCmdPushDescriptorSetWithTemplate2KHR
PtrCmdPushDescriptorSetWithTemplateKHR:                    ProcCmdPushDescriptorSetWithTemplateKHR
PtrCmdResetEvent:                                          ProcCmdResetEvent
PtrCmdResetEvent2:                                         ProcCmdResetEvent2
PtrCmdResetEvent2KHR:                                      ProcCmdResetEvent2KHR
PtrCmdResetQueryPool:                                      ProcCmdResetQueryPool
PtrCmdResolveImage:                                        ProcCmdResolveImage
PtrCmdResolveImage2:                                       ProcCmdResolveImage2
PtrCmdResolveImage2KHR:                                    ProcCmdResolveImage2KHR
PtrCmdSetAlphaToCoverageEnableEXT:                         ProcCmdSetAlphaToCoverageEnableEXT
PtrCmdSetAlphaToOneEnableEXT:                              ProcCmdSetAlphaToOneEnableEXT
PtrCmdSetAttachmentFeedbackLoopEnableEXT:                  ProcCmdSetAttachmentFeedbackLoopEnableEXT
PtrCmdSetBlendConstants:                                   ProcCmdSetBlendConstants
PtrCmdSetCheckpointNV:                                     ProcCmdSetCheckpointNV
PtrCmdSetCoarseSampleOrderNV:                              ProcCmdSetCoarseSampleOrderNV
PtrCmdSetColorBlendAdvancedEXT:                            ProcCmdSetColorBlendAdvancedEXT
PtrCmdSetColorBlendEnableEXT:                              ProcCmdSetColorBlendEnableEXT
PtrCmdSetColorBlendEquationEXT:                            ProcCmdSetColorBlendEquationEXT
PtrCmdSetColorWriteEnableEXT:                              ProcCmdSetColorWriteEnableEXT
PtrCmdSetColorWriteMaskEXT:                                ProcCmdSetColorWriteMaskEXT
PtrCmdSetComputeOccupancyPriorityNV:                       ProcCmdSetComputeOccupancyPriorityNV
PtrCmdSetConservativeRasterizationModeEXT:                 ProcCmdSetConservativeRasterizationModeEXT
PtrCmdSetCoverageModulationModeNV:                         ProcCmdSetCoverageModulationModeNV
PtrCmdSetCoverageModulationTableEnableNV:                  ProcCmdSetCoverageModulationTableEnableNV
PtrCmdSetCoverageModulationTableNV:                        ProcCmdSetCoverageModulationTableNV
PtrCmdSetCoverageReductionModeNV:                          ProcCmdSetCoverageReductionModeNV
PtrCmdSetCoverageToColorEnableNV:                          ProcCmdSetCoverageToColorEnableNV
PtrCmdSetCoverageToColorLocationNV:                        ProcCmdSetCoverageToColorLocationNV
PtrCmdSetCullMode:                                         ProcCmdSetCullMode
PtrCmdSetCullModeEXT:                                      ProcCmdSetCullModeEXT
PtrCmdSetDepthBias:                                        ProcCmdSetDepthBias
PtrCmdSetDepthBias2EXT:                                    ProcCmdSetDepthBias2EXT
PtrCmdSetDepthBiasEnable:                                  ProcCmdSetDepthBiasEnable
PtrCmdSetDepthBiasEnableEXT:                               ProcCmdSetDepthBiasEnableEXT
PtrCmdSetDepthBounds:                                      ProcCmdSetDepthBounds
PtrCmdSetDepthBoundsTestEnable:                            ProcCmdSetDepthBoundsTestEnable
PtrCmdSetDepthBoundsTestEnableEXT:                         ProcCmdSetDepthBoundsTestEnableEXT
PtrCmdSetDepthClampEnableEXT:                              ProcCmdSetDepthClampEnableEXT
PtrCmdSetDepthClampRangeEXT:                               ProcCmdSetDepthClampRangeEXT
PtrCmdSetDepthClipEnableEXT:                               ProcCmdSetDepthClipEnableEXT
PtrCmdSetDepthClipNegativeOneToOneEXT:                     ProcCmdSetDepthClipNegativeOneToOneEXT
PtrCmdSetDepthCompareOp:                                   ProcCmdSetDepthCompareOp
PtrCmdSetDepthCompareOpEXT:                                ProcCmdSetDepthCompareOpEXT
PtrCmdSetDepthTestEnable:                                  ProcCmdSetDepthTestEnable
PtrCmdSetDepthTestEnableEXT:                               ProcCmdSetDepthTestEnableEXT
PtrCmdSetDepthWriteEnable:                                 ProcCmdSetDepthWriteEnable
PtrCmdSetDepthWriteEnableEXT:                              ProcCmdSetDepthWriteEnableEXT
PtrCmdSetDescriptorBufferOffsets2EXT:                      ProcCmdSetDescriptorBufferOffsets2EXT
PtrCmdSetDescriptorBufferOffsetsEXT:                       ProcCmdSetDescriptorBufferOffsetsEXT
PtrCmdSetDeviceMask:                                       ProcCmdSetDeviceMask
PtrCmdSetDeviceMaskKHR:                                    ProcCmdSetDeviceMaskKHR
PtrCmdSetDiscardRectangleEXT:                              ProcCmdSetDiscardRectangleEXT
PtrCmdSetDiscardRectangleEnableEXT:                        ProcCmdSetDiscardRectangleEnableEXT
PtrCmdSetDiscardRectangleModeEXT:                          ProcCmdSetDiscardRectangleModeEXT
PtrCmdSetDispatchParametersARM:                            ProcCmdSetDispatchParametersARM
PtrCmdSetEvent:                                            ProcCmdSetEvent
PtrCmdSetEvent2:                                           ProcCmdSetEvent2
PtrCmdSetEvent2KHR:                                        ProcCmdSetEvent2KHR
PtrCmdSetExclusiveScissorEnableNV:                         ProcCmdSetExclusiveScissorEnableNV
PtrCmdSetExclusiveScissorNV:                               ProcCmdSetExclusiveScissorNV
PtrCmdSetExtraPrimitiveOverestimationSizeEXT:              ProcCmdSetExtraPrimitiveOverestimationSizeEXT
PtrCmdSetFragmentShadingRateEnumNV:                        ProcCmdSetFragmentShadingRateEnumNV
PtrCmdSetFragmentShadingRateKHR:                           ProcCmdSetFragmentShadingRateKHR
PtrCmdSetFrontFace:                                        ProcCmdSetFrontFace
PtrCmdSetFrontFaceEXT:                                     ProcCmdSetFrontFaceEXT
PtrCmdSetLineRasterizationModeEXT:                         ProcCmdSetLineRasterizationModeEXT
PtrCmdSetLineStipple:                                      ProcCmdSetLineStipple
PtrCmdSetLineStippleEXT:                                   ProcCmdSetLineStippleEXT
PtrCmdSetLineStippleEnableEXT:                             ProcCmdSetLineStippleEnableEXT
PtrCmdSetLineStippleKHR:                                   ProcCmdSetLineStippleKHR
PtrCmdSetLineWidth:                                        ProcCmdSetLineWidth
PtrCmdSetLogicOpEXT:                                       ProcCmdSetLogicOpEXT
PtrCmdSetLogicOpEnableEXT:                                 ProcCmdSetLogicOpEnableEXT
PtrCmdSetPatchControlPointsEXT:                            ProcCmdSetPatchControlPointsEXT
PtrCmdSetPerformanceMarkerINTEL:                           ProcCmdSetPerformanceMarkerINTEL
PtrCmdSetPerformanceOverrideINTEL:                         ProcCmdSetPerformanceOverrideINTEL
PtrCmdSetPerformanceStreamMarkerINTEL:                     ProcCmdSetPerformanceStreamMarkerINTEL
PtrCmdSetPolygonModeEXT:                                   ProcCmdSetPolygonModeEXT
PtrCmdSetPrimitiveRestartEnable:                           ProcCmdSetPrimitiveRestartEnable
PtrCmdSetPrimitiveRestartEnableEXT:                        ProcCmdSetPrimitiveRestartEnableEXT
PtrCmdSetPrimitiveRestartIndexEXT:                         ProcCmdSetPrimitiveRestartIndexEXT
PtrCmdSetPrimitiveTopology:                                ProcCmdSetPrimitiveTopology
PtrCmdSetPrimitiveTopologyEXT:                             ProcCmdSetPrimitiveTopologyEXT
PtrCmdSetProvokingVertexModeEXT:                           ProcCmdSetProvokingVertexModeEXT
PtrCmdSetRasterizationSamplesEXT:                          ProcCmdSetRasterizationSamplesEXT
PtrCmdSetRasterizationStreamEXT:                           ProcCmdSetRasterizationStreamEXT
PtrCmdSetRasterizerDiscardEnable:                          ProcCmdSetRasterizerDiscardEnable
PtrCmdSetRasterizerDiscardEnableEXT:                       ProcCmdSetRasterizerDiscardEnableEXT
PtrCmdSetRayTracingPipelineStackSizeKHR:                   ProcCmdSetRayTracingPipelineStackSizeKHR
PtrCmdSetRenderingAttachmentLocations:                     ProcCmdSetRenderingAttachmentLocations
PtrCmdSetRenderingAttachmentLocationsKHR:                  ProcCmdSetRenderingAttachmentLocationsKHR
PtrCmdSetRenderingInputAttachmentIndices:                  ProcCmdSetRenderingInputAttachmentIndices
PtrCmdSetRenderingInputAttachmentIndicesKHR:               ProcCmdSetRenderingInputAttachmentIndicesKHR
PtrCmdSetRepresentativeFragmentTestEnableNV:               ProcCmdSetRepresentativeFragmentTestEnableNV
PtrCmdSetSampleLocationsEXT:                               ProcCmdSetSampleLocationsEXT
PtrCmdSetSampleLocationsEnableEXT:                         ProcCmdSetSampleLocationsEnableEXT
PtrCmdSetSampleMaskEXT:                                    ProcCmdSetSampleMaskEXT
PtrCmdSetScissor:                                          ProcCmdSetScissor
PtrCmdSetScissorWithCount:                                 ProcCmdSetScissorWithCount
PtrCmdSetScissorWithCountEXT:                              ProcCmdSetScissorWithCountEXT
PtrCmdSetShadingRateImageEnableNV:                         ProcCmdSetShadingRateImageEnableNV
PtrCmdSetStencilCompareMask:                               ProcCmdSetStencilCompareMask
PtrCmdSetStencilOp:                                        ProcCmdSetStencilOp
PtrCmdSetStencilOpEXT:                                     ProcCmdSetStencilOpEXT
PtrCmdSetStencilReference:                                 ProcCmdSetStencilReference
PtrCmdSetStencilTestEnable:                                ProcCmdSetStencilTestEnable
PtrCmdSetStencilTestEnableEXT:                             ProcCmdSetStencilTestEnableEXT
PtrCmdSetStencilWriteMask:                                 ProcCmdSetStencilWriteMask
PtrCmdSetTessellationDomainOriginEXT:                      ProcCmdSetTessellationDomainOriginEXT
PtrCmdSetVertexInputEXT:                                   ProcCmdSetVertexInputEXT
PtrCmdSetViewport:                                         ProcCmdSetViewport
PtrCmdSetViewportShadingRatePaletteNV:                     ProcCmdSetViewportShadingRatePaletteNV
PtrCmdSetViewportSwizzleNV:                                ProcCmdSetViewportSwizzleNV
PtrCmdSetViewportWScalingEnableNV:                         ProcCmdSetViewportWScalingEnableNV
PtrCmdSetViewportWScalingNV:                               ProcCmdSetViewportWScalingNV
PtrCmdSetViewportWithCount:                                ProcCmdSetViewportWithCount
PtrCmdSetViewportWithCountEXT:                             ProcCmdSetViewportWithCountEXT
PtrCmdSubpassShadingHUAWEI:                                ProcCmdSubpassShadingHUAWEI
PtrCmdTraceRaysIndirect2KHR:                               ProcCmdTraceRaysIndirect2KHR
PtrCmdTraceRaysIndirectKHR:                                ProcCmdTraceRaysIndirectKHR
PtrCmdTraceRaysKHR:                                        ProcCmdTraceRaysKHR
PtrCmdTraceRaysNV:                                         ProcCmdTraceRaysNV
PtrCmdUpdateBuffer:                                        ProcCmdUpdateBuffer
PtrCmdUpdateMemoryKHR:                                     ProcCmdUpdateMemoryKHR
PtrCmdUpdatePipelineIndirectBufferNV:                      ProcCmdUpdatePipelineIndirectBufferNV
PtrCmdWaitEvents:                                          ProcCmdWaitEvents
PtrCmdWaitEvents2:                                         ProcCmdWaitEvents2
PtrCmdWaitEvents2KHR:                                      ProcCmdWaitEvents2KHR
PtrCmdWriteAccelerationStructuresPropertiesKHR:            ProcCmdWriteAccelerationStructuresPropertiesKHR
PtrCmdWriteAccelerationStructuresPropertiesNV:             ProcCmdWriteAccelerationStructuresPropertiesNV
PtrCmdWriteBufferMarker2AMD:                               ProcCmdWriteBufferMarker2AMD
PtrCmdWriteBufferMarkerAMD:                                ProcCmdWriteBufferMarkerAMD
PtrCmdWriteMarkerToMemoryAMD:                              ProcCmdWriteMarkerToMemoryAMD
PtrCmdWriteMicromapsPropertiesEXT:                         ProcCmdWriteMicromapsPropertiesEXT
PtrCmdWriteTimestamp:                                      ProcCmdWriteTimestamp
PtrCmdWriteTimestamp2:                                     ProcCmdWriteTimestamp2
PtrCmdWriteTimestamp2KHR:                                  ProcCmdWriteTimestamp2KHR
PtrCompileDeferredNV:                                      ProcCompileDeferredNV
PtrConvertCooperativeVectorMatrixNV:                       ProcConvertCooperativeVectorMatrixNV
PtrCopyAccelerationStructureKHR:                           ProcCopyAccelerationStructureKHR
PtrCopyAccelerationStructureToMemoryKHR:                   ProcCopyAccelerationStructureToMemoryKHR
PtrCopyImageToImage:                                       ProcCopyImageToImage
PtrCopyImageToImageEXT:                                    ProcCopyImageToImageEXT
PtrCopyImageToMemory:                                      ProcCopyImageToMemory
PtrCopyImageToMemoryEXT:                                   ProcCopyImageToMemoryEXT
PtrCopyMemoryToAccelerationStructureKHR:                   ProcCopyMemoryToAccelerationStructureKHR
PtrCopyMemoryToImage:                                      ProcCopyMemoryToImage
PtrCopyMemoryToImageEXT:                                   ProcCopyMemoryToImageEXT
PtrCopyMemoryToMicromapEXT:                                ProcCopyMemoryToMicromapEXT
PtrCopyMicromapEXT:                                        ProcCopyMicromapEXT
PtrCopyMicromapToMemoryEXT:                                ProcCopyMicromapToMemoryEXT
PtrCreateAccelerationStructure2KHR:                        ProcCreateAccelerationStructure2KHR
PtrCreateAccelerationStructureKHR:                         ProcCreateAccelerationStructureKHR
PtrCreateAccelerationStructureNV:                          ProcCreateAccelerationStructureNV
PtrCreateBuffer:                                           ProcCreateBuffer
PtrCreateBufferView:                                       ProcCreateBufferView
PtrCreateCommandPool:                                      ProcCreateCommandPool
PtrCreateComputePipelines:                                 ProcCreateComputePipelines
PtrCreateCuFunctionNVX:                                    ProcCreateCuFunctionNVX
PtrCreateCuModuleNVX:                                      ProcCreateCuModuleNVX
PtrCreateCudaFunctionNV:                                   ProcCreateCudaFunctionNV
PtrCreateCudaModuleNV:                                     ProcCreateCudaModuleNV
PtrCreateDataGraphPipelineSessionARM:                      ProcCreateDataGraphPipelineSessionARM
PtrCreateDataGraphPipelinesARM:                            ProcCreateDataGraphPipelinesARM
PtrCreateDeferredOperationKHR:                             ProcCreateDeferredOperationKHR
PtrCreateDescriptorPool:                                   ProcCreateDescriptorPool
PtrCreateDescriptorSetLayout:                              ProcCreateDescriptorSetLayout
PtrCreateDescriptorUpdateTemplate:                         ProcCreateDescriptorUpdateTemplate
PtrCreateDescriptorUpdateTemplateKHR:                      ProcCreateDescriptorUpdateTemplateKHR
PtrCreateEvent:                                            ProcCreateEvent
PtrCreateExecutionGraphPipelinesAMDX:                      ProcCreateExecutionGraphPipelinesAMDX
PtrCreateExternalComputeQueueNV:                           ProcCreateExternalComputeQueueNV
PtrCreateFence:                                            ProcCreateFence
PtrCreateFramebuffer:                                      ProcCreateFramebuffer
PtrCreateGpaSessionAMD:                                    ProcCreateGpaSessionAMD
PtrCreateGraphicsPipelines:                                ProcCreateGraphicsPipelines
PtrCreateImage:                                            ProcCreateImage
PtrCreateImageView:                                        ProcCreateImageView
PtrCreateIndirectCommandsLayoutEXT:                        ProcCreateIndirectCommandsLayoutEXT
PtrCreateIndirectCommandsLayoutNV:                         ProcCreateIndirectCommandsLayoutNV
PtrCreateIndirectExecutionSetEXT:                          ProcCreateIndirectExecutionSetEXT
PtrCreateMicromapEXT:                                      ProcCreateMicromapEXT
PtrCreateOpticalFlowSessionNV:                             ProcCreateOpticalFlowSessionNV
PtrCreatePipelineBinariesKHR:                              ProcCreatePipelineBinariesKHR
PtrCreatePipelineCache:                                    ProcCreatePipelineCache
PtrCreatePipelineLayout:                                   ProcCreatePipelineLayout
PtrCreatePrivateDataSlot:                                  ProcCreatePrivateDataSlot
PtrCreatePrivateDataSlotEXT:                               ProcCreatePrivateDataSlotEXT
PtrCreateQueryPool:                                        ProcCreateQueryPool
PtrCreateRayTracingPipelinesKHR:                           ProcCreateRayTracingPipelinesKHR
PtrCreateRayTracingPipelinesNV:                            ProcCreateRayTracingPipelinesNV
PtrCreateRenderPass:                                       ProcCreateRenderPass
PtrCreateRenderPass2:                                      ProcCreateRenderPass2
PtrCreateRenderPass2KHR:                                   ProcCreateRenderPass2KHR
PtrCreateSampler:                                          ProcCreateSampler
PtrCreateSamplerYcbcrConversion:                           ProcCreateSamplerYcbcrConversion
PtrCreateSamplerYcbcrConversionKHR:                        ProcCreateSamplerYcbcrConversionKHR
PtrCreateSemaphore:                                        ProcCreateSemaphore
PtrCreateShaderInstrumentationARM:                         ProcCreateShaderInstrumentationARM
PtrCreateShaderModule:                                     ProcCreateShaderModule
PtrCreateShadersEXT:                                       ProcCreateShadersEXT
PtrCreateSharedSwapchainsKHR:                              ProcCreateSharedSwapchainsKHR
PtrCreateSwapchainKHR:                                     ProcCreateSwapchainKHR
PtrCreateTensorARM:                                        ProcCreateTensorARM
PtrCreateTensorViewARM:                                    ProcCreateTensorViewARM
PtrCreateValidationCacheEXT:                               ProcCreateValidationCacheEXT
PtrCreateVideoSessionKHR:                                  ProcCreateVideoSessionKHR
PtrCreateVideoSessionParametersKHR:                        ProcCreateVideoSessionParametersKHR
PtrDebugMarkerSetObjectNameEXT:                            ProcDebugMarkerSetObjectNameEXT
PtrDebugMarkerSetObjectTagEXT:                             ProcDebugMarkerSetObjectTagEXT
PtrDeferredOperationJoinKHR:                               ProcDeferredOperationJoinKHR
PtrDestroyAccelerationStructureKHR:                        ProcDestroyAccelerationStructureKHR
PtrDestroyAccelerationStructureNV:                         ProcDestroyAccelerationStructureNV
PtrDestroyBuffer:                                          ProcDestroyBuffer
PtrDestroyBufferView:                                      ProcDestroyBufferView
PtrDestroyCommandPool:                                     ProcDestroyCommandPool
PtrDestroyCuFunctionNVX:                                   ProcDestroyCuFunctionNVX
PtrDestroyCuModuleNVX:                                     ProcDestroyCuModuleNVX
PtrDestroyCudaFunctionNV:                                  ProcDestroyCudaFunctionNV
PtrDestroyCudaModuleNV:                                    ProcDestroyCudaModuleNV
PtrDestroyDataGraphPipelineSessionARM:                     ProcDestroyDataGraphPipelineSessionARM
PtrDestroyDeferredOperationKHR:                            ProcDestroyDeferredOperationKHR
PtrDestroyDescriptorPool:                                  ProcDestroyDescriptorPool
PtrDestroyDescriptorSetLayout:                             ProcDestroyDescriptorSetLayout
PtrDestroyDescriptorUpdateTemplate:                        ProcDestroyDescriptorUpdateTemplate
PtrDestroyDescriptorUpdateTemplateKHR:                     ProcDestroyDescriptorUpdateTemplateKHR
PtrDestroyDevice:                                          ProcDestroyDevice
PtrDestroyEvent:                                           ProcDestroyEvent
PtrDestroyExternalComputeQueueNV:                          ProcDestroyExternalComputeQueueNV
PtrDestroyFence:                                           ProcDestroyFence
PtrDestroyFramebuffer:                                     ProcDestroyFramebuffer
PtrDestroyGpaSessionAMD:                                   ProcDestroyGpaSessionAMD
PtrDestroyImage:                                           ProcDestroyImage
PtrDestroyImageView:                                       ProcDestroyImageView
PtrDestroyIndirectCommandsLayoutEXT:                       ProcDestroyIndirectCommandsLayoutEXT
PtrDestroyIndirectCommandsLayoutNV:                        ProcDestroyIndirectCommandsLayoutNV
PtrDestroyIndirectExecutionSetEXT:                         ProcDestroyIndirectExecutionSetEXT
PtrDestroyMicromapEXT:                                     ProcDestroyMicromapEXT
PtrDestroyOpticalFlowSessionNV:                            ProcDestroyOpticalFlowSessionNV
PtrDestroyPipeline:                                        ProcDestroyPipeline
PtrDestroyPipelineBinaryKHR:                               ProcDestroyPipelineBinaryKHR
PtrDestroyPipelineCache:                                   ProcDestroyPipelineCache
PtrDestroyPipelineLayout:                                  ProcDestroyPipelineLayout
PtrDestroyPrivateDataSlot:                                 ProcDestroyPrivateDataSlot
PtrDestroyPrivateDataSlotEXT:                              ProcDestroyPrivateDataSlotEXT
PtrDestroyQueryPool:                                       ProcDestroyQueryPool
PtrDestroyRenderPass:                                      ProcDestroyRenderPass
PtrDestroySampler:                                         ProcDestroySampler
PtrDestroySamplerYcbcrConversion:                          ProcDestroySamplerYcbcrConversion
PtrDestroySamplerYcbcrConversionKHR:                       ProcDestroySamplerYcbcrConversionKHR
PtrDestroySemaphore:                                       ProcDestroySemaphore
PtrDestroyShaderEXT:                                       ProcDestroyShaderEXT
PtrDestroyShaderInstrumentationARM:                        ProcDestroyShaderInstrumentationARM
PtrDestroyShaderModule:                                    ProcDestroyShaderModule
PtrDestroySwapchainKHR:                                    ProcDestroySwapchainKHR
PtrDestroyTensorARM:                                       ProcDestroyTensorARM
PtrDestroyTensorViewARM:                                   ProcDestroyTensorViewARM
PtrDestroyValidationCacheEXT:                              ProcDestroyValidationCacheEXT
PtrDestroyVideoSessionKHR:                                 ProcDestroyVideoSessionKHR
PtrDestroyVideoSessionParametersKHR:                       ProcDestroyVideoSessionParametersKHR
PtrDeviceWaitIdle:                                         ProcDeviceWaitIdle
PtrDisplayPowerControlEXT:                                 ProcDisplayPowerControlEXT
PtrEndCommandBuffer:                                       ProcEndCommandBuffer
PtrExportMetalObjectsEXT:                                  ProcExportMetalObjectsEXT
PtrFlushMappedMemoryRanges:                                ProcFlushMappedMemoryRanges
PtrFreeCommandBuffers:                                     ProcFreeCommandBuffers
PtrFreeDescriptorSets:                                     ProcFreeDescriptorSets
PtrFreeMemory:                                             ProcFreeMemory
PtrGetAccelerationStructureBuildSizesKHR:                  ProcGetAccelerationStructureBuildSizesKHR
PtrGetAccelerationStructureDeviceAddressKHR:               ProcGetAccelerationStructureDeviceAddressKHR
PtrGetAccelerationStructureHandleNV:                       ProcGetAccelerationStructureHandleNV
PtrGetAccelerationStructureMemoryRequirementsNV:           ProcGetAccelerationStructureMemoryRequirementsNV
PtrGetAccelerationStructureOpaqueCaptureDescriptorDataEXT: ProcGetAccelerationStructureOpaqueCaptureDescriptorDataEXT
PtrGetAndroidHardwareBufferPropertiesANDROID:              ProcGetAndroidHardwareBufferPropertiesANDROID
PtrGetBufferDeviceAddress:                                 ProcGetBufferDeviceAddress
PtrGetBufferDeviceAddressEXT:                              ProcGetBufferDeviceAddressEXT
PtrGetBufferDeviceAddressKHR:                              ProcGetBufferDeviceAddressKHR
PtrGetBufferMemoryRequirements:                            ProcGetBufferMemoryRequirements
PtrGetBufferMemoryRequirements2:                           ProcGetBufferMemoryRequirements2
PtrGetBufferMemoryRequirements2KHR:                        ProcGetBufferMemoryRequirements2KHR
PtrGetBufferOpaqueCaptureAddress:                          ProcGetBufferOpaqueCaptureAddress
PtrGetBufferOpaqueCaptureAddressKHR:                       ProcGetBufferOpaqueCaptureAddressKHR
PtrGetBufferOpaqueCaptureDescriptorDataEXT:                ProcGetBufferOpaqueCaptureDescriptorDataEXT
PtrGetCalibratedTimestampsEXT:                             ProcGetCalibratedTimestampsEXT
PtrGetCalibratedTimestampsKHR:                             ProcGetCalibratedTimestampsKHR
PtrGetClusterAccelerationStructureBuildSizesNV:            ProcGetClusterAccelerationStructureBuildSizesNV
PtrGetCudaModuleCacheNV:                                   ProcGetCudaModuleCacheNV
PtrGetDataGraphPipelineAvailablePropertiesARM:             ProcGetDataGraphPipelineAvailablePropertiesARM
PtrGetDataGraphPipelinePropertiesARM:                      ProcGetDataGraphPipelinePropertiesARM
PtrGetDataGraphPipelineSessionBindPointRequirementsARM:    ProcGetDataGraphPipelineSessionBindPointRequirementsARM
PtrGetDataGraphPipelineSessionMemoryRequirementsARM:       ProcGetDataGraphPipelineSessionMemoryRequirementsARM
PtrGetDeferredOperationMaxConcurrencyKHR:                  ProcGetDeferredOperationMaxConcurrencyKHR
PtrGetDeferredOperationResultKHR:                          ProcGetDeferredOperationResultKHR
PtrGetDescriptorEXT:                                       ProcGetDescriptorEXT
PtrGetDescriptorSetHostMappingVALVE:                       ProcGetDescriptorSetHostMappingVALVE
PtrGetDescriptorSetLayoutBindingOffsetEXT:                 ProcGetDescriptorSetLayoutBindingOffsetEXT
PtrGetDescriptorSetLayoutHostMappingInfoVALVE:             ProcGetDescriptorSetLayoutHostMappingInfoVALVE
PtrGetDescriptorSetLayoutSizeEXT:                          ProcGetDescriptorSetLayoutSizeEXT
PtrGetDescriptorSetLayoutSupport:                          ProcGetDescriptorSetLayoutSupport
PtrGetDescriptorSetLayoutSupportKHR:                       ProcGetDescriptorSetLayoutSupportKHR
PtrGetDeviceAccelerationStructureCompatibilityKHR:         ProcGetDeviceAccelerationStructureCompatibilityKHR
PtrGetDeviceBufferMemoryRequirements:                      ProcGetDeviceBufferMemoryRequirements
PtrGetDeviceBufferMemoryRequirementsKHR:                   ProcGetDeviceBufferMemoryRequirementsKHR
PtrGetDeviceCombinedImageSamplerIndexNVX:                  ProcGetDeviceCombinedImageSamplerIndexNVX
PtrGetDeviceFaultDebugInfoKHR:                             ProcGetDeviceFaultDebugInfoKHR
PtrGetDeviceFaultInfoEXT:                                  ProcGetDeviceFaultInfoEXT
PtrGetDeviceFaultReportsKHR:                               ProcGetDeviceFaultReportsKHR
PtrGetDeviceGroupPeerMemoryFeatures:                       ProcGetDeviceGroupPeerMemoryFeatures
PtrGetDeviceGroupPeerMemoryFeaturesKHR:                    ProcGetDeviceGroupPeerMemoryFeaturesKHR
PtrGetDeviceGroupPresentCapabilitiesKHR:                   ProcGetDeviceGroupPresentCapabilitiesKHR
PtrGetDeviceGroupSurfacePresentModes2EXT:                  ProcGetDeviceGroupSurfacePresentModes2EXT
PtrGetDeviceGroupSurfacePresentModesKHR:                   ProcGetDeviceGroupSurfacePresentModesKHR
PtrGetDeviceImageMemoryRequirements:                       ProcGetDeviceImageMemoryRequirements
PtrGetDeviceImageMemoryRequirementsKHR:                    ProcGetDeviceImageMemoryRequirementsKHR
PtrGetDeviceImageSparseMemoryRequirements:                 ProcGetDeviceImageSparseMemoryRequirements
PtrGetDeviceImageSparseMemoryRequirementsKHR:              ProcGetDeviceImageSparseMemoryRequirementsKHR
PtrGetDeviceImageSubresourceLayout:                        ProcGetDeviceImageSubresourceLayout
PtrGetDeviceImageSubresourceLayoutKHR:                     ProcGetDeviceImageSubresourceLayoutKHR
PtrGetDeviceMemoryCommitment:                              ProcGetDeviceMemoryCommitment
PtrGetDeviceMemoryOpaqueCaptureAddress:                    ProcGetDeviceMemoryOpaqueCaptureAddress
PtrGetDeviceMemoryOpaqueCaptureAddressKHR:                 ProcGetDeviceMemoryOpaqueCaptureAddressKHR
PtrGetDeviceMicromapCompatibilityEXT:                      ProcGetDeviceMicromapCompatibilityEXT
PtrGetDeviceProcAddr:                                      ProcGetDeviceProcAddr
PtrGetDeviceQueue:                                         ProcGetDeviceQueue
PtrGetDeviceQueue2:                                        ProcGetDeviceQueue2
PtrGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI:          ProcGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI
PtrGetDeviceTensorMemoryRequirementsARM:                   ProcGetDeviceTensorMemoryRequirementsARM
PtrGetDynamicRenderingTilePropertiesQCOM:                  ProcGetDynamicRenderingTilePropertiesQCOM
PtrGetEncodedVideoSessionParametersKHR:                    ProcGetEncodedVideoSessionParametersKHR
PtrGetEventStatus:                                         ProcGetEventStatus
PtrGetExecutionGraphPipelineNodeIndexAMDX:                 ProcGetExecutionGraphPipelineNodeIndexAMDX
PtrGetExecutionGraphPipelineScratchSizeAMDX:               ProcGetExecutionGraphPipelineScratchSizeAMDX
PtrGetFenceFdKHR:                                          ProcGetFenceFdKHR
PtrGetFenceStatus:                                         ProcGetFenceStatus
PtrGetFenceWin32HandleKHR:                                 ProcGetFenceWin32HandleKHR
PtrGetFramebufferTilePropertiesQCOM:                       ProcGetFramebufferTilePropertiesQCOM
PtrGetGeneratedCommandsMemoryRequirementsEXT:              ProcGetGeneratedCommandsMemoryRequirementsEXT
PtrGetGeneratedCommandsMemoryRequirementsNV:               ProcGetGeneratedCommandsMemoryRequirementsNV
PtrGetGpaDeviceClockInfoAMD:                               ProcGetGpaDeviceClockInfoAMD
PtrGetGpaSessionResultsAMD:                                ProcGetGpaSessionResultsAMD
PtrGetGpaSessionStatusAMD:                                 ProcGetGpaSessionStatusAMD
PtrGetImageDrmFormatModifierPropertiesEXT:                 ProcGetImageDrmFormatModifierPropertiesEXT
PtrGetImageMemoryRequirements:                             ProcGetImageMemoryRequirements
PtrGetImageMemoryRequirements2:                            ProcGetImageMemoryRequirements2
PtrGetImageMemoryRequirements2KHR:                         ProcGetImageMemoryRequirements2KHR
PtrGetImageOpaqueCaptureDataEXT:                           ProcGetImageOpaqueCaptureDataEXT
PtrGetImageOpaqueCaptureDescriptorDataEXT:                 ProcGetImageOpaqueCaptureDescriptorDataEXT
PtrGetImageSparseMemoryRequirements:                       ProcGetImageSparseMemoryRequirements
PtrGetImageSparseMemoryRequirements2:                      ProcGetImageSparseMemoryRequirements2
PtrGetImageSparseMemoryRequirements2KHR:                   ProcGetImageSparseMemoryRequirements2KHR
PtrGetImageSubresourceLayout:                              ProcGetImageSubresourceLayout
PtrGetImageSubresourceLayout2:                             ProcGetImageSubresourceLayout2
PtrGetImageSubresourceLayout2EXT:                          ProcGetImageSubresourceLayout2EXT
PtrGetImageSubresourceLayout2KHR:                          ProcGetImageSubresourceLayout2KHR
PtrGetImageViewAddressNVX:                                 ProcGetImageViewAddressNVX
PtrGetImageViewHandle64NVX:                                ProcGetImageViewHandle64NVX
PtrGetImageViewHandleNVX:                                  ProcGetImageViewHandleNVX
PtrGetImageViewOpaqueCaptureDescriptorDataEXT:             ProcGetImageViewOpaqueCaptureDescriptorDataEXT
PtrGetLatencyTimingsNV:                                    ProcGetLatencyTimingsNV
PtrGetMemoryAndroidHardwareBufferANDROID:                  ProcGetMemoryAndroidHardwareBufferANDROID
PtrGetMemoryFdKHR:                                         ProcGetMemoryFdKHR
PtrGetMemoryFdPropertiesKHR:                               ProcGetMemoryFdPropertiesKHR
PtrGetMemoryHostPointerPropertiesEXT:                      ProcGetMemoryHostPointerPropertiesEXT
PtrGetMemoryMetalHandleEXT:                                ProcGetMemoryMetalHandleEXT
PtrGetMemoryMetalHandlePropertiesEXT:                      ProcGetMemoryMetalHandlePropertiesEXT
PtrGetMemoryRemoteAddressNV:                               ProcGetMemoryRemoteAddressNV
PtrGetMemoryWin32HandleKHR:                                ProcGetMemoryWin32HandleKHR
PtrGetMemoryWin32HandleNV:                                 ProcGetMemoryWin32HandleNV
PtrGetMemoryWin32HandlePropertiesKHR:                      ProcGetMemoryWin32HandlePropertiesKHR
PtrGetMicromapBuildSizesEXT:                               ProcGetMicromapBuildSizesEXT
PtrGetPartitionedAccelerationStructuresBuildSizesNV:       ProcGetPartitionedAccelerationStructuresBuildSizesNV
PtrGetPastPresentationTimingEXT:                           ProcGetPastPresentationTimingEXT
PtrGetPastPresentationTimingGOOGLE:                        ProcGetPastPresentationTimingGOOGLE
PtrGetPerformanceParameterINTEL:                           ProcGetPerformanceParameterINTEL
PtrGetPipelineBinaryDataKHR:                               ProcGetPipelineBinaryDataKHR
PtrGetPipelineCacheData:                                   ProcGetPipelineCacheData
PtrGetPipelineExecutableInternalRepresentationsKHR:        ProcGetPipelineExecutableInternalRepresentationsKHR
PtrGetPipelineExecutablePropertiesKHR:                     ProcGetPipelineExecutablePropertiesKHR
PtrGetPipelineExecutableStatisticsKHR:                     ProcGetPipelineExecutableStatisticsKHR
PtrGetPipelineIndirectDeviceAddressNV:                     ProcGetPipelineIndirectDeviceAddressNV
PtrGetPipelineIndirectMemoryRequirementsNV:                ProcGetPipelineIndirectMemoryRequirementsNV
PtrGetPipelineKeyKHR:                                      ProcGetPipelineKeyKHR
PtrGetPipelinePropertiesEXT:                               ProcGetPipelinePropertiesEXT
PtrGetPrivateData:                                         ProcGetPrivateData
PtrGetPrivateDataEXT:                                      ProcGetPrivateDataEXT
PtrGetQueryPoolResults:                                    ProcGetQueryPoolResults
PtrGetQueueCheckpointData2NV:                              ProcGetQueueCheckpointData2NV
PtrGetQueueCheckpointDataNV:                               ProcGetQueueCheckpointDataNV
PtrGetRayTracingCaptureReplayShaderGroupHandlesKHR:        ProcGetRayTracingCaptureReplayShaderGroupHandlesKHR
PtrGetRayTracingShaderGroupHandlesKHR:                     ProcGetRayTracingShaderGroupHandlesKHR
PtrGetRayTracingShaderGroupHandlesNV:                      ProcGetRayTracingShaderGroupHandlesNV
PtrGetRayTracingShaderGroupStackSizeKHR:                   ProcGetRayTracingShaderGroupStackSizeKHR
PtrGetRefreshCycleDurationGOOGLE:                          ProcGetRefreshCycleDurationGOOGLE
PtrGetRenderAreaGranularity:                               ProcGetRenderAreaGranularity
PtrGetRenderingAreaGranularity:                            ProcGetRenderingAreaGranularity
PtrGetRenderingAreaGranularityKHR:                         ProcGetRenderingAreaGranularityKHR
PtrGetSamplerOpaqueCaptureDescriptorDataEXT:               ProcGetSamplerOpaqueCaptureDescriptorDataEXT
PtrGetSemaphoreCounterValue:                               ProcGetSemaphoreCounterValue
PtrGetSemaphoreCounterValueKHR:                            ProcGetSemaphoreCounterValueKHR
PtrGetSemaphoreFdKHR:                                      ProcGetSemaphoreFdKHR
PtrGetSemaphoreWin32HandleKHR:                             ProcGetSemaphoreWin32HandleKHR
PtrGetShaderBinaryDataEXT:                                 ProcGetShaderBinaryDataEXT
PtrGetShaderInfoAMD:                                       ProcGetShaderInfoAMD
PtrGetShaderInstrumentationValuesARM:                      ProcGetShaderInstrumentationValuesARM
PtrGetShaderModuleCreateInfoIdentifierEXT:                 ProcGetShaderModuleCreateInfoIdentifierEXT
PtrGetShaderModuleIdentifierEXT:                           ProcGetShaderModuleIdentifierEXT
PtrGetSwapchainCounterEXT:                                 ProcGetSwapchainCounterEXT
PtrGetSwapchainImagesKHR:                                  ProcGetSwapchainImagesKHR
PtrGetSwapchainStatusKHR:                                  ProcGetSwapchainStatusKHR
PtrGetSwapchainTimeDomainPropertiesEXT:                    ProcGetSwapchainTimeDomainPropertiesEXT
PtrGetSwapchainTimingPropertiesEXT:                        ProcGetSwapchainTimingPropertiesEXT
PtrGetTensorMemoryRequirementsARM:                         ProcGetTensorMemoryRequirementsARM
PtrGetTensorOpaqueCaptureDataARM:                          ProcGetTensorOpaqueCaptureDataARM
PtrGetTensorOpaqueCaptureDescriptorDataARM:                ProcGetTensorOpaqueCaptureDescriptorDataARM
PtrGetTensorViewOpaqueCaptureDescriptorDataARM:            ProcGetTensorViewOpaqueCaptureDescriptorDataARM
PtrGetValidationCacheDataEXT:                              ProcGetValidationCacheDataEXT
PtrGetVideoSessionMemoryRequirementsKHR:                   ProcGetVideoSessionMemoryRequirementsKHR
PtrImportFenceFdKHR:                                       ProcImportFenceFdKHR
PtrImportFenceWin32HandleKHR:                              ProcImportFenceWin32HandleKHR
PtrImportSemaphoreFdKHR:                                   ProcImportSemaphoreFdKHR
PtrImportSemaphoreWin32HandleKHR:                          ProcImportSemaphoreWin32HandleKHR
PtrInitializePerformanceApiINTEL:                          ProcInitializePerformanceApiINTEL
PtrInvalidateMappedMemoryRanges:                           ProcInvalidateMappedMemoryRanges
PtrLatencySleepNV:                                         ProcLatencySleepNV
PtrMapMemory:                                              ProcMapMemory
PtrMapMemory2:                                             ProcMapMemory2
PtrMapMemory2KHR:                                          ProcMapMemory2KHR
PtrMergePipelineCaches:                                    ProcMergePipelineCaches
PtrMergeValidationCachesEXT:                               ProcMergeValidationCachesEXT
PtrQueueBeginDebugUtilsLabelEXT:                           ProcQueueBeginDebugUtilsLabelEXT
PtrQueueBindSparse:                                        ProcQueueBindSparse
PtrQueueEndDebugUtilsLabelEXT:                             ProcQueueEndDebugUtilsLabelEXT
PtrQueueInsertDebugUtilsLabelEXT:                          ProcQueueInsertDebugUtilsLabelEXT
PtrQueueNotifyOutOfBandNV:                                 ProcQueueNotifyOutOfBandNV
PtrQueuePresentKHR:                                        ProcQueuePresentKHR
PtrQueueSetPerformanceConfigurationINTEL:                  ProcQueueSetPerformanceConfigurationINTEL
PtrQueueSubmit:                                            ProcQueueSubmit
PtrQueueSubmit2:                                           ProcQueueSubmit2
PtrQueueSubmit2KHR:                                        ProcQueueSubmit2KHR
PtrQueueWaitIdle:                                          ProcQueueWaitIdle
PtrRegisterCustomBorderColorEXT:                           ProcRegisterCustomBorderColorEXT
PtrRegisterDeviceEventEXT:                                 ProcRegisterDeviceEventEXT
PtrRegisterDisplayEventEXT:                                ProcRegisterDisplayEventEXT
PtrReleaseCapturedPipelineDataKHR:                         ProcReleaseCapturedPipelineDataKHR
PtrReleaseFullScreenExclusiveModeEXT:                      ProcReleaseFullScreenExclusiveModeEXT
PtrReleasePerformanceConfigurationINTEL:                   ProcReleasePerformanceConfigurationINTEL
PtrReleaseProfilingLockKHR:                                ProcReleaseProfilingLockKHR
PtrReleaseSwapchainImagesEXT:                              ProcReleaseSwapchainImagesEXT
PtrReleaseSwapchainImagesKHR:                              ProcReleaseSwapchainImagesKHR
PtrResetCommandBuffer:                                     ProcResetCommandBuffer
PtrResetCommandPool:                                       ProcResetCommandPool
PtrResetDescriptorPool:                                    ProcResetDescriptorPool
PtrResetEvent:                                             ProcResetEvent
PtrResetFences:                                            ProcResetFences
PtrResetGpaSessionAMD:                                     ProcResetGpaSessionAMD
PtrResetQueryPool:                                         ProcResetQueryPool
PtrResetQueryPoolEXT:                                      ProcResetQueryPoolEXT
PtrSetDebugUtilsObjectNameEXT:                             ProcSetDebugUtilsObjectNameEXT
PtrSetDebugUtilsObjectTagEXT:                              ProcSetDebugUtilsObjectTagEXT
PtrSetDeviceMemoryPriorityEXT:                             ProcSetDeviceMemoryPriorityEXT
PtrSetEvent:                                               ProcSetEvent
PtrSetGpaDeviceClockModeAMD:                               ProcSetGpaDeviceClockModeAMD
PtrSetHdrMetadataEXT:                                      ProcSetHdrMetadataEXT
PtrSetLatencyMarkerNV:                                     ProcSetLatencyMarkerNV
PtrSetLatencySleepModeNV:                                  ProcSetLatencySleepModeNV
PtrSetLocalDimmingAMD:                                     ProcSetLocalDimmingAMD
PtrSetPrivateData:                                         ProcSetPrivateData
PtrSetPrivateDataEXT:                                      ProcSetPrivateDataEXT
PtrSetSwapchainPresentTimingQueueSizeEXT:                  ProcSetSwapchainPresentTimingQueueSizeEXT
PtrSignalSemaphore:                                        ProcSignalSemaphore
PtrSignalSemaphoreKHR:                                     ProcSignalSemaphoreKHR
PtrTransitionImageLayout:                                  ProcTransitionImageLayout
PtrTransitionImageLayoutEXT:                               ProcTransitionImageLayoutEXT
PtrTrimCommandPool:                                        ProcTrimCommandPool
PtrTrimCommandPoolKHR:                                     ProcTrimCommandPoolKHR
PtrUninitializePerformanceApiINTEL:                        ProcUninitializePerformanceApiINTEL
PtrUnmapMemory:                                            ProcUnmapMemory
PtrUnmapMemory2:                                           ProcUnmapMemory2
PtrUnmapMemory2KHR:                                        ProcUnmapMemory2KHR
PtrUnregisterCustomBorderColorEXT:                         ProcUnregisterCustomBorderColorEXT
PtrUpdateDescriptorSetWithTemplate:                        ProcUpdateDescriptorSetWithTemplate
PtrUpdateDescriptorSetWithTemplateKHR:                     ProcUpdateDescriptorSetWithTemplateKHR
PtrUpdateDescriptorSets:                                   ProcUpdateDescriptorSets
PtrUpdateIndirectExecutionSetPipelineEXT:                  ProcUpdateIndirectExecutionSetPipelineEXT
PtrUpdateIndirectExecutionSetShaderEXT:                    ProcUpdateIndirectExecutionSetShaderEXT
PtrUpdateVideoSessionParametersKHR:                        ProcUpdateVideoSessionParametersKHR
PtrWaitForFences:                                          ProcWaitForFences
PtrWaitForPresent2KHR:                                     ProcWaitForPresent2KHR
PtrWaitForPresentKHR:                                      ProcWaitForPresentKHR
PtrWaitSemaphores:                                         ProcWaitSemaphores
PtrWaitSemaphoresKHR:                                      ProcWaitSemaphoresKHR
PtrWriteAccelerationStructuresPropertiesKHR:               ProcWriteAccelerationStructuresPropertiesKHR
PtrWriteMicromapsPropertiesEXT:                            ProcWriteMicromapsPropertiesEXT
PtrWriteResourceDescriptorsEXT:                            ProcWriteResourceDescriptorsEXT
PtrWriteSamplerDescriptorsEXT:                             ProcWriteSamplerDescriptorsEXT

// Loader Procedures (public API wrappers)
CreateInstance                       :: #force_inline proc "system" (pCreateInfo: ^InstanceCreateInfo, pAllocator: ^AllocationCallbacks, pInstance: ^Instance) -> Result { return PtrCreateInstance(pCreateInfo, pAllocator, pInstance) }
DebugUtilsMessengerCallbackEXT       :: #force_inline proc "system" (messageSeverity: DebugUtilsMessageSeverityFlagsEXT, messageTypes: DebugUtilsMessageTypeFlagsEXT, pCallbackData: ^DebugUtilsMessengerCallbackDataEXT, pUserData: rawptr) -> b32 { return PtrDebugUtilsMessengerCallbackEXT(messageSeverity, messageTypes, pCallbackData, pUserData) }
DeviceMemoryReportCallbackEXT        :: #force_inline proc "system" (pCallbackData: ^DeviceMemoryReportCallbackDataEXT, pUserData: rawptr) { PtrDeviceMemoryReportCallbackEXT(pCallbackData, pUserData) }
EnumerateInstanceExtensionProperties :: #force_inline proc "system" (pLayerName: cstring, pPropertyCount: ^u32, pProperties: [^]ExtensionProperties) -> Result { return PtrEnumerateInstanceExtensionProperties(pLayerName, pPropertyCount, pProperties) }
EnumerateInstanceLayerProperties     :: #force_inline proc "system" (pPropertyCount: ^u32, pProperties: [^]LayerProperties) -> Result { return PtrEnumerateInstanceLayerProperties(pPropertyCount, pProperties) }
EnumerateInstanceVersion             :: #force_inline proc "system" (pApiVersion: ^u32) -> Result { return PtrEnumerateInstanceVersion(pApiVersion) }
GetExternalComputeQueueDataNV        :: #force_inline proc "system" (externalQueue: ExternalComputeQueueNV, params: [^]ExternalComputeQueueDataParamsNV, pData: rawptr) { PtrGetExternalComputeQueueDataNV(externalQueue, params, pData) }
GetInstanceProcAddr                  :: #force_inline proc "system" (instance: Instance, pName: cstring) -> ProcVoidFunction { return PtrGetInstanceProcAddr(instance, pName) }

// Instance Procedures (public API wrappers)
AcquireDrmDisplayEXT                                               :: #force_inline proc "system" (physicalDevice: PhysicalDevice, drmFd: i32, display: DisplayKHR) -> Result { return PtrAcquireDrmDisplayEXT(physicalDevice, drmFd, display) }
AcquireWinrtDisplayNV                                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR) -> Result { return PtrAcquireWinrtDisplayNV(physicalDevice, display) }
CreateAndroidSurfaceKHR                                            :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^AndroidSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateAndroidSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
CreateDebugReportCallbackEXT                                       :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^DebugReportCallbackCreateInfoEXT, pAllocator: ^AllocationCallbacks, pCallback: ^DebugReportCallbackEXT) -> Result { return PtrCreateDebugReportCallbackEXT(instance, pCreateInfo, pAllocator, pCallback) }
CreateDebugUtilsMessengerEXT                                       :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^DebugUtilsMessengerCreateInfoEXT, pAllocator: ^AllocationCallbacks, pMessenger: ^DebugUtilsMessengerEXT) -> Result { return PtrCreateDebugUtilsMessengerEXT(instance, pCreateInfo, pAllocator, pMessenger) }
CreateDevice                                                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pCreateInfo: ^DeviceCreateInfo, pAllocator: ^AllocationCallbacks, pDevice: ^Device) -> Result { return PtrCreateDevice(physicalDevice, pCreateInfo, pAllocator, pDevice) }
CreateDisplayModeKHR                                               :: #force_inline proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pCreateInfo: ^DisplayModeCreateInfoKHR, pAllocator: ^AllocationCallbacks, pMode: ^DisplayModeKHR) -> Result { return PtrCreateDisplayModeKHR(physicalDevice, display, pCreateInfo, pAllocator, pMode) }
CreateDisplayPlaneSurfaceKHR                                       :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^DisplaySurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateDisplayPlaneSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
CreateHeadlessSurfaceEXT                                           :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^HeadlessSurfaceCreateInfoEXT, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateHeadlessSurfaceEXT(instance, pCreateInfo, pAllocator, pSurface) }
CreateIOSSurfaceMVK                                                :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^IOSSurfaceCreateInfoMVK, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateIOSSurfaceMVK(instance, pCreateInfo, pAllocator, pSurface) }
CreateMacOSSurfaceMVK                                              :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^MacOSSurfaceCreateInfoMVK, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateMacOSSurfaceMVK(instance, pCreateInfo, pAllocator, pSurface) }
CreateMetalSurfaceEXT                                              :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^MetalSurfaceCreateInfoEXT, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateMetalSurfaceEXT(instance, pCreateInfo, pAllocator, pSurface) }
CreateWaylandSurfaceKHR                                            :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^WaylandSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateWaylandSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
CreateWin32SurfaceKHR                                              :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^Win32SurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateWin32SurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
CreateXcbSurfaceKHR                                                :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^XcbSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateXcbSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
CreateXlibSurfaceKHR                                               :: #force_inline proc "system" (instance: Instance, pCreateInfo: ^XlibSurfaceCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSurface: ^SurfaceKHR) -> Result { return PtrCreateXlibSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface) }
DebugReportMessageEXT                                              :: #force_inline proc "system" (instance: Instance, flags: DebugReportFlagsEXT, objectType: DebugReportObjectTypeEXT, object: u64, location: int, messageCode: i32, pLayerPrefix: cstring, pMessage: cstring) { PtrDebugReportMessageEXT(instance, flags, objectType, object, location, messageCode, pLayerPrefix, pMessage) }
DestroyDebugReportCallbackEXT                                      :: #force_inline proc "system" (instance: Instance, callback: DebugReportCallbackEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyDebugReportCallbackEXT(instance, callback, pAllocator) }
DestroyDebugUtilsMessengerEXT                                      :: #force_inline proc "system" (instance: Instance, messenger: DebugUtilsMessengerEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyDebugUtilsMessengerEXT(instance, messenger, pAllocator) }
DestroyInstance                                                    :: #force_inline proc "system" (instance: Instance, pAllocator: ^AllocationCallbacks) { PtrDestroyInstance(instance, pAllocator) }
DestroySurfaceKHR                                                  :: #force_inline proc "system" (instance: Instance, surface: SurfaceKHR, pAllocator: ^AllocationCallbacks) { PtrDestroySurfaceKHR(instance, surface, pAllocator) }
EnumerateDeviceExtensionProperties                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pLayerName: cstring, pPropertyCount: ^u32, pProperties: [^]ExtensionProperties) -> Result { return PtrEnumerateDeviceExtensionProperties(physicalDevice, pLayerName, pPropertyCount, pProperties) }
EnumerateDeviceLayerProperties                                     :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]LayerProperties) -> Result { return PtrEnumerateDeviceLayerProperties(physicalDevice, pPropertyCount, pProperties) }
EnumeratePhysicalDeviceGroups                                      :: #force_inline proc "system" (instance: Instance, pPhysicalDeviceGroupCount: ^u32, pPhysicalDeviceGroupProperties: [^]PhysicalDeviceGroupProperties) -> Result { return PtrEnumeratePhysicalDeviceGroups(instance, pPhysicalDeviceGroupCount, pPhysicalDeviceGroupProperties) }
EnumeratePhysicalDeviceGroupsKHR                                   :: #force_inline proc "system" (instance: Instance, pPhysicalDeviceGroupCount: ^u32, pPhysicalDeviceGroupProperties: [^]PhysicalDeviceGroupProperties) -> Result { return PtrEnumeratePhysicalDeviceGroupsKHR(instance, pPhysicalDeviceGroupCount, pPhysicalDeviceGroupProperties) }
EnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM   :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pCounterCount: ^u32, pCounters: [^]PerformanceCounterARM, pCounterDescriptions: [^]PerformanceCounterDescriptionARM) -> Result { return PtrEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM(physicalDevice, queueFamilyIndex, pCounterCount, pCounters, pCounterDescriptions) }
EnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR      :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pCounterCount: ^u32, pCounters: [^]PerformanceCounterKHR, pCounterDescriptions: [^]PerformanceCounterDescriptionKHR) -> Result { return PtrEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(physicalDevice, queueFamilyIndex, pCounterCount, pCounters, pCounterDescriptions) }
EnumeratePhysicalDeviceShaderInstrumentationMetricsARM             :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pDescriptionCount: ^u32, pDescriptions: [^]ShaderInstrumentationMetricDescriptionARM) -> Result { return PtrEnumeratePhysicalDeviceShaderInstrumentationMetricsARM(physicalDevice, pDescriptionCount, pDescriptions) }
EnumeratePhysicalDevices                                           :: #force_inline proc "system" (instance: Instance, pPhysicalDeviceCount: ^u32, pPhysicalDevices: [^]PhysicalDevice) -> Result { return PtrEnumeratePhysicalDevices(instance, pPhysicalDeviceCount, pPhysicalDevices) }
GetDisplayModeProperties2KHR                                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pPropertyCount: ^u32, pProperties: [^]DisplayModeProperties2KHR) -> Result { return PtrGetDisplayModeProperties2KHR(physicalDevice, display, pPropertyCount, pProperties) }
GetDisplayModePropertiesKHR                                        :: #force_inline proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR, pPropertyCount: ^u32, pProperties: [^]DisplayModePropertiesKHR) -> Result { return PtrGetDisplayModePropertiesKHR(physicalDevice, display, pPropertyCount, pProperties) }
GetDisplayPlaneCapabilities2KHR                                    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pDisplayPlaneInfo: ^DisplayPlaneInfo2KHR, pCapabilities: [^]DisplayPlaneCapabilities2KHR) -> Result { return PtrGetDisplayPlaneCapabilities2KHR(physicalDevice, pDisplayPlaneInfo, pCapabilities) }
GetDisplayPlaneCapabilitiesKHR                                     :: #force_inline proc "system" (physicalDevice: PhysicalDevice, mode: DisplayModeKHR, planeIndex: u32, pCapabilities: [^]DisplayPlaneCapabilitiesKHR) -> Result { return PtrGetDisplayPlaneCapabilitiesKHR(physicalDevice, mode, planeIndex, pCapabilities) }
GetDisplayPlaneSupportedDisplaysKHR                                :: #force_inline proc "system" (physicalDevice: PhysicalDevice, planeIndex: u32, pDisplayCount: ^u32, pDisplays: [^]DisplayKHR) -> Result { return PtrGetDisplayPlaneSupportedDisplaysKHR(physicalDevice, planeIndex, pDisplayCount, pDisplays) }
GetDrmDisplayEXT                                                   :: #force_inline proc "system" (physicalDevice: PhysicalDevice, drmFd: i32, connectorId: u32, display: ^DisplayKHR) -> Result { return PtrGetDrmDisplayEXT(physicalDevice, drmFd, connectorId, display) }
GetInstanceProcAddrLUNARG                                          :: #force_inline proc "system" (instance: Instance, pName: cstring) -> ProcVoidFunction { return PtrGetInstanceProcAddrLUNARG(instance, pName) }
GetPhysicalDeviceCalibrateableTimeDomainsEXT                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pTimeDomainCount: ^u32, pTimeDomains: [^]TimeDomainKHR) -> Result { return PtrGetPhysicalDeviceCalibrateableTimeDomainsEXT(physicalDevice, pTimeDomainCount, pTimeDomains) }
GetPhysicalDeviceCalibrateableTimeDomainsKHR                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pTimeDomainCount: ^u32, pTimeDomains: [^]TimeDomainKHR) -> Result { return PtrGetPhysicalDeviceCalibrateableTimeDomainsKHR(physicalDevice, pTimeDomainCount, pTimeDomains) }
GetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV   :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixFlexibleDimensionsPropertiesNV) -> Result { return PtrGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceCooperativeMatrixPropertiesKHR                    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixPropertiesKHR) -> Result { return PtrGetPhysicalDeviceCooperativeMatrixPropertiesKHR(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceCooperativeMatrixPropertiesNV                     :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeMatrixPropertiesNV) -> Result { return PtrGetPhysicalDeviceCooperativeMatrixPropertiesNV(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceCooperativeVectorPropertiesNV                     :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]CooperativeVectorPropertiesNV) -> Result { return PtrGetPhysicalDeviceCooperativeVectorPropertiesNV(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceDescriptorSizeEXT                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, descriptorType: DescriptorType) -> DeviceSize { return PtrGetPhysicalDeviceDescriptorSizeEXT(physicalDevice, descriptorType) }
GetPhysicalDeviceDisplayPlaneProperties2KHR                        :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPlaneProperties2KHR) -> Result { return PtrGetPhysicalDeviceDisplayPlaneProperties2KHR(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceDisplayPlanePropertiesKHR                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPlanePropertiesKHR) -> Result { return PtrGetPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceDisplayProperties2KHR                             :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayProperties2KHR) -> Result { return PtrGetPhysicalDeviceDisplayProperties2KHR(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceDisplayPropertiesKHR                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPropertyCount: ^u32, pProperties: [^]DisplayPropertiesKHR) -> Result { return PtrGetPhysicalDeviceDisplayPropertiesKHR(physicalDevice, pPropertyCount, pProperties) }
GetPhysicalDeviceExternalBufferProperties                          :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalBufferInfo: ^PhysicalDeviceExternalBufferInfo, pExternalBufferProperties: [^]ExternalBufferProperties) { PtrGetPhysicalDeviceExternalBufferProperties(physicalDevice, pExternalBufferInfo, pExternalBufferProperties) }
GetPhysicalDeviceExternalBufferPropertiesKHR                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalBufferInfo: ^PhysicalDeviceExternalBufferInfo, pExternalBufferProperties: [^]ExternalBufferProperties) { PtrGetPhysicalDeviceExternalBufferPropertiesKHR(physicalDevice, pExternalBufferInfo, pExternalBufferProperties) }
GetPhysicalDeviceExternalFenceProperties                           :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalFenceInfo: ^PhysicalDeviceExternalFenceInfo, pExternalFenceProperties: [^]ExternalFenceProperties) { PtrGetPhysicalDeviceExternalFenceProperties(physicalDevice, pExternalFenceInfo, pExternalFenceProperties) }
GetPhysicalDeviceExternalFencePropertiesKHR                        :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalFenceInfo: ^PhysicalDeviceExternalFenceInfo, pExternalFenceProperties: [^]ExternalFenceProperties) { PtrGetPhysicalDeviceExternalFencePropertiesKHR(physicalDevice, pExternalFenceInfo, pExternalFenceProperties) }
GetPhysicalDeviceExternalImageFormatPropertiesNV                   :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, tiling: ImageTiling, usage: ImageUsageFlags, flags: ImageCreateFlags, externalHandleType: ExternalMemoryHandleTypeFlagsNV, pExternalImageFormatProperties: [^]ExternalImageFormatPropertiesNV) -> Result { return PtrGetPhysicalDeviceExternalImageFormatPropertiesNV(physicalDevice, format, type, tiling, usage, flags, externalHandleType, pExternalImageFormatProperties) }
GetPhysicalDeviceExternalSemaphoreProperties                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalSemaphoreInfo: ^PhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: [^]ExternalSemaphoreProperties) { PtrGetPhysicalDeviceExternalSemaphoreProperties(physicalDevice, pExternalSemaphoreInfo, pExternalSemaphoreProperties) }
GetPhysicalDeviceExternalSemaphorePropertiesKHR                    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalSemaphoreInfo: ^PhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: [^]ExternalSemaphoreProperties) { PtrGetPhysicalDeviceExternalSemaphorePropertiesKHR(physicalDevice, pExternalSemaphoreInfo, pExternalSemaphoreProperties) }
GetPhysicalDeviceExternalTensorPropertiesARM                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pExternalTensorInfo: ^PhysicalDeviceExternalTensorInfoARM, pExternalTensorProperties: [^]ExternalTensorPropertiesARM) { PtrGetPhysicalDeviceExternalTensorPropertiesARM(physicalDevice, pExternalTensorInfo, pExternalTensorProperties) }
GetPhysicalDeviceFeatures                                          :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures) { PtrGetPhysicalDeviceFeatures(physicalDevice, pFeatures) }
GetPhysicalDeviceFeatures2                                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures2) { PtrGetPhysicalDeviceFeatures2(physicalDevice, pFeatures) }
GetPhysicalDeviceFeatures2KHR                                      :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFeatures: [^]PhysicalDeviceFeatures2) { PtrGetPhysicalDeviceFeatures2KHR(physicalDevice, pFeatures) }
GetPhysicalDeviceFormatProperties                                  :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties) { PtrGetPhysicalDeviceFormatProperties(physicalDevice, format, pFormatProperties) }
GetPhysicalDeviceFormatProperties2                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties2) { PtrGetPhysicalDeviceFormatProperties2(physicalDevice, format, pFormatProperties) }
GetPhysicalDeviceFormatProperties2KHR                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, pFormatProperties: [^]FormatProperties2) { PtrGetPhysicalDeviceFormatProperties2KHR(physicalDevice, format, pFormatProperties) }
GetPhysicalDeviceFragmentShadingRatesKHR                           :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFragmentShadingRateCount: ^u32, pFragmentShadingRates: [^]PhysicalDeviceFragmentShadingRateKHR) -> Result { return PtrGetPhysicalDeviceFragmentShadingRatesKHR(physicalDevice, pFragmentShadingRateCount, pFragmentShadingRates) }
GetPhysicalDeviceImageFormatProperties                             :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, tiling: ImageTiling, usage: ImageUsageFlags, flags: ImageCreateFlags, pImageFormatProperties: [^]ImageFormatProperties) -> Result { return PtrGetPhysicalDeviceImageFormatProperties(physicalDevice, format, type, tiling, usage, flags, pImageFormatProperties) }
GetPhysicalDeviceImageFormatProperties2                            :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pImageFormatInfo: ^PhysicalDeviceImageFormatInfo2, pImageFormatProperties: [^]ImageFormatProperties2) -> Result { return PtrGetPhysicalDeviceImageFormatProperties2(physicalDevice, pImageFormatInfo, pImageFormatProperties) }
GetPhysicalDeviceImageFormatProperties2KHR                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pImageFormatInfo: ^PhysicalDeviceImageFormatInfo2, pImageFormatProperties: [^]ImageFormatProperties2) -> Result { return PtrGetPhysicalDeviceImageFormatProperties2KHR(physicalDevice, pImageFormatInfo, pImageFormatProperties) }
GetPhysicalDeviceMemoryProperties                                  :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties) { PtrGetPhysicalDeviceMemoryProperties(physicalDevice, pMemoryProperties) }
GetPhysicalDeviceMemoryProperties2                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties2) { PtrGetPhysicalDeviceMemoryProperties2(physicalDevice, pMemoryProperties) }
GetPhysicalDeviceMemoryProperties2KHR                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pMemoryProperties: [^]PhysicalDeviceMemoryProperties2) { PtrGetPhysicalDeviceMemoryProperties2KHR(physicalDevice, pMemoryProperties) }
GetPhysicalDeviceMultisamplePropertiesEXT                          :: #force_inline proc "system" (physicalDevice: PhysicalDevice, samples: SampleCountFlags, pMultisampleProperties: [^]MultisamplePropertiesEXT) { PtrGetPhysicalDeviceMultisamplePropertiesEXT(physicalDevice, samples, pMultisampleProperties) }
GetPhysicalDeviceOpticalFlowImageFormatsNV                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pOpticalFlowImageFormatInfo: ^OpticalFlowImageFormatInfoNV, pFormatCount: ^u32, pImageFormatProperties: [^]OpticalFlowImageFormatPropertiesNV) -> Result { return PtrGetPhysicalDeviceOpticalFlowImageFormatsNV(physicalDevice, pOpticalFlowImageFormatInfo, pFormatCount, pImageFormatProperties) }
GetPhysicalDevicePresentRectanglesKHR                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pRectCount: ^u32, pRects: [^]Rect2D) -> Result { return PtrGetPhysicalDevicePresentRectanglesKHR(physicalDevice, surface, pRectCount, pRects) }
GetPhysicalDeviceProperties                                        :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties) { PtrGetPhysicalDeviceProperties(physicalDevice, pProperties) }
GetPhysicalDeviceProperties2                                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties2) { PtrGetPhysicalDeviceProperties2(physicalDevice, pProperties) }
GetPhysicalDeviceProperties2KHR                                    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pProperties: [^]PhysicalDeviceProperties2) { PtrGetPhysicalDeviceProperties2KHR(physicalDevice, pProperties) }
GetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM  :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM, pProperties: [^]BaseOutStructure) -> Result { return PtrGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM(physicalDevice, queueFamilyIndex, pQueueFamilyDataGraphProperties, pProperties) }
GetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM, pOpticalFlowImageFormatInfo: ^DataGraphOpticalFlowImageFormatInfoARM, pFormatCount: ^u32, pImageFormatProperties: [^]DataGraphOpticalFlowImageFormatPropertiesARM) -> Result { return PtrGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM(physicalDevice, queueFamilyIndex, pQueueFamilyDataGraphProperties, pOpticalFlowImageFormatInfo, pFormatCount, pImageFormatProperties) }
GetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyDataGraphProcessingEngineInfo: ^PhysicalDeviceQueueFamilyDataGraphProcessingEngineInfoARM, pQueueFamilyDataGraphProcessingEngineProperties: [^]QueueFamilyDataGraphProcessingEnginePropertiesARM) { PtrGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM(physicalDevice, pQueueFamilyDataGraphProcessingEngineInfo, pQueueFamilyDataGraphProcessingEngineProperties) }
GetPhysicalDeviceQueueFamilyDataGraphPropertiesARM                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, pQueueFamilyDataGraphPropertyCount: ^u32, pQueueFamilyDataGraphProperties: [^]QueueFamilyDataGraphPropertiesARM) -> Result { return PtrGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM(physicalDevice, queueFamilyIndex, pQueueFamilyDataGraphPropertyCount, pQueueFamilyDataGraphProperties) }
GetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pPerformanceQueryCreateInfo: ^QueryPoolPerformanceCreateInfoKHR, pNumPasses: [^]u32) { PtrGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(physicalDevice, pPerformanceQueryCreateInfo, pNumPasses) }
GetPhysicalDeviceQueueFamilyProperties                             :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties) { PtrGetPhysicalDeviceQueueFamilyProperties(physicalDevice, pQueueFamilyPropertyCount, pQueueFamilyProperties) }
GetPhysicalDeviceQueueFamilyProperties2                            :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties2) { PtrGetPhysicalDeviceQueueFamilyProperties2(physicalDevice, pQueueFamilyPropertyCount, pQueueFamilyProperties) }
GetPhysicalDeviceQueueFamilyProperties2KHR                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: ^u32, pQueueFamilyProperties: [^]QueueFamilyProperties2) { PtrGetPhysicalDeviceQueueFamilyProperties2KHR(physicalDevice, pQueueFamilyPropertyCount, pQueueFamilyProperties) }
GetPhysicalDeviceSparseImageFormatProperties                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, format: Format, type: ImageType, samples: SampleCountFlags, usage: ImageUsageFlags, tiling: ImageTiling, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties) { PtrGetPhysicalDeviceSparseImageFormatProperties(physicalDevice, format, type, samples, usage, tiling, pPropertyCount, pProperties) }
GetPhysicalDeviceSparseImageFormatProperties2                      :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFormatInfo: ^PhysicalDeviceSparseImageFormatInfo2, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties2) { PtrGetPhysicalDeviceSparseImageFormatProperties2(physicalDevice, pFormatInfo, pPropertyCount, pProperties) }
GetPhysicalDeviceSparseImageFormatProperties2KHR                   :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pFormatInfo: ^PhysicalDeviceSparseImageFormatInfo2, pPropertyCount: ^u32, pProperties: [^]SparseImageFormatProperties2) { PtrGetPhysicalDeviceSparseImageFormatProperties2KHR(physicalDevice, pFormatInfo, pPropertyCount, pProperties) }
GetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pCombinationCount: ^u32, pCombinations: [^]FramebufferMixedSamplesCombinationNV) -> Result { return PtrGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physicalDevice, pCombinationCount, pCombinations) }
GetPhysicalDeviceSurfaceCapabilities2EXT                           :: #force_inline proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceCapabilities: [^]SurfaceCapabilities2EXT) -> Result { return PtrGetPhysicalDeviceSurfaceCapabilities2EXT(physicalDevice, surface, pSurfaceCapabilities) }
GetPhysicalDeviceSurfaceCapabilities2KHR                           :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pSurfaceCapabilities: [^]SurfaceCapabilities2KHR) -> Result { return PtrGetPhysicalDeviceSurfaceCapabilities2KHR(physicalDevice, pSurfaceInfo, pSurfaceCapabilities) }
GetPhysicalDeviceSurfaceCapabilitiesKHR                            :: #force_inline proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceCapabilities: [^]SurfaceCapabilitiesKHR) -> Result { return PtrGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, pSurfaceCapabilities) }
GetPhysicalDeviceSurfaceFormats2KHR                                :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pSurfaceFormatCount: ^u32, pSurfaceFormats: [^]SurfaceFormat2KHR) -> Result { return PtrGetPhysicalDeviceSurfaceFormats2KHR(physicalDevice, pSurfaceInfo, pSurfaceFormatCount, pSurfaceFormats) }
GetPhysicalDeviceSurfaceFormatsKHR                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pSurfaceFormatCount: ^u32, pSurfaceFormats: [^]SurfaceFormatKHR) -> Result { return PtrGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, pSurfaceFormatCount, pSurfaceFormats) }
GetPhysicalDeviceSurfacePresentModes2EXT                           :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pPresentModeCount: ^u32, pPresentModes: [^]PresentModeKHR) -> Result { return PtrGetPhysicalDeviceSurfacePresentModes2EXT(physicalDevice, pSurfaceInfo, pPresentModeCount, pPresentModes) }
GetPhysicalDeviceSurfacePresentModesKHR                            :: #force_inline proc "system" (physicalDevice: PhysicalDevice, surface: SurfaceKHR, pPresentModeCount: ^u32, pPresentModes: [^]PresentModeKHR) -> Result { return PtrGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, pPresentModeCount, pPresentModes) }
GetPhysicalDeviceSurfaceSupportKHR                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, surface: SurfaceKHR, pSupported: ^b32) -> Result { return PtrGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, queueFamilyIndex, surface, pSupported) }
GetPhysicalDeviceToolProperties                                    :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pToolCount: ^u32, pToolProperties: [^]PhysicalDeviceToolProperties) -> Result { return PtrGetPhysicalDeviceToolProperties(physicalDevice, pToolCount, pToolProperties) }
GetPhysicalDeviceToolPropertiesEXT                                 :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pToolCount: ^u32, pToolProperties: [^]PhysicalDeviceToolProperties) -> Result { return PtrGetPhysicalDeviceToolPropertiesEXT(physicalDevice, pToolCount, pToolProperties) }
GetPhysicalDeviceVideoCapabilitiesKHR                              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pVideoProfile: ^VideoProfileInfoKHR, pCapabilities: [^]VideoCapabilitiesKHR) -> Result { return PtrGetPhysicalDeviceVideoCapabilitiesKHR(physicalDevice, pVideoProfile, pCapabilities) }
GetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR              :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pQualityLevelInfo: ^PhysicalDeviceVideoEncodeQualityLevelInfoKHR, pQualityLevelProperties: [^]VideoEncodeQualityLevelPropertiesKHR) -> Result { return PtrGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(physicalDevice, pQualityLevelInfo, pQualityLevelProperties) }
GetPhysicalDeviceVideoFormatPropertiesKHR                          :: #force_inline proc "system" (physicalDevice: PhysicalDevice, pVideoFormatInfo: ^PhysicalDeviceVideoFormatInfoKHR, pVideoFormatPropertyCount: ^u32, pVideoFormatProperties: [^]VideoFormatPropertiesKHR) -> Result { return PtrGetPhysicalDeviceVideoFormatPropertiesKHR(physicalDevice, pVideoFormatInfo, pVideoFormatPropertyCount, pVideoFormatProperties) }
GetPhysicalDeviceWaylandPresentationSupportKHR                     :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, display: ^wl_display) -> b32 { return PtrGetPhysicalDeviceWaylandPresentationSupportKHR(physicalDevice, queueFamilyIndex, display) }
GetPhysicalDeviceWin32PresentationSupportKHR                       :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32) -> b32 { return PtrGetPhysicalDeviceWin32PresentationSupportKHR(physicalDevice, queueFamilyIndex) }
GetPhysicalDeviceXcbPresentationSupportKHR                         :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, connection: ^xcb_connection_t, visual_id: xcb_visualid_t) -> b32 { return PtrGetPhysicalDeviceXcbPresentationSupportKHR(physicalDevice, queueFamilyIndex, connection, visual_id) }
GetPhysicalDeviceXlibPresentationSupportKHR                        :: #force_inline proc "system" (physicalDevice: PhysicalDevice, queueFamilyIndex: u32, dpy: ^XlibDisplay, visualID: XlibVisualID) -> b32 { return PtrGetPhysicalDeviceXlibPresentationSupportKHR(physicalDevice, queueFamilyIndex, dpy, visualID) }
GetWinrtDisplayNV                                                  :: #force_inline proc "system" (physicalDevice: PhysicalDevice, deviceRelativeId: u32, pDisplay: ^DisplayKHR) -> Result { return PtrGetWinrtDisplayNV(physicalDevice, deviceRelativeId, pDisplay) }
ReleaseDisplayEXT                                                  :: #force_inline proc "system" (physicalDevice: PhysicalDevice, display: DisplayKHR) -> Result { return PtrReleaseDisplayEXT(physicalDevice, display) }
SubmitDebugUtilsMessageEXT                                         :: #force_inline proc "system" (instance: Instance, messageSeverity: DebugUtilsMessageSeverityFlagsEXT, messageTypes: DebugUtilsMessageTypeFlagsEXT, pCallbackData: ^DebugUtilsMessengerCallbackDataEXT) { PtrSubmitDebugUtilsMessageEXT(instance, messageSeverity, messageTypes, pCallbackData) }

// Device Procedures (public API wrappers)
AcquireFullScreenExclusiveModeEXT                      :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR) -> Result { return PtrAcquireFullScreenExclusiveModeEXT(device, swapchain) }
AcquireNextImage2KHR                                   :: #force_inline proc "system" (device: Device, pAcquireInfo: ^AcquireNextImageInfoKHR, pImageIndex: ^u32) -> Result { return PtrAcquireNextImage2KHR(device, pAcquireInfo, pImageIndex) }
AcquireNextImageKHR                                    :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, timeout: u64, semaphore: Semaphore, fence: Fence, pImageIndex: ^u32) -> Result { return PtrAcquireNextImageKHR(device, swapchain, timeout, semaphore, fence, pImageIndex) }
AcquirePerformanceConfigurationINTEL                   :: #force_inline proc "system" (device: Device, pAcquireInfo: ^PerformanceConfigurationAcquireInfoINTEL, pConfiguration: ^PerformanceConfigurationINTEL) -> Result { return PtrAcquirePerformanceConfigurationINTEL(device, pAcquireInfo, pConfiguration) }
AcquireProfilingLockKHR                                :: #force_inline proc "system" (device: Device, pInfo: ^AcquireProfilingLockInfoKHR) -> Result { return PtrAcquireProfilingLockKHR(device, pInfo) }
AllocateCommandBuffers                                 :: #force_inline proc "system" (device: Device, pAllocateInfo: ^CommandBufferAllocateInfo, pCommandBuffers: [^]CommandBuffer) -> Result { return PtrAllocateCommandBuffers(device, pAllocateInfo, pCommandBuffers) }
AllocateDescriptorSets                                 :: #force_inline proc "system" (device: Device, pAllocateInfo: ^DescriptorSetAllocateInfo, pDescriptorSets: [^]DescriptorSet) -> Result { return PtrAllocateDescriptorSets(device, pAllocateInfo, pDescriptorSets) }
AllocateMemory                                         :: #force_inline proc "system" (device: Device, pAllocateInfo: ^MemoryAllocateInfo, pAllocator: ^AllocationCallbacks, pMemory: ^DeviceMemory) -> Result { return PtrAllocateMemory(device, pAllocateInfo, pAllocator, pMemory) }
AntiLagUpdateAMD                                       :: #force_inline proc "system" (device: Device, pData: ^AntiLagDataAMD) { PtrAntiLagUpdateAMD(device, pData) }
BeginCommandBuffer                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBeginInfo: ^CommandBufferBeginInfo) -> Result { return PtrBeginCommandBuffer(commandBuffer, pBeginInfo) }
BindAccelerationStructureMemoryNV                      :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindAccelerationStructureMemoryInfoNV) -> Result { return PtrBindAccelerationStructureMemoryNV(device, bindInfoCount, pBindInfos) }
BindBufferMemory                                       :: #force_inline proc "system" (device: Device, buffer: Buffer, memory: DeviceMemory, memoryOffset: DeviceSize) -> Result { return PtrBindBufferMemory(device, buffer, memory, memoryOffset) }
BindBufferMemory2                                      :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindBufferMemoryInfo) -> Result { return PtrBindBufferMemory2(device, bindInfoCount, pBindInfos) }
BindBufferMemory2KHR                                   :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindBufferMemoryInfo) -> Result { return PtrBindBufferMemory2KHR(device, bindInfoCount, pBindInfos) }
BindDataGraphPipelineSessionMemoryARM                  :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindDataGraphPipelineSessionMemoryInfoARM) -> Result { return PtrBindDataGraphPipelineSessionMemoryARM(device, bindInfoCount, pBindInfos) }
BindImageMemory                                        :: #force_inline proc "system" (device: Device, image: Image, memory: DeviceMemory, memoryOffset: DeviceSize) -> Result { return PtrBindImageMemory(device, image, memory, memoryOffset) }
BindImageMemory2                                       :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindImageMemoryInfo) -> Result { return PtrBindImageMemory2(device, bindInfoCount, pBindInfos) }
BindImageMemory2KHR                                    :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindImageMemoryInfo) -> Result { return PtrBindImageMemory2KHR(device, bindInfoCount, pBindInfos) }
BindOpticalFlowSessionImageNV                          :: #force_inline proc "system" (device: Device, session: OpticalFlowSessionNV, bindingPoint: OpticalFlowSessionBindingPointNV, view: ImageView, layout: ImageLayout) -> Result { return PtrBindOpticalFlowSessionImageNV(device, session, bindingPoint, view, layout) }
BindTensorMemoryARM                                    :: #force_inline proc "system" (device: Device, bindInfoCount: u32, pBindInfos: [^]BindTensorMemoryInfoARM) -> Result { return PtrBindTensorMemoryARM(device, bindInfoCount, pBindInfos) }
BindVideoSessionMemoryKHR                              :: #force_inline proc "system" (device: Device, videoSession: VideoSessionKHR, bindSessionMemoryInfoCount: u32, pBindSessionMemoryInfos: [^]BindVideoSessionMemoryInfoKHR) -> Result { return PtrBindVideoSessionMemoryKHR(device, videoSession, bindSessionMemoryInfoCount, pBindSessionMemoryInfos) }
BuildAccelerationStructuresKHR                         :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: ^[^]AccelerationStructureBuildRangeInfoKHR) -> Result { return PtrBuildAccelerationStructuresKHR(device, deferredOperation, infoCount, pInfos, ppBuildRangeInfos) }
BuildMicromapsEXT                                      :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, infoCount: u32, pInfos: [^]MicromapBuildInfoEXT) -> Result { return PtrBuildMicromapsEXT(device, deferredOperation, infoCount, pInfos) }
ClearShaderInstrumentationMetricsARM                   :: #force_inline proc "system" (device: Device, instrumentation: ShaderInstrumentationARM) { PtrClearShaderInstrumentationMetricsARM(device, instrumentation) }
CmdBeginConditionalRendering2EXT                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pConditionalRenderingBegin: ^ConditionalRenderingBeginInfo2EXT) { PtrCmdBeginConditionalRendering2EXT(commandBuffer, pConditionalRenderingBegin) }
CmdBeginConditionalRenderingEXT                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pConditionalRenderingBegin: ^ConditionalRenderingBeginInfoEXT) { PtrCmdBeginConditionalRenderingEXT(commandBuffer, pConditionalRenderingBegin) }
CmdBeginCustomResolveEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBeginCustomResolveInfo: ^BeginCustomResolveInfoEXT) { PtrCmdBeginCustomResolveEXT(commandBuffer, pBeginCustomResolveInfo) }
CmdBeginDebugUtilsLabelEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLabelInfo: ^DebugUtilsLabelEXT) { PtrCmdBeginDebugUtilsLabelEXT(commandBuffer, pLabelInfo) }
CmdBeginGpaSampleAMD                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD, pGpaSampleBeginInfo: ^GpaSampleBeginInfoAMD, pSampleID: ^u32) -> Result { return PtrCmdBeginGpaSampleAMD(commandBuffer, gpaSession, pGpaSampleBeginInfo, pSampleID) }
CmdBeginGpaSessionAMD                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD) -> Result { return PtrCmdBeginGpaSessionAMD(commandBuffer, gpaSession) }
CmdBeginPerTileExecutionQCOM                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPerTileBeginInfo: ^PerTileBeginInfoQCOM) { PtrCmdBeginPerTileExecutionQCOM(commandBuffer, pPerTileBeginInfo) }
CmdBeginQuery                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, flags: QueryControlFlags) { PtrCmdBeginQuery(commandBuffer, queryPool, query, flags) }
CmdBeginQueryIndexedEXT                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, flags: QueryControlFlags, index: u32) { PtrCmdBeginQueryIndexedEXT(commandBuffer, queryPool, query, flags, index) }
CmdBeginRenderPass                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, contents: SubpassContents) { PtrCmdBeginRenderPass(commandBuffer, pRenderPassBegin, contents) }
CmdBeginRenderPass2                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, pSubpassBeginInfo: ^SubpassBeginInfo) { PtrCmdBeginRenderPass2(commandBuffer, pRenderPassBegin, pSubpassBeginInfo) }
CmdBeginRenderPass2KHR                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderPassBegin: ^RenderPassBeginInfo, pSubpassBeginInfo: ^SubpassBeginInfo) { PtrCmdBeginRenderPass2KHR(commandBuffer, pRenderPassBegin, pSubpassBeginInfo) }
CmdBeginRendering                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderingInfo: ^RenderingInfo) { PtrCmdBeginRendering(commandBuffer, pRenderingInfo) }
CmdBeginRenderingKHR                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderingInfo: ^RenderingInfo) { PtrCmdBeginRenderingKHR(commandBuffer, pRenderingInfo) }
CmdBeginShaderInstrumentationARM                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, instrumentation: ShaderInstrumentationARM) { PtrCmdBeginShaderInstrumentationARM(commandBuffer, instrumentation) }
CmdBeginTransformFeedback2EXT                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstCounterRange: u32, counterRangeCount: u32, pCounterInfos: [^]BindTransformFeedbackBuffer2InfoEXT) { PtrCmdBeginTransformFeedback2EXT(commandBuffer, firstCounterRange, counterRangeCount, pCounterInfos) }
CmdBeginTransformFeedbackEXT                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstCounterBuffer: u32, counterBufferCount: u32, pCounterBuffers: [^]Buffer, pCounterBufferOffsets: [^]DeviceSize) { PtrCmdBeginTransformFeedbackEXT(commandBuffer, firstCounterBuffer, counterBufferCount, pCounterBuffers, pCounterBufferOffsets) }
CmdBeginVideoCodingKHR                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBeginInfo: ^VideoBeginCodingInfoKHR) { PtrCmdBeginVideoCodingKHR(commandBuffer, pBeginInfo) }
CmdBindDescriptorBufferEmbeddedSamplers2EXT            :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBindDescriptorBufferEmbeddedSamplersInfo: ^BindDescriptorBufferEmbeddedSamplersInfoEXT) { PtrCmdBindDescriptorBufferEmbeddedSamplers2EXT(commandBuffer, pBindDescriptorBufferEmbeddedSamplersInfo) }
CmdBindDescriptorBufferEmbeddedSamplersEXT             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32) { PtrCmdBindDescriptorBufferEmbeddedSamplersEXT(commandBuffer, pipelineBindPoint, layout, set) }
CmdBindDescriptorBuffersEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, bufferCount: u32, pBindingInfos: [^]DescriptorBufferBindingInfoEXT) { PtrCmdBindDescriptorBuffersEXT(commandBuffer, bufferCount, pBindingInfos) }
CmdBindDescriptorSets                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, firstSet: u32, descriptorSetCount: u32, pDescriptorSets: [^]DescriptorSet, dynamicOffsetCount: u32, pDynamicOffsets: [^]u32) { PtrCmdBindDescriptorSets(commandBuffer, pipelineBindPoint, layout, firstSet, descriptorSetCount, pDescriptorSets, dynamicOffsetCount, pDynamicOffsets) }
CmdBindDescriptorSets2                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBindDescriptorSetsInfo: ^BindDescriptorSetsInfo) { PtrCmdBindDescriptorSets2(commandBuffer, pBindDescriptorSetsInfo) }
CmdBindDescriptorSets2KHR                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBindDescriptorSetsInfo: ^BindDescriptorSetsInfo) { PtrCmdBindDescriptorSets2KHR(commandBuffer, pBindDescriptorSetsInfo) }
CmdBindIndexBuffer                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, indexType: IndexType) { PtrCmdBindIndexBuffer(commandBuffer, buffer, offset, indexType) }
CmdBindIndexBuffer2                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, size: DeviceSize, indexType: IndexType) { PtrCmdBindIndexBuffer2(commandBuffer, buffer, offset, size, indexType) }
CmdBindIndexBuffer2KHR                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, size: DeviceSize, indexType: IndexType) { PtrCmdBindIndexBuffer2KHR(commandBuffer, buffer, offset, size, indexType) }
CmdBindIndexBuffer3KHR                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^BindIndexBuffer3InfoKHR) { PtrCmdBindIndexBuffer3KHR(commandBuffer, pInfo) }
CmdBindInvocationMaskHUAWEI                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, imageView: ImageView, imageLayout: ImageLayout) { PtrCmdBindInvocationMaskHUAWEI(commandBuffer, imageView, imageLayout) }
CmdBindPipeline                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline) { PtrCmdBindPipeline(commandBuffer, pipelineBindPoint, pipeline) }
CmdBindPipelineShaderGroupNV                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline, groupIndex: u32) { PtrCmdBindPipelineShaderGroupNV(commandBuffer, pipelineBindPoint, pipeline, groupIndex) }
CmdBindResourceHeapEXT                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBindInfo: ^BindHeapInfoEXT) { PtrCmdBindResourceHeapEXT(commandBuffer, pBindInfo) }
CmdBindSamplerHeapEXT                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBindInfo: ^BindHeapInfoEXT) { PtrCmdBindSamplerHeapEXT(commandBuffer, pBindInfo) }
CmdBindShadersEXT                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, stageCount: u32, pStages: [^]ShaderStageFlags, pShaders: [^]ShaderEXT) { PtrCmdBindShadersEXT(commandBuffer, stageCount, pStages, pShaders) }
CmdBindShadingRateImageNV                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, imageView: ImageView, imageLayout: ImageLayout) { PtrCmdBindShadingRateImageNV(commandBuffer, imageView, imageLayout) }
CmdBindTileMemoryQCOM                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pTileMemoryBindInfo: ^TileMemoryBindInfoQCOM) { PtrCmdBindTileMemoryQCOM(commandBuffer, pTileMemoryBindInfo) }
CmdBindTransformFeedbackBuffers2EXT                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBindingInfos: [^]BindTransformFeedbackBuffer2InfoEXT) { PtrCmdBindTransformFeedbackBuffers2EXT(commandBuffer, firstBinding, bindingCount, pBindingInfos) }
CmdBindTransformFeedbackBuffersEXT                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize) { PtrCmdBindTransformFeedbackBuffersEXT(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes) }
CmdBindVertexBuffers                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize) { PtrCmdBindVertexBuffers(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets) }
CmdBindVertexBuffers2                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize, pStrides: [^]DeviceSize) { PtrCmdBindVertexBuffers2(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes, pStrides) }
CmdBindVertexBuffers2EXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBuffers: [^]Buffer, pOffsets: [^]DeviceSize, pSizes: [^]DeviceSize, pStrides: [^]DeviceSize) { PtrCmdBindVertexBuffers2EXT(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes, pStrides) }
CmdBindVertexBuffers3KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstBinding: u32, bindingCount: u32, pBindingInfos: [^]BindVertexBuffer3InfoKHR) { PtrCmdBindVertexBuffers3KHR(commandBuffer, firstBinding, bindingCount, pBindingInfos) }
CmdBlitImage                                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageBlit, filter: Filter) { PtrCmdBlitImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions, filter) }
CmdBlitImage2                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBlitImageInfo: ^BlitImageInfo2) { PtrCmdBlitImage2(commandBuffer, pBlitImageInfo) }
CmdBlitImage2KHR                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBlitImageInfo: ^BlitImageInfo2) { PtrCmdBlitImage2KHR(commandBuffer, pBlitImageInfo) }
CmdBuildAccelerationStructureNV                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^AccelerationStructureInfoNV, instanceData: Buffer, instanceOffset: DeviceSize, update: b32, dst: AccelerationStructureNV, src: AccelerationStructureNV, scratch: Buffer, scratchOffset: DeviceSize) { PtrCmdBuildAccelerationStructureNV(commandBuffer, pInfo, instanceData, instanceOffset, update, dst, src, scratch, scratchOffset) }
CmdBuildAccelerationStructuresIndirectKHR              :: #force_inline proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, pIndirectDeviceAddresses: [^]DeviceAddress, pIndirectStrides: [^]u32, ppMaxPrimitiveCounts: ^[^]u32) { PtrCmdBuildAccelerationStructuresIndirectKHR(commandBuffer, infoCount, pInfos, pIndirectDeviceAddresses, pIndirectStrides, ppMaxPrimitiveCounts) }
CmdBuildAccelerationStructuresKHR                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]AccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: ^[^]AccelerationStructureBuildRangeInfoKHR) { PtrCmdBuildAccelerationStructuresKHR(commandBuffer, infoCount, pInfos, ppBuildRangeInfos) }
CmdBuildClusterAccelerationStructureIndirectNV         :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCommandInfos: [^]ClusterAccelerationStructureCommandsInfoNV) { PtrCmdBuildClusterAccelerationStructureIndirectNV(commandBuffer, pCommandInfos) }
CmdBuildMicromapsEXT                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]MicromapBuildInfoEXT) { PtrCmdBuildMicromapsEXT(commandBuffer, infoCount, pInfos) }
CmdBuildPartitionedAccelerationStructuresNV            :: #force_inline proc "system" (commandBuffer: CommandBuffer, pBuildInfo: ^BuildPartitionedAccelerationStructureInfoNV) { PtrCmdBuildPartitionedAccelerationStructuresNV(commandBuffer, pBuildInfo) }
CmdClearAttachments                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, attachmentCount: u32, pAttachments: [^]ClearAttachment, rectCount: u32, pRects: [^]ClearRect) { PtrCmdClearAttachments(commandBuffer, attachmentCount, pAttachments, rectCount, pRects) }
CmdClearColorImage                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, image: Image, imageLayout: ImageLayout, pColor: ^ClearColorValue, rangeCount: u32, pRanges: [^]ImageSubresourceRange) { PtrCmdClearColorImage(commandBuffer, image, imageLayout, pColor, rangeCount, pRanges) }
CmdClearDepthStencilImage                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, image: Image, imageLayout: ImageLayout, pDepthStencil: ^ClearDepthStencilValue, rangeCount: u32, pRanges: [^]ImageSubresourceRange) { PtrCmdClearDepthStencilImage(commandBuffer, image, imageLayout, pDepthStencil, rangeCount, pRanges) }
CmdControlVideoCodingKHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCodingControlInfo: ^VideoCodingControlInfoKHR) { PtrCmdControlVideoCodingKHR(commandBuffer, pCodingControlInfo) }
CmdConvertCooperativeVectorMatrixNV                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, infoCount: u32, pInfos: [^]ConvertCooperativeVectorMatrixInfoNV) { PtrCmdConvertCooperativeVectorMatrixNV(commandBuffer, infoCount, pInfos) }
CmdCopyAccelerationStructureKHR                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyAccelerationStructureInfoKHR) { PtrCmdCopyAccelerationStructureKHR(commandBuffer, pInfo) }
CmdCopyAccelerationStructureNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, dst: AccelerationStructureNV, src: AccelerationStructureNV, mode: CopyAccelerationStructureModeKHR) { PtrCmdCopyAccelerationStructureNV(commandBuffer, dst, src, mode) }
CmdCopyAccelerationStructureToMemoryKHR                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyAccelerationStructureToMemoryInfoKHR) { PtrCmdCopyAccelerationStructureToMemoryKHR(commandBuffer, pInfo) }
CmdCopyBuffer                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcBuffer: Buffer, dstBuffer: Buffer, regionCount: u32, pRegions: [^]BufferCopy) { PtrCmdCopyBuffer(commandBuffer, srcBuffer, dstBuffer, regionCount, pRegions) }
CmdCopyBuffer2                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyBufferInfo: ^CopyBufferInfo2) { PtrCmdCopyBuffer2(commandBuffer, pCopyBufferInfo) }
CmdCopyBuffer2KHR                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyBufferInfo: ^CopyBufferInfo2) { PtrCmdCopyBuffer2KHR(commandBuffer, pCopyBufferInfo) }
CmdCopyBufferToImage                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcBuffer: Buffer, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]BufferImageCopy) { PtrCmdCopyBufferToImage(commandBuffer, srcBuffer, dstImage, dstImageLayout, regionCount, pRegions) }
CmdCopyBufferToImage2                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyBufferToImageInfo: ^CopyBufferToImageInfo2) { PtrCmdCopyBufferToImage2(commandBuffer, pCopyBufferToImageInfo) }
CmdCopyBufferToImage2KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyBufferToImageInfo: ^CopyBufferToImageInfo2) { PtrCmdCopyBufferToImage2KHR(commandBuffer, pCopyBufferToImageInfo) }
CmdCopyGpaSessionResultsAMD                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD) { PtrCmdCopyGpaSessionResultsAMD(commandBuffer, gpaSession) }
CmdCopyImage                                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageCopy) { PtrCmdCopyImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions) }
CmdCopyImage2                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyImageInfo: ^CopyImageInfo2) { PtrCmdCopyImage2(commandBuffer, pCopyImageInfo) }
CmdCopyImage2KHR                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyImageInfo: ^CopyImageInfo2) { PtrCmdCopyImage2KHR(commandBuffer, pCopyImageInfo) }
CmdCopyImageToBuffer                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstBuffer: Buffer, regionCount: u32, pRegions: [^]BufferImageCopy) { PtrCmdCopyImageToBuffer(commandBuffer, srcImage, srcImageLayout, dstBuffer, regionCount, pRegions) }
CmdCopyImageToBuffer2                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyImageToBufferInfo: ^CopyImageToBufferInfo2) { PtrCmdCopyImageToBuffer2(commandBuffer, pCopyImageToBufferInfo) }
CmdCopyImageToBuffer2KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyImageToBufferInfo: ^CopyImageToBufferInfo2) { PtrCmdCopyImageToBuffer2KHR(commandBuffer, pCopyImageToBufferInfo) }
CmdCopyImageToMemoryKHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryImageInfoKHR) { PtrCmdCopyImageToMemoryKHR(commandBuffer, pCopyMemoryInfo) }
CmdCopyMemoryIndirectKHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyMemoryIndirectInfo: ^CopyMemoryIndirectInfoKHR) { PtrCmdCopyMemoryIndirectKHR(commandBuffer, pCopyMemoryIndirectInfo) }
CmdCopyMemoryIndirectNV                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, copyBufferAddress: DeviceAddress, copyCount: u32, stride: u32) { PtrCmdCopyMemoryIndirectNV(commandBuffer, copyBufferAddress, copyCount, stride) }
CmdCopyMemoryKHR                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryInfoKHR) { PtrCmdCopyMemoryKHR(commandBuffer, pCopyMemoryInfo) }
CmdCopyMemoryToAccelerationStructureKHR                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMemoryToAccelerationStructureInfoKHR) { PtrCmdCopyMemoryToAccelerationStructureKHR(commandBuffer, pInfo) }
CmdCopyMemoryToImageIndirectKHR                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyMemoryToImageIndirectInfo: ^CopyMemoryToImageIndirectInfoKHR) { PtrCmdCopyMemoryToImageIndirectKHR(commandBuffer, pCopyMemoryToImageIndirectInfo) }
CmdCopyMemoryToImageIndirectNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, copyBufferAddress: DeviceAddress, copyCount: u32, stride: u32, dstImage: Image, dstImageLayout: ImageLayout, pImageSubresources: [^]ImageSubresourceLayers) { PtrCmdCopyMemoryToImageIndirectNV(commandBuffer, copyBufferAddress, copyCount, stride, dstImage, dstImageLayout, pImageSubresources) }
CmdCopyMemoryToImageKHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyMemoryInfo: ^CopyDeviceMemoryImageInfoKHR) { PtrCmdCopyMemoryToImageKHR(commandBuffer, pCopyMemoryInfo) }
CmdCopyMemoryToMicromapEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMemoryToMicromapInfoEXT) { PtrCmdCopyMemoryToMicromapEXT(commandBuffer, pInfo) }
CmdCopyMicromapEXT                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMicromapInfoEXT) { PtrCmdCopyMicromapEXT(commandBuffer, pInfo) }
CmdCopyMicromapToMemoryEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^CopyMicromapToMemoryInfoEXT) { PtrCmdCopyMicromapToMemoryEXT(commandBuffer, pInfo) }
CmdCopyQueryPoolResults                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32, dstBuffer: Buffer, dstOffset: DeviceSize, stride: DeviceSize, flags: QueryResultFlags) { PtrCmdCopyQueryPoolResults(commandBuffer, queryPool, firstQuery, queryCount, dstBuffer, dstOffset, stride, flags) }
CmdCopyQueryPoolResultsToMemoryKHR                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32, pDstRange: ^StridedDeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, queryResultFlags: QueryResultFlags) { PtrCmdCopyQueryPoolResultsToMemoryKHR(commandBuffer, queryPool, firstQuery, queryCount, pDstRange, dstFlags, queryResultFlags) }
CmdCopyTensorARM                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCopyTensorInfo: ^CopyTensorInfoARM) { PtrCmdCopyTensorARM(commandBuffer, pCopyTensorInfo) }
CmdCuLaunchKernelNVX                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLaunchInfo: ^CuLaunchInfoNVX) { PtrCmdCuLaunchKernelNVX(commandBuffer, pLaunchInfo) }
CmdCudaLaunchKernelNV                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLaunchInfo: ^CudaLaunchInfoNV) { PtrCmdCudaLaunchKernelNV(commandBuffer, pLaunchInfo) }
CmdDebugMarkerBeginEXT                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^DebugMarkerMarkerInfoEXT) { PtrCmdDebugMarkerBeginEXT(commandBuffer, pMarkerInfo) }
CmdDebugMarkerEndEXT                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdDebugMarkerEndEXT(commandBuffer) }
CmdDebugMarkerInsertEXT                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^DebugMarkerMarkerInfoEXT) { PtrCmdDebugMarkerInsertEXT(commandBuffer, pMarkerInfo) }
CmdDecodeVideoKHR                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDecodeInfo: ^VideoDecodeInfoKHR) { PtrCmdDecodeVideoKHR(commandBuffer, pDecodeInfo) }
CmdDecompressMemoryEXT                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDecompressMemoryInfoEXT: ^DecompressMemoryInfoEXT) { PtrCmdDecompressMemoryEXT(commandBuffer, pDecompressMemoryInfoEXT) }
CmdDecompressMemoryIndirectCountEXT                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, decompressionMethod: MemoryDecompressionMethodFlagsEXT, indirectCommandsAddress: DeviceAddress, indirectCommandsCountAddress: DeviceAddress, maxDecompressionCount: u32, stride: u32) { PtrCmdDecompressMemoryIndirectCountEXT(commandBuffer, decompressionMethod, indirectCommandsAddress, indirectCommandsCountAddress, maxDecompressionCount, stride) }
CmdDecompressMemoryIndirectCountNV                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, indirectCommandsAddress: DeviceAddress, indirectCommandsCountAddress: DeviceAddress, stride: u32) { PtrCmdDecompressMemoryIndirectCountNV(commandBuffer, indirectCommandsAddress, indirectCommandsCountAddress, stride) }
CmdDecompressMemoryNV                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, decompressRegionCount: u32, pDecompressMemoryRegions: [^]DecompressMemoryRegionNV) { PtrCmdDecompressMemoryNV(commandBuffer, decompressRegionCount, pDecompressMemoryRegions) }
CmdDispatch                                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32) { PtrCmdDispatch(commandBuffer, groupCountX, groupCountY, groupCountZ) }
CmdDispatchBase                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, baseGroupX: u32, baseGroupY: u32, baseGroupZ: u32, groupCountX: u32, groupCountY: u32, groupCountZ: u32) { PtrCmdDispatchBase(commandBuffer, baseGroupX, baseGroupY, baseGroupZ, groupCountX, groupCountY, groupCountZ) }
CmdDispatchBaseKHR                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, baseGroupX: u32, baseGroupY: u32, baseGroupZ: u32, groupCountX: u32, groupCountY: u32, groupCountZ: u32) { PtrCmdDispatchBaseKHR(commandBuffer, baseGroupX, baseGroupY, baseGroupZ, groupCountX, groupCountY, groupCountZ) }
CmdDispatchDataGraphARM                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, session: DataGraphPipelineSessionARM, pInfo: ^DataGraphPipelineDispatchInfoARM) { PtrCmdDispatchDataGraphARM(commandBuffer, session, pInfo) }
CmdDispatchGraphAMDX                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, pCountInfo: ^DispatchGraphCountInfoAMDX) { PtrCmdDispatchGraphAMDX(commandBuffer, scratch, scratchSize, pCountInfo) }
CmdDispatchGraphIndirectAMDX                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, pCountInfo: ^DispatchGraphCountInfoAMDX) { PtrCmdDispatchGraphIndirectAMDX(commandBuffer, scratch, scratchSize, pCountInfo) }
CmdDispatchGraphIndirectCountAMDX                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, scratch: DeviceAddress, scratchSize: DeviceSize, countInfo: DeviceAddress) { PtrCmdDispatchGraphIndirectCountAMDX(commandBuffer, scratch, scratchSize, countInfo) }
CmdDispatchIndirect                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize) { PtrCmdDispatchIndirect(commandBuffer, buffer, offset) }
CmdDispatchIndirect2KHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DispatchIndirect2InfoKHR) { PtrCmdDispatchIndirect2KHR(commandBuffer, pInfo) }
CmdDispatchTileQCOM                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDispatchTileInfo: ^DispatchTileInfoQCOM) { PtrCmdDispatchTileQCOM(commandBuffer, pDispatchTileInfo) }
CmdDraw                                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) { PtrCmdDraw(commandBuffer, vertexCount, instanceCount, firstVertex, firstInstance) }
CmdDrawClusterHUAWEI                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32) { PtrCmdDrawClusterHUAWEI(commandBuffer, groupCountX, groupCountY, groupCountZ) }
CmdDrawClusterIndirectHUAWEI                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize) { PtrCmdDrawClusterIndirectHUAWEI(commandBuffer, buffer, offset) }
CmdDrawIndexed                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, indexCount: u32, instanceCount: u32, firstIndex: u32, vertexOffset: i32, firstInstance: u32) { PtrCmdDrawIndexed(commandBuffer, indexCount, instanceCount, firstIndex, vertexOffset, firstInstance) }
CmdDrawIndexedIndirect                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32) { PtrCmdDrawIndexedIndirect(commandBuffer, buffer, offset, drawCount, stride) }
CmdDrawIndexedIndirect2KHR                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR) { PtrCmdDrawIndexedIndirect2KHR(commandBuffer, pInfo) }
CmdDrawIndexedIndirectCount                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndexedIndirectCount(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawIndexedIndirectCount2KHR                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR) { PtrCmdDrawIndexedIndirectCount2KHR(commandBuffer, pInfo) }
CmdDrawIndexedIndirectCountAMD                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndexedIndirectCountAMD(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawIndexedIndirectCountKHR                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndexedIndirectCountKHR(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawIndirect                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32) { PtrCmdDrawIndirect(commandBuffer, buffer, offset, drawCount, stride) }
CmdDrawIndirect2KHR                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR) { PtrCmdDrawIndirect2KHR(commandBuffer, pInfo) }
CmdDrawIndirectByteCount2EXT                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, instanceCount: u32, firstInstance: u32, pCounterInfo: ^BindTransformFeedbackBuffer2InfoEXT, counterOffset: u32, vertexStride: u32) { PtrCmdDrawIndirectByteCount2EXT(commandBuffer, instanceCount, firstInstance, pCounterInfo, counterOffset, vertexStride) }
CmdDrawIndirectByteCountEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, instanceCount: u32, firstInstance: u32, counterBuffer: Buffer, counterBufferOffset: DeviceSize, counterOffset: u32, vertexStride: u32) { PtrCmdDrawIndirectByteCountEXT(commandBuffer, instanceCount, firstInstance, counterBuffer, counterBufferOffset, counterOffset, vertexStride) }
CmdDrawIndirectCount                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndirectCount(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawIndirectCount2KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR) { PtrCmdDrawIndirectCount2KHR(commandBuffer, pInfo) }
CmdDrawIndirectCountAMD                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndirectCountAMD(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawIndirectCountKHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawIndirectCountKHR(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawMeshTasksEXT                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, groupCountX: u32, groupCountY: u32, groupCountZ: u32) { PtrCmdDrawMeshTasksEXT(commandBuffer, groupCountX, groupCountY, groupCountZ) }
CmdDrawMeshTasksIndirect2EXT                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirect2InfoKHR) { PtrCmdDrawMeshTasksIndirect2EXT(commandBuffer, pInfo) }
CmdDrawMeshTasksIndirectCount2EXT                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^DrawIndirectCount2InfoKHR) { PtrCmdDrawMeshTasksIndirectCount2EXT(commandBuffer, pInfo) }
CmdDrawMeshTasksIndirectCountEXT                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawMeshTasksIndirectCountEXT(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawMeshTasksIndirectCountNV                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, countBuffer: Buffer, countBufferOffset: DeviceSize, maxDrawCount: u32, stride: u32) { PtrCmdDrawMeshTasksIndirectCountNV(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride) }
CmdDrawMeshTasksIndirectEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32) { PtrCmdDrawMeshTasksIndirectEXT(commandBuffer, buffer, offset, drawCount, stride) }
CmdDrawMeshTasksIndirectNV                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, buffer: Buffer, offset: DeviceSize, drawCount: u32, stride: u32) { PtrCmdDrawMeshTasksIndirectNV(commandBuffer, buffer, offset, drawCount, stride) }
CmdDrawMeshTasksNV                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, taskCount: u32, firstTask: u32) { PtrCmdDrawMeshTasksNV(commandBuffer, taskCount, firstTask) }
CmdDrawMultiEXT                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, drawCount: u32, pVertexInfo: ^MultiDrawInfoEXT, instanceCount: u32, firstInstance: u32, stride: u32) { PtrCmdDrawMultiEXT(commandBuffer, drawCount, pVertexInfo, instanceCount, firstInstance, stride) }
CmdDrawMultiIndexedEXT                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, drawCount: u32, pIndexInfo: ^MultiDrawIndexedInfoEXT, instanceCount: u32, firstInstance: u32, stride: u32, pVertexOffset: ^i32) { PtrCmdDrawMultiIndexedEXT(commandBuffer, drawCount, pIndexInfo, instanceCount, firstInstance, stride, pVertexOffset) }
CmdEncodeVideoKHR                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pEncodeInfo: ^VideoEncodeInfoKHR) { PtrCmdEncodeVideoKHR(commandBuffer, pEncodeInfo) }
CmdEndConditionalRenderingEXT                          :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndConditionalRenderingEXT(commandBuffer) }
CmdEndDebugUtilsLabelEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndDebugUtilsLabelEXT(commandBuffer) }
CmdEndGpaSampleAMD                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD, sampleID: u32) { PtrCmdEndGpaSampleAMD(commandBuffer, gpaSession, sampleID) }
CmdEndGpaSessionAMD                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, gpaSession: GpaSessionAMD) -> Result { return PtrCmdEndGpaSessionAMD(commandBuffer, gpaSession) }
CmdEndPerTileExecutionQCOM                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPerTileEndInfo: ^PerTileEndInfoQCOM) { PtrCmdEndPerTileExecutionQCOM(commandBuffer, pPerTileEndInfo) }
CmdEndQuery                                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32) { PtrCmdEndQuery(commandBuffer, queryPool, query) }
CmdEndQueryIndexedEXT                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, query: u32, index: u32) { PtrCmdEndQueryIndexedEXT(commandBuffer, queryPool, query, index) }
CmdEndRenderPass                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndRenderPass(commandBuffer) }
CmdEndRenderPass2                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSubpassEndInfo: ^SubpassEndInfo) { PtrCmdEndRenderPass2(commandBuffer, pSubpassEndInfo) }
CmdEndRenderPass2KHR                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSubpassEndInfo: ^SubpassEndInfo) { PtrCmdEndRenderPass2KHR(commandBuffer, pSubpassEndInfo) }
CmdEndRendering                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndRendering(commandBuffer) }
CmdEndRendering2EXT                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderingEndInfo: ^RenderingEndInfoKHR) { PtrCmdEndRendering2EXT(commandBuffer, pRenderingEndInfo) }
CmdEndRendering2KHR                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRenderingEndInfo: ^RenderingEndInfoKHR) { PtrCmdEndRendering2KHR(commandBuffer, pRenderingEndInfo) }
CmdEndRenderingKHR                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndRenderingKHR(commandBuffer) }
CmdEndShaderInstrumentationARM                         :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdEndShaderInstrumentationARM(commandBuffer) }
CmdEndTransformFeedback2EXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstCounterRange: u32, counterRangeCount: u32, pCounterInfos: [^]BindTransformFeedbackBuffer2InfoEXT) { PtrCmdEndTransformFeedback2EXT(commandBuffer, firstCounterRange, counterRangeCount, pCounterInfos) }
CmdEndTransformFeedbackEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstCounterBuffer: u32, counterBufferCount: u32, pCounterBuffers: [^]Buffer, pCounterBufferOffsets: [^]DeviceSize) { PtrCmdEndTransformFeedbackEXT(commandBuffer, firstCounterBuffer, counterBufferCount, pCounterBuffers, pCounterBufferOffsets) }
CmdEndVideoCodingKHR                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pEndCodingInfo: ^VideoEndCodingInfoKHR) { PtrCmdEndVideoCodingKHR(commandBuffer, pEndCodingInfo) }
CmdExecuteCommands                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, commandBufferCount: u32, pCommandBuffers: [^]CommandBuffer) { PtrCmdExecuteCommands(commandBuffer, commandBufferCount, pCommandBuffers) }
CmdExecuteGeneratedCommandsEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, isPreprocessed: b32, pGeneratedCommandsInfo: ^GeneratedCommandsInfoEXT) { PtrCmdExecuteGeneratedCommandsEXT(commandBuffer, isPreprocessed, pGeneratedCommandsInfo) }
CmdExecuteGeneratedCommandsNV                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, isPreprocessed: b32, pGeneratedCommandsInfo: ^GeneratedCommandsInfoNV) { PtrCmdExecuteGeneratedCommandsNV(commandBuffer, isPreprocessed, pGeneratedCommandsInfo) }
CmdFillBuffer                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, dstBuffer: Buffer, dstOffset: DeviceSize, size: DeviceSize, data: u32) { PtrCmdFillBuffer(commandBuffer, dstBuffer, dstOffset, size, data) }
CmdFillMemoryKHR                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDstRange: ^DeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, data: u32) { PtrCmdFillMemoryKHR(commandBuffer, pDstRange, dstFlags, data) }
CmdInitializeGraphScratchMemoryAMDX                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, executionGraph: Pipeline, scratch: DeviceAddress, scratchSize: DeviceSize) { PtrCmdInitializeGraphScratchMemoryAMDX(commandBuffer, executionGraph, scratch, scratchSize) }
CmdInsertDebugUtilsLabelEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLabelInfo: ^DebugUtilsLabelEXT) { PtrCmdInsertDebugUtilsLabelEXT(commandBuffer, pLabelInfo) }
CmdNextSubpass                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, contents: SubpassContents) { PtrCmdNextSubpass(commandBuffer, contents) }
CmdNextSubpass2                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSubpassBeginInfo: ^SubpassBeginInfo, pSubpassEndInfo: ^SubpassEndInfo) { PtrCmdNextSubpass2(commandBuffer, pSubpassBeginInfo, pSubpassEndInfo) }
CmdNextSubpass2KHR                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSubpassBeginInfo: ^SubpassBeginInfo, pSubpassEndInfo: ^SubpassEndInfo) { PtrCmdNextSubpass2KHR(commandBuffer, pSubpassBeginInfo, pSubpassEndInfo) }
CmdOpticalFlowExecuteNV                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, session: OpticalFlowSessionNV, pExecuteInfo: ^OpticalFlowExecuteInfoNV) { PtrCmdOpticalFlowExecuteNV(commandBuffer, session, pExecuteInfo) }
CmdPipelineBarrier                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcStageMask: PipelineStageFlags, dstStageMask: PipelineStageFlags, dependencyFlags: DependencyFlags, memoryBarrierCount: u32, pMemoryBarriers: [^]MemoryBarrier, bufferMemoryBarrierCount: u32, pBufferMemoryBarriers: [^]BufferMemoryBarrier, imageMemoryBarrierCount: u32, pImageMemoryBarriers: [^]ImageMemoryBarrier) { PtrCmdPipelineBarrier(commandBuffer, srcStageMask, dstStageMask, dependencyFlags, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers) }
CmdPipelineBarrier2                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDependencyInfo: ^DependencyInfo) { PtrCmdPipelineBarrier2(commandBuffer, pDependencyInfo) }
CmdPipelineBarrier2KHR                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDependencyInfo: ^DependencyInfo) { PtrCmdPipelineBarrier2KHR(commandBuffer, pDependencyInfo) }
CmdPreprocessGeneratedCommandsEXT                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pGeneratedCommandsInfo: ^GeneratedCommandsInfoEXT, stateCommandBuffer: CommandBuffer) { PtrCmdPreprocessGeneratedCommandsEXT(commandBuffer, pGeneratedCommandsInfo, stateCommandBuffer) }
CmdPreprocessGeneratedCommandsNV                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pGeneratedCommandsInfo: ^GeneratedCommandsInfoNV) { PtrCmdPreprocessGeneratedCommandsNV(commandBuffer, pGeneratedCommandsInfo) }
CmdPushConstants                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, layout: PipelineLayout, stageFlags: ShaderStageFlags, offset: u32, size: u32, pValues: rawptr) { PtrCmdPushConstants(commandBuffer, layout, stageFlags, offset, size, pValues) }
CmdPushConstants2                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushConstantsInfo: ^PushConstantsInfo) { PtrCmdPushConstants2(commandBuffer, pPushConstantsInfo) }
CmdPushConstants2KHR                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushConstantsInfo: ^PushConstantsInfo) { PtrCmdPushConstants2KHR(commandBuffer, pPushConstantsInfo) }
CmdPushDataEXT                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushDataInfo: ^PushDataInfoEXT) { PtrCmdPushDataEXT(commandBuffer, pPushDataInfo) }
CmdPushDescriptorSet                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet) { PtrCmdPushDescriptorSet(commandBuffer, pipelineBindPoint, layout, set, descriptorWriteCount, pDescriptorWrites) }
CmdPushDescriptorSet2                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetInfo: ^PushDescriptorSetInfo) { PtrCmdPushDescriptorSet2(commandBuffer, pPushDescriptorSetInfo) }
CmdPushDescriptorSet2KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetInfo: ^PushDescriptorSetInfo) { PtrCmdPushDescriptorSet2KHR(commandBuffer, pPushDescriptorSetInfo) }
CmdPushDescriptorSetKHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, set: u32, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet) { PtrCmdPushDescriptorSetKHR(commandBuffer, pipelineBindPoint, layout, set, descriptorWriteCount, pDescriptorWrites) }
CmdPushDescriptorSetWithTemplate                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, descriptorUpdateTemplate: DescriptorUpdateTemplate, layout: PipelineLayout, set: u32, pData: rawptr) { PtrCmdPushDescriptorSetWithTemplate(commandBuffer, descriptorUpdateTemplate, layout, set, pData) }
CmdPushDescriptorSetWithTemplate2                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetWithTemplateInfo: ^PushDescriptorSetWithTemplateInfo) { PtrCmdPushDescriptorSetWithTemplate2(commandBuffer, pPushDescriptorSetWithTemplateInfo) }
CmdPushDescriptorSetWithTemplate2KHR                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pPushDescriptorSetWithTemplateInfo: ^PushDescriptorSetWithTemplateInfo) { PtrCmdPushDescriptorSetWithTemplate2KHR(commandBuffer, pPushDescriptorSetWithTemplateInfo) }
CmdPushDescriptorSetWithTemplateKHR                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, descriptorUpdateTemplate: DescriptorUpdateTemplate, layout: PipelineLayout, set: u32, pData: rawptr) { PtrCmdPushDescriptorSetWithTemplateKHR(commandBuffer, descriptorUpdateTemplate, layout, set, pData) }
CmdResetEvent                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags) { PtrCmdResetEvent(commandBuffer, event, stageMask) }
CmdResetEvent2                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags2) { PtrCmdResetEvent2(commandBuffer, event, stageMask) }
CmdResetEvent2KHR                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags2) { PtrCmdResetEvent2KHR(commandBuffer, event, stageMask) }
CmdResetQueryPool                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, queryPool: QueryPool, firstQuery: u32, queryCount: u32) { PtrCmdResetQueryPool(commandBuffer, queryPool, firstQuery, queryCount) }
CmdResolveImage                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, srcImage: Image, srcImageLayout: ImageLayout, dstImage: Image, dstImageLayout: ImageLayout, regionCount: u32, pRegions: [^]ImageResolve) { PtrCmdResolveImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions) }
CmdResolveImage2                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pResolveImageInfo: ^ResolveImageInfo2) { PtrCmdResolveImage2(commandBuffer, pResolveImageInfo) }
CmdResolveImage2KHR                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pResolveImageInfo: ^ResolveImageInfo2) { PtrCmdResolveImage2KHR(commandBuffer, pResolveImageInfo) }
CmdSetAlphaToCoverageEnableEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, alphaToCoverageEnable: b32) { PtrCmdSetAlphaToCoverageEnableEXT(commandBuffer, alphaToCoverageEnable) }
CmdSetAlphaToOneEnableEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, alphaToOneEnable: b32) { PtrCmdSetAlphaToOneEnableEXT(commandBuffer, alphaToOneEnable) }
CmdSetAttachmentFeedbackLoopEnableEXT                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, aspectMask: ImageAspectFlags) { PtrCmdSetAttachmentFeedbackLoopEnableEXT(commandBuffer, aspectMask) }
CmdSetBlendConstants                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, blendConstants: ^[4]f32) { PtrCmdSetBlendConstants(commandBuffer, blendConstants) }
CmdSetCheckpointNV                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pCheckpointMarker: rawptr) { PtrCmdSetCheckpointNV(commandBuffer, pCheckpointMarker) }
CmdSetCoarseSampleOrderNV                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, sampleOrderType: CoarseSampleOrderTypeNV, customSampleOrderCount: u32, pCustomSampleOrders: [^]CoarseSampleOrderCustomNV) { PtrCmdSetCoarseSampleOrderNV(commandBuffer, sampleOrderType, customSampleOrderCount, pCustomSampleOrders) }
CmdSetColorBlendAdvancedEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendAdvanced: ^ColorBlendAdvancedEXT) { PtrCmdSetColorBlendAdvancedEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendAdvanced) }
CmdSetColorBlendEnableEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendEnables: [^]b32) { PtrCmdSetColorBlendEnableEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendEnables) }
CmdSetColorBlendEquationEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorBlendEquations: [^]ColorBlendEquationEXT) { PtrCmdSetColorBlendEquationEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendEquations) }
CmdSetColorWriteEnableEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, attachmentCount: u32, pColorWriteEnables: [^]b32) { PtrCmdSetColorWriteEnableEXT(commandBuffer, attachmentCount, pColorWriteEnables) }
CmdSetColorWriteMaskEXT                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstAttachment: u32, attachmentCount: u32, pColorWriteMasks: [^]ColorComponentFlags) { PtrCmdSetColorWriteMaskEXT(commandBuffer, firstAttachment, attachmentCount, pColorWriteMasks) }
CmdSetComputeOccupancyPriorityNV                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pParameters: [^]ComputeOccupancyPriorityParametersNV) { PtrCmdSetComputeOccupancyPriorityNV(commandBuffer, pParameters) }
CmdSetConservativeRasterizationModeEXT                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, conservativeRasterizationMode: ConservativeRasterizationModeEXT) { PtrCmdSetConservativeRasterizationModeEXT(commandBuffer, conservativeRasterizationMode) }
CmdSetCoverageModulationModeNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageModulationMode: CoverageModulationModeNV) { PtrCmdSetCoverageModulationModeNV(commandBuffer, coverageModulationMode) }
CmdSetCoverageModulationTableEnableNV                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageModulationTableEnable: b32) { PtrCmdSetCoverageModulationTableEnableNV(commandBuffer, coverageModulationTableEnable) }
CmdSetCoverageModulationTableNV                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageModulationTableCount: u32, pCoverageModulationTable: [^]f32) { PtrCmdSetCoverageModulationTableNV(commandBuffer, coverageModulationTableCount, pCoverageModulationTable) }
CmdSetCoverageReductionModeNV                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageReductionMode: CoverageReductionModeNV) { PtrCmdSetCoverageReductionModeNV(commandBuffer, coverageReductionMode) }
CmdSetCoverageToColorEnableNV                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageToColorEnable: b32) { PtrCmdSetCoverageToColorEnableNV(commandBuffer, coverageToColorEnable) }
CmdSetCoverageToColorLocationNV                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, coverageToColorLocation: u32) { PtrCmdSetCoverageToColorLocationNV(commandBuffer, coverageToColorLocation) }
CmdSetCullMode                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, cullMode: CullModeFlags) { PtrCmdSetCullMode(commandBuffer, cullMode) }
CmdSetCullModeEXT                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, cullMode: CullModeFlags) { PtrCmdSetCullModeEXT(commandBuffer, cullMode) }
CmdSetDepthBias                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthBiasConstantFactor: f32, depthBiasClamp: f32, depthBiasSlopeFactor: f32) { PtrCmdSetDepthBias(commandBuffer, depthBiasConstantFactor, depthBiasClamp, depthBiasSlopeFactor) }
CmdSetDepthBias2EXT                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDepthBiasInfo: ^DepthBiasInfoEXT) { PtrCmdSetDepthBias2EXT(commandBuffer, pDepthBiasInfo) }
CmdSetDepthBiasEnable                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthBiasEnable: b32) { PtrCmdSetDepthBiasEnable(commandBuffer, depthBiasEnable) }
CmdSetDepthBiasEnableEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthBiasEnable: b32) { PtrCmdSetDepthBiasEnableEXT(commandBuffer, depthBiasEnable) }
CmdSetDepthBounds                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, minDepthBounds: f32, maxDepthBounds: f32) { PtrCmdSetDepthBounds(commandBuffer, minDepthBounds, maxDepthBounds) }
CmdSetDepthBoundsTestEnable                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthBoundsTestEnable: b32) { PtrCmdSetDepthBoundsTestEnable(commandBuffer, depthBoundsTestEnable) }
CmdSetDepthBoundsTestEnableEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthBoundsTestEnable: b32) { PtrCmdSetDepthBoundsTestEnableEXT(commandBuffer, depthBoundsTestEnable) }
CmdSetDepthClampEnableEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthClampEnable: b32) { PtrCmdSetDepthClampEnableEXT(commandBuffer, depthClampEnable) }
CmdSetDepthClampRangeEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthClampMode: DepthClampModeEXT, pDepthClampRange: ^DepthClampRangeEXT) { PtrCmdSetDepthClampRangeEXT(commandBuffer, depthClampMode, pDepthClampRange) }
CmdSetDepthClipEnableEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthClipEnable: b32) { PtrCmdSetDepthClipEnableEXT(commandBuffer, depthClipEnable) }
CmdSetDepthClipNegativeOneToOneEXT                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, negativeOneToOne: b32) { PtrCmdSetDepthClipNegativeOneToOneEXT(commandBuffer, negativeOneToOne) }
CmdSetDepthCompareOp                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthCompareOp: CompareOp) { PtrCmdSetDepthCompareOp(commandBuffer, depthCompareOp) }
CmdSetDepthCompareOpEXT                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthCompareOp: CompareOp) { PtrCmdSetDepthCompareOpEXT(commandBuffer, depthCompareOp) }
CmdSetDepthTestEnable                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthTestEnable: b32) { PtrCmdSetDepthTestEnable(commandBuffer, depthTestEnable) }
CmdSetDepthTestEnableEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthTestEnable: b32) { PtrCmdSetDepthTestEnableEXT(commandBuffer, depthTestEnable) }
CmdSetDepthWriteEnable                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthWriteEnable: b32) { PtrCmdSetDepthWriteEnable(commandBuffer, depthWriteEnable) }
CmdSetDepthWriteEnableEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, depthWriteEnable: b32) { PtrCmdSetDepthWriteEnableEXT(commandBuffer, depthWriteEnable) }
CmdSetDescriptorBufferOffsets2EXT                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSetDescriptorBufferOffsetsInfo: ^SetDescriptorBufferOffsetsInfoEXT) { PtrCmdSetDescriptorBufferOffsets2EXT(commandBuffer, pSetDescriptorBufferOffsetsInfo) }
CmdSetDescriptorBufferOffsetsEXT                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, layout: PipelineLayout, firstSet: u32, setCount: u32, pBufferIndices: [^]u32, pOffsets: [^]DeviceSize) { PtrCmdSetDescriptorBufferOffsetsEXT(commandBuffer, pipelineBindPoint, layout, firstSet, setCount, pBufferIndices, pOffsets) }
CmdSetDeviceMask                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, deviceMask: u32) { PtrCmdSetDeviceMask(commandBuffer, deviceMask) }
CmdSetDeviceMaskKHR                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, deviceMask: u32) { PtrCmdSetDeviceMaskKHR(commandBuffer, deviceMask) }
CmdSetDiscardRectangleEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstDiscardRectangle: u32, discardRectangleCount: u32, pDiscardRectangles: [^]Rect2D) { PtrCmdSetDiscardRectangleEXT(commandBuffer, firstDiscardRectangle, discardRectangleCount, pDiscardRectangles) }
CmdSetDiscardRectangleEnableEXT                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, discardRectangleEnable: b32) { PtrCmdSetDiscardRectangleEnableEXT(commandBuffer, discardRectangleEnable) }
CmdSetDiscardRectangleModeEXT                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, discardRectangleMode: DiscardRectangleModeEXT) { PtrCmdSetDiscardRectangleModeEXT(commandBuffer, discardRectangleMode) }
CmdSetDispatchParametersARM                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDispatchParameters: [^]DispatchParametersARM) { PtrCmdSetDispatchParametersARM(commandBuffer, pDispatchParameters) }
CmdSetEvent                                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, stageMask: PipelineStageFlags) { PtrCmdSetEvent(commandBuffer, event, stageMask) }
CmdSetEvent2                                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, pDependencyInfo: ^DependencyInfo) { PtrCmdSetEvent2(commandBuffer, event, pDependencyInfo) }
CmdSetEvent2KHR                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, event: Event, pDependencyInfo: ^DependencyInfo) { PtrCmdSetEvent2KHR(commandBuffer, event, pDependencyInfo) }
CmdSetExclusiveScissorEnableNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstExclusiveScissor: u32, exclusiveScissorCount: u32, pExclusiveScissorEnables: [^]b32) { PtrCmdSetExclusiveScissorEnableNV(commandBuffer, firstExclusiveScissor, exclusiveScissorCount, pExclusiveScissorEnables) }
CmdSetExclusiveScissorNV                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstExclusiveScissor: u32, exclusiveScissorCount: u32, pExclusiveScissors: [^]Rect2D) { PtrCmdSetExclusiveScissorNV(commandBuffer, firstExclusiveScissor, exclusiveScissorCount, pExclusiveScissors) }
CmdSetExtraPrimitiveOverestimationSizeEXT              :: #force_inline proc "system" (commandBuffer: CommandBuffer, extraPrimitiveOverestimationSize: f32) { PtrCmdSetExtraPrimitiveOverestimationSizeEXT(commandBuffer, extraPrimitiveOverestimationSize) }
CmdSetFragmentShadingRateEnumNV                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, shadingRate: FragmentShadingRateNV, combinerOps: ^[2]FragmentShadingRateCombinerOpKHR) { PtrCmdSetFragmentShadingRateEnumNV(commandBuffer, shadingRate, combinerOps) }
CmdSetFragmentShadingRateKHR                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, pFragmentSize: ^Extent2D, combinerOps: ^[2]FragmentShadingRateCombinerOpKHR) { PtrCmdSetFragmentShadingRateKHR(commandBuffer, pFragmentSize, combinerOps) }
CmdSetFrontFace                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, frontFace: FrontFace) { PtrCmdSetFrontFace(commandBuffer, frontFace) }
CmdSetFrontFaceEXT                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, frontFace: FrontFace) { PtrCmdSetFrontFaceEXT(commandBuffer, frontFace) }
CmdSetLineRasterizationModeEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, lineRasterizationMode: LineRasterizationModeEXT) { PtrCmdSetLineRasterizationModeEXT(commandBuffer, lineRasterizationMode) }
CmdSetLineStipple                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16) { PtrCmdSetLineStipple(commandBuffer, lineStippleFactor, lineStipplePattern) }
CmdSetLineStippleEXT                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16) { PtrCmdSetLineStippleEXT(commandBuffer, lineStippleFactor, lineStipplePattern) }
CmdSetLineStippleEnableEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, stippledLineEnable: b32) { PtrCmdSetLineStippleEnableEXT(commandBuffer, stippledLineEnable) }
CmdSetLineStippleKHR                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, lineStippleFactor: u32, lineStipplePattern: u16) { PtrCmdSetLineStippleKHR(commandBuffer, lineStippleFactor, lineStipplePattern) }
CmdSetLineWidth                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, lineWidth: f32) { PtrCmdSetLineWidth(commandBuffer, lineWidth) }
CmdSetLogicOpEXT                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, logicOp: LogicOp) { PtrCmdSetLogicOpEXT(commandBuffer, logicOp) }
CmdSetLogicOpEnableEXT                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, logicOpEnable: b32) { PtrCmdSetLogicOpEnableEXT(commandBuffer, logicOpEnable) }
CmdSetPatchControlPointsEXT                            :: #force_inline proc "system" (commandBuffer: CommandBuffer, patchControlPoints: u32) { PtrCmdSetPatchControlPointsEXT(commandBuffer, patchControlPoints) }
CmdSetPerformanceMarkerINTEL                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^PerformanceMarkerInfoINTEL) -> Result { return PtrCmdSetPerformanceMarkerINTEL(commandBuffer, pMarkerInfo) }
CmdSetPerformanceOverrideINTEL                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, pOverrideInfo: ^PerformanceOverrideInfoINTEL) -> Result { return PtrCmdSetPerformanceOverrideINTEL(commandBuffer, pOverrideInfo) }
CmdSetPerformanceStreamMarkerINTEL                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pMarkerInfo: ^PerformanceStreamMarkerInfoINTEL) -> Result { return PtrCmdSetPerformanceStreamMarkerINTEL(commandBuffer, pMarkerInfo) }
CmdSetPolygonModeEXT                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, polygonMode: PolygonMode) { PtrCmdSetPolygonModeEXT(commandBuffer, polygonMode) }
CmdSetPrimitiveRestartEnable                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, primitiveRestartEnable: b32) { PtrCmdSetPrimitiveRestartEnable(commandBuffer, primitiveRestartEnable) }
CmdSetPrimitiveRestartEnableEXT                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, primitiveRestartEnable: b32) { PtrCmdSetPrimitiveRestartEnableEXT(commandBuffer, primitiveRestartEnable) }
CmdSetPrimitiveRestartIndexEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, primitiveRestartIndex: u32) { PtrCmdSetPrimitiveRestartIndexEXT(commandBuffer, primitiveRestartIndex) }
CmdSetPrimitiveTopology                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, primitiveTopology: PrimitiveTopology) { PtrCmdSetPrimitiveTopology(commandBuffer, primitiveTopology) }
CmdSetPrimitiveTopologyEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, primitiveTopology: PrimitiveTopology) { PtrCmdSetPrimitiveTopologyEXT(commandBuffer, primitiveTopology) }
CmdSetProvokingVertexModeEXT                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, provokingVertexMode: ProvokingVertexModeEXT) { PtrCmdSetProvokingVertexModeEXT(commandBuffer, provokingVertexMode) }
CmdSetRasterizationSamplesEXT                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, rasterizationSamples: SampleCountFlags) { PtrCmdSetRasterizationSamplesEXT(commandBuffer, rasterizationSamples) }
CmdSetRasterizationStreamEXT                           :: #force_inline proc "system" (commandBuffer: CommandBuffer, rasterizationStream: u32) { PtrCmdSetRasterizationStreamEXT(commandBuffer, rasterizationStream) }
CmdSetRasterizerDiscardEnable                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, rasterizerDiscardEnable: b32) { PtrCmdSetRasterizerDiscardEnable(commandBuffer, rasterizerDiscardEnable) }
CmdSetRasterizerDiscardEnableEXT                       :: #force_inline proc "system" (commandBuffer: CommandBuffer, rasterizerDiscardEnable: b32) { PtrCmdSetRasterizerDiscardEnableEXT(commandBuffer, rasterizerDiscardEnable) }
CmdSetRayTracingPipelineStackSizeKHR                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineStackSize: u32) { PtrCmdSetRayTracingPipelineStackSizeKHR(commandBuffer, pipelineStackSize) }
CmdSetRenderingAttachmentLocations                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLocationInfo: ^RenderingAttachmentLocationInfo) { PtrCmdSetRenderingAttachmentLocations(commandBuffer, pLocationInfo) }
CmdSetRenderingAttachmentLocationsKHR                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pLocationInfo: ^RenderingAttachmentLocationInfo) { PtrCmdSetRenderingAttachmentLocationsKHR(commandBuffer, pLocationInfo) }
CmdSetRenderingInputAttachmentIndices                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInputAttachmentIndexInfo: ^RenderingInputAttachmentIndexInfo) { PtrCmdSetRenderingInputAttachmentIndices(commandBuffer, pInputAttachmentIndexInfo) }
CmdSetRenderingInputAttachmentIndicesKHR               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInputAttachmentIndexInfo: ^RenderingInputAttachmentIndexInfo) { PtrCmdSetRenderingInputAttachmentIndicesKHR(commandBuffer, pInputAttachmentIndexInfo) }
CmdSetRepresentativeFragmentTestEnableNV               :: #force_inline proc "system" (commandBuffer: CommandBuffer, representativeFragmentTestEnable: b32) { PtrCmdSetRepresentativeFragmentTestEnableNV(commandBuffer, representativeFragmentTestEnable) }
CmdSetSampleLocationsEXT                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, pSampleLocationsInfo: ^SampleLocationsInfoEXT) { PtrCmdSetSampleLocationsEXT(commandBuffer, pSampleLocationsInfo) }
CmdSetSampleLocationsEnableEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, sampleLocationsEnable: b32) { PtrCmdSetSampleLocationsEnableEXT(commandBuffer, sampleLocationsEnable) }
CmdSetSampleMaskEXT                                    :: #force_inline proc "system" (commandBuffer: CommandBuffer, samples: SampleCountFlags, pSampleMask: ^SampleMask) { PtrCmdSetSampleMaskEXT(commandBuffer, samples, pSampleMask) }
CmdSetScissor                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstScissor: u32, scissorCount: u32, pScissors: [^]Rect2D) { PtrCmdSetScissor(commandBuffer, firstScissor, scissorCount, pScissors) }
CmdSetScissorWithCount                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, scissorCount: u32, pScissors: [^]Rect2D) { PtrCmdSetScissorWithCount(commandBuffer, scissorCount, pScissors) }
CmdSetScissorWithCountEXT                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, scissorCount: u32, pScissors: [^]Rect2D) { PtrCmdSetScissorWithCountEXT(commandBuffer, scissorCount, pScissors) }
CmdSetShadingRateImageEnableNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, shadingRateImageEnable: b32) { PtrCmdSetShadingRateImageEnableNV(commandBuffer, shadingRateImageEnable) }
CmdSetStencilCompareMask                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, compareMask: u32) { PtrCmdSetStencilCompareMask(commandBuffer, faceMask, compareMask) }
CmdSetStencilOp                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, failOp: StencilOp, passOp: StencilOp, depthFailOp: StencilOp, compareOp: CompareOp) { PtrCmdSetStencilOp(commandBuffer, faceMask, failOp, passOp, depthFailOp, compareOp) }
CmdSetStencilOpEXT                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, failOp: StencilOp, passOp: StencilOp, depthFailOp: StencilOp, compareOp: CompareOp) { PtrCmdSetStencilOpEXT(commandBuffer, faceMask, failOp, passOp, depthFailOp, compareOp) }
CmdSetStencilReference                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, reference: u32) { PtrCmdSetStencilReference(commandBuffer, faceMask, reference) }
CmdSetStencilTestEnable                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, stencilTestEnable: b32) { PtrCmdSetStencilTestEnable(commandBuffer, stencilTestEnable) }
CmdSetStencilTestEnableEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, stencilTestEnable: b32) { PtrCmdSetStencilTestEnableEXT(commandBuffer, stencilTestEnable) }
CmdSetStencilWriteMask                                 :: #force_inline proc "system" (commandBuffer: CommandBuffer, faceMask: StencilFaceFlags, writeMask: u32) { PtrCmdSetStencilWriteMask(commandBuffer, faceMask, writeMask) }
CmdSetTessellationDomainOriginEXT                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, domainOrigin: TessellationDomainOrigin) { PtrCmdSetTessellationDomainOriginEXT(commandBuffer, domainOrigin) }
CmdSetVertexInputEXT                                   :: #force_inline proc "system" (commandBuffer: CommandBuffer, vertexBindingDescriptionCount: u32, pVertexBindingDescriptions: [^]VertexInputBindingDescription2EXT, vertexAttributeDescriptionCount: u32, pVertexAttributeDescriptions: [^]VertexInputAttributeDescription2EXT) { PtrCmdSetVertexInputEXT(commandBuffer, vertexBindingDescriptionCount, pVertexBindingDescriptions, vertexAttributeDescriptionCount, pVertexAttributeDescriptions) }
CmdSetViewport                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewports: [^]Viewport) { PtrCmdSetViewport(commandBuffer, firstViewport, viewportCount, pViewports) }
CmdSetViewportShadingRatePaletteNV                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pShadingRatePalettes: [^]ShadingRatePaletteNV) { PtrCmdSetViewportShadingRatePaletteNV(commandBuffer, firstViewport, viewportCount, pShadingRatePalettes) }
CmdSetViewportSwizzleNV                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewportSwizzles: [^]ViewportSwizzleNV) { PtrCmdSetViewportSwizzleNV(commandBuffer, firstViewport, viewportCount, pViewportSwizzles) }
CmdSetViewportWScalingEnableNV                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, viewportWScalingEnable: b32) { PtrCmdSetViewportWScalingEnableNV(commandBuffer, viewportWScalingEnable) }
CmdSetViewportWScalingNV                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, firstViewport: u32, viewportCount: u32, pViewportWScalings: [^]ViewportWScalingNV) { PtrCmdSetViewportWScalingNV(commandBuffer, firstViewport, viewportCount, pViewportWScalings) }
CmdSetViewportWithCount                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, viewportCount: u32, pViewports: [^]Viewport) { PtrCmdSetViewportWithCount(commandBuffer, viewportCount, pViewports) }
CmdSetViewportWithCountEXT                             :: #force_inline proc "system" (commandBuffer: CommandBuffer, viewportCount: u32, pViewports: [^]Viewport) { PtrCmdSetViewportWithCountEXT(commandBuffer, viewportCount, pViewports) }
CmdSubpassShadingHUAWEI                                :: #force_inline proc "system" (commandBuffer: CommandBuffer) { PtrCmdSubpassShadingHUAWEI(commandBuffer) }
CmdTraceRaysIndirect2KHR                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, indirectDeviceAddress: DeviceAddress) { PtrCmdTraceRaysIndirect2KHR(commandBuffer, indirectDeviceAddress) }
CmdTraceRaysIndirectKHR                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRaygenShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pMissShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pHitShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pCallableShaderBindingTable: [^]StridedDeviceAddressRegionKHR, indirectDeviceAddress: DeviceAddress) { PtrCmdTraceRaysIndirectKHR(commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, indirectDeviceAddress) }
CmdTraceRaysKHR                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, pRaygenShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pMissShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pHitShaderBindingTable: [^]StridedDeviceAddressRegionKHR, pCallableShaderBindingTable: [^]StridedDeviceAddressRegionKHR, width: u32, height: u32, depth: u32) { PtrCmdTraceRaysKHR(commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, width, height, depth) }
CmdTraceRaysNV                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, raygenShaderBindingTableBuffer: Buffer, raygenShaderBindingOffset: DeviceSize, missShaderBindingTableBuffer: Buffer, missShaderBindingOffset: DeviceSize, missShaderBindingStride: DeviceSize, hitShaderBindingTableBuffer: Buffer, hitShaderBindingOffset: DeviceSize, hitShaderBindingStride: DeviceSize, callableShaderBindingTableBuffer: Buffer, callableShaderBindingOffset: DeviceSize, callableShaderBindingStride: DeviceSize, width: u32, height: u32, depth: u32) { PtrCmdTraceRaysNV(commandBuffer, raygenShaderBindingTableBuffer, raygenShaderBindingOffset, missShaderBindingTableBuffer, missShaderBindingOffset, missShaderBindingStride, hitShaderBindingTableBuffer, hitShaderBindingOffset, hitShaderBindingStride, callableShaderBindingTableBuffer, callableShaderBindingOffset, callableShaderBindingStride, width, height, depth) }
CmdUpdateBuffer                                        :: #force_inline proc "system" (commandBuffer: CommandBuffer, dstBuffer: Buffer, dstOffset: DeviceSize, dataSize: DeviceSize, pData: rawptr) { PtrCmdUpdateBuffer(commandBuffer, dstBuffer, dstOffset, dataSize, pData) }
CmdUpdateMemoryKHR                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, pDstRange: ^DeviceAddressRangeKHR, dstFlags: AddressCommandFlagsKHR, dataSize: DeviceSize, pData: rawptr) { PtrCmdUpdateMemoryKHR(commandBuffer, pDstRange, dstFlags, dataSize, pData) }
CmdUpdatePipelineIndirectBufferNV                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineBindPoint: PipelineBindPoint, pipeline: Pipeline) { PtrCmdUpdatePipelineIndirectBufferNV(commandBuffer, pipelineBindPoint, pipeline) }
CmdWaitEvents                                          :: #force_inline proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, srcStageMask: PipelineStageFlags, dstStageMask: PipelineStageFlags, memoryBarrierCount: u32, pMemoryBarriers: [^]MemoryBarrier, bufferMemoryBarrierCount: u32, pBufferMemoryBarriers: [^]BufferMemoryBarrier, imageMemoryBarrierCount: u32, pImageMemoryBarriers: [^]ImageMemoryBarrier) { PtrCmdWaitEvents(commandBuffer, eventCount, pEvents, srcStageMask, dstStageMask, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers) }
CmdWaitEvents2                                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, pDependencyInfos: [^]DependencyInfo) { PtrCmdWaitEvents2(commandBuffer, eventCount, pEvents, pDependencyInfos) }
CmdWaitEvents2KHR                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, eventCount: u32, pEvents: [^]Event, pDependencyInfos: [^]DependencyInfo) { PtrCmdWaitEvents2KHR(commandBuffer, eventCount, pEvents, pDependencyInfos) }
CmdWriteAccelerationStructuresPropertiesKHR            :: #force_inline proc "system" (commandBuffer: CommandBuffer, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureKHR, queryType: QueryType, queryPool: QueryPool, firstQuery: u32) { PtrCmdWriteAccelerationStructuresPropertiesKHR(commandBuffer, accelerationStructureCount, pAccelerationStructures, queryType, queryPool, firstQuery) }
CmdWriteAccelerationStructuresPropertiesNV             :: #force_inline proc "system" (commandBuffer: CommandBuffer, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureNV, queryType: QueryType, queryPool: QueryPool, firstQuery: u32) { PtrCmdWriteAccelerationStructuresPropertiesNV(commandBuffer, accelerationStructureCount, pAccelerationStructures, queryType, queryPool, firstQuery) }
CmdWriteBufferMarker2AMD                               :: #force_inline proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, dstBuffer: Buffer, dstOffset: DeviceSize, marker: u32) { PtrCmdWriteBufferMarker2AMD(commandBuffer, stage, dstBuffer, dstOffset, marker) }
CmdWriteBufferMarkerAMD                                :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineStage: PipelineStageFlags, dstBuffer: Buffer, dstOffset: DeviceSize, marker: u32) { PtrCmdWriteBufferMarkerAMD(commandBuffer, pipelineStage, dstBuffer, dstOffset, marker) }
CmdWriteMarkerToMemoryAMD                              :: #force_inline proc "system" (commandBuffer: CommandBuffer, pInfo: ^MemoryMarkerInfoAMD) { PtrCmdWriteMarkerToMemoryAMD(commandBuffer, pInfo) }
CmdWriteMicromapsPropertiesEXT                         :: #force_inline proc "system" (commandBuffer: CommandBuffer, micromapCount: u32, pMicromaps: [^]MicromapEXT, queryType: QueryType, queryPool: QueryPool, firstQuery: u32) { PtrCmdWriteMicromapsPropertiesEXT(commandBuffer, micromapCount, pMicromaps, queryType, queryPool, firstQuery) }
CmdWriteTimestamp                                      :: #force_inline proc "system" (commandBuffer: CommandBuffer, pipelineStage: PipelineStageFlags, queryPool: QueryPool, query: u32) { PtrCmdWriteTimestamp(commandBuffer, pipelineStage, queryPool, query) }
CmdWriteTimestamp2                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, queryPool: QueryPool, query: u32) { PtrCmdWriteTimestamp2(commandBuffer, stage, queryPool, query) }
CmdWriteTimestamp2KHR                                  :: #force_inline proc "system" (commandBuffer: CommandBuffer, stage: PipelineStageFlags2, queryPool: QueryPool, query: u32) { PtrCmdWriteTimestamp2KHR(commandBuffer, stage, queryPool, query) }
CompileDeferredNV                                      :: #force_inline proc "system" (device: Device, pipeline: Pipeline, shader: u32) -> Result { return PtrCompileDeferredNV(device, pipeline, shader) }
ConvertCooperativeVectorMatrixNV                       :: #force_inline proc "system" (device: Device, pInfo: ^ConvertCooperativeVectorMatrixInfoNV) -> Result { return PtrConvertCooperativeVectorMatrixNV(device, pInfo) }
CopyAccelerationStructureKHR                           :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyAccelerationStructureInfoKHR) -> Result { return PtrCopyAccelerationStructureKHR(device, deferredOperation, pInfo) }
CopyAccelerationStructureToMemoryKHR                   :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyAccelerationStructureToMemoryInfoKHR) -> Result { return PtrCopyAccelerationStructureToMemoryKHR(device, deferredOperation, pInfo) }
CopyImageToImage                                       :: #force_inline proc "system" (device: Device, pCopyImageToImageInfo: ^CopyImageToImageInfo) -> Result { return PtrCopyImageToImage(device, pCopyImageToImageInfo) }
CopyImageToImageEXT                                    :: #force_inline proc "system" (device: Device, pCopyImageToImageInfo: ^CopyImageToImageInfo) -> Result { return PtrCopyImageToImageEXT(device, pCopyImageToImageInfo) }
CopyImageToMemory                                      :: #force_inline proc "system" (device: Device, pCopyImageToMemoryInfo: ^CopyImageToMemoryInfo) -> Result { return PtrCopyImageToMemory(device, pCopyImageToMemoryInfo) }
CopyImageToMemoryEXT                                   :: #force_inline proc "system" (device: Device, pCopyImageToMemoryInfo: ^CopyImageToMemoryInfo) -> Result { return PtrCopyImageToMemoryEXT(device, pCopyImageToMemoryInfo) }
CopyMemoryToAccelerationStructureKHR                   :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMemoryToAccelerationStructureInfoKHR) -> Result { return PtrCopyMemoryToAccelerationStructureKHR(device, deferredOperation, pInfo) }
CopyMemoryToImage                                      :: #force_inline proc "system" (device: Device, pCopyMemoryToImageInfo: ^CopyMemoryToImageInfo) -> Result { return PtrCopyMemoryToImage(device, pCopyMemoryToImageInfo) }
CopyMemoryToImageEXT                                   :: #force_inline proc "system" (device: Device, pCopyMemoryToImageInfo: ^CopyMemoryToImageInfo) -> Result { return PtrCopyMemoryToImageEXT(device, pCopyMemoryToImageInfo) }
CopyMemoryToMicromapEXT                                :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMemoryToMicromapInfoEXT) -> Result { return PtrCopyMemoryToMicromapEXT(device, deferredOperation, pInfo) }
CopyMicromapEXT                                        :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMicromapInfoEXT) -> Result { return PtrCopyMicromapEXT(device, deferredOperation, pInfo) }
CopyMicromapToMemoryEXT                                :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pInfo: ^CopyMicromapToMemoryInfoEXT) -> Result { return PtrCopyMicromapToMemoryEXT(device, deferredOperation, pInfo) }
CreateAccelerationStructure2KHR                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfo2KHR, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureKHR) -> Result { return PtrCreateAccelerationStructure2KHR(device, pCreateInfo, pAllocator, pAccelerationStructure) }
CreateAccelerationStructureKHR                         :: #force_inline proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfoKHR, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureKHR) -> Result { return PtrCreateAccelerationStructureKHR(device, pCreateInfo, pAllocator, pAccelerationStructure) }
CreateAccelerationStructureNV                          :: #force_inline proc "system" (device: Device, pCreateInfo: ^AccelerationStructureCreateInfoNV, pAllocator: ^AllocationCallbacks, pAccelerationStructure: ^AccelerationStructureNV) -> Result { return PtrCreateAccelerationStructureNV(device, pCreateInfo, pAllocator, pAccelerationStructure) }
CreateBuffer                                           :: #force_inline proc "system" (device: Device, pCreateInfo: ^BufferCreateInfo, pAllocator: ^AllocationCallbacks, pBuffer: ^Buffer) -> Result { return PtrCreateBuffer(device, pCreateInfo, pAllocator, pBuffer) }
CreateBufferView                                       :: #force_inline proc "system" (device: Device, pCreateInfo: ^BufferViewCreateInfo, pAllocator: ^AllocationCallbacks, pView: ^BufferView) -> Result { return PtrCreateBufferView(device, pCreateInfo, pAllocator, pView) }
CreateCommandPool                                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^CommandPoolCreateInfo, pAllocator: ^AllocationCallbacks, pCommandPool: ^CommandPool) -> Result { return PtrCreateCommandPool(device, pCreateInfo, pAllocator, pCommandPool) }
CreateComputePipelines                                 :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]ComputePipelineCreateInfo, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateComputePipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateCuFunctionNVX                                    :: #force_inline proc "system" (device: Device, pCreateInfo: ^CuFunctionCreateInfoNVX, pAllocator: ^AllocationCallbacks, pFunction: ^CuFunctionNVX) -> Result { return PtrCreateCuFunctionNVX(device, pCreateInfo, pAllocator, pFunction) }
CreateCuModuleNVX                                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^CuModuleCreateInfoNVX, pAllocator: ^AllocationCallbacks, pModule: ^CuModuleNVX) -> Result { return PtrCreateCuModuleNVX(device, pCreateInfo, pAllocator, pModule) }
CreateCudaFunctionNV                                   :: #force_inline proc "system" (device: Device, pCreateInfo: ^CudaFunctionCreateInfoNV, pAllocator: ^AllocationCallbacks, pFunction: ^CudaFunctionNV) -> Result { return PtrCreateCudaFunctionNV(device, pCreateInfo, pAllocator, pFunction) }
CreateCudaModuleNV                                     :: #force_inline proc "system" (device: Device, pCreateInfo: ^CudaModuleCreateInfoNV, pAllocator: ^AllocationCallbacks, pModule: ^CudaModuleNV) -> Result { return PtrCreateCudaModuleNV(device, pCreateInfo, pAllocator, pModule) }
CreateDataGraphPipelineSessionARM                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^DataGraphPipelineSessionCreateInfoARM, pAllocator: ^AllocationCallbacks, pSession: ^DataGraphPipelineSessionARM) -> Result { return PtrCreateDataGraphPipelineSessionARM(device, pCreateInfo, pAllocator, pSession) }
CreateDataGraphPipelinesARM                            :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]DataGraphPipelineCreateInfoARM, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateDataGraphPipelinesARM(device, deferredOperation, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateDeferredOperationKHR                             :: #force_inline proc "system" (device: Device, pAllocator: ^AllocationCallbacks, pDeferredOperation: ^DeferredOperationKHR) -> Result { return PtrCreateDeferredOperationKHR(device, pAllocator, pDeferredOperation) }
CreateDescriptorPool                                   :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorPoolCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorPool: ^DescriptorPool) -> Result { return PtrCreateDescriptorPool(device, pCreateInfo, pAllocator, pDescriptorPool) }
CreateDescriptorSetLayout                              :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pAllocator: ^AllocationCallbacks, pSetLayout: ^DescriptorSetLayout) -> Result { return PtrCreateDescriptorSetLayout(device, pCreateInfo, pAllocator, pSetLayout) }
CreateDescriptorUpdateTemplate                         :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorUpdateTemplateCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorUpdateTemplate: ^DescriptorUpdateTemplate) -> Result { return PtrCreateDescriptorUpdateTemplate(device, pCreateInfo, pAllocator, pDescriptorUpdateTemplate) }
CreateDescriptorUpdateTemplateKHR                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorUpdateTemplateCreateInfo, pAllocator: ^AllocationCallbacks, pDescriptorUpdateTemplate: ^DescriptorUpdateTemplate) -> Result { return PtrCreateDescriptorUpdateTemplateKHR(device, pCreateInfo, pAllocator, pDescriptorUpdateTemplate) }
CreateEvent                                            :: #force_inline proc "system" (device: Device, pCreateInfo: ^EventCreateInfo, pAllocator: ^AllocationCallbacks, pEvent: ^Event) -> Result { return PtrCreateEvent(device, pCreateInfo, pAllocator, pEvent) }
CreateExecutionGraphPipelinesAMDX                      :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]ExecutionGraphPipelineCreateInfoAMDX, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateExecutionGraphPipelinesAMDX(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateExternalComputeQueueNV                           :: #force_inline proc "system" (device: Device, pCreateInfo: ^ExternalComputeQueueCreateInfoNV, pAllocator: ^AllocationCallbacks, pExternalQueue: ^ExternalComputeQueueNV) -> Result { return PtrCreateExternalComputeQueueNV(device, pCreateInfo, pAllocator, pExternalQueue) }
CreateFence                                            :: #force_inline proc "system" (device: Device, pCreateInfo: ^FenceCreateInfo, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result { return PtrCreateFence(device, pCreateInfo, pAllocator, pFence) }
CreateFramebuffer                                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^FramebufferCreateInfo, pAllocator: ^AllocationCallbacks, pFramebuffer: ^Framebuffer) -> Result { return PtrCreateFramebuffer(device, pCreateInfo, pAllocator, pFramebuffer) }
CreateGpaSessionAMD                                    :: #force_inline proc "system" (device: Device, pCreateInfo: ^GpaSessionCreateInfoAMD, pAllocator: ^AllocationCallbacks, pGpaSession: ^GpaSessionAMD) -> Result { return PtrCreateGpaSessionAMD(device, pCreateInfo, pAllocator, pGpaSession) }
CreateGraphicsPipelines                                :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]GraphicsPipelineCreateInfo, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateGraphicsPipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateImage                                            :: #force_inline proc "system" (device: Device, pCreateInfo: ^ImageCreateInfo, pAllocator: ^AllocationCallbacks, pImage: ^Image) -> Result { return PtrCreateImage(device, pCreateInfo, pAllocator, pImage) }
CreateImageView                                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^ImageViewCreateInfo, pAllocator: ^AllocationCallbacks, pView: ^ImageView) -> Result { return PtrCreateImageView(device, pCreateInfo, pAllocator, pView) }
CreateIndirectCommandsLayoutEXT                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^IndirectCommandsLayoutCreateInfoEXT, pAllocator: ^AllocationCallbacks, pIndirectCommandsLayout: ^IndirectCommandsLayoutEXT) -> Result { return PtrCreateIndirectCommandsLayoutEXT(device, pCreateInfo, pAllocator, pIndirectCommandsLayout) }
CreateIndirectCommandsLayoutNV                         :: #force_inline proc "system" (device: Device, pCreateInfo: ^IndirectCommandsLayoutCreateInfoNV, pAllocator: ^AllocationCallbacks, pIndirectCommandsLayout: ^IndirectCommandsLayoutNV) -> Result { return PtrCreateIndirectCommandsLayoutNV(device, pCreateInfo, pAllocator, pIndirectCommandsLayout) }
CreateIndirectExecutionSetEXT                          :: #force_inline proc "system" (device: Device, pCreateInfo: ^IndirectExecutionSetCreateInfoEXT, pAllocator: ^AllocationCallbacks, pIndirectExecutionSet: ^IndirectExecutionSetEXT) -> Result { return PtrCreateIndirectExecutionSetEXT(device, pCreateInfo, pAllocator, pIndirectExecutionSet) }
CreateMicromapEXT                                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^MicromapCreateInfoEXT, pAllocator: ^AllocationCallbacks, pMicromap: ^MicromapEXT) -> Result { return PtrCreateMicromapEXT(device, pCreateInfo, pAllocator, pMicromap) }
CreateOpticalFlowSessionNV                             :: #force_inline proc "system" (device: Device, pCreateInfo: ^OpticalFlowSessionCreateInfoNV, pAllocator: ^AllocationCallbacks, pSession: ^OpticalFlowSessionNV) -> Result { return PtrCreateOpticalFlowSessionNV(device, pCreateInfo, pAllocator, pSession) }
CreatePipelineBinariesKHR                              :: #force_inline proc "system" (device: Device, pCreateInfo: ^PipelineBinaryCreateInfoKHR, pAllocator: ^AllocationCallbacks, pBinaries: [^]PipelineBinaryHandlesInfoKHR) -> Result { return PtrCreatePipelineBinariesKHR(device, pCreateInfo, pAllocator, pBinaries) }
CreatePipelineCache                                    :: #force_inline proc "system" (device: Device, pCreateInfo: ^PipelineCacheCreateInfo, pAllocator: ^AllocationCallbacks, pPipelineCache: ^PipelineCache) -> Result { return PtrCreatePipelineCache(device, pCreateInfo, pAllocator, pPipelineCache) }
CreatePipelineLayout                                   :: #force_inline proc "system" (device: Device, pCreateInfo: ^PipelineLayoutCreateInfo, pAllocator: ^AllocationCallbacks, pPipelineLayout: ^PipelineLayout) -> Result { return PtrCreatePipelineLayout(device, pCreateInfo, pAllocator, pPipelineLayout) }
CreatePrivateDataSlot                                  :: #force_inline proc "system" (device: Device, pCreateInfo: ^PrivateDataSlotCreateInfo, pAllocator: ^AllocationCallbacks, pPrivateDataSlot: ^PrivateDataSlot) -> Result { return PtrCreatePrivateDataSlot(device, pCreateInfo, pAllocator, pPrivateDataSlot) }
CreatePrivateDataSlotEXT                               :: #force_inline proc "system" (device: Device, pCreateInfo: ^PrivateDataSlotCreateInfo, pAllocator: ^AllocationCallbacks, pPrivateDataSlot: ^PrivateDataSlot) -> Result { return PtrCreatePrivateDataSlotEXT(device, pCreateInfo, pAllocator, pPrivateDataSlot) }
CreateQueryPool                                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^QueryPoolCreateInfo, pAllocator: ^AllocationCallbacks, pQueryPool: ^QueryPool) -> Result { return PtrCreateQueryPool(device, pCreateInfo, pAllocator, pQueryPool) }
CreateRayTracingPipelinesKHR                           :: #force_inline proc "system" (device: Device, deferredOperation: DeferredOperationKHR, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]RayTracingPipelineCreateInfoKHR, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateRayTracingPipelinesKHR(device, deferredOperation, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateRayTracingPipelinesNV                            :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, createInfoCount: u32, pCreateInfos: [^]RayTracingPipelineCreateInfoNV, pAllocator: ^AllocationCallbacks, pPipelines: [^]Pipeline) -> Result { return PtrCreateRayTracingPipelinesNV(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines) }
CreateRenderPass                                       :: #force_inline proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result { return PtrCreateRenderPass(device, pCreateInfo, pAllocator, pRenderPass) }
CreateRenderPass2                                      :: #force_inline proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo2, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result { return PtrCreateRenderPass2(device, pCreateInfo, pAllocator, pRenderPass) }
CreateRenderPass2KHR                                   :: #force_inline proc "system" (device: Device, pCreateInfo: ^RenderPassCreateInfo2, pAllocator: ^AllocationCallbacks, pRenderPass: [^]RenderPass) -> Result { return PtrCreateRenderPass2KHR(device, pCreateInfo, pAllocator, pRenderPass) }
CreateSampler                                          :: #force_inline proc "system" (device: Device, pCreateInfo: ^SamplerCreateInfo, pAllocator: ^AllocationCallbacks, pSampler: ^Sampler) -> Result { return PtrCreateSampler(device, pCreateInfo, pAllocator, pSampler) }
CreateSamplerYcbcrConversion                           :: #force_inline proc "system" (device: Device, pCreateInfo: ^SamplerYcbcrConversionCreateInfo, pAllocator: ^AllocationCallbacks, pYcbcrConversion: ^SamplerYcbcrConversion) -> Result { return PtrCreateSamplerYcbcrConversion(device, pCreateInfo, pAllocator, pYcbcrConversion) }
CreateSamplerYcbcrConversionKHR                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^SamplerYcbcrConversionCreateInfo, pAllocator: ^AllocationCallbacks, pYcbcrConversion: ^SamplerYcbcrConversion) -> Result { return PtrCreateSamplerYcbcrConversionKHR(device, pCreateInfo, pAllocator, pYcbcrConversion) }
CreateSemaphore                                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^SemaphoreCreateInfo, pAllocator: ^AllocationCallbacks, pSemaphore: ^Semaphore) -> Result { return PtrCreateSemaphore(device, pCreateInfo, pAllocator, pSemaphore) }
CreateShaderInstrumentationARM                         :: #force_inline proc "system" (device: Device, pCreateInfo: ^ShaderInstrumentationCreateInfoARM, pAllocator: ^AllocationCallbacks, pInstrumentation: ^ShaderInstrumentationARM) -> Result { return PtrCreateShaderInstrumentationARM(device, pCreateInfo, pAllocator, pInstrumentation) }
CreateShaderModule                                     :: #force_inline proc "system" (device: Device, pCreateInfo: ^ShaderModuleCreateInfo, pAllocator: ^AllocationCallbacks, pShaderModule: ^ShaderModule) -> Result { return PtrCreateShaderModule(device, pCreateInfo, pAllocator, pShaderModule) }
CreateShadersEXT                                       :: #force_inline proc "system" (device: Device, createInfoCount: u32, pCreateInfos: [^]ShaderCreateInfoEXT, pAllocator: ^AllocationCallbacks, pShaders: [^]ShaderEXT) -> Result { return PtrCreateShadersEXT(device, createInfoCount, pCreateInfos, pAllocator, pShaders) }
CreateSharedSwapchainsKHR                              :: #force_inline proc "system" (device: Device, swapchainCount: u32, pCreateInfos: [^]SwapchainCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSwapchains: [^]SwapchainKHR) -> Result { return PtrCreateSharedSwapchainsKHR(device, swapchainCount, pCreateInfos, pAllocator, pSwapchains) }
CreateSwapchainKHR                                     :: #force_inline proc "system" (device: Device, pCreateInfo: ^SwapchainCreateInfoKHR, pAllocator: ^AllocationCallbacks, pSwapchain: ^SwapchainKHR) -> Result { return PtrCreateSwapchainKHR(device, pCreateInfo, pAllocator, pSwapchain) }
CreateTensorARM                                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^TensorCreateInfoARM, pAllocator: ^AllocationCallbacks, pTensor: ^TensorARM) -> Result { return PtrCreateTensorARM(device, pCreateInfo, pAllocator, pTensor) }
CreateTensorViewARM                                    :: #force_inline proc "system" (device: Device, pCreateInfo: ^TensorViewCreateInfoARM, pAllocator: ^AllocationCallbacks, pView: ^TensorViewARM) -> Result { return PtrCreateTensorViewARM(device, pCreateInfo, pAllocator, pView) }
CreateValidationCacheEXT                               :: #force_inline proc "system" (device: Device, pCreateInfo: ^ValidationCacheCreateInfoEXT, pAllocator: ^AllocationCallbacks, pValidationCache: ^ValidationCacheEXT) -> Result { return PtrCreateValidationCacheEXT(device, pCreateInfo, pAllocator, pValidationCache) }
CreateVideoSessionKHR                                  :: #force_inline proc "system" (device: Device, pCreateInfo: ^VideoSessionCreateInfoKHR, pAllocator: ^AllocationCallbacks, pVideoSession: ^VideoSessionKHR) -> Result { return PtrCreateVideoSessionKHR(device, pCreateInfo, pAllocator, pVideoSession) }
CreateVideoSessionParametersKHR                        :: #force_inline proc "system" (device: Device, pCreateInfo: ^VideoSessionParametersCreateInfoKHR, pAllocator: ^AllocationCallbacks, pVideoSessionParameters: [^]VideoSessionParametersKHR) -> Result { return PtrCreateVideoSessionParametersKHR(device, pCreateInfo, pAllocator, pVideoSessionParameters) }
DebugMarkerSetObjectNameEXT                            :: #force_inline proc "system" (device: Device, pNameInfo: ^DebugMarkerObjectNameInfoEXT) -> Result { return PtrDebugMarkerSetObjectNameEXT(device, pNameInfo) }
DebugMarkerSetObjectTagEXT                             :: #force_inline proc "system" (device: Device, pTagInfo: ^DebugMarkerObjectTagInfoEXT) -> Result { return PtrDebugMarkerSetObjectTagEXT(device, pTagInfo) }
DeferredOperationJoinKHR                               :: #force_inline proc "system" (device: Device, operation: DeferredOperationKHR) -> Result { return PtrDeferredOperationJoinKHR(device, operation) }
DestroyAccelerationStructureKHR                        :: #force_inline proc "system" (device: Device, accelerationStructure: AccelerationStructureKHR, pAllocator: ^AllocationCallbacks) { PtrDestroyAccelerationStructureKHR(device, accelerationStructure, pAllocator) }
DestroyAccelerationStructureNV                         :: #force_inline proc "system" (device: Device, accelerationStructure: AccelerationStructureNV, pAllocator: ^AllocationCallbacks) { PtrDestroyAccelerationStructureNV(device, accelerationStructure, pAllocator) }
DestroyBuffer                                          :: #force_inline proc "system" (device: Device, buffer: Buffer, pAllocator: ^AllocationCallbacks) { PtrDestroyBuffer(device, buffer, pAllocator) }
DestroyBufferView                                      :: #force_inline proc "system" (device: Device, bufferView: BufferView, pAllocator: ^AllocationCallbacks) { PtrDestroyBufferView(device, bufferView, pAllocator) }
DestroyCommandPool                                     :: #force_inline proc "system" (device: Device, commandPool: CommandPool, pAllocator: ^AllocationCallbacks) { PtrDestroyCommandPool(device, commandPool, pAllocator) }
DestroyCuFunctionNVX                                   :: #force_inline proc "system" (device: Device, function: CuFunctionNVX, pAllocator: ^AllocationCallbacks) { PtrDestroyCuFunctionNVX(device, function, pAllocator) }
DestroyCuModuleNVX                                     :: #force_inline proc "system" (device: Device, module: CuModuleNVX, pAllocator: ^AllocationCallbacks) { PtrDestroyCuModuleNVX(device, module, pAllocator) }
DestroyCudaFunctionNV                                  :: #force_inline proc "system" (device: Device, function: CudaFunctionNV, pAllocator: ^AllocationCallbacks) { PtrDestroyCudaFunctionNV(device, function, pAllocator) }
DestroyCudaModuleNV                                    :: #force_inline proc "system" (device: Device, module: CudaModuleNV, pAllocator: ^AllocationCallbacks) { PtrDestroyCudaModuleNV(device, module, pAllocator) }
DestroyDataGraphPipelineSessionARM                     :: #force_inline proc "system" (device: Device, session: DataGraphPipelineSessionARM, pAllocator: ^AllocationCallbacks) { PtrDestroyDataGraphPipelineSessionARM(device, session, pAllocator) }
DestroyDeferredOperationKHR                            :: #force_inline proc "system" (device: Device, operation: DeferredOperationKHR, pAllocator: ^AllocationCallbacks) { PtrDestroyDeferredOperationKHR(device, operation, pAllocator) }
DestroyDescriptorPool                                  :: #force_inline proc "system" (device: Device, descriptorPool: DescriptorPool, pAllocator: ^AllocationCallbacks) { PtrDestroyDescriptorPool(device, descriptorPool, pAllocator) }
DestroyDescriptorSetLayout                             :: #force_inline proc "system" (device: Device, descriptorSetLayout: DescriptorSetLayout, pAllocator: ^AllocationCallbacks) { PtrDestroyDescriptorSetLayout(device, descriptorSetLayout, pAllocator) }
DestroyDescriptorUpdateTemplate                        :: #force_inline proc "system" (device: Device, descriptorUpdateTemplate: DescriptorUpdateTemplate, pAllocator: ^AllocationCallbacks) { PtrDestroyDescriptorUpdateTemplate(device, descriptorUpdateTemplate, pAllocator) }
DestroyDescriptorUpdateTemplateKHR                     :: #force_inline proc "system" (device: Device, descriptorUpdateTemplate: DescriptorUpdateTemplate, pAllocator: ^AllocationCallbacks) { PtrDestroyDescriptorUpdateTemplateKHR(device, descriptorUpdateTemplate, pAllocator) }
DestroyDevice                                          :: #force_inline proc "system" (device: Device, pAllocator: ^AllocationCallbacks) { PtrDestroyDevice(device, pAllocator) }
DestroyEvent                                           :: #force_inline proc "system" (device: Device, event: Event, pAllocator: ^AllocationCallbacks) { PtrDestroyEvent(device, event, pAllocator) }
DestroyExternalComputeQueueNV                          :: #force_inline proc "system" (device: Device, externalQueue: ExternalComputeQueueNV, pAllocator: ^AllocationCallbacks) { PtrDestroyExternalComputeQueueNV(device, externalQueue, pAllocator) }
DestroyFence                                           :: #force_inline proc "system" (device: Device, fence: Fence, pAllocator: ^AllocationCallbacks) { PtrDestroyFence(device, fence, pAllocator) }
DestroyFramebuffer                                     :: #force_inline proc "system" (device: Device, framebuffer: Framebuffer, pAllocator: ^AllocationCallbacks) { PtrDestroyFramebuffer(device, framebuffer, pAllocator) }
DestroyGpaSessionAMD                                   :: #force_inline proc "system" (device: Device, gpaSession: GpaSessionAMD, pAllocator: ^AllocationCallbacks) { PtrDestroyGpaSessionAMD(device, gpaSession, pAllocator) }
DestroyImage                                           :: #force_inline proc "system" (device: Device, image: Image, pAllocator: ^AllocationCallbacks) { PtrDestroyImage(device, image, pAllocator) }
DestroyImageView                                       :: #force_inline proc "system" (device: Device, imageView: ImageView, pAllocator: ^AllocationCallbacks) { PtrDestroyImageView(device, imageView, pAllocator) }
DestroyIndirectCommandsLayoutEXT                       :: #force_inline proc "system" (device: Device, indirectCommandsLayout: IndirectCommandsLayoutEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyIndirectCommandsLayoutEXT(device, indirectCommandsLayout, pAllocator) }
DestroyIndirectCommandsLayoutNV                        :: #force_inline proc "system" (device: Device, indirectCommandsLayout: IndirectCommandsLayoutNV, pAllocator: ^AllocationCallbacks) { PtrDestroyIndirectCommandsLayoutNV(device, indirectCommandsLayout, pAllocator) }
DestroyIndirectExecutionSetEXT                         :: #force_inline proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyIndirectExecutionSetEXT(device, indirectExecutionSet, pAllocator) }
DestroyMicromapEXT                                     :: #force_inline proc "system" (device: Device, micromap: MicromapEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyMicromapEXT(device, micromap, pAllocator) }
DestroyOpticalFlowSessionNV                            :: #force_inline proc "system" (device: Device, session: OpticalFlowSessionNV, pAllocator: ^AllocationCallbacks) { PtrDestroyOpticalFlowSessionNV(device, session, pAllocator) }
DestroyPipeline                                        :: #force_inline proc "system" (device: Device, pipeline: Pipeline, pAllocator: ^AllocationCallbacks) { PtrDestroyPipeline(device, pipeline, pAllocator) }
DestroyPipelineBinaryKHR                               :: #force_inline proc "system" (device: Device, pipelineBinary: PipelineBinaryKHR, pAllocator: ^AllocationCallbacks) { PtrDestroyPipelineBinaryKHR(device, pipelineBinary, pAllocator) }
DestroyPipelineCache                                   :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, pAllocator: ^AllocationCallbacks) { PtrDestroyPipelineCache(device, pipelineCache, pAllocator) }
DestroyPipelineLayout                                  :: #force_inline proc "system" (device: Device, pipelineLayout: PipelineLayout, pAllocator: ^AllocationCallbacks) { PtrDestroyPipelineLayout(device, pipelineLayout, pAllocator) }
DestroyPrivateDataSlot                                 :: #force_inline proc "system" (device: Device, privateDataSlot: PrivateDataSlot, pAllocator: ^AllocationCallbacks) { PtrDestroyPrivateDataSlot(device, privateDataSlot, pAllocator) }
DestroyPrivateDataSlotEXT                              :: #force_inline proc "system" (device: Device, privateDataSlot: PrivateDataSlot, pAllocator: ^AllocationCallbacks) { PtrDestroyPrivateDataSlotEXT(device, privateDataSlot, pAllocator) }
DestroyQueryPool                                       :: #force_inline proc "system" (device: Device, queryPool: QueryPool, pAllocator: ^AllocationCallbacks) { PtrDestroyQueryPool(device, queryPool, pAllocator) }
DestroyRenderPass                                      :: #force_inline proc "system" (device: Device, renderPass: RenderPass, pAllocator: ^AllocationCallbacks) { PtrDestroyRenderPass(device, renderPass, pAllocator) }
DestroySampler                                         :: #force_inline proc "system" (device: Device, sampler: Sampler, pAllocator: ^AllocationCallbacks) { PtrDestroySampler(device, sampler, pAllocator) }
DestroySamplerYcbcrConversion                          :: #force_inline proc "system" (device: Device, ycbcrConversion: SamplerYcbcrConversion, pAllocator: ^AllocationCallbacks) { PtrDestroySamplerYcbcrConversion(device, ycbcrConversion, pAllocator) }
DestroySamplerYcbcrConversionKHR                       :: #force_inline proc "system" (device: Device, ycbcrConversion: SamplerYcbcrConversion, pAllocator: ^AllocationCallbacks) { PtrDestroySamplerYcbcrConversionKHR(device, ycbcrConversion, pAllocator) }
DestroySemaphore                                       :: #force_inline proc "system" (device: Device, semaphore: Semaphore, pAllocator: ^AllocationCallbacks) { PtrDestroySemaphore(device, semaphore, pAllocator) }
DestroyShaderEXT                                       :: #force_inline proc "system" (device: Device, shader: ShaderEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyShaderEXT(device, shader, pAllocator) }
DestroyShaderInstrumentationARM                        :: #force_inline proc "system" (device: Device, instrumentation: ShaderInstrumentationARM, pAllocator: ^AllocationCallbacks) { PtrDestroyShaderInstrumentationARM(device, instrumentation, pAllocator) }
DestroyShaderModule                                    :: #force_inline proc "system" (device: Device, shaderModule: ShaderModule, pAllocator: ^AllocationCallbacks) { PtrDestroyShaderModule(device, shaderModule, pAllocator) }
DestroySwapchainKHR                                    :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pAllocator: ^AllocationCallbacks) { PtrDestroySwapchainKHR(device, swapchain, pAllocator) }
DestroyTensorARM                                       :: #force_inline proc "system" (device: Device, tensor: TensorARM, pAllocator: ^AllocationCallbacks) { PtrDestroyTensorARM(device, tensor, pAllocator) }
DestroyTensorViewARM                                   :: #force_inline proc "system" (device: Device, tensorView: TensorViewARM, pAllocator: ^AllocationCallbacks) { PtrDestroyTensorViewARM(device, tensorView, pAllocator) }
DestroyValidationCacheEXT                              :: #force_inline proc "system" (device: Device, validationCache: ValidationCacheEXT, pAllocator: ^AllocationCallbacks) { PtrDestroyValidationCacheEXT(device, validationCache, pAllocator) }
DestroyVideoSessionKHR                                 :: #force_inline proc "system" (device: Device, videoSession: VideoSessionKHR, pAllocator: ^AllocationCallbacks) { PtrDestroyVideoSessionKHR(device, videoSession, pAllocator) }
DestroyVideoSessionParametersKHR                       :: #force_inline proc "system" (device: Device, videoSessionParameters: VideoSessionParametersKHR, pAllocator: ^AllocationCallbacks) { PtrDestroyVideoSessionParametersKHR(device, videoSessionParameters, pAllocator) }
DeviceWaitIdle                                         :: #force_inline proc "system" (device: Device) -> Result { return PtrDeviceWaitIdle(device) }
DisplayPowerControlEXT                                 :: #force_inline proc "system" (device: Device, display: DisplayKHR, pDisplayPowerInfo: ^DisplayPowerInfoEXT) -> Result { return PtrDisplayPowerControlEXT(device, display, pDisplayPowerInfo) }
EndCommandBuffer                                       :: #force_inline proc "system" (commandBuffer: CommandBuffer) -> Result { return PtrEndCommandBuffer(commandBuffer) }
ExportMetalObjectsEXT                                  :: #force_inline proc "system" (device: Device, pMetalObjectsInfo: ^ExportMetalObjectsInfoEXT) { PtrExportMetalObjectsEXT(device, pMetalObjectsInfo) }
FlushMappedMemoryRanges                                :: #force_inline proc "system" (device: Device, memoryRangeCount: u32, pMemoryRanges: [^]MappedMemoryRange) -> Result { return PtrFlushMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges) }
FreeCommandBuffers                                     :: #force_inline proc "system" (device: Device, commandPool: CommandPool, commandBufferCount: u32, pCommandBuffers: [^]CommandBuffer) { PtrFreeCommandBuffers(device, commandPool, commandBufferCount, pCommandBuffers) }
FreeDescriptorSets                                     :: #force_inline proc "system" (device: Device, descriptorPool: DescriptorPool, descriptorSetCount: u32, pDescriptorSets: [^]DescriptorSet) -> Result { return PtrFreeDescriptorSets(device, descriptorPool, descriptorSetCount, pDescriptorSets) }
FreeMemory                                             :: #force_inline proc "system" (device: Device, memory: DeviceMemory, pAllocator: ^AllocationCallbacks) { PtrFreeMemory(device, memory, pAllocator) }
GetAccelerationStructureBuildSizesKHR                  :: #force_inline proc "system" (device: Device, buildType: AccelerationStructureBuildTypeKHR, pBuildInfo: ^AccelerationStructureBuildGeometryInfoKHR, pMaxPrimitiveCounts: [^]u32, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR) { PtrGetAccelerationStructureBuildSizesKHR(device, buildType, pBuildInfo, pMaxPrimitiveCounts, pSizeInfo) }
GetAccelerationStructureDeviceAddressKHR               :: #force_inline proc "system" (device: Device, pInfo: ^AccelerationStructureDeviceAddressInfoKHR) -> DeviceAddress { return PtrGetAccelerationStructureDeviceAddressKHR(device, pInfo) }
GetAccelerationStructureHandleNV                       :: #force_inline proc "system" (device: Device, accelerationStructure: AccelerationStructureNV, dataSize: int, pData: rawptr) -> Result { return PtrGetAccelerationStructureHandleNV(device, accelerationStructure, dataSize, pData) }
GetAccelerationStructureMemoryRequirementsNV           :: #force_inline proc "system" (device: Device, pInfo: ^AccelerationStructureMemoryRequirementsInfoNV, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetAccelerationStructureMemoryRequirementsNV(device, pInfo, pMemoryRequirements) }
GetAccelerationStructureOpaqueCaptureDescriptorDataEXT :: #force_inline proc "system" (device: Device, pInfo: ^AccelerationStructureCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result { return PtrGetAccelerationStructureOpaqueCaptureDescriptorDataEXT(device, pInfo, pData) }
GetAndroidHardwareBufferPropertiesANDROID              :: #force_inline proc "system" (device: Device, buffer: ^AHardwareBuffer, pProperties: [^]AndroidHardwareBufferPropertiesANDROID) -> Result { return PtrGetAndroidHardwareBufferPropertiesANDROID(device, buffer, pProperties) }
GetBufferDeviceAddress                                 :: #force_inline proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress { return PtrGetBufferDeviceAddress(device, pInfo) }
GetBufferDeviceAddressEXT                              :: #force_inline proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress { return PtrGetBufferDeviceAddressEXT(device, pInfo) }
GetBufferDeviceAddressKHR                              :: #force_inline proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> DeviceAddress { return PtrGetBufferDeviceAddressKHR(device, pInfo) }
GetBufferMemoryRequirements                            :: #force_inline proc "system" (device: Device, buffer: Buffer, pMemoryRequirements: [^]MemoryRequirements) { PtrGetBufferMemoryRequirements(device, buffer, pMemoryRequirements) }
GetBufferMemoryRequirements2                           :: #force_inline proc "system" (device: Device, pInfo: ^BufferMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetBufferMemoryRequirements2(device, pInfo, pMemoryRequirements) }
GetBufferMemoryRequirements2KHR                        :: #force_inline proc "system" (device: Device, pInfo: ^BufferMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetBufferMemoryRequirements2KHR(device, pInfo, pMemoryRequirements) }
GetBufferOpaqueCaptureAddress                          :: #force_inline proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> u64 { return PtrGetBufferOpaqueCaptureAddress(device, pInfo) }
GetBufferOpaqueCaptureAddressKHR                       :: #force_inline proc "system" (device: Device, pInfo: ^BufferDeviceAddressInfo) -> u64 { return PtrGetBufferOpaqueCaptureAddressKHR(device, pInfo) }
GetBufferOpaqueCaptureDescriptorDataEXT                :: #force_inline proc "system" (device: Device, pInfo: ^BufferCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result { return PtrGetBufferOpaqueCaptureDescriptorDataEXT(device, pInfo, pData) }
GetCalibratedTimestampsEXT                             :: #force_inline proc "system" (device: Device, timestampCount: u32, pTimestampInfos: [^]CalibratedTimestampInfoKHR, pTimestamps: [^]u64, pMaxDeviation: ^u64) -> Result { return PtrGetCalibratedTimestampsEXT(device, timestampCount, pTimestampInfos, pTimestamps, pMaxDeviation) }
GetCalibratedTimestampsKHR                             :: #force_inline proc "system" (device: Device, timestampCount: u32, pTimestampInfos: [^]CalibratedTimestampInfoKHR, pTimestamps: [^]u64, pMaxDeviation: ^u64) -> Result { return PtrGetCalibratedTimestampsKHR(device, timestampCount, pTimestampInfos, pTimestamps, pMaxDeviation) }
GetClusterAccelerationStructureBuildSizesNV            :: #force_inline proc "system" (device: Device, pInfo: ^ClusterAccelerationStructureInputInfoNV, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR) { PtrGetClusterAccelerationStructureBuildSizesNV(device, pInfo, pSizeInfo) }
GetCudaModuleCacheNV                                   :: #force_inline proc "system" (device: Device, module: CudaModuleNV, pCacheSize: ^int, pCacheData: rawptr) -> Result { return PtrGetCudaModuleCacheNV(device, module, pCacheSize, pCacheData) }
GetDataGraphPipelineAvailablePropertiesARM             :: #force_inline proc "system" (device: Device, pPipelineInfo: ^DataGraphPipelineInfoARM, pPropertiesCount: ^u32, pProperties: [^]DataGraphPipelinePropertyARM) -> Result { return PtrGetDataGraphPipelineAvailablePropertiesARM(device, pPipelineInfo, pPropertiesCount, pProperties) }
GetDataGraphPipelinePropertiesARM                      :: #force_inline proc "system" (device: Device, pPipelineInfo: ^DataGraphPipelineInfoARM, propertiesCount: u32, pProperties: [^]DataGraphPipelinePropertyQueryResultARM) -> Result { return PtrGetDataGraphPipelinePropertiesARM(device, pPipelineInfo, propertiesCount, pProperties) }
GetDataGraphPipelineSessionBindPointRequirementsARM    :: #force_inline proc "system" (device: Device, pInfo: ^DataGraphPipelineSessionBindPointRequirementsInfoARM, pBindPointRequirementCount: ^u32, pBindPointRequirements: [^]DataGraphPipelineSessionBindPointRequirementARM) -> Result { return PtrGetDataGraphPipelineSessionBindPointRequirementsARM(device, pInfo, pBindPointRequirementCount, pBindPointRequirements) }
GetDataGraphPipelineSessionMemoryRequirementsARM       :: #force_inline proc "system" (device: Device, pInfo: ^DataGraphPipelineSessionMemoryRequirementsInfoARM, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDataGraphPipelineSessionMemoryRequirementsARM(device, pInfo, pMemoryRequirements) }
GetDeferredOperationMaxConcurrencyKHR                  :: #force_inline proc "system" (device: Device, operation: DeferredOperationKHR) -> u32 { return PtrGetDeferredOperationMaxConcurrencyKHR(device, operation) }
GetDeferredOperationResultKHR                          :: #force_inline proc "system" (device: Device, operation: DeferredOperationKHR) -> Result { return PtrGetDeferredOperationResultKHR(device, operation) }
GetDescriptorEXT                                       :: #force_inline proc "system" (device: Device, pDescriptorInfo: ^DescriptorGetInfoEXT, dataSize: int, pDescriptor: rawptr) { PtrGetDescriptorEXT(device, pDescriptorInfo, dataSize, pDescriptor) }
GetDescriptorSetHostMappingVALVE                       :: #force_inline proc "system" (device: Device, descriptorSet: DescriptorSet, ppData: ^rawptr) { PtrGetDescriptorSetHostMappingVALVE(device, descriptorSet, ppData) }
GetDescriptorSetLayoutBindingOffsetEXT                 :: #force_inline proc "system" (device: Device, layout: DescriptorSetLayout, binding: u32, pOffset: ^DeviceSize) { PtrGetDescriptorSetLayoutBindingOffsetEXT(device, layout, binding, pOffset) }
GetDescriptorSetLayoutHostMappingInfoVALVE             :: #force_inline proc "system" (device: Device, pBindingReference: ^DescriptorSetBindingReferenceVALVE, pHostMapping: ^DescriptorSetLayoutHostMappingInfoVALVE) { PtrGetDescriptorSetLayoutHostMappingInfoVALVE(device, pBindingReference, pHostMapping) }
GetDescriptorSetLayoutSizeEXT                          :: #force_inline proc "system" (device: Device, layout: DescriptorSetLayout, pLayoutSizeInBytes: [^]DeviceSize) { PtrGetDescriptorSetLayoutSizeEXT(device, layout, pLayoutSizeInBytes) }
GetDescriptorSetLayoutSupport                          :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pSupport: ^DescriptorSetLayoutSupport) { PtrGetDescriptorSetLayoutSupport(device, pCreateInfo, pSupport) }
GetDescriptorSetLayoutSupportKHR                       :: #force_inline proc "system" (device: Device, pCreateInfo: ^DescriptorSetLayoutCreateInfo, pSupport: ^DescriptorSetLayoutSupport) { PtrGetDescriptorSetLayoutSupportKHR(device, pCreateInfo, pSupport) }
GetDeviceAccelerationStructureCompatibilityKHR         :: #force_inline proc "system" (device: Device, pVersionInfo: ^AccelerationStructureVersionInfoKHR, pCompatibility: ^AccelerationStructureCompatibilityKHR) { PtrGetDeviceAccelerationStructureCompatibilityKHR(device, pVersionInfo, pCompatibility) }
GetDeviceBufferMemoryRequirements                      :: #force_inline proc "system" (device: Device, pInfo: ^DeviceBufferMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDeviceBufferMemoryRequirements(device, pInfo, pMemoryRequirements) }
GetDeviceBufferMemoryRequirementsKHR                   :: #force_inline proc "system" (device: Device, pInfo: ^DeviceBufferMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDeviceBufferMemoryRequirementsKHR(device, pInfo, pMemoryRequirements) }
GetDeviceCombinedImageSamplerIndexNVX                  :: #force_inline proc "system" (device: Device, imageViewIndex: u64, samplerIndex: u64) -> u64 { return PtrGetDeviceCombinedImageSamplerIndexNVX(device, imageViewIndex, samplerIndex) }
GetDeviceFaultDebugInfoKHR                             :: #force_inline proc "system" (device: Device, pDebugInfo: ^DeviceFaultDebugInfoKHR) -> Result { return PtrGetDeviceFaultDebugInfoKHR(device, pDebugInfo) }
GetDeviceFaultInfoEXT                                  :: #force_inline proc "system" (device: Device, pFaultCounts: [^]DeviceFaultCountsEXT, pFaultInfo: ^DeviceFaultInfoEXT) -> Result { return PtrGetDeviceFaultInfoEXT(device, pFaultCounts, pFaultInfo) }
GetDeviceFaultReportsKHR                               :: #force_inline proc "system" (device: Device, timeout: u64, pFaultCounts: [^]u32, pFaultInfo: ^DeviceFaultInfoKHR) -> Result { return PtrGetDeviceFaultReportsKHR(device, timeout, pFaultCounts, pFaultInfo) }
GetDeviceGroupPeerMemoryFeatures                       :: #force_inline proc "system" (device: Device, heapIndex: u32, localDeviceIndex: u32, remoteDeviceIndex: u32, pPeerMemoryFeatures: [^]PeerMemoryFeatureFlags) { PtrGetDeviceGroupPeerMemoryFeatures(device, heapIndex, localDeviceIndex, remoteDeviceIndex, pPeerMemoryFeatures) }
GetDeviceGroupPeerMemoryFeaturesKHR                    :: #force_inline proc "system" (device: Device, heapIndex: u32, localDeviceIndex: u32, remoteDeviceIndex: u32, pPeerMemoryFeatures: [^]PeerMemoryFeatureFlags) { PtrGetDeviceGroupPeerMemoryFeaturesKHR(device, heapIndex, localDeviceIndex, remoteDeviceIndex, pPeerMemoryFeatures) }
GetDeviceGroupPresentCapabilitiesKHR                   :: #force_inline proc "system" (device: Device, pDeviceGroupPresentCapabilities: [^]DeviceGroupPresentCapabilitiesKHR) -> Result { return PtrGetDeviceGroupPresentCapabilitiesKHR(device, pDeviceGroupPresentCapabilities) }
GetDeviceGroupSurfacePresentModes2EXT                  :: #force_inline proc "system" (device: Device, pSurfaceInfo: ^PhysicalDeviceSurfaceInfo2KHR, pModes: [^]DeviceGroupPresentModeFlagsKHR) -> Result { return PtrGetDeviceGroupSurfacePresentModes2EXT(device, pSurfaceInfo, pModes) }
GetDeviceGroupSurfacePresentModesKHR                   :: #force_inline proc "system" (device: Device, surface: SurfaceKHR, pModes: [^]DeviceGroupPresentModeFlagsKHR) -> Result { return PtrGetDeviceGroupSurfacePresentModesKHR(device, surface, pModes) }
GetDeviceImageMemoryRequirements                       :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDeviceImageMemoryRequirements(device, pInfo, pMemoryRequirements) }
GetDeviceImageMemoryRequirementsKHR                    :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDeviceImageMemoryRequirementsKHR(device, pInfo, pMemoryRequirements) }
GetDeviceImageSparseMemoryRequirements                 :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2) { PtrGetDeviceImageSparseMemoryRequirements(device, pInfo, pSparseMemoryRequirementCount, pSparseMemoryRequirements) }
GetDeviceImageSparseMemoryRequirementsKHR              :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageMemoryRequirements, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2) { PtrGetDeviceImageSparseMemoryRequirementsKHR(device, pInfo, pSparseMemoryRequirementCount, pSparseMemoryRequirements) }
GetDeviceImageSubresourceLayout                        :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageSubresourceInfo, pLayout: ^SubresourceLayout2) { PtrGetDeviceImageSubresourceLayout(device, pInfo, pLayout) }
GetDeviceImageSubresourceLayoutKHR                     :: #force_inline proc "system" (device: Device, pInfo: ^DeviceImageSubresourceInfo, pLayout: ^SubresourceLayout2) { PtrGetDeviceImageSubresourceLayoutKHR(device, pInfo, pLayout) }
GetDeviceMemoryCommitment                              :: #force_inline proc "system" (device: Device, memory: DeviceMemory, pCommittedMemoryInBytes: [^]DeviceSize) { PtrGetDeviceMemoryCommitment(device, memory, pCommittedMemoryInBytes) }
GetDeviceMemoryOpaqueCaptureAddress                    :: #force_inline proc "system" (device: Device, pInfo: ^DeviceMemoryOpaqueCaptureAddressInfo) -> u64 { return PtrGetDeviceMemoryOpaqueCaptureAddress(device, pInfo) }
GetDeviceMemoryOpaqueCaptureAddressKHR                 :: #force_inline proc "system" (device: Device, pInfo: ^DeviceMemoryOpaqueCaptureAddressInfo) -> u64 { return PtrGetDeviceMemoryOpaqueCaptureAddressKHR(device, pInfo) }
GetDeviceMicromapCompatibilityEXT                      :: #force_inline proc "system" (device: Device, pVersionInfo: ^MicromapVersionInfoEXT, pCompatibility: ^AccelerationStructureCompatibilityKHR) { PtrGetDeviceMicromapCompatibilityEXT(device, pVersionInfo, pCompatibility) }
GetDeviceProcAddr                                      :: #force_inline proc "system" (device: Device, pName: cstring) -> ProcVoidFunction { return PtrGetDeviceProcAddr(device, pName) }
GetDeviceQueue                                         :: #force_inline proc "system" (device: Device, queueFamilyIndex: u32, queueIndex: u32, pQueue: ^Queue) { PtrGetDeviceQueue(device, queueFamilyIndex, queueIndex, pQueue) }
GetDeviceQueue2                                        :: #force_inline proc "system" (device: Device, pQueueInfo: ^DeviceQueueInfo2, pQueue: ^Queue) { PtrGetDeviceQueue2(device, pQueueInfo, pQueue) }
GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI          :: #force_inline proc "system" (device: Device, renderpass: RenderPass, pMaxWorkgroupSize: ^Extent2D) -> Result { return PtrGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(device, renderpass, pMaxWorkgroupSize) }
GetDeviceTensorMemoryRequirementsARM                   :: #force_inline proc "system" (device: Device, pInfo: ^DeviceTensorMemoryRequirementsARM, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetDeviceTensorMemoryRequirementsARM(device, pInfo, pMemoryRequirements) }
GetDynamicRenderingTilePropertiesQCOM                  :: #force_inline proc "system" (device: Device, pRenderingInfo: ^RenderingInfo, pProperties: [^]TilePropertiesQCOM) -> Result { return PtrGetDynamicRenderingTilePropertiesQCOM(device, pRenderingInfo, pProperties) }
GetEncodedVideoSessionParametersKHR                    :: #force_inline proc "system" (device: Device, pVideoSessionParametersInfo: ^VideoEncodeSessionParametersGetInfoKHR, pFeedbackInfo: ^VideoEncodeSessionParametersFeedbackInfoKHR, pDataSize: ^int, pData: rawptr) -> Result { return PtrGetEncodedVideoSessionParametersKHR(device, pVideoSessionParametersInfo, pFeedbackInfo, pDataSize, pData) }
GetEventStatus                                         :: #force_inline proc "system" (device: Device, event: Event) -> Result { return PtrGetEventStatus(device, event) }
GetExecutionGraphPipelineNodeIndexAMDX                 :: #force_inline proc "system" (device: Device, executionGraph: Pipeline, pNodeInfo: ^PipelineShaderStageNodeCreateInfoAMDX, pNodeIndex: ^u32) -> Result { return PtrGetExecutionGraphPipelineNodeIndexAMDX(device, executionGraph, pNodeInfo, pNodeIndex) }
GetExecutionGraphPipelineScratchSizeAMDX               :: #force_inline proc "system" (device: Device, executionGraph: Pipeline, pSizeInfo: ^ExecutionGraphPipelineScratchSizeAMDX) -> Result { return PtrGetExecutionGraphPipelineScratchSizeAMDX(device, executionGraph, pSizeInfo) }
GetFenceFdKHR                                          :: #force_inline proc "system" (device: Device, pGetFdInfo: ^FenceGetFdInfoKHR, pFd: ^c.int) -> Result { return PtrGetFenceFdKHR(device, pGetFdInfo, pFd) }
GetFenceStatus                                         :: #force_inline proc "system" (device: Device, fence: Fence) -> Result { return PtrGetFenceStatus(device, fence) }
GetFenceWin32HandleKHR                                 :: #force_inline proc "system" (device: Device, pGetWin32HandleInfo: ^FenceGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result { return PtrGetFenceWin32HandleKHR(device, pGetWin32HandleInfo, pHandle) }
GetFramebufferTilePropertiesQCOM                       :: #force_inline proc "system" (device: Device, framebuffer: Framebuffer, pPropertiesCount: ^u32, pProperties: [^]TilePropertiesQCOM) -> Result { return PtrGetFramebufferTilePropertiesQCOM(device, framebuffer, pPropertiesCount, pProperties) }
GetGeneratedCommandsMemoryRequirementsEXT              :: #force_inline proc "system" (device: Device, pInfo: ^GeneratedCommandsMemoryRequirementsInfoEXT, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetGeneratedCommandsMemoryRequirementsEXT(device, pInfo, pMemoryRequirements) }
GetGeneratedCommandsMemoryRequirementsNV               :: #force_inline proc "system" (device: Device, pInfo: ^GeneratedCommandsMemoryRequirementsInfoNV, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetGeneratedCommandsMemoryRequirementsNV(device, pInfo, pMemoryRequirements) }
GetGpaDeviceClockInfoAMD                               :: #force_inline proc "system" (device: Device, pInfo: ^GpaDeviceGetClockInfoAMD) -> Result { return PtrGetGpaDeviceClockInfoAMD(device, pInfo) }
GetGpaSessionResultsAMD                                :: #force_inline proc "system" (device: Device, gpaSession: GpaSessionAMD, sampleID: u32, pSizeInBytes: [^]int, pData: rawptr) -> Result { return PtrGetGpaSessionResultsAMD(device, gpaSession, sampleID, pSizeInBytes, pData) }
GetGpaSessionStatusAMD                                 :: #force_inline proc "system" (device: Device, gpaSession: GpaSessionAMD) -> Result { return PtrGetGpaSessionStatusAMD(device, gpaSession) }
GetImageDrmFormatModifierPropertiesEXT                 :: #force_inline proc "system" (device: Device, image: Image, pProperties: [^]ImageDrmFormatModifierPropertiesEXT) -> Result { return PtrGetImageDrmFormatModifierPropertiesEXT(device, image, pProperties) }
GetImageMemoryRequirements                             :: #force_inline proc "system" (device: Device, image: Image, pMemoryRequirements: [^]MemoryRequirements) { PtrGetImageMemoryRequirements(device, image, pMemoryRequirements) }
GetImageMemoryRequirements2                            :: #force_inline proc "system" (device: Device, pInfo: ^ImageMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetImageMemoryRequirements2(device, pInfo, pMemoryRequirements) }
GetImageMemoryRequirements2KHR                         :: #force_inline proc "system" (device: Device, pInfo: ^ImageMemoryRequirementsInfo2, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetImageMemoryRequirements2KHR(device, pInfo, pMemoryRequirements) }
GetImageOpaqueCaptureDataEXT                           :: #force_inline proc "system" (device: Device, imageCount: u32, pImages: [^]Image, pDatas: [^]HostAddressRangeEXT) -> Result { return PtrGetImageOpaqueCaptureDataEXT(device, imageCount, pImages, pDatas) }
GetImageOpaqueCaptureDescriptorDataEXT                 :: #force_inline proc "system" (device: Device, pInfo: ^ImageCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result { return PtrGetImageOpaqueCaptureDescriptorDataEXT(device, pInfo, pData) }
GetImageSparseMemoryRequirements                       :: #force_inline proc "system" (device: Device, image: Image, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements) { PtrGetImageSparseMemoryRequirements(device, image, pSparseMemoryRequirementCount, pSparseMemoryRequirements) }
GetImageSparseMemoryRequirements2                      :: #force_inline proc "system" (device: Device, pInfo: ^ImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2) { PtrGetImageSparseMemoryRequirements2(device, pInfo, pSparseMemoryRequirementCount, pSparseMemoryRequirements) }
GetImageSparseMemoryRequirements2KHR                   :: #force_inline proc "system" (device: Device, pInfo: ^ImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: ^u32, pSparseMemoryRequirements: [^]SparseImageMemoryRequirements2) { PtrGetImageSparseMemoryRequirements2KHR(device, pInfo, pSparseMemoryRequirementCount, pSparseMemoryRequirements) }
GetImageSubresourceLayout                              :: #force_inline proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource, pLayout: ^SubresourceLayout) { PtrGetImageSubresourceLayout(device, image, pSubresource, pLayout) }
GetImageSubresourceLayout2                             :: #force_inline proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2) { PtrGetImageSubresourceLayout2(device, image, pSubresource, pLayout) }
GetImageSubresourceLayout2EXT                          :: #force_inline proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2) { PtrGetImageSubresourceLayout2EXT(device, image, pSubresource, pLayout) }
GetImageSubresourceLayout2KHR                          :: #force_inline proc "system" (device: Device, image: Image, pSubresource: ^ImageSubresource2, pLayout: ^SubresourceLayout2) { PtrGetImageSubresourceLayout2KHR(device, image, pSubresource, pLayout) }
GetImageViewAddressNVX                                 :: #force_inline proc "system" (device: Device, imageView: ImageView, pProperties: [^]ImageViewAddressPropertiesNVX) -> Result { return PtrGetImageViewAddressNVX(device, imageView, pProperties) }
GetImageViewHandle64NVX                                :: #force_inline proc "system" (device: Device, pInfo: ^ImageViewHandleInfoNVX) -> u64 { return PtrGetImageViewHandle64NVX(device, pInfo) }
GetImageViewHandleNVX                                  :: #force_inline proc "system" (device: Device, pInfo: ^ImageViewHandleInfoNVX) -> u32 { return PtrGetImageViewHandleNVX(device, pInfo) }
GetImageViewOpaqueCaptureDescriptorDataEXT             :: #force_inline proc "system" (device: Device, pInfo: ^ImageViewCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result { return PtrGetImageViewOpaqueCaptureDescriptorDataEXT(device, pInfo, pData) }
GetLatencyTimingsNV                                    :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pLatencyMarkerInfo: ^GetLatencyMarkerInfoNV) { PtrGetLatencyTimingsNV(device, swapchain, pLatencyMarkerInfo) }
GetMemoryAndroidHardwareBufferANDROID                  :: #force_inline proc "system" (device: Device, pInfo: ^MemoryGetAndroidHardwareBufferInfoANDROID, pBuffer: ^^AHardwareBuffer) -> Result { return PtrGetMemoryAndroidHardwareBufferANDROID(device, pInfo, pBuffer) }
GetMemoryFdKHR                                         :: #force_inline proc "system" (device: Device, pGetFdInfo: ^MemoryGetFdInfoKHR, pFd: ^c.int) -> Result { return PtrGetMemoryFdKHR(device, pGetFdInfo, pFd) }
GetMemoryFdPropertiesKHR                               :: #force_inline proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, fd: c.int, pMemoryFdProperties: [^]MemoryFdPropertiesKHR) -> Result { return PtrGetMemoryFdPropertiesKHR(device, handleType, fd, pMemoryFdProperties) }
GetMemoryHostPointerPropertiesEXT                      :: #force_inline proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, pHostPointer: rawptr, pMemoryHostPointerProperties: [^]MemoryHostPointerPropertiesEXT) -> Result { return PtrGetMemoryHostPointerPropertiesEXT(device, handleType, pHostPointer, pMemoryHostPointerProperties) }
GetMemoryMetalHandleEXT                                :: #force_inline proc "system" (device: Device, pGetMetalHandleInfo: ^MemoryGetMetalHandleInfoEXT, pHandle: ^rawptr) -> Result { return PtrGetMemoryMetalHandleEXT(device, pGetMetalHandleInfo, pHandle) }
GetMemoryMetalHandlePropertiesEXT                      :: #force_inline proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, pHandle: rawptr, pMemoryMetalHandleProperties: [^]MemoryMetalHandlePropertiesEXT) -> Result { return PtrGetMemoryMetalHandlePropertiesEXT(device, handleType, pHandle, pMemoryMetalHandleProperties) }
GetMemoryRemoteAddressNV                               :: #force_inline proc "system" (device: Device, pMemoryGetRemoteAddressInfo: ^MemoryGetRemoteAddressInfoNV, pAddress: [^]RemoteAddressNV) -> Result { return PtrGetMemoryRemoteAddressNV(device, pMemoryGetRemoteAddressInfo, pAddress) }
GetMemoryWin32HandleKHR                                :: #force_inline proc "system" (device: Device, pGetWin32HandleInfo: ^MemoryGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result { return PtrGetMemoryWin32HandleKHR(device, pGetWin32HandleInfo, pHandle) }
GetMemoryWin32HandleNV                                 :: #force_inline proc "system" (device: Device, memory: DeviceMemory, handleType: ExternalMemoryHandleTypeFlagsNV, pHandle: ^HANDLE) -> Result { return PtrGetMemoryWin32HandleNV(device, memory, handleType, pHandle) }
GetMemoryWin32HandlePropertiesKHR                      :: #force_inline proc "system" (device: Device, handleType: ExternalMemoryHandleTypeFlags, handle: HANDLE, pMemoryWin32HandleProperties: [^]MemoryWin32HandlePropertiesKHR) -> Result { return PtrGetMemoryWin32HandlePropertiesKHR(device, handleType, handle, pMemoryWin32HandleProperties) }
GetMicromapBuildSizesEXT                               :: #force_inline proc "system" (device: Device, buildType: AccelerationStructureBuildTypeKHR, pBuildInfo: ^MicromapBuildInfoEXT, pSizeInfo: ^MicromapBuildSizesInfoEXT) { PtrGetMicromapBuildSizesEXT(device, buildType, pBuildInfo, pSizeInfo) }
GetPartitionedAccelerationStructuresBuildSizesNV       :: #force_inline proc "system" (device: Device, pInfo: ^PartitionedAccelerationStructureInstancesInputNV, pSizeInfo: ^AccelerationStructureBuildSizesInfoKHR) { PtrGetPartitionedAccelerationStructuresBuildSizesNV(device, pInfo, pSizeInfo) }
GetPastPresentationTimingEXT                           :: #force_inline proc "system" (device: Device, pPastPresentationTimingInfo: ^PastPresentationTimingInfoEXT, pPastPresentationTimingProperties: [^]PastPresentationTimingPropertiesEXT) -> Result { return PtrGetPastPresentationTimingEXT(device, pPastPresentationTimingInfo, pPastPresentationTimingProperties) }
GetPastPresentationTimingGOOGLE                        :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pPresentationTimingCount: ^u32, pPresentationTimings: [^]PastPresentationTimingGOOGLE) -> Result { return PtrGetPastPresentationTimingGOOGLE(device, swapchain, pPresentationTimingCount, pPresentationTimings) }
GetPerformanceParameterINTEL                           :: #force_inline proc "system" (device: Device, parameter: PerformanceParameterTypeINTEL, pValue: ^PerformanceValueINTEL) -> Result { return PtrGetPerformanceParameterINTEL(device, parameter, pValue) }
GetPipelineBinaryDataKHR                               :: #force_inline proc "system" (device: Device, pInfo: ^PipelineBinaryDataInfoKHR, pPipelineBinaryKey: ^PipelineBinaryKeyKHR, pPipelineBinaryDataSize: ^int, pPipelineBinaryData: rawptr) -> Result { return PtrGetPipelineBinaryDataKHR(device, pInfo, pPipelineBinaryKey, pPipelineBinaryDataSize, pPipelineBinaryData) }
GetPipelineCacheData                                   :: #force_inline proc "system" (device: Device, pipelineCache: PipelineCache, pDataSize: ^int, pData: rawptr) -> Result { return PtrGetPipelineCacheData(device, pipelineCache, pDataSize, pData) }
GetPipelineExecutableInternalRepresentationsKHR        :: #force_inline proc "system" (device: Device, pExecutableInfo: ^PipelineExecutableInfoKHR, pInternalRepresentationCount: ^u32, pInternalRepresentations: [^]PipelineExecutableInternalRepresentationKHR) -> Result { return PtrGetPipelineExecutableInternalRepresentationsKHR(device, pExecutableInfo, pInternalRepresentationCount, pInternalRepresentations) }
GetPipelineExecutablePropertiesKHR                     :: #force_inline proc "system" (device: Device, pPipelineInfo: ^PipelineInfoKHR, pExecutableCount: ^u32, pProperties: [^]PipelineExecutablePropertiesKHR) -> Result { return PtrGetPipelineExecutablePropertiesKHR(device, pPipelineInfo, pExecutableCount, pProperties) }
GetPipelineExecutableStatisticsKHR                     :: #force_inline proc "system" (device: Device, pExecutableInfo: ^PipelineExecutableInfoKHR, pStatisticCount: ^u32, pStatistics: [^]PipelineExecutableStatisticKHR) -> Result { return PtrGetPipelineExecutableStatisticsKHR(device, pExecutableInfo, pStatisticCount, pStatistics) }
GetPipelineIndirectDeviceAddressNV                     :: #force_inline proc "system" (device: Device, pInfo: ^PipelineIndirectDeviceAddressInfoNV) -> DeviceAddress { return PtrGetPipelineIndirectDeviceAddressNV(device, pInfo) }
GetPipelineIndirectMemoryRequirementsNV                :: #force_inline proc "system" (device: Device, pCreateInfo: ^ComputePipelineCreateInfo, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetPipelineIndirectMemoryRequirementsNV(device, pCreateInfo, pMemoryRequirements) }
GetPipelineKeyKHR                                      :: #force_inline proc "system" (device: Device, pPipelineCreateInfo: ^PipelineCreateInfoKHR, pPipelineKey: ^PipelineBinaryKeyKHR) -> Result { return PtrGetPipelineKeyKHR(device, pPipelineCreateInfo, pPipelineKey) }
GetPipelinePropertiesEXT                               :: #force_inline proc "system" (device: Device, pPipelineInfo: ^PipelineInfoKHR, pPipelineProperties: [^]BaseOutStructure) -> Result { return PtrGetPipelinePropertiesEXT(device, pPipelineInfo, pPipelineProperties) }
GetPrivateData                                         :: #force_inline proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, pData: ^u64) { PtrGetPrivateData(device, objectType, objectHandle, privateDataSlot, pData) }
GetPrivateDataEXT                                      :: #force_inline proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, pData: ^u64) { PtrGetPrivateDataEXT(device, objectType, objectHandle, privateDataSlot, pData) }
GetQueryPoolResults                                    :: #force_inline proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32, dataSize: int, pData: rawptr, stride: DeviceSize, flags: QueryResultFlags) -> Result { return PtrGetQueryPoolResults(device, queryPool, firstQuery, queryCount, dataSize, pData, stride, flags) }
GetQueueCheckpointData2NV                              :: #force_inline proc "system" (queue: Queue, pCheckpointDataCount: ^u32, pCheckpointData: ^CheckpointData2NV) { PtrGetQueueCheckpointData2NV(queue, pCheckpointDataCount, pCheckpointData) }
GetQueueCheckpointDataNV                               :: #force_inline proc "system" (queue: Queue, pCheckpointDataCount: ^u32, pCheckpointData: ^CheckpointDataNV) { PtrGetQueueCheckpointDataNV(queue, pCheckpointDataCount, pCheckpointData) }
GetRayTracingCaptureReplayShaderGroupHandlesKHR        :: #force_inline proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result { return PtrGetRayTracingCaptureReplayShaderGroupHandlesKHR(device, pipeline, firstGroup, groupCount, dataSize, pData) }
GetRayTracingShaderGroupHandlesKHR                     :: #force_inline proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result { return PtrGetRayTracingShaderGroupHandlesKHR(device, pipeline, firstGroup, groupCount, dataSize, pData) }
GetRayTracingShaderGroupHandlesNV                      :: #force_inline proc "system" (device: Device, pipeline: Pipeline, firstGroup: u32, groupCount: u32, dataSize: int, pData: rawptr) -> Result { return PtrGetRayTracingShaderGroupHandlesNV(device, pipeline, firstGroup, groupCount, dataSize, pData) }
GetRayTracingShaderGroupStackSizeKHR                   :: #force_inline proc "system" (device: Device, pipeline: Pipeline, group: u32, groupShader: ShaderGroupShaderKHR) -> DeviceSize { return PtrGetRayTracingShaderGroupStackSizeKHR(device, pipeline, group, groupShader) }
GetRefreshCycleDurationGOOGLE                          :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pDisplayTimingProperties: [^]RefreshCycleDurationGOOGLE) -> Result { return PtrGetRefreshCycleDurationGOOGLE(device, swapchain, pDisplayTimingProperties) }
GetRenderAreaGranularity                               :: #force_inline proc "system" (device: Device, renderPass: RenderPass, pGranularity: ^Extent2D) { PtrGetRenderAreaGranularity(device, renderPass, pGranularity) }
GetRenderingAreaGranularity                            :: #force_inline proc "system" (device: Device, pRenderingAreaInfo: ^RenderingAreaInfo, pGranularity: ^Extent2D) { PtrGetRenderingAreaGranularity(device, pRenderingAreaInfo, pGranularity) }
GetRenderingAreaGranularityKHR                         :: #force_inline proc "system" (device: Device, pRenderingAreaInfo: ^RenderingAreaInfo, pGranularity: ^Extent2D) { PtrGetRenderingAreaGranularityKHR(device, pRenderingAreaInfo, pGranularity) }
GetSamplerOpaqueCaptureDescriptorDataEXT               :: #force_inline proc "system" (device: Device, pInfo: ^SamplerCaptureDescriptorDataInfoEXT, pData: rawptr) -> Result { return PtrGetSamplerOpaqueCaptureDescriptorDataEXT(device, pInfo, pData) }
GetSemaphoreCounterValue                               :: #force_inline proc "system" (device: Device, semaphore: Semaphore, pValue: ^u64) -> Result { return PtrGetSemaphoreCounterValue(device, semaphore, pValue) }
GetSemaphoreCounterValueKHR                            :: #force_inline proc "system" (device: Device, semaphore: Semaphore, pValue: ^u64) -> Result { return PtrGetSemaphoreCounterValueKHR(device, semaphore, pValue) }
GetSemaphoreFdKHR                                      :: #force_inline proc "system" (device: Device, pGetFdInfo: ^SemaphoreGetFdInfoKHR, pFd: ^c.int) -> Result { return PtrGetSemaphoreFdKHR(device, pGetFdInfo, pFd) }
GetSemaphoreWin32HandleKHR                             :: #force_inline proc "system" (device: Device, pGetWin32HandleInfo: ^SemaphoreGetWin32HandleInfoKHR, pHandle: ^HANDLE) -> Result { return PtrGetSemaphoreWin32HandleKHR(device, pGetWin32HandleInfo, pHandle) }
GetShaderBinaryDataEXT                                 :: #force_inline proc "system" (device: Device, shader: ShaderEXT, pDataSize: ^int, pData: rawptr) -> Result { return PtrGetShaderBinaryDataEXT(device, shader, pDataSize, pData) }
GetShaderInfoAMD                                       :: #force_inline proc "system" (device: Device, pipeline: Pipeline, shaderStage: ShaderStageFlags, infoType: ShaderInfoTypeAMD, pInfoSize: ^int, pInfo: rawptr) -> Result { return PtrGetShaderInfoAMD(device, pipeline, shaderStage, infoType, pInfoSize, pInfo) }
GetShaderInstrumentationValuesARM                      :: #force_inline proc "system" (device: Device, instrumentation: ShaderInstrumentationARM, pMetricBlockCount: ^u32, pMetricValues: rawptr, flags: ShaderInstrumentationValuesFlagsARM) -> Result { return PtrGetShaderInstrumentationValuesARM(device, instrumentation, pMetricBlockCount, pMetricValues, flags) }
GetShaderModuleCreateInfoIdentifierEXT                 :: #force_inline proc "system" (device: Device, pCreateInfo: ^ShaderModuleCreateInfo, pIdentifier: ^ShaderModuleIdentifierEXT) { PtrGetShaderModuleCreateInfoIdentifierEXT(device, pCreateInfo, pIdentifier) }
GetShaderModuleIdentifierEXT                           :: #force_inline proc "system" (device: Device, shaderModule: ShaderModule, pIdentifier: ^ShaderModuleIdentifierEXT) { PtrGetShaderModuleIdentifierEXT(device, shaderModule, pIdentifier) }
GetSwapchainCounterEXT                                 :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, counter: SurfaceCounterFlagsEXT, pCounterValue: ^u64) -> Result { return PtrGetSwapchainCounterEXT(device, swapchain, counter, pCounterValue) }
GetSwapchainImagesKHR                                  :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainImageCount: ^u32, pSwapchainImages: [^]Image) -> Result { return PtrGetSwapchainImagesKHR(device, swapchain, pSwapchainImageCount, pSwapchainImages) }
GetSwapchainStatusKHR                                  :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR) -> Result { return PtrGetSwapchainStatusKHR(device, swapchain) }
GetSwapchainTimeDomainPropertiesEXT                    :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainTimeDomainProperties: [^]SwapchainTimeDomainPropertiesEXT, pTimeDomainsCounter: ^u64) -> Result { return PtrGetSwapchainTimeDomainPropertiesEXT(device, swapchain, pSwapchainTimeDomainProperties, pTimeDomainsCounter) }
GetSwapchainTimingPropertiesEXT                        :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pSwapchainTimingProperties: [^]SwapchainTimingPropertiesEXT, pSwapchainTimingPropertiesCounter: ^u64) -> Result { return PtrGetSwapchainTimingPropertiesEXT(device, swapchain, pSwapchainTimingProperties, pSwapchainTimingPropertiesCounter) }
GetTensorMemoryRequirementsARM                         :: #force_inline proc "system" (device: Device, pInfo: ^TensorMemoryRequirementsInfoARM, pMemoryRequirements: [^]MemoryRequirements2) { PtrGetTensorMemoryRequirementsARM(device, pInfo, pMemoryRequirements) }
GetTensorOpaqueCaptureDataARM                          :: #force_inline proc "system" (device: Device, tensorCount: u32, pTensors: [^]TensorARM, pDatas: [^]HostAddressRangeEXT) -> Result { return PtrGetTensorOpaqueCaptureDataARM(device, tensorCount, pTensors, pDatas) }
GetTensorOpaqueCaptureDescriptorDataARM                :: #force_inline proc "system" (device: Device, pInfo: ^TensorCaptureDescriptorDataInfoARM, pData: rawptr) -> Result { return PtrGetTensorOpaqueCaptureDescriptorDataARM(device, pInfo, pData) }
GetTensorViewOpaqueCaptureDescriptorDataARM            :: #force_inline proc "system" (device: Device, pInfo: ^TensorViewCaptureDescriptorDataInfoARM, pData: rawptr) -> Result { return PtrGetTensorViewOpaqueCaptureDescriptorDataARM(device, pInfo, pData) }
GetValidationCacheDataEXT                              :: #force_inline proc "system" (device: Device, validationCache: ValidationCacheEXT, pDataSize: ^int, pData: rawptr) -> Result { return PtrGetValidationCacheDataEXT(device, validationCache, pDataSize, pData) }
GetVideoSessionMemoryRequirementsKHR                   :: #force_inline proc "system" (device: Device, videoSession: VideoSessionKHR, pMemoryRequirementsCount: ^u32, pMemoryRequirements: [^]VideoSessionMemoryRequirementsKHR) -> Result { return PtrGetVideoSessionMemoryRequirementsKHR(device, videoSession, pMemoryRequirementsCount, pMemoryRequirements) }
ImportFenceFdKHR                                       :: #force_inline proc "system" (device: Device, pImportFenceFdInfo: ^ImportFenceFdInfoKHR) -> Result { return PtrImportFenceFdKHR(device, pImportFenceFdInfo) }
ImportFenceWin32HandleKHR                              :: #force_inline proc "system" (device: Device, pImportFenceWin32HandleInfo: ^ImportFenceWin32HandleInfoKHR) -> Result { return PtrImportFenceWin32HandleKHR(device, pImportFenceWin32HandleInfo) }
ImportSemaphoreFdKHR                                   :: #force_inline proc "system" (device: Device, pImportSemaphoreFdInfo: ^ImportSemaphoreFdInfoKHR) -> Result { return PtrImportSemaphoreFdKHR(device, pImportSemaphoreFdInfo) }
ImportSemaphoreWin32HandleKHR                          :: #force_inline proc "system" (device: Device, pImportSemaphoreWin32HandleInfo: ^ImportSemaphoreWin32HandleInfoKHR) -> Result { return PtrImportSemaphoreWin32HandleKHR(device, pImportSemaphoreWin32HandleInfo) }
InitializePerformanceApiINTEL                          :: #force_inline proc "system" (device: Device, pInitializeInfo: ^InitializePerformanceApiInfoINTEL) -> Result { return PtrInitializePerformanceApiINTEL(device, pInitializeInfo) }
InvalidateMappedMemoryRanges                           :: #force_inline proc "system" (device: Device, memoryRangeCount: u32, pMemoryRanges: [^]MappedMemoryRange) -> Result { return PtrInvalidateMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges) }
LatencySleepNV                                         :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pSleepInfo: ^LatencySleepInfoNV) -> Result { return PtrLatencySleepNV(device, swapchain, pSleepInfo) }
MapMemory                                              :: #force_inline proc "system" (device: Device, memory: DeviceMemory, offset: DeviceSize, size: DeviceSize, flags: MemoryMapFlags, ppData: ^rawptr) -> Result { return PtrMapMemory(device, memory, offset, size, flags, ppData) }
MapMemory2                                             :: #force_inline proc "system" (device: Device, pMemoryMapInfo: ^MemoryMapInfo, ppData: ^rawptr) -> Result { return PtrMapMemory2(device, pMemoryMapInfo, ppData) }
MapMemory2KHR                                          :: #force_inline proc "system" (device: Device, pMemoryMapInfo: ^MemoryMapInfo, ppData: ^rawptr) -> Result { return PtrMapMemory2KHR(device, pMemoryMapInfo, ppData) }
MergePipelineCaches                                    :: #force_inline proc "system" (device: Device, dstCache: PipelineCache, srcCacheCount: u32, pSrcCaches: [^]PipelineCache) -> Result { return PtrMergePipelineCaches(device, dstCache, srcCacheCount, pSrcCaches) }
MergeValidationCachesEXT                               :: #force_inline proc "system" (device: Device, dstCache: ValidationCacheEXT, srcCacheCount: u32, pSrcCaches: [^]ValidationCacheEXT) -> Result { return PtrMergeValidationCachesEXT(device, dstCache, srcCacheCount, pSrcCaches) }
QueueBeginDebugUtilsLabelEXT                           :: #force_inline proc "system" (queue: Queue, pLabelInfo: ^DebugUtilsLabelEXT) { PtrQueueBeginDebugUtilsLabelEXT(queue, pLabelInfo) }
QueueBindSparse                                        :: #force_inline proc "system" (queue: Queue, bindInfoCount: u32, pBindInfo: ^BindSparseInfo, fence: Fence) -> Result { return PtrQueueBindSparse(queue, bindInfoCount, pBindInfo, fence) }
QueueEndDebugUtilsLabelEXT                             :: #force_inline proc "system" (queue: Queue) { PtrQueueEndDebugUtilsLabelEXT(queue) }
QueueInsertDebugUtilsLabelEXT                          :: #force_inline proc "system" (queue: Queue, pLabelInfo: ^DebugUtilsLabelEXT) { PtrQueueInsertDebugUtilsLabelEXT(queue, pLabelInfo) }
QueueNotifyOutOfBandNV                                 :: #force_inline proc "system" (queue: Queue, pQueueTypeInfo: ^OutOfBandQueueTypeInfoNV) { PtrQueueNotifyOutOfBandNV(queue, pQueueTypeInfo) }
QueuePresentKHR                                        :: #force_inline proc "system" (queue: Queue, pPresentInfo: ^PresentInfoKHR) -> Result { return PtrQueuePresentKHR(queue, pPresentInfo) }
QueueSetPerformanceConfigurationINTEL                  :: #force_inline proc "system" (queue: Queue, configuration: PerformanceConfigurationINTEL) -> Result { return PtrQueueSetPerformanceConfigurationINTEL(queue, configuration) }
QueueSubmit                                            :: #force_inline proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo, fence: Fence) -> Result { return PtrQueueSubmit(queue, submitCount, pSubmits, fence) }
QueueSubmit2                                           :: #force_inline proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo2, fence: Fence) -> Result { return PtrQueueSubmit2(queue, submitCount, pSubmits, fence) }
QueueSubmit2KHR                                        :: #force_inline proc "system" (queue: Queue, submitCount: u32, pSubmits: [^]SubmitInfo2, fence: Fence) -> Result { return PtrQueueSubmit2KHR(queue, submitCount, pSubmits, fence) }
QueueWaitIdle                                          :: #force_inline proc "system" (queue: Queue) -> Result { return PtrQueueWaitIdle(queue) }
RegisterCustomBorderColorEXT                           :: #force_inline proc "system" (device: Device, pBorderColor: ^SamplerCustomBorderColorCreateInfoEXT, requestIndex: b32, pIndex: ^u32) -> Result { return PtrRegisterCustomBorderColorEXT(device, pBorderColor, requestIndex, pIndex) }
RegisterDeviceEventEXT                                 :: #force_inline proc "system" (device: Device, pDeviceEventInfo: ^DeviceEventInfoEXT, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result { return PtrRegisterDeviceEventEXT(device, pDeviceEventInfo, pAllocator, pFence) }
RegisterDisplayEventEXT                                :: #force_inline proc "system" (device: Device, display: DisplayKHR, pDisplayEventInfo: ^DisplayEventInfoEXT, pAllocator: ^AllocationCallbacks, pFence: ^Fence) -> Result { return PtrRegisterDisplayEventEXT(device, display, pDisplayEventInfo, pAllocator, pFence) }
ReleaseCapturedPipelineDataKHR                         :: #force_inline proc "system" (device: Device, pInfo: ^ReleaseCapturedPipelineDataInfoKHR, pAllocator: ^AllocationCallbacks) -> Result { return PtrReleaseCapturedPipelineDataKHR(device, pInfo, pAllocator) }
ReleaseFullScreenExclusiveModeEXT                      :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR) -> Result { return PtrReleaseFullScreenExclusiveModeEXT(device, swapchain) }
ReleasePerformanceConfigurationINTEL                   :: #force_inline proc "system" (device: Device, configuration: PerformanceConfigurationINTEL) -> Result { return PtrReleasePerformanceConfigurationINTEL(device, configuration) }
ReleaseProfilingLockKHR                                :: #force_inline proc "system" (device: Device) { PtrReleaseProfilingLockKHR(device) }
ReleaseSwapchainImagesEXT                              :: #force_inline proc "system" (device: Device, pReleaseInfo: ^ReleaseSwapchainImagesInfoKHR) -> Result { return PtrReleaseSwapchainImagesEXT(device, pReleaseInfo) }
ReleaseSwapchainImagesKHR                              :: #force_inline proc "system" (device: Device, pReleaseInfo: ^ReleaseSwapchainImagesInfoKHR) -> Result { return PtrReleaseSwapchainImagesKHR(device, pReleaseInfo) }
ResetCommandBuffer                                     :: #force_inline proc "system" (commandBuffer: CommandBuffer, flags: CommandBufferResetFlags) -> Result { return PtrResetCommandBuffer(commandBuffer, flags) }
ResetCommandPool                                       :: #force_inline proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolResetFlags) -> Result { return PtrResetCommandPool(device, commandPool, flags) }
ResetDescriptorPool                                    :: #force_inline proc "system" (device: Device, descriptorPool: DescriptorPool, flags: DescriptorPoolResetFlags) -> Result { return PtrResetDescriptorPool(device, descriptorPool, flags) }
ResetEvent                                             :: #force_inline proc "system" (device: Device, event: Event) -> Result { return PtrResetEvent(device, event) }
ResetFences                                            :: #force_inline proc "system" (device: Device, fenceCount: u32, pFences: [^]Fence) -> Result { return PtrResetFences(device, fenceCount, pFences) }
ResetGpaSessionAMD                                     :: #force_inline proc "system" (device: Device, gpaSession: GpaSessionAMD) -> Result { return PtrResetGpaSessionAMD(device, gpaSession) }
ResetQueryPool                                         :: #force_inline proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32) { PtrResetQueryPool(device, queryPool, firstQuery, queryCount) }
ResetQueryPoolEXT                                      :: #force_inline proc "system" (device: Device, queryPool: QueryPool, firstQuery: u32, queryCount: u32) { PtrResetQueryPoolEXT(device, queryPool, firstQuery, queryCount) }
SetDebugUtilsObjectNameEXT                             :: #force_inline proc "system" (device: Device, pNameInfo: ^DebugUtilsObjectNameInfoEXT) -> Result { return PtrSetDebugUtilsObjectNameEXT(device, pNameInfo) }
SetDebugUtilsObjectTagEXT                              :: #force_inline proc "system" (device: Device, pTagInfo: ^DebugUtilsObjectTagInfoEXT) -> Result { return PtrSetDebugUtilsObjectTagEXT(device, pTagInfo) }
SetDeviceMemoryPriorityEXT                             :: #force_inline proc "system" (device: Device, memory: DeviceMemory, priority: f32) { PtrSetDeviceMemoryPriorityEXT(device, memory, priority) }
SetEvent                                               :: #force_inline proc "system" (device: Device, event: Event) -> Result { return PtrSetEvent(device, event) }
SetGpaDeviceClockModeAMD                               :: #force_inline proc "system" (device: Device, pInfo: ^GpaDeviceClockModeInfoAMD) -> Result { return PtrSetGpaDeviceClockModeAMD(device, pInfo) }
SetHdrMetadataEXT                                      :: #force_inline proc "system" (device: Device, swapchainCount: u32, pSwapchains: [^]SwapchainKHR, pMetadata: ^HdrMetadataEXT) { PtrSetHdrMetadataEXT(device, swapchainCount, pSwapchains, pMetadata) }
SetLatencyMarkerNV                                     :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pLatencyMarkerInfo: ^SetLatencyMarkerInfoNV) { PtrSetLatencyMarkerNV(device, swapchain, pLatencyMarkerInfo) }
SetLatencySleepModeNV                                  :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pSleepModeInfo: ^LatencySleepModeInfoNV) -> Result { return PtrSetLatencySleepModeNV(device, swapchain, pSleepModeInfo) }
SetLocalDimmingAMD                                     :: #force_inline proc "system" (device: Device, swapChain: SwapchainKHR, localDimmingEnable: b32) { PtrSetLocalDimmingAMD(device, swapChain, localDimmingEnable) }
SetPrivateData                                         :: #force_inline proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, data: u64) -> Result { return PtrSetPrivateData(device, objectType, objectHandle, privateDataSlot, data) }
SetPrivateDataEXT                                      :: #force_inline proc "system" (device: Device, objectType: ObjectType, objectHandle: u64, privateDataSlot: PrivateDataSlot, data: u64) -> Result { return PtrSetPrivateDataEXT(device, objectType, objectHandle, privateDataSlot, data) }
SetSwapchainPresentTimingQueueSizeEXT                  :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, size: u32) -> Result { return PtrSetSwapchainPresentTimingQueueSizeEXT(device, swapchain, size) }
SignalSemaphore                                        :: #force_inline proc "system" (device: Device, pSignalInfo: ^SemaphoreSignalInfo) -> Result { return PtrSignalSemaphore(device, pSignalInfo) }
SignalSemaphoreKHR                                     :: #force_inline proc "system" (device: Device, pSignalInfo: ^SemaphoreSignalInfo) -> Result { return PtrSignalSemaphoreKHR(device, pSignalInfo) }
TransitionImageLayout                                  :: #force_inline proc "system" (device: Device, transitionCount: u32, pTransitions: [^]HostImageLayoutTransitionInfo) -> Result { return PtrTransitionImageLayout(device, transitionCount, pTransitions) }
TransitionImageLayoutEXT                               :: #force_inline proc "system" (device: Device, transitionCount: u32, pTransitions: [^]HostImageLayoutTransitionInfo) -> Result { return PtrTransitionImageLayoutEXT(device, transitionCount, pTransitions) }
TrimCommandPool                                        :: #force_inline proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolTrimFlags) { PtrTrimCommandPool(device, commandPool, flags) }
TrimCommandPoolKHR                                     :: #force_inline proc "system" (device: Device, commandPool: CommandPool, flags: CommandPoolTrimFlags) { PtrTrimCommandPoolKHR(device, commandPool, flags) }
UninitializePerformanceApiINTEL                        :: #force_inline proc "system" (device: Device) { PtrUninitializePerformanceApiINTEL(device) }
UnmapMemory                                            :: #force_inline proc "system" (device: Device, memory: DeviceMemory) { PtrUnmapMemory(device, memory) }
UnmapMemory2                                           :: #force_inline proc "system" (device: Device, pMemoryUnmapInfo: ^MemoryUnmapInfo) -> Result { return PtrUnmapMemory2(device, pMemoryUnmapInfo) }
UnmapMemory2KHR                                        :: #force_inline proc "system" (device: Device, pMemoryUnmapInfo: ^MemoryUnmapInfo) -> Result { return PtrUnmapMemory2KHR(device, pMemoryUnmapInfo) }
UnregisterCustomBorderColorEXT                         :: #force_inline proc "system" (device: Device, index: u32) { PtrUnregisterCustomBorderColorEXT(device, index) }
UpdateDescriptorSetWithTemplate                        :: #force_inline proc "system" (device: Device, descriptorSet: DescriptorSet, descriptorUpdateTemplate: DescriptorUpdateTemplate, pData: rawptr) { PtrUpdateDescriptorSetWithTemplate(device, descriptorSet, descriptorUpdateTemplate, pData) }
UpdateDescriptorSetWithTemplateKHR                     :: #force_inline proc "system" (device: Device, descriptorSet: DescriptorSet, descriptorUpdateTemplate: DescriptorUpdateTemplate, pData: rawptr) { PtrUpdateDescriptorSetWithTemplateKHR(device, descriptorSet, descriptorUpdateTemplate, pData) }
UpdateDescriptorSets                                   :: #force_inline proc "system" (device: Device, descriptorWriteCount: u32, pDescriptorWrites: [^]WriteDescriptorSet, descriptorCopyCount: u32, pDescriptorCopies: [^]CopyDescriptorSet) { PtrUpdateDescriptorSets(device, descriptorWriteCount, pDescriptorWrites, descriptorCopyCount, pDescriptorCopies) }
UpdateIndirectExecutionSetPipelineEXT                  :: #force_inline proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, executionSetWriteCount: u32, pExecutionSetWrites: [^]WriteIndirectExecutionSetPipelineEXT) { PtrUpdateIndirectExecutionSetPipelineEXT(device, indirectExecutionSet, executionSetWriteCount, pExecutionSetWrites) }
UpdateIndirectExecutionSetShaderEXT                    :: #force_inline proc "system" (device: Device, indirectExecutionSet: IndirectExecutionSetEXT, executionSetWriteCount: u32, pExecutionSetWrites: [^]WriteIndirectExecutionSetShaderEXT) { PtrUpdateIndirectExecutionSetShaderEXT(device, indirectExecutionSet, executionSetWriteCount, pExecutionSetWrites) }
UpdateVideoSessionParametersKHR                        :: #force_inline proc "system" (device: Device, videoSessionParameters: VideoSessionParametersKHR, pUpdateInfo: ^VideoSessionParametersUpdateInfoKHR) -> Result { return PtrUpdateVideoSessionParametersKHR(device, videoSessionParameters, pUpdateInfo) }
WaitForFences                                          :: #force_inline proc "system" (device: Device, fenceCount: u32, pFences: [^]Fence, waitAll: b32, timeout: u64) -> Result { return PtrWaitForFences(device, fenceCount, pFences, waitAll, timeout) }
WaitForPresent2KHR                                     :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, pPresentWait2Info: ^PresentWait2InfoKHR) -> Result { return PtrWaitForPresent2KHR(device, swapchain, pPresentWait2Info) }
WaitForPresentKHR                                      :: #force_inline proc "system" (device: Device, swapchain: SwapchainKHR, presentId: u64, timeout: u64) -> Result { return PtrWaitForPresentKHR(device, swapchain, presentId, timeout) }
WaitSemaphores                                         :: #force_inline proc "system" (device: Device, pWaitInfo: ^SemaphoreWaitInfo, timeout: u64) -> Result { return PtrWaitSemaphores(device, pWaitInfo, timeout) }
WaitSemaphoresKHR                                      :: #force_inline proc "system" (device: Device, pWaitInfo: ^SemaphoreWaitInfo, timeout: u64) -> Result { return PtrWaitSemaphoresKHR(device, pWaitInfo, timeout) }
WriteAccelerationStructuresPropertiesKHR               :: #force_inline proc "system" (device: Device, accelerationStructureCount: u32, pAccelerationStructures: [^]AccelerationStructureKHR, queryType: QueryType, dataSize: int, pData: rawptr, stride: int) -> Result { return PtrWriteAccelerationStructuresPropertiesKHR(device, accelerationStructureCount, pAccelerationStructures, queryType, dataSize, pData, stride) }
WriteMicromapsPropertiesEXT                            :: #force_inline proc "system" (device: Device, micromapCount: u32, pMicromaps: [^]MicromapEXT, queryType: QueryType, dataSize: int, pData: rawptr, stride: int) -> Result { return PtrWriteMicromapsPropertiesEXT(device, micromapCount, pMicromaps, queryType, dataSize, pData, stride) }
WriteResourceDescriptorsEXT                            :: #force_inline proc "system" (device: Device, resourceCount: u32, pResources: [^]ResourceDescriptorInfoEXT, pDescriptors: [^]HostAddressRangeEXT) -> Result { return PtrWriteResourceDescriptorsEXT(device, resourceCount, pResources, pDescriptors) }
WriteSamplerDescriptorsEXT                             :: #force_inline proc "system" (device: Device, samplerCount: u32, pSamplers: [^]SamplerCreateInfo, pDescriptors: [^]HostAddressRangeEXT) -> Result { return PtrWriteSamplerDescriptorsEXT(device, samplerCount, pSamplers, pDescriptors) }


load_proc_addresses_custom :: proc(set_proc_address: SetProcAddressType) {
	// Loader Procedures
	set_proc_address(&PtrCreateInstance,                       "vkCreateInstance")
	set_proc_address(&PtrDebugUtilsMessengerCallbackEXT,       "vkDebugUtilsMessengerCallbackEXT")
	set_proc_address(&PtrDeviceMemoryReportCallbackEXT,        "vkDeviceMemoryReportCallbackEXT")
	set_proc_address(&PtrEnumerateInstanceExtensionProperties, "vkEnumerateInstanceExtensionProperties")
	set_proc_address(&PtrEnumerateInstanceLayerProperties,     "vkEnumerateInstanceLayerProperties")
	set_proc_address(&PtrEnumerateInstanceVersion,             "vkEnumerateInstanceVersion")
	set_proc_address(&PtrGetExternalComputeQueueDataNV,        "vkGetExternalComputeQueueDataNV")
	set_proc_address(&PtrGetInstanceProcAddr,                  "vkGetInstanceProcAddr")

	// Instance Procedures
	set_proc_address(&PtrAcquireDrmDisplayEXT,                                               "vkAcquireDrmDisplayEXT")
	set_proc_address(&PtrAcquireWinrtDisplayNV,                                              "vkAcquireWinrtDisplayNV")
	set_proc_address(&PtrCreateAndroidSurfaceKHR,                                            "vkCreateAndroidSurfaceKHR")
	set_proc_address(&PtrCreateDebugReportCallbackEXT,                                       "vkCreateDebugReportCallbackEXT")
	set_proc_address(&PtrCreateDebugUtilsMessengerEXT,                                       "vkCreateDebugUtilsMessengerEXT")
	set_proc_address(&PtrCreateDevice,                                                       "vkCreateDevice")
	set_proc_address(&PtrCreateDisplayModeKHR,                                               "vkCreateDisplayModeKHR")
	set_proc_address(&PtrCreateDisplayPlaneSurfaceKHR,                                       "vkCreateDisplayPlaneSurfaceKHR")
	set_proc_address(&PtrCreateHeadlessSurfaceEXT,                                           "vkCreateHeadlessSurfaceEXT")
	set_proc_address(&PtrCreateIOSSurfaceMVK,                                                "vkCreateIOSSurfaceMVK")
	set_proc_address(&PtrCreateMacOSSurfaceMVK,                                              "vkCreateMacOSSurfaceMVK")
	set_proc_address(&PtrCreateMetalSurfaceEXT,                                              "vkCreateMetalSurfaceEXT")
	set_proc_address(&PtrCreateWaylandSurfaceKHR,                                            "vkCreateWaylandSurfaceKHR")
	set_proc_address(&PtrCreateWin32SurfaceKHR,                                              "vkCreateWin32SurfaceKHR")
	set_proc_address(&PtrCreateXcbSurfaceKHR,                                                "vkCreateXcbSurfaceKHR")
	set_proc_address(&PtrCreateXlibSurfaceKHR,                                               "vkCreateXlibSurfaceKHR")
	set_proc_address(&PtrDebugReportMessageEXT,                                              "vkDebugReportMessageEXT")
	set_proc_address(&PtrDestroyDebugReportCallbackEXT,                                      "vkDestroyDebugReportCallbackEXT")
	set_proc_address(&PtrDestroyDebugUtilsMessengerEXT,                                      "vkDestroyDebugUtilsMessengerEXT")
	set_proc_address(&PtrDestroyInstance,                                                    "vkDestroyInstance")
	set_proc_address(&PtrDestroySurfaceKHR,                                                  "vkDestroySurfaceKHR")
	set_proc_address(&PtrEnumerateDeviceExtensionProperties,                                 "vkEnumerateDeviceExtensionProperties")
	set_proc_address(&PtrEnumerateDeviceLayerProperties,                                     "vkEnumerateDeviceLayerProperties")
	set_proc_address(&PtrEnumeratePhysicalDeviceGroups,                                      "vkEnumeratePhysicalDeviceGroups")
	set_proc_address(&PtrEnumeratePhysicalDeviceGroupsKHR,                                   "vkEnumeratePhysicalDeviceGroupsKHR")
	set_proc_address(&PtrEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM,   "vkEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM")
	set_proc_address(&PtrEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR,      "vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR")
	set_proc_address(&PtrEnumeratePhysicalDeviceShaderInstrumentationMetricsARM,             "vkEnumeratePhysicalDeviceShaderInstrumentationMetricsARM")
	set_proc_address(&PtrEnumeratePhysicalDevices,                                           "vkEnumeratePhysicalDevices")
	set_proc_address(&PtrGetDisplayModeProperties2KHR,                                       "vkGetDisplayModeProperties2KHR")
	set_proc_address(&PtrGetDisplayModePropertiesKHR,                                        "vkGetDisplayModePropertiesKHR")
	set_proc_address(&PtrGetDisplayPlaneCapabilities2KHR,                                    "vkGetDisplayPlaneCapabilities2KHR")
	set_proc_address(&PtrGetDisplayPlaneCapabilitiesKHR,                                     "vkGetDisplayPlaneCapabilitiesKHR")
	set_proc_address(&PtrGetDisplayPlaneSupportedDisplaysKHR,                                "vkGetDisplayPlaneSupportedDisplaysKHR")
	set_proc_address(&PtrGetDrmDisplayEXT,                                                   "vkGetDrmDisplayEXT")
	set_proc_address(&PtrGetInstanceProcAddrLUNARG,                                          "vkGetInstanceProcAddrLUNARG")
	set_proc_address(&PtrGetPhysicalDeviceCalibrateableTimeDomainsEXT,                       "vkGetPhysicalDeviceCalibrateableTimeDomainsEXT")
	set_proc_address(&PtrGetPhysicalDeviceCalibrateableTimeDomainsKHR,                       "vkGetPhysicalDeviceCalibrateableTimeDomainsKHR")
	set_proc_address(&PtrGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV,   "vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV")
	set_proc_address(&PtrGetPhysicalDeviceCooperativeMatrixPropertiesKHR,                    "vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceCooperativeMatrixPropertiesNV,                     "vkGetPhysicalDeviceCooperativeMatrixPropertiesNV")
	set_proc_address(&PtrGetPhysicalDeviceCooperativeVectorPropertiesNV,                     "vkGetPhysicalDeviceCooperativeVectorPropertiesNV")
	set_proc_address(&PtrGetPhysicalDeviceDescriptorSizeEXT,                                 "vkGetPhysicalDeviceDescriptorSizeEXT")
	set_proc_address(&PtrGetPhysicalDeviceDisplayPlaneProperties2KHR,                        "vkGetPhysicalDeviceDisplayPlaneProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceDisplayPlanePropertiesKHR,                         "vkGetPhysicalDeviceDisplayPlanePropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceDisplayProperties2KHR,                             "vkGetPhysicalDeviceDisplayProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceDisplayPropertiesKHR,                              "vkGetPhysicalDeviceDisplayPropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceExternalBufferProperties,                          "vkGetPhysicalDeviceExternalBufferProperties")
	set_proc_address(&PtrGetPhysicalDeviceExternalBufferPropertiesKHR,                       "vkGetPhysicalDeviceExternalBufferPropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceExternalFenceProperties,                           "vkGetPhysicalDeviceExternalFenceProperties")
	set_proc_address(&PtrGetPhysicalDeviceExternalFencePropertiesKHR,                        "vkGetPhysicalDeviceExternalFencePropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceExternalImageFormatPropertiesNV,                   "vkGetPhysicalDeviceExternalImageFormatPropertiesNV")
	set_proc_address(&PtrGetPhysicalDeviceExternalSemaphoreProperties,                       "vkGetPhysicalDeviceExternalSemaphoreProperties")
	set_proc_address(&PtrGetPhysicalDeviceExternalSemaphorePropertiesKHR,                    "vkGetPhysicalDeviceExternalSemaphorePropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceExternalTensorPropertiesARM,                       "vkGetPhysicalDeviceExternalTensorPropertiesARM")
	set_proc_address(&PtrGetPhysicalDeviceFeatures,                                          "vkGetPhysicalDeviceFeatures")
	set_proc_address(&PtrGetPhysicalDeviceFeatures2,                                         "vkGetPhysicalDeviceFeatures2")
	set_proc_address(&PtrGetPhysicalDeviceFeatures2KHR,                                      "vkGetPhysicalDeviceFeatures2KHR")
	set_proc_address(&PtrGetPhysicalDeviceFormatProperties,                                  "vkGetPhysicalDeviceFormatProperties")
	set_proc_address(&PtrGetPhysicalDeviceFormatProperties2,                                 "vkGetPhysicalDeviceFormatProperties2")
	set_proc_address(&PtrGetPhysicalDeviceFormatProperties2KHR,                              "vkGetPhysicalDeviceFormatProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceFragmentShadingRatesKHR,                           "vkGetPhysicalDeviceFragmentShadingRatesKHR")
	set_proc_address(&PtrGetPhysicalDeviceImageFormatProperties,                             "vkGetPhysicalDeviceImageFormatProperties")
	set_proc_address(&PtrGetPhysicalDeviceImageFormatProperties2,                            "vkGetPhysicalDeviceImageFormatProperties2")
	set_proc_address(&PtrGetPhysicalDeviceImageFormatProperties2KHR,                         "vkGetPhysicalDeviceImageFormatProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceMemoryProperties,                                  "vkGetPhysicalDeviceMemoryProperties")
	set_proc_address(&PtrGetPhysicalDeviceMemoryProperties2,                                 "vkGetPhysicalDeviceMemoryProperties2")
	set_proc_address(&PtrGetPhysicalDeviceMemoryProperties2KHR,                              "vkGetPhysicalDeviceMemoryProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceMultisamplePropertiesEXT,                          "vkGetPhysicalDeviceMultisamplePropertiesEXT")
	set_proc_address(&PtrGetPhysicalDeviceOpticalFlowImageFormatsNV,                         "vkGetPhysicalDeviceOpticalFlowImageFormatsNV")
	set_proc_address(&PtrGetPhysicalDevicePresentRectanglesKHR,                              "vkGetPhysicalDevicePresentRectanglesKHR")
	set_proc_address(&PtrGetPhysicalDeviceProperties,                                        "vkGetPhysicalDeviceProperties")
	set_proc_address(&PtrGetPhysicalDeviceProperties2,                                       "vkGetPhysicalDeviceProperties2")
	set_proc_address(&PtrGetPhysicalDeviceProperties2KHR,                                    "vkGetPhysicalDeviceProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM,  "vkGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM,    "vkGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM, "vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM,                 "vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR,              "vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyProperties,                             "vkGetPhysicalDeviceQueueFamilyProperties")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyProperties2,                            "vkGetPhysicalDeviceQueueFamilyProperties2")
	set_proc_address(&PtrGetPhysicalDeviceQueueFamilyProperties2KHR,                         "vkGetPhysicalDeviceQueueFamilyProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceSparseImageFormatProperties,                       "vkGetPhysicalDeviceSparseImageFormatProperties")
	set_proc_address(&PtrGetPhysicalDeviceSparseImageFormatProperties2,                      "vkGetPhysicalDeviceSparseImageFormatProperties2")
	set_proc_address(&PtrGetPhysicalDeviceSparseImageFormatProperties2KHR,                   "vkGetPhysicalDeviceSparseImageFormatProperties2KHR")
	set_proc_address(&PtrGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV,    "vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceCapabilities2EXT,                           "vkGetPhysicalDeviceSurfaceCapabilities2EXT")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceCapabilities2KHR,                           "vkGetPhysicalDeviceSurfaceCapabilities2KHR")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceCapabilitiesKHR,                            "vkGetPhysicalDeviceSurfaceCapabilitiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceFormats2KHR,                                "vkGetPhysicalDeviceSurfaceFormats2KHR")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceFormatsKHR,                                 "vkGetPhysicalDeviceSurfaceFormatsKHR")
	set_proc_address(&PtrGetPhysicalDeviceSurfacePresentModes2EXT,                           "vkGetPhysicalDeviceSurfacePresentModes2EXT")
	set_proc_address(&PtrGetPhysicalDeviceSurfacePresentModesKHR,                            "vkGetPhysicalDeviceSurfacePresentModesKHR")
	set_proc_address(&PtrGetPhysicalDeviceSurfaceSupportKHR,                                 "vkGetPhysicalDeviceSurfaceSupportKHR")
	set_proc_address(&PtrGetPhysicalDeviceToolProperties,                                    "vkGetPhysicalDeviceToolProperties")
	set_proc_address(&PtrGetPhysicalDeviceToolPropertiesEXT,                                 "vkGetPhysicalDeviceToolPropertiesEXT")
	set_proc_address(&PtrGetPhysicalDeviceVideoCapabilitiesKHR,                              "vkGetPhysicalDeviceVideoCapabilitiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR,              "vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceVideoFormatPropertiesKHR,                          "vkGetPhysicalDeviceVideoFormatPropertiesKHR")
	set_proc_address(&PtrGetPhysicalDeviceWaylandPresentationSupportKHR,                     "vkGetPhysicalDeviceWaylandPresentationSupportKHR")
	set_proc_address(&PtrGetPhysicalDeviceWin32PresentationSupportKHR,                       "vkGetPhysicalDeviceWin32PresentationSupportKHR")
	set_proc_address(&PtrGetPhysicalDeviceXcbPresentationSupportKHR,                         "vkGetPhysicalDeviceXcbPresentationSupportKHR")
	set_proc_address(&PtrGetPhysicalDeviceXlibPresentationSupportKHR,                        "vkGetPhysicalDeviceXlibPresentationSupportKHR")
	set_proc_address(&PtrGetWinrtDisplayNV,                                                  "vkGetWinrtDisplayNV")
	set_proc_address(&PtrReleaseDisplayEXT,                                                  "vkReleaseDisplayEXT")
	set_proc_address(&PtrSubmitDebugUtilsMessageEXT,                                         "vkSubmitDebugUtilsMessageEXT")

	// Device Procedures
	set_proc_address(&PtrAcquireFullScreenExclusiveModeEXT,                      "vkAcquireFullScreenExclusiveModeEXT")
	set_proc_address(&PtrAcquireNextImage2KHR,                                   "vkAcquireNextImage2KHR")
	set_proc_address(&PtrAcquireNextImageKHR,                                    "vkAcquireNextImageKHR")
	set_proc_address(&PtrAcquirePerformanceConfigurationINTEL,                   "vkAcquirePerformanceConfigurationINTEL")
	set_proc_address(&PtrAcquireProfilingLockKHR,                                "vkAcquireProfilingLockKHR")
	set_proc_address(&PtrAllocateCommandBuffers,                                 "vkAllocateCommandBuffers")
	set_proc_address(&PtrAllocateDescriptorSets,                                 "vkAllocateDescriptorSets")
	set_proc_address(&PtrAllocateMemory,                                         "vkAllocateMemory")
	set_proc_address(&PtrAntiLagUpdateAMD,                                       "vkAntiLagUpdateAMD")
	set_proc_address(&PtrBeginCommandBuffer,                                     "vkBeginCommandBuffer")
	set_proc_address(&PtrBindAccelerationStructureMemoryNV,                      "vkBindAccelerationStructureMemoryNV")
	set_proc_address(&PtrBindBufferMemory,                                       "vkBindBufferMemory")
	set_proc_address(&PtrBindBufferMemory2,                                      "vkBindBufferMemory2")
	set_proc_address(&PtrBindBufferMemory2KHR,                                   "vkBindBufferMemory2KHR")
	set_proc_address(&PtrBindDataGraphPipelineSessionMemoryARM,                  "vkBindDataGraphPipelineSessionMemoryARM")
	set_proc_address(&PtrBindImageMemory,                                        "vkBindImageMemory")
	set_proc_address(&PtrBindImageMemory2,                                       "vkBindImageMemory2")
	set_proc_address(&PtrBindImageMemory2KHR,                                    "vkBindImageMemory2KHR")
	set_proc_address(&PtrBindOpticalFlowSessionImageNV,                          "vkBindOpticalFlowSessionImageNV")
	set_proc_address(&PtrBindTensorMemoryARM,                                    "vkBindTensorMemoryARM")
	set_proc_address(&PtrBindVideoSessionMemoryKHR,                              "vkBindVideoSessionMemoryKHR")
	set_proc_address(&PtrBuildAccelerationStructuresKHR,                         "vkBuildAccelerationStructuresKHR")
	set_proc_address(&PtrBuildMicromapsEXT,                                      "vkBuildMicromapsEXT")
	set_proc_address(&PtrClearShaderInstrumentationMetricsARM,                   "vkClearShaderInstrumentationMetricsARM")
	set_proc_address(&PtrCmdBeginConditionalRendering2EXT,                       "vkCmdBeginConditionalRendering2EXT")
	set_proc_address(&PtrCmdBeginConditionalRenderingEXT,                        "vkCmdBeginConditionalRenderingEXT")
	set_proc_address(&PtrCmdBeginCustomResolveEXT,                               "vkCmdBeginCustomResolveEXT")
	set_proc_address(&PtrCmdBeginDebugUtilsLabelEXT,                             "vkCmdBeginDebugUtilsLabelEXT")
	set_proc_address(&PtrCmdBeginGpaSampleAMD,                                   "vkCmdBeginGpaSampleAMD")
	set_proc_address(&PtrCmdBeginGpaSessionAMD,                                  "vkCmdBeginGpaSessionAMD")
	set_proc_address(&PtrCmdBeginPerTileExecutionQCOM,                           "vkCmdBeginPerTileExecutionQCOM")
	set_proc_address(&PtrCmdBeginQuery,                                          "vkCmdBeginQuery")
	set_proc_address(&PtrCmdBeginQueryIndexedEXT,                                "vkCmdBeginQueryIndexedEXT")
	set_proc_address(&PtrCmdBeginRenderPass,                                     "vkCmdBeginRenderPass")
	set_proc_address(&PtrCmdBeginRenderPass2,                                    "vkCmdBeginRenderPass2")
	set_proc_address(&PtrCmdBeginRenderPass2KHR,                                 "vkCmdBeginRenderPass2KHR")
	set_proc_address(&PtrCmdBeginRendering,                                      "vkCmdBeginRendering")
	set_proc_address(&PtrCmdBeginRenderingKHR,                                   "vkCmdBeginRenderingKHR")
	set_proc_address(&PtrCmdBeginShaderInstrumentationARM,                       "vkCmdBeginShaderInstrumentationARM")
	set_proc_address(&PtrCmdBeginTransformFeedback2EXT,                          "vkCmdBeginTransformFeedback2EXT")
	set_proc_address(&PtrCmdBeginTransformFeedbackEXT,                           "vkCmdBeginTransformFeedbackEXT")
	set_proc_address(&PtrCmdBeginVideoCodingKHR,                                 "vkCmdBeginVideoCodingKHR")
	set_proc_address(&PtrCmdBindDescriptorBufferEmbeddedSamplers2EXT,            "vkCmdBindDescriptorBufferEmbeddedSamplers2EXT")
	set_proc_address(&PtrCmdBindDescriptorBufferEmbeddedSamplersEXT,             "vkCmdBindDescriptorBufferEmbeddedSamplersEXT")
	set_proc_address(&PtrCmdBindDescriptorBuffersEXT,                            "vkCmdBindDescriptorBuffersEXT")
	set_proc_address(&PtrCmdBindDescriptorSets,                                  "vkCmdBindDescriptorSets")
	set_proc_address(&PtrCmdBindDescriptorSets2,                                 "vkCmdBindDescriptorSets2")
	set_proc_address(&PtrCmdBindDescriptorSets2KHR,                              "vkCmdBindDescriptorSets2KHR")
	set_proc_address(&PtrCmdBindIndexBuffer,                                     "vkCmdBindIndexBuffer")
	set_proc_address(&PtrCmdBindIndexBuffer2,                                    "vkCmdBindIndexBuffer2")
	set_proc_address(&PtrCmdBindIndexBuffer2KHR,                                 "vkCmdBindIndexBuffer2KHR")
	set_proc_address(&PtrCmdBindIndexBuffer3KHR,                                 "vkCmdBindIndexBuffer3KHR")
	set_proc_address(&PtrCmdBindInvocationMaskHUAWEI,                            "vkCmdBindInvocationMaskHUAWEI")
	set_proc_address(&PtrCmdBindPipeline,                                        "vkCmdBindPipeline")
	set_proc_address(&PtrCmdBindPipelineShaderGroupNV,                           "vkCmdBindPipelineShaderGroupNV")
	set_proc_address(&PtrCmdBindResourceHeapEXT,                                 "vkCmdBindResourceHeapEXT")
	set_proc_address(&PtrCmdBindSamplerHeapEXT,                                  "vkCmdBindSamplerHeapEXT")
	set_proc_address(&PtrCmdBindShadersEXT,                                      "vkCmdBindShadersEXT")
	set_proc_address(&PtrCmdBindShadingRateImageNV,                              "vkCmdBindShadingRateImageNV")
	set_proc_address(&PtrCmdBindTileMemoryQCOM,                                  "vkCmdBindTileMemoryQCOM")
	set_proc_address(&PtrCmdBindTransformFeedbackBuffers2EXT,                    "vkCmdBindTransformFeedbackBuffers2EXT")
	set_proc_address(&PtrCmdBindTransformFeedbackBuffersEXT,                     "vkCmdBindTransformFeedbackBuffersEXT")
	set_proc_address(&PtrCmdBindVertexBuffers,                                   "vkCmdBindVertexBuffers")
	set_proc_address(&PtrCmdBindVertexBuffers2,                                  "vkCmdBindVertexBuffers2")
	set_proc_address(&PtrCmdBindVertexBuffers2EXT,                               "vkCmdBindVertexBuffers2EXT")
	set_proc_address(&PtrCmdBindVertexBuffers3KHR,                               "vkCmdBindVertexBuffers3KHR")
	set_proc_address(&PtrCmdBlitImage,                                           "vkCmdBlitImage")
	set_proc_address(&PtrCmdBlitImage2,                                          "vkCmdBlitImage2")
	set_proc_address(&PtrCmdBlitImage2KHR,                                       "vkCmdBlitImage2KHR")
	set_proc_address(&PtrCmdBuildAccelerationStructureNV,                        "vkCmdBuildAccelerationStructureNV")
	set_proc_address(&PtrCmdBuildAccelerationStructuresIndirectKHR,              "vkCmdBuildAccelerationStructuresIndirectKHR")
	set_proc_address(&PtrCmdBuildAccelerationStructuresKHR,                      "vkCmdBuildAccelerationStructuresKHR")
	set_proc_address(&PtrCmdBuildClusterAccelerationStructureIndirectNV,         "vkCmdBuildClusterAccelerationStructureIndirectNV")
	set_proc_address(&PtrCmdBuildMicromapsEXT,                                   "vkCmdBuildMicromapsEXT")
	set_proc_address(&PtrCmdBuildPartitionedAccelerationStructuresNV,            "vkCmdBuildPartitionedAccelerationStructuresNV")
	set_proc_address(&PtrCmdClearAttachments,                                    "vkCmdClearAttachments")
	set_proc_address(&PtrCmdClearColorImage,                                     "vkCmdClearColorImage")
	set_proc_address(&PtrCmdClearDepthStencilImage,                              "vkCmdClearDepthStencilImage")
	set_proc_address(&PtrCmdControlVideoCodingKHR,                               "vkCmdControlVideoCodingKHR")
	set_proc_address(&PtrCmdConvertCooperativeVectorMatrixNV,                    "vkCmdConvertCooperativeVectorMatrixNV")
	set_proc_address(&PtrCmdCopyAccelerationStructureKHR,                        "vkCmdCopyAccelerationStructureKHR")
	set_proc_address(&PtrCmdCopyAccelerationStructureNV,                         "vkCmdCopyAccelerationStructureNV")
	set_proc_address(&PtrCmdCopyAccelerationStructureToMemoryKHR,                "vkCmdCopyAccelerationStructureToMemoryKHR")
	set_proc_address(&PtrCmdCopyBuffer,                                          "vkCmdCopyBuffer")
	set_proc_address(&PtrCmdCopyBuffer2,                                         "vkCmdCopyBuffer2")
	set_proc_address(&PtrCmdCopyBuffer2KHR,                                      "vkCmdCopyBuffer2KHR")
	set_proc_address(&PtrCmdCopyBufferToImage,                                   "vkCmdCopyBufferToImage")
	set_proc_address(&PtrCmdCopyBufferToImage2,                                  "vkCmdCopyBufferToImage2")
	set_proc_address(&PtrCmdCopyBufferToImage2KHR,                               "vkCmdCopyBufferToImage2KHR")
	set_proc_address(&PtrCmdCopyGpaSessionResultsAMD,                            "vkCmdCopyGpaSessionResultsAMD")
	set_proc_address(&PtrCmdCopyImage,                                           "vkCmdCopyImage")
	set_proc_address(&PtrCmdCopyImage2,                                          "vkCmdCopyImage2")
	set_proc_address(&PtrCmdCopyImage2KHR,                                       "vkCmdCopyImage2KHR")
	set_proc_address(&PtrCmdCopyImageToBuffer,                                   "vkCmdCopyImageToBuffer")
	set_proc_address(&PtrCmdCopyImageToBuffer2,                                  "vkCmdCopyImageToBuffer2")
	set_proc_address(&PtrCmdCopyImageToBuffer2KHR,                               "vkCmdCopyImageToBuffer2KHR")
	set_proc_address(&PtrCmdCopyImageToMemoryKHR,                                "vkCmdCopyImageToMemoryKHR")
	set_proc_address(&PtrCmdCopyMemoryIndirectKHR,                               "vkCmdCopyMemoryIndirectKHR")
	set_proc_address(&PtrCmdCopyMemoryIndirectNV,                                "vkCmdCopyMemoryIndirectNV")
	set_proc_address(&PtrCmdCopyMemoryKHR,                                       "vkCmdCopyMemoryKHR")
	set_proc_address(&PtrCmdCopyMemoryToAccelerationStructureKHR,                "vkCmdCopyMemoryToAccelerationStructureKHR")
	set_proc_address(&PtrCmdCopyMemoryToImageIndirectKHR,                        "vkCmdCopyMemoryToImageIndirectKHR")
	set_proc_address(&PtrCmdCopyMemoryToImageIndirectNV,                         "vkCmdCopyMemoryToImageIndirectNV")
	set_proc_address(&PtrCmdCopyMemoryToImageKHR,                                "vkCmdCopyMemoryToImageKHR")
	set_proc_address(&PtrCmdCopyMemoryToMicromapEXT,                             "vkCmdCopyMemoryToMicromapEXT")
	set_proc_address(&PtrCmdCopyMicromapEXT,                                     "vkCmdCopyMicromapEXT")
	set_proc_address(&PtrCmdCopyMicromapToMemoryEXT,                             "vkCmdCopyMicromapToMemoryEXT")
	set_proc_address(&PtrCmdCopyQueryPoolResults,                                "vkCmdCopyQueryPoolResults")
	set_proc_address(&PtrCmdCopyQueryPoolResultsToMemoryKHR,                     "vkCmdCopyQueryPoolResultsToMemoryKHR")
	set_proc_address(&PtrCmdCopyTensorARM,                                       "vkCmdCopyTensorARM")
	set_proc_address(&PtrCmdCuLaunchKernelNVX,                                   "vkCmdCuLaunchKernelNVX")
	set_proc_address(&PtrCmdCudaLaunchKernelNV,                                  "vkCmdCudaLaunchKernelNV")
	set_proc_address(&PtrCmdDebugMarkerBeginEXT,                                 "vkCmdDebugMarkerBeginEXT")
	set_proc_address(&PtrCmdDebugMarkerEndEXT,                                   "vkCmdDebugMarkerEndEXT")
	set_proc_address(&PtrCmdDebugMarkerInsertEXT,                                "vkCmdDebugMarkerInsertEXT")
	set_proc_address(&PtrCmdDecodeVideoKHR,                                      "vkCmdDecodeVideoKHR")
	set_proc_address(&PtrCmdDecompressMemoryEXT,                                 "vkCmdDecompressMemoryEXT")
	set_proc_address(&PtrCmdDecompressMemoryIndirectCountEXT,                    "vkCmdDecompressMemoryIndirectCountEXT")
	set_proc_address(&PtrCmdDecompressMemoryIndirectCountNV,                     "vkCmdDecompressMemoryIndirectCountNV")
	set_proc_address(&PtrCmdDecompressMemoryNV,                                  "vkCmdDecompressMemoryNV")
	set_proc_address(&PtrCmdDispatch,                                            "vkCmdDispatch")
	set_proc_address(&PtrCmdDispatchBase,                                        "vkCmdDispatchBase")
	set_proc_address(&PtrCmdDispatchBaseKHR,                                     "vkCmdDispatchBaseKHR")
	set_proc_address(&PtrCmdDispatchDataGraphARM,                                "vkCmdDispatchDataGraphARM")
	set_proc_address(&PtrCmdDispatchGraphAMDX,                                   "vkCmdDispatchGraphAMDX")
	set_proc_address(&PtrCmdDispatchGraphIndirectAMDX,                           "vkCmdDispatchGraphIndirectAMDX")
	set_proc_address(&PtrCmdDispatchGraphIndirectCountAMDX,                      "vkCmdDispatchGraphIndirectCountAMDX")
	set_proc_address(&PtrCmdDispatchIndirect,                                    "vkCmdDispatchIndirect")
	set_proc_address(&PtrCmdDispatchIndirect2KHR,                                "vkCmdDispatchIndirect2KHR")
	set_proc_address(&PtrCmdDispatchTileQCOM,                                    "vkCmdDispatchTileQCOM")
	set_proc_address(&PtrCmdDraw,                                                "vkCmdDraw")
	set_proc_address(&PtrCmdDrawClusterHUAWEI,                                   "vkCmdDrawClusterHUAWEI")
	set_proc_address(&PtrCmdDrawClusterIndirectHUAWEI,                           "vkCmdDrawClusterIndirectHUAWEI")
	set_proc_address(&PtrCmdDrawIndexed,                                         "vkCmdDrawIndexed")
	set_proc_address(&PtrCmdDrawIndexedIndirect,                                 "vkCmdDrawIndexedIndirect")
	set_proc_address(&PtrCmdDrawIndexedIndirect2KHR,                             "vkCmdDrawIndexedIndirect2KHR")
	set_proc_address(&PtrCmdDrawIndexedIndirectCount,                            "vkCmdDrawIndexedIndirectCount")
	set_proc_address(&PtrCmdDrawIndexedIndirectCount2KHR,                        "vkCmdDrawIndexedIndirectCount2KHR")
	set_proc_address(&PtrCmdDrawIndexedIndirectCountAMD,                         "vkCmdDrawIndexedIndirectCountAMD")
	set_proc_address(&PtrCmdDrawIndexedIndirectCountKHR,                         "vkCmdDrawIndexedIndirectCountKHR")
	set_proc_address(&PtrCmdDrawIndirect,                                        "vkCmdDrawIndirect")
	set_proc_address(&PtrCmdDrawIndirect2KHR,                                    "vkCmdDrawIndirect2KHR")
	set_proc_address(&PtrCmdDrawIndirectByteCount2EXT,                           "vkCmdDrawIndirectByteCount2EXT")
	set_proc_address(&PtrCmdDrawIndirectByteCountEXT,                            "vkCmdDrawIndirectByteCountEXT")
	set_proc_address(&PtrCmdDrawIndirectCount,                                   "vkCmdDrawIndirectCount")
	set_proc_address(&PtrCmdDrawIndirectCount2KHR,                               "vkCmdDrawIndirectCount2KHR")
	set_proc_address(&PtrCmdDrawIndirectCountAMD,                                "vkCmdDrawIndirectCountAMD")
	set_proc_address(&PtrCmdDrawIndirectCountKHR,                                "vkCmdDrawIndirectCountKHR")
	set_proc_address(&PtrCmdDrawMeshTasksEXT,                                    "vkCmdDrawMeshTasksEXT")
	set_proc_address(&PtrCmdDrawMeshTasksIndirect2EXT,                           "vkCmdDrawMeshTasksIndirect2EXT")
	set_proc_address(&PtrCmdDrawMeshTasksIndirectCount2EXT,                      "vkCmdDrawMeshTasksIndirectCount2EXT")
	set_proc_address(&PtrCmdDrawMeshTasksIndirectCountEXT,                       "vkCmdDrawMeshTasksIndirectCountEXT")
	set_proc_address(&PtrCmdDrawMeshTasksIndirectCountNV,                        "vkCmdDrawMeshTasksIndirectCountNV")
	set_proc_address(&PtrCmdDrawMeshTasksIndirectEXT,                            "vkCmdDrawMeshTasksIndirectEXT")
	set_proc_address(&PtrCmdDrawMeshTasksIndirectNV,                             "vkCmdDrawMeshTasksIndirectNV")
	set_proc_address(&PtrCmdDrawMeshTasksNV,                                     "vkCmdDrawMeshTasksNV")
	set_proc_address(&PtrCmdDrawMultiEXT,                                        "vkCmdDrawMultiEXT")
	set_proc_address(&PtrCmdDrawMultiIndexedEXT,                                 "vkCmdDrawMultiIndexedEXT")
	set_proc_address(&PtrCmdEncodeVideoKHR,                                      "vkCmdEncodeVideoKHR")
	set_proc_address(&PtrCmdEndConditionalRenderingEXT,                          "vkCmdEndConditionalRenderingEXT")
	set_proc_address(&PtrCmdEndDebugUtilsLabelEXT,                               "vkCmdEndDebugUtilsLabelEXT")
	set_proc_address(&PtrCmdEndGpaSampleAMD,                                     "vkCmdEndGpaSampleAMD")
	set_proc_address(&PtrCmdEndGpaSessionAMD,                                    "vkCmdEndGpaSessionAMD")
	set_proc_address(&PtrCmdEndPerTileExecutionQCOM,                             "vkCmdEndPerTileExecutionQCOM")
	set_proc_address(&PtrCmdEndQuery,                                            "vkCmdEndQuery")
	set_proc_address(&PtrCmdEndQueryIndexedEXT,                                  "vkCmdEndQueryIndexedEXT")
	set_proc_address(&PtrCmdEndRenderPass,                                       "vkCmdEndRenderPass")
	set_proc_address(&PtrCmdEndRenderPass2,                                      "vkCmdEndRenderPass2")
	set_proc_address(&PtrCmdEndRenderPass2KHR,                                   "vkCmdEndRenderPass2KHR")
	set_proc_address(&PtrCmdEndRendering,                                        "vkCmdEndRendering")
	set_proc_address(&PtrCmdEndRendering2EXT,                                    "vkCmdEndRendering2EXT")
	set_proc_address(&PtrCmdEndRendering2KHR,                                    "vkCmdEndRendering2KHR")
	set_proc_address(&PtrCmdEndRenderingKHR,                                     "vkCmdEndRenderingKHR")
	set_proc_address(&PtrCmdEndShaderInstrumentationARM,                         "vkCmdEndShaderInstrumentationARM")
	set_proc_address(&PtrCmdEndTransformFeedback2EXT,                            "vkCmdEndTransformFeedback2EXT")
	set_proc_address(&PtrCmdEndTransformFeedbackEXT,                             "vkCmdEndTransformFeedbackEXT")
	set_proc_address(&PtrCmdEndVideoCodingKHR,                                   "vkCmdEndVideoCodingKHR")
	set_proc_address(&PtrCmdExecuteCommands,                                     "vkCmdExecuteCommands")
	set_proc_address(&PtrCmdExecuteGeneratedCommandsEXT,                         "vkCmdExecuteGeneratedCommandsEXT")
	set_proc_address(&PtrCmdExecuteGeneratedCommandsNV,                          "vkCmdExecuteGeneratedCommandsNV")
	set_proc_address(&PtrCmdFillBuffer,                                          "vkCmdFillBuffer")
	set_proc_address(&PtrCmdFillMemoryKHR,                                       "vkCmdFillMemoryKHR")
	set_proc_address(&PtrCmdInitializeGraphScratchMemoryAMDX,                    "vkCmdInitializeGraphScratchMemoryAMDX")
	set_proc_address(&PtrCmdInsertDebugUtilsLabelEXT,                            "vkCmdInsertDebugUtilsLabelEXT")
	set_proc_address(&PtrCmdNextSubpass,                                         "vkCmdNextSubpass")
	set_proc_address(&PtrCmdNextSubpass2,                                        "vkCmdNextSubpass2")
	set_proc_address(&PtrCmdNextSubpass2KHR,                                     "vkCmdNextSubpass2KHR")
	set_proc_address(&PtrCmdOpticalFlowExecuteNV,                                "vkCmdOpticalFlowExecuteNV")
	set_proc_address(&PtrCmdPipelineBarrier,                                     "vkCmdPipelineBarrier")
	set_proc_address(&PtrCmdPipelineBarrier2,                                    "vkCmdPipelineBarrier2")
	set_proc_address(&PtrCmdPipelineBarrier2KHR,                                 "vkCmdPipelineBarrier2KHR")
	set_proc_address(&PtrCmdPreprocessGeneratedCommandsEXT,                      "vkCmdPreprocessGeneratedCommandsEXT")
	set_proc_address(&PtrCmdPreprocessGeneratedCommandsNV,                       "vkCmdPreprocessGeneratedCommandsNV")
	set_proc_address(&PtrCmdPushConstants,                                       "vkCmdPushConstants")
	set_proc_address(&PtrCmdPushConstants2,                                      "vkCmdPushConstants2")
	set_proc_address(&PtrCmdPushConstants2KHR,                                   "vkCmdPushConstants2KHR")
	set_proc_address(&PtrCmdPushDataEXT,                                         "vkCmdPushDataEXT")
	set_proc_address(&PtrCmdPushDescriptorSet,                                   "vkCmdPushDescriptorSet")
	set_proc_address(&PtrCmdPushDescriptorSet2,                                  "vkCmdPushDescriptorSet2")
	set_proc_address(&PtrCmdPushDescriptorSet2KHR,                               "vkCmdPushDescriptorSet2KHR")
	set_proc_address(&PtrCmdPushDescriptorSetKHR,                                "vkCmdPushDescriptorSetKHR")
	set_proc_address(&PtrCmdPushDescriptorSetWithTemplate,                       "vkCmdPushDescriptorSetWithTemplate")
	set_proc_address(&PtrCmdPushDescriptorSetWithTemplate2,                      "vkCmdPushDescriptorSetWithTemplate2")
	set_proc_address(&PtrCmdPushDescriptorSetWithTemplate2KHR,                   "vkCmdPushDescriptorSetWithTemplate2KHR")
	set_proc_address(&PtrCmdPushDescriptorSetWithTemplateKHR,                    "vkCmdPushDescriptorSetWithTemplateKHR")
	set_proc_address(&PtrCmdResetEvent,                                          "vkCmdResetEvent")
	set_proc_address(&PtrCmdResetEvent2,                                         "vkCmdResetEvent2")
	set_proc_address(&PtrCmdResetEvent2KHR,                                      "vkCmdResetEvent2KHR")
	set_proc_address(&PtrCmdResetQueryPool,                                      "vkCmdResetQueryPool")
	set_proc_address(&PtrCmdResolveImage,                                        "vkCmdResolveImage")
	set_proc_address(&PtrCmdResolveImage2,                                       "vkCmdResolveImage2")
	set_proc_address(&PtrCmdResolveImage2KHR,                                    "vkCmdResolveImage2KHR")
	set_proc_address(&PtrCmdSetAlphaToCoverageEnableEXT,                         "vkCmdSetAlphaToCoverageEnableEXT")
	set_proc_address(&PtrCmdSetAlphaToOneEnableEXT,                              "vkCmdSetAlphaToOneEnableEXT")
	set_proc_address(&PtrCmdSetAttachmentFeedbackLoopEnableEXT,                  "vkCmdSetAttachmentFeedbackLoopEnableEXT")
	set_proc_address(&PtrCmdSetBlendConstants,                                   "vkCmdSetBlendConstants")
	set_proc_address(&PtrCmdSetCheckpointNV,                                     "vkCmdSetCheckpointNV")
	set_proc_address(&PtrCmdSetCoarseSampleOrderNV,                              "vkCmdSetCoarseSampleOrderNV")
	set_proc_address(&PtrCmdSetColorBlendAdvancedEXT,                            "vkCmdSetColorBlendAdvancedEXT")
	set_proc_address(&PtrCmdSetColorBlendEnableEXT,                              "vkCmdSetColorBlendEnableEXT")
	set_proc_address(&PtrCmdSetColorBlendEquationEXT,                            "vkCmdSetColorBlendEquationEXT")
	set_proc_address(&PtrCmdSetColorWriteEnableEXT,                              "vkCmdSetColorWriteEnableEXT")
	set_proc_address(&PtrCmdSetColorWriteMaskEXT,                                "vkCmdSetColorWriteMaskEXT")
	set_proc_address(&PtrCmdSetComputeOccupancyPriorityNV,                       "vkCmdSetComputeOccupancyPriorityNV")
	set_proc_address(&PtrCmdSetConservativeRasterizationModeEXT,                 "vkCmdSetConservativeRasterizationModeEXT")
	set_proc_address(&PtrCmdSetCoverageModulationModeNV,                         "vkCmdSetCoverageModulationModeNV")
	set_proc_address(&PtrCmdSetCoverageModulationTableEnableNV,                  "vkCmdSetCoverageModulationTableEnableNV")
	set_proc_address(&PtrCmdSetCoverageModulationTableNV,                        "vkCmdSetCoverageModulationTableNV")
	set_proc_address(&PtrCmdSetCoverageReductionModeNV,                          "vkCmdSetCoverageReductionModeNV")
	set_proc_address(&PtrCmdSetCoverageToColorEnableNV,                          "vkCmdSetCoverageToColorEnableNV")
	set_proc_address(&PtrCmdSetCoverageToColorLocationNV,                        "vkCmdSetCoverageToColorLocationNV")
	set_proc_address(&PtrCmdSetCullMode,                                         "vkCmdSetCullMode")
	set_proc_address(&PtrCmdSetCullModeEXT,                                      "vkCmdSetCullModeEXT")
	set_proc_address(&PtrCmdSetDepthBias,                                        "vkCmdSetDepthBias")
	set_proc_address(&PtrCmdSetDepthBias2EXT,                                    "vkCmdSetDepthBias2EXT")
	set_proc_address(&PtrCmdSetDepthBiasEnable,                                  "vkCmdSetDepthBiasEnable")
	set_proc_address(&PtrCmdSetDepthBiasEnableEXT,                               "vkCmdSetDepthBiasEnableEXT")
	set_proc_address(&PtrCmdSetDepthBounds,                                      "vkCmdSetDepthBounds")
	set_proc_address(&PtrCmdSetDepthBoundsTestEnable,                            "vkCmdSetDepthBoundsTestEnable")
	set_proc_address(&PtrCmdSetDepthBoundsTestEnableEXT,                         "vkCmdSetDepthBoundsTestEnableEXT")
	set_proc_address(&PtrCmdSetDepthClampEnableEXT,                              "vkCmdSetDepthClampEnableEXT")
	set_proc_address(&PtrCmdSetDepthClampRangeEXT,                               "vkCmdSetDepthClampRangeEXT")
	set_proc_address(&PtrCmdSetDepthClipEnableEXT,                               "vkCmdSetDepthClipEnableEXT")
	set_proc_address(&PtrCmdSetDepthClipNegativeOneToOneEXT,                     "vkCmdSetDepthClipNegativeOneToOneEXT")
	set_proc_address(&PtrCmdSetDepthCompareOp,                                   "vkCmdSetDepthCompareOp")
	set_proc_address(&PtrCmdSetDepthCompareOpEXT,                                "vkCmdSetDepthCompareOpEXT")
	set_proc_address(&PtrCmdSetDepthTestEnable,                                  "vkCmdSetDepthTestEnable")
	set_proc_address(&PtrCmdSetDepthTestEnableEXT,                               "vkCmdSetDepthTestEnableEXT")
	set_proc_address(&PtrCmdSetDepthWriteEnable,                                 "vkCmdSetDepthWriteEnable")
	set_proc_address(&PtrCmdSetDepthWriteEnableEXT,                              "vkCmdSetDepthWriteEnableEXT")
	set_proc_address(&PtrCmdSetDescriptorBufferOffsets2EXT,                      "vkCmdSetDescriptorBufferOffsets2EXT")
	set_proc_address(&PtrCmdSetDescriptorBufferOffsetsEXT,                       "vkCmdSetDescriptorBufferOffsetsEXT")
	set_proc_address(&PtrCmdSetDeviceMask,                                       "vkCmdSetDeviceMask")
	set_proc_address(&PtrCmdSetDeviceMaskKHR,                                    "vkCmdSetDeviceMaskKHR")
	set_proc_address(&PtrCmdSetDiscardRectangleEXT,                              "vkCmdSetDiscardRectangleEXT")
	set_proc_address(&PtrCmdSetDiscardRectangleEnableEXT,                        "vkCmdSetDiscardRectangleEnableEXT")
	set_proc_address(&PtrCmdSetDiscardRectangleModeEXT,                          "vkCmdSetDiscardRectangleModeEXT")
	set_proc_address(&PtrCmdSetDispatchParametersARM,                            "vkCmdSetDispatchParametersARM")
	set_proc_address(&PtrCmdSetEvent,                                            "vkCmdSetEvent")
	set_proc_address(&PtrCmdSetEvent2,                                           "vkCmdSetEvent2")
	set_proc_address(&PtrCmdSetEvent2KHR,                                        "vkCmdSetEvent2KHR")
	set_proc_address(&PtrCmdSetExclusiveScissorEnableNV,                         "vkCmdSetExclusiveScissorEnableNV")
	set_proc_address(&PtrCmdSetExclusiveScissorNV,                               "vkCmdSetExclusiveScissorNV")
	set_proc_address(&PtrCmdSetExtraPrimitiveOverestimationSizeEXT,              "vkCmdSetExtraPrimitiveOverestimationSizeEXT")
	set_proc_address(&PtrCmdSetFragmentShadingRateEnumNV,                        "vkCmdSetFragmentShadingRateEnumNV")
	set_proc_address(&PtrCmdSetFragmentShadingRateKHR,                           "vkCmdSetFragmentShadingRateKHR")
	set_proc_address(&PtrCmdSetFrontFace,                                        "vkCmdSetFrontFace")
	set_proc_address(&PtrCmdSetFrontFaceEXT,                                     "vkCmdSetFrontFaceEXT")
	set_proc_address(&PtrCmdSetLineRasterizationModeEXT,                         "vkCmdSetLineRasterizationModeEXT")
	set_proc_address(&PtrCmdSetLineStipple,                                      "vkCmdSetLineStipple")
	set_proc_address(&PtrCmdSetLineStippleEXT,                                   "vkCmdSetLineStippleEXT")
	set_proc_address(&PtrCmdSetLineStippleEnableEXT,                             "vkCmdSetLineStippleEnableEXT")
	set_proc_address(&PtrCmdSetLineStippleKHR,                                   "vkCmdSetLineStippleKHR")
	set_proc_address(&PtrCmdSetLineWidth,                                        "vkCmdSetLineWidth")
	set_proc_address(&PtrCmdSetLogicOpEXT,                                       "vkCmdSetLogicOpEXT")
	set_proc_address(&PtrCmdSetLogicOpEnableEXT,                                 "vkCmdSetLogicOpEnableEXT")
	set_proc_address(&PtrCmdSetPatchControlPointsEXT,                            "vkCmdSetPatchControlPointsEXT")
	set_proc_address(&PtrCmdSetPerformanceMarkerINTEL,                           "vkCmdSetPerformanceMarkerINTEL")
	set_proc_address(&PtrCmdSetPerformanceOverrideINTEL,                         "vkCmdSetPerformanceOverrideINTEL")
	set_proc_address(&PtrCmdSetPerformanceStreamMarkerINTEL,                     "vkCmdSetPerformanceStreamMarkerINTEL")
	set_proc_address(&PtrCmdSetPolygonModeEXT,                                   "vkCmdSetPolygonModeEXT")
	set_proc_address(&PtrCmdSetPrimitiveRestartEnable,                           "vkCmdSetPrimitiveRestartEnable")
	set_proc_address(&PtrCmdSetPrimitiveRestartEnableEXT,                        "vkCmdSetPrimitiveRestartEnableEXT")
	set_proc_address(&PtrCmdSetPrimitiveRestartIndexEXT,                         "vkCmdSetPrimitiveRestartIndexEXT")
	set_proc_address(&PtrCmdSetPrimitiveTopology,                                "vkCmdSetPrimitiveTopology")
	set_proc_address(&PtrCmdSetPrimitiveTopologyEXT,                             "vkCmdSetPrimitiveTopologyEXT")
	set_proc_address(&PtrCmdSetProvokingVertexModeEXT,                           "vkCmdSetProvokingVertexModeEXT")
	set_proc_address(&PtrCmdSetRasterizationSamplesEXT,                          "vkCmdSetRasterizationSamplesEXT")
	set_proc_address(&PtrCmdSetRasterizationStreamEXT,                           "vkCmdSetRasterizationStreamEXT")
	set_proc_address(&PtrCmdSetRasterizerDiscardEnable,                          "vkCmdSetRasterizerDiscardEnable")
	set_proc_address(&PtrCmdSetRasterizerDiscardEnableEXT,                       "vkCmdSetRasterizerDiscardEnableEXT")
	set_proc_address(&PtrCmdSetRayTracingPipelineStackSizeKHR,                   "vkCmdSetRayTracingPipelineStackSizeKHR")
	set_proc_address(&PtrCmdSetRenderingAttachmentLocations,                     "vkCmdSetRenderingAttachmentLocations")
	set_proc_address(&PtrCmdSetRenderingAttachmentLocationsKHR,                  "vkCmdSetRenderingAttachmentLocationsKHR")
	set_proc_address(&PtrCmdSetRenderingInputAttachmentIndices,                  "vkCmdSetRenderingInputAttachmentIndices")
	set_proc_address(&PtrCmdSetRenderingInputAttachmentIndicesKHR,               "vkCmdSetRenderingInputAttachmentIndicesKHR")
	set_proc_address(&PtrCmdSetRepresentativeFragmentTestEnableNV,               "vkCmdSetRepresentativeFragmentTestEnableNV")
	set_proc_address(&PtrCmdSetSampleLocationsEXT,                               "vkCmdSetSampleLocationsEXT")
	set_proc_address(&PtrCmdSetSampleLocationsEnableEXT,                         "vkCmdSetSampleLocationsEnableEXT")
	set_proc_address(&PtrCmdSetSampleMaskEXT,                                    "vkCmdSetSampleMaskEXT")
	set_proc_address(&PtrCmdSetScissor,                                          "vkCmdSetScissor")
	set_proc_address(&PtrCmdSetScissorWithCount,                                 "vkCmdSetScissorWithCount")
	set_proc_address(&PtrCmdSetScissorWithCountEXT,                              "vkCmdSetScissorWithCountEXT")
	set_proc_address(&PtrCmdSetShadingRateImageEnableNV,                         "vkCmdSetShadingRateImageEnableNV")
	set_proc_address(&PtrCmdSetStencilCompareMask,                               "vkCmdSetStencilCompareMask")
	set_proc_address(&PtrCmdSetStencilOp,                                        "vkCmdSetStencilOp")
	set_proc_address(&PtrCmdSetStencilOpEXT,                                     "vkCmdSetStencilOpEXT")
	set_proc_address(&PtrCmdSetStencilReference,                                 "vkCmdSetStencilReference")
	set_proc_address(&PtrCmdSetStencilTestEnable,                                "vkCmdSetStencilTestEnable")
	set_proc_address(&PtrCmdSetStencilTestEnableEXT,                             "vkCmdSetStencilTestEnableEXT")
	set_proc_address(&PtrCmdSetStencilWriteMask,                                 "vkCmdSetStencilWriteMask")
	set_proc_address(&PtrCmdSetTessellationDomainOriginEXT,                      "vkCmdSetTessellationDomainOriginEXT")
	set_proc_address(&PtrCmdSetVertexInputEXT,                                   "vkCmdSetVertexInputEXT")
	set_proc_address(&PtrCmdSetViewport,                                         "vkCmdSetViewport")
	set_proc_address(&PtrCmdSetViewportShadingRatePaletteNV,                     "vkCmdSetViewportShadingRatePaletteNV")
	set_proc_address(&PtrCmdSetViewportSwizzleNV,                                "vkCmdSetViewportSwizzleNV")
	set_proc_address(&PtrCmdSetViewportWScalingEnableNV,                         "vkCmdSetViewportWScalingEnableNV")
	set_proc_address(&PtrCmdSetViewportWScalingNV,                               "vkCmdSetViewportWScalingNV")
	set_proc_address(&PtrCmdSetViewportWithCount,                                "vkCmdSetViewportWithCount")
	set_proc_address(&PtrCmdSetViewportWithCountEXT,                             "vkCmdSetViewportWithCountEXT")
	set_proc_address(&PtrCmdSubpassShadingHUAWEI,                                "vkCmdSubpassShadingHUAWEI")
	set_proc_address(&PtrCmdTraceRaysIndirect2KHR,                               "vkCmdTraceRaysIndirect2KHR")
	set_proc_address(&PtrCmdTraceRaysIndirectKHR,                                "vkCmdTraceRaysIndirectKHR")
	set_proc_address(&PtrCmdTraceRaysKHR,                                        "vkCmdTraceRaysKHR")
	set_proc_address(&PtrCmdTraceRaysNV,                                         "vkCmdTraceRaysNV")
	set_proc_address(&PtrCmdUpdateBuffer,                                        "vkCmdUpdateBuffer")
	set_proc_address(&PtrCmdUpdateMemoryKHR,                                     "vkCmdUpdateMemoryKHR")
	set_proc_address(&PtrCmdUpdatePipelineIndirectBufferNV,                      "vkCmdUpdatePipelineIndirectBufferNV")
	set_proc_address(&PtrCmdWaitEvents,                                          "vkCmdWaitEvents")
	set_proc_address(&PtrCmdWaitEvents2,                                         "vkCmdWaitEvents2")
	set_proc_address(&PtrCmdWaitEvents2KHR,                                      "vkCmdWaitEvents2KHR")
	set_proc_address(&PtrCmdWriteAccelerationStructuresPropertiesKHR,            "vkCmdWriteAccelerationStructuresPropertiesKHR")
	set_proc_address(&PtrCmdWriteAccelerationStructuresPropertiesNV,             "vkCmdWriteAccelerationStructuresPropertiesNV")
	set_proc_address(&PtrCmdWriteBufferMarker2AMD,                               "vkCmdWriteBufferMarker2AMD")
	set_proc_address(&PtrCmdWriteBufferMarkerAMD,                                "vkCmdWriteBufferMarkerAMD")
	set_proc_address(&PtrCmdWriteMarkerToMemoryAMD,                              "vkCmdWriteMarkerToMemoryAMD")
	set_proc_address(&PtrCmdWriteMicromapsPropertiesEXT,                         "vkCmdWriteMicromapsPropertiesEXT")
	set_proc_address(&PtrCmdWriteTimestamp,                                      "vkCmdWriteTimestamp")
	set_proc_address(&PtrCmdWriteTimestamp2,                                     "vkCmdWriteTimestamp2")
	set_proc_address(&PtrCmdWriteTimestamp2KHR,                                  "vkCmdWriteTimestamp2KHR")
	set_proc_address(&PtrCompileDeferredNV,                                      "vkCompileDeferredNV")
	set_proc_address(&PtrConvertCooperativeVectorMatrixNV,                       "vkConvertCooperativeVectorMatrixNV")
	set_proc_address(&PtrCopyAccelerationStructureKHR,                           "vkCopyAccelerationStructureKHR")
	set_proc_address(&PtrCopyAccelerationStructureToMemoryKHR,                   "vkCopyAccelerationStructureToMemoryKHR")
	set_proc_address(&PtrCopyImageToImage,                                       "vkCopyImageToImage")
	set_proc_address(&PtrCopyImageToImageEXT,                                    "vkCopyImageToImageEXT")
	set_proc_address(&PtrCopyImageToMemory,                                      "vkCopyImageToMemory")
	set_proc_address(&PtrCopyImageToMemoryEXT,                                   "vkCopyImageToMemoryEXT")
	set_proc_address(&PtrCopyMemoryToAccelerationStructureKHR,                   "vkCopyMemoryToAccelerationStructureKHR")
	set_proc_address(&PtrCopyMemoryToImage,                                      "vkCopyMemoryToImage")
	set_proc_address(&PtrCopyMemoryToImageEXT,                                   "vkCopyMemoryToImageEXT")
	set_proc_address(&PtrCopyMemoryToMicromapEXT,                                "vkCopyMemoryToMicromapEXT")
	set_proc_address(&PtrCopyMicromapEXT,                                        "vkCopyMicromapEXT")
	set_proc_address(&PtrCopyMicromapToMemoryEXT,                                "vkCopyMicromapToMemoryEXT")
	set_proc_address(&PtrCreateAccelerationStructure2KHR,                        "vkCreateAccelerationStructure2KHR")
	set_proc_address(&PtrCreateAccelerationStructureKHR,                         "vkCreateAccelerationStructureKHR")
	set_proc_address(&PtrCreateAccelerationStructureNV,                          "vkCreateAccelerationStructureNV")
	set_proc_address(&PtrCreateBuffer,                                           "vkCreateBuffer")
	set_proc_address(&PtrCreateBufferView,                                       "vkCreateBufferView")
	set_proc_address(&PtrCreateCommandPool,                                      "vkCreateCommandPool")
	set_proc_address(&PtrCreateComputePipelines,                                 "vkCreateComputePipelines")
	set_proc_address(&PtrCreateCuFunctionNVX,                                    "vkCreateCuFunctionNVX")
	set_proc_address(&PtrCreateCuModuleNVX,                                      "vkCreateCuModuleNVX")
	set_proc_address(&PtrCreateCudaFunctionNV,                                   "vkCreateCudaFunctionNV")
	set_proc_address(&PtrCreateCudaModuleNV,                                     "vkCreateCudaModuleNV")
	set_proc_address(&PtrCreateDataGraphPipelineSessionARM,                      "vkCreateDataGraphPipelineSessionARM")
	set_proc_address(&PtrCreateDataGraphPipelinesARM,                            "vkCreateDataGraphPipelinesARM")
	set_proc_address(&PtrCreateDeferredOperationKHR,                             "vkCreateDeferredOperationKHR")
	set_proc_address(&PtrCreateDescriptorPool,                                   "vkCreateDescriptorPool")
	set_proc_address(&PtrCreateDescriptorSetLayout,                              "vkCreateDescriptorSetLayout")
	set_proc_address(&PtrCreateDescriptorUpdateTemplate,                         "vkCreateDescriptorUpdateTemplate")
	set_proc_address(&PtrCreateDescriptorUpdateTemplateKHR,                      "vkCreateDescriptorUpdateTemplateKHR")
	set_proc_address(&PtrCreateEvent,                                            "vkCreateEvent")
	set_proc_address(&PtrCreateExecutionGraphPipelinesAMDX,                      "vkCreateExecutionGraphPipelinesAMDX")
	set_proc_address(&PtrCreateExternalComputeQueueNV,                           "vkCreateExternalComputeQueueNV")
	set_proc_address(&PtrCreateFence,                                            "vkCreateFence")
	set_proc_address(&PtrCreateFramebuffer,                                      "vkCreateFramebuffer")
	set_proc_address(&PtrCreateGpaSessionAMD,                                    "vkCreateGpaSessionAMD")
	set_proc_address(&PtrCreateGraphicsPipelines,                                "vkCreateGraphicsPipelines")
	set_proc_address(&PtrCreateImage,                                            "vkCreateImage")
	set_proc_address(&PtrCreateImageView,                                        "vkCreateImageView")
	set_proc_address(&PtrCreateIndirectCommandsLayoutEXT,                        "vkCreateIndirectCommandsLayoutEXT")
	set_proc_address(&PtrCreateIndirectCommandsLayoutNV,                         "vkCreateIndirectCommandsLayoutNV")
	set_proc_address(&PtrCreateIndirectExecutionSetEXT,                          "vkCreateIndirectExecutionSetEXT")
	set_proc_address(&PtrCreateMicromapEXT,                                      "vkCreateMicromapEXT")
	set_proc_address(&PtrCreateOpticalFlowSessionNV,                             "vkCreateOpticalFlowSessionNV")
	set_proc_address(&PtrCreatePipelineBinariesKHR,                              "vkCreatePipelineBinariesKHR")
	set_proc_address(&PtrCreatePipelineCache,                                    "vkCreatePipelineCache")
	set_proc_address(&PtrCreatePipelineLayout,                                   "vkCreatePipelineLayout")
	set_proc_address(&PtrCreatePrivateDataSlot,                                  "vkCreatePrivateDataSlot")
	set_proc_address(&PtrCreatePrivateDataSlotEXT,                               "vkCreatePrivateDataSlotEXT")
	set_proc_address(&PtrCreateQueryPool,                                        "vkCreateQueryPool")
	set_proc_address(&PtrCreateRayTracingPipelinesKHR,                           "vkCreateRayTracingPipelinesKHR")
	set_proc_address(&PtrCreateRayTracingPipelinesNV,                            "vkCreateRayTracingPipelinesNV")
	set_proc_address(&PtrCreateRenderPass,                                       "vkCreateRenderPass")
	set_proc_address(&PtrCreateRenderPass2,                                      "vkCreateRenderPass2")
	set_proc_address(&PtrCreateRenderPass2KHR,                                   "vkCreateRenderPass2KHR")
	set_proc_address(&PtrCreateSampler,                                          "vkCreateSampler")
	set_proc_address(&PtrCreateSamplerYcbcrConversion,                           "vkCreateSamplerYcbcrConversion")
	set_proc_address(&PtrCreateSamplerYcbcrConversionKHR,                        "vkCreateSamplerYcbcrConversionKHR")
	set_proc_address(&PtrCreateSemaphore,                                        "vkCreateSemaphore")
	set_proc_address(&PtrCreateShaderInstrumentationARM,                         "vkCreateShaderInstrumentationARM")
	set_proc_address(&PtrCreateShaderModule,                                     "vkCreateShaderModule")
	set_proc_address(&PtrCreateShadersEXT,                                       "vkCreateShadersEXT")
	set_proc_address(&PtrCreateSharedSwapchainsKHR,                              "vkCreateSharedSwapchainsKHR")
	set_proc_address(&PtrCreateSwapchainKHR,                                     "vkCreateSwapchainKHR")
	set_proc_address(&PtrCreateTensorARM,                                        "vkCreateTensorARM")
	set_proc_address(&PtrCreateTensorViewARM,                                    "vkCreateTensorViewARM")
	set_proc_address(&PtrCreateValidationCacheEXT,                               "vkCreateValidationCacheEXT")
	set_proc_address(&PtrCreateVideoSessionKHR,                                  "vkCreateVideoSessionKHR")
	set_proc_address(&PtrCreateVideoSessionParametersKHR,                        "vkCreateVideoSessionParametersKHR")
	set_proc_address(&PtrDebugMarkerSetObjectNameEXT,                            "vkDebugMarkerSetObjectNameEXT")
	set_proc_address(&PtrDebugMarkerSetObjectTagEXT,                             "vkDebugMarkerSetObjectTagEXT")
	set_proc_address(&PtrDeferredOperationJoinKHR,                               "vkDeferredOperationJoinKHR")
	set_proc_address(&PtrDestroyAccelerationStructureKHR,                        "vkDestroyAccelerationStructureKHR")
	set_proc_address(&PtrDestroyAccelerationStructureNV,                         "vkDestroyAccelerationStructureNV")
	set_proc_address(&PtrDestroyBuffer,                                          "vkDestroyBuffer")
	set_proc_address(&PtrDestroyBufferView,                                      "vkDestroyBufferView")
	set_proc_address(&PtrDestroyCommandPool,                                     "vkDestroyCommandPool")
	set_proc_address(&PtrDestroyCuFunctionNVX,                                   "vkDestroyCuFunctionNVX")
	set_proc_address(&PtrDestroyCuModuleNVX,                                     "vkDestroyCuModuleNVX")
	set_proc_address(&PtrDestroyCudaFunctionNV,                                  "vkDestroyCudaFunctionNV")
	set_proc_address(&PtrDestroyCudaModuleNV,                                    "vkDestroyCudaModuleNV")
	set_proc_address(&PtrDestroyDataGraphPipelineSessionARM,                     "vkDestroyDataGraphPipelineSessionARM")
	set_proc_address(&PtrDestroyDeferredOperationKHR,                            "vkDestroyDeferredOperationKHR")
	set_proc_address(&PtrDestroyDescriptorPool,                                  "vkDestroyDescriptorPool")
	set_proc_address(&PtrDestroyDescriptorSetLayout,                             "vkDestroyDescriptorSetLayout")
	set_proc_address(&PtrDestroyDescriptorUpdateTemplate,                        "vkDestroyDescriptorUpdateTemplate")
	set_proc_address(&PtrDestroyDescriptorUpdateTemplateKHR,                     "vkDestroyDescriptorUpdateTemplateKHR")
	set_proc_address(&PtrDestroyDevice,                                          "vkDestroyDevice")
	set_proc_address(&PtrDestroyEvent,                                           "vkDestroyEvent")
	set_proc_address(&PtrDestroyExternalComputeQueueNV,                          "vkDestroyExternalComputeQueueNV")
	set_proc_address(&PtrDestroyFence,                                           "vkDestroyFence")
	set_proc_address(&PtrDestroyFramebuffer,                                     "vkDestroyFramebuffer")
	set_proc_address(&PtrDestroyGpaSessionAMD,                                   "vkDestroyGpaSessionAMD")
	set_proc_address(&PtrDestroyImage,                                           "vkDestroyImage")
	set_proc_address(&PtrDestroyImageView,                                       "vkDestroyImageView")
	set_proc_address(&PtrDestroyIndirectCommandsLayoutEXT,                       "vkDestroyIndirectCommandsLayoutEXT")
	set_proc_address(&PtrDestroyIndirectCommandsLayoutNV,                        "vkDestroyIndirectCommandsLayoutNV")
	set_proc_address(&PtrDestroyIndirectExecutionSetEXT,                         "vkDestroyIndirectExecutionSetEXT")
	set_proc_address(&PtrDestroyMicromapEXT,                                     "vkDestroyMicromapEXT")
	set_proc_address(&PtrDestroyOpticalFlowSessionNV,                            "vkDestroyOpticalFlowSessionNV")
	set_proc_address(&PtrDestroyPipeline,                                        "vkDestroyPipeline")
	set_proc_address(&PtrDestroyPipelineBinaryKHR,                               "vkDestroyPipelineBinaryKHR")
	set_proc_address(&PtrDestroyPipelineCache,                                   "vkDestroyPipelineCache")
	set_proc_address(&PtrDestroyPipelineLayout,                                  "vkDestroyPipelineLayout")
	set_proc_address(&PtrDestroyPrivateDataSlot,                                 "vkDestroyPrivateDataSlot")
	set_proc_address(&PtrDestroyPrivateDataSlotEXT,                              "vkDestroyPrivateDataSlotEXT")
	set_proc_address(&PtrDestroyQueryPool,                                       "vkDestroyQueryPool")
	set_proc_address(&PtrDestroyRenderPass,                                      "vkDestroyRenderPass")
	set_proc_address(&PtrDestroySampler,                                         "vkDestroySampler")
	set_proc_address(&PtrDestroySamplerYcbcrConversion,                          "vkDestroySamplerYcbcrConversion")
	set_proc_address(&PtrDestroySamplerYcbcrConversionKHR,                       "vkDestroySamplerYcbcrConversionKHR")
	set_proc_address(&PtrDestroySemaphore,                                       "vkDestroySemaphore")
	set_proc_address(&PtrDestroyShaderEXT,                                       "vkDestroyShaderEXT")
	set_proc_address(&PtrDestroyShaderInstrumentationARM,                        "vkDestroyShaderInstrumentationARM")
	set_proc_address(&PtrDestroyShaderModule,                                    "vkDestroyShaderModule")
	set_proc_address(&PtrDestroySwapchainKHR,                                    "vkDestroySwapchainKHR")
	set_proc_address(&PtrDestroyTensorARM,                                       "vkDestroyTensorARM")
	set_proc_address(&PtrDestroyTensorViewARM,                                   "vkDestroyTensorViewARM")
	set_proc_address(&PtrDestroyValidationCacheEXT,                              "vkDestroyValidationCacheEXT")
	set_proc_address(&PtrDestroyVideoSessionKHR,                                 "vkDestroyVideoSessionKHR")
	set_proc_address(&PtrDestroyVideoSessionParametersKHR,                       "vkDestroyVideoSessionParametersKHR")
	set_proc_address(&PtrDeviceWaitIdle,                                         "vkDeviceWaitIdle")
	set_proc_address(&PtrDisplayPowerControlEXT,                                 "vkDisplayPowerControlEXT")
	set_proc_address(&PtrEndCommandBuffer,                                       "vkEndCommandBuffer")
	set_proc_address(&PtrExportMetalObjectsEXT,                                  "vkExportMetalObjectsEXT")
	set_proc_address(&PtrFlushMappedMemoryRanges,                                "vkFlushMappedMemoryRanges")
	set_proc_address(&PtrFreeCommandBuffers,                                     "vkFreeCommandBuffers")
	set_proc_address(&PtrFreeDescriptorSets,                                     "vkFreeDescriptorSets")
	set_proc_address(&PtrFreeMemory,                                             "vkFreeMemory")
	set_proc_address(&PtrGetAccelerationStructureBuildSizesKHR,                  "vkGetAccelerationStructureBuildSizesKHR")
	set_proc_address(&PtrGetAccelerationStructureDeviceAddressKHR,               "vkGetAccelerationStructureDeviceAddressKHR")
	set_proc_address(&PtrGetAccelerationStructureHandleNV,                       "vkGetAccelerationStructureHandleNV")
	set_proc_address(&PtrGetAccelerationStructureMemoryRequirementsNV,           "vkGetAccelerationStructureMemoryRequirementsNV")
	set_proc_address(&PtrGetAccelerationStructureOpaqueCaptureDescriptorDataEXT, "vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT")
	set_proc_address(&PtrGetAndroidHardwareBufferPropertiesANDROID,              "vkGetAndroidHardwareBufferPropertiesANDROID")
	set_proc_address(&PtrGetBufferDeviceAddress,                                 "vkGetBufferDeviceAddress")
	set_proc_address(&PtrGetBufferDeviceAddressEXT,                              "vkGetBufferDeviceAddressEXT")
	set_proc_address(&PtrGetBufferDeviceAddressKHR,                              "vkGetBufferDeviceAddressKHR")
	set_proc_address(&PtrGetBufferMemoryRequirements,                            "vkGetBufferMemoryRequirements")
	set_proc_address(&PtrGetBufferMemoryRequirements2,                           "vkGetBufferMemoryRequirements2")
	set_proc_address(&PtrGetBufferMemoryRequirements2KHR,                        "vkGetBufferMemoryRequirements2KHR")
	set_proc_address(&PtrGetBufferOpaqueCaptureAddress,                          "vkGetBufferOpaqueCaptureAddress")
	set_proc_address(&PtrGetBufferOpaqueCaptureAddressKHR,                       "vkGetBufferOpaqueCaptureAddressKHR")
	set_proc_address(&PtrGetBufferOpaqueCaptureDescriptorDataEXT,                "vkGetBufferOpaqueCaptureDescriptorDataEXT")
	set_proc_address(&PtrGetCalibratedTimestampsEXT,                             "vkGetCalibratedTimestampsEXT")
	set_proc_address(&PtrGetCalibratedTimestampsKHR,                             "vkGetCalibratedTimestampsKHR")
	set_proc_address(&PtrGetClusterAccelerationStructureBuildSizesNV,            "vkGetClusterAccelerationStructureBuildSizesNV")
	set_proc_address(&PtrGetCudaModuleCacheNV,                                   "vkGetCudaModuleCacheNV")
	set_proc_address(&PtrGetDataGraphPipelineAvailablePropertiesARM,             "vkGetDataGraphPipelineAvailablePropertiesARM")
	set_proc_address(&PtrGetDataGraphPipelinePropertiesARM,                      "vkGetDataGraphPipelinePropertiesARM")
	set_proc_address(&PtrGetDataGraphPipelineSessionBindPointRequirementsARM,    "vkGetDataGraphPipelineSessionBindPointRequirementsARM")
	set_proc_address(&PtrGetDataGraphPipelineSessionMemoryRequirementsARM,       "vkGetDataGraphPipelineSessionMemoryRequirementsARM")
	set_proc_address(&PtrGetDeferredOperationMaxConcurrencyKHR,                  "vkGetDeferredOperationMaxConcurrencyKHR")
	set_proc_address(&PtrGetDeferredOperationResultKHR,                          "vkGetDeferredOperationResultKHR")
	set_proc_address(&PtrGetDescriptorEXT,                                       "vkGetDescriptorEXT")
	set_proc_address(&PtrGetDescriptorSetHostMappingVALVE,                       "vkGetDescriptorSetHostMappingVALVE")
	set_proc_address(&PtrGetDescriptorSetLayoutBindingOffsetEXT,                 "vkGetDescriptorSetLayoutBindingOffsetEXT")
	set_proc_address(&PtrGetDescriptorSetLayoutHostMappingInfoVALVE,             "vkGetDescriptorSetLayoutHostMappingInfoVALVE")
	set_proc_address(&PtrGetDescriptorSetLayoutSizeEXT,                          "vkGetDescriptorSetLayoutSizeEXT")
	set_proc_address(&PtrGetDescriptorSetLayoutSupport,                          "vkGetDescriptorSetLayoutSupport")
	set_proc_address(&PtrGetDescriptorSetLayoutSupportKHR,                       "vkGetDescriptorSetLayoutSupportKHR")
	set_proc_address(&PtrGetDeviceAccelerationStructureCompatibilityKHR,         "vkGetDeviceAccelerationStructureCompatibilityKHR")
	set_proc_address(&PtrGetDeviceBufferMemoryRequirements,                      "vkGetDeviceBufferMemoryRequirements")
	set_proc_address(&PtrGetDeviceBufferMemoryRequirementsKHR,                   "vkGetDeviceBufferMemoryRequirementsKHR")
	set_proc_address(&PtrGetDeviceCombinedImageSamplerIndexNVX,                  "vkGetDeviceCombinedImageSamplerIndexNVX")
	set_proc_address(&PtrGetDeviceFaultDebugInfoKHR,                             "vkGetDeviceFaultDebugInfoKHR")
	set_proc_address(&PtrGetDeviceFaultInfoEXT,                                  "vkGetDeviceFaultInfoEXT")
	set_proc_address(&PtrGetDeviceFaultReportsKHR,                               "vkGetDeviceFaultReportsKHR")
	set_proc_address(&PtrGetDeviceGroupPeerMemoryFeatures,                       "vkGetDeviceGroupPeerMemoryFeatures")
	set_proc_address(&PtrGetDeviceGroupPeerMemoryFeaturesKHR,                    "vkGetDeviceGroupPeerMemoryFeaturesKHR")
	set_proc_address(&PtrGetDeviceGroupPresentCapabilitiesKHR,                   "vkGetDeviceGroupPresentCapabilitiesKHR")
	set_proc_address(&PtrGetDeviceGroupSurfacePresentModes2EXT,                  "vkGetDeviceGroupSurfacePresentModes2EXT")
	set_proc_address(&PtrGetDeviceGroupSurfacePresentModesKHR,                   "vkGetDeviceGroupSurfacePresentModesKHR")
	set_proc_address(&PtrGetDeviceImageMemoryRequirements,                       "vkGetDeviceImageMemoryRequirements")
	set_proc_address(&PtrGetDeviceImageMemoryRequirementsKHR,                    "vkGetDeviceImageMemoryRequirementsKHR")
	set_proc_address(&PtrGetDeviceImageSparseMemoryRequirements,                 "vkGetDeviceImageSparseMemoryRequirements")
	set_proc_address(&PtrGetDeviceImageSparseMemoryRequirementsKHR,              "vkGetDeviceImageSparseMemoryRequirementsKHR")
	set_proc_address(&PtrGetDeviceImageSubresourceLayout,                        "vkGetDeviceImageSubresourceLayout")
	set_proc_address(&PtrGetDeviceImageSubresourceLayoutKHR,                     "vkGetDeviceImageSubresourceLayoutKHR")
	set_proc_address(&PtrGetDeviceMemoryCommitment,                              "vkGetDeviceMemoryCommitment")
	set_proc_address(&PtrGetDeviceMemoryOpaqueCaptureAddress,                    "vkGetDeviceMemoryOpaqueCaptureAddress")
	set_proc_address(&PtrGetDeviceMemoryOpaqueCaptureAddressKHR,                 "vkGetDeviceMemoryOpaqueCaptureAddressKHR")
	set_proc_address(&PtrGetDeviceMicromapCompatibilityEXT,                      "vkGetDeviceMicromapCompatibilityEXT")
	set_proc_address(&PtrGetDeviceProcAddr,                                      "vkGetDeviceProcAddr")
	set_proc_address(&PtrGetDeviceQueue,                                         "vkGetDeviceQueue")
	set_proc_address(&PtrGetDeviceQueue2,                                        "vkGetDeviceQueue2")
	set_proc_address(&PtrGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI,          "vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI")
	set_proc_address(&PtrGetDeviceTensorMemoryRequirementsARM,                   "vkGetDeviceTensorMemoryRequirementsARM")
	set_proc_address(&PtrGetDynamicRenderingTilePropertiesQCOM,                  "vkGetDynamicRenderingTilePropertiesQCOM")
	set_proc_address(&PtrGetEncodedVideoSessionParametersKHR,                    "vkGetEncodedVideoSessionParametersKHR")
	set_proc_address(&PtrGetEventStatus,                                         "vkGetEventStatus")
	set_proc_address(&PtrGetExecutionGraphPipelineNodeIndexAMDX,                 "vkGetExecutionGraphPipelineNodeIndexAMDX")
	set_proc_address(&PtrGetExecutionGraphPipelineScratchSizeAMDX,               "vkGetExecutionGraphPipelineScratchSizeAMDX")
	set_proc_address(&PtrGetFenceFdKHR,                                          "vkGetFenceFdKHR")
	set_proc_address(&PtrGetFenceStatus,                                         "vkGetFenceStatus")
	set_proc_address(&PtrGetFenceWin32HandleKHR,                                 "vkGetFenceWin32HandleKHR")
	set_proc_address(&PtrGetFramebufferTilePropertiesQCOM,                       "vkGetFramebufferTilePropertiesQCOM")
	set_proc_address(&PtrGetGeneratedCommandsMemoryRequirementsEXT,              "vkGetGeneratedCommandsMemoryRequirementsEXT")
	set_proc_address(&PtrGetGeneratedCommandsMemoryRequirementsNV,               "vkGetGeneratedCommandsMemoryRequirementsNV")
	set_proc_address(&PtrGetGpaDeviceClockInfoAMD,                               "vkGetGpaDeviceClockInfoAMD")
	set_proc_address(&PtrGetGpaSessionResultsAMD,                                "vkGetGpaSessionResultsAMD")
	set_proc_address(&PtrGetGpaSessionStatusAMD,                                 "vkGetGpaSessionStatusAMD")
	set_proc_address(&PtrGetImageDrmFormatModifierPropertiesEXT,                 "vkGetImageDrmFormatModifierPropertiesEXT")
	set_proc_address(&PtrGetImageMemoryRequirements,                             "vkGetImageMemoryRequirements")
	set_proc_address(&PtrGetImageMemoryRequirements2,                            "vkGetImageMemoryRequirements2")
	set_proc_address(&PtrGetImageMemoryRequirements2KHR,                         "vkGetImageMemoryRequirements2KHR")
	set_proc_address(&PtrGetImageOpaqueCaptureDataEXT,                           "vkGetImageOpaqueCaptureDataEXT")
	set_proc_address(&PtrGetImageOpaqueCaptureDescriptorDataEXT,                 "vkGetImageOpaqueCaptureDescriptorDataEXT")
	set_proc_address(&PtrGetImageSparseMemoryRequirements,                       "vkGetImageSparseMemoryRequirements")
	set_proc_address(&PtrGetImageSparseMemoryRequirements2,                      "vkGetImageSparseMemoryRequirements2")
	set_proc_address(&PtrGetImageSparseMemoryRequirements2KHR,                   "vkGetImageSparseMemoryRequirements2KHR")
	set_proc_address(&PtrGetImageSubresourceLayout,                              "vkGetImageSubresourceLayout")
	set_proc_address(&PtrGetImageSubresourceLayout2,                             "vkGetImageSubresourceLayout2")
	set_proc_address(&PtrGetImageSubresourceLayout2EXT,                          "vkGetImageSubresourceLayout2EXT")
	set_proc_address(&PtrGetImageSubresourceLayout2KHR,                          "vkGetImageSubresourceLayout2KHR")
	set_proc_address(&PtrGetImageViewAddressNVX,                                 "vkGetImageViewAddressNVX")
	set_proc_address(&PtrGetImageViewHandle64NVX,                                "vkGetImageViewHandle64NVX")
	set_proc_address(&PtrGetImageViewHandleNVX,                                  "vkGetImageViewHandleNVX")
	set_proc_address(&PtrGetImageViewOpaqueCaptureDescriptorDataEXT,             "vkGetImageViewOpaqueCaptureDescriptorDataEXT")
	set_proc_address(&PtrGetLatencyTimingsNV,                                    "vkGetLatencyTimingsNV")
	set_proc_address(&PtrGetMemoryAndroidHardwareBufferANDROID,                  "vkGetMemoryAndroidHardwareBufferANDROID")
	set_proc_address(&PtrGetMemoryFdKHR,                                         "vkGetMemoryFdKHR")
	set_proc_address(&PtrGetMemoryFdPropertiesKHR,                               "vkGetMemoryFdPropertiesKHR")
	set_proc_address(&PtrGetMemoryHostPointerPropertiesEXT,                      "vkGetMemoryHostPointerPropertiesEXT")
	set_proc_address(&PtrGetMemoryMetalHandleEXT,                                "vkGetMemoryMetalHandleEXT")
	set_proc_address(&PtrGetMemoryMetalHandlePropertiesEXT,                      "vkGetMemoryMetalHandlePropertiesEXT")
	set_proc_address(&PtrGetMemoryRemoteAddressNV,                               "vkGetMemoryRemoteAddressNV")
	set_proc_address(&PtrGetMemoryWin32HandleKHR,                                "vkGetMemoryWin32HandleKHR")
	set_proc_address(&PtrGetMemoryWin32HandleNV,                                 "vkGetMemoryWin32HandleNV")
	set_proc_address(&PtrGetMemoryWin32HandlePropertiesKHR,                      "vkGetMemoryWin32HandlePropertiesKHR")
	set_proc_address(&PtrGetMicromapBuildSizesEXT,                               "vkGetMicromapBuildSizesEXT")
	set_proc_address(&PtrGetPartitionedAccelerationStructuresBuildSizesNV,       "vkGetPartitionedAccelerationStructuresBuildSizesNV")
	set_proc_address(&PtrGetPastPresentationTimingEXT,                           "vkGetPastPresentationTimingEXT")
	set_proc_address(&PtrGetPastPresentationTimingGOOGLE,                        "vkGetPastPresentationTimingGOOGLE")
	set_proc_address(&PtrGetPerformanceParameterINTEL,                           "vkGetPerformanceParameterINTEL")
	set_proc_address(&PtrGetPipelineBinaryDataKHR,                               "vkGetPipelineBinaryDataKHR")
	set_proc_address(&PtrGetPipelineCacheData,                                   "vkGetPipelineCacheData")
	set_proc_address(&PtrGetPipelineExecutableInternalRepresentationsKHR,        "vkGetPipelineExecutableInternalRepresentationsKHR")
	set_proc_address(&PtrGetPipelineExecutablePropertiesKHR,                     "vkGetPipelineExecutablePropertiesKHR")
	set_proc_address(&PtrGetPipelineExecutableStatisticsKHR,                     "vkGetPipelineExecutableStatisticsKHR")
	set_proc_address(&PtrGetPipelineIndirectDeviceAddressNV,                     "vkGetPipelineIndirectDeviceAddressNV")
	set_proc_address(&PtrGetPipelineIndirectMemoryRequirementsNV,                "vkGetPipelineIndirectMemoryRequirementsNV")
	set_proc_address(&PtrGetPipelineKeyKHR,                                      "vkGetPipelineKeyKHR")
	set_proc_address(&PtrGetPipelinePropertiesEXT,                               "vkGetPipelinePropertiesEXT")
	set_proc_address(&PtrGetPrivateData,                                         "vkGetPrivateData")
	set_proc_address(&PtrGetPrivateDataEXT,                                      "vkGetPrivateDataEXT")
	set_proc_address(&PtrGetQueryPoolResults,                                    "vkGetQueryPoolResults")
	set_proc_address(&PtrGetQueueCheckpointData2NV,                              "vkGetQueueCheckpointData2NV")
	set_proc_address(&PtrGetQueueCheckpointDataNV,                               "vkGetQueueCheckpointDataNV")
	set_proc_address(&PtrGetRayTracingCaptureReplayShaderGroupHandlesKHR,        "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR")
	set_proc_address(&PtrGetRayTracingShaderGroupHandlesKHR,                     "vkGetRayTracingShaderGroupHandlesKHR")
	set_proc_address(&PtrGetRayTracingShaderGroupHandlesNV,                      "vkGetRayTracingShaderGroupHandlesNV")
	set_proc_address(&PtrGetRayTracingShaderGroupStackSizeKHR,                   "vkGetRayTracingShaderGroupStackSizeKHR")
	set_proc_address(&PtrGetRefreshCycleDurationGOOGLE,                          "vkGetRefreshCycleDurationGOOGLE")
	set_proc_address(&PtrGetRenderAreaGranularity,                               "vkGetRenderAreaGranularity")
	set_proc_address(&PtrGetRenderingAreaGranularity,                            "vkGetRenderingAreaGranularity")
	set_proc_address(&PtrGetRenderingAreaGranularityKHR,                         "vkGetRenderingAreaGranularityKHR")
	set_proc_address(&PtrGetSamplerOpaqueCaptureDescriptorDataEXT,               "vkGetSamplerOpaqueCaptureDescriptorDataEXT")
	set_proc_address(&PtrGetSemaphoreCounterValue,                               "vkGetSemaphoreCounterValue")
	set_proc_address(&PtrGetSemaphoreCounterValueKHR,                            "vkGetSemaphoreCounterValueKHR")
	set_proc_address(&PtrGetSemaphoreFdKHR,                                      "vkGetSemaphoreFdKHR")
	set_proc_address(&PtrGetSemaphoreWin32HandleKHR,                             "vkGetSemaphoreWin32HandleKHR")
	set_proc_address(&PtrGetShaderBinaryDataEXT,                                 "vkGetShaderBinaryDataEXT")
	set_proc_address(&PtrGetShaderInfoAMD,                                       "vkGetShaderInfoAMD")
	set_proc_address(&PtrGetShaderInstrumentationValuesARM,                      "vkGetShaderInstrumentationValuesARM")
	set_proc_address(&PtrGetShaderModuleCreateInfoIdentifierEXT,                 "vkGetShaderModuleCreateInfoIdentifierEXT")
	set_proc_address(&PtrGetShaderModuleIdentifierEXT,                           "vkGetShaderModuleIdentifierEXT")
	set_proc_address(&PtrGetSwapchainCounterEXT,                                 "vkGetSwapchainCounterEXT")
	set_proc_address(&PtrGetSwapchainImagesKHR,                                  "vkGetSwapchainImagesKHR")
	set_proc_address(&PtrGetSwapchainStatusKHR,                                  "vkGetSwapchainStatusKHR")
	set_proc_address(&PtrGetSwapchainTimeDomainPropertiesEXT,                    "vkGetSwapchainTimeDomainPropertiesEXT")
	set_proc_address(&PtrGetSwapchainTimingPropertiesEXT,                        "vkGetSwapchainTimingPropertiesEXT")
	set_proc_address(&PtrGetTensorMemoryRequirementsARM,                         "vkGetTensorMemoryRequirementsARM")
	set_proc_address(&PtrGetTensorOpaqueCaptureDataARM,                          "vkGetTensorOpaqueCaptureDataARM")
	set_proc_address(&PtrGetTensorOpaqueCaptureDescriptorDataARM,                "vkGetTensorOpaqueCaptureDescriptorDataARM")
	set_proc_address(&PtrGetTensorViewOpaqueCaptureDescriptorDataARM,            "vkGetTensorViewOpaqueCaptureDescriptorDataARM")
	set_proc_address(&PtrGetValidationCacheDataEXT,                              "vkGetValidationCacheDataEXT")
	set_proc_address(&PtrGetVideoSessionMemoryRequirementsKHR,                   "vkGetVideoSessionMemoryRequirementsKHR")
	set_proc_address(&PtrImportFenceFdKHR,                                       "vkImportFenceFdKHR")
	set_proc_address(&PtrImportFenceWin32HandleKHR,                              "vkImportFenceWin32HandleKHR")
	set_proc_address(&PtrImportSemaphoreFdKHR,                                   "vkImportSemaphoreFdKHR")
	set_proc_address(&PtrImportSemaphoreWin32HandleKHR,                          "vkImportSemaphoreWin32HandleKHR")
	set_proc_address(&PtrInitializePerformanceApiINTEL,                          "vkInitializePerformanceApiINTEL")
	set_proc_address(&PtrInvalidateMappedMemoryRanges,                           "vkInvalidateMappedMemoryRanges")
	set_proc_address(&PtrLatencySleepNV,                                         "vkLatencySleepNV")
	set_proc_address(&PtrMapMemory,                                              "vkMapMemory")
	set_proc_address(&PtrMapMemory2,                                             "vkMapMemory2")
	set_proc_address(&PtrMapMemory2KHR,                                          "vkMapMemory2KHR")
	set_proc_address(&PtrMergePipelineCaches,                                    "vkMergePipelineCaches")
	set_proc_address(&PtrMergeValidationCachesEXT,                               "vkMergeValidationCachesEXT")
	set_proc_address(&PtrQueueBeginDebugUtilsLabelEXT,                           "vkQueueBeginDebugUtilsLabelEXT")
	set_proc_address(&PtrQueueBindSparse,                                        "vkQueueBindSparse")
	set_proc_address(&PtrQueueEndDebugUtilsLabelEXT,                             "vkQueueEndDebugUtilsLabelEXT")
	set_proc_address(&PtrQueueInsertDebugUtilsLabelEXT,                          "vkQueueInsertDebugUtilsLabelEXT")
	set_proc_address(&PtrQueueNotifyOutOfBandNV,                                 "vkQueueNotifyOutOfBandNV")
	set_proc_address(&PtrQueuePresentKHR,                                        "vkQueuePresentKHR")
	set_proc_address(&PtrQueueSetPerformanceConfigurationINTEL,                  "vkQueueSetPerformanceConfigurationINTEL")
	set_proc_address(&PtrQueueSubmit,                                            "vkQueueSubmit")
	set_proc_address(&PtrQueueSubmit2,                                           "vkQueueSubmit2")
	set_proc_address(&PtrQueueSubmit2KHR,                                        "vkQueueSubmit2KHR")
	set_proc_address(&PtrQueueWaitIdle,                                          "vkQueueWaitIdle")
	set_proc_address(&PtrRegisterCustomBorderColorEXT,                           "vkRegisterCustomBorderColorEXT")
	set_proc_address(&PtrRegisterDeviceEventEXT,                                 "vkRegisterDeviceEventEXT")
	set_proc_address(&PtrRegisterDisplayEventEXT,                                "vkRegisterDisplayEventEXT")
	set_proc_address(&PtrReleaseCapturedPipelineDataKHR,                         "vkReleaseCapturedPipelineDataKHR")
	set_proc_address(&PtrReleaseFullScreenExclusiveModeEXT,                      "vkReleaseFullScreenExclusiveModeEXT")
	set_proc_address(&PtrReleasePerformanceConfigurationINTEL,                   "vkReleasePerformanceConfigurationINTEL")
	set_proc_address(&PtrReleaseProfilingLockKHR,                                "vkReleaseProfilingLockKHR")
	set_proc_address(&PtrReleaseSwapchainImagesEXT,                              "vkReleaseSwapchainImagesEXT")
	set_proc_address(&PtrReleaseSwapchainImagesKHR,                              "vkReleaseSwapchainImagesKHR")
	set_proc_address(&PtrResetCommandBuffer,                                     "vkResetCommandBuffer")
	set_proc_address(&PtrResetCommandPool,                                       "vkResetCommandPool")
	set_proc_address(&PtrResetDescriptorPool,                                    "vkResetDescriptorPool")
	set_proc_address(&PtrResetEvent,                                             "vkResetEvent")
	set_proc_address(&PtrResetFences,                                            "vkResetFences")
	set_proc_address(&PtrResetGpaSessionAMD,                                     "vkResetGpaSessionAMD")
	set_proc_address(&PtrResetQueryPool,                                         "vkResetQueryPool")
	set_proc_address(&PtrResetQueryPoolEXT,                                      "vkResetQueryPoolEXT")
	set_proc_address(&PtrSetDebugUtilsObjectNameEXT,                             "vkSetDebugUtilsObjectNameEXT")
	set_proc_address(&PtrSetDebugUtilsObjectTagEXT,                              "vkSetDebugUtilsObjectTagEXT")
	set_proc_address(&PtrSetDeviceMemoryPriorityEXT,                             "vkSetDeviceMemoryPriorityEXT")
	set_proc_address(&PtrSetEvent,                                               "vkSetEvent")
	set_proc_address(&PtrSetGpaDeviceClockModeAMD,                               "vkSetGpaDeviceClockModeAMD")
	set_proc_address(&PtrSetHdrMetadataEXT,                                      "vkSetHdrMetadataEXT")
	set_proc_address(&PtrSetLatencyMarkerNV,                                     "vkSetLatencyMarkerNV")
	set_proc_address(&PtrSetLatencySleepModeNV,                                  "vkSetLatencySleepModeNV")
	set_proc_address(&PtrSetLocalDimmingAMD,                                     "vkSetLocalDimmingAMD")
	set_proc_address(&PtrSetPrivateData,                                         "vkSetPrivateData")
	set_proc_address(&PtrSetPrivateDataEXT,                                      "vkSetPrivateDataEXT")
	set_proc_address(&PtrSetSwapchainPresentTimingQueueSizeEXT,                  "vkSetSwapchainPresentTimingQueueSizeEXT")
	set_proc_address(&PtrSignalSemaphore,                                        "vkSignalSemaphore")
	set_proc_address(&PtrSignalSemaphoreKHR,                                     "vkSignalSemaphoreKHR")
	set_proc_address(&PtrTransitionImageLayout,                                  "vkTransitionImageLayout")
	set_proc_address(&PtrTransitionImageLayoutEXT,                               "vkTransitionImageLayoutEXT")
	set_proc_address(&PtrTrimCommandPool,                                        "vkTrimCommandPool")
	set_proc_address(&PtrTrimCommandPoolKHR,                                     "vkTrimCommandPoolKHR")
	set_proc_address(&PtrUninitializePerformanceApiINTEL,                        "vkUninitializePerformanceApiINTEL")
	set_proc_address(&PtrUnmapMemory,                                            "vkUnmapMemory")
	set_proc_address(&PtrUnmapMemory2,                                           "vkUnmapMemory2")
	set_proc_address(&PtrUnmapMemory2KHR,                                        "vkUnmapMemory2KHR")
	set_proc_address(&PtrUnregisterCustomBorderColorEXT,                         "vkUnregisterCustomBorderColorEXT")
	set_proc_address(&PtrUpdateDescriptorSetWithTemplate,                        "vkUpdateDescriptorSetWithTemplate")
	set_proc_address(&PtrUpdateDescriptorSetWithTemplateKHR,                     "vkUpdateDescriptorSetWithTemplateKHR")
	set_proc_address(&PtrUpdateDescriptorSets,                                   "vkUpdateDescriptorSets")
	set_proc_address(&PtrUpdateIndirectExecutionSetPipelineEXT,                  "vkUpdateIndirectExecutionSetPipelineEXT")
	set_proc_address(&PtrUpdateIndirectExecutionSetShaderEXT,                    "vkUpdateIndirectExecutionSetShaderEXT")
	set_proc_address(&PtrUpdateVideoSessionParametersKHR,                        "vkUpdateVideoSessionParametersKHR")
	set_proc_address(&PtrWaitForFences,                                          "vkWaitForFences")
	set_proc_address(&PtrWaitForPresent2KHR,                                     "vkWaitForPresent2KHR")
	set_proc_address(&PtrWaitForPresentKHR,                                      "vkWaitForPresentKHR")
	set_proc_address(&PtrWaitSemaphores,                                         "vkWaitSemaphores")
	set_proc_address(&PtrWaitSemaphoresKHR,                                      "vkWaitSemaphoresKHR")
	set_proc_address(&PtrWriteAccelerationStructuresPropertiesKHR,               "vkWriteAccelerationStructuresPropertiesKHR")
	set_proc_address(&PtrWriteMicromapsPropertiesEXT,                            "vkWriteMicromapsPropertiesEXT")
	set_proc_address(&PtrWriteResourceDescriptorsEXT,                            "vkWriteResourceDescriptorsEXT")
	set_proc_address(&PtrWriteSamplerDescriptorsEXT,                             "vkWriteSamplerDescriptorsEXT")

}

// Device Procedure VTable
Device_VTable :: struct {
	AcquireFullScreenExclusiveModeEXT:                      ProcAcquireFullScreenExclusiveModeEXT,
	AcquireNextImage2KHR:                                   ProcAcquireNextImage2KHR,
	AcquireNextImageKHR:                                    ProcAcquireNextImageKHR,
	AcquirePerformanceConfigurationINTEL:                   ProcAcquirePerformanceConfigurationINTEL,
	AcquireProfilingLockKHR:                                ProcAcquireProfilingLockKHR,
	AllocateCommandBuffers:                                 ProcAllocateCommandBuffers,
	AllocateDescriptorSets:                                 ProcAllocateDescriptorSets,
	AllocateMemory:                                         ProcAllocateMemory,
	AntiLagUpdateAMD:                                       ProcAntiLagUpdateAMD,
	BeginCommandBuffer:                                     ProcBeginCommandBuffer,
	BindAccelerationStructureMemoryNV:                      ProcBindAccelerationStructureMemoryNV,
	BindBufferMemory:                                       ProcBindBufferMemory,
	BindBufferMemory2:                                      ProcBindBufferMemory2,
	BindBufferMemory2KHR:                                   ProcBindBufferMemory2KHR,
	BindDataGraphPipelineSessionMemoryARM:                  ProcBindDataGraphPipelineSessionMemoryARM,
	BindImageMemory:                                        ProcBindImageMemory,
	BindImageMemory2:                                       ProcBindImageMemory2,
	BindImageMemory2KHR:                                    ProcBindImageMemory2KHR,
	BindOpticalFlowSessionImageNV:                          ProcBindOpticalFlowSessionImageNV,
	BindTensorMemoryARM:                                    ProcBindTensorMemoryARM,
	BindVideoSessionMemoryKHR:                              ProcBindVideoSessionMemoryKHR,
	BuildAccelerationStructuresKHR:                         ProcBuildAccelerationStructuresKHR,
	BuildMicromapsEXT:                                      ProcBuildMicromapsEXT,
	ClearShaderInstrumentationMetricsARM:                   ProcClearShaderInstrumentationMetricsARM,
	CmdBeginConditionalRendering2EXT:                       ProcCmdBeginConditionalRendering2EXT,
	CmdBeginConditionalRenderingEXT:                        ProcCmdBeginConditionalRenderingEXT,
	CmdBeginCustomResolveEXT:                               ProcCmdBeginCustomResolveEXT,
	CmdBeginDebugUtilsLabelEXT:                             ProcCmdBeginDebugUtilsLabelEXT,
	CmdBeginGpaSampleAMD:                                   ProcCmdBeginGpaSampleAMD,
	CmdBeginGpaSessionAMD:                                  ProcCmdBeginGpaSessionAMD,
	CmdBeginPerTileExecutionQCOM:                           ProcCmdBeginPerTileExecutionQCOM,
	CmdBeginQuery:                                          ProcCmdBeginQuery,
	CmdBeginQueryIndexedEXT:                                ProcCmdBeginQueryIndexedEXT,
	CmdBeginRenderPass:                                     ProcCmdBeginRenderPass,
	CmdBeginRenderPass2:                                    ProcCmdBeginRenderPass2,
	CmdBeginRenderPass2KHR:                                 ProcCmdBeginRenderPass2KHR,
	CmdBeginRendering:                                      ProcCmdBeginRendering,
	CmdBeginRenderingKHR:                                   ProcCmdBeginRenderingKHR,
	CmdBeginShaderInstrumentationARM:                       ProcCmdBeginShaderInstrumentationARM,
	CmdBeginTransformFeedback2EXT:                          ProcCmdBeginTransformFeedback2EXT,
	CmdBeginTransformFeedbackEXT:                           ProcCmdBeginTransformFeedbackEXT,
	CmdBeginVideoCodingKHR:                                 ProcCmdBeginVideoCodingKHR,
	CmdBindDescriptorBufferEmbeddedSamplers2EXT:            ProcCmdBindDescriptorBufferEmbeddedSamplers2EXT,
	CmdBindDescriptorBufferEmbeddedSamplersEXT:             ProcCmdBindDescriptorBufferEmbeddedSamplersEXT,
	CmdBindDescriptorBuffersEXT:                            ProcCmdBindDescriptorBuffersEXT,
	CmdBindDescriptorSets:                                  ProcCmdBindDescriptorSets,
	CmdBindDescriptorSets2:                                 ProcCmdBindDescriptorSets2,
	CmdBindDescriptorSets2KHR:                              ProcCmdBindDescriptorSets2KHR,
	CmdBindIndexBuffer:                                     ProcCmdBindIndexBuffer,
	CmdBindIndexBuffer2:                                    ProcCmdBindIndexBuffer2,
	CmdBindIndexBuffer2KHR:                                 ProcCmdBindIndexBuffer2KHR,
	CmdBindIndexBuffer3KHR:                                 ProcCmdBindIndexBuffer3KHR,
	CmdBindInvocationMaskHUAWEI:                            ProcCmdBindInvocationMaskHUAWEI,
	CmdBindPipeline:                                        ProcCmdBindPipeline,
	CmdBindPipelineShaderGroupNV:                           ProcCmdBindPipelineShaderGroupNV,
	CmdBindResourceHeapEXT:                                 ProcCmdBindResourceHeapEXT,
	CmdBindSamplerHeapEXT:                                  ProcCmdBindSamplerHeapEXT,
	CmdBindShadersEXT:                                      ProcCmdBindShadersEXT,
	CmdBindShadingRateImageNV:                              ProcCmdBindShadingRateImageNV,
	CmdBindTileMemoryQCOM:                                  ProcCmdBindTileMemoryQCOM,
	CmdBindTransformFeedbackBuffers2EXT:                    ProcCmdBindTransformFeedbackBuffers2EXT,
	CmdBindTransformFeedbackBuffersEXT:                     ProcCmdBindTransformFeedbackBuffersEXT,
	CmdBindVertexBuffers:                                   ProcCmdBindVertexBuffers,
	CmdBindVertexBuffers2:                                  ProcCmdBindVertexBuffers2,
	CmdBindVertexBuffers2EXT:                               ProcCmdBindVertexBuffers2EXT,
	CmdBindVertexBuffers3KHR:                               ProcCmdBindVertexBuffers3KHR,
	CmdBlitImage:                                           ProcCmdBlitImage,
	CmdBlitImage2:                                          ProcCmdBlitImage2,
	CmdBlitImage2KHR:                                       ProcCmdBlitImage2KHR,
	CmdBuildAccelerationStructureNV:                        ProcCmdBuildAccelerationStructureNV,
	CmdBuildAccelerationStructuresIndirectKHR:              ProcCmdBuildAccelerationStructuresIndirectKHR,
	CmdBuildAccelerationStructuresKHR:                      ProcCmdBuildAccelerationStructuresKHR,
	CmdBuildClusterAccelerationStructureIndirectNV:         ProcCmdBuildClusterAccelerationStructureIndirectNV,
	CmdBuildMicromapsEXT:                                   ProcCmdBuildMicromapsEXT,
	CmdBuildPartitionedAccelerationStructuresNV:            ProcCmdBuildPartitionedAccelerationStructuresNV,
	CmdClearAttachments:                                    ProcCmdClearAttachments,
	CmdClearColorImage:                                     ProcCmdClearColorImage,
	CmdClearDepthStencilImage:                              ProcCmdClearDepthStencilImage,
	CmdControlVideoCodingKHR:                               ProcCmdControlVideoCodingKHR,
	CmdConvertCooperativeVectorMatrixNV:                    ProcCmdConvertCooperativeVectorMatrixNV,
	CmdCopyAccelerationStructureKHR:                        ProcCmdCopyAccelerationStructureKHR,
	CmdCopyAccelerationStructureNV:                         ProcCmdCopyAccelerationStructureNV,
	CmdCopyAccelerationStructureToMemoryKHR:                ProcCmdCopyAccelerationStructureToMemoryKHR,
	CmdCopyBuffer:                                          ProcCmdCopyBuffer,
	CmdCopyBuffer2:                                         ProcCmdCopyBuffer2,
	CmdCopyBuffer2KHR:                                      ProcCmdCopyBuffer2KHR,
	CmdCopyBufferToImage:                                   ProcCmdCopyBufferToImage,
	CmdCopyBufferToImage2:                                  ProcCmdCopyBufferToImage2,
	CmdCopyBufferToImage2KHR:                               ProcCmdCopyBufferToImage2KHR,
	CmdCopyGpaSessionResultsAMD:                            ProcCmdCopyGpaSessionResultsAMD,
	CmdCopyImage:                                           ProcCmdCopyImage,
	CmdCopyImage2:                                          ProcCmdCopyImage2,
	CmdCopyImage2KHR:                                       ProcCmdCopyImage2KHR,
	CmdCopyImageToBuffer:                                   ProcCmdCopyImageToBuffer,
	CmdCopyImageToBuffer2:                                  ProcCmdCopyImageToBuffer2,
	CmdCopyImageToBuffer2KHR:                               ProcCmdCopyImageToBuffer2KHR,
	CmdCopyImageToMemoryKHR:                                ProcCmdCopyImageToMemoryKHR,
	CmdCopyMemoryIndirectKHR:                               ProcCmdCopyMemoryIndirectKHR,
	CmdCopyMemoryIndirectNV:                                ProcCmdCopyMemoryIndirectNV,
	CmdCopyMemoryKHR:                                       ProcCmdCopyMemoryKHR,
	CmdCopyMemoryToAccelerationStructureKHR:                ProcCmdCopyMemoryToAccelerationStructureKHR,
	CmdCopyMemoryToImageIndirectKHR:                        ProcCmdCopyMemoryToImageIndirectKHR,
	CmdCopyMemoryToImageIndirectNV:                         ProcCmdCopyMemoryToImageIndirectNV,
	CmdCopyMemoryToImageKHR:                                ProcCmdCopyMemoryToImageKHR,
	CmdCopyMemoryToMicromapEXT:                             ProcCmdCopyMemoryToMicromapEXT,
	CmdCopyMicromapEXT:                                     ProcCmdCopyMicromapEXT,
	CmdCopyMicromapToMemoryEXT:                             ProcCmdCopyMicromapToMemoryEXT,
	CmdCopyQueryPoolResults:                                ProcCmdCopyQueryPoolResults,
	CmdCopyQueryPoolResultsToMemoryKHR:                     ProcCmdCopyQueryPoolResultsToMemoryKHR,
	CmdCopyTensorARM:                                       ProcCmdCopyTensorARM,
	CmdCuLaunchKernelNVX:                                   ProcCmdCuLaunchKernelNVX,
	CmdCudaLaunchKernelNV:                                  ProcCmdCudaLaunchKernelNV,
	CmdDebugMarkerBeginEXT:                                 ProcCmdDebugMarkerBeginEXT,
	CmdDebugMarkerEndEXT:                                   ProcCmdDebugMarkerEndEXT,
	CmdDebugMarkerInsertEXT:                                ProcCmdDebugMarkerInsertEXT,
	CmdDecodeVideoKHR:                                      ProcCmdDecodeVideoKHR,
	CmdDecompressMemoryEXT:                                 ProcCmdDecompressMemoryEXT,
	CmdDecompressMemoryIndirectCountEXT:                    ProcCmdDecompressMemoryIndirectCountEXT,
	CmdDecompressMemoryIndirectCountNV:                     ProcCmdDecompressMemoryIndirectCountNV,
	CmdDecompressMemoryNV:                                  ProcCmdDecompressMemoryNV,
	CmdDispatch:                                            ProcCmdDispatch,
	CmdDispatchBase:                                        ProcCmdDispatchBase,
	CmdDispatchBaseKHR:                                     ProcCmdDispatchBaseKHR,
	CmdDispatchDataGraphARM:                                ProcCmdDispatchDataGraphARM,
	CmdDispatchGraphAMDX:                                   ProcCmdDispatchGraphAMDX,
	CmdDispatchGraphIndirectAMDX:                           ProcCmdDispatchGraphIndirectAMDX,
	CmdDispatchGraphIndirectCountAMDX:                      ProcCmdDispatchGraphIndirectCountAMDX,
	CmdDispatchIndirect:                                    ProcCmdDispatchIndirect,
	CmdDispatchIndirect2KHR:                                ProcCmdDispatchIndirect2KHR,
	CmdDispatchTileQCOM:                                    ProcCmdDispatchTileQCOM,
	CmdDraw:                                                ProcCmdDraw,
	CmdDrawClusterHUAWEI:                                   ProcCmdDrawClusterHUAWEI,
	CmdDrawClusterIndirectHUAWEI:                           ProcCmdDrawClusterIndirectHUAWEI,
	CmdDrawIndexed:                                         ProcCmdDrawIndexed,
	CmdDrawIndexedIndirect:                                 ProcCmdDrawIndexedIndirect,
	CmdDrawIndexedIndirect2KHR:                             ProcCmdDrawIndexedIndirect2KHR,
	CmdDrawIndexedIndirectCount:                            ProcCmdDrawIndexedIndirectCount,
	CmdDrawIndexedIndirectCount2KHR:                        ProcCmdDrawIndexedIndirectCount2KHR,
	CmdDrawIndexedIndirectCountAMD:                         ProcCmdDrawIndexedIndirectCountAMD,
	CmdDrawIndexedIndirectCountKHR:                         ProcCmdDrawIndexedIndirectCountKHR,
	CmdDrawIndirect:                                        ProcCmdDrawIndirect,
	CmdDrawIndirect2KHR:                                    ProcCmdDrawIndirect2KHR,
	CmdDrawIndirectByteCount2EXT:                           ProcCmdDrawIndirectByteCount2EXT,
	CmdDrawIndirectByteCountEXT:                            ProcCmdDrawIndirectByteCountEXT,
	CmdDrawIndirectCount:                                   ProcCmdDrawIndirectCount,
	CmdDrawIndirectCount2KHR:                               ProcCmdDrawIndirectCount2KHR,
	CmdDrawIndirectCountAMD:                                ProcCmdDrawIndirectCountAMD,
	CmdDrawIndirectCountKHR:                                ProcCmdDrawIndirectCountKHR,
	CmdDrawMeshTasksEXT:                                    ProcCmdDrawMeshTasksEXT,
	CmdDrawMeshTasksIndirect2EXT:                           ProcCmdDrawMeshTasksIndirect2EXT,
	CmdDrawMeshTasksIndirectCount2EXT:                      ProcCmdDrawMeshTasksIndirectCount2EXT,
	CmdDrawMeshTasksIndirectCountEXT:                       ProcCmdDrawMeshTasksIndirectCountEXT,
	CmdDrawMeshTasksIndirectCountNV:                        ProcCmdDrawMeshTasksIndirectCountNV,
	CmdDrawMeshTasksIndirectEXT:                            ProcCmdDrawMeshTasksIndirectEXT,
	CmdDrawMeshTasksIndirectNV:                             ProcCmdDrawMeshTasksIndirectNV,
	CmdDrawMeshTasksNV:                                     ProcCmdDrawMeshTasksNV,
	CmdDrawMultiEXT:                                        ProcCmdDrawMultiEXT,
	CmdDrawMultiIndexedEXT:                                 ProcCmdDrawMultiIndexedEXT,
	CmdEncodeVideoKHR:                                      ProcCmdEncodeVideoKHR,
	CmdEndConditionalRenderingEXT:                          ProcCmdEndConditionalRenderingEXT,
	CmdEndDebugUtilsLabelEXT:                               ProcCmdEndDebugUtilsLabelEXT,
	CmdEndGpaSampleAMD:                                     ProcCmdEndGpaSampleAMD,
	CmdEndGpaSessionAMD:                                    ProcCmdEndGpaSessionAMD,
	CmdEndPerTileExecutionQCOM:                             ProcCmdEndPerTileExecutionQCOM,
	CmdEndQuery:                                            ProcCmdEndQuery,
	CmdEndQueryIndexedEXT:                                  ProcCmdEndQueryIndexedEXT,
	CmdEndRenderPass:                                       ProcCmdEndRenderPass,
	CmdEndRenderPass2:                                      ProcCmdEndRenderPass2,
	CmdEndRenderPass2KHR:                                   ProcCmdEndRenderPass2KHR,
	CmdEndRendering:                                        ProcCmdEndRendering,
	CmdEndRendering2EXT:                                    ProcCmdEndRendering2EXT,
	CmdEndRendering2KHR:                                    ProcCmdEndRendering2KHR,
	CmdEndRenderingKHR:                                     ProcCmdEndRenderingKHR,
	CmdEndShaderInstrumentationARM:                         ProcCmdEndShaderInstrumentationARM,
	CmdEndTransformFeedback2EXT:                            ProcCmdEndTransformFeedback2EXT,
	CmdEndTransformFeedbackEXT:                             ProcCmdEndTransformFeedbackEXT,
	CmdEndVideoCodingKHR:                                   ProcCmdEndVideoCodingKHR,
	CmdExecuteCommands:                                     ProcCmdExecuteCommands,
	CmdExecuteGeneratedCommandsEXT:                         ProcCmdExecuteGeneratedCommandsEXT,
	CmdExecuteGeneratedCommandsNV:                          ProcCmdExecuteGeneratedCommandsNV,
	CmdFillBuffer:                                          ProcCmdFillBuffer,
	CmdFillMemoryKHR:                                       ProcCmdFillMemoryKHR,
	CmdInitializeGraphScratchMemoryAMDX:                    ProcCmdInitializeGraphScratchMemoryAMDX,
	CmdInsertDebugUtilsLabelEXT:                            ProcCmdInsertDebugUtilsLabelEXT,
	CmdNextSubpass:                                         ProcCmdNextSubpass,
	CmdNextSubpass2:                                        ProcCmdNextSubpass2,
	CmdNextSubpass2KHR:                                     ProcCmdNextSubpass2KHR,
	CmdOpticalFlowExecuteNV:                                ProcCmdOpticalFlowExecuteNV,
	CmdPipelineBarrier:                                     ProcCmdPipelineBarrier,
	CmdPipelineBarrier2:                                    ProcCmdPipelineBarrier2,
	CmdPipelineBarrier2KHR:                                 ProcCmdPipelineBarrier2KHR,
	CmdPreprocessGeneratedCommandsEXT:                      ProcCmdPreprocessGeneratedCommandsEXT,
	CmdPreprocessGeneratedCommandsNV:                       ProcCmdPreprocessGeneratedCommandsNV,
	CmdPushConstants:                                       ProcCmdPushConstants,
	CmdPushConstants2:                                      ProcCmdPushConstants2,
	CmdPushConstants2KHR:                                   ProcCmdPushConstants2KHR,
	CmdPushDataEXT:                                         ProcCmdPushDataEXT,
	CmdPushDescriptorSet:                                   ProcCmdPushDescriptorSet,
	CmdPushDescriptorSet2:                                  ProcCmdPushDescriptorSet2,
	CmdPushDescriptorSet2KHR:                               ProcCmdPushDescriptorSet2KHR,
	CmdPushDescriptorSetKHR:                                ProcCmdPushDescriptorSetKHR,
	CmdPushDescriptorSetWithTemplate:                       ProcCmdPushDescriptorSetWithTemplate,
	CmdPushDescriptorSetWithTemplate2:                      ProcCmdPushDescriptorSetWithTemplate2,
	CmdPushDescriptorSetWithTemplate2KHR:                   ProcCmdPushDescriptorSetWithTemplate2KHR,
	CmdPushDescriptorSetWithTemplateKHR:                    ProcCmdPushDescriptorSetWithTemplateKHR,
	CmdResetEvent:                                          ProcCmdResetEvent,
	CmdResetEvent2:                                         ProcCmdResetEvent2,
	CmdResetEvent2KHR:                                      ProcCmdResetEvent2KHR,
	CmdResetQueryPool:                                      ProcCmdResetQueryPool,
	CmdResolveImage:                                        ProcCmdResolveImage,
	CmdResolveImage2:                                       ProcCmdResolveImage2,
	CmdResolveImage2KHR:                                    ProcCmdResolveImage2KHR,
	CmdSetAlphaToCoverageEnableEXT:                         ProcCmdSetAlphaToCoverageEnableEXT,
	CmdSetAlphaToOneEnableEXT:                              ProcCmdSetAlphaToOneEnableEXT,
	CmdSetAttachmentFeedbackLoopEnableEXT:                  ProcCmdSetAttachmentFeedbackLoopEnableEXT,
	CmdSetBlendConstants:                                   ProcCmdSetBlendConstants,
	CmdSetCheckpointNV:                                     ProcCmdSetCheckpointNV,
	CmdSetCoarseSampleOrderNV:                              ProcCmdSetCoarseSampleOrderNV,
	CmdSetColorBlendAdvancedEXT:                            ProcCmdSetColorBlendAdvancedEXT,
	CmdSetColorBlendEnableEXT:                              ProcCmdSetColorBlendEnableEXT,
	CmdSetColorBlendEquationEXT:                            ProcCmdSetColorBlendEquationEXT,
	CmdSetColorWriteEnableEXT:                              ProcCmdSetColorWriteEnableEXT,
	CmdSetColorWriteMaskEXT:                                ProcCmdSetColorWriteMaskEXT,
	CmdSetComputeOccupancyPriorityNV:                       ProcCmdSetComputeOccupancyPriorityNV,
	CmdSetConservativeRasterizationModeEXT:                 ProcCmdSetConservativeRasterizationModeEXT,
	CmdSetCoverageModulationModeNV:                         ProcCmdSetCoverageModulationModeNV,
	CmdSetCoverageModulationTableEnableNV:                  ProcCmdSetCoverageModulationTableEnableNV,
	CmdSetCoverageModulationTableNV:                        ProcCmdSetCoverageModulationTableNV,
	CmdSetCoverageReductionModeNV:                          ProcCmdSetCoverageReductionModeNV,
	CmdSetCoverageToColorEnableNV:                          ProcCmdSetCoverageToColorEnableNV,
	CmdSetCoverageToColorLocationNV:                        ProcCmdSetCoverageToColorLocationNV,
	CmdSetCullMode:                                         ProcCmdSetCullMode,
	CmdSetCullModeEXT:                                      ProcCmdSetCullModeEXT,
	CmdSetDepthBias:                                        ProcCmdSetDepthBias,
	CmdSetDepthBias2EXT:                                    ProcCmdSetDepthBias2EXT,
	CmdSetDepthBiasEnable:                                  ProcCmdSetDepthBiasEnable,
	CmdSetDepthBiasEnableEXT:                               ProcCmdSetDepthBiasEnableEXT,
	CmdSetDepthBounds:                                      ProcCmdSetDepthBounds,
	CmdSetDepthBoundsTestEnable:                            ProcCmdSetDepthBoundsTestEnable,
	CmdSetDepthBoundsTestEnableEXT:                         ProcCmdSetDepthBoundsTestEnableEXT,
	CmdSetDepthClampEnableEXT:                              ProcCmdSetDepthClampEnableEXT,
	CmdSetDepthClampRangeEXT:                               ProcCmdSetDepthClampRangeEXT,
	CmdSetDepthClipEnableEXT:                               ProcCmdSetDepthClipEnableEXT,
	CmdSetDepthClipNegativeOneToOneEXT:                     ProcCmdSetDepthClipNegativeOneToOneEXT,
	CmdSetDepthCompareOp:                                   ProcCmdSetDepthCompareOp,
	CmdSetDepthCompareOpEXT:                                ProcCmdSetDepthCompareOpEXT,
	CmdSetDepthTestEnable:                                  ProcCmdSetDepthTestEnable,
	CmdSetDepthTestEnableEXT:                               ProcCmdSetDepthTestEnableEXT,
	CmdSetDepthWriteEnable:                                 ProcCmdSetDepthWriteEnable,
	CmdSetDepthWriteEnableEXT:                              ProcCmdSetDepthWriteEnableEXT,
	CmdSetDescriptorBufferOffsets2EXT:                      ProcCmdSetDescriptorBufferOffsets2EXT,
	CmdSetDescriptorBufferOffsetsEXT:                       ProcCmdSetDescriptorBufferOffsetsEXT,
	CmdSetDeviceMask:                                       ProcCmdSetDeviceMask,
	CmdSetDeviceMaskKHR:                                    ProcCmdSetDeviceMaskKHR,
	CmdSetDiscardRectangleEXT:                              ProcCmdSetDiscardRectangleEXT,
	CmdSetDiscardRectangleEnableEXT:                        ProcCmdSetDiscardRectangleEnableEXT,
	CmdSetDiscardRectangleModeEXT:                          ProcCmdSetDiscardRectangleModeEXT,
	CmdSetDispatchParametersARM:                            ProcCmdSetDispatchParametersARM,
	CmdSetEvent:                                            ProcCmdSetEvent,
	CmdSetEvent2:                                           ProcCmdSetEvent2,
	CmdSetEvent2KHR:                                        ProcCmdSetEvent2KHR,
	CmdSetExclusiveScissorEnableNV:                         ProcCmdSetExclusiveScissorEnableNV,
	CmdSetExclusiveScissorNV:                               ProcCmdSetExclusiveScissorNV,
	CmdSetExtraPrimitiveOverestimationSizeEXT:              ProcCmdSetExtraPrimitiveOverestimationSizeEXT,
	CmdSetFragmentShadingRateEnumNV:                        ProcCmdSetFragmentShadingRateEnumNV,
	CmdSetFragmentShadingRateKHR:                           ProcCmdSetFragmentShadingRateKHR,
	CmdSetFrontFace:                                        ProcCmdSetFrontFace,
	CmdSetFrontFaceEXT:                                     ProcCmdSetFrontFaceEXT,
	CmdSetLineRasterizationModeEXT:                         ProcCmdSetLineRasterizationModeEXT,
	CmdSetLineStipple:                                      ProcCmdSetLineStipple,
	CmdSetLineStippleEXT:                                   ProcCmdSetLineStippleEXT,
	CmdSetLineStippleEnableEXT:                             ProcCmdSetLineStippleEnableEXT,
	CmdSetLineStippleKHR:                                   ProcCmdSetLineStippleKHR,
	CmdSetLineWidth:                                        ProcCmdSetLineWidth,
	CmdSetLogicOpEXT:                                       ProcCmdSetLogicOpEXT,
	CmdSetLogicOpEnableEXT:                                 ProcCmdSetLogicOpEnableEXT,
	CmdSetPatchControlPointsEXT:                            ProcCmdSetPatchControlPointsEXT,
	CmdSetPerformanceMarkerINTEL:                           ProcCmdSetPerformanceMarkerINTEL,
	CmdSetPerformanceOverrideINTEL:                         ProcCmdSetPerformanceOverrideINTEL,
	CmdSetPerformanceStreamMarkerINTEL:                     ProcCmdSetPerformanceStreamMarkerINTEL,
	CmdSetPolygonModeEXT:                                   ProcCmdSetPolygonModeEXT,
	CmdSetPrimitiveRestartEnable:                           ProcCmdSetPrimitiveRestartEnable,
	CmdSetPrimitiveRestartEnableEXT:                        ProcCmdSetPrimitiveRestartEnableEXT,
	CmdSetPrimitiveRestartIndexEXT:                         ProcCmdSetPrimitiveRestartIndexEXT,
	CmdSetPrimitiveTopology:                                ProcCmdSetPrimitiveTopology,
	CmdSetPrimitiveTopologyEXT:                             ProcCmdSetPrimitiveTopologyEXT,
	CmdSetProvokingVertexModeEXT:                           ProcCmdSetProvokingVertexModeEXT,
	CmdSetRasterizationSamplesEXT:                          ProcCmdSetRasterizationSamplesEXT,
	CmdSetRasterizationStreamEXT:                           ProcCmdSetRasterizationStreamEXT,
	CmdSetRasterizerDiscardEnable:                          ProcCmdSetRasterizerDiscardEnable,
	CmdSetRasterizerDiscardEnableEXT:                       ProcCmdSetRasterizerDiscardEnableEXT,
	CmdSetRayTracingPipelineStackSizeKHR:                   ProcCmdSetRayTracingPipelineStackSizeKHR,
	CmdSetRenderingAttachmentLocations:                     ProcCmdSetRenderingAttachmentLocations,
	CmdSetRenderingAttachmentLocationsKHR:                  ProcCmdSetRenderingAttachmentLocationsKHR,
	CmdSetRenderingInputAttachmentIndices:                  ProcCmdSetRenderingInputAttachmentIndices,
	CmdSetRenderingInputAttachmentIndicesKHR:               ProcCmdSetRenderingInputAttachmentIndicesKHR,
	CmdSetRepresentativeFragmentTestEnableNV:               ProcCmdSetRepresentativeFragmentTestEnableNV,
	CmdSetSampleLocationsEXT:                               ProcCmdSetSampleLocationsEXT,
	CmdSetSampleLocationsEnableEXT:                         ProcCmdSetSampleLocationsEnableEXT,
	CmdSetSampleMaskEXT:                                    ProcCmdSetSampleMaskEXT,
	CmdSetScissor:                                          ProcCmdSetScissor,
	CmdSetScissorWithCount:                                 ProcCmdSetScissorWithCount,
	CmdSetScissorWithCountEXT:                              ProcCmdSetScissorWithCountEXT,
	CmdSetShadingRateImageEnableNV:                         ProcCmdSetShadingRateImageEnableNV,
	CmdSetStencilCompareMask:                               ProcCmdSetStencilCompareMask,
	CmdSetStencilOp:                                        ProcCmdSetStencilOp,
	CmdSetStencilOpEXT:                                     ProcCmdSetStencilOpEXT,
	CmdSetStencilReference:                                 ProcCmdSetStencilReference,
	CmdSetStencilTestEnable:                                ProcCmdSetStencilTestEnable,
	CmdSetStencilTestEnableEXT:                             ProcCmdSetStencilTestEnableEXT,
	CmdSetStencilWriteMask:                                 ProcCmdSetStencilWriteMask,
	CmdSetTessellationDomainOriginEXT:                      ProcCmdSetTessellationDomainOriginEXT,
	CmdSetVertexInputEXT:                                   ProcCmdSetVertexInputEXT,
	CmdSetViewport:                                         ProcCmdSetViewport,
	CmdSetViewportShadingRatePaletteNV:                     ProcCmdSetViewportShadingRatePaletteNV,
	CmdSetViewportSwizzleNV:                                ProcCmdSetViewportSwizzleNV,
	CmdSetViewportWScalingEnableNV:                         ProcCmdSetViewportWScalingEnableNV,
	CmdSetViewportWScalingNV:                               ProcCmdSetViewportWScalingNV,
	CmdSetViewportWithCount:                                ProcCmdSetViewportWithCount,
	CmdSetViewportWithCountEXT:                             ProcCmdSetViewportWithCountEXT,
	CmdSubpassShadingHUAWEI:                                ProcCmdSubpassShadingHUAWEI,
	CmdTraceRaysIndirect2KHR:                               ProcCmdTraceRaysIndirect2KHR,
	CmdTraceRaysIndirectKHR:                                ProcCmdTraceRaysIndirectKHR,
	CmdTraceRaysKHR:                                        ProcCmdTraceRaysKHR,
	CmdTraceRaysNV:                                         ProcCmdTraceRaysNV,
	CmdUpdateBuffer:                                        ProcCmdUpdateBuffer,
	CmdUpdateMemoryKHR:                                     ProcCmdUpdateMemoryKHR,
	CmdUpdatePipelineIndirectBufferNV:                      ProcCmdUpdatePipelineIndirectBufferNV,
	CmdWaitEvents:                                          ProcCmdWaitEvents,
	CmdWaitEvents2:                                         ProcCmdWaitEvents2,
	CmdWaitEvents2KHR:                                      ProcCmdWaitEvents2KHR,
	CmdWriteAccelerationStructuresPropertiesKHR:            ProcCmdWriteAccelerationStructuresPropertiesKHR,
	CmdWriteAccelerationStructuresPropertiesNV:             ProcCmdWriteAccelerationStructuresPropertiesNV,
	CmdWriteBufferMarker2AMD:                               ProcCmdWriteBufferMarker2AMD,
	CmdWriteBufferMarkerAMD:                                ProcCmdWriteBufferMarkerAMD,
	CmdWriteMarkerToMemoryAMD:                              ProcCmdWriteMarkerToMemoryAMD,
	CmdWriteMicromapsPropertiesEXT:                         ProcCmdWriteMicromapsPropertiesEXT,
	CmdWriteTimestamp:                                      ProcCmdWriteTimestamp,
	CmdWriteTimestamp2:                                     ProcCmdWriteTimestamp2,
	CmdWriteTimestamp2KHR:                                  ProcCmdWriteTimestamp2KHR,
	CompileDeferredNV:                                      ProcCompileDeferredNV,
	ConvertCooperativeVectorMatrixNV:                       ProcConvertCooperativeVectorMatrixNV,
	CopyAccelerationStructureKHR:                           ProcCopyAccelerationStructureKHR,
	CopyAccelerationStructureToMemoryKHR:                   ProcCopyAccelerationStructureToMemoryKHR,
	CopyImageToImage:                                       ProcCopyImageToImage,
	CopyImageToImageEXT:                                    ProcCopyImageToImageEXT,
	CopyImageToMemory:                                      ProcCopyImageToMemory,
	CopyImageToMemoryEXT:                                   ProcCopyImageToMemoryEXT,
	CopyMemoryToAccelerationStructureKHR:                   ProcCopyMemoryToAccelerationStructureKHR,
	CopyMemoryToImage:                                      ProcCopyMemoryToImage,
	CopyMemoryToImageEXT:                                   ProcCopyMemoryToImageEXT,
	CopyMemoryToMicromapEXT:                                ProcCopyMemoryToMicromapEXT,
	CopyMicromapEXT:                                        ProcCopyMicromapEXT,
	CopyMicromapToMemoryEXT:                                ProcCopyMicromapToMemoryEXT,
	CreateAccelerationStructure2KHR:                        ProcCreateAccelerationStructure2KHR,
	CreateAccelerationStructureKHR:                         ProcCreateAccelerationStructureKHR,
	CreateAccelerationStructureNV:                          ProcCreateAccelerationStructureNV,
	CreateBuffer:                                           ProcCreateBuffer,
	CreateBufferView:                                       ProcCreateBufferView,
	CreateCommandPool:                                      ProcCreateCommandPool,
	CreateComputePipelines:                                 ProcCreateComputePipelines,
	CreateCuFunctionNVX:                                    ProcCreateCuFunctionNVX,
	CreateCuModuleNVX:                                      ProcCreateCuModuleNVX,
	CreateCudaFunctionNV:                                   ProcCreateCudaFunctionNV,
	CreateCudaModuleNV:                                     ProcCreateCudaModuleNV,
	CreateDataGraphPipelineSessionARM:                      ProcCreateDataGraphPipelineSessionARM,
	CreateDataGraphPipelinesARM:                            ProcCreateDataGraphPipelinesARM,
	CreateDeferredOperationKHR:                             ProcCreateDeferredOperationKHR,
	CreateDescriptorPool:                                   ProcCreateDescriptorPool,
	CreateDescriptorSetLayout:                              ProcCreateDescriptorSetLayout,
	CreateDescriptorUpdateTemplate:                         ProcCreateDescriptorUpdateTemplate,
	CreateDescriptorUpdateTemplateKHR:                      ProcCreateDescriptorUpdateTemplateKHR,
	CreateEvent:                                            ProcCreateEvent,
	CreateExecutionGraphPipelinesAMDX:                      ProcCreateExecutionGraphPipelinesAMDX,
	CreateExternalComputeQueueNV:                           ProcCreateExternalComputeQueueNV,
	CreateFence:                                            ProcCreateFence,
	CreateFramebuffer:                                      ProcCreateFramebuffer,
	CreateGpaSessionAMD:                                    ProcCreateGpaSessionAMD,
	CreateGraphicsPipelines:                                ProcCreateGraphicsPipelines,
	CreateImage:                                            ProcCreateImage,
	CreateImageView:                                        ProcCreateImageView,
	CreateIndirectCommandsLayoutEXT:                        ProcCreateIndirectCommandsLayoutEXT,
	CreateIndirectCommandsLayoutNV:                         ProcCreateIndirectCommandsLayoutNV,
	CreateIndirectExecutionSetEXT:                          ProcCreateIndirectExecutionSetEXT,
	CreateMicromapEXT:                                      ProcCreateMicromapEXT,
	CreateOpticalFlowSessionNV:                             ProcCreateOpticalFlowSessionNV,
	CreatePipelineBinariesKHR:                              ProcCreatePipelineBinariesKHR,
	CreatePipelineCache:                                    ProcCreatePipelineCache,
	CreatePipelineLayout:                                   ProcCreatePipelineLayout,
	CreatePrivateDataSlot:                                  ProcCreatePrivateDataSlot,
	CreatePrivateDataSlotEXT:                               ProcCreatePrivateDataSlotEXT,
	CreateQueryPool:                                        ProcCreateQueryPool,
	CreateRayTracingPipelinesKHR:                           ProcCreateRayTracingPipelinesKHR,
	CreateRayTracingPipelinesNV:                            ProcCreateRayTracingPipelinesNV,
	CreateRenderPass:                                       ProcCreateRenderPass,
	CreateRenderPass2:                                      ProcCreateRenderPass2,
	CreateRenderPass2KHR:                                   ProcCreateRenderPass2KHR,
	CreateSampler:                                          ProcCreateSampler,
	CreateSamplerYcbcrConversion:                           ProcCreateSamplerYcbcrConversion,
	CreateSamplerYcbcrConversionKHR:                        ProcCreateSamplerYcbcrConversionKHR,
	CreateSemaphore:                                        ProcCreateSemaphore,
	CreateShaderInstrumentationARM:                         ProcCreateShaderInstrumentationARM,
	CreateShaderModule:                                     ProcCreateShaderModule,
	CreateShadersEXT:                                       ProcCreateShadersEXT,
	CreateSharedSwapchainsKHR:                              ProcCreateSharedSwapchainsKHR,
	CreateSwapchainKHR:                                     ProcCreateSwapchainKHR,
	CreateTensorARM:                                        ProcCreateTensorARM,
	CreateTensorViewARM:                                    ProcCreateTensorViewARM,
	CreateValidationCacheEXT:                               ProcCreateValidationCacheEXT,
	CreateVideoSessionKHR:                                  ProcCreateVideoSessionKHR,
	CreateVideoSessionParametersKHR:                        ProcCreateVideoSessionParametersKHR,
	DebugMarkerSetObjectNameEXT:                            ProcDebugMarkerSetObjectNameEXT,
	DebugMarkerSetObjectTagEXT:                             ProcDebugMarkerSetObjectTagEXT,
	DeferredOperationJoinKHR:                               ProcDeferredOperationJoinKHR,
	DestroyAccelerationStructureKHR:                        ProcDestroyAccelerationStructureKHR,
	DestroyAccelerationStructureNV:                         ProcDestroyAccelerationStructureNV,
	DestroyBuffer:                                          ProcDestroyBuffer,
	DestroyBufferView:                                      ProcDestroyBufferView,
	DestroyCommandPool:                                     ProcDestroyCommandPool,
	DestroyCuFunctionNVX:                                   ProcDestroyCuFunctionNVX,
	DestroyCuModuleNVX:                                     ProcDestroyCuModuleNVX,
	DestroyCudaFunctionNV:                                  ProcDestroyCudaFunctionNV,
	DestroyCudaModuleNV:                                    ProcDestroyCudaModuleNV,
	DestroyDataGraphPipelineSessionARM:                     ProcDestroyDataGraphPipelineSessionARM,
	DestroyDeferredOperationKHR:                            ProcDestroyDeferredOperationKHR,
	DestroyDescriptorPool:                                  ProcDestroyDescriptorPool,
	DestroyDescriptorSetLayout:                             ProcDestroyDescriptorSetLayout,
	DestroyDescriptorUpdateTemplate:                        ProcDestroyDescriptorUpdateTemplate,
	DestroyDescriptorUpdateTemplateKHR:                     ProcDestroyDescriptorUpdateTemplateKHR,
	DestroyDevice:                                          ProcDestroyDevice,
	DestroyEvent:                                           ProcDestroyEvent,
	DestroyExternalComputeQueueNV:                          ProcDestroyExternalComputeQueueNV,
	DestroyFence:                                           ProcDestroyFence,
	DestroyFramebuffer:                                     ProcDestroyFramebuffer,
	DestroyGpaSessionAMD:                                   ProcDestroyGpaSessionAMD,
	DestroyImage:                                           ProcDestroyImage,
	DestroyImageView:                                       ProcDestroyImageView,
	DestroyIndirectCommandsLayoutEXT:                       ProcDestroyIndirectCommandsLayoutEXT,
	DestroyIndirectCommandsLayoutNV:                        ProcDestroyIndirectCommandsLayoutNV,
	DestroyIndirectExecutionSetEXT:                         ProcDestroyIndirectExecutionSetEXT,
	DestroyMicromapEXT:                                     ProcDestroyMicromapEXT,
	DestroyOpticalFlowSessionNV:                            ProcDestroyOpticalFlowSessionNV,
	DestroyPipeline:                                        ProcDestroyPipeline,
	DestroyPipelineBinaryKHR:                               ProcDestroyPipelineBinaryKHR,
	DestroyPipelineCache:                                   ProcDestroyPipelineCache,
	DestroyPipelineLayout:                                  ProcDestroyPipelineLayout,
	DestroyPrivateDataSlot:                                 ProcDestroyPrivateDataSlot,
	DestroyPrivateDataSlotEXT:                              ProcDestroyPrivateDataSlotEXT,
	DestroyQueryPool:                                       ProcDestroyQueryPool,
	DestroyRenderPass:                                      ProcDestroyRenderPass,
	DestroySampler:                                         ProcDestroySampler,
	DestroySamplerYcbcrConversion:                          ProcDestroySamplerYcbcrConversion,
	DestroySamplerYcbcrConversionKHR:                       ProcDestroySamplerYcbcrConversionKHR,
	DestroySemaphore:                                       ProcDestroySemaphore,
	DestroyShaderEXT:                                       ProcDestroyShaderEXT,
	DestroyShaderInstrumentationARM:                        ProcDestroyShaderInstrumentationARM,
	DestroyShaderModule:                                    ProcDestroyShaderModule,
	DestroySwapchainKHR:                                    ProcDestroySwapchainKHR,
	DestroyTensorARM:                                       ProcDestroyTensorARM,
	DestroyTensorViewARM:                                   ProcDestroyTensorViewARM,
	DestroyValidationCacheEXT:                              ProcDestroyValidationCacheEXT,
	DestroyVideoSessionKHR:                                 ProcDestroyVideoSessionKHR,
	DestroyVideoSessionParametersKHR:                       ProcDestroyVideoSessionParametersKHR,
	DeviceWaitIdle:                                         ProcDeviceWaitIdle,
	DisplayPowerControlEXT:                                 ProcDisplayPowerControlEXT,
	EndCommandBuffer:                                       ProcEndCommandBuffer,
	ExportMetalObjectsEXT:                                  ProcExportMetalObjectsEXT,
	FlushMappedMemoryRanges:                                ProcFlushMappedMemoryRanges,
	FreeCommandBuffers:                                     ProcFreeCommandBuffers,
	FreeDescriptorSets:                                     ProcFreeDescriptorSets,
	FreeMemory:                                             ProcFreeMemory,
	GetAccelerationStructureBuildSizesKHR:                  ProcGetAccelerationStructureBuildSizesKHR,
	GetAccelerationStructureDeviceAddressKHR:               ProcGetAccelerationStructureDeviceAddressKHR,
	GetAccelerationStructureHandleNV:                       ProcGetAccelerationStructureHandleNV,
	GetAccelerationStructureMemoryRequirementsNV:           ProcGetAccelerationStructureMemoryRequirementsNV,
	GetAccelerationStructureOpaqueCaptureDescriptorDataEXT: ProcGetAccelerationStructureOpaqueCaptureDescriptorDataEXT,
	GetAndroidHardwareBufferPropertiesANDROID:              ProcGetAndroidHardwareBufferPropertiesANDROID,
	GetBufferDeviceAddress:                                 ProcGetBufferDeviceAddress,
	GetBufferDeviceAddressEXT:                              ProcGetBufferDeviceAddressEXT,
	GetBufferDeviceAddressKHR:                              ProcGetBufferDeviceAddressKHR,
	GetBufferMemoryRequirements:                            ProcGetBufferMemoryRequirements,
	GetBufferMemoryRequirements2:                           ProcGetBufferMemoryRequirements2,
	GetBufferMemoryRequirements2KHR:                        ProcGetBufferMemoryRequirements2KHR,
	GetBufferOpaqueCaptureAddress:                          ProcGetBufferOpaqueCaptureAddress,
	GetBufferOpaqueCaptureAddressKHR:                       ProcGetBufferOpaqueCaptureAddressKHR,
	GetBufferOpaqueCaptureDescriptorDataEXT:                ProcGetBufferOpaqueCaptureDescriptorDataEXT,
	GetCalibratedTimestampsEXT:                             ProcGetCalibratedTimestampsEXT,
	GetCalibratedTimestampsKHR:                             ProcGetCalibratedTimestampsKHR,
	GetClusterAccelerationStructureBuildSizesNV:            ProcGetClusterAccelerationStructureBuildSizesNV,
	GetCudaModuleCacheNV:                                   ProcGetCudaModuleCacheNV,
	GetDataGraphPipelineAvailablePropertiesARM:             ProcGetDataGraphPipelineAvailablePropertiesARM,
	GetDataGraphPipelinePropertiesARM:                      ProcGetDataGraphPipelinePropertiesARM,
	GetDataGraphPipelineSessionBindPointRequirementsARM:    ProcGetDataGraphPipelineSessionBindPointRequirementsARM,
	GetDataGraphPipelineSessionMemoryRequirementsARM:       ProcGetDataGraphPipelineSessionMemoryRequirementsARM,
	GetDeferredOperationMaxConcurrencyKHR:                  ProcGetDeferredOperationMaxConcurrencyKHR,
	GetDeferredOperationResultKHR:                          ProcGetDeferredOperationResultKHR,
	GetDescriptorEXT:                                       ProcGetDescriptorEXT,
	GetDescriptorSetHostMappingVALVE:                       ProcGetDescriptorSetHostMappingVALVE,
	GetDescriptorSetLayoutBindingOffsetEXT:                 ProcGetDescriptorSetLayoutBindingOffsetEXT,
	GetDescriptorSetLayoutHostMappingInfoVALVE:             ProcGetDescriptorSetLayoutHostMappingInfoVALVE,
	GetDescriptorSetLayoutSizeEXT:                          ProcGetDescriptorSetLayoutSizeEXT,
	GetDescriptorSetLayoutSupport:                          ProcGetDescriptorSetLayoutSupport,
	GetDescriptorSetLayoutSupportKHR:                       ProcGetDescriptorSetLayoutSupportKHR,
	GetDeviceAccelerationStructureCompatibilityKHR:         ProcGetDeviceAccelerationStructureCompatibilityKHR,
	GetDeviceBufferMemoryRequirements:                      ProcGetDeviceBufferMemoryRequirements,
	GetDeviceBufferMemoryRequirementsKHR:                   ProcGetDeviceBufferMemoryRequirementsKHR,
	GetDeviceCombinedImageSamplerIndexNVX:                  ProcGetDeviceCombinedImageSamplerIndexNVX,
	GetDeviceFaultDebugInfoKHR:                             ProcGetDeviceFaultDebugInfoKHR,
	GetDeviceFaultInfoEXT:                                  ProcGetDeviceFaultInfoEXT,
	GetDeviceFaultReportsKHR:                               ProcGetDeviceFaultReportsKHR,
	GetDeviceGroupPeerMemoryFeatures:                       ProcGetDeviceGroupPeerMemoryFeatures,
	GetDeviceGroupPeerMemoryFeaturesKHR:                    ProcGetDeviceGroupPeerMemoryFeaturesKHR,
	GetDeviceGroupPresentCapabilitiesKHR:                   ProcGetDeviceGroupPresentCapabilitiesKHR,
	GetDeviceGroupSurfacePresentModes2EXT:                  ProcGetDeviceGroupSurfacePresentModes2EXT,
	GetDeviceGroupSurfacePresentModesKHR:                   ProcGetDeviceGroupSurfacePresentModesKHR,
	GetDeviceImageMemoryRequirements:                       ProcGetDeviceImageMemoryRequirements,
	GetDeviceImageMemoryRequirementsKHR:                    ProcGetDeviceImageMemoryRequirementsKHR,
	GetDeviceImageSparseMemoryRequirements:                 ProcGetDeviceImageSparseMemoryRequirements,
	GetDeviceImageSparseMemoryRequirementsKHR:              ProcGetDeviceImageSparseMemoryRequirementsKHR,
	GetDeviceImageSubresourceLayout:                        ProcGetDeviceImageSubresourceLayout,
	GetDeviceImageSubresourceLayoutKHR:                     ProcGetDeviceImageSubresourceLayoutKHR,
	GetDeviceMemoryCommitment:                              ProcGetDeviceMemoryCommitment,
	GetDeviceMemoryOpaqueCaptureAddress:                    ProcGetDeviceMemoryOpaqueCaptureAddress,
	GetDeviceMemoryOpaqueCaptureAddressKHR:                 ProcGetDeviceMemoryOpaqueCaptureAddressKHR,
	GetDeviceMicromapCompatibilityEXT:                      ProcGetDeviceMicromapCompatibilityEXT,
	GetDeviceProcAddr:                                      ProcGetDeviceProcAddr,
	GetDeviceQueue:                                         ProcGetDeviceQueue,
	GetDeviceQueue2:                                        ProcGetDeviceQueue2,
	GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI:          ProcGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI,
	GetDeviceTensorMemoryRequirementsARM:                   ProcGetDeviceTensorMemoryRequirementsARM,
	GetDynamicRenderingTilePropertiesQCOM:                  ProcGetDynamicRenderingTilePropertiesQCOM,
	GetEncodedVideoSessionParametersKHR:                    ProcGetEncodedVideoSessionParametersKHR,
	GetEventStatus:                                         ProcGetEventStatus,
	GetExecutionGraphPipelineNodeIndexAMDX:                 ProcGetExecutionGraphPipelineNodeIndexAMDX,
	GetExecutionGraphPipelineScratchSizeAMDX:               ProcGetExecutionGraphPipelineScratchSizeAMDX,
	GetFenceFdKHR:                                          ProcGetFenceFdKHR,
	GetFenceStatus:                                         ProcGetFenceStatus,
	GetFenceWin32HandleKHR:                                 ProcGetFenceWin32HandleKHR,
	GetFramebufferTilePropertiesQCOM:                       ProcGetFramebufferTilePropertiesQCOM,
	GetGeneratedCommandsMemoryRequirementsEXT:              ProcGetGeneratedCommandsMemoryRequirementsEXT,
	GetGeneratedCommandsMemoryRequirementsNV:               ProcGetGeneratedCommandsMemoryRequirementsNV,
	GetGpaDeviceClockInfoAMD:                               ProcGetGpaDeviceClockInfoAMD,
	GetGpaSessionResultsAMD:                                ProcGetGpaSessionResultsAMD,
	GetGpaSessionStatusAMD:                                 ProcGetGpaSessionStatusAMD,
	GetImageDrmFormatModifierPropertiesEXT:                 ProcGetImageDrmFormatModifierPropertiesEXT,
	GetImageMemoryRequirements:                             ProcGetImageMemoryRequirements,
	GetImageMemoryRequirements2:                            ProcGetImageMemoryRequirements2,
	GetImageMemoryRequirements2KHR:                         ProcGetImageMemoryRequirements2KHR,
	GetImageOpaqueCaptureDataEXT:                           ProcGetImageOpaqueCaptureDataEXT,
	GetImageOpaqueCaptureDescriptorDataEXT:                 ProcGetImageOpaqueCaptureDescriptorDataEXT,
	GetImageSparseMemoryRequirements:                       ProcGetImageSparseMemoryRequirements,
	GetImageSparseMemoryRequirements2:                      ProcGetImageSparseMemoryRequirements2,
	GetImageSparseMemoryRequirements2KHR:                   ProcGetImageSparseMemoryRequirements2KHR,
	GetImageSubresourceLayout:                              ProcGetImageSubresourceLayout,
	GetImageSubresourceLayout2:                             ProcGetImageSubresourceLayout2,
	GetImageSubresourceLayout2EXT:                          ProcGetImageSubresourceLayout2EXT,
	GetImageSubresourceLayout2KHR:                          ProcGetImageSubresourceLayout2KHR,
	GetImageViewAddressNVX:                                 ProcGetImageViewAddressNVX,
	GetImageViewHandle64NVX:                                ProcGetImageViewHandle64NVX,
	GetImageViewHandleNVX:                                  ProcGetImageViewHandleNVX,
	GetImageViewOpaqueCaptureDescriptorDataEXT:             ProcGetImageViewOpaqueCaptureDescriptorDataEXT,
	GetLatencyTimingsNV:                                    ProcGetLatencyTimingsNV,
	GetMemoryAndroidHardwareBufferANDROID:                  ProcGetMemoryAndroidHardwareBufferANDROID,
	GetMemoryFdKHR:                                         ProcGetMemoryFdKHR,
	GetMemoryFdPropertiesKHR:                               ProcGetMemoryFdPropertiesKHR,
	GetMemoryHostPointerPropertiesEXT:                      ProcGetMemoryHostPointerPropertiesEXT,
	GetMemoryMetalHandleEXT:                                ProcGetMemoryMetalHandleEXT,
	GetMemoryMetalHandlePropertiesEXT:                      ProcGetMemoryMetalHandlePropertiesEXT,
	GetMemoryRemoteAddressNV:                               ProcGetMemoryRemoteAddressNV,
	GetMemoryWin32HandleKHR:                                ProcGetMemoryWin32HandleKHR,
	GetMemoryWin32HandleNV:                                 ProcGetMemoryWin32HandleNV,
	GetMemoryWin32HandlePropertiesKHR:                      ProcGetMemoryWin32HandlePropertiesKHR,
	GetMicromapBuildSizesEXT:                               ProcGetMicromapBuildSizesEXT,
	GetPartitionedAccelerationStructuresBuildSizesNV:       ProcGetPartitionedAccelerationStructuresBuildSizesNV,
	GetPastPresentationTimingEXT:                           ProcGetPastPresentationTimingEXT,
	GetPastPresentationTimingGOOGLE:                        ProcGetPastPresentationTimingGOOGLE,
	GetPerformanceParameterINTEL:                           ProcGetPerformanceParameterINTEL,
	GetPipelineBinaryDataKHR:                               ProcGetPipelineBinaryDataKHR,
	GetPipelineCacheData:                                   ProcGetPipelineCacheData,
	GetPipelineExecutableInternalRepresentationsKHR:        ProcGetPipelineExecutableInternalRepresentationsKHR,
	GetPipelineExecutablePropertiesKHR:                     ProcGetPipelineExecutablePropertiesKHR,
	GetPipelineExecutableStatisticsKHR:                     ProcGetPipelineExecutableStatisticsKHR,
	GetPipelineIndirectDeviceAddressNV:                     ProcGetPipelineIndirectDeviceAddressNV,
	GetPipelineIndirectMemoryRequirementsNV:                ProcGetPipelineIndirectMemoryRequirementsNV,
	GetPipelineKeyKHR:                                      ProcGetPipelineKeyKHR,
	GetPipelinePropertiesEXT:                               ProcGetPipelinePropertiesEXT,
	GetPrivateData:                                         ProcGetPrivateData,
	GetPrivateDataEXT:                                      ProcGetPrivateDataEXT,
	GetQueryPoolResults:                                    ProcGetQueryPoolResults,
	GetQueueCheckpointData2NV:                              ProcGetQueueCheckpointData2NV,
	GetQueueCheckpointDataNV:                               ProcGetQueueCheckpointDataNV,
	GetRayTracingCaptureReplayShaderGroupHandlesKHR:        ProcGetRayTracingCaptureReplayShaderGroupHandlesKHR,
	GetRayTracingShaderGroupHandlesKHR:                     ProcGetRayTracingShaderGroupHandlesKHR,
	GetRayTracingShaderGroupHandlesNV:                      ProcGetRayTracingShaderGroupHandlesNV,
	GetRayTracingShaderGroupStackSizeKHR:                   ProcGetRayTracingShaderGroupStackSizeKHR,
	GetRefreshCycleDurationGOOGLE:                          ProcGetRefreshCycleDurationGOOGLE,
	GetRenderAreaGranularity:                               ProcGetRenderAreaGranularity,
	GetRenderingAreaGranularity:                            ProcGetRenderingAreaGranularity,
	GetRenderingAreaGranularityKHR:                         ProcGetRenderingAreaGranularityKHR,
	GetSamplerOpaqueCaptureDescriptorDataEXT:               ProcGetSamplerOpaqueCaptureDescriptorDataEXT,
	GetSemaphoreCounterValue:                               ProcGetSemaphoreCounterValue,
	GetSemaphoreCounterValueKHR:                            ProcGetSemaphoreCounterValueKHR,
	GetSemaphoreFdKHR:                                      ProcGetSemaphoreFdKHR,
	GetSemaphoreWin32HandleKHR:                             ProcGetSemaphoreWin32HandleKHR,
	GetShaderBinaryDataEXT:                                 ProcGetShaderBinaryDataEXT,
	GetShaderInfoAMD:                                       ProcGetShaderInfoAMD,
	GetShaderInstrumentationValuesARM:                      ProcGetShaderInstrumentationValuesARM,
	GetShaderModuleCreateInfoIdentifierEXT:                 ProcGetShaderModuleCreateInfoIdentifierEXT,
	GetShaderModuleIdentifierEXT:                           ProcGetShaderModuleIdentifierEXT,
	GetSwapchainCounterEXT:                                 ProcGetSwapchainCounterEXT,
	GetSwapchainImagesKHR:                                  ProcGetSwapchainImagesKHR,
	GetSwapchainStatusKHR:                                  ProcGetSwapchainStatusKHR,
	GetSwapchainTimeDomainPropertiesEXT:                    ProcGetSwapchainTimeDomainPropertiesEXT,
	GetSwapchainTimingPropertiesEXT:                        ProcGetSwapchainTimingPropertiesEXT,
	GetTensorMemoryRequirementsARM:                         ProcGetTensorMemoryRequirementsARM,
	GetTensorOpaqueCaptureDataARM:                          ProcGetTensorOpaqueCaptureDataARM,
	GetTensorOpaqueCaptureDescriptorDataARM:                ProcGetTensorOpaqueCaptureDescriptorDataARM,
	GetTensorViewOpaqueCaptureDescriptorDataARM:            ProcGetTensorViewOpaqueCaptureDescriptorDataARM,
	GetValidationCacheDataEXT:                              ProcGetValidationCacheDataEXT,
	GetVideoSessionMemoryRequirementsKHR:                   ProcGetVideoSessionMemoryRequirementsKHR,
	ImportFenceFdKHR:                                       ProcImportFenceFdKHR,
	ImportFenceWin32HandleKHR:                              ProcImportFenceWin32HandleKHR,
	ImportSemaphoreFdKHR:                                   ProcImportSemaphoreFdKHR,
	ImportSemaphoreWin32HandleKHR:                          ProcImportSemaphoreWin32HandleKHR,
	InitializePerformanceApiINTEL:                          ProcInitializePerformanceApiINTEL,
	InvalidateMappedMemoryRanges:                           ProcInvalidateMappedMemoryRanges,
	LatencySleepNV:                                         ProcLatencySleepNV,
	MapMemory:                                              ProcMapMemory,
	MapMemory2:                                             ProcMapMemory2,
	MapMemory2KHR:                                          ProcMapMemory2KHR,
	MergePipelineCaches:                                    ProcMergePipelineCaches,
	MergeValidationCachesEXT:                               ProcMergeValidationCachesEXT,
	QueueBeginDebugUtilsLabelEXT:                           ProcQueueBeginDebugUtilsLabelEXT,
	QueueBindSparse:                                        ProcQueueBindSparse,
	QueueEndDebugUtilsLabelEXT:                             ProcQueueEndDebugUtilsLabelEXT,
	QueueInsertDebugUtilsLabelEXT:                          ProcQueueInsertDebugUtilsLabelEXT,
	QueueNotifyOutOfBandNV:                                 ProcQueueNotifyOutOfBandNV,
	QueuePresentKHR:                                        ProcQueuePresentKHR,
	QueueSetPerformanceConfigurationINTEL:                  ProcQueueSetPerformanceConfigurationINTEL,
	QueueSubmit:                                            ProcQueueSubmit,
	QueueSubmit2:                                           ProcQueueSubmit2,
	QueueSubmit2KHR:                                        ProcQueueSubmit2KHR,
	QueueWaitIdle:                                          ProcQueueWaitIdle,
	RegisterCustomBorderColorEXT:                           ProcRegisterCustomBorderColorEXT,
	RegisterDeviceEventEXT:                                 ProcRegisterDeviceEventEXT,
	RegisterDisplayEventEXT:                                ProcRegisterDisplayEventEXT,
	ReleaseCapturedPipelineDataKHR:                         ProcReleaseCapturedPipelineDataKHR,
	ReleaseFullScreenExclusiveModeEXT:                      ProcReleaseFullScreenExclusiveModeEXT,
	ReleasePerformanceConfigurationINTEL:                   ProcReleasePerformanceConfigurationINTEL,
	ReleaseProfilingLockKHR:                                ProcReleaseProfilingLockKHR,
	ReleaseSwapchainImagesEXT:                              ProcReleaseSwapchainImagesEXT,
	ReleaseSwapchainImagesKHR:                              ProcReleaseSwapchainImagesKHR,
	ResetCommandBuffer:                                     ProcResetCommandBuffer,
	ResetCommandPool:                                       ProcResetCommandPool,
	ResetDescriptorPool:                                    ProcResetDescriptorPool,
	ResetEvent:                                             ProcResetEvent,
	ResetFences:                                            ProcResetFences,
	ResetGpaSessionAMD:                                     ProcResetGpaSessionAMD,
	ResetQueryPool:                                         ProcResetQueryPool,
	ResetQueryPoolEXT:                                      ProcResetQueryPoolEXT,
	SetDebugUtilsObjectNameEXT:                             ProcSetDebugUtilsObjectNameEXT,
	SetDebugUtilsObjectTagEXT:                              ProcSetDebugUtilsObjectTagEXT,
	SetDeviceMemoryPriorityEXT:                             ProcSetDeviceMemoryPriorityEXT,
	SetEvent:                                               ProcSetEvent,
	SetGpaDeviceClockModeAMD:                               ProcSetGpaDeviceClockModeAMD,
	SetHdrMetadataEXT:                                      ProcSetHdrMetadataEXT,
	SetLatencyMarkerNV:                                     ProcSetLatencyMarkerNV,
	SetLatencySleepModeNV:                                  ProcSetLatencySleepModeNV,
	SetLocalDimmingAMD:                                     ProcSetLocalDimmingAMD,
	SetPrivateData:                                         ProcSetPrivateData,
	SetPrivateDataEXT:                                      ProcSetPrivateDataEXT,
	SetSwapchainPresentTimingQueueSizeEXT:                  ProcSetSwapchainPresentTimingQueueSizeEXT,
	SignalSemaphore:                                        ProcSignalSemaphore,
	SignalSemaphoreKHR:                                     ProcSignalSemaphoreKHR,
	TransitionImageLayout:                                  ProcTransitionImageLayout,
	TransitionImageLayoutEXT:                               ProcTransitionImageLayoutEXT,
	TrimCommandPool:                                        ProcTrimCommandPool,
	TrimCommandPoolKHR:                                     ProcTrimCommandPoolKHR,
	UninitializePerformanceApiINTEL:                        ProcUninitializePerformanceApiINTEL,
	UnmapMemory:                                            ProcUnmapMemory,
	UnmapMemory2:                                           ProcUnmapMemory2,
	UnmapMemory2KHR:                                        ProcUnmapMemory2KHR,
	UnregisterCustomBorderColorEXT:                         ProcUnregisterCustomBorderColorEXT,
	UpdateDescriptorSetWithTemplate:                        ProcUpdateDescriptorSetWithTemplate,
	UpdateDescriptorSetWithTemplateKHR:                     ProcUpdateDescriptorSetWithTemplateKHR,
	UpdateDescriptorSets:                                   ProcUpdateDescriptorSets,
	UpdateIndirectExecutionSetPipelineEXT:                  ProcUpdateIndirectExecutionSetPipelineEXT,
	UpdateIndirectExecutionSetShaderEXT:                    ProcUpdateIndirectExecutionSetShaderEXT,
	UpdateVideoSessionParametersKHR:                        ProcUpdateVideoSessionParametersKHR,
	WaitForFences:                                          ProcWaitForFences,
	WaitForPresent2KHR:                                     ProcWaitForPresent2KHR,
	WaitForPresentKHR:                                      ProcWaitForPresentKHR,
	WaitSemaphores:                                         ProcWaitSemaphores,
	WaitSemaphoresKHR:                                      ProcWaitSemaphoresKHR,
	WriteAccelerationStructuresPropertiesKHR:               ProcWriteAccelerationStructuresPropertiesKHR,
	WriteMicromapsPropertiesEXT:                            ProcWriteMicromapsPropertiesEXT,
	WriteResourceDescriptorsEXT:                            ProcWriteResourceDescriptorsEXT,
	WriteSamplerDescriptorsEXT:                             ProcWriteSamplerDescriptorsEXT,
}

load_proc_addresses_device_vtable :: proc(device: Device, vtable: ^Device_VTable) {
	vtable.AcquireFullScreenExclusiveModeEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireFullScreenExclusiveModeEXT")
	vtable.AcquireNextImage2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireNextImage2KHR")
	vtable.AcquireNextImageKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireNextImageKHR")
	vtable.AcquirePerformanceConfigurationINTEL                   = auto_cast PtrGetDeviceProcAddr(device, "vkAcquirePerformanceConfigurationINTEL")
	vtable.AcquireProfilingLockKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireProfilingLockKHR")
	vtable.AllocateCommandBuffers                                 = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateCommandBuffers")
	vtable.AllocateDescriptorSets                                 = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateDescriptorSets")
	vtable.AllocateMemory                                         = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateMemory")
	vtable.AntiLagUpdateAMD                                       = auto_cast PtrGetDeviceProcAddr(device, "vkAntiLagUpdateAMD")
	vtable.BeginCommandBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkBeginCommandBuffer")
	vtable.BindAccelerationStructureMemoryNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkBindAccelerationStructureMemoryNV")
	vtable.BindBufferMemory                                       = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory")
	vtable.BindBufferMemory2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory2")
	vtable.BindBufferMemory2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory2KHR")
	vtable.BindDataGraphPipelineSessionMemoryARM                  = auto_cast PtrGetDeviceProcAddr(device, "vkBindDataGraphPipelineSessionMemoryARM")
	vtable.BindImageMemory                                        = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory")
	vtable.BindImageMemory2                                       = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory2")
	vtable.BindImageMemory2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory2KHR")
	vtable.BindOpticalFlowSessionImageNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkBindOpticalFlowSessionImageNV")
	vtable.BindTensorMemoryARM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkBindTensorMemoryARM")
	vtable.BindVideoSessionMemoryKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkBindVideoSessionMemoryKHR")
	vtable.BuildAccelerationStructuresKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkBuildAccelerationStructuresKHR")
	vtable.BuildMicromapsEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkBuildMicromapsEXT")
	vtable.ClearShaderInstrumentationMetricsARM                   = auto_cast PtrGetDeviceProcAddr(device, "vkClearShaderInstrumentationMetricsARM")
	vtable.CmdBeginConditionalRendering2EXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginConditionalRendering2EXT")
	vtable.CmdBeginConditionalRenderingEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginConditionalRenderingEXT")
	vtable.CmdBeginCustomResolveEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginCustomResolveEXT")
	vtable.CmdBeginDebugUtilsLabelEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginDebugUtilsLabelEXT")
	vtable.CmdBeginGpaSampleAMD                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginGpaSampleAMD")
	vtable.CmdBeginGpaSessionAMD                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginGpaSessionAMD")
	vtable.CmdBeginPerTileExecutionQCOM                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginPerTileExecutionQCOM")
	vtable.CmdBeginQuery                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginQuery")
	vtable.CmdBeginQueryIndexedEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginQueryIndexedEXT")
	vtable.CmdBeginRenderPass                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass")
	vtable.CmdBeginRenderPass2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass2")
	vtable.CmdBeginRenderPass2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass2KHR")
	vtable.CmdBeginRendering                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRendering")
	vtable.CmdBeginRenderingKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderingKHR")
	vtable.CmdBeginShaderInstrumentationARM                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginShaderInstrumentationARM")
	vtable.CmdBeginTransformFeedback2EXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginTransformFeedback2EXT")
	vtable.CmdBeginTransformFeedbackEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginTransformFeedbackEXT")
	vtable.CmdBeginVideoCodingKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginVideoCodingKHR")
	vtable.CmdBindDescriptorBufferEmbeddedSamplers2EXT            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBufferEmbeddedSamplers2EXT")
	vtable.CmdBindDescriptorBufferEmbeddedSamplersEXT             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBufferEmbeddedSamplersEXT")
	vtable.CmdBindDescriptorBuffersEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBuffersEXT")
	vtable.CmdBindDescriptorSets                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets")
	vtable.CmdBindDescriptorSets2                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets2")
	vtable.CmdBindDescriptorSets2KHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets2KHR")
	vtable.CmdBindIndexBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer")
	vtable.CmdBindIndexBuffer2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer2")
	vtable.CmdBindIndexBuffer2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer2KHR")
	vtable.CmdBindIndexBuffer3KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer3KHR")
	vtable.CmdBindInvocationMaskHUAWEI                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindInvocationMaskHUAWEI")
	vtable.CmdBindPipeline                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindPipeline")
	vtable.CmdBindPipelineShaderGroupNV                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindPipelineShaderGroupNV")
	vtable.CmdBindResourceHeapEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindResourceHeapEXT")
	vtable.CmdBindSamplerHeapEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindSamplerHeapEXT")
	vtable.CmdBindShadersEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindShadersEXT")
	vtable.CmdBindShadingRateImageNV                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindShadingRateImageNV")
	vtable.CmdBindTileMemoryQCOM                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTileMemoryQCOM")
	vtable.CmdBindTransformFeedbackBuffers2EXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTransformFeedbackBuffers2EXT")
	vtable.CmdBindTransformFeedbackBuffersEXT                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTransformFeedbackBuffersEXT")
	vtable.CmdBindVertexBuffers                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers")
	vtable.CmdBindVertexBuffers2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers2")
	vtable.CmdBindVertexBuffers2EXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers2EXT")
	vtable.CmdBindVertexBuffers3KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers3KHR")
	vtable.CmdBlitImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage")
	vtable.CmdBlitImage2                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage2")
	vtable.CmdBlitImage2KHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage2KHR")
	vtable.CmdBuildAccelerationStructureNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructureNV")
	vtable.CmdBuildAccelerationStructuresIndirectKHR              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructuresIndirectKHR")
	vtable.CmdBuildAccelerationStructuresKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructuresKHR")
	vtable.CmdBuildClusterAccelerationStructureIndirectNV         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildClusterAccelerationStructureIndirectNV")
	vtable.CmdBuildMicromapsEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildMicromapsEXT")
	vtable.CmdBuildPartitionedAccelerationStructuresNV            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildPartitionedAccelerationStructuresNV")
	vtable.CmdClearAttachments                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearAttachments")
	vtable.CmdClearColorImage                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearColorImage")
	vtable.CmdClearDepthStencilImage                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearDepthStencilImage")
	vtable.CmdControlVideoCodingKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdControlVideoCodingKHR")
	vtable.CmdConvertCooperativeVectorMatrixNV                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdConvertCooperativeVectorMatrixNV")
	vtable.CmdCopyAccelerationStructureKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureKHR")
	vtable.CmdCopyAccelerationStructureNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureNV")
	vtable.CmdCopyAccelerationStructureToMemoryKHR                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureToMemoryKHR")
	vtable.CmdCopyBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer")
	vtable.CmdCopyBuffer2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer2")
	vtable.CmdCopyBuffer2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer2KHR")
	vtable.CmdCopyBufferToImage                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage")
	vtable.CmdCopyBufferToImage2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage2")
	vtable.CmdCopyBufferToImage2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage2KHR")
	vtable.CmdCopyGpaSessionResultsAMD                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyGpaSessionResultsAMD")
	vtable.CmdCopyImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage")
	vtable.CmdCopyImage2                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage2")
	vtable.CmdCopyImage2KHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage2KHR")
	vtable.CmdCopyImageToBuffer                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer")
	vtable.CmdCopyImageToBuffer2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer2")
	vtable.CmdCopyImageToBuffer2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer2KHR")
	vtable.CmdCopyImageToMemoryKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToMemoryKHR")
	vtable.CmdCopyMemoryIndirectKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryIndirectKHR")
	vtable.CmdCopyMemoryIndirectNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryIndirectNV")
	vtable.CmdCopyMemoryKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryKHR")
	vtable.CmdCopyMemoryToAccelerationStructureKHR                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToAccelerationStructureKHR")
	vtable.CmdCopyMemoryToImageIndirectKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageIndirectKHR")
	vtable.CmdCopyMemoryToImageIndirectNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageIndirectNV")
	vtable.CmdCopyMemoryToImageKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageKHR")
	vtable.CmdCopyMemoryToMicromapEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToMicromapEXT")
	vtable.CmdCopyMicromapEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMicromapEXT")
	vtable.CmdCopyMicromapToMemoryEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMicromapToMemoryEXT")
	vtable.CmdCopyQueryPoolResults                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyQueryPoolResults")
	vtable.CmdCopyQueryPoolResultsToMemoryKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyQueryPoolResultsToMemoryKHR")
	vtable.CmdCopyTensorARM                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyTensorARM")
	vtable.CmdCuLaunchKernelNVX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCuLaunchKernelNVX")
	vtable.CmdCudaLaunchKernelNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCudaLaunchKernelNV")
	vtable.CmdDebugMarkerBeginEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerBeginEXT")
	vtable.CmdDebugMarkerEndEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerEndEXT")
	vtable.CmdDebugMarkerInsertEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerInsertEXT")
	vtable.CmdDecodeVideoKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecodeVideoKHR")
	vtable.CmdDecompressMemoryEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryEXT")
	vtable.CmdDecompressMemoryIndirectCountEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryIndirectCountEXT")
	vtable.CmdDecompressMemoryIndirectCountNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryIndirectCountNV")
	vtable.CmdDecompressMemoryNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryNV")
	vtable.CmdDispatch                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatch")
	vtable.CmdDispatchBase                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchBase")
	vtable.CmdDispatchBaseKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchBaseKHR")
	vtable.CmdDispatchDataGraphARM                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchDataGraphARM")
	vtable.CmdDispatchGraphAMDX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphAMDX")
	vtable.CmdDispatchGraphIndirectAMDX                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphIndirectAMDX")
	vtable.CmdDispatchGraphIndirectCountAMDX                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphIndirectCountAMDX")
	vtable.CmdDispatchIndirect                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchIndirect")
	vtable.CmdDispatchIndirect2KHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchIndirect2KHR")
	vtable.CmdDispatchTileQCOM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchTileQCOM")
	vtable.CmdDraw                                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDraw")
	vtable.CmdDrawClusterHUAWEI                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawClusterHUAWEI")
	vtable.CmdDrawClusterIndirectHUAWEI                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawClusterIndirectHUAWEI")
	vtable.CmdDrawIndexed                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexed")
	vtable.CmdDrawIndexedIndirect                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirect")
	vtable.CmdDrawIndexedIndirect2KHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirect2KHR")
	vtable.CmdDrawIndexedIndirectCount                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCount")
	vtable.CmdDrawIndexedIndirectCount2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCount2KHR")
	vtable.CmdDrawIndexedIndirectCountAMD                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCountAMD")
	vtable.CmdDrawIndexedIndirectCountKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCountKHR")
	vtable.CmdDrawIndirect                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirect")
	vtable.CmdDrawIndirect2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirect2KHR")
	vtable.CmdDrawIndirectByteCount2EXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectByteCount2EXT")
	vtable.CmdDrawIndirectByteCountEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectByteCountEXT")
	vtable.CmdDrawIndirectCount                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCount")
	vtable.CmdDrawIndirectCount2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCount2KHR")
	vtable.CmdDrawIndirectCountAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCountAMD")
	vtable.CmdDrawIndirectCountKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCountKHR")
	vtable.CmdDrawMeshTasksEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksEXT")
	vtable.CmdDrawMeshTasksIndirect2EXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirect2EXT")
	vtable.CmdDrawMeshTasksIndirectCount2EXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCount2EXT")
	vtable.CmdDrawMeshTasksIndirectCountEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCountEXT")
	vtable.CmdDrawMeshTasksIndirectCountNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCountNV")
	vtable.CmdDrawMeshTasksIndirectEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectEXT")
	vtable.CmdDrawMeshTasksIndirectNV                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectNV")
	vtable.CmdDrawMeshTasksNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksNV")
	vtable.CmdDrawMultiEXT                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMultiEXT")
	vtable.CmdDrawMultiIndexedEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMultiIndexedEXT")
	vtable.CmdEncodeVideoKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEncodeVideoKHR")
	vtable.CmdEndConditionalRenderingEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndConditionalRenderingEXT")
	vtable.CmdEndDebugUtilsLabelEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndDebugUtilsLabelEXT")
	vtable.CmdEndGpaSampleAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndGpaSampleAMD")
	vtable.CmdEndGpaSessionAMD                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndGpaSessionAMD")
	vtable.CmdEndPerTileExecutionQCOM                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndPerTileExecutionQCOM")
	vtable.CmdEndQuery                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndQuery")
	vtable.CmdEndQueryIndexedEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndQueryIndexedEXT")
	vtable.CmdEndRenderPass                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass")
	vtable.CmdEndRenderPass2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass2")
	vtable.CmdEndRenderPass2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass2KHR")
	vtable.CmdEndRendering                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering")
	vtable.CmdEndRendering2EXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering2EXT")
	vtable.CmdEndRendering2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering2KHR")
	vtable.CmdEndRenderingKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderingKHR")
	vtable.CmdEndShaderInstrumentationARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndShaderInstrumentationARM")
	vtable.CmdEndTransformFeedback2EXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndTransformFeedback2EXT")
	vtable.CmdEndTransformFeedbackEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndTransformFeedbackEXT")
	vtable.CmdEndVideoCodingKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndVideoCodingKHR")
	vtable.CmdExecuteCommands                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteCommands")
	vtable.CmdExecuteGeneratedCommandsEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteGeneratedCommandsEXT")
	vtable.CmdExecuteGeneratedCommandsNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteGeneratedCommandsNV")
	vtable.CmdFillBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdFillBuffer")
	vtable.CmdFillMemoryKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdFillMemoryKHR")
	vtable.CmdInitializeGraphScratchMemoryAMDX                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdInitializeGraphScratchMemoryAMDX")
	vtable.CmdInsertDebugUtilsLabelEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdInsertDebugUtilsLabelEXT")
	vtable.CmdNextSubpass                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass")
	vtable.CmdNextSubpass2                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass2")
	vtable.CmdNextSubpass2KHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass2KHR")
	vtable.CmdOpticalFlowExecuteNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdOpticalFlowExecuteNV")
	vtable.CmdPipelineBarrier                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier")
	vtable.CmdPipelineBarrier2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier2")
	vtable.CmdPipelineBarrier2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier2KHR")
	vtable.CmdPreprocessGeneratedCommandsEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPreprocessGeneratedCommandsEXT")
	vtable.CmdPreprocessGeneratedCommandsNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPreprocessGeneratedCommandsNV")
	vtable.CmdPushConstants                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants")
	vtable.CmdPushConstants2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants2")
	vtable.CmdPushConstants2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants2KHR")
	vtable.CmdPushDataEXT                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDataEXT")
	vtable.CmdPushDescriptorSet                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet")
	vtable.CmdPushDescriptorSet2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet2")
	vtable.CmdPushDescriptorSet2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet2KHR")
	vtable.CmdPushDescriptorSetKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetKHR")
	vtable.CmdPushDescriptorSetWithTemplate                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate")
	vtable.CmdPushDescriptorSetWithTemplate2                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate2")
	vtable.CmdPushDescriptorSetWithTemplate2KHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate2KHR")
	vtable.CmdPushDescriptorSetWithTemplateKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplateKHR")
	vtable.CmdResetEvent                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent")
	vtable.CmdResetEvent2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent2")
	vtable.CmdResetEvent2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent2KHR")
	vtable.CmdResetQueryPool                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetQueryPool")
	vtable.CmdResolveImage                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage")
	vtable.CmdResolveImage2                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage2")
	vtable.CmdResolveImage2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage2KHR")
	vtable.CmdSetAlphaToCoverageEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAlphaToCoverageEnableEXT")
	vtable.CmdSetAlphaToOneEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAlphaToOneEnableEXT")
	vtable.CmdSetAttachmentFeedbackLoopEnableEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAttachmentFeedbackLoopEnableEXT")
	vtable.CmdSetBlendConstants                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetBlendConstants")
	vtable.CmdSetCheckpointNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCheckpointNV")
	vtable.CmdSetCoarseSampleOrderNV                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoarseSampleOrderNV")
	vtable.CmdSetColorBlendAdvancedEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendAdvancedEXT")
	vtable.CmdSetColorBlendEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendEnableEXT")
	vtable.CmdSetColorBlendEquationEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendEquationEXT")
	vtable.CmdSetColorWriteEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorWriteEnableEXT")
	vtable.CmdSetColorWriteMaskEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorWriteMaskEXT")
	vtable.CmdSetComputeOccupancyPriorityNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetComputeOccupancyPriorityNV")
	vtable.CmdSetConservativeRasterizationModeEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetConservativeRasterizationModeEXT")
	vtable.CmdSetCoverageModulationModeNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationModeNV")
	vtable.CmdSetCoverageModulationTableEnableNV                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationTableEnableNV")
	vtable.CmdSetCoverageModulationTableNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationTableNV")
	vtable.CmdSetCoverageReductionModeNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageReductionModeNV")
	vtable.CmdSetCoverageToColorEnableNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageToColorEnableNV")
	vtable.CmdSetCoverageToColorLocationNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageToColorLocationNV")
	vtable.CmdSetCullMode                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCullMode")
	vtable.CmdSetCullModeEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCullModeEXT")
	vtable.CmdSetDepthBias                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBias")
	vtable.CmdSetDepthBias2EXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBias2EXT")
	vtable.CmdSetDepthBiasEnable                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBiasEnable")
	vtable.CmdSetDepthBiasEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBiasEnableEXT")
	vtable.CmdSetDepthBounds                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBounds")
	vtable.CmdSetDepthBoundsTestEnable                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBoundsTestEnable")
	vtable.CmdSetDepthBoundsTestEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBoundsTestEnableEXT")
	vtable.CmdSetDepthClampEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClampEnableEXT")
	vtable.CmdSetDepthClampRangeEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClampRangeEXT")
	vtable.CmdSetDepthClipEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClipEnableEXT")
	vtable.CmdSetDepthClipNegativeOneToOneEXT                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClipNegativeOneToOneEXT")
	vtable.CmdSetDepthCompareOp                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthCompareOp")
	vtable.CmdSetDepthCompareOpEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthCompareOpEXT")
	vtable.CmdSetDepthTestEnable                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthTestEnable")
	vtable.CmdSetDepthTestEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthTestEnableEXT")
	vtable.CmdSetDepthWriteEnable                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthWriteEnable")
	vtable.CmdSetDepthWriteEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthWriteEnableEXT")
	vtable.CmdSetDescriptorBufferOffsets2EXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDescriptorBufferOffsets2EXT")
	vtable.CmdSetDescriptorBufferOffsetsEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDescriptorBufferOffsetsEXT")
	vtable.CmdSetDeviceMask                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDeviceMask")
	vtable.CmdSetDeviceMaskKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDeviceMaskKHR")
	vtable.CmdSetDiscardRectangleEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleEXT")
	vtable.CmdSetDiscardRectangleEnableEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleEnableEXT")
	vtable.CmdSetDiscardRectangleModeEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleModeEXT")
	vtable.CmdSetDispatchParametersARM                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDispatchParametersARM")
	vtable.CmdSetEvent                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent")
	vtable.CmdSetEvent2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent2")
	vtable.CmdSetEvent2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent2KHR")
	vtable.CmdSetExclusiveScissorEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExclusiveScissorEnableNV")
	vtable.CmdSetExclusiveScissorNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExclusiveScissorNV")
	vtable.CmdSetExtraPrimitiveOverestimationSizeEXT              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExtraPrimitiveOverestimationSizeEXT")
	vtable.CmdSetFragmentShadingRateEnumNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFragmentShadingRateEnumNV")
	vtable.CmdSetFragmentShadingRateKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFragmentShadingRateKHR")
	vtable.CmdSetFrontFace                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFrontFace")
	vtable.CmdSetFrontFaceEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFrontFaceEXT")
	vtable.CmdSetLineRasterizationModeEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineRasterizationModeEXT")
	vtable.CmdSetLineStipple                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStipple")
	vtable.CmdSetLineStippleEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleEXT")
	vtable.CmdSetLineStippleEnableEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleEnableEXT")
	vtable.CmdSetLineStippleKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleKHR")
	vtable.CmdSetLineWidth                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineWidth")
	vtable.CmdSetLogicOpEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLogicOpEXT")
	vtable.CmdSetLogicOpEnableEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLogicOpEnableEXT")
	vtable.CmdSetPatchControlPointsEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPatchControlPointsEXT")
	vtable.CmdSetPerformanceMarkerINTEL                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceMarkerINTEL")
	vtable.CmdSetPerformanceOverrideINTEL                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceOverrideINTEL")
	vtable.CmdSetPerformanceStreamMarkerINTEL                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceStreamMarkerINTEL")
	vtable.CmdSetPolygonModeEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPolygonModeEXT")
	vtable.CmdSetPrimitiveRestartEnable                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartEnable")
	vtable.CmdSetPrimitiveRestartEnableEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartEnableEXT")
	vtable.CmdSetPrimitiveRestartIndexEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartIndexEXT")
	vtable.CmdSetPrimitiveTopology                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveTopology")
	vtable.CmdSetPrimitiveTopologyEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveTopologyEXT")
	vtable.CmdSetProvokingVertexModeEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetProvokingVertexModeEXT")
	vtable.CmdSetRasterizationSamplesEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizationSamplesEXT")
	vtable.CmdSetRasterizationStreamEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizationStreamEXT")
	vtable.CmdSetRasterizerDiscardEnable                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizerDiscardEnable")
	vtable.CmdSetRasterizerDiscardEnableEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizerDiscardEnableEXT")
	vtable.CmdSetRayTracingPipelineStackSizeKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRayTracingPipelineStackSizeKHR")
	vtable.CmdSetRenderingAttachmentLocations                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingAttachmentLocations")
	vtable.CmdSetRenderingAttachmentLocationsKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingAttachmentLocationsKHR")
	vtable.CmdSetRenderingInputAttachmentIndices                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingInputAttachmentIndices")
	vtable.CmdSetRenderingInputAttachmentIndicesKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingInputAttachmentIndicesKHR")
	vtable.CmdSetRepresentativeFragmentTestEnableNV               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRepresentativeFragmentTestEnableNV")
	vtable.CmdSetSampleLocationsEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleLocationsEXT")
	vtable.CmdSetSampleLocationsEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleLocationsEnableEXT")
	vtable.CmdSetSampleMaskEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleMaskEXT")
	vtable.CmdSetScissor                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissor")
	vtable.CmdSetScissorWithCount                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissorWithCount")
	vtable.CmdSetScissorWithCountEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissorWithCountEXT")
	vtable.CmdSetShadingRateImageEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetShadingRateImageEnableNV")
	vtable.CmdSetStencilCompareMask                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilCompareMask")
	vtable.CmdSetStencilOp                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilOp")
	vtable.CmdSetStencilOpEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilOpEXT")
	vtable.CmdSetStencilReference                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilReference")
	vtable.CmdSetStencilTestEnable                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilTestEnable")
	vtable.CmdSetStencilTestEnableEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilTestEnableEXT")
	vtable.CmdSetStencilWriteMask                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilWriteMask")
	vtable.CmdSetTessellationDomainOriginEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetTessellationDomainOriginEXT")
	vtable.CmdSetVertexInputEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetVertexInputEXT")
	vtable.CmdSetViewport                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewport")
	vtable.CmdSetViewportShadingRatePaletteNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportShadingRatePaletteNV")
	vtable.CmdSetViewportSwizzleNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportSwizzleNV")
	vtable.CmdSetViewportWScalingEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWScalingEnableNV")
	vtable.CmdSetViewportWScalingNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWScalingNV")
	vtable.CmdSetViewportWithCount                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWithCount")
	vtable.CmdSetViewportWithCountEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWithCountEXT")
	vtable.CmdSubpassShadingHUAWEI                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSubpassShadingHUAWEI")
	vtable.CmdTraceRaysIndirect2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysIndirect2KHR")
	vtable.CmdTraceRaysIndirectKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysIndirectKHR")
	vtable.CmdTraceRaysKHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysKHR")
	vtable.CmdTraceRaysNV                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysNV")
	vtable.CmdUpdateBuffer                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdateBuffer")
	vtable.CmdUpdateMemoryKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdateMemoryKHR")
	vtable.CmdUpdatePipelineIndirectBufferNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdatePipelineIndirectBufferNV")
	vtable.CmdWaitEvents                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents")
	vtable.CmdWaitEvents2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents2")
	vtable.CmdWaitEvents2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents2KHR")
	vtable.CmdWriteAccelerationStructuresPropertiesKHR            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteAccelerationStructuresPropertiesKHR")
	vtable.CmdWriteAccelerationStructuresPropertiesNV             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteAccelerationStructuresPropertiesNV")
	vtable.CmdWriteBufferMarker2AMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteBufferMarker2AMD")
	vtable.CmdWriteBufferMarkerAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteBufferMarkerAMD")
	vtable.CmdWriteMarkerToMemoryAMD                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteMarkerToMemoryAMD")
	vtable.CmdWriteMicromapsPropertiesEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteMicromapsPropertiesEXT")
	vtable.CmdWriteTimestamp                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp")
	vtable.CmdWriteTimestamp2                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp2")
	vtable.CmdWriteTimestamp2KHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp2KHR")
	vtable.CompileDeferredNV                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCompileDeferredNV")
	vtable.ConvertCooperativeVectorMatrixNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkConvertCooperativeVectorMatrixNV")
	vtable.CopyAccelerationStructureKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCopyAccelerationStructureKHR")
	vtable.CopyAccelerationStructureToMemoryKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyAccelerationStructureToMemoryKHR")
	vtable.CopyImageToImage                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToImage")
	vtable.CopyImageToImageEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToImageEXT")
	vtable.CopyImageToMemory                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToMemory")
	vtable.CopyImageToMemoryEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToMemoryEXT")
	vtable.CopyMemoryToAccelerationStructureKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToAccelerationStructureKHR")
	vtable.CopyMemoryToImage                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToImage")
	vtable.CopyMemoryToImageEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToImageEXT")
	vtable.CopyMemoryToMicromapEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToMicromapEXT")
	vtable.CopyMicromapEXT                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMicromapEXT")
	vtable.CopyMicromapToMemoryEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMicromapToMemoryEXT")
	vtable.CreateAccelerationStructure2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructure2KHR")
	vtable.CreateAccelerationStructureKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructureKHR")
	vtable.CreateAccelerationStructureNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructureNV")
	vtable.CreateBuffer                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateBuffer")
	vtable.CreateBufferView                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateBufferView")
	vtable.CreateCommandPool                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCommandPool")
	vtable.CreateComputePipelines                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCreateComputePipelines")
	vtable.CreateCuFunctionNVX                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCuFunctionNVX")
	vtable.CreateCuModuleNVX                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCuModuleNVX")
	vtable.CreateCudaFunctionNV                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCudaFunctionNV")
	vtable.CreateCudaModuleNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCudaModuleNV")
	vtable.CreateDataGraphPipelineSessionARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDataGraphPipelineSessionARM")
	vtable.CreateDataGraphPipelinesARM                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDataGraphPipelinesARM")
	vtable.CreateDeferredOperationKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDeferredOperationKHR")
	vtable.CreateDescriptorPool                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorPool")
	vtable.CreateDescriptorSetLayout                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorSetLayout")
	vtable.CreateDescriptorUpdateTemplate                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorUpdateTemplate")
	vtable.CreateDescriptorUpdateTemplateKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorUpdateTemplateKHR")
	vtable.CreateEvent                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateEvent")
	vtable.CreateExecutionGraphPipelinesAMDX                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateExecutionGraphPipelinesAMDX")
	vtable.CreateExternalComputeQueueNV                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateExternalComputeQueueNV")
	vtable.CreateFence                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateFence")
	vtable.CreateFramebuffer                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateFramebuffer")
	vtable.CreateGpaSessionAMD                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateGpaSessionAMD")
	vtable.CreateGraphicsPipelines                                = auto_cast PtrGetDeviceProcAddr(device, "vkCreateGraphicsPipelines")
	vtable.CreateImage                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateImage")
	vtable.CreateImageView                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateImageView")
	vtable.CreateIndirectCommandsLayoutEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectCommandsLayoutEXT")
	vtable.CreateIndirectCommandsLayoutNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectCommandsLayoutNV")
	vtable.CreateIndirectExecutionSetEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectExecutionSetEXT")
	vtable.CreateMicromapEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateMicromapEXT")
	vtable.CreateOpticalFlowSessionNV                             = auto_cast PtrGetDeviceProcAddr(device, "vkCreateOpticalFlowSessionNV")
	vtable.CreatePipelineBinariesKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineBinariesKHR")
	vtable.CreatePipelineCache                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineCache")
	vtable.CreatePipelineLayout                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineLayout")
	vtable.CreatePrivateDataSlot                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePrivateDataSlot")
	vtable.CreatePrivateDataSlotEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePrivateDataSlotEXT")
	vtable.CreateQueryPool                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateQueryPool")
	vtable.CreateRayTracingPipelinesKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRayTracingPipelinesKHR")
	vtable.CreateRayTracingPipelinesNV                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRayTracingPipelinesNV")
	vtable.CreateRenderPass                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass")
	vtable.CreateRenderPass2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass2")
	vtable.CreateRenderPass2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass2KHR")
	vtable.CreateSampler                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSampler")
	vtable.CreateSamplerYcbcrConversion                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSamplerYcbcrConversion")
	vtable.CreateSamplerYcbcrConversionKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSamplerYcbcrConversionKHR")
	vtable.CreateSemaphore                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSemaphore")
	vtable.CreateShaderInstrumentationARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShaderInstrumentationARM")
	vtable.CreateShaderModule                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShaderModule")
	vtable.CreateShadersEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShadersEXT")
	vtable.CreateSharedSwapchainsKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSharedSwapchainsKHR")
	vtable.CreateSwapchainKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSwapchainKHR")
	vtable.CreateTensorARM                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateTensorARM")
	vtable.CreateTensorViewARM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateTensorViewARM")
	vtable.CreateValidationCacheEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCreateValidationCacheEXT")
	vtable.CreateVideoSessionKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCreateVideoSessionKHR")
	vtable.CreateVideoSessionParametersKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateVideoSessionParametersKHR")
	vtable.DebugMarkerSetObjectNameEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkDebugMarkerSetObjectNameEXT")
	vtable.DebugMarkerSetObjectTagEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkDebugMarkerSetObjectTagEXT")
	vtable.DeferredOperationJoinKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkDeferredOperationJoinKHR")
	vtable.DestroyAccelerationStructureKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyAccelerationStructureKHR")
	vtable.DestroyAccelerationStructureNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyAccelerationStructureNV")
	vtable.DestroyBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyBuffer")
	vtable.DestroyBufferView                                      = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyBufferView")
	vtable.DestroyCommandPool                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCommandPool")
	vtable.DestroyCuFunctionNVX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCuFunctionNVX")
	vtable.DestroyCuModuleNVX                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCuModuleNVX")
	vtable.DestroyCudaFunctionNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCudaFunctionNV")
	vtable.DestroyCudaModuleNV                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCudaModuleNV")
	vtable.DestroyDataGraphPipelineSessionARM                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDataGraphPipelineSessionARM")
	vtable.DestroyDeferredOperationKHR                            = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDeferredOperationKHR")
	vtable.DestroyDescriptorPool                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorPool")
	vtable.DestroyDescriptorSetLayout                             = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorSetLayout")
	vtable.DestroyDescriptorUpdateTemplate                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorUpdateTemplate")
	vtable.DestroyDescriptorUpdateTemplateKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorUpdateTemplateKHR")
	vtable.DestroyDevice                                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDevice")
	vtable.DestroyEvent                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyEvent")
	vtable.DestroyExternalComputeQueueNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyExternalComputeQueueNV")
	vtable.DestroyFence                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyFence")
	vtable.DestroyFramebuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyFramebuffer")
	vtable.DestroyGpaSessionAMD                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyGpaSessionAMD")
	vtable.DestroyImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyImage")
	vtable.DestroyImageView                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyImageView")
	vtable.DestroyIndirectCommandsLayoutEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectCommandsLayoutEXT")
	vtable.DestroyIndirectCommandsLayoutNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectCommandsLayoutNV")
	vtable.DestroyIndirectExecutionSetEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectExecutionSetEXT")
	vtable.DestroyMicromapEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyMicromapEXT")
	vtable.DestroyOpticalFlowSessionNV                            = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyOpticalFlowSessionNV")
	vtable.DestroyPipeline                                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipeline")
	vtable.DestroyPipelineBinaryKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineBinaryKHR")
	vtable.DestroyPipelineCache                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineCache")
	vtable.DestroyPipelineLayout                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineLayout")
	vtable.DestroyPrivateDataSlot                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPrivateDataSlot")
	vtable.DestroyPrivateDataSlotEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPrivateDataSlotEXT")
	vtable.DestroyQueryPool                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyQueryPool")
	vtable.DestroyRenderPass                                      = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyRenderPass")
	vtable.DestroySampler                                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySampler")
	vtable.DestroySamplerYcbcrConversion                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySamplerYcbcrConversion")
	vtable.DestroySamplerYcbcrConversionKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySamplerYcbcrConversionKHR")
	vtable.DestroySemaphore                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySemaphore")
	vtable.DestroyShaderEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderEXT")
	vtable.DestroyShaderInstrumentationARM                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderInstrumentationARM")
	vtable.DestroyShaderModule                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderModule")
	vtable.DestroySwapchainKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySwapchainKHR")
	vtable.DestroyTensorARM                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyTensorARM")
	vtable.DestroyTensorViewARM                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyTensorViewARM")
	vtable.DestroyValidationCacheEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyValidationCacheEXT")
	vtable.DestroyVideoSessionKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyVideoSessionKHR")
	vtable.DestroyVideoSessionParametersKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyVideoSessionParametersKHR")
	vtable.DeviceWaitIdle                                         = auto_cast PtrGetDeviceProcAddr(device, "vkDeviceWaitIdle")
	vtable.DisplayPowerControlEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDisplayPowerControlEXT")
	vtable.EndCommandBuffer                                       = auto_cast PtrGetDeviceProcAddr(device, "vkEndCommandBuffer")
	vtable.ExportMetalObjectsEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkExportMetalObjectsEXT")
	vtable.FlushMappedMemoryRanges                                = auto_cast PtrGetDeviceProcAddr(device, "vkFlushMappedMemoryRanges")
	vtable.FreeCommandBuffers                                     = auto_cast PtrGetDeviceProcAddr(device, "vkFreeCommandBuffers")
	vtable.FreeDescriptorSets                                     = auto_cast PtrGetDeviceProcAddr(device, "vkFreeDescriptorSets")
	vtable.FreeMemory                                             = auto_cast PtrGetDeviceProcAddr(device, "vkFreeMemory")
	vtable.GetAccelerationStructureBuildSizesKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureBuildSizesKHR")
	vtable.GetAccelerationStructureDeviceAddressKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureDeviceAddressKHR")
	vtable.GetAccelerationStructureHandleNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureHandleNV")
	vtable.GetAccelerationStructureMemoryRequirementsNV           = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureMemoryRequirementsNV")
	vtable.GetAccelerationStructureOpaqueCaptureDescriptorDataEXT = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT")
	vtable.GetAndroidHardwareBufferPropertiesANDROID              = auto_cast PtrGetDeviceProcAddr(device, "vkGetAndroidHardwareBufferPropertiesANDROID")
	vtable.GetBufferDeviceAddress                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddress")
	vtable.GetBufferDeviceAddressEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddressEXT")
	vtable.GetBufferDeviceAddressKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddressKHR")
	vtable.GetBufferMemoryRequirements                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements")
	vtable.GetBufferMemoryRequirements2                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements2")
	vtable.GetBufferMemoryRequirements2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements2KHR")
	vtable.GetBufferOpaqueCaptureAddress                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureAddress")
	vtable.GetBufferOpaqueCaptureAddressKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureAddressKHR")
	vtable.GetBufferOpaqueCaptureDescriptorDataEXT                = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureDescriptorDataEXT")
	vtable.GetCalibratedTimestampsEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetCalibratedTimestampsEXT")
	vtable.GetCalibratedTimestampsKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetCalibratedTimestampsKHR")
	vtable.GetClusterAccelerationStructureBuildSizesNV            = auto_cast PtrGetDeviceProcAddr(device, "vkGetClusterAccelerationStructureBuildSizesNV")
	vtable.GetCudaModuleCacheNV                                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetCudaModuleCacheNV")
	vtable.GetDataGraphPipelineAvailablePropertiesARM             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineAvailablePropertiesARM")
	vtable.GetDataGraphPipelinePropertiesARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelinePropertiesARM")
	vtable.GetDataGraphPipelineSessionBindPointRequirementsARM    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineSessionBindPointRequirementsARM")
	vtable.GetDataGraphPipelineSessionMemoryRequirementsARM       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineSessionMemoryRequirementsARM")
	vtable.GetDeferredOperationMaxConcurrencyKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeferredOperationMaxConcurrencyKHR")
	vtable.GetDeferredOperationResultKHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeferredOperationResultKHR")
	vtable.GetDescriptorEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorEXT")
	vtable.GetDescriptorSetHostMappingVALVE                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetHostMappingVALVE")
	vtable.GetDescriptorSetLayoutBindingOffsetEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutBindingOffsetEXT")
	vtable.GetDescriptorSetLayoutHostMappingInfoVALVE             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutHostMappingInfoVALVE")
	vtable.GetDescriptorSetLayoutSizeEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSizeEXT")
	vtable.GetDescriptorSetLayoutSupport                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSupport")
	vtable.GetDescriptorSetLayoutSupportKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSupportKHR")
	vtable.GetDeviceAccelerationStructureCompatibilityKHR         = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceAccelerationStructureCompatibilityKHR")
	vtable.GetDeviceBufferMemoryRequirements                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceBufferMemoryRequirements")
	vtable.GetDeviceBufferMemoryRequirementsKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceBufferMemoryRequirementsKHR")
	vtable.GetDeviceCombinedImageSamplerIndexNVX                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceCombinedImageSamplerIndexNVX")
	vtable.GetDeviceFaultDebugInfoKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultDebugInfoKHR")
	vtable.GetDeviceFaultInfoEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultInfoEXT")
	vtable.GetDeviceFaultReportsKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultReportsKHR")
	vtable.GetDeviceGroupPeerMemoryFeatures                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPeerMemoryFeatures")
	vtable.GetDeviceGroupPeerMemoryFeaturesKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPeerMemoryFeaturesKHR")
	vtable.GetDeviceGroupPresentCapabilitiesKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPresentCapabilitiesKHR")
	vtable.GetDeviceGroupSurfacePresentModes2EXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupSurfacePresentModes2EXT")
	vtable.GetDeviceGroupSurfacePresentModesKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupSurfacePresentModesKHR")
	vtable.GetDeviceImageMemoryRequirements                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageMemoryRequirements")
	vtable.GetDeviceImageMemoryRequirementsKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageMemoryRequirementsKHR")
	vtable.GetDeviceImageSparseMemoryRequirements                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSparseMemoryRequirements")
	vtable.GetDeviceImageSparseMemoryRequirementsKHR              = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSparseMemoryRequirementsKHR")
	vtable.GetDeviceImageSubresourceLayout                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSubresourceLayout")
	vtable.GetDeviceImageSubresourceLayoutKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSubresourceLayoutKHR")
	vtable.GetDeviceMemoryCommitment                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryCommitment")
	vtable.GetDeviceMemoryOpaqueCaptureAddress                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryOpaqueCaptureAddress")
	vtable.GetDeviceMemoryOpaqueCaptureAddressKHR                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryOpaqueCaptureAddressKHR")
	vtable.GetDeviceMicromapCompatibilityEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMicromapCompatibilityEXT")
	vtable.GetDeviceProcAddr                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceProcAddr")
	vtable.GetDeviceQueue                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceQueue")
	vtable.GetDeviceQueue2                                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceQueue2")
	vtable.GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI")
	vtable.GetDeviceTensorMemoryRequirementsARM                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceTensorMemoryRequirementsARM")
	vtable.GetDynamicRenderingTilePropertiesQCOM                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDynamicRenderingTilePropertiesQCOM")
	vtable.GetEncodedVideoSessionParametersKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetEncodedVideoSessionParametersKHR")
	vtable.GetEventStatus                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetEventStatus")
	vtable.GetExecutionGraphPipelineNodeIndexAMDX                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetExecutionGraphPipelineNodeIndexAMDX")
	vtable.GetExecutionGraphPipelineScratchSizeAMDX               = auto_cast PtrGetDeviceProcAddr(device, "vkGetExecutionGraphPipelineScratchSizeAMDX")
	vtable.GetFenceFdKHR                                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceFdKHR")
	vtable.GetFenceStatus                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceStatus")
	vtable.GetFenceWin32HandleKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceWin32HandleKHR")
	vtable.GetFramebufferTilePropertiesQCOM                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetFramebufferTilePropertiesQCOM")
	vtable.GetGeneratedCommandsMemoryRequirementsEXT              = auto_cast PtrGetDeviceProcAddr(device, "vkGetGeneratedCommandsMemoryRequirementsEXT")
	vtable.GetGeneratedCommandsMemoryRequirementsNV               = auto_cast PtrGetDeviceProcAddr(device, "vkGetGeneratedCommandsMemoryRequirementsNV")
	vtable.GetGpaDeviceClockInfoAMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaDeviceClockInfoAMD")
	vtable.GetGpaSessionResultsAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaSessionResultsAMD")
	vtable.GetGpaSessionStatusAMD                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaSessionStatusAMD")
	vtable.GetImageDrmFormatModifierPropertiesEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageDrmFormatModifierPropertiesEXT")
	vtable.GetImageMemoryRequirements                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements")
	vtable.GetImageMemoryRequirements2                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements2")
	vtable.GetImageMemoryRequirements2KHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements2KHR")
	vtable.GetImageOpaqueCaptureDataEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageOpaqueCaptureDataEXT")
	vtable.GetImageOpaqueCaptureDescriptorDataEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageOpaqueCaptureDescriptorDataEXT")
	vtable.GetImageSparseMemoryRequirements                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements")
	vtable.GetImageSparseMemoryRequirements2                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements2")
	vtable.GetImageSparseMemoryRequirements2KHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements2KHR")
	vtable.GetImageSubresourceLayout                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout")
	vtable.GetImageSubresourceLayout2                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2")
	vtable.GetImageSubresourceLayout2EXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2EXT")
	vtable.GetImageSubresourceLayout2KHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2KHR")
	vtable.GetImageViewAddressNVX                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewAddressNVX")
	vtable.GetImageViewHandle64NVX                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewHandle64NVX")
	vtable.GetImageViewHandleNVX                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewHandleNVX")
	vtable.GetImageViewOpaqueCaptureDescriptorDataEXT             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewOpaqueCaptureDescriptorDataEXT")
	vtable.GetLatencyTimingsNV                                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetLatencyTimingsNV")
	vtable.GetMemoryAndroidHardwareBufferANDROID                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryAndroidHardwareBufferANDROID")
	vtable.GetMemoryFdKHR                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryFdKHR")
	vtable.GetMemoryFdPropertiesKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryFdPropertiesKHR")
	vtable.GetMemoryHostPointerPropertiesEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryHostPointerPropertiesEXT")
	vtable.GetMemoryMetalHandleEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryMetalHandleEXT")
	vtable.GetMemoryMetalHandlePropertiesEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryMetalHandlePropertiesEXT")
	vtable.GetMemoryRemoteAddressNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryRemoteAddressNV")
	vtable.GetMemoryWin32HandleKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandleKHR")
	vtable.GetMemoryWin32HandleNV                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandleNV")
	vtable.GetMemoryWin32HandlePropertiesKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandlePropertiesKHR")
	vtable.GetMicromapBuildSizesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMicromapBuildSizesEXT")
	vtable.GetPartitionedAccelerationStructuresBuildSizesNV       = auto_cast PtrGetDeviceProcAddr(device, "vkGetPartitionedAccelerationStructuresBuildSizesNV")
	vtable.GetPastPresentationTimingEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetPastPresentationTimingEXT")
	vtable.GetPastPresentationTimingGOOGLE                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetPastPresentationTimingGOOGLE")
	vtable.GetPerformanceParameterINTEL                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetPerformanceParameterINTEL")
	vtable.GetPipelineBinaryDataKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineBinaryDataKHR")
	vtable.GetPipelineCacheData                                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineCacheData")
	vtable.GetPipelineExecutableInternalRepresentationsKHR        = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutableInternalRepresentationsKHR")
	vtable.GetPipelineExecutablePropertiesKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutablePropertiesKHR")
	vtable.GetPipelineExecutableStatisticsKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutableStatisticsKHR")
	vtable.GetPipelineIndirectDeviceAddressNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineIndirectDeviceAddressNV")
	vtable.GetPipelineIndirectMemoryRequirementsNV                = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineIndirectMemoryRequirementsNV")
	vtable.GetPipelineKeyKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineKeyKHR")
	vtable.GetPipelinePropertiesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelinePropertiesEXT")
	vtable.GetPrivateData                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetPrivateData")
	vtable.GetPrivateDataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetPrivateDataEXT")
	vtable.GetQueryPoolResults                                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueryPoolResults")
	vtable.GetQueueCheckpointData2NV                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueueCheckpointData2NV")
	vtable.GetQueueCheckpointDataNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueueCheckpointDataNV")
	vtable.GetRayTracingCaptureReplayShaderGroupHandlesKHR        = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR")
	vtable.GetRayTracingShaderGroupHandlesKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupHandlesKHR")
	vtable.GetRayTracingShaderGroupHandlesNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupHandlesNV")
	vtable.GetRayTracingShaderGroupStackSizeKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupStackSizeKHR")
	vtable.GetRefreshCycleDurationGOOGLE                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetRefreshCycleDurationGOOGLE")
	vtable.GetRenderAreaGranularity                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderAreaGranularity")
	vtable.GetRenderingAreaGranularity                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderingAreaGranularity")
	vtable.GetRenderingAreaGranularityKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderingAreaGranularityKHR")
	vtable.GetSamplerOpaqueCaptureDescriptorDataEXT               = auto_cast PtrGetDeviceProcAddr(device, "vkGetSamplerOpaqueCaptureDescriptorDataEXT")
	vtable.GetSemaphoreCounterValue                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreCounterValue")
	vtable.GetSemaphoreCounterValueKHR                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreCounterValueKHR")
	vtable.GetSemaphoreFdKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreFdKHR")
	vtable.GetSemaphoreWin32HandleKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreWin32HandleKHR")
	vtable.GetShaderBinaryDataEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderBinaryDataEXT")
	vtable.GetShaderInfoAMD                                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderInfoAMD")
	vtable.GetShaderInstrumentationValuesARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderInstrumentationValuesARM")
	vtable.GetShaderModuleCreateInfoIdentifierEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderModuleCreateInfoIdentifierEXT")
	vtable.GetShaderModuleIdentifierEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderModuleIdentifierEXT")
	vtable.GetSwapchainCounterEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainCounterEXT")
	vtable.GetSwapchainImagesKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainImagesKHR")
	vtable.GetSwapchainStatusKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainStatusKHR")
	vtable.GetSwapchainTimeDomainPropertiesEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainTimeDomainPropertiesEXT")
	vtable.GetSwapchainTimingPropertiesEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainTimingPropertiesEXT")
	vtable.GetTensorMemoryRequirementsARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorMemoryRequirementsARM")
	vtable.GetTensorOpaqueCaptureDataARM                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorOpaqueCaptureDataARM")
	vtable.GetTensorOpaqueCaptureDescriptorDataARM                = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorOpaqueCaptureDescriptorDataARM")
	vtable.GetTensorViewOpaqueCaptureDescriptorDataARM            = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorViewOpaqueCaptureDescriptorDataARM")
	vtable.GetValidationCacheDataEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetValidationCacheDataEXT")
	vtable.GetVideoSessionMemoryRequirementsKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetVideoSessionMemoryRequirementsKHR")
	vtable.ImportFenceFdKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkImportFenceFdKHR")
	vtable.ImportFenceWin32HandleKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkImportFenceWin32HandleKHR")
	vtable.ImportSemaphoreFdKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkImportSemaphoreFdKHR")
	vtable.ImportSemaphoreWin32HandleKHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkImportSemaphoreWin32HandleKHR")
	vtable.InitializePerformanceApiINTEL                          = auto_cast PtrGetDeviceProcAddr(device, "vkInitializePerformanceApiINTEL")
	vtable.InvalidateMappedMemoryRanges                           = auto_cast PtrGetDeviceProcAddr(device, "vkInvalidateMappedMemoryRanges")
	vtable.LatencySleepNV                                         = auto_cast PtrGetDeviceProcAddr(device, "vkLatencySleepNV")
	vtable.MapMemory                                              = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory")
	vtable.MapMemory2                                             = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory2")
	vtable.MapMemory2KHR                                          = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory2KHR")
	vtable.MergePipelineCaches                                    = auto_cast PtrGetDeviceProcAddr(device, "vkMergePipelineCaches")
	vtable.MergeValidationCachesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkMergeValidationCachesEXT")
	vtable.QueueBeginDebugUtilsLabelEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkQueueBeginDebugUtilsLabelEXT")
	vtable.QueueBindSparse                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueueBindSparse")
	vtable.QueueEndDebugUtilsLabelEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkQueueEndDebugUtilsLabelEXT")
	vtable.QueueInsertDebugUtilsLabelEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkQueueInsertDebugUtilsLabelEXT")
	vtable.QueueNotifyOutOfBandNV                                 = auto_cast PtrGetDeviceProcAddr(device, "vkQueueNotifyOutOfBandNV")
	vtable.QueuePresentKHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueuePresentKHR")
	vtable.QueueSetPerformanceConfigurationINTEL                  = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSetPerformanceConfigurationINTEL")
	vtable.QueueSubmit                                            = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit")
	vtable.QueueSubmit2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit2")
	vtable.QueueSubmit2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit2KHR")
	vtable.QueueWaitIdle                                          = auto_cast PtrGetDeviceProcAddr(device, "vkQueueWaitIdle")
	vtable.RegisterCustomBorderColorEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterCustomBorderColorEXT")
	vtable.RegisterDeviceEventEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterDeviceEventEXT")
	vtable.RegisterDisplayEventEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterDisplayEventEXT")
	vtable.ReleaseCapturedPipelineDataKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseCapturedPipelineDataKHR")
	vtable.ReleaseFullScreenExclusiveModeEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseFullScreenExclusiveModeEXT")
	vtable.ReleasePerformanceConfigurationINTEL                   = auto_cast PtrGetDeviceProcAddr(device, "vkReleasePerformanceConfigurationINTEL")
	vtable.ReleaseProfilingLockKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseProfilingLockKHR")
	vtable.ReleaseSwapchainImagesEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseSwapchainImagesEXT")
	vtable.ReleaseSwapchainImagesKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseSwapchainImagesKHR")
	vtable.ResetCommandBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkResetCommandBuffer")
	vtable.ResetCommandPool                                       = auto_cast PtrGetDeviceProcAddr(device, "vkResetCommandPool")
	vtable.ResetDescriptorPool                                    = auto_cast PtrGetDeviceProcAddr(device, "vkResetDescriptorPool")
	vtable.ResetEvent                                             = auto_cast PtrGetDeviceProcAddr(device, "vkResetEvent")
	vtable.ResetFences                                            = auto_cast PtrGetDeviceProcAddr(device, "vkResetFences")
	vtable.ResetGpaSessionAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkResetGpaSessionAMD")
	vtable.ResetQueryPool                                         = auto_cast PtrGetDeviceProcAddr(device, "vkResetQueryPool")
	vtable.ResetQueryPoolEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkResetQueryPoolEXT")
	vtable.SetDebugUtilsObjectNameEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkSetDebugUtilsObjectNameEXT")
	vtable.SetDebugUtilsObjectTagEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkSetDebugUtilsObjectTagEXT")
	vtable.SetDeviceMemoryPriorityEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkSetDeviceMemoryPriorityEXT")
	vtable.SetEvent                                               = auto_cast PtrGetDeviceProcAddr(device, "vkSetEvent")
	vtable.SetGpaDeviceClockModeAMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkSetGpaDeviceClockModeAMD")
	vtable.SetHdrMetadataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkSetHdrMetadataEXT")
	vtable.SetLatencyMarkerNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSetLatencyMarkerNV")
	vtable.SetLatencySleepModeNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkSetLatencySleepModeNV")
	vtable.SetLocalDimmingAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSetLocalDimmingAMD")
	vtable.SetPrivateData                                         = auto_cast PtrGetDeviceProcAddr(device, "vkSetPrivateData")
	vtable.SetPrivateDataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkSetPrivateDataEXT")
	vtable.SetSwapchainPresentTimingQueueSizeEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkSetSwapchainPresentTimingQueueSizeEXT")
	vtable.SignalSemaphore                                        = auto_cast PtrGetDeviceProcAddr(device, "vkSignalSemaphore")
	vtable.SignalSemaphoreKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSignalSemaphoreKHR")
	vtable.TransitionImageLayout                                  = auto_cast PtrGetDeviceProcAddr(device, "vkTransitionImageLayout")
	vtable.TransitionImageLayoutEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkTransitionImageLayoutEXT")
	vtable.TrimCommandPool                                        = auto_cast PtrGetDeviceProcAddr(device, "vkTrimCommandPool")
	vtable.TrimCommandPoolKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkTrimCommandPoolKHR")
	vtable.UninitializePerformanceApiINTEL                        = auto_cast PtrGetDeviceProcAddr(device, "vkUninitializePerformanceApiINTEL")
	vtable.UnmapMemory                                            = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory")
	vtable.UnmapMemory2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory2")
	vtable.UnmapMemory2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory2KHR")
	vtable.UnregisterCustomBorderColorEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkUnregisterCustomBorderColorEXT")
	vtable.UpdateDescriptorSetWithTemplate                        = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSetWithTemplate")
	vtable.UpdateDescriptorSetWithTemplateKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSetWithTemplateKHR")
	vtable.UpdateDescriptorSets                                   = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSets")
	vtable.UpdateIndirectExecutionSetPipelineEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateIndirectExecutionSetPipelineEXT")
	vtable.UpdateIndirectExecutionSetShaderEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateIndirectExecutionSetShaderEXT")
	vtable.UpdateVideoSessionParametersKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateVideoSessionParametersKHR")
	vtable.WaitForFences                                          = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForFences")
	vtable.WaitForPresent2KHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForPresent2KHR")
	vtable.WaitForPresentKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForPresentKHR")
	vtable.WaitSemaphores                                         = auto_cast PtrGetDeviceProcAddr(device, "vkWaitSemaphores")
	vtable.WaitSemaphoresKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkWaitSemaphoresKHR")
	vtable.WriteAccelerationStructuresPropertiesKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkWriteAccelerationStructuresPropertiesKHR")
	vtable.WriteMicromapsPropertiesEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkWriteMicromapsPropertiesEXT")
	vtable.WriteResourceDescriptorsEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkWriteResourceDescriptorsEXT")
	vtable.WriteSamplerDescriptorsEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkWriteSamplerDescriptorsEXT")
}

load_proc_addresses_device :: proc(device: Device) {
	PtrAcquireFullScreenExclusiveModeEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireFullScreenExclusiveModeEXT")
	PtrAcquireNextImage2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireNextImage2KHR")
	PtrAcquireNextImageKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireNextImageKHR")
	PtrAcquirePerformanceConfigurationINTEL                   = auto_cast PtrGetDeviceProcAddr(device, "vkAcquirePerformanceConfigurationINTEL")
	PtrAcquireProfilingLockKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkAcquireProfilingLockKHR")
	PtrAllocateCommandBuffers                                 = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateCommandBuffers")
	PtrAllocateDescriptorSets                                 = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateDescriptorSets")
	PtrAllocateMemory                                         = auto_cast PtrGetDeviceProcAddr(device, "vkAllocateMemory")
	PtrAntiLagUpdateAMD                                       = auto_cast PtrGetDeviceProcAddr(device, "vkAntiLagUpdateAMD")
	PtrBeginCommandBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkBeginCommandBuffer")
	PtrBindAccelerationStructureMemoryNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkBindAccelerationStructureMemoryNV")
	PtrBindBufferMemory                                       = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory")
	PtrBindBufferMemory2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory2")
	PtrBindBufferMemory2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkBindBufferMemory2KHR")
	PtrBindDataGraphPipelineSessionMemoryARM                  = auto_cast PtrGetDeviceProcAddr(device, "vkBindDataGraphPipelineSessionMemoryARM")
	PtrBindImageMemory                                        = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory")
	PtrBindImageMemory2                                       = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory2")
	PtrBindImageMemory2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkBindImageMemory2KHR")
	PtrBindOpticalFlowSessionImageNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkBindOpticalFlowSessionImageNV")
	PtrBindTensorMemoryARM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkBindTensorMemoryARM")
	PtrBindVideoSessionMemoryKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkBindVideoSessionMemoryKHR")
	PtrBuildAccelerationStructuresKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkBuildAccelerationStructuresKHR")
	PtrBuildMicromapsEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkBuildMicromapsEXT")
	PtrClearShaderInstrumentationMetricsARM                   = auto_cast PtrGetDeviceProcAddr(device, "vkClearShaderInstrumentationMetricsARM")
	PtrCmdBeginConditionalRendering2EXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginConditionalRendering2EXT")
	PtrCmdBeginConditionalRenderingEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginConditionalRenderingEXT")
	PtrCmdBeginCustomResolveEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginCustomResolveEXT")
	PtrCmdBeginDebugUtilsLabelEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginDebugUtilsLabelEXT")
	PtrCmdBeginGpaSampleAMD                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginGpaSampleAMD")
	PtrCmdBeginGpaSessionAMD                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginGpaSessionAMD")
	PtrCmdBeginPerTileExecutionQCOM                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginPerTileExecutionQCOM")
	PtrCmdBeginQuery                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginQuery")
	PtrCmdBeginQueryIndexedEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginQueryIndexedEXT")
	PtrCmdBeginRenderPass                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass")
	PtrCmdBeginRenderPass2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass2")
	PtrCmdBeginRenderPass2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderPass2KHR")
	PtrCmdBeginRendering                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRendering")
	PtrCmdBeginRenderingKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginRenderingKHR")
	PtrCmdBeginShaderInstrumentationARM                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginShaderInstrumentationARM")
	PtrCmdBeginTransformFeedback2EXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginTransformFeedback2EXT")
	PtrCmdBeginTransformFeedbackEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginTransformFeedbackEXT")
	PtrCmdBeginVideoCodingKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBeginVideoCodingKHR")
	PtrCmdBindDescriptorBufferEmbeddedSamplers2EXT            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBufferEmbeddedSamplers2EXT")
	PtrCmdBindDescriptorBufferEmbeddedSamplersEXT             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBufferEmbeddedSamplersEXT")
	PtrCmdBindDescriptorBuffersEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorBuffersEXT")
	PtrCmdBindDescriptorSets                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets")
	PtrCmdBindDescriptorSets2                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets2")
	PtrCmdBindDescriptorSets2KHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindDescriptorSets2KHR")
	PtrCmdBindIndexBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer")
	PtrCmdBindIndexBuffer2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer2")
	PtrCmdBindIndexBuffer2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer2KHR")
	PtrCmdBindIndexBuffer3KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindIndexBuffer3KHR")
	PtrCmdBindInvocationMaskHUAWEI                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindInvocationMaskHUAWEI")
	PtrCmdBindPipeline                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindPipeline")
	PtrCmdBindPipelineShaderGroupNV                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindPipelineShaderGroupNV")
	PtrCmdBindResourceHeapEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindResourceHeapEXT")
	PtrCmdBindSamplerHeapEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindSamplerHeapEXT")
	PtrCmdBindShadersEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindShadersEXT")
	PtrCmdBindShadingRateImageNV                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindShadingRateImageNV")
	PtrCmdBindTileMemoryQCOM                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTileMemoryQCOM")
	PtrCmdBindTransformFeedbackBuffers2EXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTransformFeedbackBuffers2EXT")
	PtrCmdBindTransformFeedbackBuffersEXT                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindTransformFeedbackBuffersEXT")
	PtrCmdBindVertexBuffers                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers")
	PtrCmdBindVertexBuffers2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers2")
	PtrCmdBindVertexBuffers2EXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers2EXT")
	PtrCmdBindVertexBuffers3KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBindVertexBuffers3KHR")
	PtrCmdBlitImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage")
	PtrCmdBlitImage2                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage2")
	PtrCmdBlitImage2KHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBlitImage2KHR")
	PtrCmdBuildAccelerationStructureNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructureNV")
	PtrCmdBuildAccelerationStructuresIndirectKHR              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructuresIndirectKHR")
	PtrCmdBuildAccelerationStructuresKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildAccelerationStructuresKHR")
	PtrCmdBuildClusterAccelerationStructureIndirectNV         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildClusterAccelerationStructureIndirectNV")
	PtrCmdBuildMicromapsEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildMicromapsEXT")
	PtrCmdBuildPartitionedAccelerationStructuresNV            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdBuildPartitionedAccelerationStructuresNV")
	PtrCmdClearAttachments                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearAttachments")
	PtrCmdClearColorImage                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearColorImage")
	PtrCmdClearDepthStencilImage                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdClearDepthStencilImage")
	PtrCmdControlVideoCodingKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdControlVideoCodingKHR")
	PtrCmdConvertCooperativeVectorMatrixNV                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdConvertCooperativeVectorMatrixNV")
	PtrCmdCopyAccelerationStructureKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureKHR")
	PtrCmdCopyAccelerationStructureNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureNV")
	PtrCmdCopyAccelerationStructureToMemoryKHR                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyAccelerationStructureToMemoryKHR")
	PtrCmdCopyBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer")
	PtrCmdCopyBuffer2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer2")
	PtrCmdCopyBuffer2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBuffer2KHR")
	PtrCmdCopyBufferToImage                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage")
	PtrCmdCopyBufferToImage2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage2")
	PtrCmdCopyBufferToImage2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyBufferToImage2KHR")
	PtrCmdCopyGpaSessionResultsAMD                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyGpaSessionResultsAMD")
	PtrCmdCopyImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage")
	PtrCmdCopyImage2                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage2")
	PtrCmdCopyImage2KHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImage2KHR")
	PtrCmdCopyImageToBuffer                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer")
	PtrCmdCopyImageToBuffer2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer2")
	PtrCmdCopyImageToBuffer2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToBuffer2KHR")
	PtrCmdCopyImageToMemoryKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyImageToMemoryKHR")
	PtrCmdCopyMemoryIndirectKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryIndirectKHR")
	PtrCmdCopyMemoryIndirectNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryIndirectNV")
	PtrCmdCopyMemoryKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryKHR")
	PtrCmdCopyMemoryToAccelerationStructureKHR                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToAccelerationStructureKHR")
	PtrCmdCopyMemoryToImageIndirectKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageIndirectKHR")
	PtrCmdCopyMemoryToImageIndirectNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageIndirectNV")
	PtrCmdCopyMemoryToImageKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToImageKHR")
	PtrCmdCopyMemoryToMicromapEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMemoryToMicromapEXT")
	PtrCmdCopyMicromapEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMicromapEXT")
	PtrCmdCopyMicromapToMemoryEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyMicromapToMemoryEXT")
	PtrCmdCopyQueryPoolResults                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyQueryPoolResults")
	PtrCmdCopyQueryPoolResultsToMemoryKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyQueryPoolResultsToMemoryKHR")
	PtrCmdCopyTensorARM                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCopyTensorARM")
	PtrCmdCuLaunchKernelNVX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCuLaunchKernelNVX")
	PtrCmdCudaLaunchKernelNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdCudaLaunchKernelNV")
	PtrCmdDebugMarkerBeginEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerBeginEXT")
	PtrCmdDebugMarkerEndEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerEndEXT")
	PtrCmdDebugMarkerInsertEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDebugMarkerInsertEXT")
	PtrCmdDecodeVideoKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecodeVideoKHR")
	PtrCmdDecompressMemoryEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryEXT")
	PtrCmdDecompressMemoryIndirectCountEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryIndirectCountEXT")
	PtrCmdDecompressMemoryIndirectCountNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryIndirectCountNV")
	PtrCmdDecompressMemoryNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDecompressMemoryNV")
	PtrCmdDispatch                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatch")
	PtrCmdDispatchBase                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchBase")
	PtrCmdDispatchBaseKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchBaseKHR")
	PtrCmdDispatchDataGraphARM                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchDataGraphARM")
	PtrCmdDispatchGraphAMDX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphAMDX")
	PtrCmdDispatchGraphIndirectAMDX                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphIndirectAMDX")
	PtrCmdDispatchGraphIndirectCountAMDX                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchGraphIndirectCountAMDX")
	PtrCmdDispatchIndirect                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchIndirect")
	PtrCmdDispatchIndirect2KHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchIndirect2KHR")
	PtrCmdDispatchTileQCOM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDispatchTileQCOM")
	PtrCmdDraw                                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDraw")
	PtrCmdDrawClusterHUAWEI                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawClusterHUAWEI")
	PtrCmdDrawClusterIndirectHUAWEI                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawClusterIndirectHUAWEI")
	PtrCmdDrawIndexed                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexed")
	PtrCmdDrawIndexedIndirect                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirect")
	PtrCmdDrawIndexedIndirect2KHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirect2KHR")
	PtrCmdDrawIndexedIndirectCount                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCount")
	PtrCmdDrawIndexedIndirectCount2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCount2KHR")
	PtrCmdDrawIndexedIndirectCountAMD                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCountAMD")
	PtrCmdDrawIndexedIndirectCountKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndexedIndirectCountKHR")
	PtrCmdDrawIndirect                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirect")
	PtrCmdDrawIndirect2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirect2KHR")
	PtrCmdDrawIndirectByteCount2EXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectByteCount2EXT")
	PtrCmdDrawIndirectByteCountEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectByteCountEXT")
	PtrCmdDrawIndirectCount                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCount")
	PtrCmdDrawIndirectCount2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCount2KHR")
	PtrCmdDrawIndirectCountAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCountAMD")
	PtrCmdDrawIndirectCountKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawIndirectCountKHR")
	PtrCmdDrawMeshTasksEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksEXT")
	PtrCmdDrawMeshTasksIndirect2EXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirect2EXT")
	PtrCmdDrawMeshTasksIndirectCount2EXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCount2EXT")
	PtrCmdDrawMeshTasksIndirectCountEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCountEXT")
	PtrCmdDrawMeshTasksIndirectCountNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectCountNV")
	PtrCmdDrawMeshTasksIndirectEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectEXT")
	PtrCmdDrawMeshTasksIndirectNV                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksIndirectNV")
	PtrCmdDrawMeshTasksNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMeshTasksNV")
	PtrCmdDrawMultiEXT                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMultiEXT")
	PtrCmdDrawMultiIndexedEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdDrawMultiIndexedEXT")
	PtrCmdEncodeVideoKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEncodeVideoKHR")
	PtrCmdEndConditionalRenderingEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndConditionalRenderingEXT")
	PtrCmdEndDebugUtilsLabelEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndDebugUtilsLabelEXT")
	PtrCmdEndGpaSampleAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndGpaSampleAMD")
	PtrCmdEndGpaSessionAMD                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndGpaSessionAMD")
	PtrCmdEndPerTileExecutionQCOM                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndPerTileExecutionQCOM")
	PtrCmdEndQuery                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndQuery")
	PtrCmdEndQueryIndexedEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndQueryIndexedEXT")
	PtrCmdEndRenderPass                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass")
	PtrCmdEndRenderPass2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass2")
	PtrCmdEndRenderPass2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderPass2KHR")
	PtrCmdEndRendering                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering")
	PtrCmdEndRendering2EXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering2EXT")
	PtrCmdEndRendering2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRendering2KHR")
	PtrCmdEndRenderingKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndRenderingKHR")
	PtrCmdEndShaderInstrumentationARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndShaderInstrumentationARM")
	PtrCmdEndTransformFeedback2EXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndTransformFeedback2EXT")
	PtrCmdEndTransformFeedbackEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndTransformFeedbackEXT")
	PtrCmdEndVideoCodingKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdEndVideoCodingKHR")
	PtrCmdExecuteCommands                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteCommands")
	PtrCmdExecuteGeneratedCommandsEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteGeneratedCommandsEXT")
	PtrCmdExecuteGeneratedCommandsNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdExecuteGeneratedCommandsNV")
	PtrCmdFillBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdFillBuffer")
	PtrCmdFillMemoryKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdFillMemoryKHR")
	PtrCmdInitializeGraphScratchMemoryAMDX                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdInitializeGraphScratchMemoryAMDX")
	PtrCmdInsertDebugUtilsLabelEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdInsertDebugUtilsLabelEXT")
	PtrCmdNextSubpass                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass")
	PtrCmdNextSubpass2                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass2")
	PtrCmdNextSubpass2KHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdNextSubpass2KHR")
	PtrCmdOpticalFlowExecuteNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdOpticalFlowExecuteNV")
	PtrCmdPipelineBarrier                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier")
	PtrCmdPipelineBarrier2                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier2")
	PtrCmdPipelineBarrier2KHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPipelineBarrier2KHR")
	PtrCmdPreprocessGeneratedCommandsEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPreprocessGeneratedCommandsEXT")
	PtrCmdPreprocessGeneratedCommandsNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPreprocessGeneratedCommandsNV")
	PtrCmdPushConstants                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants")
	PtrCmdPushConstants2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants2")
	PtrCmdPushConstants2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushConstants2KHR")
	PtrCmdPushDataEXT                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDataEXT")
	PtrCmdPushDescriptorSet                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet")
	PtrCmdPushDescriptorSet2                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet2")
	PtrCmdPushDescriptorSet2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSet2KHR")
	PtrCmdPushDescriptorSetKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetKHR")
	PtrCmdPushDescriptorSetWithTemplate                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate")
	PtrCmdPushDescriptorSetWithTemplate2                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate2")
	PtrCmdPushDescriptorSetWithTemplate2KHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplate2KHR")
	PtrCmdPushDescriptorSetWithTemplateKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdPushDescriptorSetWithTemplateKHR")
	PtrCmdResetEvent                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent")
	PtrCmdResetEvent2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent2")
	PtrCmdResetEvent2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetEvent2KHR")
	PtrCmdResetQueryPool                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResetQueryPool")
	PtrCmdResolveImage                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage")
	PtrCmdResolveImage2                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage2")
	PtrCmdResolveImage2KHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdResolveImage2KHR")
	PtrCmdSetAlphaToCoverageEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAlphaToCoverageEnableEXT")
	PtrCmdSetAlphaToOneEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAlphaToOneEnableEXT")
	PtrCmdSetAttachmentFeedbackLoopEnableEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetAttachmentFeedbackLoopEnableEXT")
	PtrCmdSetBlendConstants                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetBlendConstants")
	PtrCmdSetCheckpointNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCheckpointNV")
	PtrCmdSetCoarseSampleOrderNV                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoarseSampleOrderNV")
	PtrCmdSetColorBlendAdvancedEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendAdvancedEXT")
	PtrCmdSetColorBlendEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendEnableEXT")
	PtrCmdSetColorBlendEquationEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorBlendEquationEXT")
	PtrCmdSetColorWriteEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorWriteEnableEXT")
	PtrCmdSetColorWriteMaskEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetColorWriteMaskEXT")
	PtrCmdSetComputeOccupancyPriorityNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetComputeOccupancyPriorityNV")
	PtrCmdSetConservativeRasterizationModeEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetConservativeRasterizationModeEXT")
	PtrCmdSetCoverageModulationModeNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationModeNV")
	PtrCmdSetCoverageModulationTableEnableNV                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationTableEnableNV")
	PtrCmdSetCoverageModulationTableNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageModulationTableNV")
	PtrCmdSetCoverageReductionModeNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageReductionModeNV")
	PtrCmdSetCoverageToColorEnableNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageToColorEnableNV")
	PtrCmdSetCoverageToColorLocationNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCoverageToColorLocationNV")
	PtrCmdSetCullMode                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCullMode")
	PtrCmdSetCullModeEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetCullModeEXT")
	PtrCmdSetDepthBias                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBias")
	PtrCmdSetDepthBias2EXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBias2EXT")
	PtrCmdSetDepthBiasEnable                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBiasEnable")
	PtrCmdSetDepthBiasEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBiasEnableEXT")
	PtrCmdSetDepthBounds                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBounds")
	PtrCmdSetDepthBoundsTestEnable                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBoundsTestEnable")
	PtrCmdSetDepthBoundsTestEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthBoundsTestEnableEXT")
	PtrCmdSetDepthClampEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClampEnableEXT")
	PtrCmdSetDepthClampRangeEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClampRangeEXT")
	PtrCmdSetDepthClipEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClipEnableEXT")
	PtrCmdSetDepthClipNegativeOneToOneEXT                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthClipNegativeOneToOneEXT")
	PtrCmdSetDepthCompareOp                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthCompareOp")
	PtrCmdSetDepthCompareOpEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthCompareOpEXT")
	PtrCmdSetDepthTestEnable                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthTestEnable")
	PtrCmdSetDepthTestEnableEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthTestEnableEXT")
	PtrCmdSetDepthWriteEnable                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthWriteEnable")
	PtrCmdSetDepthWriteEnableEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDepthWriteEnableEXT")
	PtrCmdSetDescriptorBufferOffsets2EXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDescriptorBufferOffsets2EXT")
	PtrCmdSetDescriptorBufferOffsetsEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDescriptorBufferOffsetsEXT")
	PtrCmdSetDeviceMask                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDeviceMask")
	PtrCmdSetDeviceMaskKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDeviceMaskKHR")
	PtrCmdSetDiscardRectangleEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleEXT")
	PtrCmdSetDiscardRectangleEnableEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleEnableEXT")
	PtrCmdSetDiscardRectangleModeEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDiscardRectangleModeEXT")
	PtrCmdSetDispatchParametersARM                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetDispatchParametersARM")
	PtrCmdSetEvent                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent")
	PtrCmdSetEvent2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent2")
	PtrCmdSetEvent2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetEvent2KHR")
	PtrCmdSetExclusiveScissorEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExclusiveScissorEnableNV")
	PtrCmdSetExclusiveScissorNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExclusiveScissorNV")
	PtrCmdSetExtraPrimitiveOverestimationSizeEXT              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetExtraPrimitiveOverestimationSizeEXT")
	PtrCmdSetFragmentShadingRateEnumNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFragmentShadingRateEnumNV")
	PtrCmdSetFragmentShadingRateKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFragmentShadingRateKHR")
	PtrCmdSetFrontFace                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFrontFace")
	PtrCmdSetFrontFaceEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetFrontFaceEXT")
	PtrCmdSetLineRasterizationModeEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineRasterizationModeEXT")
	PtrCmdSetLineStipple                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStipple")
	PtrCmdSetLineStippleEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleEXT")
	PtrCmdSetLineStippleEnableEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleEnableEXT")
	PtrCmdSetLineStippleKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineStippleKHR")
	PtrCmdSetLineWidth                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLineWidth")
	PtrCmdSetLogicOpEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLogicOpEXT")
	PtrCmdSetLogicOpEnableEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetLogicOpEnableEXT")
	PtrCmdSetPatchControlPointsEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPatchControlPointsEXT")
	PtrCmdSetPerformanceMarkerINTEL                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceMarkerINTEL")
	PtrCmdSetPerformanceOverrideINTEL                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceOverrideINTEL")
	PtrCmdSetPerformanceStreamMarkerINTEL                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPerformanceStreamMarkerINTEL")
	PtrCmdSetPolygonModeEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPolygonModeEXT")
	PtrCmdSetPrimitiveRestartEnable                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartEnable")
	PtrCmdSetPrimitiveRestartEnableEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartEnableEXT")
	PtrCmdSetPrimitiveRestartIndexEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveRestartIndexEXT")
	PtrCmdSetPrimitiveTopology                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveTopology")
	PtrCmdSetPrimitiveTopologyEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetPrimitiveTopologyEXT")
	PtrCmdSetProvokingVertexModeEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetProvokingVertexModeEXT")
	PtrCmdSetRasterizationSamplesEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizationSamplesEXT")
	PtrCmdSetRasterizationStreamEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizationStreamEXT")
	PtrCmdSetRasterizerDiscardEnable                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizerDiscardEnable")
	PtrCmdSetRasterizerDiscardEnableEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRasterizerDiscardEnableEXT")
	PtrCmdSetRayTracingPipelineStackSizeKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRayTracingPipelineStackSizeKHR")
	PtrCmdSetRenderingAttachmentLocations                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingAttachmentLocations")
	PtrCmdSetRenderingAttachmentLocationsKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingAttachmentLocationsKHR")
	PtrCmdSetRenderingInputAttachmentIndices                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingInputAttachmentIndices")
	PtrCmdSetRenderingInputAttachmentIndicesKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRenderingInputAttachmentIndicesKHR")
	PtrCmdSetRepresentativeFragmentTestEnableNV               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetRepresentativeFragmentTestEnableNV")
	PtrCmdSetSampleLocationsEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleLocationsEXT")
	PtrCmdSetSampleLocationsEnableEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleLocationsEnableEXT")
	PtrCmdSetSampleMaskEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetSampleMaskEXT")
	PtrCmdSetScissor                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissor")
	PtrCmdSetScissorWithCount                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissorWithCount")
	PtrCmdSetScissorWithCountEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetScissorWithCountEXT")
	PtrCmdSetShadingRateImageEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetShadingRateImageEnableNV")
	PtrCmdSetStencilCompareMask                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilCompareMask")
	PtrCmdSetStencilOp                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilOp")
	PtrCmdSetStencilOpEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilOpEXT")
	PtrCmdSetStencilReference                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilReference")
	PtrCmdSetStencilTestEnable                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilTestEnable")
	PtrCmdSetStencilTestEnableEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilTestEnableEXT")
	PtrCmdSetStencilWriteMask                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetStencilWriteMask")
	PtrCmdSetTessellationDomainOriginEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetTessellationDomainOriginEXT")
	PtrCmdSetVertexInputEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetVertexInputEXT")
	PtrCmdSetViewport                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewport")
	PtrCmdSetViewportShadingRatePaletteNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportShadingRatePaletteNV")
	PtrCmdSetViewportSwizzleNV                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportSwizzleNV")
	PtrCmdSetViewportWScalingEnableNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWScalingEnableNV")
	PtrCmdSetViewportWScalingNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWScalingNV")
	PtrCmdSetViewportWithCount                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWithCount")
	PtrCmdSetViewportWithCountEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSetViewportWithCountEXT")
	PtrCmdSubpassShadingHUAWEI                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdSubpassShadingHUAWEI")
	PtrCmdTraceRaysIndirect2KHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysIndirect2KHR")
	PtrCmdTraceRaysIndirectKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysIndirectKHR")
	PtrCmdTraceRaysKHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysKHR")
	PtrCmdTraceRaysNV                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdTraceRaysNV")
	PtrCmdUpdateBuffer                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdateBuffer")
	PtrCmdUpdateMemoryKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdateMemoryKHR")
	PtrCmdUpdatePipelineIndirectBufferNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdUpdatePipelineIndirectBufferNV")
	PtrCmdWaitEvents                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents")
	PtrCmdWaitEvents2                                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents2")
	PtrCmdWaitEvents2KHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWaitEvents2KHR")
	PtrCmdWriteAccelerationStructuresPropertiesKHR            = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteAccelerationStructuresPropertiesKHR")
	PtrCmdWriteAccelerationStructuresPropertiesNV             = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteAccelerationStructuresPropertiesNV")
	PtrCmdWriteBufferMarker2AMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteBufferMarker2AMD")
	PtrCmdWriteBufferMarkerAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteBufferMarkerAMD")
	PtrCmdWriteMarkerToMemoryAMD                              = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteMarkerToMemoryAMD")
	PtrCmdWriteMicromapsPropertiesEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteMicromapsPropertiesEXT")
	PtrCmdWriteTimestamp                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp")
	PtrCmdWriteTimestamp2                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp2")
	PtrCmdWriteTimestamp2KHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCmdWriteTimestamp2KHR")
	PtrCompileDeferredNV                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCompileDeferredNV")
	PtrConvertCooperativeVectorMatrixNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkConvertCooperativeVectorMatrixNV")
	PtrCopyAccelerationStructureKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCopyAccelerationStructureKHR")
	PtrCopyAccelerationStructureToMemoryKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyAccelerationStructureToMemoryKHR")
	PtrCopyImageToImage                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToImage")
	PtrCopyImageToImageEXT                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToImageEXT")
	PtrCopyImageToMemory                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToMemory")
	PtrCopyImageToMemoryEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyImageToMemoryEXT")
	PtrCopyMemoryToAccelerationStructureKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToAccelerationStructureKHR")
	PtrCopyMemoryToImage                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToImage")
	PtrCopyMemoryToImageEXT                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToImageEXT")
	PtrCopyMemoryToMicromapEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMemoryToMicromapEXT")
	PtrCopyMicromapEXT                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMicromapEXT")
	PtrCopyMicromapToMemoryEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkCopyMicromapToMemoryEXT")
	PtrCreateAccelerationStructure2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructure2KHR")
	PtrCreateAccelerationStructureKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructureKHR")
	PtrCreateAccelerationStructureNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateAccelerationStructureNV")
	PtrCreateBuffer                                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateBuffer")
	PtrCreateBufferView                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateBufferView")
	PtrCreateCommandPool                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCommandPool")
	PtrCreateComputePipelines                                 = auto_cast PtrGetDeviceProcAddr(device, "vkCreateComputePipelines")
	PtrCreateCuFunctionNVX                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCuFunctionNVX")
	PtrCreateCuModuleNVX                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCuModuleNVX")
	PtrCreateCudaFunctionNV                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCudaFunctionNV")
	PtrCreateCudaModuleNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateCudaModuleNV")
	PtrCreateDataGraphPipelineSessionARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDataGraphPipelineSessionARM")
	PtrCreateDataGraphPipelinesARM                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDataGraphPipelinesARM")
	PtrCreateDeferredOperationKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDeferredOperationKHR")
	PtrCreateDescriptorPool                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorPool")
	PtrCreateDescriptorSetLayout                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorSetLayout")
	PtrCreateDescriptorUpdateTemplate                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorUpdateTemplate")
	PtrCreateDescriptorUpdateTemplateKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateDescriptorUpdateTemplateKHR")
	PtrCreateEvent                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateEvent")
	PtrCreateExecutionGraphPipelinesAMDX                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateExecutionGraphPipelinesAMDX")
	PtrCreateExternalComputeQueueNV                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateExternalComputeQueueNV")
	PtrCreateFence                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateFence")
	PtrCreateFramebuffer                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateFramebuffer")
	PtrCreateGpaSessionAMD                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateGpaSessionAMD")
	PtrCreateGraphicsPipelines                                = auto_cast PtrGetDeviceProcAddr(device, "vkCreateGraphicsPipelines")
	PtrCreateImage                                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateImage")
	PtrCreateImageView                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateImageView")
	PtrCreateIndirectCommandsLayoutEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectCommandsLayoutEXT")
	PtrCreateIndirectCommandsLayoutNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectCommandsLayoutNV")
	PtrCreateIndirectExecutionSetEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateIndirectExecutionSetEXT")
	PtrCreateMicromapEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateMicromapEXT")
	PtrCreateOpticalFlowSessionNV                             = auto_cast PtrGetDeviceProcAddr(device, "vkCreateOpticalFlowSessionNV")
	PtrCreatePipelineBinariesKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineBinariesKHR")
	PtrCreatePipelineCache                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineCache")
	PtrCreatePipelineLayout                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePipelineLayout")
	PtrCreatePrivateDataSlot                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePrivateDataSlot")
	PtrCreatePrivateDataSlotEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCreatePrivateDataSlotEXT")
	PtrCreateQueryPool                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateQueryPool")
	PtrCreateRayTracingPipelinesKHR                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRayTracingPipelinesKHR")
	PtrCreateRayTracingPipelinesNV                            = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRayTracingPipelinesNV")
	PtrCreateRenderPass                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass")
	PtrCreateRenderPass2                                      = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass2")
	PtrCreateRenderPass2KHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkCreateRenderPass2KHR")
	PtrCreateSampler                                          = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSampler")
	PtrCreateSamplerYcbcrConversion                           = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSamplerYcbcrConversion")
	PtrCreateSamplerYcbcrConversionKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSamplerYcbcrConversionKHR")
	PtrCreateSemaphore                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSemaphore")
	PtrCreateShaderInstrumentationARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShaderInstrumentationARM")
	PtrCreateShaderModule                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShaderModule")
	PtrCreateShadersEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkCreateShadersEXT")
	PtrCreateSharedSwapchainsKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSharedSwapchainsKHR")
	PtrCreateSwapchainKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkCreateSwapchainKHR")
	PtrCreateTensorARM                                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateTensorARM")
	PtrCreateTensorViewARM                                    = auto_cast PtrGetDeviceProcAddr(device, "vkCreateTensorViewARM")
	PtrCreateValidationCacheEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkCreateValidationCacheEXT")
	PtrCreateVideoSessionKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkCreateVideoSessionKHR")
	PtrCreateVideoSessionParametersKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkCreateVideoSessionParametersKHR")
	PtrDebugMarkerSetObjectNameEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkDebugMarkerSetObjectNameEXT")
	PtrDebugMarkerSetObjectTagEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkDebugMarkerSetObjectTagEXT")
	PtrDeferredOperationJoinKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkDeferredOperationJoinKHR")
	PtrDestroyAccelerationStructureKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyAccelerationStructureKHR")
	PtrDestroyAccelerationStructureNV                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyAccelerationStructureNV")
	PtrDestroyBuffer                                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyBuffer")
	PtrDestroyBufferView                                      = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyBufferView")
	PtrDestroyCommandPool                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCommandPool")
	PtrDestroyCuFunctionNVX                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCuFunctionNVX")
	PtrDestroyCuModuleNVX                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCuModuleNVX")
	PtrDestroyCudaFunctionNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCudaFunctionNV")
	PtrDestroyCudaModuleNV                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyCudaModuleNV")
	PtrDestroyDataGraphPipelineSessionARM                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDataGraphPipelineSessionARM")
	PtrDestroyDeferredOperationKHR                            = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDeferredOperationKHR")
	PtrDestroyDescriptorPool                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorPool")
	PtrDestroyDescriptorSetLayout                             = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorSetLayout")
	PtrDestroyDescriptorUpdateTemplate                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorUpdateTemplate")
	PtrDestroyDescriptorUpdateTemplateKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDescriptorUpdateTemplateKHR")
	PtrDestroyDevice                                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyDevice")
	PtrDestroyEvent                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyEvent")
	PtrDestroyExternalComputeQueueNV                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyExternalComputeQueueNV")
	PtrDestroyFence                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyFence")
	PtrDestroyFramebuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyFramebuffer")
	PtrDestroyGpaSessionAMD                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyGpaSessionAMD")
	PtrDestroyImage                                           = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyImage")
	PtrDestroyImageView                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyImageView")
	PtrDestroyIndirectCommandsLayoutEXT                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectCommandsLayoutEXT")
	PtrDestroyIndirectCommandsLayoutNV                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectCommandsLayoutNV")
	PtrDestroyIndirectExecutionSetEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyIndirectExecutionSetEXT")
	PtrDestroyMicromapEXT                                     = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyMicromapEXT")
	PtrDestroyOpticalFlowSessionNV                            = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyOpticalFlowSessionNV")
	PtrDestroyPipeline                                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipeline")
	PtrDestroyPipelineBinaryKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineBinaryKHR")
	PtrDestroyPipelineCache                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineCache")
	PtrDestroyPipelineLayout                                  = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPipelineLayout")
	PtrDestroyPrivateDataSlot                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPrivateDataSlot")
	PtrDestroyPrivateDataSlotEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyPrivateDataSlotEXT")
	PtrDestroyQueryPool                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyQueryPool")
	PtrDestroyRenderPass                                      = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyRenderPass")
	PtrDestroySampler                                         = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySampler")
	PtrDestroySamplerYcbcrConversion                          = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySamplerYcbcrConversion")
	PtrDestroySamplerYcbcrConversionKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySamplerYcbcrConversionKHR")
	PtrDestroySemaphore                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySemaphore")
	PtrDestroyShaderEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderEXT")
	PtrDestroyShaderInstrumentationARM                        = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderInstrumentationARM")
	PtrDestroyShaderModule                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyShaderModule")
	PtrDestroySwapchainKHR                                    = auto_cast PtrGetDeviceProcAddr(device, "vkDestroySwapchainKHR")
	PtrDestroyTensorARM                                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyTensorARM")
	PtrDestroyTensorViewARM                                   = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyTensorViewARM")
	PtrDestroyValidationCacheEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyValidationCacheEXT")
	PtrDestroyVideoSessionKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyVideoSessionKHR")
	PtrDestroyVideoSessionParametersKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkDestroyVideoSessionParametersKHR")
	PtrDeviceWaitIdle                                         = auto_cast PtrGetDeviceProcAddr(device, "vkDeviceWaitIdle")
	PtrDisplayPowerControlEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkDisplayPowerControlEXT")
	PtrEndCommandBuffer                                       = auto_cast PtrGetDeviceProcAddr(device, "vkEndCommandBuffer")
	PtrExportMetalObjectsEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkExportMetalObjectsEXT")
	PtrFlushMappedMemoryRanges                                = auto_cast PtrGetDeviceProcAddr(device, "vkFlushMappedMemoryRanges")
	PtrFreeCommandBuffers                                     = auto_cast PtrGetDeviceProcAddr(device, "vkFreeCommandBuffers")
	PtrFreeDescriptorSets                                     = auto_cast PtrGetDeviceProcAddr(device, "vkFreeDescriptorSets")
	PtrFreeMemory                                             = auto_cast PtrGetDeviceProcAddr(device, "vkFreeMemory")
	PtrGetAccelerationStructureBuildSizesKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureBuildSizesKHR")
	PtrGetAccelerationStructureDeviceAddressKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureDeviceAddressKHR")
	PtrGetAccelerationStructureHandleNV                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureHandleNV")
	PtrGetAccelerationStructureMemoryRequirementsNV           = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureMemoryRequirementsNV")
	PtrGetAccelerationStructureOpaqueCaptureDescriptorDataEXT = auto_cast PtrGetDeviceProcAddr(device, "vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT")
	PtrGetAndroidHardwareBufferPropertiesANDROID              = auto_cast PtrGetDeviceProcAddr(device, "vkGetAndroidHardwareBufferPropertiesANDROID")
	PtrGetBufferDeviceAddress                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddress")
	PtrGetBufferDeviceAddressEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddressEXT")
	PtrGetBufferDeviceAddressKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferDeviceAddressKHR")
	PtrGetBufferMemoryRequirements                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements")
	PtrGetBufferMemoryRequirements2                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements2")
	PtrGetBufferMemoryRequirements2KHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferMemoryRequirements2KHR")
	PtrGetBufferOpaqueCaptureAddress                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureAddress")
	PtrGetBufferOpaqueCaptureAddressKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureAddressKHR")
	PtrGetBufferOpaqueCaptureDescriptorDataEXT                = auto_cast PtrGetDeviceProcAddr(device, "vkGetBufferOpaqueCaptureDescriptorDataEXT")
	PtrGetCalibratedTimestampsEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetCalibratedTimestampsEXT")
	PtrGetCalibratedTimestampsKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetCalibratedTimestampsKHR")
	PtrGetClusterAccelerationStructureBuildSizesNV            = auto_cast PtrGetDeviceProcAddr(device, "vkGetClusterAccelerationStructureBuildSizesNV")
	PtrGetCudaModuleCacheNV                                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetCudaModuleCacheNV")
	PtrGetDataGraphPipelineAvailablePropertiesARM             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineAvailablePropertiesARM")
	PtrGetDataGraphPipelinePropertiesARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelinePropertiesARM")
	PtrGetDataGraphPipelineSessionBindPointRequirementsARM    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineSessionBindPointRequirementsARM")
	PtrGetDataGraphPipelineSessionMemoryRequirementsARM       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDataGraphPipelineSessionMemoryRequirementsARM")
	PtrGetDeferredOperationMaxConcurrencyKHR                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeferredOperationMaxConcurrencyKHR")
	PtrGetDeferredOperationResultKHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeferredOperationResultKHR")
	PtrGetDescriptorEXT                                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorEXT")
	PtrGetDescriptorSetHostMappingVALVE                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetHostMappingVALVE")
	PtrGetDescriptorSetLayoutBindingOffsetEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutBindingOffsetEXT")
	PtrGetDescriptorSetLayoutHostMappingInfoVALVE             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutHostMappingInfoVALVE")
	PtrGetDescriptorSetLayoutSizeEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSizeEXT")
	PtrGetDescriptorSetLayoutSupport                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSupport")
	PtrGetDescriptorSetLayoutSupportKHR                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDescriptorSetLayoutSupportKHR")
	PtrGetDeviceAccelerationStructureCompatibilityKHR         = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceAccelerationStructureCompatibilityKHR")
	PtrGetDeviceBufferMemoryRequirements                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceBufferMemoryRequirements")
	PtrGetDeviceBufferMemoryRequirementsKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceBufferMemoryRequirementsKHR")
	PtrGetDeviceCombinedImageSamplerIndexNVX                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceCombinedImageSamplerIndexNVX")
	PtrGetDeviceFaultDebugInfoKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultDebugInfoKHR")
	PtrGetDeviceFaultInfoEXT                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultInfoEXT")
	PtrGetDeviceFaultReportsKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceFaultReportsKHR")
	PtrGetDeviceGroupPeerMemoryFeatures                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPeerMemoryFeatures")
	PtrGetDeviceGroupPeerMemoryFeaturesKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPeerMemoryFeaturesKHR")
	PtrGetDeviceGroupPresentCapabilitiesKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupPresentCapabilitiesKHR")
	PtrGetDeviceGroupSurfacePresentModes2EXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupSurfacePresentModes2EXT")
	PtrGetDeviceGroupSurfacePresentModesKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceGroupSurfacePresentModesKHR")
	PtrGetDeviceImageMemoryRequirements                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageMemoryRequirements")
	PtrGetDeviceImageMemoryRequirementsKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageMemoryRequirementsKHR")
	PtrGetDeviceImageSparseMemoryRequirements                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSparseMemoryRequirements")
	PtrGetDeviceImageSparseMemoryRequirementsKHR              = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSparseMemoryRequirementsKHR")
	PtrGetDeviceImageSubresourceLayout                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSubresourceLayout")
	PtrGetDeviceImageSubresourceLayoutKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceImageSubresourceLayoutKHR")
	PtrGetDeviceMemoryCommitment                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryCommitment")
	PtrGetDeviceMemoryOpaqueCaptureAddress                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryOpaqueCaptureAddress")
	PtrGetDeviceMemoryOpaqueCaptureAddressKHR                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMemoryOpaqueCaptureAddressKHR")
	PtrGetDeviceMicromapCompatibilityEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceMicromapCompatibilityEXT")
	PtrGetDeviceProcAddr                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceProcAddr")
	PtrGetDeviceQueue                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceQueue")
	PtrGetDeviceQueue2                                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceQueue2")
	PtrGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI          = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI")
	PtrGetDeviceTensorMemoryRequirementsARM                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetDeviceTensorMemoryRequirementsARM")
	PtrGetDynamicRenderingTilePropertiesQCOM                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetDynamicRenderingTilePropertiesQCOM")
	PtrGetEncodedVideoSessionParametersKHR                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetEncodedVideoSessionParametersKHR")
	PtrGetEventStatus                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetEventStatus")
	PtrGetExecutionGraphPipelineNodeIndexAMDX                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetExecutionGraphPipelineNodeIndexAMDX")
	PtrGetExecutionGraphPipelineScratchSizeAMDX               = auto_cast PtrGetDeviceProcAddr(device, "vkGetExecutionGraphPipelineScratchSizeAMDX")
	PtrGetFenceFdKHR                                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceFdKHR")
	PtrGetFenceStatus                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceStatus")
	PtrGetFenceWin32HandleKHR                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetFenceWin32HandleKHR")
	PtrGetFramebufferTilePropertiesQCOM                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetFramebufferTilePropertiesQCOM")
	PtrGetGeneratedCommandsMemoryRequirementsEXT              = auto_cast PtrGetDeviceProcAddr(device, "vkGetGeneratedCommandsMemoryRequirementsEXT")
	PtrGetGeneratedCommandsMemoryRequirementsNV               = auto_cast PtrGetDeviceProcAddr(device, "vkGetGeneratedCommandsMemoryRequirementsNV")
	PtrGetGpaDeviceClockInfoAMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaDeviceClockInfoAMD")
	PtrGetGpaSessionResultsAMD                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaSessionResultsAMD")
	PtrGetGpaSessionStatusAMD                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetGpaSessionStatusAMD")
	PtrGetImageDrmFormatModifierPropertiesEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageDrmFormatModifierPropertiesEXT")
	PtrGetImageMemoryRequirements                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements")
	PtrGetImageMemoryRequirements2                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements2")
	PtrGetImageMemoryRequirements2KHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageMemoryRequirements2KHR")
	PtrGetImageOpaqueCaptureDataEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageOpaqueCaptureDataEXT")
	PtrGetImageOpaqueCaptureDescriptorDataEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageOpaqueCaptureDescriptorDataEXT")
	PtrGetImageSparseMemoryRequirements                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements")
	PtrGetImageSparseMemoryRequirements2                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements2")
	PtrGetImageSparseMemoryRequirements2KHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSparseMemoryRequirements2KHR")
	PtrGetImageSubresourceLayout                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout")
	PtrGetImageSubresourceLayout2                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2")
	PtrGetImageSubresourceLayout2EXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2EXT")
	PtrGetImageSubresourceLayout2KHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageSubresourceLayout2KHR")
	PtrGetImageViewAddressNVX                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewAddressNVX")
	PtrGetImageViewHandle64NVX                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewHandle64NVX")
	PtrGetImageViewHandleNVX                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewHandleNVX")
	PtrGetImageViewOpaqueCaptureDescriptorDataEXT             = auto_cast PtrGetDeviceProcAddr(device, "vkGetImageViewOpaqueCaptureDescriptorDataEXT")
	PtrGetLatencyTimingsNV                                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetLatencyTimingsNV")
	PtrGetMemoryAndroidHardwareBufferANDROID                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryAndroidHardwareBufferANDROID")
	PtrGetMemoryFdKHR                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryFdKHR")
	PtrGetMemoryFdPropertiesKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryFdPropertiesKHR")
	PtrGetMemoryHostPointerPropertiesEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryHostPointerPropertiesEXT")
	PtrGetMemoryMetalHandleEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryMetalHandleEXT")
	PtrGetMemoryMetalHandlePropertiesEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryMetalHandlePropertiesEXT")
	PtrGetMemoryRemoteAddressNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryRemoteAddressNV")
	PtrGetMemoryWin32HandleKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandleKHR")
	PtrGetMemoryWin32HandleNV                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandleNV")
	PtrGetMemoryWin32HandlePropertiesKHR                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetMemoryWin32HandlePropertiesKHR")
	PtrGetMicromapBuildSizesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetMicromapBuildSizesEXT")
	PtrGetPartitionedAccelerationStructuresBuildSizesNV       = auto_cast PtrGetDeviceProcAddr(device, "vkGetPartitionedAccelerationStructuresBuildSizesNV")
	PtrGetPastPresentationTimingEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetPastPresentationTimingEXT")
	PtrGetPastPresentationTimingGOOGLE                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetPastPresentationTimingGOOGLE")
	PtrGetPerformanceParameterINTEL                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetPerformanceParameterINTEL")
	PtrGetPipelineBinaryDataKHR                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineBinaryDataKHR")
	PtrGetPipelineCacheData                                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineCacheData")
	PtrGetPipelineExecutableInternalRepresentationsKHR        = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutableInternalRepresentationsKHR")
	PtrGetPipelineExecutablePropertiesKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutablePropertiesKHR")
	PtrGetPipelineExecutableStatisticsKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineExecutableStatisticsKHR")
	PtrGetPipelineIndirectDeviceAddressNV                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineIndirectDeviceAddressNV")
	PtrGetPipelineIndirectMemoryRequirementsNV                = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineIndirectMemoryRequirementsNV")
	PtrGetPipelineKeyKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelineKeyKHR")
	PtrGetPipelinePropertiesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetPipelinePropertiesEXT")
	PtrGetPrivateData                                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetPrivateData")
	PtrGetPrivateDataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetPrivateDataEXT")
	PtrGetQueryPoolResults                                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueryPoolResults")
	PtrGetQueueCheckpointData2NV                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueueCheckpointData2NV")
	PtrGetQueueCheckpointDataNV                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetQueueCheckpointDataNV")
	PtrGetRayTracingCaptureReplayShaderGroupHandlesKHR        = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR")
	PtrGetRayTracingShaderGroupHandlesKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupHandlesKHR")
	PtrGetRayTracingShaderGroupHandlesNV                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupHandlesNV")
	PtrGetRayTracingShaderGroupStackSizeKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetRayTracingShaderGroupStackSizeKHR")
	PtrGetRefreshCycleDurationGOOGLE                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetRefreshCycleDurationGOOGLE")
	PtrGetRenderAreaGranularity                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderAreaGranularity")
	PtrGetRenderingAreaGranularity                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderingAreaGranularity")
	PtrGetRenderingAreaGranularityKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetRenderingAreaGranularityKHR")
	PtrGetSamplerOpaqueCaptureDescriptorDataEXT               = auto_cast PtrGetDeviceProcAddr(device, "vkGetSamplerOpaqueCaptureDescriptorDataEXT")
	PtrGetSemaphoreCounterValue                               = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreCounterValue")
	PtrGetSemaphoreCounterValueKHR                            = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreCounterValueKHR")
	PtrGetSemaphoreFdKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreFdKHR")
	PtrGetSemaphoreWin32HandleKHR                             = auto_cast PtrGetDeviceProcAddr(device, "vkGetSemaphoreWin32HandleKHR")
	PtrGetShaderBinaryDataEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderBinaryDataEXT")
	PtrGetShaderInfoAMD                                       = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderInfoAMD")
	PtrGetShaderInstrumentationValuesARM                      = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderInstrumentationValuesARM")
	PtrGetShaderModuleCreateInfoIdentifierEXT                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderModuleCreateInfoIdentifierEXT")
	PtrGetShaderModuleIdentifierEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkGetShaderModuleIdentifierEXT")
	PtrGetSwapchainCounterEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainCounterEXT")
	PtrGetSwapchainImagesKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainImagesKHR")
	PtrGetSwapchainStatusKHR                                  = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainStatusKHR")
	PtrGetSwapchainTimeDomainPropertiesEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainTimeDomainPropertiesEXT")
	PtrGetSwapchainTimingPropertiesEXT                        = auto_cast PtrGetDeviceProcAddr(device, "vkGetSwapchainTimingPropertiesEXT")
	PtrGetTensorMemoryRequirementsARM                         = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorMemoryRequirementsARM")
	PtrGetTensorOpaqueCaptureDataARM                          = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorOpaqueCaptureDataARM")
	PtrGetTensorOpaqueCaptureDescriptorDataARM                = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorOpaqueCaptureDescriptorDataARM")
	PtrGetTensorViewOpaqueCaptureDescriptorDataARM            = auto_cast PtrGetDeviceProcAddr(device, "vkGetTensorViewOpaqueCaptureDescriptorDataARM")
	PtrGetValidationCacheDataEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkGetValidationCacheDataEXT")
	PtrGetVideoSessionMemoryRequirementsKHR                   = auto_cast PtrGetDeviceProcAddr(device, "vkGetVideoSessionMemoryRequirementsKHR")
	PtrImportFenceFdKHR                                       = auto_cast PtrGetDeviceProcAddr(device, "vkImportFenceFdKHR")
	PtrImportFenceWin32HandleKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkImportFenceWin32HandleKHR")
	PtrImportSemaphoreFdKHR                                   = auto_cast PtrGetDeviceProcAddr(device, "vkImportSemaphoreFdKHR")
	PtrImportSemaphoreWin32HandleKHR                          = auto_cast PtrGetDeviceProcAddr(device, "vkImportSemaphoreWin32HandleKHR")
	PtrInitializePerformanceApiINTEL                          = auto_cast PtrGetDeviceProcAddr(device, "vkInitializePerformanceApiINTEL")
	PtrInvalidateMappedMemoryRanges                           = auto_cast PtrGetDeviceProcAddr(device, "vkInvalidateMappedMemoryRanges")
	PtrLatencySleepNV                                         = auto_cast PtrGetDeviceProcAddr(device, "vkLatencySleepNV")
	PtrMapMemory                                              = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory")
	PtrMapMemory2                                             = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory2")
	PtrMapMemory2KHR                                          = auto_cast PtrGetDeviceProcAddr(device, "vkMapMemory2KHR")
	PtrMergePipelineCaches                                    = auto_cast PtrGetDeviceProcAddr(device, "vkMergePipelineCaches")
	PtrMergeValidationCachesEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkMergeValidationCachesEXT")
	PtrQueueBeginDebugUtilsLabelEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkQueueBeginDebugUtilsLabelEXT")
	PtrQueueBindSparse                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueueBindSparse")
	PtrQueueEndDebugUtilsLabelEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkQueueEndDebugUtilsLabelEXT")
	PtrQueueInsertDebugUtilsLabelEXT                          = auto_cast PtrGetDeviceProcAddr(device, "vkQueueInsertDebugUtilsLabelEXT")
	PtrQueueNotifyOutOfBandNV                                 = auto_cast PtrGetDeviceProcAddr(device, "vkQueueNotifyOutOfBandNV")
	PtrQueuePresentKHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueuePresentKHR")
	PtrQueueSetPerformanceConfigurationINTEL                  = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSetPerformanceConfigurationINTEL")
	PtrQueueSubmit                                            = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit")
	PtrQueueSubmit2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit2")
	PtrQueueSubmit2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkQueueSubmit2KHR")
	PtrQueueWaitIdle                                          = auto_cast PtrGetDeviceProcAddr(device, "vkQueueWaitIdle")
	PtrRegisterCustomBorderColorEXT                           = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterCustomBorderColorEXT")
	PtrRegisterDeviceEventEXT                                 = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterDeviceEventEXT")
	PtrRegisterDisplayEventEXT                                = auto_cast PtrGetDeviceProcAddr(device, "vkRegisterDisplayEventEXT")
	PtrReleaseCapturedPipelineDataKHR                         = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseCapturedPipelineDataKHR")
	PtrReleaseFullScreenExclusiveModeEXT                      = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseFullScreenExclusiveModeEXT")
	PtrReleasePerformanceConfigurationINTEL                   = auto_cast PtrGetDeviceProcAddr(device, "vkReleasePerformanceConfigurationINTEL")
	PtrReleaseProfilingLockKHR                                = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseProfilingLockKHR")
	PtrReleaseSwapchainImagesEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseSwapchainImagesEXT")
	PtrReleaseSwapchainImagesKHR                              = auto_cast PtrGetDeviceProcAddr(device, "vkReleaseSwapchainImagesKHR")
	PtrResetCommandBuffer                                     = auto_cast PtrGetDeviceProcAddr(device, "vkResetCommandBuffer")
	PtrResetCommandPool                                       = auto_cast PtrGetDeviceProcAddr(device, "vkResetCommandPool")
	PtrResetDescriptorPool                                    = auto_cast PtrGetDeviceProcAddr(device, "vkResetDescriptorPool")
	PtrResetEvent                                             = auto_cast PtrGetDeviceProcAddr(device, "vkResetEvent")
	PtrResetFences                                            = auto_cast PtrGetDeviceProcAddr(device, "vkResetFences")
	PtrResetGpaSessionAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkResetGpaSessionAMD")
	PtrResetQueryPool                                         = auto_cast PtrGetDeviceProcAddr(device, "vkResetQueryPool")
	PtrResetQueryPoolEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkResetQueryPoolEXT")
	PtrSetDebugUtilsObjectNameEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkSetDebugUtilsObjectNameEXT")
	PtrSetDebugUtilsObjectTagEXT                              = auto_cast PtrGetDeviceProcAddr(device, "vkSetDebugUtilsObjectTagEXT")
	PtrSetDeviceMemoryPriorityEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkSetDeviceMemoryPriorityEXT")
	PtrSetEvent                                               = auto_cast PtrGetDeviceProcAddr(device, "vkSetEvent")
	PtrSetGpaDeviceClockModeAMD                               = auto_cast PtrGetDeviceProcAddr(device, "vkSetGpaDeviceClockModeAMD")
	PtrSetHdrMetadataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkSetHdrMetadataEXT")
	PtrSetLatencyMarkerNV                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSetLatencyMarkerNV")
	PtrSetLatencySleepModeNV                                  = auto_cast PtrGetDeviceProcAddr(device, "vkSetLatencySleepModeNV")
	PtrSetLocalDimmingAMD                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSetLocalDimmingAMD")
	PtrSetPrivateData                                         = auto_cast PtrGetDeviceProcAddr(device, "vkSetPrivateData")
	PtrSetPrivateDataEXT                                      = auto_cast PtrGetDeviceProcAddr(device, "vkSetPrivateDataEXT")
	PtrSetSwapchainPresentTimingQueueSizeEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkSetSwapchainPresentTimingQueueSizeEXT")
	PtrSignalSemaphore                                        = auto_cast PtrGetDeviceProcAddr(device, "vkSignalSemaphore")
	PtrSignalSemaphoreKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkSignalSemaphoreKHR")
	PtrTransitionImageLayout                                  = auto_cast PtrGetDeviceProcAddr(device, "vkTransitionImageLayout")
	PtrTransitionImageLayoutEXT                               = auto_cast PtrGetDeviceProcAddr(device, "vkTransitionImageLayoutEXT")
	PtrTrimCommandPool                                        = auto_cast PtrGetDeviceProcAddr(device, "vkTrimCommandPool")
	PtrTrimCommandPoolKHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkTrimCommandPoolKHR")
	PtrUninitializePerformanceApiINTEL                        = auto_cast PtrGetDeviceProcAddr(device, "vkUninitializePerformanceApiINTEL")
	PtrUnmapMemory                                            = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory")
	PtrUnmapMemory2                                           = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory2")
	PtrUnmapMemory2KHR                                        = auto_cast PtrGetDeviceProcAddr(device, "vkUnmapMemory2KHR")
	PtrUnregisterCustomBorderColorEXT                         = auto_cast PtrGetDeviceProcAddr(device, "vkUnregisterCustomBorderColorEXT")
	PtrUpdateDescriptorSetWithTemplate                        = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSetWithTemplate")
	PtrUpdateDescriptorSetWithTemplateKHR                     = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSetWithTemplateKHR")
	PtrUpdateDescriptorSets                                   = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateDescriptorSets")
	PtrUpdateIndirectExecutionSetPipelineEXT                  = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateIndirectExecutionSetPipelineEXT")
	PtrUpdateIndirectExecutionSetShaderEXT                    = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateIndirectExecutionSetShaderEXT")
	PtrUpdateVideoSessionParametersKHR                        = auto_cast PtrGetDeviceProcAddr(device, "vkUpdateVideoSessionParametersKHR")
	PtrWaitForFences                                          = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForFences")
	PtrWaitForPresent2KHR                                     = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForPresent2KHR")
	PtrWaitForPresentKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkWaitForPresentKHR")
	PtrWaitSemaphores                                         = auto_cast PtrGetDeviceProcAddr(device, "vkWaitSemaphores")
	PtrWaitSemaphoresKHR                                      = auto_cast PtrGetDeviceProcAddr(device, "vkWaitSemaphoresKHR")
	PtrWriteAccelerationStructuresPropertiesKHR               = auto_cast PtrGetDeviceProcAddr(device, "vkWriteAccelerationStructuresPropertiesKHR")
	PtrWriteMicromapsPropertiesEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkWriteMicromapsPropertiesEXT")
	PtrWriteResourceDescriptorsEXT                            = auto_cast PtrGetDeviceProcAddr(device, "vkWriteResourceDescriptorsEXT")
	PtrWriteSamplerDescriptorsEXT                             = auto_cast PtrGetDeviceProcAddr(device, "vkWriteSamplerDescriptorsEXT")
}

load_proc_addresses_instance :: proc(instance: Instance) {
	PtrAcquireDrmDisplayEXT                                               = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireDrmDisplayEXT")
	PtrAcquireWinrtDisplayNV                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireWinrtDisplayNV")
	PtrCreateAndroidSurfaceKHR                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateAndroidSurfaceKHR")
	PtrCreateDebugReportCallbackEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDebugReportCallbackEXT")
	PtrCreateDebugUtilsMessengerEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT")
	PtrCreateDevice                                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDevice")
	PtrCreateDisplayModeKHR                                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDisplayModeKHR")
	PtrCreateDisplayPlaneSurfaceKHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDisplayPlaneSurfaceKHR")
	PtrCreateHeadlessSurfaceEXT                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateHeadlessSurfaceEXT")
	PtrCreateIOSSurfaceMVK                                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateIOSSurfaceMVK")
	PtrCreateMacOSSurfaceMVK                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateMacOSSurfaceMVK")
	PtrCreateMetalSurfaceEXT                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateMetalSurfaceEXT")
	PtrCreateWaylandSurfaceKHR                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateWaylandSurfaceKHR")
	PtrCreateWin32SurfaceKHR                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateWin32SurfaceKHR")
	PtrCreateXcbSurfaceKHR                                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateXcbSurfaceKHR")
	PtrCreateXlibSurfaceKHR                                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateXlibSurfaceKHR")
	PtrDebugReportMessageEXT                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkDebugReportMessageEXT")
	PtrDestroyDebugReportCallbackEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDebugReportCallbackEXT")
	PtrDestroyDebugUtilsMessengerEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDebugUtilsMessengerEXT")
	PtrDestroyInstance                                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyInstance")
	PtrDestroySurfaceKHR                                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySurfaceKHR")
	PtrEnumerateDeviceExtensionProperties                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumerateDeviceExtensionProperties")
	PtrEnumerateDeviceLayerProperties                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumerateDeviceLayerProperties")
	PtrEnumeratePhysicalDeviceGroups                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDeviceGroups")
	PtrEnumeratePhysicalDeviceGroupsKHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDeviceGroupsKHR")
	PtrEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM   = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDeviceQueueFamilyPerformanceCountersByRegionARM")
	PtrEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR      = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR")
	PtrEnumeratePhysicalDeviceShaderInstrumentationMetricsARM             = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDeviceShaderInstrumentationMetricsARM")
	PtrEnumeratePhysicalDevices                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkEnumeratePhysicalDevices")
	PtrGetDisplayModeProperties2KHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDisplayModeProperties2KHR")
	PtrGetDisplayModePropertiesKHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDisplayModePropertiesKHR")
	PtrGetDisplayPlaneCapabilities2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDisplayPlaneCapabilities2KHR")
	PtrGetDisplayPlaneCapabilitiesKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDisplayPlaneCapabilitiesKHR")
	PtrGetDisplayPlaneSupportedDisplaysKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDisplayPlaneSupportedDisplaysKHR")
	PtrGetDrmDisplayEXT                                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDrmDisplayEXT")
	PtrGetInstanceProcAddrLUNARG                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetInstanceProcAddrLUNARG")
	PtrGetPhysicalDeviceCalibrateableTimeDomainsEXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCalibrateableTimeDomainsEXT")
	PtrGetPhysicalDeviceCalibrateableTimeDomainsKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCalibrateableTimeDomainsKHR")
	PtrGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV")
	PtrGetPhysicalDeviceCooperativeMatrixPropertiesKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR")
	PtrGetPhysicalDeviceCooperativeMatrixPropertiesNV                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCooperativeMatrixPropertiesNV")
	PtrGetPhysicalDeviceCooperativeVectorPropertiesNV                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceCooperativeVectorPropertiesNV")
	PtrGetPhysicalDeviceDescriptorSizeEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceDescriptorSizeEXT")
	PtrGetPhysicalDeviceDisplayPlaneProperties2KHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceDisplayPlaneProperties2KHR")
	PtrGetPhysicalDeviceDisplayPlanePropertiesKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceDisplayPlanePropertiesKHR")
	PtrGetPhysicalDeviceDisplayProperties2KHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceDisplayProperties2KHR")
	PtrGetPhysicalDeviceDisplayPropertiesKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceDisplayPropertiesKHR")
	PtrGetPhysicalDeviceExternalBufferProperties                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalBufferProperties")
	PtrGetPhysicalDeviceExternalBufferPropertiesKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalBufferPropertiesKHR")
	PtrGetPhysicalDeviceExternalFenceProperties                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalFenceProperties")
	PtrGetPhysicalDeviceExternalFencePropertiesKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalFencePropertiesKHR")
	PtrGetPhysicalDeviceExternalImageFormatPropertiesNV                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalImageFormatPropertiesNV")
	PtrGetPhysicalDeviceExternalSemaphoreProperties                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalSemaphoreProperties")
	PtrGetPhysicalDeviceExternalSemaphorePropertiesKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalSemaphorePropertiesKHR")
	PtrGetPhysicalDeviceExternalTensorPropertiesARM                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceExternalTensorPropertiesARM")
	PtrGetPhysicalDeviceFeatures                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFeatures")
	PtrGetPhysicalDeviceFeatures2                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFeatures2")
	PtrGetPhysicalDeviceFeatures2KHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFeatures2KHR")
	PtrGetPhysicalDeviceFormatProperties                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFormatProperties")
	PtrGetPhysicalDeviceFormatProperties2                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFormatProperties2")
	PtrGetPhysicalDeviceFormatProperties2KHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFormatProperties2KHR")
	PtrGetPhysicalDeviceFragmentShadingRatesKHR                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFragmentShadingRatesKHR")
	PtrGetPhysicalDeviceImageFormatProperties                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceImageFormatProperties")
	PtrGetPhysicalDeviceImageFormatProperties2                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceImageFormatProperties2")
	PtrGetPhysicalDeviceImageFormatProperties2KHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceImageFormatProperties2KHR")
	PtrGetPhysicalDeviceMemoryProperties                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceMemoryProperties")
	PtrGetPhysicalDeviceMemoryProperties2                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceMemoryProperties2")
	PtrGetPhysicalDeviceMemoryProperties2KHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceMemoryProperties2KHR")
	PtrGetPhysicalDeviceMultisamplePropertiesEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceMultisamplePropertiesEXT")
	PtrGetPhysicalDeviceOpticalFlowImageFormatsNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceOpticalFlowImageFormatsNV")
	PtrGetPhysicalDevicePresentRectanglesKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDevicePresentRectanglesKHR")
	PtrGetPhysicalDeviceProperties                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties")
	PtrGetPhysicalDeviceProperties2                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties2")
	PtrGetPhysicalDeviceProperties2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties2KHR")
	PtrGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyDataGraphEngineOperationPropertiesARM")
	PtrGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyDataGraphOpticalFlowImageFormatsARM")
	PtrGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM")
	PtrGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM")
	PtrGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR")
	PtrGetPhysicalDeviceQueueFamilyProperties                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyProperties")
	PtrGetPhysicalDeviceQueueFamilyProperties2                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyProperties2")
	PtrGetPhysicalDeviceQueueFamilyProperties2KHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyProperties2KHR")
	PtrGetPhysicalDeviceSparseImageFormatProperties                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSparseImageFormatProperties")
	PtrGetPhysicalDeviceSparseImageFormatProperties2                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSparseImageFormatProperties2")
	PtrGetPhysicalDeviceSparseImageFormatProperties2KHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSparseImageFormatProperties2KHR")
	PtrGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV")
	PtrGetPhysicalDeviceSurfaceCapabilities2EXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceCapabilities2EXT")
	PtrGetPhysicalDeviceSurfaceCapabilities2KHR                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceCapabilities2KHR")
	PtrGetPhysicalDeviceSurfaceCapabilitiesKHR                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceCapabilitiesKHR")
	PtrGetPhysicalDeviceSurfaceFormats2KHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceFormats2KHR")
	PtrGetPhysicalDeviceSurfaceFormatsKHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceFormatsKHR")
	PtrGetPhysicalDeviceSurfacePresentModes2EXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfacePresentModes2EXT")
	PtrGetPhysicalDeviceSurfacePresentModesKHR                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfacePresentModesKHR")
	PtrGetPhysicalDeviceSurfaceSupportKHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceSupportKHR")
	PtrGetPhysicalDeviceToolProperties                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceToolProperties")
	PtrGetPhysicalDeviceToolPropertiesEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceToolPropertiesEXT")
	PtrGetPhysicalDeviceVideoCapabilitiesKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceVideoCapabilitiesKHR")
	PtrGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR")
	PtrGetPhysicalDeviceVideoFormatPropertiesKHR                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceVideoFormatPropertiesKHR")
	PtrGetPhysicalDeviceWaylandPresentationSupportKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceWaylandPresentationSupportKHR")
	PtrGetPhysicalDeviceWin32PresentationSupportKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceWin32PresentationSupportKHR")
	PtrGetPhysicalDeviceXcbPresentationSupportKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceXcbPresentationSupportKHR")
	PtrGetPhysicalDeviceXlibPresentationSupportKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPhysicalDeviceXlibPresentationSupportKHR")
	PtrGetWinrtDisplayNV                                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetWinrtDisplayNV")
	PtrReleaseDisplayEXT                                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseDisplayEXT")
	PtrSubmitDebugUtilsMessageEXT                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkSubmitDebugUtilsMessageEXT")

	// Device Procedures (may call into dispatch)
	PtrAcquireFullScreenExclusiveModeEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireFullScreenExclusiveModeEXT")
	PtrAcquireNextImage2KHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireNextImage2KHR")
	PtrAcquireNextImageKHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireNextImageKHR")
	PtrAcquirePerformanceConfigurationINTEL                   = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquirePerformanceConfigurationINTEL")
	PtrAcquireProfilingLockKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkAcquireProfilingLockKHR")
	PtrAllocateCommandBuffers                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkAllocateCommandBuffers")
	PtrAllocateDescriptorSets                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkAllocateDescriptorSets")
	PtrAllocateMemory                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkAllocateMemory")
	PtrAntiLagUpdateAMD                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkAntiLagUpdateAMD")
	PtrBeginCommandBuffer                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkBeginCommandBuffer")
	PtrBindAccelerationStructureMemoryNV                      = auto_cast PtrGetInstanceProcAddr(instance, "vkBindAccelerationStructureMemoryNV")
	PtrBindBufferMemory                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkBindBufferMemory")
	PtrBindBufferMemory2                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkBindBufferMemory2")
	PtrBindBufferMemory2KHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkBindBufferMemory2KHR")
	PtrBindDataGraphPipelineSessionMemoryARM                  = auto_cast PtrGetInstanceProcAddr(instance, "vkBindDataGraphPipelineSessionMemoryARM")
	PtrBindImageMemory                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkBindImageMemory")
	PtrBindImageMemory2                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkBindImageMemory2")
	PtrBindImageMemory2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkBindImageMemory2KHR")
	PtrBindOpticalFlowSessionImageNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkBindOpticalFlowSessionImageNV")
	PtrBindTensorMemoryARM                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkBindTensorMemoryARM")
	PtrBindVideoSessionMemoryKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkBindVideoSessionMemoryKHR")
	PtrBuildAccelerationStructuresKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkBuildAccelerationStructuresKHR")
	PtrBuildMicromapsEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkBuildMicromapsEXT")
	PtrClearShaderInstrumentationMetricsARM                   = auto_cast PtrGetInstanceProcAddr(instance, "vkClearShaderInstrumentationMetricsARM")
	PtrCmdBeginConditionalRendering2EXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginConditionalRendering2EXT")
	PtrCmdBeginConditionalRenderingEXT                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginConditionalRenderingEXT")
	PtrCmdBeginCustomResolveEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginCustomResolveEXT")
	PtrCmdBeginDebugUtilsLabelEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginDebugUtilsLabelEXT")
	PtrCmdBeginGpaSampleAMD                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginGpaSampleAMD")
	PtrCmdBeginGpaSessionAMD                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginGpaSessionAMD")
	PtrCmdBeginPerTileExecutionQCOM                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginPerTileExecutionQCOM")
	PtrCmdBeginQuery                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginQuery")
	PtrCmdBeginQueryIndexedEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginQueryIndexedEXT")
	PtrCmdBeginRenderPass                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginRenderPass")
	PtrCmdBeginRenderPass2                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginRenderPass2")
	PtrCmdBeginRenderPass2KHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginRenderPass2KHR")
	PtrCmdBeginRendering                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginRendering")
	PtrCmdBeginRenderingKHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginRenderingKHR")
	PtrCmdBeginShaderInstrumentationARM                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginShaderInstrumentationARM")
	PtrCmdBeginTransformFeedback2EXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginTransformFeedback2EXT")
	PtrCmdBeginTransformFeedbackEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginTransformFeedbackEXT")
	PtrCmdBeginVideoCodingKHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBeginVideoCodingKHR")
	PtrCmdBindDescriptorBufferEmbeddedSamplers2EXT            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorBufferEmbeddedSamplers2EXT")
	PtrCmdBindDescriptorBufferEmbeddedSamplersEXT             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorBufferEmbeddedSamplersEXT")
	PtrCmdBindDescriptorBuffersEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorBuffersEXT")
	PtrCmdBindDescriptorSets                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorSets")
	PtrCmdBindDescriptorSets2                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorSets2")
	PtrCmdBindDescriptorSets2KHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindDescriptorSets2KHR")
	PtrCmdBindIndexBuffer                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindIndexBuffer")
	PtrCmdBindIndexBuffer2                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindIndexBuffer2")
	PtrCmdBindIndexBuffer2KHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindIndexBuffer2KHR")
	PtrCmdBindIndexBuffer3KHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindIndexBuffer3KHR")
	PtrCmdBindInvocationMaskHUAWEI                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindInvocationMaskHUAWEI")
	PtrCmdBindPipeline                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindPipeline")
	PtrCmdBindPipelineShaderGroupNV                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindPipelineShaderGroupNV")
	PtrCmdBindResourceHeapEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindResourceHeapEXT")
	PtrCmdBindSamplerHeapEXT                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindSamplerHeapEXT")
	PtrCmdBindShadersEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindShadersEXT")
	PtrCmdBindShadingRateImageNV                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindShadingRateImageNV")
	PtrCmdBindTileMemoryQCOM                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindTileMemoryQCOM")
	PtrCmdBindTransformFeedbackBuffers2EXT                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindTransformFeedbackBuffers2EXT")
	PtrCmdBindTransformFeedbackBuffersEXT                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindTransformFeedbackBuffersEXT")
	PtrCmdBindVertexBuffers                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindVertexBuffers")
	PtrCmdBindVertexBuffers2                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindVertexBuffers2")
	PtrCmdBindVertexBuffers2EXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindVertexBuffers2EXT")
	PtrCmdBindVertexBuffers3KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBindVertexBuffers3KHR")
	PtrCmdBlitImage                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBlitImage")
	PtrCmdBlitImage2                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBlitImage2")
	PtrCmdBlitImage2KHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBlitImage2KHR")
	PtrCmdBuildAccelerationStructureNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildAccelerationStructureNV")
	PtrCmdBuildAccelerationStructuresIndirectKHR              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildAccelerationStructuresIndirectKHR")
	PtrCmdBuildAccelerationStructuresKHR                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildAccelerationStructuresKHR")
	PtrCmdBuildClusterAccelerationStructureIndirectNV         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildClusterAccelerationStructureIndirectNV")
	PtrCmdBuildMicromapsEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildMicromapsEXT")
	PtrCmdBuildPartitionedAccelerationStructuresNV            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdBuildPartitionedAccelerationStructuresNV")
	PtrCmdClearAttachments                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdClearAttachments")
	PtrCmdClearColorImage                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdClearColorImage")
	PtrCmdClearDepthStencilImage                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdClearDepthStencilImage")
	PtrCmdControlVideoCodingKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdControlVideoCodingKHR")
	PtrCmdConvertCooperativeVectorMatrixNV                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdConvertCooperativeVectorMatrixNV")
	PtrCmdCopyAccelerationStructureKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyAccelerationStructureKHR")
	PtrCmdCopyAccelerationStructureNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyAccelerationStructureNV")
	PtrCmdCopyAccelerationStructureToMemoryKHR                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyAccelerationStructureToMemoryKHR")
	PtrCmdCopyBuffer                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBuffer")
	PtrCmdCopyBuffer2                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBuffer2")
	PtrCmdCopyBuffer2KHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBuffer2KHR")
	PtrCmdCopyBufferToImage                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBufferToImage")
	PtrCmdCopyBufferToImage2                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBufferToImage2")
	PtrCmdCopyBufferToImage2KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyBufferToImage2KHR")
	PtrCmdCopyGpaSessionResultsAMD                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyGpaSessionResultsAMD")
	PtrCmdCopyImage                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImage")
	PtrCmdCopyImage2                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImage2")
	PtrCmdCopyImage2KHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImage2KHR")
	PtrCmdCopyImageToBuffer                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImageToBuffer")
	PtrCmdCopyImageToBuffer2                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImageToBuffer2")
	PtrCmdCopyImageToBuffer2KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImageToBuffer2KHR")
	PtrCmdCopyImageToMemoryKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyImageToMemoryKHR")
	PtrCmdCopyMemoryIndirectKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryIndirectKHR")
	PtrCmdCopyMemoryIndirectNV                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryIndirectNV")
	PtrCmdCopyMemoryKHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryKHR")
	PtrCmdCopyMemoryToAccelerationStructureKHR                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryToAccelerationStructureKHR")
	PtrCmdCopyMemoryToImageIndirectKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryToImageIndirectKHR")
	PtrCmdCopyMemoryToImageIndirectNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryToImageIndirectNV")
	PtrCmdCopyMemoryToImageKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryToImageKHR")
	PtrCmdCopyMemoryToMicromapEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMemoryToMicromapEXT")
	PtrCmdCopyMicromapEXT                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMicromapEXT")
	PtrCmdCopyMicromapToMemoryEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyMicromapToMemoryEXT")
	PtrCmdCopyQueryPoolResults                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyQueryPoolResults")
	PtrCmdCopyQueryPoolResultsToMemoryKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyQueryPoolResultsToMemoryKHR")
	PtrCmdCopyTensorARM                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCopyTensorARM")
	PtrCmdCuLaunchKernelNVX                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCuLaunchKernelNVX")
	PtrCmdCudaLaunchKernelNV                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdCudaLaunchKernelNV")
	PtrCmdDebugMarkerBeginEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDebugMarkerBeginEXT")
	PtrCmdDebugMarkerEndEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDebugMarkerEndEXT")
	PtrCmdDebugMarkerInsertEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDebugMarkerInsertEXT")
	PtrCmdDecodeVideoKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDecodeVideoKHR")
	PtrCmdDecompressMemoryEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDecompressMemoryEXT")
	PtrCmdDecompressMemoryIndirectCountEXT                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDecompressMemoryIndirectCountEXT")
	PtrCmdDecompressMemoryIndirectCountNV                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDecompressMemoryIndirectCountNV")
	PtrCmdDecompressMemoryNV                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDecompressMemoryNV")
	PtrCmdDispatch                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatch")
	PtrCmdDispatchBase                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchBase")
	PtrCmdDispatchBaseKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchBaseKHR")
	PtrCmdDispatchDataGraphARM                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchDataGraphARM")
	PtrCmdDispatchGraphAMDX                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchGraphAMDX")
	PtrCmdDispatchGraphIndirectAMDX                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchGraphIndirectAMDX")
	PtrCmdDispatchGraphIndirectCountAMDX                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchGraphIndirectCountAMDX")
	PtrCmdDispatchIndirect                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchIndirect")
	PtrCmdDispatchIndirect2KHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchIndirect2KHR")
	PtrCmdDispatchTileQCOM                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDispatchTileQCOM")
	PtrCmdDraw                                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDraw")
	PtrCmdDrawClusterHUAWEI                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawClusterHUAWEI")
	PtrCmdDrawClusterIndirectHUAWEI                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawClusterIndirectHUAWEI")
	PtrCmdDrawIndexed                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexed")
	PtrCmdDrawIndexedIndirect                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirect")
	PtrCmdDrawIndexedIndirect2KHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirect2KHR")
	PtrCmdDrawIndexedIndirectCount                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirectCount")
	PtrCmdDrawIndexedIndirectCount2KHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirectCount2KHR")
	PtrCmdDrawIndexedIndirectCountAMD                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirectCountAMD")
	PtrCmdDrawIndexedIndirectCountKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirectCountKHR")
	PtrCmdDrawIndirect                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirect")
	PtrCmdDrawIndirect2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirect2KHR")
	PtrCmdDrawIndirectByteCount2EXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectByteCount2EXT")
	PtrCmdDrawIndirectByteCountEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectByteCountEXT")
	PtrCmdDrawIndirectCount                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectCount")
	PtrCmdDrawIndirectCount2KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectCount2KHR")
	PtrCmdDrawIndirectCountAMD                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectCountAMD")
	PtrCmdDrawIndirectCountKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawIndirectCountKHR")
	PtrCmdDrawMeshTasksEXT                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksEXT")
	PtrCmdDrawMeshTasksIndirect2EXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirect2EXT")
	PtrCmdDrawMeshTasksIndirectCount2EXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirectCount2EXT")
	PtrCmdDrawMeshTasksIndirectCountEXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirectCountEXT")
	PtrCmdDrawMeshTasksIndirectCountNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirectCountNV")
	PtrCmdDrawMeshTasksIndirectEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirectEXT")
	PtrCmdDrawMeshTasksIndirectNV                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksIndirectNV")
	PtrCmdDrawMeshTasksNV                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMeshTasksNV")
	PtrCmdDrawMultiEXT                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMultiEXT")
	PtrCmdDrawMultiIndexedEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdDrawMultiIndexedEXT")
	PtrCmdEncodeVideoKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEncodeVideoKHR")
	PtrCmdEndConditionalRenderingEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndConditionalRenderingEXT")
	PtrCmdEndDebugUtilsLabelEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndDebugUtilsLabelEXT")
	PtrCmdEndGpaSampleAMD                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndGpaSampleAMD")
	PtrCmdEndGpaSessionAMD                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndGpaSessionAMD")
	PtrCmdEndPerTileExecutionQCOM                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndPerTileExecutionQCOM")
	PtrCmdEndQuery                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndQuery")
	PtrCmdEndQueryIndexedEXT                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndQueryIndexedEXT")
	PtrCmdEndRenderPass                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRenderPass")
	PtrCmdEndRenderPass2                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRenderPass2")
	PtrCmdEndRenderPass2KHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRenderPass2KHR")
	PtrCmdEndRendering                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRendering")
	PtrCmdEndRendering2EXT                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRendering2EXT")
	PtrCmdEndRendering2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRendering2KHR")
	PtrCmdEndRenderingKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndRenderingKHR")
	PtrCmdEndShaderInstrumentationARM                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndShaderInstrumentationARM")
	PtrCmdEndTransformFeedback2EXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndTransformFeedback2EXT")
	PtrCmdEndTransformFeedbackEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndTransformFeedbackEXT")
	PtrCmdEndVideoCodingKHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdEndVideoCodingKHR")
	PtrCmdExecuteCommands                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdExecuteCommands")
	PtrCmdExecuteGeneratedCommandsEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdExecuteGeneratedCommandsEXT")
	PtrCmdExecuteGeneratedCommandsNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdExecuteGeneratedCommandsNV")
	PtrCmdFillBuffer                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdFillBuffer")
	PtrCmdFillMemoryKHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdFillMemoryKHR")
	PtrCmdInitializeGraphScratchMemoryAMDX                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdInitializeGraphScratchMemoryAMDX")
	PtrCmdInsertDebugUtilsLabelEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdInsertDebugUtilsLabelEXT")
	PtrCmdNextSubpass                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdNextSubpass")
	PtrCmdNextSubpass2                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdNextSubpass2")
	PtrCmdNextSubpass2KHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdNextSubpass2KHR")
	PtrCmdOpticalFlowExecuteNV                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdOpticalFlowExecuteNV")
	PtrCmdPipelineBarrier                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPipelineBarrier")
	PtrCmdPipelineBarrier2                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPipelineBarrier2")
	PtrCmdPipelineBarrier2KHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPipelineBarrier2KHR")
	PtrCmdPreprocessGeneratedCommandsEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPreprocessGeneratedCommandsEXT")
	PtrCmdPreprocessGeneratedCommandsNV                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPreprocessGeneratedCommandsNV")
	PtrCmdPushConstants                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushConstants")
	PtrCmdPushConstants2                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushConstants2")
	PtrCmdPushConstants2KHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushConstants2KHR")
	PtrCmdPushDataEXT                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDataEXT")
	PtrCmdPushDescriptorSet                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSet")
	PtrCmdPushDescriptorSet2                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSet2")
	PtrCmdPushDescriptorSet2KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSet2KHR")
	PtrCmdPushDescriptorSetKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSetKHR")
	PtrCmdPushDescriptorSetWithTemplate                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSetWithTemplate")
	PtrCmdPushDescriptorSetWithTemplate2                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSetWithTemplate2")
	PtrCmdPushDescriptorSetWithTemplate2KHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSetWithTemplate2KHR")
	PtrCmdPushDescriptorSetWithTemplateKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdPushDescriptorSetWithTemplateKHR")
	PtrCmdResetEvent                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResetEvent")
	PtrCmdResetEvent2                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResetEvent2")
	PtrCmdResetEvent2KHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResetEvent2KHR")
	PtrCmdResetQueryPool                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResetQueryPool")
	PtrCmdResolveImage                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResolveImage")
	PtrCmdResolveImage2                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResolveImage2")
	PtrCmdResolveImage2KHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdResolveImage2KHR")
	PtrCmdSetAlphaToCoverageEnableEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetAlphaToCoverageEnableEXT")
	PtrCmdSetAlphaToOneEnableEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetAlphaToOneEnableEXT")
	PtrCmdSetAttachmentFeedbackLoopEnableEXT                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetAttachmentFeedbackLoopEnableEXT")
	PtrCmdSetBlendConstants                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetBlendConstants")
	PtrCmdSetCheckpointNV                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCheckpointNV")
	PtrCmdSetCoarseSampleOrderNV                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoarseSampleOrderNV")
	PtrCmdSetColorBlendAdvancedEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetColorBlendAdvancedEXT")
	PtrCmdSetColorBlendEnableEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetColorBlendEnableEXT")
	PtrCmdSetColorBlendEquationEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetColorBlendEquationEXT")
	PtrCmdSetColorWriteEnableEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetColorWriteEnableEXT")
	PtrCmdSetColorWriteMaskEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetColorWriteMaskEXT")
	PtrCmdSetComputeOccupancyPriorityNV                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetComputeOccupancyPriorityNV")
	PtrCmdSetConservativeRasterizationModeEXT                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetConservativeRasterizationModeEXT")
	PtrCmdSetCoverageModulationModeNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageModulationModeNV")
	PtrCmdSetCoverageModulationTableEnableNV                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageModulationTableEnableNV")
	PtrCmdSetCoverageModulationTableNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageModulationTableNV")
	PtrCmdSetCoverageReductionModeNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageReductionModeNV")
	PtrCmdSetCoverageToColorEnableNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageToColorEnableNV")
	PtrCmdSetCoverageToColorLocationNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCoverageToColorLocationNV")
	PtrCmdSetCullMode                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCullMode")
	PtrCmdSetCullModeEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetCullModeEXT")
	PtrCmdSetDepthBias                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBias")
	PtrCmdSetDepthBias2EXT                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBias2EXT")
	PtrCmdSetDepthBiasEnable                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBiasEnable")
	PtrCmdSetDepthBiasEnableEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBiasEnableEXT")
	PtrCmdSetDepthBounds                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBounds")
	PtrCmdSetDepthBoundsTestEnable                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBoundsTestEnable")
	PtrCmdSetDepthBoundsTestEnableEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthBoundsTestEnableEXT")
	PtrCmdSetDepthClampEnableEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthClampEnableEXT")
	PtrCmdSetDepthClampRangeEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthClampRangeEXT")
	PtrCmdSetDepthClipEnableEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthClipEnableEXT")
	PtrCmdSetDepthClipNegativeOneToOneEXT                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthClipNegativeOneToOneEXT")
	PtrCmdSetDepthCompareOp                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthCompareOp")
	PtrCmdSetDepthCompareOpEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthCompareOpEXT")
	PtrCmdSetDepthTestEnable                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthTestEnable")
	PtrCmdSetDepthTestEnableEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthTestEnableEXT")
	PtrCmdSetDepthWriteEnable                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthWriteEnable")
	PtrCmdSetDepthWriteEnableEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDepthWriteEnableEXT")
	PtrCmdSetDescriptorBufferOffsets2EXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDescriptorBufferOffsets2EXT")
	PtrCmdSetDescriptorBufferOffsetsEXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDescriptorBufferOffsetsEXT")
	PtrCmdSetDeviceMask                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDeviceMask")
	PtrCmdSetDeviceMaskKHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDeviceMaskKHR")
	PtrCmdSetDiscardRectangleEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDiscardRectangleEXT")
	PtrCmdSetDiscardRectangleEnableEXT                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDiscardRectangleEnableEXT")
	PtrCmdSetDiscardRectangleModeEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDiscardRectangleModeEXT")
	PtrCmdSetDispatchParametersARM                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetDispatchParametersARM")
	PtrCmdSetEvent                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetEvent")
	PtrCmdSetEvent2                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetEvent2")
	PtrCmdSetEvent2KHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetEvent2KHR")
	PtrCmdSetExclusiveScissorEnableNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetExclusiveScissorEnableNV")
	PtrCmdSetExclusiveScissorNV                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetExclusiveScissorNV")
	PtrCmdSetExtraPrimitiveOverestimationSizeEXT              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetExtraPrimitiveOverestimationSizeEXT")
	PtrCmdSetFragmentShadingRateEnumNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetFragmentShadingRateEnumNV")
	PtrCmdSetFragmentShadingRateKHR                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetFragmentShadingRateKHR")
	PtrCmdSetFrontFace                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetFrontFace")
	PtrCmdSetFrontFaceEXT                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetFrontFaceEXT")
	PtrCmdSetLineRasterizationModeEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineRasterizationModeEXT")
	PtrCmdSetLineStipple                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineStipple")
	PtrCmdSetLineStippleEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineStippleEXT")
	PtrCmdSetLineStippleEnableEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineStippleEnableEXT")
	PtrCmdSetLineStippleKHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineStippleKHR")
	PtrCmdSetLineWidth                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLineWidth")
	PtrCmdSetLogicOpEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLogicOpEXT")
	PtrCmdSetLogicOpEnableEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetLogicOpEnableEXT")
	PtrCmdSetPatchControlPointsEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPatchControlPointsEXT")
	PtrCmdSetPerformanceMarkerINTEL                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPerformanceMarkerINTEL")
	PtrCmdSetPerformanceOverrideINTEL                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPerformanceOverrideINTEL")
	PtrCmdSetPerformanceStreamMarkerINTEL                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPerformanceStreamMarkerINTEL")
	PtrCmdSetPolygonModeEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPolygonModeEXT")
	PtrCmdSetPrimitiveRestartEnable                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPrimitiveRestartEnable")
	PtrCmdSetPrimitiveRestartEnableEXT                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPrimitiveRestartEnableEXT")
	PtrCmdSetPrimitiveRestartIndexEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPrimitiveRestartIndexEXT")
	PtrCmdSetPrimitiveTopology                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPrimitiveTopology")
	PtrCmdSetPrimitiveTopologyEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetPrimitiveTopologyEXT")
	PtrCmdSetProvokingVertexModeEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetProvokingVertexModeEXT")
	PtrCmdSetRasterizationSamplesEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRasterizationSamplesEXT")
	PtrCmdSetRasterizationStreamEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRasterizationStreamEXT")
	PtrCmdSetRasterizerDiscardEnable                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRasterizerDiscardEnable")
	PtrCmdSetRasterizerDiscardEnableEXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRasterizerDiscardEnableEXT")
	PtrCmdSetRayTracingPipelineStackSizeKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRayTracingPipelineStackSizeKHR")
	PtrCmdSetRenderingAttachmentLocations                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRenderingAttachmentLocations")
	PtrCmdSetRenderingAttachmentLocationsKHR                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRenderingAttachmentLocationsKHR")
	PtrCmdSetRenderingInputAttachmentIndices                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRenderingInputAttachmentIndices")
	PtrCmdSetRenderingInputAttachmentIndicesKHR               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRenderingInputAttachmentIndicesKHR")
	PtrCmdSetRepresentativeFragmentTestEnableNV               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetRepresentativeFragmentTestEnableNV")
	PtrCmdSetSampleLocationsEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetSampleLocationsEXT")
	PtrCmdSetSampleLocationsEnableEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetSampleLocationsEnableEXT")
	PtrCmdSetSampleMaskEXT                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetSampleMaskEXT")
	PtrCmdSetScissor                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetScissor")
	PtrCmdSetScissorWithCount                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetScissorWithCount")
	PtrCmdSetScissorWithCountEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetScissorWithCountEXT")
	PtrCmdSetShadingRateImageEnableNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetShadingRateImageEnableNV")
	PtrCmdSetStencilCompareMask                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilCompareMask")
	PtrCmdSetStencilOp                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilOp")
	PtrCmdSetStencilOpEXT                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilOpEXT")
	PtrCmdSetStencilReference                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilReference")
	PtrCmdSetStencilTestEnable                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilTestEnable")
	PtrCmdSetStencilTestEnableEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilTestEnableEXT")
	PtrCmdSetStencilWriteMask                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetStencilWriteMask")
	PtrCmdSetTessellationDomainOriginEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetTessellationDomainOriginEXT")
	PtrCmdSetVertexInputEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetVertexInputEXT")
	PtrCmdSetViewport                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewport")
	PtrCmdSetViewportShadingRatePaletteNV                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportShadingRatePaletteNV")
	PtrCmdSetViewportSwizzleNV                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportSwizzleNV")
	PtrCmdSetViewportWScalingEnableNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportWScalingEnableNV")
	PtrCmdSetViewportWScalingNV                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportWScalingNV")
	PtrCmdSetViewportWithCount                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportWithCount")
	PtrCmdSetViewportWithCountEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSetViewportWithCountEXT")
	PtrCmdSubpassShadingHUAWEI                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdSubpassShadingHUAWEI")
	PtrCmdTraceRaysIndirect2KHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdTraceRaysIndirect2KHR")
	PtrCmdTraceRaysIndirectKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdTraceRaysIndirectKHR")
	PtrCmdTraceRaysKHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdTraceRaysKHR")
	PtrCmdTraceRaysNV                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdTraceRaysNV")
	PtrCmdUpdateBuffer                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdUpdateBuffer")
	PtrCmdUpdateMemoryKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdUpdateMemoryKHR")
	PtrCmdUpdatePipelineIndirectBufferNV                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdUpdatePipelineIndirectBufferNV")
	PtrCmdWaitEvents                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWaitEvents")
	PtrCmdWaitEvents2                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWaitEvents2")
	PtrCmdWaitEvents2KHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWaitEvents2KHR")
	PtrCmdWriteAccelerationStructuresPropertiesKHR            = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteAccelerationStructuresPropertiesKHR")
	PtrCmdWriteAccelerationStructuresPropertiesNV             = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteAccelerationStructuresPropertiesNV")
	PtrCmdWriteBufferMarker2AMD                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteBufferMarker2AMD")
	PtrCmdWriteBufferMarkerAMD                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteBufferMarkerAMD")
	PtrCmdWriteMarkerToMemoryAMD                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteMarkerToMemoryAMD")
	PtrCmdWriteMicromapsPropertiesEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteMicromapsPropertiesEXT")
	PtrCmdWriteTimestamp                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteTimestamp")
	PtrCmdWriteTimestamp2                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteTimestamp2")
	PtrCmdWriteTimestamp2KHR                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCmdWriteTimestamp2KHR")
	PtrCompileDeferredNV                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCompileDeferredNV")
	PtrConvertCooperativeVectorMatrixNV                       = auto_cast PtrGetInstanceProcAddr(instance, "vkConvertCooperativeVectorMatrixNV")
	PtrCopyAccelerationStructureKHR                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyAccelerationStructureKHR")
	PtrCopyAccelerationStructureToMemoryKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyAccelerationStructureToMemoryKHR")
	PtrCopyImageToImage                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyImageToImage")
	PtrCopyImageToImageEXT                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyImageToImageEXT")
	PtrCopyImageToMemory                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyImageToMemory")
	PtrCopyImageToMemoryEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyImageToMemoryEXT")
	PtrCopyMemoryToAccelerationStructureKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMemoryToAccelerationStructureKHR")
	PtrCopyMemoryToImage                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMemoryToImage")
	PtrCopyMemoryToImageEXT                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMemoryToImageEXT")
	PtrCopyMemoryToMicromapEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMemoryToMicromapEXT")
	PtrCopyMicromapEXT                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMicromapEXT")
	PtrCopyMicromapToMemoryEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCopyMicromapToMemoryEXT")
	PtrCreateAccelerationStructure2KHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateAccelerationStructure2KHR")
	PtrCreateAccelerationStructureKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateAccelerationStructureKHR")
	PtrCreateAccelerationStructureNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateAccelerationStructureNV")
	PtrCreateBuffer                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateBuffer")
	PtrCreateBufferView                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateBufferView")
	PtrCreateCommandPool                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateCommandPool")
	PtrCreateComputePipelines                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateComputePipelines")
	PtrCreateCuFunctionNVX                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateCuFunctionNVX")
	PtrCreateCuModuleNVX                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateCuModuleNVX")
	PtrCreateCudaFunctionNV                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateCudaFunctionNV")
	PtrCreateCudaModuleNV                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateCudaModuleNV")
	PtrCreateDataGraphPipelineSessionARM                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDataGraphPipelineSessionARM")
	PtrCreateDataGraphPipelinesARM                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDataGraphPipelinesARM")
	PtrCreateDeferredOperationKHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDeferredOperationKHR")
	PtrCreateDescriptorPool                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDescriptorPool")
	PtrCreateDescriptorSetLayout                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDescriptorSetLayout")
	PtrCreateDescriptorUpdateTemplate                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDescriptorUpdateTemplate")
	PtrCreateDescriptorUpdateTemplateKHR                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateDescriptorUpdateTemplateKHR")
	PtrCreateEvent                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateEvent")
	PtrCreateExecutionGraphPipelinesAMDX                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateExecutionGraphPipelinesAMDX")
	PtrCreateExternalComputeQueueNV                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateExternalComputeQueueNV")
	PtrCreateFence                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateFence")
	PtrCreateFramebuffer                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateFramebuffer")
	PtrCreateGpaSessionAMD                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateGpaSessionAMD")
	PtrCreateGraphicsPipelines                                = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateGraphicsPipelines")
	PtrCreateImage                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateImage")
	PtrCreateImageView                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateImageView")
	PtrCreateIndirectCommandsLayoutEXT                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateIndirectCommandsLayoutEXT")
	PtrCreateIndirectCommandsLayoutNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateIndirectCommandsLayoutNV")
	PtrCreateIndirectExecutionSetEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateIndirectExecutionSetEXT")
	PtrCreateMicromapEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateMicromapEXT")
	PtrCreateOpticalFlowSessionNV                             = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateOpticalFlowSessionNV")
	PtrCreatePipelineBinariesKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreatePipelineBinariesKHR")
	PtrCreatePipelineCache                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCreatePipelineCache")
	PtrCreatePipelineLayout                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCreatePipelineLayout")
	PtrCreatePrivateDataSlot                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCreatePrivateDataSlot")
	PtrCreatePrivateDataSlotEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCreatePrivateDataSlotEXT")
	PtrCreateQueryPool                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateQueryPool")
	PtrCreateRayTracingPipelinesKHR                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateRayTracingPipelinesKHR")
	PtrCreateRayTracingPipelinesNV                            = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateRayTracingPipelinesNV")
	PtrCreateRenderPass                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateRenderPass")
	PtrCreateRenderPass2                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateRenderPass2")
	PtrCreateRenderPass2KHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateRenderPass2KHR")
	PtrCreateSampler                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSampler")
	PtrCreateSamplerYcbcrConversion                           = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSamplerYcbcrConversion")
	PtrCreateSamplerYcbcrConversionKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSamplerYcbcrConversionKHR")
	PtrCreateSemaphore                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSemaphore")
	PtrCreateShaderInstrumentationARM                         = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateShaderInstrumentationARM")
	PtrCreateShaderModule                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateShaderModule")
	PtrCreateShadersEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateShadersEXT")
	PtrCreateSharedSwapchainsKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSharedSwapchainsKHR")
	PtrCreateSwapchainKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateSwapchainKHR")
	PtrCreateTensorARM                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateTensorARM")
	PtrCreateTensorViewARM                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateTensorViewARM")
	PtrCreateValidationCacheEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateValidationCacheEXT")
	PtrCreateVideoSessionKHR                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateVideoSessionKHR")
	PtrCreateVideoSessionParametersKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkCreateVideoSessionParametersKHR")
	PtrDebugMarkerSetObjectNameEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkDebugMarkerSetObjectNameEXT")
	PtrDebugMarkerSetObjectTagEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkDebugMarkerSetObjectTagEXT")
	PtrDeferredOperationJoinKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkDeferredOperationJoinKHR")
	PtrDestroyAccelerationStructureKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyAccelerationStructureKHR")
	PtrDestroyAccelerationStructureNV                         = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyAccelerationStructureNV")
	PtrDestroyBuffer                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyBuffer")
	PtrDestroyBufferView                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyBufferView")
	PtrDestroyCommandPool                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyCommandPool")
	PtrDestroyCuFunctionNVX                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyCuFunctionNVX")
	PtrDestroyCuModuleNVX                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyCuModuleNVX")
	PtrDestroyCudaFunctionNV                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyCudaFunctionNV")
	PtrDestroyCudaModuleNV                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyCudaModuleNV")
	PtrDestroyDataGraphPipelineSessionARM                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDataGraphPipelineSessionARM")
	PtrDestroyDeferredOperationKHR                            = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDeferredOperationKHR")
	PtrDestroyDescriptorPool                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDescriptorPool")
	PtrDestroyDescriptorSetLayout                             = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDescriptorSetLayout")
	PtrDestroyDescriptorUpdateTemplate                        = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDescriptorUpdateTemplate")
	PtrDestroyDescriptorUpdateTemplateKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDescriptorUpdateTemplateKHR")
	PtrDestroyDevice                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyDevice")
	PtrDestroyEvent                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyEvent")
	PtrDestroyExternalComputeQueueNV                          = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyExternalComputeQueueNV")
	PtrDestroyFence                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyFence")
	PtrDestroyFramebuffer                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyFramebuffer")
	PtrDestroyGpaSessionAMD                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyGpaSessionAMD")
	PtrDestroyImage                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyImage")
	PtrDestroyImageView                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyImageView")
	PtrDestroyIndirectCommandsLayoutEXT                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyIndirectCommandsLayoutEXT")
	PtrDestroyIndirectCommandsLayoutNV                        = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyIndirectCommandsLayoutNV")
	PtrDestroyIndirectExecutionSetEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyIndirectExecutionSetEXT")
	PtrDestroyMicromapEXT                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyMicromapEXT")
	PtrDestroyOpticalFlowSessionNV                            = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyOpticalFlowSessionNV")
	PtrDestroyPipeline                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPipeline")
	PtrDestroyPipelineBinaryKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPipelineBinaryKHR")
	PtrDestroyPipelineCache                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPipelineCache")
	PtrDestroyPipelineLayout                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPipelineLayout")
	PtrDestroyPrivateDataSlot                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPrivateDataSlot")
	PtrDestroyPrivateDataSlotEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyPrivateDataSlotEXT")
	PtrDestroyQueryPool                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyQueryPool")
	PtrDestroyRenderPass                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyRenderPass")
	PtrDestroySampler                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySampler")
	PtrDestroySamplerYcbcrConversion                          = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySamplerYcbcrConversion")
	PtrDestroySamplerYcbcrConversionKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySamplerYcbcrConversionKHR")
	PtrDestroySemaphore                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySemaphore")
	PtrDestroyShaderEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyShaderEXT")
	PtrDestroyShaderInstrumentationARM                        = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyShaderInstrumentationARM")
	PtrDestroyShaderModule                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyShaderModule")
	PtrDestroySwapchainKHR                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroySwapchainKHR")
	PtrDestroyTensorARM                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyTensorARM")
	PtrDestroyTensorViewARM                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyTensorViewARM")
	PtrDestroyValidationCacheEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyValidationCacheEXT")
	PtrDestroyVideoSessionKHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyVideoSessionKHR")
	PtrDestroyVideoSessionParametersKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkDestroyVideoSessionParametersKHR")
	PtrDeviceWaitIdle                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkDeviceWaitIdle")
	PtrDisplayPowerControlEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkDisplayPowerControlEXT")
	PtrEndCommandBuffer                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkEndCommandBuffer")
	PtrExportMetalObjectsEXT                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkExportMetalObjectsEXT")
	PtrFlushMappedMemoryRanges                                = auto_cast PtrGetInstanceProcAddr(instance, "vkFlushMappedMemoryRanges")
	PtrFreeCommandBuffers                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkFreeCommandBuffers")
	PtrFreeDescriptorSets                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkFreeDescriptorSets")
	PtrFreeMemory                                             = auto_cast PtrGetInstanceProcAddr(instance, "vkFreeMemory")
	PtrGetAccelerationStructureBuildSizesKHR                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAccelerationStructureBuildSizesKHR")
	PtrGetAccelerationStructureDeviceAddressKHR               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAccelerationStructureDeviceAddressKHR")
	PtrGetAccelerationStructureHandleNV                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAccelerationStructureHandleNV")
	PtrGetAccelerationStructureMemoryRequirementsNV           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAccelerationStructureMemoryRequirementsNV")
	PtrGetAccelerationStructureOpaqueCaptureDescriptorDataEXT = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT")
	PtrGetAndroidHardwareBufferPropertiesANDROID              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetAndroidHardwareBufferPropertiesANDROID")
	PtrGetBufferDeviceAddress                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferDeviceAddress")
	PtrGetBufferDeviceAddressEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferDeviceAddressEXT")
	PtrGetBufferDeviceAddressKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferDeviceAddressKHR")
	PtrGetBufferMemoryRequirements                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferMemoryRequirements")
	PtrGetBufferMemoryRequirements2                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferMemoryRequirements2")
	PtrGetBufferMemoryRequirements2KHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferMemoryRequirements2KHR")
	PtrGetBufferOpaqueCaptureAddress                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferOpaqueCaptureAddress")
	PtrGetBufferOpaqueCaptureAddressKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferOpaqueCaptureAddressKHR")
	PtrGetBufferOpaqueCaptureDescriptorDataEXT                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetBufferOpaqueCaptureDescriptorDataEXT")
	PtrGetCalibratedTimestampsEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetCalibratedTimestampsEXT")
	PtrGetCalibratedTimestampsKHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetCalibratedTimestampsKHR")
	PtrGetClusterAccelerationStructureBuildSizesNV            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetClusterAccelerationStructureBuildSizesNV")
	PtrGetCudaModuleCacheNV                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetCudaModuleCacheNV")
	PtrGetDataGraphPipelineAvailablePropertiesARM             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDataGraphPipelineAvailablePropertiesARM")
	PtrGetDataGraphPipelinePropertiesARM                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDataGraphPipelinePropertiesARM")
	PtrGetDataGraphPipelineSessionBindPointRequirementsARM    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDataGraphPipelineSessionBindPointRequirementsARM")
	PtrGetDataGraphPipelineSessionMemoryRequirementsARM       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDataGraphPipelineSessionMemoryRequirementsARM")
	PtrGetDeferredOperationMaxConcurrencyKHR                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeferredOperationMaxConcurrencyKHR")
	PtrGetDeferredOperationResultKHR                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeferredOperationResultKHR")
	PtrGetDescriptorEXT                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorEXT")
	PtrGetDescriptorSetHostMappingVALVE                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetHostMappingVALVE")
	PtrGetDescriptorSetLayoutBindingOffsetEXT                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetLayoutBindingOffsetEXT")
	PtrGetDescriptorSetLayoutHostMappingInfoVALVE             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetLayoutHostMappingInfoVALVE")
	PtrGetDescriptorSetLayoutSizeEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetLayoutSizeEXT")
	PtrGetDescriptorSetLayoutSupport                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetLayoutSupport")
	PtrGetDescriptorSetLayoutSupportKHR                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDescriptorSetLayoutSupportKHR")
	PtrGetDeviceAccelerationStructureCompatibilityKHR         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceAccelerationStructureCompatibilityKHR")
	PtrGetDeviceBufferMemoryRequirements                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceBufferMemoryRequirements")
	PtrGetDeviceBufferMemoryRequirementsKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceBufferMemoryRequirementsKHR")
	PtrGetDeviceCombinedImageSamplerIndexNVX                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceCombinedImageSamplerIndexNVX")
	PtrGetDeviceFaultDebugInfoKHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceFaultDebugInfoKHR")
	PtrGetDeviceFaultInfoEXT                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceFaultInfoEXT")
	PtrGetDeviceFaultReportsKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceFaultReportsKHR")
	PtrGetDeviceGroupPeerMemoryFeatures                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceGroupPeerMemoryFeatures")
	PtrGetDeviceGroupPeerMemoryFeaturesKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceGroupPeerMemoryFeaturesKHR")
	PtrGetDeviceGroupPresentCapabilitiesKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceGroupPresentCapabilitiesKHR")
	PtrGetDeviceGroupSurfacePresentModes2EXT                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceGroupSurfacePresentModes2EXT")
	PtrGetDeviceGroupSurfacePresentModesKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceGroupSurfacePresentModesKHR")
	PtrGetDeviceImageMemoryRequirements                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageMemoryRequirements")
	PtrGetDeviceImageMemoryRequirementsKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageMemoryRequirementsKHR")
	PtrGetDeviceImageSparseMemoryRequirements                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageSparseMemoryRequirements")
	PtrGetDeviceImageSparseMemoryRequirementsKHR              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageSparseMemoryRequirementsKHR")
	PtrGetDeviceImageSubresourceLayout                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageSubresourceLayout")
	PtrGetDeviceImageSubresourceLayoutKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceImageSubresourceLayoutKHR")
	PtrGetDeviceMemoryCommitment                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceMemoryCommitment")
	PtrGetDeviceMemoryOpaqueCaptureAddress                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceMemoryOpaqueCaptureAddress")
	PtrGetDeviceMemoryOpaqueCaptureAddressKHR                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceMemoryOpaqueCaptureAddressKHR")
	PtrGetDeviceMicromapCompatibilityEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceMicromapCompatibilityEXT")
	PtrGetDeviceProcAddr                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceProcAddr")
	PtrGetDeviceQueue                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceQueue")
	PtrGetDeviceQueue2                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceQueue2")
	PtrGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI")
	PtrGetDeviceTensorMemoryRequirementsARM                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDeviceTensorMemoryRequirementsARM")
	PtrGetDynamicRenderingTilePropertiesQCOM                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetDynamicRenderingTilePropertiesQCOM")
	PtrGetEncodedVideoSessionParametersKHR                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetEncodedVideoSessionParametersKHR")
	PtrGetEventStatus                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetEventStatus")
	PtrGetExecutionGraphPipelineNodeIndexAMDX                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetExecutionGraphPipelineNodeIndexAMDX")
	PtrGetExecutionGraphPipelineScratchSizeAMDX               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetExecutionGraphPipelineScratchSizeAMDX")
	PtrGetFenceFdKHR                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetFenceFdKHR")
	PtrGetFenceStatus                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetFenceStatus")
	PtrGetFenceWin32HandleKHR                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetFenceWin32HandleKHR")
	PtrGetFramebufferTilePropertiesQCOM                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetFramebufferTilePropertiesQCOM")
	PtrGetGeneratedCommandsMemoryRequirementsEXT              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetGeneratedCommandsMemoryRequirementsEXT")
	PtrGetGeneratedCommandsMemoryRequirementsNV               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetGeneratedCommandsMemoryRequirementsNV")
	PtrGetGpaDeviceClockInfoAMD                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetGpaDeviceClockInfoAMD")
	PtrGetGpaSessionResultsAMD                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetGpaSessionResultsAMD")
	PtrGetGpaSessionStatusAMD                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetGpaSessionStatusAMD")
	PtrGetImageDrmFormatModifierPropertiesEXT                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageDrmFormatModifierPropertiesEXT")
	PtrGetImageMemoryRequirements                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageMemoryRequirements")
	PtrGetImageMemoryRequirements2                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageMemoryRequirements2")
	PtrGetImageMemoryRequirements2KHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageMemoryRequirements2KHR")
	PtrGetImageOpaqueCaptureDataEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageOpaqueCaptureDataEXT")
	PtrGetImageOpaqueCaptureDescriptorDataEXT                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageOpaqueCaptureDescriptorDataEXT")
	PtrGetImageSparseMemoryRequirements                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSparseMemoryRequirements")
	PtrGetImageSparseMemoryRequirements2                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSparseMemoryRequirements2")
	PtrGetImageSparseMemoryRequirements2KHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSparseMemoryRequirements2KHR")
	PtrGetImageSubresourceLayout                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSubresourceLayout")
	PtrGetImageSubresourceLayout2                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSubresourceLayout2")
	PtrGetImageSubresourceLayout2EXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSubresourceLayout2EXT")
	PtrGetImageSubresourceLayout2KHR                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageSubresourceLayout2KHR")
	PtrGetImageViewAddressNVX                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageViewAddressNVX")
	PtrGetImageViewHandle64NVX                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageViewHandle64NVX")
	PtrGetImageViewHandleNVX                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageViewHandleNVX")
	PtrGetImageViewOpaqueCaptureDescriptorDataEXT             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetImageViewOpaqueCaptureDescriptorDataEXT")
	PtrGetLatencyTimingsNV                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetLatencyTimingsNV")
	PtrGetMemoryAndroidHardwareBufferANDROID                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryAndroidHardwareBufferANDROID")
	PtrGetMemoryFdKHR                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryFdKHR")
	PtrGetMemoryFdPropertiesKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryFdPropertiesKHR")
	PtrGetMemoryHostPointerPropertiesEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryHostPointerPropertiesEXT")
	PtrGetMemoryMetalHandleEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryMetalHandleEXT")
	PtrGetMemoryMetalHandlePropertiesEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryMetalHandlePropertiesEXT")
	PtrGetMemoryRemoteAddressNV                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryRemoteAddressNV")
	PtrGetMemoryWin32HandleKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryWin32HandleKHR")
	PtrGetMemoryWin32HandleNV                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryWin32HandleNV")
	PtrGetMemoryWin32HandlePropertiesKHR                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMemoryWin32HandlePropertiesKHR")
	PtrGetMicromapBuildSizesEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetMicromapBuildSizesEXT")
	PtrGetPartitionedAccelerationStructuresBuildSizesNV       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPartitionedAccelerationStructuresBuildSizesNV")
	PtrGetPastPresentationTimingEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPastPresentationTimingEXT")
	PtrGetPastPresentationTimingGOOGLE                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPastPresentationTimingGOOGLE")
	PtrGetPerformanceParameterINTEL                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPerformanceParameterINTEL")
	PtrGetPipelineBinaryDataKHR                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineBinaryDataKHR")
	PtrGetPipelineCacheData                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineCacheData")
	PtrGetPipelineExecutableInternalRepresentationsKHR        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineExecutableInternalRepresentationsKHR")
	PtrGetPipelineExecutablePropertiesKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineExecutablePropertiesKHR")
	PtrGetPipelineExecutableStatisticsKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineExecutableStatisticsKHR")
	PtrGetPipelineIndirectDeviceAddressNV                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineIndirectDeviceAddressNV")
	PtrGetPipelineIndirectMemoryRequirementsNV                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineIndirectMemoryRequirementsNV")
	PtrGetPipelineKeyKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelineKeyKHR")
	PtrGetPipelinePropertiesEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPipelinePropertiesEXT")
	PtrGetPrivateData                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPrivateData")
	PtrGetPrivateDataEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetPrivateDataEXT")
	PtrGetQueryPoolResults                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetQueryPoolResults")
	PtrGetQueueCheckpointData2NV                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetQueueCheckpointData2NV")
	PtrGetQueueCheckpointDataNV                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetQueueCheckpointDataNV")
	PtrGetRayTracingCaptureReplayShaderGroupHandlesKHR        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR")
	PtrGetRayTracingShaderGroupHandlesKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRayTracingShaderGroupHandlesKHR")
	PtrGetRayTracingShaderGroupHandlesNV                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRayTracingShaderGroupHandlesNV")
	PtrGetRayTracingShaderGroupStackSizeKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRayTracingShaderGroupStackSizeKHR")
	PtrGetRefreshCycleDurationGOOGLE                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRefreshCycleDurationGOOGLE")
	PtrGetRenderAreaGranularity                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRenderAreaGranularity")
	PtrGetRenderingAreaGranularity                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRenderingAreaGranularity")
	PtrGetRenderingAreaGranularityKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetRenderingAreaGranularityKHR")
	PtrGetSamplerOpaqueCaptureDescriptorDataEXT               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSamplerOpaqueCaptureDescriptorDataEXT")
	PtrGetSemaphoreCounterValue                               = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSemaphoreCounterValue")
	PtrGetSemaphoreCounterValueKHR                            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSemaphoreCounterValueKHR")
	PtrGetSemaphoreFdKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSemaphoreFdKHR")
	PtrGetSemaphoreWin32HandleKHR                             = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSemaphoreWin32HandleKHR")
	PtrGetShaderBinaryDataEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetShaderBinaryDataEXT")
	PtrGetShaderInfoAMD                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkGetShaderInfoAMD")
	PtrGetShaderInstrumentationValuesARM                      = auto_cast PtrGetInstanceProcAddr(instance, "vkGetShaderInstrumentationValuesARM")
	PtrGetShaderModuleCreateInfoIdentifierEXT                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetShaderModuleCreateInfoIdentifierEXT")
	PtrGetShaderModuleIdentifierEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkGetShaderModuleIdentifierEXT")
	PtrGetSwapchainCounterEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSwapchainCounterEXT")
	PtrGetSwapchainImagesKHR                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSwapchainImagesKHR")
	PtrGetSwapchainStatusKHR                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSwapchainStatusKHR")
	PtrGetSwapchainTimeDomainPropertiesEXT                    = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSwapchainTimeDomainPropertiesEXT")
	PtrGetSwapchainTimingPropertiesEXT                        = auto_cast PtrGetInstanceProcAddr(instance, "vkGetSwapchainTimingPropertiesEXT")
	PtrGetTensorMemoryRequirementsARM                         = auto_cast PtrGetInstanceProcAddr(instance, "vkGetTensorMemoryRequirementsARM")
	PtrGetTensorOpaqueCaptureDataARM                          = auto_cast PtrGetInstanceProcAddr(instance, "vkGetTensorOpaqueCaptureDataARM")
	PtrGetTensorOpaqueCaptureDescriptorDataARM                = auto_cast PtrGetInstanceProcAddr(instance, "vkGetTensorOpaqueCaptureDescriptorDataARM")
	PtrGetTensorViewOpaqueCaptureDescriptorDataARM            = auto_cast PtrGetInstanceProcAddr(instance, "vkGetTensorViewOpaqueCaptureDescriptorDataARM")
	PtrGetValidationCacheDataEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkGetValidationCacheDataEXT")
	PtrGetVideoSessionMemoryRequirementsKHR                   = auto_cast PtrGetInstanceProcAddr(instance, "vkGetVideoSessionMemoryRequirementsKHR")
	PtrImportFenceFdKHR                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkImportFenceFdKHR")
	PtrImportFenceWin32HandleKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkImportFenceWin32HandleKHR")
	PtrImportSemaphoreFdKHR                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkImportSemaphoreFdKHR")
	PtrImportSemaphoreWin32HandleKHR                          = auto_cast PtrGetInstanceProcAddr(instance, "vkImportSemaphoreWin32HandleKHR")
	PtrInitializePerformanceApiINTEL                          = auto_cast PtrGetInstanceProcAddr(instance, "vkInitializePerformanceApiINTEL")
	PtrInvalidateMappedMemoryRanges                           = auto_cast PtrGetInstanceProcAddr(instance, "vkInvalidateMappedMemoryRanges")
	PtrLatencySleepNV                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkLatencySleepNV")
	PtrMapMemory                                              = auto_cast PtrGetInstanceProcAddr(instance, "vkMapMemory")
	PtrMapMemory2                                             = auto_cast PtrGetInstanceProcAddr(instance, "vkMapMemory2")
	PtrMapMemory2KHR                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkMapMemory2KHR")
	PtrMergePipelineCaches                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkMergePipelineCaches")
	PtrMergeValidationCachesEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkMergeValidationCachesEXT")
	PtrQueueBeginDebugUtilsLabelEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueBeginDebugUtilsLabelEXT")
	PtrQueueBindSparse                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueBindSparse")
	PtrQueueEndDebugUtilsLabelEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueEndDebugUtilsLabelEXT")
	PtrQueueInsertDebugUtilsLabelEXT                          = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueInsertDebugUtilsLabelEXT")
	PtrQueueNotifyOutOfBandNV                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueNotifyOutOfBandNV")
	PtrQueuePresentKHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkQueuePresentKHR")
	PtrQueueSetPerformanceConfigurationINTEL                  = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueSetPerformanceConfigurationINTEL")
	PtrQueueSubmit                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueSubmit")
	PtrQueueSubmit2                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueSubmit2")
	PtrQueueSubmit2KHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueSubmit2KHR")
	PtrQueueWaitIdle                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkQueueWaitIdle")
	PtrRegisterCustomBorderColorEXT                           = auto_cast PtrGetInstanceProcAddr(instance, "vkRegisterCustomBorderColorEXT")
	PtrRegisterDeviceEventEXT                                 = auto_cast PtrGetInstanceProcAddr(instance, "vkRegisterDeviceEventEXT")
	PtrRegisterDisplayEventEXT                                = auto_cast PtrGetInstanceProcAddr(instance, "vkRegisterDisplayEventEXT")
	PtrReleaseCapturedPipelineDataKHR                         = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseCapturedPipelineDataKHR")
	PtrReleaseFullScreenExclusiveModeEXT                      = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseFullScreenExclusiveModeEXT")
	PtrReleasePerformanceConfigurationINTEL                   = auto_cast PtrGetInstanceProcAddr(instance, "vkReleasePerformanceConfigurationINTEL")
	PtrReleaseProfilingLockKHR                                = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseProfilingLockKHR")
	PtrReleaseSwapchainImagesEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseSwapchainImagesEXT")
	PtrReleaseSwapchainImagesKHR                              = auto_cast PtrGetInstanceProcAddr(instance, "vkReleaseSwapchainImagesKHR")
	PtrResetCommandBuffer                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkResetCommandBuffer")
	PtrResetCommandPool                                       = auto_cast PtrGetInstanceProcAddr(instance, "vkResetCommandPool")
	PtrResetDescriptorPool                                    = auto_cast PtrGetInstanceProcAddr(instance, "vkResetDescriptorPool")
	PtrResetEvent                                             = auto_cast PtrGetInstanceProcAddr(instance, "vkResetEvent")
	PtrResetFences                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkResetFences")
	PtrResetGpaSessionAMD                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkResetGpaSessionAMD")
	PtrResetQueryPool                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkResetQueryPool")
	PtrResetQueryPoolEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkResetQueryPoolEXT")
	PtrSetDebugUtilsObjectNameEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkSetDebugUtilsObjectNameEXT")
	PtrSetDebugUtilsObjectTagEXT                              = auto_cast PtrGetInstanceProcAddr(instance, "vkSetDebugUtilsObjectTagEXT")
	PtrSetDeviceMemoryPriorityEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkSetDeviceMemoryPriorityEXT")
	PtrSetEvent                                               = auto_cast PtrGetInstanceProcAddr(instance, "vkSetEvent")
	PtrSetGpaDeviceClockModeAMD                               = auto_cast PtrGetInstanceProcAddr(instance, "vkSetGpaDeviceClockModeAMD")
	PtrSetHdrMetadataEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkSetHdrMetadataEXT")
	PtrSetLatencyMarkerNV                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkSetLatencyMarkerNV")
	PtrSetLatencySleepModeNV                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkSetLatencySleepModeNV")
	PtrSetLocalDimmingAMD                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkSetLocalDimmingAMD")
	PtrSetPrivateData                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkSetPrivateData")
	PtrSetPrivateDataEXT                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkSetPrivateDataEXT")
	PtrSetSwapchainPresentTimingQueueSizeEXT                  = auto_cast PtrGetInstanceProcAddr(instance, "vkSetSwapchainPresentTimingQueueSizeEXT")
	PtrSignalSemaphore                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkSignalSemaphore")
	PtrSignalSemaphoreKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkSignalSemaphoreKHR")
	PtrTransitionImageLayout                                  = auto_cast PtrGetInstanceProcAddr(instance, "vkTransitionImageLayout")
	PtrTransitionImageLayoutEXT                               = auto_cast PtrGetInstanceProcAddr(instance, "vkTransitionImageLayoutEXT")
	PtrTrimCommandPool                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkTrimCommandPool")
	PtrTrimCommandPoolKHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkTrimCommandPoolKHR")
	PtrUninitializePerformanceApiINTEL                        = auto_cast PtrGetInstanceProcAddr(instance, "vkUninitializePerformanceApiINTEL")
	PtrUnmapMemory                                            = auto_cast PtrGetInstanceProcAddr(instance, "vkUnmapMemory")
	PtrUnmapMemory2                                           = auto_cast PtrGetInstanceProcAddr(instance, "vkUnmapMemory2")
	PtrUnmapMemory2KHR                                        = auto_cast PtrGetInstanceProcAddr(instance, "vkUnmapMemory2KHR")
	PtrUnregisterCustomBorderColorEXT                         = auto_cast PtrGetInstanceProcAddr(instance, "vkUnregisterCustomBorderColorEXT")
	PtrUpdateDescriptorSetWithTemplate                        = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateDescriptorSetWithTemplate")
	PtrUpdateDescriptorSetWithTemplateKHR                     = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateDescriptorSetWithTemplateKHR")
	PtrUpdateDescriptorSets                                   = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateDescriptorSets")
	PtrUpdateIndirectExecutionSetPipelineEXT                  = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateIndirectExecutionSetPipelineEXT")
	PtrUpdateIndirectExecutionSetShaderEXT                    = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateIndirectExecutionSetShaderEXT")
	PtrUpdateVideoSessionParametersKHR                        = auto_cast PtrGetInstanceProcAddr(instance, "vkUpdateVideoSessionParametersKHR")
	PtrWaitForFences                                          = auto_cast PtrGetInstanceProcAddr(instance, "vkWaitForFences")
	PtrWaitForPresent2KHR                                     = auto_cast PtrGetInstanceProcAddr(instance, "vkWaitForPresent2KHR")
	PtrWaitForPresentKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkWaitForPresentKHR")
	PtrWaitSemaphores                                         = auto_cast PtrGetInstanceProcAddr(instance, "vkWaitSemaphores")
	PtrWaitSemaphoresKHR                                      = auto_cast PtrGetInstanceProcAddr(instance, "vkWaitSemaphoresKHR")
	PtrWriteAccelerationStructuresPropertiesKHR               = auto_cast PtrGetInstanceProcAddr(instance, "vkWriteAccelerationStructuresPropertiesKHR")
	PtrWriteMicromapsPropertiesEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkWriteMicromapsPropertiesEXT")
	PtrWriteResourceDescriptorsEXT                            = auto_cast PtrGetInstanceProcAddr(instance, "vkWriteResourceDescriptorsEXT")
	PtrWriteSamplerDescriptorsEXT                             = auto_cast PtrGetInstanceProcAddr(instance, "vkWriteSamplerDescriptorsEXT")
}

load_proc_addresses_global :: proc(vk_get_instance_proc_addr: rawptr) {
	PtrGetInstanceProcAddr = auto_cast vk_get_instance_proc_addr

	PtrCreateInstance                       = auto_cast PtrGetInstanceProcAddr(nil, "vkCreateInstance")
	PtrDebugUtilsMessengerCallbackEXT       = auto_cast PtrGetInstanceProcAddr(nil, "vkDebugUtilsMessengerCallbackEXT")
	PtrDeviceMemoryReportCallbackEXT        = auto_cast PtrGetInstanceProcAddr(nil, "vkDeviceMemoryReportCallbackEXT")
	PtrEnumerateInstanceExtensionProperties = auto_cast PtrGetInstanceProcAddr(nil, "vkEnumerateInstanceExtensionProperties")
	PtrEnumerateInstanceLayerProperties     = auto_cast PtrGetInstanceProcAddr(nil, "vkEnumerateInstanceLayerProperties")
	PtrEnumerateInstanceVersion             = auto_cast PtrGetInstanceProcAddr(nil, "vkEnumerateInstanceVersion")
	PtrGetExternalComputeQueueDataNV        = auto_cast PtrGetInstanceProcAddr(nil, "vkGetExternalComputeQueueDataNV")
	PtrGetInstanceProcAddr                  = auto_cast PtrGetInstanceProcAddr(nil, "vkGetInstanceProcAddr")
}

load_proc_addresses :: proc{
	load_proc_addresses_global,
	load_proc_addresses_instance,
	load_proc_addresses_device,
	load_proc_addresses_device_vtable,
	load_proc_addresses_custom,
}

