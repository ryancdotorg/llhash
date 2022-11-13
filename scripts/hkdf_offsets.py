#!/usr/bin/env python3

from sys import argv, stderr, stdout, version_info
from functools import partial
eprint = partial(print, file=stderr)

HASH_WORD_SIZE = int(argv[1])
HASH_BLOCK_LENGTH = int(argv[2])
HASH_DIGEST_LENGTH = int(argv[3])
info_sz = int(argv[4])

ioff = irem = 0
BITS_SZ = HASH_WORD_SIZE//4

dlen = HASH_DIGEST_LENGTH + info_sz + 1
if dlen < (HASH_BLOCK_LENGTH*3-(BITS_SZ)):
    iblk = irem = 0
    blocks = 0
    pad = -1
    while pad < 0:
        blocks += 1
        pad = blocks * HASH_BLOCK_LENGTH - (dlen + 1 + BITS_SZ)

    print(f'head[{blocks}]: [T:{HASH_DIGEST_LENGTH}||info(0:{info_sz}):{info_sz}||block:1||0x80||pad:{pad}||bits:{BITS_SZ}]')
    print(f'tail[0]: [None]')
    print(f'blkptr:  head + {HASH_DIGEST_LENGTH + info_sz}')
else:
    ioff = ((HASH_DIGEST_LENGTH + info_sz) & ~(HASH_BLOCK_LENGTH-1)) - HASH_DIGEST_LENGTH
    irem = info_sz - ioff

    blocks = 0
    pad = -1
    while pad < 0:
        blocks += 1
        pad = blocks * HASH_BLOCK_LENGTH - (irem + 2 + BITS_SZ)

    print(ioff, irem)
    brem = HASH_BLOCK_LENGTH-HASH_DIGEST_LENGTH
    dblk = (ioff-brem) // HASH_BLOCK_LENGTH
    print(f'head[1]: [T:{HASH_DIGEST_LENGTH}||info(0:{brem}):{brem}]')
    print(f'data[{dblk}]: [info({brem}:{ioff}):{ioff-brem}]')
    print(f'tail[{blocks}]: [info({ioff}:{info_sz}):{irem}||block:1||0x80||pad:{pad}||bits:{BITS_SZ}]')
    blkptr = irem
    print(f'blkptr:  tail + {irem}')

