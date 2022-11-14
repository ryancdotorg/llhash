/* SPDX-License-Identifier: MIT */
#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha1_nayuki64_xform)
#elif !(defined(WITH_NAYUKI))
#error "implementation disabled"
#else
/*
 * SHA-1 hash in x86-64 assembly
 *
 * Copyright (c) 2017 Project Nayuki. (MIT License)
 * https://www.nayuki.io/page/fast-sha1-hash-implementation-in-x86-assembly
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
 *       4  eax       SHA-1 state variable A
 *       4  ecx       SHA-1 state variable B
 *       4  r8d       SHA-1 state variable C
 *       4  r9d       SHA-1 state variable D
 *       4  r10d      SHA-1 state variable E
 *       8  rdi       1st arg, Base address of state array argument
 *       8  rsi       2nd arg, Base address of block array argument
 *       8  rdx       3rd arg, Number of blocks to process
 *       4  r11d      Temporary for calculation per round
 *       4  ebx       Temporary for calculation per round
 *       8  rsp       x86-64 stack pointer
 *      64  [rsp+0]   Circular buffer of most recent 16 key schedule items, 4 bytes each
 */

#define ROUND0a(a, b, c, d, e, i)  \
	movl    (i*4)(%rsi), %r11d;  \
	bswapl  %r11d;               \
	movl    %r11d, (i*4)(%rsp);  \
	addl    %r11d, %e;           \
	movl    %c, %r11d;           \
	xorl    %d, %r11d;           \
	andl    %b, %r11d;           \
	xorl    %d, %r11d;           \
	ROUNDTAIL(a, b, e, i, 0x5A827999)

#define SCHEDULE(i, e)  \
	movl  (((i- 3)&0xF)*4)(%rsp), %r11d;  \
	xorl  (((i- 8)&0xF)*4)(%rsp), %r11d;  \
	xorl  (((i-14)&0xF)*4)(%rsp), %r11d;  \
	xorl  (((i-16)&0xF)*4)(%rsp), %r11d;  \
	roll  $1, %r11d;                      \
	addl  %r11d, %e;                      \
	movl  %r11d, ((i&0xF)*4)(%rsp);

#define ROUND0b(a, b, c, d, e, i)  \
	SCHEDULE(i, e)  \
	movl  %c, %r11d;  \
	xorl  %d, %r11d;  \
	andl  %b, %r11d;  \
	xorl  %d, %r11d;  \
	ROUNDTAIL(a, b, e, i, 0x5A827999)

#define ROUND1(a, b, c, d, e, i)  \
	SCHEDULE(i, e)  \
	movl  %b, %r11d;  \
	xorl  %c, %r11d;  \
	xorl  %d, %r11d;  \
	ROUNDTAIL(a, b, e, i, 0x6ED9EBA1)

#define ROUND2(a, b, c, d, e, i)  \
	SCHEDULE(i, e)  \
	movl  %c, %r11d;    \
	movl  %c, %ebx;     \
	orl   %d, %r11d;    \
	andl  %b, %r11d;    \
	andl  %d, %ebx;     \
	orl   %ebx, %r11d;  \
	ROUNDTAIL(a, b, e, i, -0x70E44324)

#define ROUND3(a, b, c, d, e, i)  \
	SCHEDULE(i, e)  \
	movl  %b, %r11d;  \
	xorl  %c, %r11d;  \
	xorl  %d, %r11d;  \
	ROUNDTAIL(a, b, e, i, -0x359D3E2A)

#define ROUNDTAIL(a, b, e, i, k)  \
	roll  $30, %b;          \
	leal  k(%e,%r11d), %e;  \
	movl  %a, %r11d;        \
	roll  $5, %r11d;        \
	addl  %r11d, %e;


/* void sha1_nayuki64_xform(uint32_t state[static 5], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(sha1_nayuki64_xform)
	/* Save registers, allocate scratch space */
	pushq %rbx
	subq  $64, %rsp

ny64_process:
	/* Load state */
	movl     0(%rdi), %eax  /* a */
	movl     4(%rdi), %ecx  /* b */
	movl     8(%rdi), %r8d  /* c */
	movl    12(%rdi), %r9d  /* d */
	movl    16(%rdi), %r10d /* e */

	/* 80 rounds of hashing */
	ROUND0a(eax, ecx, r8d, r9d, r10d,  0)
	ROUND0a(r10d, eax, ecx, r8d, r9d,  1)
	ROUND0a(r9d, r10d, eax, ecx, r8d,  2)
	ROUND0a(r8d, r9d, r10d, eax, ecx,  3)
	ROUND0a(ecx, r8d, r9d, r10d, eax,  4)
	ROUND0a(eax, ecx, r8d, r9d, r10d,  5)
	ROUND0a(r10d, eax, ecx, r8d, r9d,  6)
	ROUND0a(r9d, r10d, eax, ecx, r8d,  7)
	ROUND0a(r8d, r9d, r10d, eax, ecx,  8)
	ROUND0a(ecx, r8d, r9d, r10d, eax,  9)
	ROUND0a(eax, ecx, r8d, r9d, r10d, 10)
	ROUND0a(r10d, eax, ecx, r8d, r9d, 11)
	ROUND0a(r9d, r10d, eax, ecx, r8d, 12)
	ROUND0a(r8d, r9d, r10d, eax, ecx, 13)
	ROUND0a(ecx, r8d, r9d, r10d, eax, 14)
	ROUND0a(eax, ecx, r8d, r9d, r10d, 15)
	ROUND0b(r10d, eax, ecx, r8d, r9d, 16)
	ROUND0b(r9d, r10d, eax, ecx, r8d, 17)
	ROUND0b(r8d, r9d, r10d, eax, ecx, 18)
	ROUND0b(ecx, r8d, r9d, r10d, eax, 19)
	ROUND1( eax, ecx, r8d, r9d, r10d, 20)
	ROUND1( r10d, eax, ecx, r8d, r9d, 21)
	ROUND1( r9d, r10d, eax, ecx, r8d, 22)
	ROUND1( r8d, r9d, r10d, eax, ecx, 23)
	ROUND1( ecx, r8d, r9d, r10d, eax, 24)
	ROUND1( eax, ecx, r8d, r9d, r10d, 25)
	ROUND1( r10d, eax, ecx, r8d, r9d, 26)
	ROUND1( r9d, r10d, eax, ecx, r8d, 27)
	ROUND1( r8d, r9d, r10d, eax, ecx, 28)
	ROUND1( ecx, r8d, r9d, r10d, eax, 29)
	ROUND1( eax, ecx, r8d, r9d, r10d, 30)
	ROUND1( r10d, eax, ecx, r8d, r9d, 31)
	ROUND1( r9d, r10d, eax, ecx, r8d, 32)
	ROUND1( r8d, r9d, r10d, eax, ecx, 33)
	ROUND1( ecx, r8d, r9d, r10d, eax, 34)
	ROUND1( eax, ecx, r8d, r9d, r10d, 35)
	ROUND1( r10d, eax, ecx, r8d, r9d, 36)
	ROUND1( r9d, r10d, eax, ecx, r8d, 37)
	ROUND1( r8d, r9d, r10d, eax, ecx, 38)
	ROUND1( ecx, r8d, r9d, r10d, eax, 39)
	ROUND2( eax, ecx, r8d, r9d, r10d, 40)
	ROUND2( r10d, eax, ecx, r8d, r9d, 41)
	ROUND2( r9d, r10d, eax, ecx, r8d, 42)
	ROUND2( r8d, r9d, r10d, eax, ecx, 43)
	ROUND2( ecx, r8d, r9d, r10d, eax, 44)
	ROUND2( eax, ecx, r8d, r9d, r10d, 45)
	ROUND2( r10d, eax, ecx, r8d, r9d, 46)
	ROUND2( r9d, r10d, eax, ecx, r8d, 47)
	ROUND2( r8d, r9d, r10d, eax, ecx, 48)
	ROUND2( ecx, r8d, r9d, r10d, eax, 49)
	ROUND2( eax, ecx, r8d, r9d, r10d, 50)
	ROUND2( r10d, eax, ecx, r8d, r9d, 51)
	ROUND2( r9d, r10d, eax, ecx, r8d, 52)
	ROUND2( r8d, r9d, r10d, eax, ecx, 53)
	ROUND2( ecx, r8d, r9d, r10d, eax, 54)
	ROUND2( eax, ecx, r8d, r9d, r10d, 55)
	ROUND2( r10d, eax, ecx, r8d, r9d, 56)
	ROUND2( r9d, r10d, eax, ecx, r8d, 57)
	ROUND2( r8d, r9d, r10d, eax, ecx, 58)
	ROUND2( ecx, r8d, r9d, r10d, eax, 59)
	ROUND3( eax, ecx, r8d, r9d, r10d, 60)
	ROUND3( r10d, eax, ecx, r8d, r9d, 61)
	ROUND3( r9d, r10d, eax, ecx, r8d, 62)
	ROUND3( r8d, r9d, r10d, eax, ecx, 63)
	ROUND3( ecx, r8d, r9d, r10d, eax, 64)
	ROUND3( eax, ecx, r8d, r9d, r10d, 65)
	ROUND3( r10d, eax, ecx, r8d, r9d, 66)
	ROUND3( r9d, r10d, eax, ecx, r8d, 67)
	ROUND3( r8d, r9d, r10d, eax, ecx, 68)
	ROUND3( ecx, r8d, r9d, r10d, eax, 69)
	ROUND3( eax, ecx, r8d, r9d, r10d, 70)
	ROUND3( r10d, eax, ecx, r8d, r9d, 71)
	ROUND3( r9d, r10d, eax, ecx, r8d, 72)
	ROUND3( r8d, r9d, r10d, eax, ecx, 73)
	ROUND3( ecx, r8d, r9d, r10d, eax, 74)
	ROUND3( eax, ecx, r8d, r9d, r10d, 75)
	ROUND3( r10d, eax, ecx, r8d, r9d, 76)
	ROUND3( r9d, r10d, eax, ecx, r8d, 77)
	ROUND3( r8d, r9d, r10d, eax, ecx, 78)
	ROUND3( ecx, r8d, r9d, r10d, eax, 79)

	/* Save updated state */
	addl    %eax ,  0(%rdi)
	addl    %ecx ,  4(%rdi)
	addl    %r8d ,  8(%rdi)
	addl    %r9d , 12(%rdi)
	addl    %r10d, 16(%rdi)

ny64_next:
	/* maybe process another block */
	dec   %rdx
	jz    ny64_ret
	addq  $64, %rsi
	jmp   ny64_process

ny64_ret:
	/* Restore registers */
	addq  $64, %rsp
	popq  %rbx
	retq
ENDPROC(sha1_nayuki64_xform)
#endif
