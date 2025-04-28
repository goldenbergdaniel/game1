package devman

import "core:fmt"

import "udev"

main :: proc()
{
  entity: Entity = make_entity()
  entity->init({1, 1})
  entity->tick(1)
  entity->draw()
}

Entity_VTable :: struct
{
  init: type_of(entity_init),
  tick: type_of(entity_tick),
  draw: type_of(entity_draw),
}

entity_vtable := init_entity_vtable()
init_entity_vtable :: proc() -> Entity_VTable
{
  vtable: Entity_VTable
  vtable.init = entity_init
  vtable.tick = entity_tick
  vtable.draw = entity_draw
  return vtable
}

Entity :: struct
{
  using v_table: ^Entity_VTable,
  pos: [2]f32,
}

make_entity :: proc() -> Entity
{
  return {v_table=&entity_vtable}
}

entity_init :: proc(this: ^Entity, pos: [2]f32)
{
  this.pos = pos
}

entity_tick :: proc(this: ^Entity, dt: f32)
{
  this.pos += dt
}

entity_tick_down :: proc(this: ^Entity, dt: f32)
{
  this.pos -= dt
}

entity_draw :: proc(this: ^Entity)
{
  fmt.println(this.pos)
}

udev_test :: proc()
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