MAKEFLAGS += --no-builtin-rules
export LANG=c LC_ALL=C

TMPDIR ?= /dev/shm

LICENSES = -DLICENSE_GPL
HASHES = md/md4 md/md5 md/ripemd160 md/sha1 md/sha2_256 md/sha2_512 md/sha2_224 md/sha2_384

# custom functions
eat = $(subst _,,_)
# https://stackoverflow.com/a/18258352
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
# https://stackoverflow.com/a/14260762
rev = $(if $(wordlist 2,2,$1),$(call rev,$(wordlist 2,$(words $1),$1)) $(firstword $1),$1)
pdir = $(wordlist $1,$1,$(call rev,$(subst /, ,$2)))
# https://stackoverflow.com/a/12324443
containing = $(foreach v,$2,$(if $(findstring $1,$v),$v))
not-containing = $(foreach v,$2,$(if $(findstring $1,$v),,$v))

# awful hacky uppercase/lowercase functions
# https://stackoverflow.com/a/665045
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))

_OBJ_ASM := $(subst .S,.o,$(call containing,/asm/,$(call rwildcard,src,*.S)))
_OBJ_ASM += $(subst .c,.o,$(call containing,/asm/,$(call rwildcard,src,*.c)))
OBJ_ASM = $(subst /asm/,/xform/,$(subst src/,obj/,$(_OBJ_ASM)))
OBJ_NATIVE = $(patsubst src/%/xform.c,obj/%/xform/native.o,$(call rwildcard,src,*/xform.c))
OBJ_GENERIC = $(patsubst src/%/xform.c,obj/%/xform/generic.o,$(call rwildcard,src,*/xform.c))
OBJ_HASHES = $(patsubst %,obj/%.o,$(HASHES))
OBJ_CAN = obj/common/cpuinfo.o obj/common/can_native.o $(patsubst src/common/%.c,obj/common/%.o,$(wildcard src/common/can_*.c))
OBJ_XFORM = $(patsubst src/%/xform.c,obj/%/xform.o,$(call rwildcard,src,*/xform.c))

LIBH = $(patsubst src/libh/%_h.py,libh/%.h,$(wildcard src/libh/*_h.py))

HEADERS := util.h llhash.h
HEADERS += $(foreach h,$(HASHES),$(patsubst %,gen/%/hash.h,$h))
HEADERS += $(foreach h,$(HASHES),$(patsubst %,gen/%/hmac.h,$h))
HEADERS += $(foreach h,$(HASHES),$(patsubst %,gen/%/ext.h,$h))

MACROS = macros.h param.h libh/libh.h libh/magic.h $(LIBH)

BINARIES = test vectors sha2t
#override CFLAGS += -O3 -flto -fPIC -funsigned-char \
#-flto -ffat-lto-objects \

override CFLAGS += -O3 -fPIC \
	-Wall -Wextra -pedantic \
	-std=gnu11 -ggdb

CC := ccache gcc
AS := ccache gcc
PP := ccache cpp
LD := ccache ld

COMPILE = $(CC) $(CFLAGS)
ASSEMBLE = $(AS) $(LICENSES) -O3 -ggdb

.PHONY: all libh macros headers asm native generic \
	clean_all _clean_all clean _clean _nop \
	run_test run_vectors

all: obj/llhash.o

libh: libh/libh.h libh/magic.h $(LIBH)
macros: macros.h param.h libh
headers: macros $(HEADERS)
asm: $(OBJ_ASM)
native: $(OBJ_NATIVE)
generic: $(OBJ_GENERIC)

param.h: scripts/param.py
	python3 $< $(HASHES) > $@

# preprocessor magic
libh/libh.h: $(LIBH)
	@mkdir -p $(@D)
	awk 'BEGIN{for(;++i<ARGC;)print"#include \""ARGV[i]"\""}' \
	$(sort $(subst $(@D)/,,$(filter-out $@,$(wildcard $(@D)/*.h)))) > $@

libh/%.h: src/libh/%_h.py src/libh/util.py
	@mkdir -p $(@D)
	python3 $< > $@

# generated headers
gen/md/%/hash.h: src/md/%/param.h src/md/hash.h.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -P -C -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hash.h.in | \
	sed -En 's/^\s*#\s+/#/;/pragma once/,$$p' > $@

gen/md/%/hmac.h: src/md/%/param.h src/md/hmac.h.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -C -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hmac.h.in | \
	sed -En 's/^\s*#\s+/#/;/pragma once/,$$p' > $@

gen/md/%/ext.h: src/md/%/param.h src/md/ext.h.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -C -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/ext.h.in | \
	sed -En 's/^\s*#\s+/#/;/pragma once/,$$p' > $@

# generated c hash driver
gen/md/%/register.c: src/md/%/param.h src/md/register.c.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/register.c.in > $@

gen/md/%/hash.c: src/md/%/param.h src/md/hash.h.in src/md/hash.c.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hash.c.in > $@

gen/md/%/hmac.c: src/md/%/param.h src/md/hmac.h.in src/md/hmac.c.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/hmac.c.in > $@

gen/md/%/ext.c: src/md/%/param.h src/md/ext.h.in src/md/ext.c.in $(MACROS)
	@mkdir -p $(@D)
	$(PP) -P -D_INDIRECT=_INDIRECT -DHASH_$(call uc,$*) -include $< \
	-DHASH_name=$* -DHASH_NAME=$(call uc,$*) src/md/ext.c.in > $@

# combining these allows a bit more optimization...
gen/md/%/driver.c: gen/md/%/hash.c gen/md/%/hmac.c gen/md/%/ext.c
	@mkdir -p $(@D)
	cat $^ > $@

# c transform implementations
obj/md/%/xform/generic.o: src/md/%/xform.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -Dc_impl=generic -c $< -o $@

obj/md/%/xform/native.o: src/md/%/xform.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -march=native -Dc_impl=native -c $< -o $@

obj/md/%/xform/generic.S: src/md/%/xform.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -Dc_impl=generic -c $< -S -o $@

obj/md/%/xform/native.S: src/md/%/xform.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -march=native -Dc_impl=native -c $< -S -o $@

# core hash drivers
obj/md/%/hash.o: gen/md/%/hash.c gen/md/%/hash.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# hmac drivers
obj/md/%/hmac.o: gen/md/%/hmac.c gen/md/%/hmac.h gen/md/%/hash.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

obj/md/%/ext.o: gen/md/%/ext.c gen/md/%/ext.h gen/md/%/hmac.h gen/md/%/hash.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# impl registration
obj/md/%/register.o: gen/md/%/register.c gen/md/%/hash.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# misc
obj/common/%.o: src/common/%.c src/common/%.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

obj/common/%.o: src/common/%.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

obj/common/%.o: gen/common/%.c $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

# cpu functionality checks
obj/can.o: $(OBJ_CAN)
	$(LD) -r $^ -o $@

# individual hash module
obj/md/%/driver.o: gen/md/%/driver.c gen/md/%/hash.h gen/md/%/hmac.h gen/md/%/ext.h $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

#obj/md/%.o: obj/md/%/hash.o obj/md/%/hmac.o obj/md/%/ext.o obj/md/%/register.o
obj/md/%.o: obj/md/%/driver.o obj/md/%/register.o
	$(LD) -r $^ -o $@

obj/xform.o: $(OBJ_XFORM)
	$(LD) -r $^ -o $@

# everything
obj/llhash.o: obj/can.o obj/xform.o $(OBJ_HASHES)
	$(LD) -r $^ -o $@

# fallback build rules
%.o: %.c %.h $(MACROS) $(HEADERS)
	$(COMPILE) -c $< -o $@

%.o: %.c $(MACROS) $(HEADERS)
	$(COMPILE) -c $< -o $@

lib%.so: %.o
	$(COMPILE) -shared $< -o $@

lib%.a: %.o
	$(AR) rcs $@ $<

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

test: test.o openssl.o obj/llhash.o
	$(COMPILE) $^ -ldl -o $@

# test vector suite
obj/test_vectors.o: scripts/vector.py
	@mkdir -p gen/ $(@D)
	python3 $< c > gen/test_vectors.c
	$(CC) -fPIC -Os -c gen/test_vectors.c -o obj/test_vectors.o
	rm gen/test_vectors.c

gen/test_vectors.h: scripts/vector.py
	@mkdir -p $(@D)
	python3 $< h > $@

vectors.o: vectors.c $(MACROS) $(HEADERS) gen/test_vectors.h
	$(COMPILE) -c $< -o $@

vectors: vectors.o obj/test_vectors.o obj/llhash.o
	$(COMPILE) $^ -o $@

# run test programs
run_test: test
	./test nobench

run_vectors: vectors
	./vectors

#@awk '/_clean:/{f=1;next}/^([^\t]|$$)/{f=0}f&&sub(/\t/,"")' $(MAKEFILE_LIST)
# hack to force clean to run first *to completion* even for parallel builds
# note that $(info ...) prints everything on one line
clean_all: _nop $(foreach _,$(filter clean_all,$(MAKECMDGOALS)),$(info $(shell $(MAKE) _clean_all)))
_clean_all: _clean
	rm -rf param.h libh/libh.h $(LIBH) || /bin/true

clean: _nop $(foreach _,$(filter clean,$(MAKECMDGOALS)),$(info $(shell $(MAKE) _clean)))
_clean:
	rm -rf obj gen bin $(BINARIES) $(wildcard *.o) || /bin/true

_nop:
	@true

.SECONDARY:
.SECONDEXPANSION:
# assembly transform implementations
# if the assembler fails, we fall back to compiling dummy functions in c
obj/%.o: $$(subst /xform/,/asm/,src/$$*.S) src/common/built.S $(MACROS)
	@mkdir -p $(@D)
	$(ASSEMBLE) -c $< -o $@ || \
	$(COMPILE) -Wno-unused-parameter -DSTUBBED -x c -c $< -o $@

# c with inline assembly implementations
obj/%.o: $$(subst /xform/,/asm/,src/$$*.c) $(MACROS)
	@mkdir -p $(@D)
	$(COMPILE) -O2 -c $< -o $@ || \
	$(COMPILE) -Wno-unused-parameter -DSTUBBED -c $< -o $@

# transform registration
obj/%/xform.o: obj/%/xform/generic.o obj/%/xform/native.o \
$$(subst .c,.o,$$(subst src/$$*/asm/,obj/$$*/xform/,$$(wildcard src/$$*/asm/*.c))) \
$$(subst .S,.o,$$(subst src/$$*/asm/,obj/$$*/xform/,$$(wildcard src/$$*/asm/*.S)))
	$(LD) -r $^ -o $@
