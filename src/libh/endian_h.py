#!/usr/bin/env python3

import sys

from itertools import product

from util import LineWrapper, Appender, irange, placeholders, header

bo = {"BE": "4321", "LE": "1234"}

h = Appender()
func = h.section()
indir = h.section()
alias = h.section()
stor = h.section()

for width, order in product((64, 32), ('BE', 'LE')):
    indir.define(f'_U{width}_H_{bo[order]}(V)',f'U{width}H2{order}(V)')

    l = LineWrapper(newline='always')
    l(f'#define U{width}H2{order}(V) __extension__({{')
    l(f'  uint{width}_t _v = (V);')
    l(f'  uint8_t _t[{width//8}];')
    for i in range(width//8):
        sw = width - 8 * (i + 1) if order == 'BE' else i * 8
        if width == 64:
            l(f'  _t[{i}] = (_v & UINT64_C(0x{255<<sw:016X})) >> {sw:2};')
        elif width == 32:
            l(f'  _t[{i}] = (_v & UINT32_C(0x{255<<sw:08X})) >> {sw:2};')
    l(f'  *((uint{width}_t*)_t);')
    l.newline = 'never'
    l('});')
    func(l)

    indir.define(f'_U{width}_{bo[order]}_H(V)',f'U{width}{order}2H(V)')
    l = LineWrapper(newline='always')
    l(f'#define U{width}{order}2H(V) __extension__({{')
    l(f'  uint{width}_t _v = (V);')
    l(f'  uint8_t *_t = (uint8_t*)&_v;')
    l(f'  uint{width}_t _r = 0;')
    for i in range(width//8):
        sw = width - 8 * (i + 1) if order == 'BE' else i * 8
        l(f'  _r |= ((uint{width}_t)_t[{i}]) << {sw:2};')
    l('  _r;')
    l.newline = 'never'
    l('});')
    func(l)

for width, order in product(('WS', '64', '32'), ('DE', 'BE', 'LE')):
    stor.define(
        f'STOR{width}{order}(D, V)',
        f'(*((uint{width}_t*)(D)) = U{width}H2{order}((V))'
    )

alias.define('UWSH2LE(V)','CONCAT(_U,HASH_WORD_BITS,_H_,__ORDER_LITTLE_ENDIAN__)(V)')
alias.define('UWSH2BE(V)','CONCAT(_U,HASH_WORD_BITS,_H_,__ORDER_BIG_ENDIAN__)(V)')
alias.define('UWSH2DE(V)','CONCAT(_U,HASH_WORD_BITS,_H_,HASH_ENDIAN)(V)')
alias.define('U32H2DE(V)','CONCAT(_U32_H_,HASH_ENDIAN)(V)')
alias.define('U64H2DE(V)','CONCAT(_U64_H_,HASH_ENDIAN)(V)')

alias.define('UWSLE2H(V)','CONCAT(_U,HASH_WORD_BITS,_,__ORDER_LITTLE_ENDIAN__,_H)(V)')
alias.define('UWSBE2H(V)','CONCAT(_U,HASH_WORD_BITS,_,__ORDER_BIG_ENDIAN__,_H)(V)')
alias.define('UWSDE2H(V)','CONCAT(_U,HASH_WORD_BITS,_,HASH_ENDIAN,_H)(V)')
alias.define('U32DE2H(V)','CONCAT(_U32_,HASH_ENDIAN,_H)(V)')
alias.define('U64DE2H(V)','CONCAT(_U64_,HASH_ENDIAN,_H)(V)')

h.print()
