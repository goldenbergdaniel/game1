OS=$(shell uname)

ifeq ($(OS), Darwin)
all: darwin
else
all: unix
endif

unix:
	mkdir -p ../lib
	$(CC) -c -O2 -Os -fPIC stb_image.c stb_image_write.c stb_image_resize.c stb_truetype.c stb_rect_pack.c stb_vorbis.c stb_sprintf.c
	$(AR) rcs ../lib/stb_truetype.a     stb_truetype.o
	$(AR) rcs ../lib/stb_rect_pack.a    stb_rect_pack.o
	$(AR) rcs ../lib/stb_vorbis.a       stb_vorbis.o
	rm *.o

darwin:
	mkdir -p ../lib
	$(CC) -arch x86_64 -c -O2 -Os -fPIC stb_truetype.c -o stb_truetype-x86_64.o -mmacosx-version-min=10.12
	$(CC) -arch arm64  -c -O2 -Os -fPIC stb_truetype.c -o stb_truetype-arm64.o -mmacosx-version-min=10.12
	lipo -create stb_truetype-x86_64.o stb_truetype-arm64.o -output ../lib/darwin/stb_truetype.a
	$(CC) -arch x86_64 -c -O2 -Os -fPIC stb_rect_pack.c -o stb_rect_pack-x86_64.o -mmacosx-version-min=10.12
	$(CC) -arch arm64  -c -O2 -Os -fPIC stb_rect_pack.c -o stb_rect_pack-arm64.o -mmacosx-version-min=10.12
	lipo -create stb_rect_pack-x86_64.o stb_rect_pack-arm64.o -output ../lib/darwin/stb_rect_pack.a
	$(CC) -arch x86_64 -c -O2 -Os -fPIC stb_vorbis.c -o stb_vorbis-x86_64.o -mmacosx-version-min=10.12
	$(CC) -arch arm64  -c -O2 -Os -fPIC stb_vorbis.c -o stb_vorbis-arm64.o -mmacosx-version-min=10.12
	lipo -create stb_vorbis-x86_64.o stb_vorbis-arm64.o -output ../lib/darwin/stb_vorbis.a
	rm *.o
