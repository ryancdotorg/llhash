#!/usr/bin/env python3

import io
import sys

from functools import reduce
from collections.abc import Iterable
from collections import OrderedDict

class Appender:
    def __init__(self):
        self._f = io.StringIO('')
        self._d = OrderedDict()

    def __getattr__(self, name):
        return self._d.setdefault(name, Appender())

    def __call__(self, s):
        self._f.write(s.strip('\n')+'\n')

    def __str__(self):
        return self._f.getvalue()

    def all(self):
        return str(self) + ''.join(map(str, self._d.values()))

def __getattr__(name):
    global _header
    if name == 'header':
        _header()
        _header = lambda: None
        return _header
    elif name == 'MAX':
        return int(sys.argv[1]) if len(sys.argv) > 1 else 256

def _header():
    print('#pragma once\n')
    print('/* automatically generated */\n')

def OR(*args):
    if len(args) == 1 and isinstance(args[0], Iterable):
        args = iter(args[0])

    return reduce(lambda a,b: f'OR({a},{b})', args)

def AND(*args):
    if len(args) == 1 and isinstance(args[0], Iterable):
        args = iter(args[0])

    return reduce(lambda a,b: f'AND({a},{b})', args)

def ELIF(*args):
    if len(args) == 1 and isinstance(args[0], Iterable):
        args = iter(args[0])

    args = list(reversed(list(args)))
    args[0] = 'IF({})({})'.format(*args[0])
    return reduce(lambda a,b: f'IF_ELSE({b[0]})({b[1]}, {a})', args)
