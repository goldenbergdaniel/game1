#!/bin/bash

c++ vk_mem_alloc.c -lvulkan -c -O2 -fno-exceptions
ar -crs vk_mem_alloc.a vk_mem_alloc.o
rm -f *.o
