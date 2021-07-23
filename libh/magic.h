#pragma once
#include "arith.h"
/* arcane macro magic, based in part on tricks from
 * http://jhnet.co.uk/articles/cpp_magic and
 * https://github.com/18sg/uSHET/blob/master/lib/cpp_magic.h and
 * https://github.com/pfultz2/Cloak/wiki/C-Preprocessor-tricks,-tips,-and-idioms
 */

#define EMPTY()
#define COMMA() ,
#define SEMICOLON() ;
#define _POUND #
#define POUND() _POUND

// excessive nesting here makes my syntax checker slow
#define EVAL(...)   _EVAL3(_EVAL3(_EVAL3(__VA_ARGS__)))
#define _EVAL3(...) _EVAL2(_EVAL2(_EVAL2(__VA_ARGS__)))
#define _EVAL2(...) _EVAL1(_EVAL1(_EVAL1(__VA_ARGS__)))
#define _EVAL1(...) _EVAL0(_EVAL0(_EVAL0(__VA_ARGS__)))
#define _EVAL0(...) __VA_ARGS__

#define CAT(a, ...) a ## __VA_ARGS__
#define CAT3(a, b, ...) a ## b ## __VA_ARGS__
#define CAT4(a, b, c, ...) a ## b ## c ## __VA_ARGS__

#define DEFER1(id) id EMPTY()
#define DEFER2(id) id EMPTY EMPTY()()

#define CONSUME(...)
#define EXPAND(...) __VA_ARGS__
#define PASS(...) __VA_ARGS__
#define ARRAY(...) {__VA_ARGS__}
#define PARENS(...) (__VA_ARGS__)

//#define OBSTRUCT(...) __VA_ARGS__ DEFER1(EMPTY)()

#define __(X) DEFER1(CAT3)(__,X,__)
#define h(...) POUND()__VA_ARGS__
#define APPLY(fn, ...) fn(__VA_ARGS__)
#define FIRST(a, ...) a
#define SECOND(a, b, ...) b
#define THIRD(a, b, c, ...) c
#define REST(a, ...) __VA_ARGS__

#define IS_PROBE(...) SECOND(__VA_ARGS__, 0)
#define PROBE() ~, 1,

#define IS_PAREN(x) IS_PROBE(_IS_PAREN_PROBE x)
#define _IS_PAREN_PROBE(...) PROBE()

#define NOT(x) IS_PROBE(CAT(_NOT_, x))
#define _NOT_0 PROBE()

#define COMPL(x) CAT(_COMPL_, x)
#define _COMPL_0 1
#define _COMPL_1 0

#define BOOL(x) COMPL(NOT(x))

#define BITAND(x) CAT(_BITAND_, x)
#define _BITAND_0(x) 0
#define _BITAND_1(x) x

#define OR(a,b) CAT3(_OR_, a, b)
#define _OR_00 0
#define _OR_01 1
#define _OR_10 1
#define _OR_11 1

#define AND(a,b) CAT3(_AND_, a, b)
#define _AND_00 0
#define _AND_01 0
#define _AND_10 0
#define _AND_11 1

#define XOR(a,b) CAT3(_XOR_, a, b)
#define _XOR_00 1
#define _XOR_01 0
#define _XOR_10 0
#define _XOR_11 1

#define NAND(a,b) COMPL(AND(a,b))
#define NOR(a,b) COMPL(OR(a,b))

// need to define e.g. COMPARE_foo(x) x
#define COMPARABLE(x) IS_PAREN(CAT(_COMPARE_,x)(()))
#define _COMPARE(a, b) COMPL(IS_PAREN(_COMPARE_##a(_COMPARE_##b)(())))
#define EQUAL(x, y) BITAND(BITAND(COMPARABLE(x))(COMPARABLE(y)))(_COMPARE(x,y))
#define NOT_EQUAL(x, y) COMPL(EQUAL(x, y))

// need to define e.g. FOO() value, ()
#define GETTABLE(x) IS_PAREN(APPLY(SECOND, x(), ~))
#define GET(x, ...) IF_ELSE(GETTABLE(x))(APPLY(FIRST, x()), __VA_ARGS__)

#define IF_EQUAL(a, b) IF(EQUAL(a, b))
#define IF_NOTEQ(a, b) IF(COMPL(EQUAL(a, b)))

#define IF(c) _IF(BOOL(c))
#define _IF(c) CAT(_IF_,c)
#define _IF_0(...)
#define _IF_1(...) __VA_ARGS__

#define IF_ELSE(c) _IF_ELSE(BOOL(c))
#define _IF_ELSE(c) CAT(_IF_ELSE_,c)
#define _IF_ELSE_0(t,f) f
#define _IF_ELSE_1(t,f) t

#define HAS_ARGS(...) BOOL(FIRST(_END_OF_ARGUMENTS_ __VA_ARGS__)(0))
#define _END_OF_ARGUMENTS_(...) BOOL(FIRST(__VA_ARGS__))

#define REMOVE_TRAILING_COMMAS(...) MAP(PASS, COMMA, __VA_ARGS__)

#define MAP(...) IF(HAS_ARGS(__VA_ARGS__))(EVAL( \
  _MAP_INNER(__VA_ARGS__)) \
)
#define _MAP_DEFER() _MAP_INNER
#define _MAP_INNER(op,sep,val, ...) \
  op(val) \
  IF(HAS_ARGS(__VA_ARGS__))( \
    sep() DEFER2(_MAP_DEFER)()(op, sep, ##__VA_ARGS__) \
  )

#define MAP_WITH_COUNTER(op,start,sep,...) IF(HAS_ARGS(__VA_ARGS__))(EVAL( \
  _MAP_WITH_COUNTER_INNER(op,sep,start, ##__VA_ARGS__)) \
)
#define _MAP_WITH_COUNTER_DEFER() _MAP_WITH_COUNTER_INNER
#define _MAP_WITH_COUNTER_INNER(op,sep,n,val, ...) \
  op(n,val) \
  IF(HAS_ARGS(__VA_ARGS__))( \
    sep() DEFER2(_MAP_WITH_COUNTER_DEFER)()(op, sep, INC(n), ##__VA_ARGS__) \
  )

#define REPEAT(...) IF(HAS_ARGS(__VA_ARGS__))(EVAL( \
  _REPEAT_INNER(__VA_ARGS__)) \
)
#define _REPEAT_DEFER() _REPEAT_INNER
#define _REPEAT_INNER(n, sep, ...) IF(n) ( \
  DEFER2(_REPEAT_DEFER)()(DEC(n), sep, __VA_ARGS__) \
  IF(DEC(n))(sep()) __VA_ARGS__ \
)

#define REPEAT_WITH_COUNTER(...) IF(HAS_ARGS(__VA_ARGS__))(EVAL( \
  _REPEAT_WITH_COUNTER_INNER(__VA_ARGS__)) \
)
#define _REPEAT_WITH_COUNTER_DEFER() _REPEAT_WITH_COUNTER_INNER
#define _REPEAT_WITH_COUNTER_INNER(n, sep, op, ...) IF(n) ( \
  DEFER2(_REPEAT_WITH_COUNTER_DEFER)()(DEC(n), sep, op, __VA_ARGS__) \
  IF(DEC(n))(sep()) \
  DEFER2(op)(DEC(n), __VA_ARGS__) \
)

#define REDUCE(op, ...) IF(HAS_ARGS(__VA_ARGS__))( \
  IF_ELSE(HAS_ARGS(REST(__VA_ARGS__)))( \
    EVAL(_REDUCE_INNER(op, __VA_ARGS__)), \
    FIRST(__VA_ARGS__) \
  ) \
)
#define _REDUCE_DEFER() _REDUCE_INNER
#define _REDUCE_INNER(op, a, b, ...) IF_ELSE(HAS_ARGS(__VA_ARGS__))( \
  DEFER2(_REDUCE_DEFER)()(op, op(a, b),  __VA_ARGS__), \
  op(a, b) \
)

/*
#define WHILE(...) IF(HAS_ARGS(__VA_ARGS__))(EVAL(WHILE_INNER(__VA_ARGS)))
#define WHILE_INNER(c, op, ...) IF_ELSE(c(__VA_ARGS__))( \
  DEFER2(_WHILE_INNER) () (c, op, op(__VA_ARGS__)), \
  __VA_ARGS__ \
)
#define _WHILE_INNER() WHILE_INNER
//*/
