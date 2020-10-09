OBJ_SHA1 = impl/sha1_generic.o impl/sha1/sha1_native.o
OBJ_SHA2_256 = impl/sha2_256_generic.o impl/sha2_256_native.o
OBJ_SHA2_512 = impl/sha2_512_generic.o impl/sha2_512_native.o
ifeq ($(shell uname -m),x86_64)
	OBJ_SHA1     = $(patsubst %.S,%.o,$(wildcard impl/sha1_*_asm.S))
	OBJ_SHA2_256 = $(patsubst %.S,%.o,$(wildcard impl/sha2_256_*_asm.S))
	OBJ_SHA2_512 = $(patsubst %.S,%.o,$(wildcard impl/sha2_512_*_asm.S))
endif
OBJECTS = $(OBJ_SHA1) $(OBJ_SHA2_256) $(OBJ_SHA2_512)
override CFLAGS += -O3 -flto -funsigned-char \
	-Wall -Wextra -Wno-pointer-sign -Wno-sign-compare -pedantic \
	-std=gnu99 -ggdb
CC := gcc
COMPILE = $(CC) $(CFLAGS)
ASSEMBLE = $(CC) -O3 -flto -ggdb

all: $(OBJECTS)

impl/%_asm.o: impl/%_asm.S impl/built.S impl/stub.S
	$(ASSEMBLE) -DFUNCPFX=$* -c $< -o $@ || $(ASSEMBLE) -DFUNCPFX=$* -c impl/stub.S -o $@

impl/%_asm.o: impl/stub.S impl/%_asm.S

clean:
	rm -f $(OBJECTS) *.o */*.o || /bin/true
