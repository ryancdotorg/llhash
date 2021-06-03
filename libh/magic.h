#pragma once
#include "arith.h"

/* magic shit */
// https://github.com/18sg/uSHET/blob/master/lib/cpp_magic.h

#define EVAL(...) EVAL1024(__VA_ARGS__)
#define EVAL1024(...) EVAL512(EVAL512(__VA_ARGS__))
#define EVAL512(...) EVAL256(EVAL256(__VA_ARGS__))
#define EVAL256(...) EVAL128(EVAL128(__VA_ARGS__))
#define EVAL128(...) EVAL64(EVAL64(__VA_ARGS__))
#define EVAL64(...) EVAL32(EVAL32(__VA_ARGS__))
#define EVAL32(...) EVAL16(EVAL16(__VA_ARGS__))
#define EVAL16(...) EVAL8(EVAL8(__VA_ARGS__))
#define EVAL8(...) EVAL4(EVAL4(__VA_ARGS__))
#define EVAL4(...) EVAL2(EVAL2(__VA_ARGS__))
#define EVAL2(...) EVAL1(EVAL1(__VA_ARGS__))
#define EVAL1(...) __VA_ARGS__

#define PASS(...) __VA_ARGS__
#define EMPTY()
#define COMMA() ,
#define SEMICOLON() ;

#define DEFER1(id) id EMPTY()
#define DEFER2(id) id EMPTY EMPTY()()

#define CAT(a, ...) a ## __VA_ARGS__
#define CAT3(a, b, ...) a ## b ## __VA_ARGS__

#define FIRST(a, ...) a
#define SECOND(a, b, ...) b

#define IS_PROBE(...) SECOND(__VA_ARGS__, 0)
#define PROBE() ~, 1,

#define IS_PAREN(x) IS_PROBE(_IS_PAREN_PROBE x)
#define _IS_PAREN_PROBE(...) PROBE()

#define NOT(x) IS_PROBE(CAT(_NOT_, x))
#define _NOT_0 PROBE()

#define BOOL(x) NOT(NOT(x))

#define BITAND(x) CAT(_BITAND_, x)
#define _BITAND_0(x) 0
#define _BITAND_1(x) x

#define COMPL(x) CAT(_COMPL_, x)
#define _COMPL_0 1
#define _COMPL_1 0

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

// need to define e.g. COMPARE_foo
#define COMPARABLE(x) IS_PAREN(CAT(COMPARE_,x)(()))
#define _COMPARE(a, b) COMPL(IS_PAREN(COMPARE_##a(COMPARE_##b)(())))
#define EQUAL(x, y) BITAND(BITAND(COMPARABLE(x))(COMPARABLE(y)))(_COMPARE(x,y))
#define NOT_EQUAL(x, y) COMPL(EQUAL(x, y))

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

#define MAP(...) \
   IF(HAS_ARGS(__VA_ARGS__))(EVAL(MAP_INNER(__VA_ARGS__)))
#define MAP_INNER(op,sep,val, ...) \
  op(val) \
  IF(HAS_ARGS(__VA_ARGS__))( \
    sep() DEFER2(_MAP_INNER)()(op, sep, ##__VA_ARGS__) \
  )
#define _MAP_INNER() MAP_INNER

#define MAP_WITH_COUNTER(op,start,sep,...) \
  IF(HAS_ARGS(__VA_ARGS__))(EVAL(MAP_WITH_COUNTER_INNER(op,sep,start, ##__VA_ARGS__)))
#define MAP_WITH_COUNTER_INNER(op,sep,n,val, ...) \
  op(n,val) \
  IF(HAS_ARGS(__VA_ARGS__))( \
    sep() DEFER2(_MAP_WITH_COUNTER_INNER)()(op, sep, INC(n), ##__VA_ARGS__) \
  )
#define _MAP_WITH_COUNTER_INNER() MAP_WITH_COUNTER_INNER
