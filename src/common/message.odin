package common

import "core:sync"

Message :: struct
{
  kind: Message_Kind,
  packet: TCP_Packet,
  next: ^Message,
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
  sync.mutex_lock(&queue.lock)

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
  
  sync.mutex_unlock(&queue.lock)
}

pop_message :: proc(queue: ^Message_Queue) -> Message
{
  sync.mutex_lock(&queue.lock)

  old_head := queue.head
  queue.head = old_head.next
  result := old_head^

  if old_head.next == nil
  {
    queue.tail = nil
  }

  free(old_head)

  sync.mutex_unlock(&queue.lock)

  return result
}

peek_message :: #force_inline proc(queue: ^Message_Queue) -> Message
{
  return queue.head^
}
