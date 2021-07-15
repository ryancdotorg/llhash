#!/usr/bin/env python3

import io
import re
import sys

from functools import reduce
from itertools import chain, product
from collections.abc import Iterable, Iterator
from collections import OrderedDict

__all__ = ['LineWrapper', 'Appender', 'irange', 'placeholders']

class LineWrapper:
    def __init__(self, length=78, continuation='\\'):
        self._f = io.StringIO('')
        self._line = ''
        self.line_length = length
        self.continuation = continuation

    def __call__(self, *args):
        for s in args:
            if len(self._line) + len(s) > self.line_length:
                self.linebreak()
            self._line += s

    def __str__(self):
        self._f.write(self._line)
        s = self._f.getvalue()
        self._f = None
        return s

    def linebreak(self):
        if self._line[-1] != ' ':
            self._line += ' '
        self._f.write(self._line + self.continuation + '\n')
        self._line = ''

class Appender:
    def __init__(self):
        self._f = io.StringIO('')
        self._d = OrderedDict()
        self._s = 0

    def __getattr__(self, name):
        return self.section(name)

    def __call__(self, s):
        self.append(s)

    def __str__(self):
        return self._f.getvalue()

    def _writeln(self, s):
        self._f.write(s.strip('\n')+'\n')

    # basic stuff
    def section(self, name=None):
        if name is None:
            name = (id(self), self._s)
            self._s += 1

        return self._d.setdefault(name, Appender())

    def append(self, s):
        if isinstance(s, (list, tuple, Iterator)):
            for line in s:
                self._writeln(line)
        else:
            self._writeln(s)

    # helpers
    def define(self, k, v):
        self._f.write(f'#define {k} {v}\n')

    def indirect(self, k, v):
        m = re.match(r'(\w+)\s*[(]([^)]*)[)]', k)
        if m:
            name = m.group(1)
            args = re.split(r',\s*', m.group(2).strip(' \t\r\n'))
            self.define(k, f'_{name}({", ".join(args)})')
            if args[-1] != '...':
                v = re.sub(r'\b'+args[-1]+r'\b', '__VA_ARGS__', v)
                args[-1] = '...'
            self.define(f'_{name}({", ".join(args)})', v)

    def gettable(self, k, v):
        self._f.write(f'#define {k}() {v}, ()\n')

    def comparable(self, k):
        self._f.write(f'#define _COMPARE_{k}(x) x\n')

    # output
    def print(self):
        print(str(self).strip('\n'))

    def all(self):
        return str(self) + ''.join(map(str, self._d.values()))

    def print_all(self):
        print(self.all().strip('\n'))

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

def irange(a, b=None, i=1):
    if b is None:
        b = a
        a = 0

    if a > b:
        i = -i

    return range(a, b + i, i)

def placeholders(pfx, a, b=None, i=1):
    return map(lambda x: f'{pfx}{x}', irange(a, b, i))

def first_rest(*args):
    if len(args) == 1:
        rest = iter(args[0])
        return (next(rest), rest)
    elif len(args) == 3:
        first, rest, iterable = args
        i = iter(iterable)
        first(next(i))
        rest(i)
    else:
        raise TypeError(f'first_rest() takes 1 or 3 arguments ({len(args)} given)')

def lutmacro(name, fn, *args):
    if len(args) > 26:
        raise TypeError(f'Too many macro arguments, max 26 ({len(args)} given)')
    p = list(map(chr, range(65, 65+len(args))))
    main = (f'{name}({", ".join(p)})', f'_{name}_##{"##_##".join(p)}')
    helper = lambda a: (f'_{name}_{"_".join(map(str, a))}', fn(*a))
    return (main, map(helper, product(*args)))

def OR(*args):
    if len(args) == 1 and isinstance(args[0], Iterable): args = iter(args[0])
    return reduce(lambda a,b: f'OR({a},{b})', args)

def AND(*args):
    if len(args) == 1 and isinstance(args[0], Iterable): args = iter(args[0])
    return reduce(lambda a,b: f'AND({a},{b})', args)

def ELIF(*args):
    if len(args) == 1 and isinstance(args[0], Iterable): args = iter(args[0])
    args = list(reversed(list(args)))
    args[0] = 'IF({})({})'.format(*args[0])
    return reduce(lambda a,b: f'IF_ELSE({b[0]})({b[1]}, {a})', args)
