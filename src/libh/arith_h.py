#!/usr/bin/env python3

import sys

from util import *
from util import ELIF, MAX, lutmacro, header

def ALTER(x):
    return ELIF(map(lambda n: (f'EQUAL(_MOD(r,{x}),{n})',chr(97+n)),range(x)))

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
#macros('#define MODX(a, b) EQUAL(MOD(a, b), DEC(b))')
#macros('#define MOD0(a, b) NOT(MOD(a, b))')

compare = h.section()
for i in range(64):
    compare.comparable(i)

h.print()
