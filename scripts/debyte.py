#!/usr/bin/env python3

import sys
import subprocess

b = bytes(map(int, sys.argv[1].split(',')))
with open('/dev/shm/x.bin', 'wb') as f:
    f.write(b)
    f.flush()
    inst = subprocess.check_output(['objdump', '-D', '-Matt,x86-64', '-b', 'binary', '-m', 'i386', '-wz', '/dev/shm/x.bin'])
    for line in inst.decode().split('\n'):
        parts = line.split('\t')
        if len(parts) > 1:
            i = parts[2].replace(' ', '\\t')
            print(f'perl -i -pe \'s/^[.]byte\s+{sys.argv[1]}$/\\t{i}/\' ../src/md/sha*/asm/*.S')
# objdump -D -Mintel,x86-64 -b binary -m i386 foo.bin
