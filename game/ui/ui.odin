package ui

import "core:fmt"
import "core:log"
import "core:strings"
import "../basic/mem"

@(thread_local)
global_tree: ^Tree


// Tree //////////////////////////////////////////////////////////////////////////////////


Tree :: struct
{
  boxes:           []Box,
  cache:           map[Box_ID]Retained_Data,
  capacity:        int,
  count:           int,
  root:            ^Box,
  curr:            ^Box,
  cursor_pos:      [2]f32,
  last_cursor_pos: [2]f32,
  mouse_btn_down:  [Mouse_Btn_Kind]bool,
  perm_arena:      ^mem.Arena,
  temp_arena:      ^mem.Arena,
}

tree_init :: proc(tree: ^Tree, cap: int, perm_arena, temp_arena: ^mem.Arena)
{
  tree.boxes = make([]Box, cap, mem.allocator(perm_arena))
  tree.cache = make(map[Box_ID]Retained_Data, cap, mem.allocator(perm_arena))
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

  scratch := mem.temp_begin(mem.get_scratch())
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
        else if box.size[axis].kind == .Text_Content
        {
          text_size: [2]f32
          for r in box.text
          {
            glyph := glyph_from_rune(r)
            text_size[0] += glyph.advance.x * box.text_size
          }
          
          text_size[1] += max_height_from_text(box.text) * box.text_size

          box.computed_abs_dim[axis] = text_size[axis]
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
        if box.size[axis].kind == .Percent_Of_Parent
        {
          assert(box.parent != nil)
          if box.parent.size[axis].kind != .Sum_Of_Children
          {
            box.computed_abs_dim[axis] = box.parent.computed_abs_dim[axis] * box.size[axis].value
          }

          // fmt.println("  Up:", box.id, box.computed_abs_dim[axis])
        }
      }
    }
  }

  // - Downward sizes ---
  {
    iter := make_iterator_postorder(tree.root, scratch)
    for box in iterate_postorder(&iter)
    {
      for axis in 0..<2
      {
        if box.size[axis].kind == .Sum_Of_Children
        {
          for child := box.first; child != nil; child = child.next
          {
            if child.size[axis].kind == .Percent_Of_Parent do continue
            if .Floating in child.props do continue

            box.computed_abs_dim[axis] += child.computed_abs_dim[axis]
            // fmt.println("Down:", child.id, box.computed_abs_dim[axis])
          }
        }
      }
    }
  }

  // - Relative positions ---
  {
    iter := make_iterator_preorder(tree.root, scratch)
    for box in iterate_preorder(&iter)
    {
      offset: [2]f32

      if .Floating in box.props
      {
        box.computed_rel_pos = box.offset
      }

      for child := box.first; child != nil; child = child.next
      {
        if .Floating in child.props do continue

        offset += child.offset

        for axis in 0..<2
        {
          switch box.child_justify[axis]
          {
          case .Left:
            child.computed_rel_pos[axis] = offset[axis]
          
          case .Center:
            child.computed_rel_pos[axis] = box.computed_abs_dim[axis]/2 - child.computed_abs_dim[axis]/2 + offset[axis]
          }
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

      box.color.rgb *= box.shade

      // fmt.println(node.name, node.rect_pos, node.rect_dim)
    }
  }
}

@(private)
tree_resolve_signals :: proc(tree: ^Tree)
{
  iter := make_iterator_flat(tree)
  for box in iterate_flat(&iter)
  {
    cursor := tree.cursor_pos

    x_intersect := cursor.x > box.rect_pos.x && cursor.x < box.rect_pos.x + box.rect_dim.x
    y_intersect := cursor.y > box.rect_pos.y && cursor.y < box.rect_pos.y + box.rect_dim.y
    intersects := x_intersect && y_intersect

    box.signal[.Prev] = box.signal[.Curr]
    box.signal[.Curr].flags = {}
    
    box.signal[.Curr].flags += intersects ? {.Hovered} : {}
    box.signal[.Curr].flags += global_tree.mouse_btn_down[.Left] && intersects ? {.Left_Pressed} : {}
    box.signal[.Curr].flags += global_tree.mouse_btn_down[.Right] && intersects ? {.Right_Pressed} : {}
    box.signal[.Curr].flags += global_tree.mouse_btn_down[.Middle] && intersects ? {.Middle_Pressed} : {}
  }
}

tree_print_bfs :: proc(tree: ^Tree)
{
  scratch := mem.temp_begin(mem.get_scratch())
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
  scratch := mem.temp_begin(mem.get_scratch())
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
  decorated_text:      Decorated_String,
  sprite:              int,

  computed_rel_pos:    [2]f32,
  computed_abs_dim:    [2]f32,
  rect_pos:            [2]f32,
  rect_dim:            [2]f32,

  using retained_data: Retained_Data,
}

Box_ID :: distinct string

Box_Prop :: enum
{
  Floating,
  Dragable,
}

@(private)
Retained_Data :: struct
{
  signal: [enum{Curr, Prev}]Signal,
}

Layout :: struct
{
  props:           bit_set[Box_Prop],
  offset:          [2]f32,
  offset_dir:      [2]enum{FWD, BWD},
  size:            [2]Size,
  color:           [4]f32,
  shade:           [3]f32,
  text_size:       f32,

  child_size:      [2]Size,
  child_align:     Alignment,
  child_justify:   [2]Justify,
  child_text_size: f32,
}

Mouse_Btn_Kind :: enum
{
  Left,
  Right,
  Middle,
}

Signal :: struct
{
  flags: bit_set[Signal_Flag],
}

Signal_Flag :: enum
{
  Left_Pressed,
  Right_Pressed,
  Middle_Pressed,
  Hovered,
}

Size :: struct
{
  kind:  Size_Kind,
  value: f32,
}

Size_Kind :: enum
{
  Pixels,
  Percent_Of_Parent,
  Sum_Of_Children,
  Text_Content,
}

px           :: proc(val: f32) -> Size { return {.Pixels, val} }
pct          :: proc(val: f32) -> Size { return {.Percent_Of_Parent, val} }
fit_children :: proc() -> Size { return {.Sum_Of_Children, 0}}
fit_text     :: proc() -> Size { return {.Text_Content, 0} }

Alignment :: enum
{
  Horizontal,
  Vertical,
}

Justify :: enum
{
  Left,
  Center,
}

this :: #force_inline proc() -> ^Box
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
  temp := mem.temp_begin(mem.get_scratch())
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
  id_str := cast(string) box.id
  if box.id not_in global_tree.cache
  {
    id_str, _ = strings.clone(string(box.id), mem.allocator(global_tree.perm_arena))
  }

  global_tree.cache[Box_ID(id_str)] = box.retained_data
}

@(private)
box_fetch_retained_data :: proc(box: ^Box)
{
  data, ok := global_tree.cache[box.id]
  if ok
  {
    box.retained_data = data
  }
}


// Layout ////////////////////////////////////////////////////////////////////////////////


begin_tree :: proc(
  tree: ^Tree,
  st: struct
  {
    background_color: [4]f32,
    window_size:      [2]f32,
    cursor_pos:       [2]f32,
    mouse_btn_down:   [Mouse_Btn_Kind]bool,
  },
){
  tree_clear(tree)
  
  tree.cursor_pos = st.cursor_pos
  tree.mouse_btn_down = st.mouse_btn_down
  tree.root.name = "root"
  tree.root.shade = {1, 1, 1}
  tree.curr = tree.root
  global_tree = tree

  layout_width(px(st.window_size.x))
  layout_height(px(st.window_size.y))
  layout_color(st.background_color)
}

end_tree :: proc()
{
  temp := mem.temp_begin(mem.get_scratch())
  defer mem.temp_end(temp)

  tree_resolve_layout(global_tree)
  tree_resolve_signals(global_tree)

  iter := make_iterator_preorder(global_tree.root, temp)
  for box in iterate_preorder(&iter)
  {
    if box.retain
    {
      box_cache_retained_data(box)
    }
  }

  global_tree.last_cursor_pos = global_tree.cursor_pos
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
  box.size[0] = pct(1)
  box.size[1] = pct(1)
  box.shade = {1, 1, 1}

  box_generate_id(box)

  if retained
  {
    box_fetch_retained_data(box)
  }

  // fmt.println("Generated", box.id, box.retain)
  
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

pressed :: proc(box: ^Box, btn: Mouse_Btn_Kind) -> bool
{
  if btn == .Left
  {
    return .Left_Pressed in box.signal[.Curr].flags
  }
  else if btn == .Right
  {
    return .Right_Pressed in box.signal[.Curr].flags
  }
  else
  {
    return .Middle_Pressed in box.signal[.Curr].flags
  }
}

just_pressed :: proc(box: ^Box, btn: Mouse_Btn_Kind) -> bool
{
  if btn == .Left
  {
    return .Left_Pressed in box.signal[.Curr].flags && .Left_Pressed not_in box.signal[.Prev].flags
  }
  else if btn == .Right
  {
    return .Right_Pressed in box.signal[.Curr].flags && .Right_Pressed not_in box.signal[.Prev].flags
  }
  else
  {
    return .Middle_Pressed in box.signal[.Curr].flags && .Middle_Pressed not_in box.signal[.Prev].flags
  }
}

hovered :: proc(box: ^Box) -> bool
{
  return .Hovered in box.signal[.Curr].flags
}

layout_width :: proc(size: Size)
{
  assert(global_tree.curr != nil)
  global_tree.curr.size.x = size
}

layout_child_width :: proc(size: Size)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_size.x = size
}

layout_height :: proc(size: Size)
{
  assert(global_tree.curr != nil)
  global_tree.curr.size.y = size
}

layout_child_height :: proc(size: Size)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_size.y = size
}

layout_offset :: proc(off: [2]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.offset = off
}

layout_offset_dir :: proc(dir: [2]enum{FWD, BWD})
{
  assert(global_tree.curr != nil)
  global_tree.curr.offset_dir = dir
}

layout_follow_cursor :: proc()
{
  assert(global_tree.curr != nil)
  global_tree.curr.offset = global_tree.cursor_pos - global_tree.last_cursor_pos
}

layout_color :: proc(color: [4]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.color = color
}

layout_shade :: proc(shade: [3]f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.shade = shade
}

layout_props :: proc(props: bit_set[Box_Prop])
{
  assert(global_tree.curr != nil)
  global_tree.curr.props = props
}

layout_text_size :: proc(size: f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.text_size = size
}

layout_child_text_size :: proc(size: f32)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_text_size = size
}

layout_child_align :: proc(align: Alignment)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_align = align
}

layout_child_justify :: proc(justify: [2]Justify)
{
  assert(global_tree.curr != nil)
  global_tree.curr.child_justify = justify
}
