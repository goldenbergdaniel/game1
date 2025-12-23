package ui

import "core:fmt"
import "core:strings"
import "../basic/mem"

@(thread_local, private)
global_tree: ^Tree


// Tree //////////////////////////////////////////////////////////////////////////////////


Tree :: struct
{
  boxes:       []Box,
  cache:       map[Box_ID]Retained_Box_Data,
  capacity:    int,
  count:       int,
  root:        ^Box,
  curr:        ^Box,
  cursor_pos:  [2]f32,
  input_down:  [enum{Curr, Prev}]bool,
  perm_arena:  ^mem.Arena,
  temp_arena: ^mem.Arena,
}

tree_init :: proc(tree: ^Tree, cap: int, perm_arena, temp_arena: ^mem.Arena)
{
  tree.boxes = make([]Box, cap, mem.allocator(perm_arena))
  tree.cache = make(map[Box_ID]Retained_Box_Data, cap, mem.allocator(perm_arena))
  tree.capacity = cap
  tree.root = tree_alloc_box(tree)
  tree.curr = tree.root
  tree.perm_arena = perm_arena
  tree.temp_arena = temp_arena
}

@(require_results)
tree_alloc_box :: proc(tree: ^Tree) -> ^Box
{
  assert(tree.count < tree.capacity)
  
  result := &tree.boxes[tree.count]
  tree.count += 1

  if tree.curr != nil
  {
    result.parent = tree.curr
    result.layout = result.parent.descendant_layout
    result.descendant_layout = result.parent.descendant_layout

    box_push_child(tree.curr, result)
  }

  return result
}

tree_clear :: proc(tree: ^Tree)
{
  for &box in tree.boxes[:]
  {
    box = {}
  }

  tree.count = 1
}

@(private)
tree_resolve_layout :: proc(tree: ^Tree)
{
  if tree.root == nil do return

  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)

  // - Standalone sizes ---
  {
    iter := make_iterator_flat(tree)
    for box in iterate_flat(&iter)
    {
      for axis in 0..=1
      {
        if box.size[axis].kind == .Pixels
        {
          box.computed_abs_dim[axis] = box.size[axis].value
        }
      }
    }
  }

  // - Upward sizes ---
  {
    iter := make_iterator_preorder(tree.root, scratch)
    for box in iterate_preorder(&iter)
    {
      for axis in 0..<2
      {
        if box.size[axis].kind == .Percent && box.parent.size[axis].kind != .Sum_Of_Children
        {
          box.computed_abs_dim[axis] = box.parent.computed_abs_dim[axis] * box.size[axis].value
        }
      }
    }
  }

  // - Downward sizes ---
  {
    iter := make_iterator_postorder(tree.root, scratch)
    for box in iterate_postorder(&iter)
    {

    }
  }

  // - Relative positions ---
  {
    iter := make_iterator_preorder(tree.root, scratch)
    for box in iterate_preorder(&iter)
    {
      offset: [2]f32

      for child := box.first; child != nil; child = child.next
      {
        offset += child.offset

        for axis in 0..<2
        {
          child.computed_rel_pos[axis] = offset[axis]
        }

        offset[box.child_align] += child.computed_abs_dim[box.child_align]
      }
    }
  }

  // - Final pass ---
  {
    iter := make_iterator_flat(tree)
    for box in iterate_flat(&iter)
    {
      box.rect_dim = box.computed_abs_dim
      box.rect_pos = box.computed_rel_pos

      if .Floating not_in box.props
      {
        for ancestor := box.parent; ancestor != nil; ancestor = ancestor.parent
        {
          box.rect_pos += ancestor.computed_rel_pos

          if .Floating in ancestor.props do break
        }
      }

      // fmt.println(node.name, node.rect_pos, node.rect_dim)
    }
  }
}

@(private)
tree_resolve_interaction :: proc(tree: ^Tree)
{
  iter := make_iterator_flat(tree)
  for box in iterate_flat(&iter)
  {
    cursor := tree.cursor_pos

    box.interaction[.Prev] = box.interaction[.Curr]

    x_intersect := cursor.x >= box.rect_pos.x && cursor.x <= box.rect_pos.x + box.rect_dim.x
    y_intersect := cursor.y >= box.rect_pos.y && cursor.y <= box.rect_pos.y + box.rect_dim.y

    box.interaction[.Curr].hovered = x_intersect && y_intersect
    box.interaction[.Curr].pressed = box.interaction[.Curr].hovered && tree.input_down[.Curr]
  }
}

tree_print_bfs :: proc(tree: ^Tree)
{
  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)

  boxes: [dynamic]^Box
  boxes.allocator = mem.allocator(scratch.arena)
  append(&boxes, tree.root)

  for i := 0; i < len(boxes); i += 1
  {
    box := boxes[i]
    fmt.println(box.name)

    for curr := box.first; curr != nil; curr = curr.next
    {
      append(&boxes, curr)
    }
  }
}

tree_print_dfs :: proc(tree: ^Tree, way: enum{Preorder, Postorder})
{
  scratch := mem.temp_begin(mem.scratch())
  defer mem.temp_end(scratch)

  switch way
  {
  case .Preorder:
    iter := make_iterator_preorder(tree.root, scratch)
    for box, idx in iterate_preorder(&iter)
    {
      fmt.println(idx, box.name)
    }

  case .Postorder:
    iter := make_iterator_postorder(tree.root, scratch)
    for box, idx in iterate_postorder(&iter)
    {
      fmt.println(idx, box.name)
    }
  }
}


// Iterators //////////////////////////////////////////////////////////////////////////////


Iterator_Flat :: struct
{
  tree: ^Tree,
  idx:  int,
}

make_iterator_flat :: proc(tree: ^Tree) -> Iterator_Flat
{
  return {tree, 0}
}

iterate_flat :: proc(it: ^Iterator_Flat) -> (elem: ^Box, idx: int, ok: bool)
{
  start := it.idx
  for &box in it.tree.boxes[start:]
  {
    defer it.idx += 1

    if box.parent != nil || it.idx == 0
    {
      return &box, it.idx-1, true
    }
  }

  return nil, it.idx, false
}

Iterator_Preorder :: struct
{
  idx:     int,
  stack:   [dynamic]^Box,
  scratch: mem.Arena_Temp,
}

make_iterator_preorder :: proc(root: ^Box, scratch: mem.Arena_Temp) -> Iterator_Preorder
{
  stack: [dynamic]^Box
  stack.allocator = mem.allocator(scratch.arena)
  append(&stack, root)
  return {0, stack, scratch}
}

iterate_preorder :: proc(it: ^Iterator_Preorder) -> (elem: ^Box, idx: int, ok: bool)
{
  if len(it.stack) > 0
  {
    elem = pop(&it.stack)

    for child := elem.last; child != nil; child = child.prev
    {
      append(&it.stack, child)
    }

    it.idx += 1
    ok = true
  }
  else
  {
    ok = false
  }

  return elem, it.idx-1, ok
}

Postorder_Stack_Element :: struct
{
  box:              ^Box, 
  children_visited: bool,
}

Iterator_Postorder :: struct
{
  idx:     int,
  stack:   [dynamic]Postorder_Stack_Element,
  scratch: mem.Arena_Temp,
}

make_iterator_postorder :: proc(root: ^Box, scratch: mem.Arena_Temp) -> Iterator_Postorder
{
  stack: [dynamic]Postorder_Stack_Element
  stack.allocator = mem.allocator(scratch.arena)
  append(&stack, Postorder_Stack_Element{root, false})
  return {0, stack, scratch}
}

iterate_postorder :: proc(it: ^Iterator_Postorder) -> (elem: ^Box, idx: int, ok: bool)
{
  for len(it.stack) > 0
  {
    wrap := pop(&it.stack)
    if wrap.children_visited || !box_has_children(wrap.box)
    {
      it.idx += 1
      return wrap.box, it.idx-1, true
    }
    else
    {
      append(&it.stack, Postorder_Stack_Element{wrap.box, true})

      for curr := wrap.box.last; curr != nil; curr = curr.prev
      {
        append(&it.stack, Postorder_Stack_Element{curr, false})
      }
    }
  }

  return nil, it.idx-1, false
}


// Box ///////////////////////////////////////////////////////////////////////////////////


Box :: struct
{
  parent:              ^Box,
  first:               ^Box,
  last:                ^Box,
  next:                ^Box,
  prev:                ^Box,

  id:                  Box_ID,
  name:                string,
  idx:                 Maybe(int),
  using layout:        Layout,
  descendant_layout:   Layout,
  retain:              bool,

  text:                string,
  sprite:              int,

  computed_rel_pos:    [2]f32,
  computed_abs_dim:    [2]f32,
  rect_pos:            [2]f32,
  rect_dim:            [2]f32,

  using retained_data: Retained_Box_Data,
}

@(private)
Retained_Box_Data :: struct
{
  interaction: [enum{Curr, Prev}]Interaction,
  counter:     int,
}

Layout :: struct
{
  props:            bit_set[Box_Prop],
  offset:           [2]f32,
  size:             [2]Size,
  color:            [4]f32,
  child_align:      Alignment,
  text_size:        f32,
  text_line_height: f32,
}

Interaction :: struct
{
  hovered: bool,
  pressed: bool,
}

Box_ID :: distinct string

Box_Prop :: enum
{
  Floating,
}

Size :: struct
{
  kind:  Size_Kind,
  value: f32,
}

Size_Kind :: enum
{
  Pixels,
  Percent,
  Sum_Of_Children,
  Text_Content,
}

Alignment :: enum
{
  Horizontal,
  Vertical,
}

current_box :: proc() -> ^Box
{
  return global_tree.curr
}

@(private)
box_has_children :: proc(box: ^Box) -> bool
{
  return box.first != nil
}

@(private)
box_get_child_at :: proc(box: ^Box, idx: int) -> (child: ^Box)
{
  pos: int
  for curr := box.first; curr != nil; curr = curr.next
  {
    child = curr
    if pos == idx do break
    pos += 1
  }

  return
}

@(private)
box_push_child :: proc(box, child: ^Box)
{
  if box.first == nil
  {
    box.first = child
    box.last = child
  }
  else
  {
    curr_last := box.last
    curr_last.next = child
    box.last = child
    box.last.prev = curr_last
  }
}

@(private)
box_pop_child :: proc(box: ^Box) -> ^Box
{
  popped: ^Box

  if box.first != nil
  {
    if box.first == box.last
    {
      popped = box.first
      box.first = nil
      box.last = nil
    }
    else
    {
      prev := box.last.prev
      box.last = prev
      box.last.next = nil
    }
  }

  return popped
}

@(private)
box_remove_child_at :: proc(box: ^Box, idx: int) -> (child: ^Box)
{
  child = box_get_child_at(box, idx)
  if child != nil
  {
    if box.first == box.last
    {
      box.first = nil
      box.last = nil
    }
    else if child == box.first
    {
      box.first.next.prev = nil
      box.first = child.next
    }
    else if child == box.last
    {
      box.last.prev.next = nil
      box.last = child.prev
    }
    else
    {
      box.first.next.prev = nil
      box.last.prev.next = nil
    }
  }
  
  return
}

@(private)
box_generate_id :: proc(box: ^Box)
{
  temp := mem.temp_begin(mem.scratch())
  defer mem.temp_end(temp)

  iter := make_iterator_preorder(box, temp)
  for box in iterate_preorder(&iter)
  {
    if box.parent == nil do continue

    id := strings.builder_make(mem.allocator(global_tree.temp_arena))

    if box.parent.parent != nil
    {
      strings.write_string(&id, string(box.parent.id))
      strings.write_string(&id, ".")
    }

    idx_int, idx_ok := box.idx.?
    if idx_ok && box.name != ""
    {
      idx_str := fmt.aprintf("%i", idx_int, allocator=mem.allocator(temp.arena))
      strings.write_string(&id, box.name)
      strings.write_string(&id, idx_str)
    }
    else if box.name != ""
    {
      strings.write_string(&id, box.name)
    }
    
    box.id = cast(Box_ID) strings.clone_from_bytes(id.buf[:], mem.allocator(global_tree.temp_arena))
  }
}

@(private)
box_cache_retained_data :: proc(box: ^Box)
{
  global_tree.cache[box.id] = box.retained_data
}

@(private)
box_fetch_retained_data :: proc(box: ^Box)
{
  data, ok := global_tree.cache[box.id]
  if ok
  {
    box.retained_data = data
    // fmt.printf("Fetched %s with count %i\n", box.id, box.counter)
  }
}


// Layout ////////////////////////////////////////////////////////////////////////////////


begin_tree :: proc(
  tree:     ^Tree,
  using st: struct
  {
    background_color: [4]f32,
    window_size:      [2]f32,
    cursor_pos:       [2]f32,
    input_down:       bool,
  },
){
  tree_clear(tree)
  
  tree.cursor_pos = cursor_pos
  tree.input_down[.Curr] = input_down
  tree.root.name = "root"
  tree.curr = tree.root
  global_tree = tree

  layout_size(.Pixels, window_size)
  layout_fill_color(background_color)
}

end_tree :: proc()
{
  temp := mem.temp_begin(mem.scratch())
  defer mem.temp_end(temp)

  tree_resolve_layout(global_tree)
  tree_resolve_interaction(global_tree)

  iter := make_iterator_preorder(global_tree.root, temp)
  for box in iterate_preorder(&iter)
  {
    if box.retain
    {
      box_cache_retained_data(box)
    }
  }

  global_tree.input_down[.Prev] = global_tree.input_down[.Curr]
  global_tree = nil
}

@(require_results)
create_box :: proc(name: string, idx: Maybe(int), retained: bool) -> ^Box
{
  box := tree_alloc_box(global_tree)
  box.parent = global_tree.curr
  box.name = name
  box.idx = idx
  box.retain = retained

  box_generate_id(box)

  if retained
  {
    box_fetch_retained_data(box)
  }
  
  return box
}

begin_box :: proc(node: ^Box)
{
  global_tree.curr = node
}

end_box :: proc()
{
  global_tree.curr = global_tree.curr.parent
}

@(deferred_none=end_box, require_results)
parent :: proc(node: ^Box) -> bool
{
  begin_box(node)
  return true
}

P :: parent

set_layout :: proc(layout: Layout)
{
  assert(global_tree.curr != nil)
  global_tree.curr.layout = layout
}

set_descendant_layout :: proc(layout: Layout)
{
  assert(global_tree.curr != nil)
  global_tree.curr.descendant_layout = layout
}

is_hovered :: proc() -> bool
{
  assert(global_tree.curr != nil)
  global_tree.curr.retain = true
  return global_tree.curr.interaction[.Curr].hovered
}

is_pressed :: proc() -> bool
{
  assert(global_tree.curr != nil)
  return global_tree.curr.interaction[.Curr].pressed
}

is_just_pressed :: proc() -> bool
{
  assert(global_tree.curr != nil)
  return global_tree.curr.interaction[.Curr].pressed && 
        !global_tree.curr.interaction[.Prev].pressed
}

layout_size :: proc(kind: Size_Kind, val: [2]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.size[0] = Size{kind, val[0]}
  global_tree.curr.size[1] = Size{kind, val[1]}
}

layout_width :: proc(kind: Size_Kind, val: f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.size.x = Size{kind, val}
}

layout_height :: proc(kind: Size_Kind, val: f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.size.y = Size{kind, val}
}

layout_offset :: proc(off: [2]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.offset = off
}

layout_fill_color :: proc(color: [4]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.color = color
}

layout_props :: proc(props: bit_set[Box_Prop])
{
  assert(global_tree.curr != nil)
  global_tree.curr.props = props
}

layout_child_align :: proc(align: Alignment)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_align = align
}

layout_text_size :: proc(size: f32)
{
  global_tree.curr.text_size = size
}

layout_text_line_height :: proc(height: f32)
{
  global_tree.curr.text_line_height = height
}


// Widgets ///////////////////////////////////////////////////////////////////////////////


box :: proc(name: string, idx: Maybe(int) = nil) -> ^Box
{
  return create_box(name == "" ? "Box" : name, idx, true)
}

spacer :: proc(width: Size, height: Size, idx: Maybe(int) = nil) -> ^Box
{
  spacer := create_box("Spacer", idx, false)

  begin_box(spacer)
  layout_width(width.kind, width.value)
  layout_height(height.kind, height.value)
  end_box()
  
  return spacer
}

text :: proc(fmt_str: string, fmt_args: ..any, idx: Maybe(int) = nil) -> ^Box
{
  text := create_box("Text", idx, false)

  begin_box(text)
  layout_text_size(2)
  layout_text_line_height(1)
  layout_fill_color({1, 1, 1, 0})
  content := fmt.aprintf(fmt_str, ..fmt_args, allocator=mem.allocator(global_tree.temp_arena))
  global_tree.curr.text = content
  end_box()

  return text
}
