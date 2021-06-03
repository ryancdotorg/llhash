#define CAT(a, ...) a ## __VA_ARGS__

#define BITAND(x) CAT(BITAND_, x)
#define BITAND_0(y) 0
#define BITAND_1(y) y

#if 1
#define CHECK_N(x, n, ...) n
#define CHECK(...) CHECK_N(__VA_ARGS__, 0,)
#define PROBE(x) x, 1,

#define IS_PAREN(x) CHECK(IS_PAREN_PROBE x)
#define IS_PAREN_PROBE(...) PROBE(~)
#else
#define SECOND(a, b, ...) b
#define IS_PROBE(...) SECOND(__VA_ARGS__, 0,)
#define PROBE() ~, 1,
#define IS_PAREN(x) IS_PROBE(_IS_PAREN_PROBE x)
#define _IS_PAREN_PROBE(...) PROBE()
#endif

#define COMPARE(x, y) IS_PAREN \
( \
COMPARE_ ## x ( COMPARE_ ## y) (())  \
)


#define COMPARABLE(x) IS_PAREN(CAT(COMPARE_,x)(()))

#define BOTH_COMPARABLE(x, y) BITAND(COMPARABLE(x))(COMPARABLE(y))

#define EQUAL(x, y) BITAND(BOTH_COMPARABLE(x,y))(COMPARE(x,y))
#define EQUAL(x,y) BITAND(BITAND(COMPARABLE(x))(COMPARABLE(y)))(COMPARE(x,y))

#define COMPARE_rdx(x) x
#define COMPARE_rcx(x) x

is paren
IS_PAREN(xxx)
IS_PAREN(())

comparable
COMPARABLE(rcx)
COMPARABLE(rdx)

equal
EQUAL(rcx,rcx)
EQUAL(rcx,rdx)
EQUAL(rdx,rcx)
EQUAL(rdx,rdx)

COMPARE(rcx,rcx)
COMPARE(rcx,rdx)
COMPARE(rdx,rcx)
COMPARE(rdx,rdx)
