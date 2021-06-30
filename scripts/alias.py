#!/usr/bin/env python3

import re
import sys

from pathlib import Path

p = Path('.')

def sha2_fn(m, f):
    ret, bits, suffix, args, end = map(m.group, range(1, 6))
    orig, alias = f'SHA2_{bits}{suffix}', f'SHA{bits}{suffix}'
    if end == ';':
        f.write(f'{ret} {alias}{args};\n')
    elif end == ' {':
        f.write(f'{ret} {alias}{args} __attribute__((alias("{orig}")));\n')

def sha2_ctx(m, f):
    bits = m.group(1)
    f.write(f'typedef SHA2_{bits}_CTX SHA{bits}_CTX;\n');

def sha2_xform(m, f):
    bits, args = m.group(1), m.group(2)
    f.write(f'void SHA{bits}_Transform{args}\n')

matchers = (
    (sha2_fn,    r'^(\S.+)\sSHA2_(\d+)((?:_\w+)?)(\(.+\))( \{|;)$'),
    (sha2_ctx,   r'^\} SHA2_(\d+)_CTX;$'),
    (sha2_xform, r'^void \(\*SHA2_(\d+)_Transform\)(\(.+\);)$'),
)

with open(sys.argv[1], 'r') as i, open(sys.argv[2], 'w') as o:
    for line in i:
        for func, regex in matchers:
            m = re.match(regex, line)
            if m:
                func(m, o)
