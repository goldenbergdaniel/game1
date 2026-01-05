#+build darwin
#+private
package render

import mtl "vendor:darwin/Metal"

mtl_init :: proc()
{
  queue mtl.CommandQeue
  mtl.CommandQueue_comandBuffer(queue)
}
