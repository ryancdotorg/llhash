#!/usr/bin/env python3

from sys import argv, stderr, stdout, version_info
from functools import partial
eprint = partial(print, file=stderr)

import json

algo = argv[1]
test = int(argv[2])

ref = []
vec = []

with open('vec_ref.ndjson') as f:
    printing = False
    for line in map(str.strip, f):
        if line[0] != '{': continue
        obj = json.loads(line)
        if printing:
            if obj['type'] == 'test':
                break
            ref.append(line)
        else:
            if obj['type'] == 'test' and obj['algo'] == algo and obj['id'] == test:
                printing = True
                ref.append(line)

with open('vec.out') as f:
    printing = False
    for line in map(str.strip, f):
        if line[0] != '{': continue
        obj = json.loads(line)
        if printing:
            if obj['type'] == 'test':
                break
            vec.append(line)
        else:
            if obj['type'] == 'test' and obj['algo'] == algo and obj['id'] == test:
                printing = True
                vec.append(line)

for i, r in enumerate(ref):
    v = vec[i]
    if i == 0:
        print(v)
    else:
        if r != v:
            print('VEC:', v)
            print('REF:', r)
