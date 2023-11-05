/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR Unlicense OR CC0-1.0+
 * Copyright (c) 2022, Ryan Castellucci, no rights reserved
 * MD4 implemetation, transform only
 */
#define NAME md4_ryanc
#include "../../../common/built.S"
#ifdef STUBBED
STUB(JOIN(NAME,xform))
#else

/* main working registers */
#define RA eax
#define RB ecx
#define RC r8d
#define RD r9d

/* temporary registers */
#define T1 r10d
#define T2 r11d
#define T3
#define T4
#define T5

/* end of input */
#define END IF_ELSE(SAME_REG(RD,rdx))(r15,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

#define ROUND_F(r, a, b, c, d, kn, s) \
CONCAT(NAME,_f,PAD02(r)): \
	mov %d, %T1;                    /* t1 = d */ \
	add r*4(%rsi), %a;              /* a += w : w + a */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %b, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %d, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;                    /* a += t1 : (d ^ (b & (c ^ d))) + w + a */ \
	rol $s, %a;                     /* a = rol(a, s) */

#define ROUND_G(r, a, b, c, d, kn, s) \
CONCAT(NAME,_g,PAD02(r)): \
	mov %c, %T1;                    /* t1 = c */ \
	mov %c, %T2;                    /* t2 = c */ \
	add kn*4(%rsi), %a;             /* a += w : w + a */ \
	or  %d, %T1;                    /* t1 |= d : (d | c) */ \
	and %d, %T2;                    /* t2 &= d : (d & c) */ \
	and %b, %T1;                    /* t1 &= b : (b & (d | c)) */ \
	add $0x5a827999, %a;            /* a += k : k + w + a */ \
	or  %T2, %T1;                   /* t1 |= t2 : ((d & c) | (b & (d | c))) */ \
	add %T1, %a;                    /* a += t1 : ((d & c) | (b & (d | c))) + k + w + a */ \
	rol $s, %a;                     /* a = rol(a, s) */

#define ROUND_H(r, a, b, c, d, kn, s) \
CONCAT(NAME,_h,PAD02(r)): \
	add kn*4(%rsi), %a;             /* a += w : w + a*/ \
	mov %d, %T1;                    /* t1 = d */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	add $0x6ed9eba1, %a;            /* a += k : k + w + a */ \
	xor %b, %T1;                    /* t1 ^= b : (b ^ (c ^ d)) */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + k + w + x */ \
	rol $s, %a;                     /* a = rol(a, s) */

#define R4(R, r, kn0, s0, kn1, s1, kn2, s2, kn3, s3) \
R(ADD0(r), RA, RB, RC, RD, kn0, s0) \
R(ADD1(r), RD, RA, RB, RC, kn1, s1) \
R(ADD2(r), RC, RD, RA, RB, kn2, s2) \
R(ADD3(r), RB, RC, RD, RA, kn3, s3)

/* void md4_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(JOIN(NAME,xform))
save:
	/* save registers */
	CALLEE_SAVE(REG64(RA))
	CALLEE_SAVE(REG64(RB))
	CALLEE_SAVE(REG64(RC))
	CALLEE_SAVE(REG64(RD))
	CALLEE_SAVE(REG64(T1))
	CALLEE_SAVE(REG64(T2))
	CALLEE_SAVE(REG64(T3))
	CALLEE_SAVE(REG64(T4))
	CALLEE_SAVE(REG64(T5))
	CALLEE_SAVE(REG64(END))

adjust:
	shl $6, %rdx   /* number of bytes to process */
	add %rsi, %rdx /* end address for data to process */
	IF(DIFF_REG(END,rdx))(mov %rdx, %END)

.align 16
load_state:
	/* load state */
	mov  0(%rdi), %RA /* a */
	mov  4(%rdi), %RB /* b */
	mov  8(%rdi), %RC /* c */
	mov 12(%rdi), %RD /* d */

//	             r,  kn0, s0, kn1,  s1, kn2,  s2,  kn3, s3
	R4(ROUND_F,  0,    1,  3,    2,  7,    3, 11,    4, 19)
	R4(ROUND_F,  4,    5,  3,    6,  7,    7, 11,    8, 19)
	R4(ROUND_F,  8,    9,  3,   10,  7,   11, 11,   12, 19)
	R4(ROUND_F, 12,   13,  3,   14,  7,   15, 11,    0, 19)
//	             r,  kn0, s0, kn1,  s1, kn2,  s2,  kn3, s3
	R4(ROUND_G, 16,    0,  3,    4,  5,    8,  9,   12, 13)
	R4(ROUND_G, 20,    1,  3,    5,  5,    9,  9,   13, 13)
	R4(ROUND_G, 24,    2,  3,    6,  5,   10,  9,   14, 13)
	R4(ROUND_G, 28,    3,  3,    7,  5,   11,  9,   15, 13)
//	             r,  kn0, s0,  kn1, s1,  kn2, s2,  kn3, s3
	R4(ROUND_H, 32,    0,  3,    8,  9,    4, 11,   12, 15)
	R4(ROUND_H, 36,    2,  3,   10,  9,    6, 11,   14, 15)
	R4(ROUND_H, 40,    1,  3,    9,  9,    5, 11,   13, 15)
	R4(ROUND_H, 44,    3,  3,   11,  9,    7, 11,   15, 15)

update:
	add %RA,  0(%rdi)
	add %RB,  4(%rdi)
	add %RC,  8(%rdi)
	add %RD, 12(%rdi)

next:
	add $64, %rsi
	cmp %END, %rsi
	jb  load_state

ret:
	/* restore registers */
	CALLEE_RESTORE(REG64(END))
	CALLEE_RESTORE(REG64(T5))
	CALLEE_RESTORE(REG64(T4))
	CALLEE_RESTORE(REG64(T3))
	CALLEE_RESTORE(REG64(T2))
	CALLEE_RESTORE(REG64(T1))
	CALLEE_RESTORE(REG64(RD))
	CALLEE_RESTORE(REG64(RC))
	CALLEE_RESTORE(REG64(RB))
	CALLEE_RESTORE(REG64(RA))
	retq
ENDPROC(JOIN(NAME,xform))
#endif
