#!/usr/bin/env python3

import sys

from util import *
from util import MAX, header

h = Appender()
macros, helpers, pad = h.sections(3)

W_MAX = 2

for w in range(2, W_MAX+1):
    macros.define(f'PAD0{w}(n)', f'IF_ELSE(_NEED_PAD({w},n))(APPLY(FIRST, _PAD0{w}_ ## n()), n)')

helpers.define('_NEED_PAD(w,n)', 'IS_PAREN(APPLY(SECOND, CAT4(_PAD0,w,_,n)(), ~))')

for w in range(2, W_MAX+1):
    x = 10 ** (w-1)
    for i in range(MAX):
        if i < x:
            # neat, nested formatting works
            pad.define(f'_PAD0{w}_{i}()', f'{i:0{w}d}, ()')

h.print()
