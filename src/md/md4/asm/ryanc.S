/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR Unlicense OR CC0-1.0+
 * Copyright (c) 2022, Ryan Castellucci, no rights reserved
 * MD4 implemetation, transform only
 */
#define NAME md4_ryanc
#include "../../../common/built.S"
#ifdef STUBBED
STUB(JOIN(NAME,xform))
#elif !(defined(WITH_RYANC_SLOW))
#error "implementation disabled"
#else

/* main working registers */
#define RA eax
#define RB ecx
#define RC r8d
#define RD r9d

/* temporary registers */
#define T1 r10d
#define T2 r11d
#define T3 r12d
#define T4 r13d
#define T5 r14d

/* end of input */
#define EI IF_ELSE(SAME_REG(RD,rdx))(r13,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

/* a = rol((d ^ (b & (c ^ d))) + w + a, s)
 * =
 * a = a + (d ^ (b & (c ^ d)))
 * a = rol(a, s)
 * =
 * t0 = w
 * t1 = c
 * t1 ^= d : (c ^ d)
 * t1 &= b : (b & (c ^ d))
 * t1 ^= d : (d ^ (b & (c ^ d)))
 * t1 += t0 : (d ^ (b & (c ^ d))) + w
 * a += t1 : (d ^ (b & (c ^ d))) + w + a
 * a = rol(a, s)
 */
#define ROUND_F(r, a, b, c, d, kn, s) \
CONCAT(NAME,_f,PAD02(r)): \
	IF(EQUAL(r,0))(mov 0(%rsi), %T2;) \
	mov kn*4(%rsi), %EVEN_ODD(r, T3, T2); \
	mov %c, %T1; \
	xor %d, %T1; \
	and %b, %T1; \
	xor %d, %T1; \
	add %T1, %a; \
	add %EVEN_ODD(r, T2, T3), %a; \
	rol $s, %a;

/* a = rol(((b & c) | (b & d) | (c & d)) + a + w + 0x5a827999, s);
 * t0 = w
 * t1 = d
 * t2 = b
 * t1 &= c : (c & d)
 * t2 &= d : (b & d)
 * t1 |= t2 : ((b & d) | (c & d))
 * t2 = b
 * t2 &= c : (b & c)
 * t1 |= t2 : ((b & c) | ((b & d) | (c & d)))
 * a += 0x5a827999 + t0
 * a += t1
 * a = rol(a, s)
 *
 * we can save c&d as b&c for the next round...
 * latency is long enough here we don't alternate temp registers
 */

#define ROUND_XG(r, a, b, c, d, kn, s) \
CONCAT(NAME,_Xg,PAD02(r)): \
	IF(EQUAL(r,16))(mov %d, %T1;) \
	IF(EQUAL(r,16))(and %c, %T1;) \
	mov %d, %T3; \
	and %b, %T3; \
	or %T1, %T3; \
	mov %b, %T1; \
	and %c, %T1; \
	or %T1, %T3; \
	add %T2, %a; \
	mov kn*4(%rsi), %T2; \
	add $0x5a827999, %a; \
	add %T3, %a; \
	rol $s, %a;
/* TMP1 retains B&C for use as C&D in the next round */

#define ROUND_G(r, a, b, c, d, kn, s) \
CONCAT(NAME,_g,PAD02(r)): \
	mov %b, %T1;                       /* b */ \
	IF(EQUAL(r,16))(mov %c, %T3;)      /* c */ \
	mov %d, %T4;                       /* d */ \
	and %c, %T1;                       /* b&c */ \
	IF(EQUAL(r,16))(and %d, %T3;)      /* c&d */ \
	and %b, %T4;                       /* b&d */ \
	add %T2, %a;                       /* add */ \
	mov kn*4(%rsi), %T2;               /* in */ \
	or %T3, %T4;                       /* (c&d)|(b&d) */ \
	add $0x5a827999, %a;               /* add */ \
	IF(NOT_EQUAL(r,31))(mov %T1, %T3;) /* b&c -> c&d */ \
	or %T1, %T4;                       /* (b&c)|(c&d)|(b&d) */ \
	add %T4, %a;                       /* add */ \
	rol $s, %a;

/* a = rol((b ^ c ^ d)  + a + w + 0x6ed9eba1, s);
                    B    C    D
  ROUND_H(32, RXA, RXB, RXC, RXD,  0,  3)
  ROUND_H(33, RXD, RXA, RXB, RXC,  8,  9)
  ROUND_H(34, RXC, RXD, RXA, RXB,  4, 11)
  ROUND_H(35, RXB, RXC, RXD, RXA, 12, 15)

  at the end of the round we have
  tmp1 = b ^ c ^ d
  the b ^ c component is used as c ^ d for the next round
  so we can get rid of d by doing tmp1 ^= d
  and then on the next round doing tmp1 ^= b
*/

//	IF(EQUAL(r,32))(mov %d, %T1;) \
//	IF(EQUAL(r,32))(xor %c, %T1;) \

#define ROUND_H(r, a, b, c, d, kn, s) \
CONCAT(NAME,_h,PAD02(r)): \
	IF(EQUAL(r,32))(mov %d, %T1;) \
	IF(EQUAL(r,32))(xor %c, %T1;) \
	mov $0x6ed9eba1, %T4; \
	IF(NOT_EQUAL(r,47))(mov kn*4(%rsi), %EVEN_ODD(r, T3, T2);) \
	xor %b, %T1; \
	add %EVEN_ODD(r, T2, T3), %T4; \
	add %T4, %a; \
	add %T1, %a; \
	IF(NOT_EQUAL(r,47))(xor %d, %T1;) \
	rol $s, %a; \
	IF(EQUAL(r,44))(add %a,  0(%rdi);) \
	IF(EQUAL(r,45))(add %a, 12(%rdi);) \
	IF(EQUAL(r,46))(add %a,  8(%rdi);) \
	IF(EQUAL(r,47))(add %a,  4(%rdi);)

/* T1 retains B^C for use as C^D in the next round */

#define R4(R, r, kn0, s0, kn1, s1, kn2, s2, kn3, s3) \
R(r,                RA, RB, RC, RD, kn0, s0) \
R(INC(r),           RD, RA, RB, RC, kn1, s1) \
R(INC(INC(r)),      RC, RD, RA, RB, kn2, s2) \
R(INC(INC(INC(r))), RB, RC, RD, RA, kn3, s3)

/* void md4_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */ 
ENTRY(JOIN(NAME,xform))
save:
	/* save registers */
	IF(CALLEE_SAVED(RA))(push %REG64(RA))
	IF(CALLEE_SAVED(RB))(push %REG64(RB))
	IF(CALLEE_SAVED(RC))(push %REG64(RC))
	IF(CALLEE_SAVED(RD))(push %REG64(RD))
	IF(CALLEE_SAVED(T1))(push %REG64(T1))
	IF(CALLEE_SAVED(T2))(push %REG64(T2))
	IF(CALLEE_SAVED(T3))(push %REG64(T3))
	IF(CALLEE_SAVED(T3))(push %REG64(T4))
	IF(CALLEE_SAVED(T3))(push %REG64(T5))
	IF(CALLEE_SAVED(EI))(push %REG64(EI))

adjust:
	shl $6, %rdx
	add %rsi, %rdx
	IF(DIFF_REG(EI,rdx))(mov %rdx, %EI)

.align 16
load:
	/* load state */
	mov  0(%rdi), %RA /* a */
	mov  4(%rdi), %RB /* b */
	mov  8(%rdi), %RC /* c */
	mov 12(%rdi), %RD /* d */
	mov  0(%rsi), %T2 /* first word of block */

	R4(ROUND_F,  0,    1,  3,    2,  7,    3, 11,    4, 19)
	R4(ROUND_F,  4,    5,  3,    6,  7,    7, 11,    8, 19)
	R4(ROUND_F,  8,    9,  3,   10,  7,   11, 11,   12, 19)
	R4(ROUND_F, 12,   13,  3,   14,  7,   15, 11,    0, 19)

	R4(ROUND_G, 16,    4,  3,    8,  5,   12,  9,    1, 13)
	R4(ROUND_G, 20,    5,  3,    9,  5,   13,  9,    2, 13)
	R4(ROUND_G, 24,    6,  3,   10,  5,   14,  9,    3, 13)
	R4(ROUND_G, 28,    7,  3,   11,  5,   15,  9,    0, 13)

	R4(ROUND_H, 32,    8,  3,    4,  9,   12, 11,    2, 15)
	R4(ROUND_H, 36,   10,  3,    6,  9,   14, 11,    1, 15)
	R4(ROUND_H, 40,    9,  3,    5,  9,   13, 11,    3, 15)
	R4(ROUND_H, 44,   11,  3,    7,  9,   15, 11,    _, 15)
/*
update:
	add %RA,  0(%rdi)
	add %RB,  4(%rdi)
	add %RC,  8(%rdi)
	add %RD, 12(%rdi)
*/

next:
	add $64, %rsi
	cmp %EI, %rsi
	jb  load

ret:
	/* restore registers */
	IF(CALLEE_SAVED(EI))(pop %REG64(EI))
	IF(CALLEE_SAVED(T3))(pop %REG64(T5))
	IF(CALLEE_SAVED(T3))(pop %REG64(T4))
	IF(CALLEE_SAVED(T3))(pop %REG64(T3))
	IF(CALLEE_SAVED(T2))(pop %REG64(T2))
	IF(CALLEE_SAVED(T1))(pop %REG64(T1))
	IF(CALLEE_SAVED(RD))(pop %REG64(RD))
	IF(CALLEE_SAVED(RC))(pop %REG64(RC))
	IF(CALLEE_SAVED(RB))(pop %REG64(RB))
	IF(CALLEE_SAVED(RA))(pop %REG64(RA))
	retq
ENDPROC(JOIN(NAME,xform))
#endif
