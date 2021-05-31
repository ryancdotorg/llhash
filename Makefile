MAKEFLAGS += --no-builtin-rules

LICENSES = -DLICENSE_GPL
HASHES = md/md4 md/md5 md/sha1 md/sha2_256 md/sha2_512 md/sha2_224 md/sha2_384

# custom functions
# https://stackoverflow.com/a/18258352
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
# https://stackoverflow.com/a/14260762
rev = $(if $(wordlist 2,2,$1),$(call rev,$(wordlist 2,$(words $1),$1)) $(firstword $1),$1)
pdir = $(wordlist $1,$1,$(call rev,$(subst /, ,$2)))

# awful hacky uppercase/lowercase functions
# https://stackoverflow.com/a/665045
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))

SRC_ASM = $(filter-out src/common/%,$(call rwildcard,src,*.S))
OBJ_ASM = $(subst .S,.o,$(subst /asm/,/xform/,$(subst src/,obj/,$(SRC_ASM))))
OBJ_NATIVE = $(patsubst src/%/xform.c,obj/%/xform/native.o,$(call rwildcard,src,*/xform.c))
OBJ_GENERIC = $(patsubst src/%/xform.c,obj/%/xform/generic.o,$(call rwildcard,src,*/xform.c))
OBJ_HASHES = $(patsubst %,obj/%.o,$(HASHES))
OBJ_CAN = obj/common/cpuinfo.o obj/common/can_native.o $(patsubst src/common/%.c,obj/common/%.o,$(wildcard src/common/can_*.c))
OBJ_XFORM = $(patsubst src/%/xform.c,obj/%/xform.o,$(call rwildcard,src,*/xform.c))

#ifeq ($(shell uname -m),x86_64)
#	OBJ_SHA1     += $(patsubst %.S,%.o,$(wildcard impl/sha1_*.S))
#	OBJ_SHA2_256 += $(patsubst %.S,%.o,$(wildcard impl/sha2_256_*.S))
#	OBJ_SHA2_512 += $(patsubst %.S,%.o,$(wildcard impl/sha2_512_*.S))
#endif
BINARIES = test sha2t
#override CFLAGS += -O3 -flto -fPIC -funsigned-char \
#-flto -ffat-lto-objects \

override CFLAGS += -O3 -fPIC \
	-Wall -Wextra -pedantic \
	-std=gnu11 -ggdb

CC := ccache gcc
AS := ccache gcc
PP := ccache cpp

COMPILE = $(CC) $(CFLAGS)
ASSEMBLE = $(AS) $(LICENSES) -O3 -ggdb

all: obj/rhashc.o

asm: $(OBJ_ASM)
native: $(OBJ_NATIVE)
generic: $(OBJ_GENERIC)
headers: $(HEADERS)

# generated headers
gen/md/%/hash.h: src/md/%/param.h src/md/hash.h.in
	@mkdir -p $(@D)
	$(PP) -C -D_INDIRECT=_INDIRECT -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hash.h.in | \
	sed -En 's/^\s*#\s+/#/;/pragma once/,$$p' > $@

gen/md/%/hmac.h: src/md/%/param.h src/md/hmac.h.in
	@mkdir -p $(@D)
	$(PP) -C -D_INDIRECT=_INDIRECT -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hmac.h.in | \
	sed -En 's/^\s*#\s+/#/;/pragma once/,$$p' > $@

# generated c hash driver
gen/md/%/hash.c: src/md/%/param.h src/md/hash.h.in src/md/hash.c.in
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hash.c.in > $@

gen/md/%/hmac.c: src/md/%/param.h src/md/hmac.h.in src/md/hmac.c.in
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hmac.c.in > $@

# c transform implementations
obj/md/%/xform/generic.o: src/md/%/xform.c
	@mkdir -p $(@D)
	$(COMPILE) -Dc_impl=generic -c $< -o $@

obj/md/%/xform/native.o: src/md/%/xform.c
	@mkdir -p $(@D)
	$(COMPILE) -march=native -Dc_impl=native -c $< -o $@

# core hash drivers
obj/md/%/hash.o: gen/md/%/hash.c gen/md/%/hash.h
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# hmac drivers
obj/md/%/hmac.o: gen/md/%/hmac.c gen/md/%/hmac.h gen/md/%/hash.h
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# impl registration
obj/md/%/register.o: src/md/%/register.c gen/md/%/hash.h
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# misc
obj/common/%.o: src/common/%.c src/common/%.h
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

obj/common/%.o: src/common/%.c
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

obj/common/%.o: gen/common/%.c
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# cpu functionality checks
obj/can.o: $(OBJ_CAN)
	ld -r $^ -o $@

# individual hash module
obj/md/%.o: obj/md/%/hash.o obj/md/%/hmac.o obj/md/%/register.o
	ld -r $^ -o $@

obj/xform.o: $(OBJ_XFORM)
	ld -r $^ -o $@

# everything
obj/rhashc.o: obj/can.o obj/xform.o $(OBJ_HASHES)
	ld -r $^ -o $@

# fallback build rules
%.o: %.c %.h
	$(COMPILE) -c $< -o $@

%.o: %.c
	$(COMPILE) -c $< -o $@

%.so: %.o
	$(COMPILE) -shared $< -o $@

# check whether the native compile target matches the runtime cpu
obj/common/can_native.o: bin/helper/prcpu
	@mkdir -p $(@D)
	$< | $(COMPILE) -x c -c - -o $@

bin/helper/prcpu: obj/common/cpuinfo.o obj/common/prcpu.o
	@mkdir -p $(@D)
	$(COMPILE) $^ -o $@

bin/helper/chkcpu: obj/common/cpuinfo.o obj/common/can_native.o obj/common/chkcpu.o
	@mkdir -p $(@D)
	$(COMPILE) $^ -o $@

gen/sha2_iv.c: bin/helper/sha2t
	@mkdir -p $(@D)
	$< > $@

bin/helper/sha2t: sha2t.o
	@mkdir -p $(@D)
	$(COMPILE) $^ -ldl -o $@

test: test.o openssl.o obj/rhashc.o
	$(COMPILE) $^ -ldl -o $@

clean:
	rm -rf $(BINARIES) $(wildcard *.o) obj gen bin || /bin/true

.SECONDARY:
.SECONDEXPANSION:
# assembly transform implementations
# if the assembler fails, we fall back to compiling dummy functions in c
obj/%.o: $$(subst /xform/,/asm/,src/$$*.S) src/common/built.S
	@mkdir -p $(@D)
	$(ASSEMBLE) -c $< -o $@ || \
	$(COMPILE) -Wno-unused-parameter -DSTUBBED -x c -c $< -o $@

# transform registration
obj/%/xform.o: obj/%/xform/generic.o obj/%/xform/native.o \
$$(subst .S,.o,$$(subst src/$$*/asm/,obj/$$*/xform/,$$(wildcard src/$$*/asm/*.S)))
	ld -r $^ -o $@
