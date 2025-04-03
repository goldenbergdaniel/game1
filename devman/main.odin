package devman

import "core:fmt"

import "udev"

main :: proc()
{
  inst := udev.new()
  defer udev.unref(inst)

  enumerate := udev.enumerate_new(inst)
  defer udev.enumerate_unref(enumerate)
  udev.enumerate_scan_devices(enumerate)
  first_device := udev.enumerate_get_list_entry(enumerate)
  
  iterator := udev.make_list_entry_iterator(first_device)
  for entry in udev.iterate_list_entries(&iterator)
  {
    path := udev.list_entry_get_name(entry)
    device := udev.device_new_from_syspath(inst, path)
    defer udev.device_unref(device)

    devnode := udev.device_get_devnode(device)
    if len(devnode) > 0
    {
      devpath := udev.device_get_devpath(device)
      
      devtype := udev.device_get_devtype(device)
      if devtype == nil do devtype = "unknown"
      
      fmt.println("node:", devnode)
      fmt.println("path:", devpath)
      fmt.println("type:", devtype)
      fmt.println()
    }
  }
}
