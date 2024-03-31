/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR CC0-1.0+
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
#define EI IF_ELSE(SAME_REG(RD,rdx))(r15,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

#define F(r, a, b, c, d, w) \
CONCAT(NAME,_f,PAD02(r)): \
	mov %d, %T1;                    /* t1 = d */ \
	add w*4(%rsi), %a;              /* a += w : w + a */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %b, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %d, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;                    /* a += t1 : (d ^ (b & (c ^ d))) + w + a */ \
	rol $ALTER4(r,3,7,11,19), %a;   /* a = rol(a, s) */

#define G(r, a, b, c, d, w) \
CONCAT(NAME,_g,PAD02(r)): \
	mov %c, %T1;                    /* t1 = c */ \
	mov %c, %T2;                    /* t2 = c */ \
	add w*4(%rsi), %a;              /* a += w : w + a */ \
	or  %d, %T1;                    /* t1 |= d : (d | c) */ \
	and %d, %T2;                    /* t2 &= d : (d & c) */ \
	and %b, %T1;                    /* t1 &= b : (b & (d | c)) */ \
	add $0x5a827999, %a;            /* a += k : k + w + a */ \
	or  %T2, %T1;                   /* t1 |= t2 : ((d & c) | (b & (d | c))) */ \
	add %T1, %a;                    /* a += t1 : ((d & c) | (b & (d | c))) + k + w + a */ \
	rol $ALTER4(r,3,5,9,13), %a;    /* a = rol(a, s) */

#define H(r, a, b, c, d, w) \
CONCAT(NAME,_h,PAD02(r)): \
	add w*4(%rsi), %a;              /* a += w : w + a*/ \
	mov %d, %T1;                    /* t1 = d */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	add $0x6ed9eba1, %a;            /* a += k : k + w + a */ \
	xor %b, %T1;                    /* t1 ^= b : (b ^ (c ^ d)) */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + k + w + x */ \
	rol $ALTER4(r,3,9,11,15), %a;   /* a = rol(a, s) */

#define RX(R, r, w) \
EXPAND(DEFER1(R)(r, ROTATE4L(r, RA, RB, RC, RD), w))

#define R8(R, r, w0, w1, w2, w3, w4, w5, w6, w7) \
RX(R, ADD0(r), w0) RX(R, ADD1(r), w1) \
RX(R, ADD2(r), w2) RX(R, ADD3(r), w3) \
RX(R, ADD4(r), w4) RX(R, ADD5(r), w5) \
RX(R, ADD6(r), w6) RX(R, ADD7(r), w7)

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
	CALLEE_SAVE(REG64(EI))

adjust:
	shl $6, %rdx   /* number of bytes to process */
	add %rsi, %rdx /* end address for data to process */
	IF(DIFF_REG(EI,rdx))(mov %rdx, %EI)

.align 16
load_state:
	/* load state */
	mov  0(%rdi), %RA /* a */
	mov  4(%rdi), %RB /* b */
	mov  8(%rdi), %RC /* c */
	mov 12(%rdi), %RD /* d */

	R8(F,  0,  0,  1,  2,  3,  4,  5,  6,  7)
	R8(F,  8,  8,  9, 10, 11, 12, 13, 14, 15)
	R8(G, 16,  0,  4,  8, 12,  1,  5,  9, 13)
	R8(G, 24,  2,  6, 10, 14,  3,  7, 11, 15)
	R8(H, 32,  0,  8,  4, 12,  2, 10,  6, 14)
	R8(H, 40,  1,  9,  5, 13,  3, 11,  7, 15)

update:
	add %RA,  0(%rdi)
	add %RB,  4(%rdi)
	add %RC,  8(%rdi)
	add %RD, 12(%rdi)

next:
	add $64, %rsi
	cmp %EI, %rsi
	jb  load_state

ret:
	/* restore registers */
	CALLEE_RESTORE(REG64(EI))
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
