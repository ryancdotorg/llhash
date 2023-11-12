/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR Unlicense OR CC0-1.0+
 * Copyright (c) 2022, Ryan Castellucci, no rights reserved
 * RIPEMD-160 implemetation, transform only
 */
#define NAME ripemd160_ryanc_avx2
#include "../../../common/built.S"
#ifdef STUBBED
STUB(JOIN(NAME,xform))
#else

/* main working registers */
#define LA eax
#define LB ebx
#define LC ecx
#define LD r8d
#define LE r9d

#define RA r10d
#define RB r11d
#define RC r12d
#define RD r13d
#define RE r14d

#define XI xmm0

#define XA xmm1
#define XB xmm2
#define XC xmm3
#define XD xmm4
#define XE xmm5

#define XT xmm6

#define XN xmm8

#define XS xmm9

/* temporary registers */
#define T1 ebp
#define T2 r15d
#define T3
#define T4
#define T5

/* end of input */
#define EI rdx

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
	add %T1, %a;

#if 0
#define G(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %c, %T1; \
	and %b, %T1; \
	add %T1, %a; \
	andn %d, %b, %T1; \
	add %T1, %a;

#else
#define G(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %d, %T1;                    /* t1 = d */ \
	xor %c, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %b, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %d, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;

#endif

#define H(r, a, b, c, d, e, s, k) \
	add $k, %a;                     /* a += k : k + w + a */ \
	mov %c, %T1;                    /* t1 = c */ \
	not %T1;                        /* t1 ~= : ~c */ \
	or  %b, %T1;                    /* t1 |= b : b | ~c */ \
	xor %d, %T1;                    /* t1 ^= d : (b | ~c) ^ d */ \
	add %T1, %a;

#if 0
#define I(r, a, b, c, d, e, s, k) \
	add $k, %a;                     /* a += k : k + w + a */ \
	mov %d, %T1;                    /* t1 = d */ \
	and %b, %T1;                    /* t1 &= b : d & b */ \
	add %T1, %a;                    /* a += t1 */ \
	andn %c, %d, %T2;               /* t1 = c & ~b */ \
	add %T2, %a;

#else
#define I(r, a, b, c, d, e, s, k) \
	IF_NOTEQ(k,0)(add $k, %a;)      /* a += k : k + w + a */ \
	mov %c, %T1;                    /* t1 = d */ \
	xor %b, %T1;                    /* t1 ^= c : (c ^ d) */ \
	and %d, %T1;                    /* t1 &= b : (b & (c ^ d)) */ \
	xor %c, %T1;                    /* t1 ^= d : (d ^ (b & (c ^ d))) */ \
	add %T1, %a;

#endif

#define J(r, a, b, c, d, e, s, k) \
	H(r, a, c, d, b, e, s, k)

#define X2SHUF(IM, XX, XY) \
	movdqa        %XX,      %XT; \
	vpblendd $IM, %XY, %XX, %XX; \
	vpblendd $IM, %XT, %XY, %XY;

#define X3SHUF(IM, XX, XY, XZ) \
	movdqa        %XX,      %XT; \
	vpblendd $IM, %XY, %XX, %XX; \
	vpblendd $IM, %XZ, %XY, %XY; \
	vpblendd $IM, %XT, %XZ, %XZ;

#define X4SHUF(IM, XW, XX, XY, XZ) \
	movdqa        %XW,      %XT; \
	vpblendd $IM, %XX, %XW, %XW; \
	vpblendd $IM, %XY, %XX, %XX; \
	vpblendd $IM, %XZ, %XY, %XY; \
	vpblendd $IM, %XT, %XZ, %XZ;

#define X5SHUF(IM, XV, XW, XX, XY, XZ) \
	movdqa        %XV,      %XT; \
	vpblendd $IM, %XW, %XV, %XV; \
	vpblendd $IM, %XX, %XW, %XW; \
	vpblendd $IM, %XY, %XX, %XX; \
	vpblendd $IM, %XZ, %XY, %XY; \
	vpblendd $IM, %XT, %XZ, %XZ;

#define _X5PERM(IM, XV, XW, XX, XY, XZ, YV, YW, YX, YY, YZ) \
	IF_NOTEQ(XV, YV)(movdqa %XV, %xmm10;) \
	IF_NOTEQ(XW, YW)(movdqa %XW, %xmm11;) \
	IF_NOTEQ(XX, YX)(movdqa %XX, %xmm12;) \
	IF_NOTEQ(XY, YY)(movdqa %XY, %xmm13;) \
	IF_NOTEQ(XZ, YZ)(movdqa %XZ, %xmm14;) \
	IF_NOTEQ(XV, YV)(vpblendd $IM, %xmm10, %YV, %YV;) \
	IF_NOTEQ(XW, YW)(vpblendd $IM, %xmm11, %YW, %YW;) \
	IF_NOTEQ(XX, YX)(vpblendd $IM, %xmm12, %YX, %YX;) \
	IF_NOTEQ(XY, YY)(vpblendd $IM, %xmm13, %YY, %YY;) \
	IF_NOTEQ(XZ, YZ)(vpblendd $IM, %xmm14, %YZ, %YZ;)

#define X5PERM(IM, XV, XW, XX, XY, XZ, YV, YW, YX, YY, YZ) \
	movdqa %XV, %xmm10; \
	movdqa %XW, %xmm11; \
	movdqa %XX, %xmm12; \
	movdqa %XY, %xmm13; \
	movdqa %XZ, %xmm14; \
	vpblendd $IM, %xmm10, %YV, %YV; \
	vpblendd $IM, %xmm11, %YW, %YW; \
	vpblendd $IM, %xmm12, %YX, %YX; \
	vpblendd $IM, %xmm13, %YY, %YY; \
	vpblendd $IM, %xmm14, %YZ, %YZ;

#define GI_BODY(r, s, lw, rw) \
EXPAND(DEFER1(_GI_BODY)(r, s, ROTATE5L(r, XA, XB, XC, XD, XE), lw, rw))
#define _GI_BODY(r, s, xa, xb, xc, xd, xe, lw, rw) \
CONCAT(NAME,_,PAD02(r),X): \
	IF_EQUAL(r,16)(movdqa GI_ADD(%rip), %XI;) \
	movdqa  GI_SHR+s*16(%rip), %XS; \
	pinsrd  $2, lw*4(%rsi), %XT; \
	pinsrd  $0, rw*4(%rsi), %XT; \
	paddd   %XI, %XT; \
	paddd   %XT, %xa; \
	vpxor   %xd, %xc, %XT; \
	pand    %xb, %XT; \
	pxor    %xd, %XT; \
	paddd   %XT, %xa; \
	pshufd  $0xa0, %xa, %xa; \
	vpsrlvq %XS, %xa, %xa; \
	paddd   %xe, %xa; \
	movdqa %xc, %XT; \
	vpblendd $3, %xd, %xc, %xc; \
	pshufd  $0xa0, %xc, %xc; \
	psrlq   $22, %xc; \
	vpblendd $3, %xb, %xd, %xd; \
	IF_NOTEQ(r,31)(vpblendd $3, %xa, %xb, %xb;) \
	IF_NOTEQ(r,31)(vpblendd $3, %xc, %xa, %xa;) \
	IF_NOTEQ(r,31)(vpblendd $3, %XT, %xc, %xc;) \
	IF_EQUAL(r,31)(vpblendd $3, %XT, %xb, %xb;) \


#define HH_BODY(r, s, lw, rw) \
EXPAND(DEFER1(_HH_BODY)(r, s, ROTATE5L(r, XA, XB, XC, XD, XE), lw, rw))
#define _HH_BODY(r, s, xa, xb, xc, xd, xe, lw, rw) \
CONCAT(NAME,_,PAD02(r),X): \
	IF_EQUAL(r,32)(movdqa HH_ADD(%rip), %XI;) \
	movdqa  HH_SHR+s*16(%rip), %XS; \
	pinsrd  $2, lw*4(%rsi), %XT; \
	pinsrd  $0, rw*4(%rsi), %XT; \
	paddd   %XI, %XT; \
	paddd   %XT, %xa; \
	vpxor   %xc, %XN, %XT; \
	por     %xb, %XT; \
	pxor    %xd, %XT; \
	paddd   %XT, %xa; \
	pshufd  $0xa0, %xa, %xa; \
	vpsrlvq %XS, %xa, %xa; \
	paddd   %xe, %xa; \
	pshufd  $0xa0, %xc, %xc; \
	psrlq   $22, %xc; \
	IF_EQUAL(r,47)(X3SHUF(0x3, xc, xa, xb)) \


#define IG_BODY(r, s, lw, rw) \
EXPAND(DEFER1(_IG_BODY)(r, s, ROTATE5L(r, XA, XB, XC, XD, XE), lw, rw))
#define _IG_BODY(r, s, xa, xb, xc, xd, xe, lw, rw) \
CONCAT(NAME,_,PAD02(r),X): \
	IF_EQUAL(r,48)(movdqa IG_ADD(%rip), %XI;) \
	movdqa  IG_SHR+s*16(%rip), %XS; \
	pinsrd  $2, lw*4(%rsi), %XT; \
	pinsrd  $0, rw*4(%rsi), %XT; \
	paddd   %XI, %XT; \
	paddd   %XT, %xa; \
	vpxor   %xb, %xc, %XT; \
	pand    %xd, %XT; \
	pxor    %xc, %XT; \
	paddd   %XT, %xa; \
	pshufd  $0xa0, %xa, %xa; \
	vpsrlvq %XS, %xa, %xa; \
	paddd   %xe, %xa; \
	movdqa %xc, %XT; \
	vpblendd $3, %xb, %xc, %xc; \
	pshufd  $0xa0, %xc, %xc; \
	psrlq   $22, %xc; \
	IF_NOTEQ(r,63)(vpblendd $3, %xc, %xb, %xb;) \
	IF_NOTEQ(r,63)(vpblendd $3, %xa, %xc, %xc;) \
	IF_NOTEQ(r,63)(vpblendd $3, %xd, %xa, %xa;) \
	IF_NOTEQ(r,63)(vpblendd $3, %XT, %xd, %xd;) \


#define _RND(FN, r, LR, a, b, c, d, e, w, s, k) \
EXPAND(DEFER1(RND)(FNL, r, LR, ROTATE5L(r, A, B, C, D, E), w, s, k))
#define RND(FN, r, LR, a, b, c, d, e, w, s, k) \
CONCAT(NAME,_,PAD02(r),LR): \
	add w*4(%rsi), %a;              /* a += w : w + a*/ \
	FN(r, a, b, c, d, e, s, k) \
	rol $s, %a;                     /* a = rol(a, s) */ \
	add %e, %a;                     /* a += e */ \
	rol $10, %c;                    /* c = rol(c, 10) */ \

#define R(r, FNL, wl, sl, kl, FNR, wr, sr, kr) \
EXPAND(DEFER1(RND)(FNL, r, L, ROTATE5L(r, LA, LB, LC, LD, LE), wl, sl, kl)) \
EXPAND(DEFER1(RND)(FNR, r, R, ROTATE5L(r, RA, RB, RC, RD, RE), wr, sr, kr))

#define RMD1(r, wl, sl, wr, sr) R(r, F, wl, sl,          0, J, wr, sr, 0x50A28BE6)
#define RMD2(r, wl, sl, wr, sr) R(r, G, wl, sl, 0x5A827999, I, wr, sr, 0x5C4DD124)
#define RMD3(r, wl, sl, wr, sr) R(r, H, wl, sl, 0x6ED9EBA1, H, wr, sr, 0x6D703EF3)
#define RMD4(r, wl, sl, wr, sr) R(r, I, wl, sl, 0x8F1BBCDC, G, wr, sr, 0x7A6D76E9)
#define RMD5(r, wl, sl, wr, sr) R(r, J, wl, sl, 0xA953FD4E, F, wr, sr,          0)

.align 64
.type GI_SHR, @object
GI_SHR:
	.quad 0x17,0x19
	.quad 0x13,0x1a
	.quad 0x11,0x18
	.quad 0x19,0x13
	.quad 0x14,0x15
	.quad 0x18,0x17
	.quad 0x17,0x19
	.quad 0x15,0x11
	.quad 0x19,0x19
	.quad 0x19,0x14
	.quad 0x14,0x11
	.quad 0x19,0x17
	.quad 0x1a,0x15
	.quad 0x11,0x19
	.quad 0x13,0x13
	.quad 0x15,0x14

.type HH_SHR, @object
HH_SHR:
	.quad 0x17,0x15
	.quad 0x19,0x13
	.quad 0x11,0x1a
	.quad 0x15,0x19
	.quad 0x18,0x12
	.quad 0x1a,0x17
	.quad 0x1a,0x13
	.quad 0x12,0x11
	.quad 0x14,0x12
	.quad 0x13,0x18
	.quad 0x1b,0x13
	.quad 0x12,0x1a
	.quad 0x13,0x1b
	.quad 0x13,0x14
	.quad 0x19,0x19
	.quad 0x1b,0x1b

.type IG_SHR, @object
IG_SHR:
	.quad 0x11,0x15
	.quad 0x1b,0x14
	.quad 0x18,0x12
	.quad 0x15,0x11
	.quad 0x12,0x12
	.quad 0x12,0x11
	.quad 0x1a,0x17
	.quad 0x12,0x18
	.quad 0x1a,0x17
	.quad 0x17,0x12
	.quad 0x14,0x1b
	.quad 0x17,0x1a
	.quad 0x14,0x18
	.quad 0x1b,0x1a
	.quad 0x11,0x1b
	.quad 0x18,0x14

.align 32
.type GI_ADD, @object
GI_ADD:
.long 0x5c4dd124,0,0x5a827999,0

.type HH_ADD, @object
HH_ADD:
.long 0x6d703ef3,0,0x6ed9eba1,0

.type IG_ADD, @object
IG_ADD:
.long 0x7a6d76e9,0,0x8f1bbcdc,0

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
	pcmpeqb %XN, %XN;

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

CONCAT(NAME,_,x_load):
	pinsrd $2, %LA, %XA;
	pinsrd $2, %LB, %XB;
	pinsrd $2, %LC, %XC;
	pinsrd $2, %LD, %XD;
	pinsrd $2, %LE, %XE;

	pinsrd $0, %RE, %XE;
	pinsrd $0, %RB, %XC;
	pinsrd $0, %RA, %XB;
	pinsrd $0, %RD, %XD;
	pinsrd $0, %RC, %XA;

	GI_BODY(16,  0,  7,  6)
	GI_BODY(17,  1,  4, 11)
	GI_BODY(18,  2, 13,  3)
	GI_BODY(19,  3,  1,  7)
	GI_BODY(20,  4, 10,  0)
	GI_BODY(21,  5,  6, 13)
	GI_BODY(22,  6, 15,  5)
	GI_BODY(23,  7,  3, 10)
	GI_BODY(24,  8, 12, 14)
	GI_BODY(25,  9,  0, 15)
	GI_BODY(26, 10,  9,  8)
	GI_BODY(27, 11,  5, 12)
	GI_BODY(28, 12,  2,  4)
	GI_BODY(29, 13, 14,  9)
	GI_BODY(30, 14, 11,  1)
	GI_BODY(31, 15,  8,  2)

	HH_BODY(32,  0,  3, 15)
	HH_BODY(33,  1, 10,  5)
	HH_BODY(34,  2, 14,  1)
	HH_BODY(35,  3,  4,  3)
	HH_BODY(36,  4,  9,  7)
	HH_BODY(37,  5, 15, 14)
	HH_BODY(38,  6,  8,  6)
	HH_BODY(39,  7,  1,  9)
	HH_BODY(40,  8,  2, 11)
	HH_BODY(41,  9,  7,  8)
	HH_BODY(42, 10,  0, 12)
	HH_BODY(43, 11,  6,  2)
	HH_BODY(44, 12, 13, 10)
	HH_BODY(45, 13, 11,  0)
	HH_BODY(46, 14,  5,  4)
	HH_BODY(47, 15, 12, 13)

	IG_BODY(48,  0,  1,  8)
	IG_BODY(49,  1,  9,  6)
	IG_BODY(50,  2, 11,  4)
	IG_BODY(51,  3, 10,  1)
	IG_BODY(52,  4,  0,  3)
	IG_BODY(53,  5,  8, 11)
	IG_BODY(54,  6, 12, 15)
	IG_BODY(55,  7,  4,  0)
	IG_BODY(56,  8, 13,  5)
	IG_BODY(57,  9,  3, 12)
	IG_BODY(58, 10,  7,  2)
	IG_BODY(59, 11, 15, 13)
	IG_BODY(60, 12, 14,  9)
	IG_BODY(61, 13,  5,  7)
	IG_BODY(62, 14,  6, 10)
	IG_BODY(63, 15,  2, 14)

CONCAT(NAME,_,x_stor):
	pextrd  $2, %XA, %LA;
	pextrd  $2, %XB, %LB;
	pextrd  $2, %XC, %LC;
	pextrd  $2, %XD, %LD;
	pextrd  $2, %XE, %LE;

	pextrd  $0, %XT, %RA;
	pextrd  $0, %XB, %RB;
	pextrd  $0, %XC, %RC;
	pextrd  $0, %XA, %RD;
	pextrd  $0, %XE, %RE;

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
