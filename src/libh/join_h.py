#!/usr/bin/env python3

import sys

from util import *
from util import header

h = Appender()

h.define('_JOIN(a, ...)', 'a ## _ ## __VA_ARGS__')
h.define('JOIN(...)', 'REDUCE(_JOIN, __VA_ARGS__)')
h.define('CONCAT(...)', 'REDUCE(CAT, __VA_ARGS__)')

h.print()
