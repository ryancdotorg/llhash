#include "../../../common/built.S"
#ifdef STUBBED
STUB(md5_nayuki64_xform)
#else
/*
 * MD5 hash in x86-64 assembly
 *
 * Copyright (c) 2017 Project Nayuki. (MIT License)
 * https://www.nayuki.io/page/fast-md5-hash-implementation-in-x86-assembly
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 *
 * Storage usage:
 *   Bytes  Location  Description
 *       4  eax       MD5 state variable A
 *       4  ecx       MD5 state variable B
 *       4  r8d       MD5 state variable C
 *       4  r9d       MD5 state variable D
 *       4  r10d      Temporary for calculation per round
 *       4  r11d      Temporary for calculation per round
 *       8  rdi       1st arg, Base address of state array argument
 *       8  rsi       2nd arg, Base address of block array argument
 *       8  rdx       3rd arg, Number of blocks to process
 */

#define ROUND0(a, b, c, d, k, s, t)  \
	movl  %c, %r10d;        \
	addl  (k*4)(%rsi), %a;  \
	xorl  %d, %r10d;        \
	andl  %b, %r10d;        \
	xorl  %d, %r10d;        \
	SUM_IRD(t, %r10d, %a);  \
	roll  $s, %a;           \
	addl  %b, %a;

#define ROUND1(a, b, c, d, k, s, t)  \
	movl  %d, %r10d;        \
	movl  %d, %r11d;        \
	addl  (k*4)(%rsi), %a;  \
	notl  %r10d;            \
	andl  %b, %r11d;        \
	andl  %c, %r10d;        \
	orl   %r11d, %r10d;     \
	SUM_IRD(t, %r10d, %a);  \
	roll  $s, %a;           \
	addl  %b, %a;

#define ROUND2(a, b, c, d, k, s, t)  \
	movl  %c, %r10d;        \
	addl  (k*4)(%rsi), %a;  \
	xorl  %d, %r10d;        \
	xorl  %b, %r10d;        \
	SUM_IRD(t, %r10d, %a);  \
	roll  $s, %a;           \
	addl  %b, %a;

#define ROUND3(a, b, c, d, k, s, t)  \
	movl  %d, %r10d;        \
	not   %r10d;            \
	addl  (k*4)(%rsi), %a;  \
	orl   %b, %r10d;        \
	xorl  %c, %r10d;        \
	SUM_IRD(t, %r10d, %a);  \
	roll  $s, %a;           \
	addl  %b, %a;

/* void md5_nayuki64_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(md5_nayuki64_xform)
ny64_process:
	/* Load state */
	movl     0(%rdi), %eax  /* a */
	movl     4(%rdi), %ecx  /* b */
	movl     8(%rdi), %r8d  /* c */
	movl    12(%rdi), %r9d  /* d */

	/* 64 rounds of hashing */
	ROUND0(eax, ecx, r8d, r9d,  0,  7, -0x28955B88)
	ROUND0(r9d, eax, ecx, r8d,  1, 12, -0x173848AA)
	ROUND0(r8d, r9d, eax, ecx,  2, 17,  0x242070DB)
	ROUND0(ecx, r8d, r9d, eax,  3, 22, -0x3E423112)
	ROUND0(eax, ecx, r8d, r9d,  4,  7, -0x0A83F051)
	ROUND0(r9d, eax, ecx, r8d,  5, 12,  0x4787C62A)
	ROUND0(r8d, r9d, eax, ecx,  6, 17, -0x57CFB9ED)
	ROUND0(ecx, r8d, r9d, eax,  7, 22, -0x02B96AFF)
	ROUND0(eax, ecx, r8d, r9d,  8,  7,  0x698098D8)
	ROUND0(r9d, eax, ecx, r8d,  9, 12, -0x74BB0851)
	ROUND0(r8d, r9d, eax, ecx, 10, 17, -0x0000A44F)
	ROUND0(ecx, r8d, r9d, eax, 11, 22, -0x76A32842)
	ROUND0(eax, ecx, r8d, r9d, 12,  7,  0x6B901122)
	ROUND0(r9d, eax, ecx, r8d, 13, 12, -0x02678E6D)
	ROUND0(r8d, r9d, eax, ecx, 14, 17, -0x5986BC72)
	ROUND0(ecx, r8d, r9d, eax, 15, 22,  0x49B40821)
	ROUND1(eax, ecx, r8d, r9d,  1,  5, -0x09E1DA9E)
	ROUND1(r9d, eax, ecx, r8d,  6,  9, -0x3FBF4CC0)
	ROUND1(r8d, r9d, eax, ecx, 11, 14,  0x265E5A51)
	ROUND1(ecx, r8d, r9d, eax,  0, 20, -0x16493856)
	ROUND1(eax, ecx, r8d, r9d,  5,  5, -0x29D0EFA3)
	ROUND1(r9d, eax, ecx, r8d, 10,  9,  0x02441453)
	ROUND1(r8d, r9d, eax, ecx, 15, 14, -0x275E197F)
	ROUND1(ecx, r8d, r9d, eax,  4, 20, -0x182C0438)
	ROUND1(eax, ecx, r8d, r9d,  9,  5,  0x21E1CDE6)
	ROUND1(r9d, eax, ecx, r8d, 14,  9, -0x3CC8F82A)
	ROUND1(r8d, r9d, eax, ecx,  3, 14, -0x0B2AF279)
	ROUND1(ecx, r8d, r9d, eax,  8, 20,  0x455A14ED)
	ROUND1(eax, ecx, r8d, r9d, 13,  5, -0x561C16FB)
	ROUND1(r9d, eax, ecx, r8d,  2,  9, -0x03105C08)
	ROUND1(r8d, r9d, eax, ecx,  7, 14,  0x676F02D9)
	ROUND1(ecx, r8d, r9d, eax, 12, 20, -0x72D5B376)
	ROUND2(eax, ecx, r8d, r9d,  5,  4, -0x0005C6BE)
	ROUND2(r9d, eax, ecx, r8d,  8, 11, -0x788E097F)
	ROUND2(r8d, r9d, eax, ecx, 11, 16,  0x6D9D6122)
	ROUND2(ecx, r8d, r9d, eax, 14, 23, -0x021AC7F4)
	ROUND2(eax, ecx, r8d, r9d,  1,  4, -0x5B4115BC)
	ROUND2(r9d, eax, ecx, r8d,  4, 11,  0x4BDECFA9)
	ROUND2(r8d, r9d, eax, ecx,  7, 16, -0x0944B4A0)
	ROUND2(ecx, r8d, r9d, eax, 10, 23, -0x41404390)
	ROUND2(eax, ecx, r8d, r9d, 13,  4,  0x289B7EC6)
	ROUND2(r9d, eax, ecx, r8d,  0, 11, -0x155ED806)
	ROUND2(r8d, r9d, eax, ecx,  3, 16, -0x2B10CF7B)
	ROUND2(ecx, r8d, r9d, eax,  6, 23,  0x04881D05)
	ROUND2(eax, ecx, r8d, r9d,  9,  4, -0x262B2FC7)
	ROUND2(r9d, eax, ecx, r8d, 12, 11, -0x1924661B)
	ROUND2(r8d, r9d, eax, ecx, 15, 16,  0x1FA27CF8)
	ROUND2(ecx, r8d, r9d, eax,  2, 23, -0x3B53A99B)
	ROUND3(eax, ecx, r8d, r9d,  0,  6, -0x0BD6DDBC)
	ROUND3(r9d, eax, ecx, r8d,  7, 10,  0x432AFF97)
	ROUND3(r8d, r9d, eax, ecx, 14, 15, -0x546BDC59)
	ROUND3(ecx, r8d, r9d, eax,  5, 21, -0x036C5FC7)
	ROUND3(eax, ecx, r8d, r9d, 12,  6,  0x655B59C3)
	ROUND3(r9d, eax, ecx, r8d,  3, 10, -0x70F3336E)
	ROUND3(r8d, r9d, eax, ecx, 10, 15, -0x00100B83)
	ROUND3(ecx, r8d, r9d, eax,  1, 21, -0x7A7BA22F)
	ROUND3(eax, ecx, r8d, r9d,  8,  6,  0x6FA87E4F)
	ROUND3(r9d, eax, ecx, r8d, 15, 10, -0x01D31920)
	ROUND3(r8d, r9d, eax, ecx,  6, 15, -0x5CFEBCEC)
	ROUND3(ecx, r8d, r9d, eax, 13, 21,  0x4E0811A1)
	ROUND3(eax, ecx, r8d, r9d,  4,  6, -0x08AC817E)
	ROUND3(r9d, eax, ecx, r8d, 11, 10, -0x42C50DCB)
	ROUND3(r8d, r9d, eax, ecx,  2, 15,  0x2AD7D2BB)
	ROUND3(ecx, r8d, r9d, eax,  9, 21, -0x14792C6F)

	/* Save updated state */
	addl  %eax,  0(%rdi)
	addl  %ecx,  4(%rdi)
	addl  %r8d,  8(%rdi)
	addl  %r9d, 12(%rdi)

ny64_next:
	/* maybe process another block */
	dec   %rdx
	jz    ny64_ret
	addq  $64, %rsi
	jmp   ny64_process

ny64_ret:
	retq
ENDPROC(md5_nayuki64_xform)
#endif
