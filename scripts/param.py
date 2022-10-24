#!/usr/bin/env python3

from sys import argv, stderr, stdout, version_info
from functools import partial
eprint = partial(print, file=stderr)

print('#pragma once\n')

names = list(argv[1:])
last_i = len(names) - 1
for i, name in enumerate(names):
    NAME = name.upper()
    if i == 0: first, last = True, False
    elif i == last_i: first, last = False, True
    else: first, last = False, False

    print(f'#{"if" if first else "elif"} defined(HASH_{NAME})')
    print(f'# ifdef HASH_NAME')
    print(f'# undef HASH_NAME')
    print(f'# endif')
    print(f'# define HASH_NAME {NAME}')
    print(f'# ifdef HASH_name')
    print(f'# undef HASH_name')
    print(f'# endif')
    print(f'# define HASH_name {name}')
    print(f'# include "src/md/{name}/param.h"')
    if last: print('#endif')
