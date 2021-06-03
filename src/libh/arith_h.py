#!/usr/bin/env python3

import sys

from util import Appender, header

MAX = int(sys.argv[1]) if len(sys.argv) > 1 else 256

h = Appender()

h.macros('#define INC(n) _DECINC(_INC_, n)')
h.macros('#define DEC(n) _DECINC(_DEC_, n)')
h.helpers('#define _DECINC(a, ...) a ## __VA_ARGS__')

h.macros('#define IDIV(a, b) _IDIV(a, b)')
h.helpers('#define _IDIV(a, ...) _IDIV_ ## a ## _ ## __VA_ARGS__')

h.macros('#define MOD(a, b) _MOD(a, b)')
h.macros('#define MODX(a, b) EQUAL(MOD(a, b), DEC(b))')
h.macros('#define MOD0(a, b) NOT(MOD(a, b))')
h.helpers('#define _MOD(a, ...) _MOD_ ## a ## _ ## __VA_ARGS__')

for i in range(MAX):
    h.compare(f'#define COMPARE_{i}(x) x')

for i in range(MAX):
    h.decinc(f'#define _INC_{i} {i+1}')
    h.decinc(f'#define _DEC_{i+1} {i}')

for i in range(MAX):
    for j in [2,3,4,5,8,16,64,128]:
        h.mod(f'#define _MOD_{i}_{j} {i%j}')
        h.idiv(f'#define _IDIV_{i}_{j} {i//j}')

print(h.all())
