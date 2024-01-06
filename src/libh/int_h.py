#!/usr/bin/env python3

import sys

from itertools import product

from util import LineWrapper, Appender, irange, placeholders, header

bo = {"BE": "4321", "LE": "1234"}

h = Appender()

for f, s, d in (('TO_S', 'unsigned', 'signed'), ('TO_U', 'signed', 'unsigned')):
    l = LineWrapper(newline='always')
    l(f'#define {f}(X) _Generic((X)),')
    for t in ('char', 'short int', 'int', 'long int', 'long long int'):
        _s, _d = f'{s} {t}:', f'(({d} {t})(X))'
        l(f'  {_s:24} {_d},')
    l.newline = 'never'
    l(f'  {"default:":24} (X)')
    h(l)

h.print()
