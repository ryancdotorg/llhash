#!/usr/bin/env python3

import sys

from util import Appender, header

h = Appender()

h.macros.define('BITS(n)', 'GET(_BITS_##n, ((n)<<3))')
h.macros.define('BYTES(n)', 'GET(_BYTES_##n, ((n)>>3))')

for i in range(33):
    h.bits.gettable(f'_BITS_{i}', i*8)
    h.bytes.gettable(f'_BYTES_{i*8}', i)

h.print_all()
