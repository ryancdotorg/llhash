#!/usr/bin/env python3

import sys

from util import *
from util import header

MAX_ARGS = int(sys.argv[1]) if len(sys.argv) > 1 else 9

h = Appender()

helpers, macros = h.sections(2)

helpers.define('_VEXP(...)', '__VA_ARGS__')

def va_reverse_n(n):
    r = LineWrapper()

    if n == 1:
        helpers.define('_VREV1(_1)', '_1')
    else:
        r(f'#define _VREV{n}(_{n}, ')
        for_each(lambda x: r(f'_{x}) ', '_1, ') if x == 1 else r(f'_{x}, '), irange(n-1, 1))
        for_each(lambda x: r(f'_{x}') if x == n else r(f'_{x}, '), irange(2, n))
        helpers(str(r))

def va_select_n(n):
    d = LineWrapper()

    if n == 1:
        helpers('#define _VSEL1(_1, NAME, ...) NAME')
    else:
        d(f'#define _VSEL{n}(_{n}, ')
        for_each(lambda x: d(f'_{x}, '), irange(n-1, 1))

        d('NAME, ', '...) ', 'NAME')
        helpers(str(d))

def va_select():
    for n in irange(1, MAX_ARGS):
        va_select_n(n)
        va_reverse_n(n)

    va_select_n(MAX_ARGS + 1)

    d = LineWrapper(f'#define _VSEL(...) _VSEL{MAX_ARGS}(__VA_ARGS__, ')
    r = LineWrapper(f'#define _VREV(...) _VSEL{MAX_ARGS}(__VA_ARGS__, ')
    c = LineWrapper(f'#define _VCNT(...) _VSEL{MAX_ARGS+1}(__VA_ARGS__, ')

    for n in irange(MAX_ARGS, 1):
        if n != 1:
            d(f'_VSEL{n}, ')
            r(f'_VREV{n}, ')
            c(f'{n}, ')
        else:
            d(f'_VSEL{n})')
            r(f'_VREV{n}', ')(__VA_ARGS__)')
            c('1, ', '0', ')')

    helpers(map(str, (d, r, c)))
    helpers.define('_VA2(a, b, ...)', 'b')
    helpers.define('_VSEP(...)', '_VA2(__VA_ARGS__, _VEXP(,))')
    helpers.define('_VTPX(...)', '~,')
    helpers.define('_VCOMMA(...)', '_VSEP(_VEXP(_VTPX _VA2(,__VA_ARGS__)())) __VA_ARGS__')
    macros('')

va_select()

macros.define('VA_REVERSE(...)', '_VREV(__VA_ARGS__)')
macros.define('VA_COUNT(...)', '_VCNT(_ _VCOMMA(__VA_ARGS__))')
macros.define('VA_SEP(A, ...)', 'A _VCOMMA(__VA_ARGS__)')
# The c preprocessor needs to be forced to do some extra expansion passes over
# this monstrosity of a macro via _VEXP in order to make it work properly.
macros.define('VA_SELECT(F, V, ...)', '''_VEXP( \\
  _VSEL(__VA_ARGS__) \\
  _VEXP(( _VEXP V, _VREV(__VA_ARGS__) )) \\
  (_VEXP F, _VEXP V) \\
)''')
macros('')
macros('''
/* EXAMPLES:
#define _SUM2(a, b) _sum2((a), (b))
#define _SUM3(a, b, c) _sum3((a), (b), (c))
#define SUM(A, ...) VA_SELECT((A), (__VA_ARGS__), _SUM2, _SUM3)
int _sum2(int a, int b) { return a + b; }
int _sum3(int a, int b, int c) { return a + b + c; }

SUM(1, 2, 3)                   // _sum3((1), (2), (3))
SUM(1, 2)                      // _sum2((1), (2))
SUM(1)                         // _sum2((1), ()) - compile error
VA_REVERSE(a, b, c, d, e)      // e, d, c, b, a
VA_COUNT(a, b, c, d, e)        // count 5
VA_COUNT(a)                    // count 1
VA_COUNT()                     // count 0
{VA_SEP()}                     // { }
{VA_SEP(a)}                    // {a }
{VA_SEP(a, b)}                 // {a , b}
{VA_SEP(a, b, c)}              // {a , b, c}
{VA_SEP(a, b, c, d)}           // {a , b, c, d}
//*/
''')

h.print()
