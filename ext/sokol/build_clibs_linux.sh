set -e

build_lib_x64_release() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    cc -pthread -c -O2 -DNDEBUG -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

build_lib_x64_debug() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    cc -pthread -c -g -DIMPL -D$backend c/$src.c
    ar rcs $dst.a $src.o
}

# x64 + GL + Release
build_lib_x64_release sokol_log         log/sokol_log_linux_x64_gl_release SOKOL_GLCORE
build_lib_x64_release sokol_gfx         gfx/sokol_gfx_linux_x64_gl_release SOKOL_GLCORE

# x64 + GL + Debug
build_lib_x64_debug sokol_log           log/sokol_log_linux_x64_gl_debug SOKOL_GLCORE
build_lib_x64_debug sokol_gfx           gfx/sokol_gfx_linux_x64_gl_debug SOKOL_GLCORE

rm *.o
