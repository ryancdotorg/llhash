#!/usr/bin/env python3

import sys

from util import *
from util import header

h = Appender()

macros, helpers = h.section(), h.sections(2)
macros.indirect('BITS(n)', 'GET(_BITS_##n, ((n)<<3))')
macros.indirect('BYTES(n)', 'GET(_BYTES_##n, ((n)>>3))')

for i in range(33):
    helpers[0].gettable(f'_BITS_{i}', i*8)
    helpers[1].gettable(f'_BYTES_{i*8}', i)

h.print()
