#!/usr/bin/env python3

import sys

from util import Appender, header

h = Appender()

h.macros.indirect('BITS(n)', 'GET(_BITS_##n, ((n)<<3))')
h.macros.indirect('BYTES(n)', 'GET(_BYTES_##n, ((n)>>3))')

#h.macros.define('BITS(n)', '_BITS(n)')
#h.macros.define('BYTES(n)', '_BYTES(n)')
#h.bits.define('_BITS(...)', 'GET(_BITS_##__VA_ARGS__, ((__VA_ARGS__)<<3))')
#h.bytes.define('_BYTES(...)', 'GET(_BYTES_##__VA_ARGS__, ((__VA_ARGS__)>>3))')

for i in range(33):
    h.bits.gettable(f'_BITS_{i}', i*8)
    h.bytes.gettable(f'_BYTES_{i*8}', i)

h.print_all()
