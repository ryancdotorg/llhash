#!/usr/bin/env python3

from util import *
from util import OR, AND, header

h = Appender()
h.define('SAME_REG(a,b)', 'EQUAL(REG32(a),REG32(b))')
h.define('DIFF_REG(a,b)', 'NOT_EQUAL(REG32(a),REG32(b))')

h.section()('#if __i386__ || __x86_64__')

pr32 = h.section()

h.section()('#endif\n\n#if __x86_64__')

pr64 = h.section()

h.section()('#endif')

pr64.indirect('REG64(x)', '_REG_64_##x')
pr32.indirect('REG32(x)', '_REG_32_##x')
pr32.indirect('REG16(x)', '_REG_16_##x')
pr32.indirect('REG8(x)',  '_REG_8_##x')

callee_saved = ('rsp', 'rbp', 'rbx', 'r12', 'r13', 'r14', 'r15')
pr64.define('CALLEE_SAVED(r)', OR(map(lambda r: f'SAME_REG(r,{r})', callee_saved)))
pr64.define('CALLER_SAVED(r)', 'COMPL(CALLEE_SAVED(r))')
pr64.define('CALLEE_SAVE(r)', 'IF(CALLEE_SAVED(r))(push %r)')
pr64.define('CALLEE_RESTORE(r)', 'IF(CALLEE_SAVED(r))(pop %r)')

def prdef(x, w, reg):
        if reg[0] in 'rxy':
            pr64.compare.comparable(reg)
        else:
            pr32.compare.comparable(reg)

        if reg[0] in 'yz' or (reg[0] == 'x' and int(reg[3:]) >= 8):
            for bits, n in ((512, 0), (256, 1), (128, 2)):
                pr64.define(f'_REG_{bits}_{reg}', w[n])
        elif reg[0] == 'x':
            for bits, n in ((512, 0), (256, 1)):
                pr64.define(f'_REG_{bits}_{reg}', w[n])
            pr32.define(f'_REG_128_{reg}', w[2])
        else:
            pr64.define(f'_REG_64_{reg}', w[0])
            for bits, n in ((32, 1), (16, 2), (8, 3)):
                if bits == 8 and reg.endswith('h'):
                    pr32.define(f'_REG_{bits}_{reg}', reg)
                else:
                    pr32.define(f'_REG_{bits}_{reg}', w[n])

for x in ('si', 'di', 'sp', 'bp'):
    w = (f'r{x}', f'e{x}', f'{x}', f'{x}l')
    for_each(lambda f: prdef(x, w, f), w)

for x in ('a', 'b', 'c', 'd'):
    w = (f'r{x}x', f'e{x}x', f'{x}x', f'{x}l', f'{x}h')
    for_each(lambda f: prdef(x, w, f), w)

for x in range(16):
    w = (f'zmm{x}', f'ymm{x}', f'xmm{x}')
    for_each(lambda f: prdef(x, w, f), w)

for x in range(8, 16):
    w = (f'r{x}', f'r{x}d', f'r{x}w', f'r{x}l')
    for_each(lambda f: prdef(x, w, f), w)

pr64.indirect('REG512(x)', '_REG_512_##x')
pr64.indirect('REG256(x)', '_REG_256_##x')
pr32.indirect('REG128(x)', '_REG_128_##x')

h.print()
