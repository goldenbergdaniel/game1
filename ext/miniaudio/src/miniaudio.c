// #define STB_VORBIS_HEADER_ONLY
// #include "../../stb/src/stb_vorbis.c" /* Enables Vorbis decoding. */

#define MINIAUDIO_IMPLEMENTATION
#define MA_NO_GENERATOR
#define MA_ENABLE_ONLY_SPECIFIC_BACKENDS
#define MA_ENABLE_PULSEAUDIO
// #define MA_DEBUG_OUTPUT
#include "miniaudio.h"

/* stb_vorbis implementation must come after the implementation of miniaudio. */
// #undef STB_VORBIS_HEADER_ONLY
// #include "../../stb/src/stb_vorbis.c"
