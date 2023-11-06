#!/usr/bin/env python3

import sys

from util import *
from util import ELIF, MAX, lutmacro, header

def ALTER(x):
    return ELIF(map(lambda n: (f'EQUAL(_MOD(r,{x}),{n})',chr(97+n)),range(x)))

def ROTATE_L(x):
    rot = list(map(lambda n: chr(97+n), range(x)))
    rot *= 2
    return ELIF(map(lambda n: (f'EQUAL(_MOD(r,{x}),{n})','PASS(' + ', '.join(rot[x-n:][:x]) + ')'), range(x)))

def ROTATE_R(x):
    rot = list(map(lambda n: chr(97+n), range(x)))
    rot *= 2
    return ELIF(map(lambda n: (f'EQUAL(_MOD(r,{x}),{n})','PASS(' + ', '.join(rot[n:][:x]) + ')'), range(x)))

h = Appender()

macros, helpers, compare = h.sections(3)

def lut(name, fn, *args):
    main, entry = lutmacro(name, fn, *args)
    macros.indirect(*main)
    for e in entry:
        helpers.define(*e)

div = (2,3,4,5,8,16,20,32,64,128)

lut('INC', lambda x: x+1, range(MAX))
lut('DEC', lambda x: x-1, range(1, MAX+1))
lut('MOD', lambda a, b: a % b, range(MAX), div)
lut('IDIV', lambda a, b: a // b, range(MAX), div)
#lut('ADD', lambda a, b: a + b, range(MAX), range(MAX))
#lut('MULT', lambda a, b: a * b, range(MAX), div)

for i in range(8):
    macros(f'#define ADD{i}(a) ' + ('INC(' * i) + 'a' + (')' * i))

for i in range(8):
    macros(f'#define SUB{i}(a) ' + ('DEC(' * i) + 'a' + (')' * i))

macros('#define ODD(a) _MOD(a, 2)')
macros('#define EVEN(a) COMPL(_MOD(a, 2))')
macros('#define ODD_EVEN(r, a, b) IF_ELSE(_MOD(r, 2))(a, b)')
macros('#define EVEN_ODD(r, a, b) IF_ELSE(_MOD(r, 2))(b, a)')
macros('#define ALTER2(r, a, b) EVEN_ODD(r, a, b)')
macros('#define ALTER3(r, a, b, c) ' + ALTER(3))
macros('#define ALTER4(r, a, b, c, d) ' + ALTER(4))
macros('#define ROTATE2L(r, a, b) ' + ROTATE_L(2))
macros('#define ROTATE2R(r, a, b) ' + ROTATE_R(2))
macros('#define ROTATE3L(r, a, b, c) ' + ROTATE_L(3))
macros('#define ROTATE3R(r, a, b, c) ' + ROTATE_R(3))
macros('#define ROTATE4L(r, a, b, c, d) ' + ROTATE_L(4))
macros('#define ROTATE4R(r, a, b, c, d) ' + ROTATE_R(4))
macros('#define ROTATE5L(r, a, b, c, d, e) ' + ROTATE_L(5))
macros('#define ROTATE5R(r, a, b, c, d, e) ' + ROTATE_R(5))
macros('#define ROTATE8L(r, a, b, c, d, e, f, g, h) ' + ROTATE_L(8))
macros('#define ROTATE8R(r, a, b, c, d, e, f, g, h) ' + ROTATE_R(8))
#macros('#define MODX(a, b) EQUAL(MOD(a, b), DEC(b))')
#macros('#define MOD0(a, b) NOT(MOD(a, b))')

compare = h.section()
for i in range(64):
    compare.comparable(i)

h.print()
