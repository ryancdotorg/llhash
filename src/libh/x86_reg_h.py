#!/usr/bin/env python3

from util import OR, AND, Appender, header

pr32 = Appender()
pr64 = Appender()

pr64('#define REG64(x) CAT(_REG64_,x)')
callee_saved = ('rsp', 'rbp', 'rbx', 'r12', 'r13', 'r14', 'r15')
same_reg = lambda r: f'SAME_REG(r,{r})'
pr64('#define CALLEE_SAVED(r) '+OR(map(same_reg, callee_saved)))
pr64('#define CALLER_SAVED(r) COMPL(CALLEE_SAVED(r))')
pr32('''
#define REG32(x) CAT(_REG32_,x)
#define REG16(x) CAT(_REG16_,x)
#define REG8(x) CAT(_REG8_,x)
''')

def prdef(x, w, reg):
        if reg.startswith('r'):
            pr64('#define COMPARE_{}(x) x'.format(f))
        else:
            pr32('#define COMPARE_{}(x) x'.format(f))
        pr64('#define _REG{}_{} {}'.format(64, reg, w[0]))
        for bits, n in ((32, 1), (16, 2), (8, 3)):
            pr32('#define _REG{}_{} {}'.format(bits, reg, w[n]))

for x in ('si', 'di', 'sp', 'bp'):
    w = (f'r{x}', f'e{x}', f'{x}', f'{x}l')
    for f in w:
        prdef(x, w, f)

for x in ('a', 'b', 'c', 'd'):
    w = (f'r{x}x', f'e{x}x', f'{x}x', f'{x}l', f'{x}h')
    for f in w:
        prdef(x, w, f)

for x in range(8, 16):
    w = (f'r{x}', f'r{x}d', f'r{x}w', f'r{x}l')
    for f in w:
        prdef(x, w, f)

print('\n'.join([
'#pragma once\n',
'#define SAME_REG(a,b) EQUAL(REG32(a),REG32(b))',
'#define DIFF_REG(a,b) NOT_EQUAL(REG32(a),REG32(b))',
f'#if __i386__ || __x86_64__\n{pr32}#endif',
f'#if __x86_64__\n{pr64}#endif',
]))
