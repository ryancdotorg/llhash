#!/usr/bin/env python3

import sys
import hashlib, hmac

from binascii import hexlify

def rc4_prng(n, seed):
    S = bytearray(range(256))
    i, j = 0, 0

    seedlen = len(seed)
    for i in range(256):
        j = (j + S[i] + seed[i % seedlen]) & 0xff
        S[i], S[j] = S[j], S[i]

    i = j = 0
    out = bytearray(n)
    for p in range(n):
        i = (i + 1) & 0xff
        j = (j + S[i]) & 0xff
        S[i], S[j] = S[j], S[i]
        out[p] = S[(S[i] + S[j]) & 0xff]

    return out

algos = {
    'md4': 'MD4',         'md5': 'MD5',
    'sha1': 'SHA1',       'ripemd160': 'RIPEMD160',
    'sha224': 'SHA2_224', 'sha256': 'SHA2_256',
    'sha384': 'SHA2_384', 'sha512': 'SHA2_512',
}

cx00 = bytearray([0x00] * 256)
cxff = bytearray([0xff] * 256)
rand = rc4_prng(256, b'an arbitrary string')

def uchar_literal(b):
    return '{{{}}}'.format(', '.join(map(lambda c: f'0x{c:02x}', b)))

def fn_args(*a):
    return ', '.join(map(lambda v: f'unsigned char *{v}, size_t *{v}_sz', a))

# hashlib.new(algo, m)
# hmac.new(k, m, algo)

if len(sys.argv) != 2:
    sys.exit()

if sys.argv[1] == 'h':
    print('#pragma once\n')
    print('#include <stdint.h>\n#include <stddef.h>\n')
    for algo, s in algos.items():
        print(f'int {s}_hash_vector({fn_args("m", "d")}, int i);')
    print('')
    for algo, s in algos.items():
        print(f'int {s}_hmac_vector({fn_args("k", "m", "d")}, int i);')
elif sys.argv[1] == 'c':
    print('#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <string.h>\n')

    sizes = (
        0, 1, 2, 3, 4, 5, 6, 7, 8,
        55, 56, 57,
        63, 64, 65,
        111, 112, 113,
        119, 120, 121,
        127, 128, 129,
        239, 240, 241,
        247, 248, 249,
        255, 256
    )

    for algo, s in algos.items():
        vector_id = 1;
        print(f'int {s}_hash_vector({fn_args("mesg", "dgst")}, int id) {{')
        print(f'  const char algo[] = "{algo}";')
        print(f'  switch (id) {{')
        for b in (cx00, cxff, rand):
            for n in sizes:
                if n == 0 and b != cx00:
                    continue
                m = b[0:n]
                h = hashlib.new(algo, m).digest()
                mesg = uchar_literal(m)
                dgst = uchar_literal(h)
                print(f'    case {vector_id}:')
                print('      {')
                print(f'        unsigned char m[] = {mesg};')
                print('        if (*mesg_sz >= sizeof(m)) {')
                print('          *mesg_sz = sizeof(m);')
                print('          memcpy(mesg, m, sizeof(m));')
                print('        } else {')
                print('          return -1;')
                print('        }')
                print(f'        unsigned char d[] = {dgst};')
                print('        if (*dgst_sz >= sizeof(d)) {')
                print('          *dgst_sz = sizeof(d);')
                print('          memcpy(dgst, d, sizeof(d));')
                print('        } else {')
                print('          return -2;')
                print('        }')
                print('        return 1;')
                print('      }')
                print('      break;')
                vector_id += 1
        print('    default:')
        print('      return -9;')
        print('  }')
        print('  return 0;')
        print('}')

        vector_id = 1;
        print(f'int {s}_hmac_vector({fn_args("key", "mesg", "dgst")}, int id) {{')
        print(f'  const char algo[] = "{algo}";')
        print(f'  switch (id) {{')
        for b1 in (cx00, rand):
            for n1 in sizes:
                for n2 in sizes:
                    k, m = b1[0:n1], rand[0:n2]
                    h = hmac.new(k, m, algo).digest()
                    key = uchar_literal(k)
                    mesg = uchar_literal(m)
                    dgst = uchar_literal(h)
                    print(f'    case {vector_id}:')
                    print('      {')
                    print(f'        unsigned char k[] = {key};')
                    print('        if (*key_sz >= sizeof(k)) {')
                    print('          *key_sz = sizeof(k);')
                    print('          memcpy(key, k, sizeof(k));')
                    print('        } else {')
                    print('          return -1;')
                    print('        }')
                    print(f'        unsigned char m[] = {mesg};')
                    print('        if (*mesg_sz >= sizeof(m)) {')
                    print('          *mesg_sz = sizeof(m);')
                    print('          memcpy(mesg, m, sizeof(m));')
                    print('        } else {')
                    print('          return -2;')
                    print('        }')
                    print(f'        unsigned char d[] = {dgst};')
                    print('        if (*dgst_sz >= sizeof(d)) {')
                    print('          *dgst_sz = sizeof(d);')
                    print('          memcpy(dgst, d, sizeof(d));')
                    print('        } else {')
                    print('          return -3;')
                    print('        }')
                    print('        return 1;')
                    print('      }')
                    print('      break;')
                    vector_id += 1
        print('    default:')
        print('      return -9;')
        print('  }')
        print('  return 0;')
        print('}')
