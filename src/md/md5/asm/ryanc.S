/* SPDX-License-Identifier: 0BSD OR OR MIT-0 OR CC0-1.0+
 * Copyright (c) 2022, Ryan Castellucci, no rights reserved
 * MD5 implemetation, transform only
 */
#include "../../../common/built.S"
#ifdef STUBBED
STUB(md5_ryanc_xform)
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
#define T4
#define T5

/* end of input */
#define EI IF_ELSE(SAME_REG(RD,rdx))(r13,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

#ifdef SUM_IRD
#undef SUM_IRD
#endif

#if 1
#define SUM_IRD(ic, ra, rd) \
	add $ic, rd; \
	add ra, rd
#else
#define SUM_IRD(ic, ra, rd) \
	lea ic(rd,ra), rd
#endif

#define ROUND_F(r, a, b, c, d, kn, s, t) \
CONCAT(NAME,_f,PAD02(r)): \
	IF_EQUAL(r,0)(mov %RD, %T2;) \
	xor %c, %T2; \
	SUM_IRD(t, %T1, %a); \
	and %b, %T2; \
	mov kn*4(%rsi), %T1; \
	xor %d, %T2; \
	add %T2, %a; \
	rol $s, %a; \
	IF_NOTEQ(r,15)(mov %c, %T2;) \
	add %b, %a;

/* https://github.com/animetosho/md5-optimisation#dependency-shortcut-in-g-function
 * standard version of g is either
 * a = (c ^ (d & (b ^ c))) + a + rol(a, s) + b
 * or
 * a = ((~d & c) | (d & b)) + a + rol(a, s) + b
 * we instead compute
 * a = (~d & c) + (d & b) + a + rol(a, s) + b
 * which allows the CPU to take better advantage of commutative addition */
#define ROUND_G(r, a, b, c, d, kn, s, t) \
CONCAT(NAME,_g,PAD02(r)): \
	IF_EQUAL(r,16)(mov %RD, %T2;) \
	IF_EQUAL(r,16)(mov %RD, %T3;) \
	not %T2; \
	and %b, %T3; \
	SUM_IRD(t, %T1, %a); \
	and %c, %T2; \
	add %T2, %a; \
	mov kn*4(%rsi), %T1; \
	IF_NOTEQ(r,31)(mov %c, %T2;) \
	add %T3, %a; \
	IF_NOTEQ(r,31)(mov %c, %T3;) \
	rol $s, %a; \
	add %b, %a;

#define ROUND_H(r, a, b, c, d, kn, s, t) \
CONCAT(NAME,_h,PAD02(r)): \
	IF_EQUAL(r,32)(mov %RC, %T2;) \
	SUM_IRD(t, %T1, %a); \
	xor %d, %T2; \
	mov kn*4(%rsi), %T1; \
	xor %b, %T2; \
	add %T2, %a; \
	IF_ELSE(ODD(r))(rol $s COMMA() %a;, IF_NOTEQ(r,47)(mov %b COMMA() %T2;)) \
	IF_ELSE(ODD(r))(IF_NOTEQ(r,47)(mov %b COMMA() %T2;), rol $s COMMA() %a;) \
	add %b, %a;

#define ROUND_I(r, a, b, c, d, kn, s, t) \
CONCAT(NAME,_i,PAD02(r)): \
	IF_EQUAL(r,48)(mov $0xffffffff, %T2;) \
	IF_EQUAL(r,48)(xor %RD, %T2;) \
	SUM_IRD(t, %T1, %a); \
	or %b, %T2; \
	IF_NOTEQ(r,63)(mov kn*4(%rsi), %T1;) \
	xor %c, %T2; \
	add %T2, %a; \
	IF_NOTEQ(r,63)(mov $0xffffffff, %T2;) \
	rol $s, %a; \
	IF_NOTEQ(r,63)(xor %c, %T2;) \
	add %b, %a;

#define R2A(R, r, k0, s0, t0, k1, s1, t1) \
R(ADD0(r), RA, RB, RC, RD, k0, s0, t0) \
R(ADD1(r), RD, RA, RB, RC, k1, s1, t1)

#define R2B(R, r, k0, s0, t0, k1, s1, t1) \
R(ADD0(r), RC, RD, RA, RB, k0, s0, t0) \
R(ADD1(r), RB, RC, RD, RA, k1, s1, t1)

/* void md5_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(md5_ryanc_xform)
save:
	/* Save registers */
	IF(CALLEE_SAVED(T3))(movq %REG64(T3), %xmm0)
	IF(CALLEE_SAVED(RB))(movq %REG64(RB), %xmm1)
	IF(CALLEE_SAVED(EI))(movq %REG64(EI), %xmm2)

adjust:
	shl $6, %rdx
	add %rsi, %rdx
	IF(DIFF_REG(EI,rdx))(mov %rdx, %END)
//	lea (%rsi,%END,1), %END
//	cmp %rsi, %END
//	je ret


load:
	/* Load state */
	mov  0(%rdi), %RA  /* a */
	mov  4(%rdi), %RB  /* b */
	mov  8(%rdi), %RC  /* c */
	mov 12(%rdi), %RD  /* d */
	mov  0(%rsi), %T1  /* first word of block */

	/* 64 rounds of hashing */
	R2A(ROUND_F,  0,  1,  7, -0x28955B88,  2, 12, -0x173848AA)
	R2B(ROUND_F,  2,  3, 17,  0x242070DB,  4, 22, -0x3E423112)
	R2A(ROUND_F,  4,  5,  7, -0x0A83F051,  6, 12,  0x4787C62A)
	R2B(ROUND_F,  6,  7, 17, -0x57CFB9ED,  8, 22, -0x02B96AFF)
	R2A(ROUND_F,  8,  9,  7,  0x698098D8, 10, 12, -0x74BB0851)
	R2B(ROUND_F, 10, 11, 17, -0x0000A44F, 12, 22, -0x76A32842)
	R2A(ROUND_F, 12, 13,  7,  0x6B901122, 14, 12, -0x02678E6D)
	R2B(ROUND_F, 14, 15, 17, -0x5986BC72,  1, 22,  0x49B40821)

	R2A(ROUND_G, 16,  6,  5, -0x09E1DA9E, 11,  9, -0x3FBF4CC0)
	R2B(ROUND_G, 18,  0, 14,  0x265E5A51,  5, 20, -0x16493856)
	R2A(ROUND_G, 20, 10,  5, -0x29D0EFA3, 15,  9,  0x02441453)
	R2B(ROUND_G, 22,  4, 14, -0x275E197F,  9, 20, -0x182C0438)
	R2A(ROUND_G, 24, 14,  5,  0x21E1CDE6,  3,  9, -0x3CC8F82A)
	R2B(ROUND_G, 26,  8, 14, -0x0B2AF279, 13, 20,  0x455A14ED)
	R2A(ROUND_G, 28,  2,  5, -0x561C16FB,  7,  9, -0x03105C08)
	R2B(ROUND_G, 30, 12, 14,  0x676F02D9,  5, 20, -0x72D5B376)

	R2A(ROUND_H, 32,  8,  4, -0x0005C6BE, 11, 11, -0x788E097F)
	R2B(ROUND_H, 34, 14, 16,  0x6D9D6122,  1, 23, -0x021AC7F4)
	R2A(ROUND_H, 36,  4,  4, -0x5B4115BC,  7, 11,  0x4BDECFA9)
	R2B(ROUND_H, 38, 10, 16, -0x0944B4A0, 13, 23, -0x41404390)
	R2A(ROUND_H, 40,  0,  4,  0x289B7EC6,  3, 11, -0x155ED806)
	R2B(ROUND_H, 42,  6, 16, -0x2B10CF7B,  9, 23,  0x04881D05)
	R2A(ROUND_H, 44, 12,  4, -0x262B2FC7, 15, 11, -0x1924661B)
	R2B(ROUND_H, 46,  2, 16,  0x1FA27CF8,  0, 23, -0x3B53A99B)

	R2A(ROUND_I, 48,  7,  6, -0x0BD6DDBC, 14, 10,  0x432AFF97)
	R2B(ROUND_I, 50,  5, 15, -0x546BDC59, 12, 21, -0x036C5FC7)
	R2A(ROUND_I, 52,  3,  6,  0x655B59C3, 10, 10, -0x70F3336E)
	R2B(ROUND_I, 54,  1, 15, -0x00100B83,  8, 21, -0x7A7BA22F)
	R2A(ROUND_I, 56, 15,  6,  0x6FA87E4F,  6, 10, -0x01D31920)
	R2B(ROUND_I, 58, 13, 15, -0x5CFEBCEC,  4, 21,  0x4E0811A1)
	R2A(ROUND_I, 60, 11,  6, -0x08AC817E,  2, 10, -0x42C50DCB)
	R2B(ROUND_I, 62,  9, 15,  0x2AD7D2BB,  _, 21, -0x14792C6F)

update:
	/* Save updated state */
	add %RA,  0(%rdi)
	add %RB,  4(%rdi)
	add %RC,  8(%rdi)
	add %RD, 12(%rdi)

next:
	/* maybe process another block */
	add  $64, %rsi
	cmp  %rsi, %EI
	jne  load

ret:
	/* Restore registers */
	IF(CALLEE_SAVED(EI))(movq %xmm2, %REG64(EI))
	IF(CALLEE_SAVED(RB))(movq %xmm1, %REG64(RB))
	IF(CALLEE_SAVED(T3))(movq %xmm0, %REG64(T3))
	retq
ENDPROC(md5_ryanc_xform)
#endif
