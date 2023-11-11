/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR Unlicense OR CC0-1.0+
 * Copyright (c) 2022, Ryan Castellucci, no rights reserved
 * RIPEMD-160 implemetation, transform only
 */
#define NAME ripemd160_ryanc
#include "../../../common/built.S"
#ifdef STUBBED
STUB(JOIN(NAME,xform))
#else

/* main working registers */
#define RA ebp
#define RB eax
#define RC ebx
#define RD ecx
#define RE r13d

#define LA r8d
#define LB r9d
#define LC r10d
#define LD r11d
#define LE r12d

#define XI xmm0

#define XA xmm1
#define XB xmm2
#define XC xmm3
#define XD xmm4
#define XE xmm5

#define XT xmm6
#define XU xmm7
#define XN xmm8

#define XS xmm9

/* temporary registers */
#define T1 r14d
#define T2 r15d
#define T3
#define T4
#define T5

/* end of input */
#define EI IF_ELSE(SAME_REG(RD,rdx))(r15,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

# F(b, c, d) ((b) ^ (c) ^ (d))
# G(b, c, d) (((c) & (b)) | ((d) & ~(b)))
# G2(b, c, d) (((c) & (b)) + ((d) & ~(b)))
# G3(b, c, d) ((((c) ^ (d)) & (b)) ^ (d))
# H(b, c, d) (((b) | ~(c)) ^ (d))
# I(b, c, d) G(d, b, c)
# J(b, c, d) H(c, d, b)

#define F(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %d, %T1;                    /* t1 = d */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	xor %b, %T1;                    /* t1 ^= b : (b ^ (c ^ d)) */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#if 0
#define G(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %c, %T1; \
	and %b, %T1; \
	add %T1, %a; \
	andn %d, %b, %T1; \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#else
#define G(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %d, %T1;                    /* t1 = d */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %b, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %d, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#endif

/*
HH_INIT(la, lb, lc, ld, le, ra, rb, rc, rd, re) \
	movdqa HH_ADD(%rip), %XI; \
	pinsrd $2, %la, %XA; pinsrd $0, %ra, %XA; \
	pinsrd $2, %lb, %XB; pinsrd $0, %rb, %XB; \
	pinsrd $2, %lc, %XC; pinsrd $0, %rc, %XC; \
	pinsrd $2, %ld, %XD; pinsrd $0, %rd, %XD; \
	pinsrd $2, %le, %XE; pinsrd $0, %re, %XE; \
	pcmpeqb %XN, %XN; \

HH_BODY(r, s, xa, xb, xc, xd, xe, lw, rw) \
	movdqa  HH_SHR+i*8(%rip), %XS; \
	pinsrd  $2, $lw*4(%rsi), %XT; pinsrd  $0, $rw*4(%rsi), %XT; \
	paddd   %XI, %XT; \
	paddd   %XT, %xa; \
	pxor    %xc, %XN, %XT; \
	por     %xb, %XT; \
	pxor    %xd, %XT; \
	paddd   %XT, %xa; \
	pshufd  $0xa0, %xa, %xa; \
	vpsrlvq %XS, %xa, %xa; \
	paddd   %xe, %xa
	pshufd  $0xa0, %xc, %xc; \
	psrlq   $22, %xc; \

HH_POST(la, lb, lc, ld, le, ra, rb, rc, rd, re) \
	pextrd  $2, %XA, %la; pextrd  $0, %XA, %ra; \
	pextrd  $2, %XB, %la; pextrd  $0, %XB, %ra; \
	pextrd  $2, %XC, %la; pextrd  $0, %XC, %ra; \
	pextrd  $2, %XD, %la; pextrd  $0, %XD, %ra; \
	pextrd  $2, %XE, %la; pextrd  $0, %XE, %ra; \

# mergeable - rotation constants for round h
.section .rodata.cst16.GI_ADD, "aM", @progbits, 16
.align 16
GI_ADD
.long 0x00000000,0x5a827999,0x00000000,0x5c4dd124

.section .rodata.cst512.GI_SHR, "aM", @progbits, 512
.align 32
GI_SHR:
.quad 0x0000000000000019,0x0000000000000017
.quad 0x000000000000001a,0x0000000000000013
.quad 0x0000000000000018,0x0000000000000011
.quad 0x0000000000000013,0x0000000000000019
.quad 0x0000000000000015,0x0000000000000014
.quad 0x0000000000000017,0x0000000000000018
.quad 0x0000000000000019,0x0000000000000017
.quad 0x0000000000000011,0x0000000000000015
.quad 0x0000000000000019,0x0000000000000019
.quad 0x0000000000000014,0x0000000000000019
.quad 0x0000000000000011,0x0000000000000014
.quad 0x0000000000000017,0x0000000000000019
.quad 0x0000000000000015,0x000000000000001a
.quad 0x0000000000000019,0x0000000000000011
.quad 0x0000000000000013,0x0000000000000013
.quad 0x0000000000000014,0x0000000000000015

.section .rodata.cst16.HH_ADD, "aM", @progbits, 16
.align 16
HH_ADD
.long 0x00000000,0x6ed9eba1,0x00000000,0x6d703ef3

.section .rodata.cst512.HH_SHR, "aM", @progbits, 512
.align 32
HH_SHR:
	.quad 0x0000000000000015,0x0000000000000011
	.quad 0x0000000000000013,0x000000000000001b
	.quad 0x000000000000001a,0x000000000000001f
	.quad 0x0000000000000019,0x000000000000001d
	.quad 0x0000000000000012,0x0000000000000019
	.quad 0x0000000000000017,0x0000000000000012
	.quad 0x0000000000000013,0x000000000000001a
	.quad 0x0000000000000011,0x0000000000000017
	.quad 0x0000000000000012,0x0000000000000015
	.quad 0x0000000000000018,0x0000000000000018
	.quad 0x0000000000000013,0x0000000000000014
	.quad 0x000000000000001a,0x000000000000001e
	.quad 0x000000000000001b,0x0000000000000016
	.quad 0x0000000000000014,0x0000000000000020
	.quad 0x0000000000000019,0x000000000000001c
	.quad 0x000000000000001b,0x0000000000000013

.section .rodata.cst16.IG_ADD, "aM", @progbits, 16
.align 16
IG_ADD
.long 0x00000000,0x8f1bbcdc,0x00000000,0x7a6d76e9

.section .rodata.cst512.IG_SHR, "aM", @progbits, 512
.align 32
IG_SHR:
.quad 0x0000000000000015,0x0000000000000011
.quad 0x0000000000000014,0x000000000000001b
.quad 0x0000000000000012,0x0000000000000018
.quad 0x0000000000000011,0x0000000000000015
.quad 0x0000000000000012,0x0000000000000012
.quad 0x0000000000000011,0x0000000000000012
.quad 0x0000000000000017,0x000000000000001a
.quad 0x0000000000000018,0x0000000000000012
.quad 0x0000000000000017,0x000000000000001a
.quad 0x0000000000000012,0x0000000000000017
.quad 0x000000000000001b,0x0000000000000014
.quad 0x000000000000001a,0x0000000000000017
.quad 0x0000000000000018,0x0000000000000014
.quad 0x000000000000001a,0x000000000000001b
.quad 0x000000000000001b,0x0000000000000011
.quad 0x0000000000000014,0x0000000000000018

*/

#define H(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %c, %T1;                    /* t1 = c */ \
	not %T1;                        /* t1 ~= : ~c */ \
	or  %b, %T1;                    /* t1 |= b : b | ~c */ \
	xor %d, %T1;                    /* t1 ^= d : (b | ~c) ^ d */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#if 1
#define I(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %d, %T1;                    /* t1 = d */ \
	and %b, %T1;                    /* t1 &= b : d & b */ \
	add %T1, %a;                    /* a += t1 */ \
	andn %c, %d, %T2;               /* t1 = c & ~b */ \
	add %T2, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#else
#define I(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %c, %T1;                    /* t1 = d */ \
	xor %b, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %d, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %c, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;                    /* a += t1 : (b ^ (c ^ d)) + w + a */ \

#endif



#define J(r, a, b, c, d, e, s, k) \
	H(r, a, c, d, b, e, s, k)

#define RND(FN, r, LR, a, b, c, d, e, w, s, k) \
CONCAT(NAME,_,PAD02(r),LR): \
	add w*4(%rsi), %a;              /* a += w : w + a*/ \
	FN(r, a, b, c, d, e, s, k) \
	rol $s, %a;                     /* a = rol(a, s) */ \
	add %e, %a;                     /* a += e */ \
	rol $10, %c;                    /* c = rol(c, 10) */

#define R(r, FNL, wl, sl, kl, FNR, wr, sr, kr) \
EXPAND(DEFER1(RND)(FNL, r, L, ROTATE5L(r, LA, LB, LC, LD, LE), wl, sl, kl)) \
EXPAND(DEFER1(RND)(FNR, r, R, ROTATE5L(r, RA, RB, RC, RD, RE), wr, sr, kr))

#define RMD1(r, wl, sl, wr, sr) R(r, F, wl, sl,          0, J, wr, sr, 0x50A28BE6)
#define RMD2(r, wl, sl, wr, sr) R(r, G, wl, sl, 0x5A827999, I, wr, sr, 0x5C4DD124)
#define RMD3(r, wl, sl, wr, sr) R(r, H, wl, sl, 0x6ED9EBA1, H, wr, sr, 0x6D703EF3)
#define RMD4(r, wl, sl, wr, sr) R(r, I, wl, sl, 0x8F1BBCDC, G, wr, sr, 0x7A6D76E9)
#define RMD5(r, wl, sl, wr, sr) R(r, J, wl, sl, 0xA953FD4E, F, wr, sr,          0)

/* void ripemd160_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(JOIN(NAME,xform))
save:
	/* save registers */
	CALLEE_SAVE(REG64(LA))
	CALLEE_SAVE(REG64(LB))
	CALLEE_SAVE(REG64(LC))
	CALLEE_SAVE(REG64(LD))
	CALLEE_SAVE(REG64(LE))

	CALLEE_SAVE(REG64(RA))
	CALLEE_SAVE(REG64(RB))
	CALLEE_SAVE(REG64(RC))
	CALLEE_SAVE(REG64(RD))
	CALLEE_SAVE(REG64(RE))

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
	mov  0(%rdi), %LA /* a */
	mov  4(%rdi), %LB /* b */
	mov  8(%rdi), %LC /* c */
	mov 12(%rdi), %LD /* d */
	mov 16(%rdi), %LE /* e */
	mov %LA, %RA
	mov %LB, %RB
	mov %LC, %RC
	mov %LD, %RD
	mov %LE, %RE

	/* rounds */
	RMD1( 0,   0, 11,   5,  8)
	RMD1( 1,   1, 14,  14,  9)
	RMD1( 2,   2, 15,   7,  9)
	RMD1( 3,   3, 12,   0, 11)
	RMD1( 4,   4,  5,   9, 13)
	RMD1( 5,   5,  8,   2, 15)
	RMD1( 6,   6,  7,  11, 15)
	RMD1( 7,   7,  9,   4,  5)
	RMD1( 8,   8, 11,  13,  7)
	RMD1( 9,   9, 13,   6,  7)
	RMD1(10,  10, 14,  15,  8)
	RMD1(11,  11, 15,   8, 11)
	RMD1(12,  12,  6,   1, 14)
	RMD1(13,  13,  7,  10, 14)
	RMD1(14,  14,  9,   3, 12)
	RMD1(15,  15,  8,  12,  6)

	RMD2(16,   7,  7,   6,  9)
	RMD2(17,   4,  6,  11, 13)
	RMD2(18,  13,  8,   3, 15)
	RMD2(19,   1, 13,   7,  7)
	RMD2(20,  10, 11,   0, 12)
	RMD2(21,   6,  9,  13,  8)
	RMD2(22,  15,  7,   5,  9)
	RMD2(23,   3, 15,  10, 11)
	RMD2(24,  12,  7,  14,  7)
	RMD2(25,   0, 12,  15,  7)
	RMD2(26,   9, 15,   8, 12)
	RMD2(27,   5,  9,  12,  7)
	RMD2(28,   2, 11,   4,  6)
	RMD2(29,  14,  7,   9, 15)
	RMD2(30,  11, 13,   1, 13)
	RMD2(31,   8, 12,   2, 11)

	RMD3(32,   3, 11,  15,  9)
	RMD3(33,  10, 13,   5,  7)
	RMD3(34,  14,  6,   1, 15)
	RMD3(35,   4,  7,   3, 11)
	RMD3(36,   9, 14,   7,  8)
	RMD3(37,  15,  9,  14,  6)
	RMD3(38,   8, 13,   6,  6)
	RMD3(39,   1, 15,   9, 14)
	RMD3(40,   2, 14,  11, 12)
	RMD3(41,   7,  8,   8, 13)
	RMD3(42,   0, 13,  12,  5)
	RMD3(43,   6,  6,   2, 14)
	RMD3(44,  13,  5,  10, 13)
	RMD3(45,  11, 12,   0, 13)
	RMD3(46,   5,  7,   4,  7)
	RMD3(47,  12,  5,  13,  5)

	RMD4(48,   1, 11,   8, 15)
	RMD4(49,   9, 12,   6,  5)
	RMD4(50,  11, 14,   4,  8)
	RMD4(51,  10, 15,   1, 11)
	RMD4(52,   0, 14,   3, 14)
	RMD4(53,   8, 15,  11, 14)
	RMD4(54,  12,  9,  15,  6)
	RMD4(55,   4,  8,   0, 14)
	RMD4(56,  13,  9,   5,  6)
	RMD4(57,   3, 14,  12,  9)
	RMD4(58,   7,  5,   2, 12)
	RMD4(59,  15,  6,  13,  9)
	RMD4(60,  14,  8,   9, 12)
	RMD4(61,   5,  6,   7,  5)
	RMD4(62,   6,  5,  10, 15)
	RMD4(63,   2, 12,  14,  8)

	RMD5(64,   4,  9,  12,  8)
	RMD5(65,   0, 15,  15,  5)
	RMD5(66,   5,  5,  10, 12)
	RMD5(67,   9, 11,   4,  9)
	RMD5(68,   7,  6,   1, 12)
	RMD5(69,  12,  8,   5,  5)
	RMD5(70,   2, 13,   8, 14)
	RMD5(71,  10, 12,   7,  6)
	RMD5(72,  14,  5,   6,  8)
	RMD5(73,   1, 12,   2, 13)
	RMD5(74,   3, 13,  13,  6)
	RMD5(75,   8, 14,  14,  5)
	RMD5(76,  11, 11,   0, 15)
	RMD5(77,   6,  8,   3, 13)
	RMD5(78,  15,  5,   9, 11)
	RMD5(79,  13,  6,  11, 11)

update:
	add  0(%rdi), %LB
	add  4(%rdi), %LC
	add  8(%rdi), %LD
	add 12(%rdi), %LE
	add 16(%rdi), %LA
	add %RC,      %LB
	add %RD,      %LC
	add %RE,      %LD
	add %RA,      %LE
	add %RB,      %LA
	mov %LB, 16(%rdi)
	mov %LC,  0(%rdi)
	mov %LD,  4(%rdi)
	mov %LE,  8(%rdi)
	mov %LA, 12(%rdi)

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

	CALLEE_RESTORE(REG64(RE))
	CALLEE_RESTORE(REG64(RD))
	CALLEE_RESTORE(REG64(RC))
	CALLEE_RESTORE(REG64(RB))
	CALLEE_RESTORE(REG64(RA))

	CALLEE_RESTORE(REG64(LE))
	CALLEE_RESTORE(REG64(LD))
	CALLEE_RESTORE(REG64(LC))
	CALLEE_RESTORE(REG64(LB))
	CALLEE_RESTORE(REG64(LA))

	retq
ENDPROC(JOIN(NAME,xform))
#endif
