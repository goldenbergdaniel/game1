package game

import "core:sync"

// Entity ///////////////////////////////////////////////////////////////////////////

Entity :: struct
{
  kind:   Entity_Kind,
  active: bool,
  pos:    [2]f32,
  vel:    [2]f32,
  dim:    [2]f32,
  color:  [4]u8,
}

Entity_Kind :: enum
{
  SHIP,
  PROJECTILE,
}

// Message //////////////////////////////////////////////////////////////////////////

Message :: struct
{
  kind:   Message_Kind,
  packet: TCP_Packet,
  next:   ^Message,
}

Message_Kind :: enum
{
  PLAYER_JOINED,
  PLAYER_LEFT,
}

Message_Queue :: struct
{
  head: ^Message,
  tail: ^Message,
  lock: sync.Mutex,
}

push_message :: proc(queue: ^Message_Queue, msg: Message)
{
  sync.mutex_guard(&queue.lock)

  new_msg := new_clone(msg)
  if queue.head == nil
  {
    queue.head = new_msg
    queue.tail = new_msg
  }
  else
  {
    queue.tail.next = new_msg
    queue.tail = new_msg
  }
}

pop_message :: proc(queue: ^Message_Queue) -> Message
{
  sync.mutex_guard(&queue.lock)

  old_head := queue.head
  queue.head = old_head.next
  result := old_head^

  if old_head.next == nil
  {
    queue.tail = nil
  }

  free(old_head)

  return result
}

peek_message :: #force_inline proc(queue: ^Message_Queue) -> Message
{
  return queue.head^
}

TCP_Packet :: struct
{
  kind: TCP_Packet_Kind
}

TCP_Packet_Kind :: enum u8
{
  PLAYER_CONNECTED,
  PLAYER_DISCONNECTED,
}

UDP_Packet :: struct
{
  kind: UDP_Packet_Kind
}

UDP_Packet_Kind :: enum u8
{
  
}
