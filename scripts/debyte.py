#!/usr/bin/env python3

import re
import sys
import tempfile
import subprocess

from tempfile import NamedTemporaryFile

def decode(s):
    b = bytearray()
    for c in re.split(r'\s*,\s*', s):
        if c.startswith('0x'):
            b.append(int(c, 16))
        else:
            b.append(int(c))

    with NamedTemporaryFile() as tmp:
        tmp.write(bytes(b))
        tmp.flush()
        inst = subprocess.check_output([
            'objdump', '-D', '-Matt,x86-64', '-b', 'binary',
            '-m', 'i386', '-wz', tmp.name
        ])

        ret = []
        for line in inst.decode().split('\n'):
            line = line.rstrip(' ')
            parts = line.split('\t')
            try:
                if len(parts) > 1:
                    ret.append(tuple(parts[2].split(' ')))
            except:
                pass

        return ret

BYTE_RE = r'(?:0x[0-9a-fA-F]{1,2}|25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])'
with open(sys.argv[1], 'r') as f:
    for line in f:
        line = line.rstrip('\n')
        m = re.fullmatch(r'(\s*)[.]byte(\s+)('+BYTE_RE+r'(?:\s*,\s*'+BYTE_RE+r'){0,14})(?:\s+.*)?', line)
        if m:
            s1, s2, b = m.groups()
            if s1 == '': s1 = '\t'
            for x in decode(b):
                inst = '\t'.join(x)
                print(f'{s1}{inst}')
        else:
            print(line)
