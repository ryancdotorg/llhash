#!/usr/bin/env python3

import sys

from util import Appender, irange, placeholders, header

h = Appender()

MAX_ARGS = 8
args = ', '.join(placeholders('_', 1, MAX_ARGS))
h.helpers(f'#define _VA_SELECT({args}, NAME, ...) NAME')

for n in irange(2, MAX_ARGS):
    v = list(map(lambda x: chr(64+x), irange(1, n)))
    a = ','.join(v)
    m = '##_##'.join(v)
    h.join(f'#define _JOIN{n}({a}) {m}')
jargs = ', '.join(placeholders('_JOIN', MAX_ARGS, 2))
h.join(f'#define JOIN(...) _VA_SELECT(__VA_ARGS__, {jargs}, IDENTITY)(__VA_ARGS__)')

for n in irange(2, MAX_ARGS):
    v = list(map(lambda x: chr(64+x), irange(1, n)))
    a = ','.join(v)
    m = '##'.join(v)
    h.concat(f'#define _CONCAT{n}({a}) {m}')
cargs = ', '.join(placeholders('_CONCAT', MAX_ARGS, 2))
h.concat(f'#define CONCAT(...) _VA_SELECT(__VA_ARGS__, {cargs}, IDENTITY)(__VA_ARGS__)')

h.print_all()
