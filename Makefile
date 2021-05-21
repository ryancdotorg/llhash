MAKEFLAGS += --no-builtin-rules

OBJ_SHA1 =     impl/sha1.o impl/hmac_sha1.o impl/pbkdf2_sha1.o \
	       impl/register_sha1.o impl/sha1_generic.o impl/sha1_native.o
OBJ_SHA2_256 = impl/sha2_256.o impl/hmac_sha2_256.o impl/pbkdf2_sha2_256.o \
	       impl/register_sha2_256.o impl/sha2_256_generic.o impl/sha2_256_native.o
OBJ_SHA2_512 = impl/sha2_512.o impl/hmac_sha2_512.o impl/pbkdf2_sha2_512.o \
	       impl/register_sha2_512.o impl/sha2_512_generic.o impl/sha2_512_native.o
ifeq ($(shell uname -m),x86_64)
	OBJ_SHA1     += $(patsubst %.S,%.o,$(wildcard impl/sha1_*.S))
	OBJ_SHA2_256 += $(patsubst %.S,%.o,$(wildcard impl/sha2_256_*.S))
	OBJ_SHA2_512 += $(patsubst %.S,%.o,$(wildcard impl/sha2_512_*.S))
endif
OBJ_CPUID = can/cpuinfo.o can/can_native.o $(patsubst %.c,%.o,$(wildcard can/can_*.c))
OBJECTS = $(OBJ_SHA1) $(OBJ_SHA2_256) $(OBJ_SHA2_512) $(OBJ_CPUID)
#override CFLAGS += -O3 -flto -fPIC -funsigned-char \

override CFLAGS += -O3 -fPIC -funsigned-char \
	-Wall -Wextra -Wno-pointer-sign -Wno-sign-compare -pedantic \
	-std=gnu11 -ggdb
CC := ccache gcc
COMPILE = $(CC) $(CFLAGS)
ASSEMBLE = $(CC) -D__RHASHC_GPL_ -O3 -flto -ggdb
#ASSEMBLE = $(CC) -O3 -flto -ggdb

all: $(OBJECTS)

%.o: %.c
	$(COMPILE) -c $< -o $@

impl/register_%.o: impl/register_%.c
	$(COMPILE) -c $< -o $@

impl/%_generic.o: impl/%_c.c
	$(COMPILE) -Dc_impl=generic -c $< -o $@

impl/%_native.o: impl/%_c.c
	$(COMPILE) -march=native -Dc_impl=native -c $< -o $@

impl/%.o: impl/%.c
	$(COMPILE) -c $< -o $@

impl/%.o: impl/%.S impl/built.S impl/stub.c
	$(ASSEMBLE) -DFUNCPFX=$* -c $< -o $@ || $(COMPILE) -DFUNCPFX=$* -c impl/stub.c -o $@

sha2_iv.c: sha2t
	./$< > $@

can/can_native.c: can/prcpu
	$< > $@

can/prcpu: can/cpuinfo.o can/prcpu.o
	$(COMPILE) $^ -o $@

can/chkcpu: can/cpuinfo.o can/can_native.o can/chkcpu.o
	$(COMPILE) $^ -o $@

sha2t: sha2t.o
	$(COMPILE) $^ -ldl -o $@

test: test.o openssl.o $(OBJECTS)
	$(COMPILE) $^ -ldl -o $@

clean:
	@rm -f chkcpu prcpu can/can_native.c *.o */*.o || /bin/true

.SECONDEXPANSION:
impl/%.o: $$(subst .S,.o,$$(wildcard impl/$$*_*.S))
	ld -r -o $@ $^
