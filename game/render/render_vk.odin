#+build linux, windows
#+private
package render

import "base:runtime"
import "core:fmt"
import "core:os"
import vk "ext:vulkan"
import vma "ext:vma"
import "../basic/mem"
import "../platform"


