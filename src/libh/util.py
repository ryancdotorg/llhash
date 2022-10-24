#!/usr/bin/env python3

import io
import re
import sys

from functools import reduce
from itertools import chain, product
from collections.abc import Iterable, Iterator
from collections import OrderedDict

__all__ = ['LineWrapper', 'Appender', 'for_each', 'irange', 'placeholders']

class LineWrapper:
    def __init__(self, line='', length=78, continuation='\\'):
        self._f = io.StringIO('')
        self._line = line
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
        self.__str__ = lambda self: s
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
        self._name = None
        self._parent = None

    def __getattr__(self, name):
        return self.section(name)

    def __call__(self, s):
        self.append(s)

    def __str__(self):
        return self._f.getvalue() + ''.join(map(str, self._d.values()))

    def __repr__(self):
        return f'<{type(self).__name__} {self.name()}>'

    def _writeln(self, s):
        self._f.write(s.strip('\n')+'\n')

    # basic stuff
    def name(self):
        if self._parent is None: return f'0x{id(self):x}'
        else: return f'{self._parent.name()}::{self._name}'

    def section(self, name=None):
        if name is None:
            k = (id(self), self._s)
            name = self._s
            self._s += 1
        else:
            k = name

        sub = self._d.setdefault(k, Appender())
        sub._name = name
        sub._parent = self
        return sub

    def sections(self, *args):
        if len(args) == 1 and type(args[0]) == int:
            args = (None,)*args[0]

        return tuple(map(lambda x: self.section(x), args))

    def append(self, s):
        if isinstance(s, (list, tuple, Iterator)):
            for line in s: self._writeln(line)
        else: self._writeln(s)

    # helpers
    def define(self, k, v):
        self._f.write(f'#define {k} {v}\n')

    def indirect(self, k, v):
        call, decl, body = indirect(k, v)
        self.define(k, call)
        self.define(decl, body)

    def gettable(self, k, v):
        self.define(f'{k}()', f'{v}, ()')

    def comparable(self, k):
        self.define(f'_COMPARE_{k}(x)', 'x')

    # output
    def print(self):
        print(str(self).strip('\n'))

# for magic imports
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

def indirect(decl, body):
    m = re.match(r'(\w+)\s*[(]([^)]*)[)]', decl)
    if m:
        name = m.group(1)
        args = re.split(r',\s*', m.group(2).strip(' \t\r\n'))
        call = f'_{name}({", ".join(args)})'
        if args[-1] != '...':
            body = re.sub(r'\b'+args[-1]+r'\b', '__VA_ARGS__', body)
            args[-1] = '...'
        decl = f'_{name}({", ".join(args)})'
        return (call, decl, body)

def for_each(func, *iterables):
    for args in zip(*iterables): func(*args)

def irange(a, b=None, i=1):
    if b is None: b, a = a, 0
    if a > b: i = -i
    return range(a, b + i, i)

def placeholders(pfx, a, b=None, i=1, *, sep='', end=''):
    return map(lambda x: f'{pfx}{x}' + (end if x == b else sep), irange(a, b, i))

def lutmacro(name, fn, *args):
    if len(args) > 26:
        raise TypeError(f'Too many macro arguments, max 26 ({len(args)} given)')
    p = list(map(chr, range(65, 65+len(args))))
    main = (f'{name}({", ".join(p)})', f'_{name}_##{"##_##".join(p)}')
    helper = lambda a: (f'_{name}_{"_".join(map(str, a))}', fn(*a))
    return (main, map(helper, product(*args)))

def REDUCE(fn, *args):
    if len(args) == 1 and isinstance(args[0], Iterable): args = iter(args[0])
    return reduce(lambda a, b: f'{fn}({a},{b})', args)

def ELIF(*args):
    if len(args) == 1 and isinstance(args[0], Iterable): args = iter(args[0])
    args = list(reversed(list(args)))
    args[0] = 'IF({})({})'.format(*args[0])
    return reduce(lambda a,b: f'IF_ELSE({b[0]})({b[1]}, {a})', args)

OR = lambda *a: REDUCE('OR', *a)
AND = lambda *a: REDUCE('AND', *a)
