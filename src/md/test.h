#define FOO(n, k) x[n] = k;

MAP_WITH_COUNTER(FOO, 5, EMPTY, 0x1, 0x2, 0x3, 0x4)
IF(1)(lol)

IF(0)(mov 0*4(%rsi), %r10d;)
INC(10)
DEC(10)
MOD(7, 5)
// not
NOT(1)
NOT(7)
NOT(0)

IF_ELSE(MOD(10,2))(rol $s COMMA() %a;,    mov %b COMMA() %r11d;)
IF_ELSE(MOD(10,2))(mov %b COMMA() %r11d;, rol $s COMMA() %a;)


#define COMPARE_rdx
#define COMPARE_rcx

IS_PAREN(())
IS_PAREN(xxx)

IS_COMPARABLE(rdx)
IS_COMPARABLE(rcx)
//EQUAL(rdx,rdx)
//EQUAL(rdx,rcx)
//EQUAL(rcx,rdx)
//EQUAL(rcx,rcx)
equal
EQUAL(rcx,rcx)
EQUAL(rcx,rdx)
EQUAL(rdx,rcx)
EQUAL(rdx,rdx)

COMPL(1)
COMPL(0)
