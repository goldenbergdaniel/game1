package mem0

import "base:intrinsics"
import "base:runtime"
import "core:mem/virtual"
import "core:mem/tlsf"

Allocator       :: runtime.Allocator
Allocator_Error :: runtime.Allocator_Error
Arena           :: virtual.Arena
Temp      			:: virtual.Arena_Temp
Heap						:: tlsf.Allocator

KIB :: 1 << 10
MIB :: 1 << 20
GIB :: 1 << 30

@(thread_local, private)
global_scratches: [2]Arena

@(init)
init_scratches :: proc "contextless" ()
{
	context = runtime.default_context()

	if err := arena_init_growing(&global_scratches[0]); err != nil
	{
		panic("Error initializing scratch arena!")
	}

	if err := arena_init_growing(&global_scratches[1]); err != nil
	{
		panic("Error initializing scratch arena!")
	}
}

copy :: #force_inline proc "contextless" (dst, src: rawptr, len: int) -> rawptr
{
	intrinsics.mem_copy(dst, src, len)
	return dst
}

set :: #force_inline proc "contextless" (data: rawptr, value: byte, len: int) -> rawptr
{
	return runtime.memset(data, i32(value), len)
}

zero :: #force_inline proc "contextless" (data: rawptr, len: int) -> rawptr
{
	intrinsics.mem_zero(data, len)
	return data
}

allocator :: proc
{
	allocator_arena,
	allocator_heap,	
}

allocator_arena :: #force_inline proc "contextless" (arena: ^Arena) -> Allocator
{
	return Allocator{
		procedure = virtual.arena_allocator_proc,
		data = arena,
	}
}

allocator_heap :: #force_inline proc "contextless" (heap: ^Heap) -> Allocator
{
	return Allocator{
		procedure = tlsf.allocator_proc,
		data = heap,
	}
}

default_allocator :: #force_inline proc() -> Allocator
{
	return runtime.default_allocator()
}

// Arena /////////////////////////////////////////////////////////////////////////////////

arena_init_buffer  :: virtual.arena_init_buffer
arena_init_growing :: virtual.arena_init_growing
arena_init_static  :: virtual.arena_init_static
arena_destroy			 :: virtual.arena_destroy

temp_begin :: virtual.arena_temp_begin
temp_end	 :: virtual.arena_temp_end

scratch :: proc(conflict: ^Arena = nil) -> ^Arena
{
	result := &global_scratches[0]

	if conflict == nil do return result

	if cast(uintptr) result.curr_block.base == cast(uintptr) conflict.curr_block.base
	{
		result = &global_scratches[1]
	}

	return result
}

// Heap //////////////////////////////////////////////////////////////////////////////////

heap_init 							 :: tlsf.init
heap_init_from_allocator :: tlsf.init_from_allocator
heap_init_from_buffer 	 :: tlsf.init_from_buffer
heap_destroy						 :: tlsf.destroy
