#!/usr/bin/env python3

import sys

from util import MAX, Appender, header

h = Appender()

W_MAX = 2

for w in range(2, W_MAX+1):
    h.macros(f'#define PAD0{w}(n) IF_ELSE(_NEED_PAD({w},n))(APPLY(FIRST, _PAD0{w}_ ## n()), n)')

h.helpers('#define _NEED_PAD(w,n) IS_PAREN(APPLY(SECOND, CAT4(_PAD0,w,_,n)(), ~))')

for w in range(2, W_MAX+1):
    x = 10 ** (w-1)
    for i in range(MAX):
        if i < x:
            # neat, nested formatting works
            h.pad(f'#define _PAD0{w}_{i}() {i:0{w}d}, ()')

print(h.all())
