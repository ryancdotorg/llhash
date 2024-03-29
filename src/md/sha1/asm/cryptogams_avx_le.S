/* SPDX-License-Identifier: Apache-2.0 OR (BSD-3-Clause OR GPL-1.0-or-later) */
#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha1_cryptogams_avx_xform_le)
#else
/* Copyright 2006-2020 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 *
 * ====================================================================
 * Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 * project. The module is, however, dual licensed under OpenSSL and
 * CRYPTOGAMS licenses depending on where you obtain it. For further
 * details see http://www.openssl.org/~appro/cryptogams/.
 */

.text

.align	64
.type	K_XX_XX,@object
K_XX_XX:
.long	0x5a827999,0x5a827999,0x5a827999,0x5a827999
.long	0x5a827999,0x5a827999,0x5a827999,0x5a827999
.long	0x6ed9eba1,0x6ed9eba1,0x6ed9eba1,0x6ed9eba1
.long	0x6ed9eba1,0x6ed9eba1,0x6ed9eba1,0x6ed9eba1
.long	0x8f1bbcdc,0x8f1bbcdc,0x8f1bbcdc,0x8f1bbcdc
.long	0x8f1bbcdc,0x8f1bbcdc,0x8f1bbcdc,0x8f1bbcdc
.long	0xca62c1d6,0xca62c1d6,0xca62c1d6,0xca62c1d6
.long	0xca62c1d6,0xca62c1d6,0xca62c1d6,0xca62c1d6
.long	0x00010203,0x04050607,0x08090a0b,0x0c0d0e0f
.long	0x00010203,0x04050607,0x08090a0b,0x0c0d0e0f
.byte	0xf,0xe,0xd,0xc,0xb,0xa,0x9,0x8,0x7,0x6,0x5,0x4,0x3,0x2,0x1,0x0
.byte	83,72,65,49,32,98,108,111,99,107,32,116,114,97,110,115,102,111,114,109,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0


ENTRY(sha1_cryptogams_avx_xform_le)
.cfi_startproc
	movq	%rsp,%r11
.cfi_def_cfa_register	%r11
	pushq	%rbx
.cfi_offset	%rbx,-16
	pushq	%rbp
.cfi_offset	%rbp,-24
	pushq	%r12
.cfi_offset	%r12,-32
	pushq	%r13
.cfi_offset	%r13,-40
	pushq	%r14
.cfi_offset	%r14,-48
	leaq	-64(%rsp),%rsp
	vzeroupper
	andq	$-64,%rsp
	movq	%rdi,%r8
	movq	%rsi,%r9
	movq	%rdx,%r10

	shlq	$6,%r10
	addq	%r9,%r10
	leaq	K_XX_XX+64(%rip),%r14

	movl	0(%r8),%eax
	movl	4(%r8),%ebx
	movl	8(%r8),%ecx
	movl	12(%r8),%edx
	movl	%ebx,%esi
	movl	16(%r8),%ebp
	movl	%ecx,%edi
	xorl	%edx,%edi
	andl	%edi,%esi

	vmovdqa	-64(%r14),%xmm11
	vmovdqu	0(%r9),%xmm0
	vmovdqu	16(%r9),%xmm1
	vmovdqu	32(%r9),%xmm2
	vmovdqu	48(%r9),%xmm3
	addq	$64,%r9
	vpaddd	%xmm11,%xmm0,%xmm4
	vpaddd	%xmm11,%xmm1,%xmm5
	vpaddd	%xmm11,%xmm2,%xmm6
	vmovdqa	%xmm4,0(%rsp)
	vmovdqa	%xmm5,16(%rsp)
	vmovdqa	%xmm6,32(%rsp)
	jmp	.Loop_avx
.align	16
.Loop_avx:
	shrdl	$2,%ebx,%ebx
	xorl	%edx,%esi
	vpalignr	$8,%xmm0,%xmm1,%xmm4
	movl	%eax,%edi
	addl	0(%rsp),%ebp
	vpaddd	%xmm3,%xmm11,%xmm9
	xorl	%ecx,%ebx
	shldl	$5,%eax,%eax
	vpsrldq	$4,%xmm3,%xmm8
	addl	%esi,%ebp
	andl	%ebx,%edi
	vpxor	%xmm0,%xmm4,%xmm4
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	vpxor	%xmm2,%xmm8,%xmm8
	shrdl	$7,%eax,%eax
	xorl	%ecx,%edi
	movl	%ebp,%esi
	addl	4(%rsp),%edx
	vpxor	%xmm8,%xmm4,%xmm4
	xorl	%ebx,%eax
	shldl	$5,%ebp,%ebp
	vmovdqa	%xmm9,48(%rsp)
	addl	%edi,%edx
	andl	%eax,%esi
	vpsrld	$31,%xmm4,%xmm8
	xorl	%ebx,%eax
	addl	%ebp,%edx
	shrdl	$7,%ebp,%ebp
	xorl	%ebx,%esi
	vpslldq	$12,%xmm4,%xmm10
	vpaddd	%xmm4,%xmm4,%xmm4
	movl	%edx,%edi
	addl	8(%rsp),%ecx
	xorl	%eax,%ebp
	shldl	$5,%edx,%edx
	vpsrld	$30,%xmm10,%xmm9
	vpor	%xmm8,%xmm4,%xmm4
	addl	%esi,%ecx
	andl	%ebp,%edi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	vpslld	$2,%xmm10,%xmm10
	vpxor	%xmm9,%xmm4,%xmm4
	shrdl	$7,%edx,%edx
	xorl	%eax,%edi
	movl	%ecx,%esi
	addl	12(%rsp),%ebx
	vpxor	%xmm10,%xmm4,%xmm4
	xorl	%ebp,%edx
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	andl	%edx,%esi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	shrdl	$7,%ecx,%ecx
	xorl	%ebp,%esi
	vpalignr	$8,%xmm1,%xmm2,%xmm5
	movl	%ebx,%edi
	addl	16(%rsp),%eax
	vpaddd	%xmm4,%xmm11,%xmm9
	xorl	%edx,%ecx
	shldl	$5,%ebx,%ebx
	vpsrldq	$4,%xmm4,%xmm8
	addl	%esi,%eax
	andl	%ecx,%edi
	vpxor	%xmm1,%xmm5,%xmm5
	xorl	%edx,%ecx
	addl	%ebx,%eax
	vpxor	%xmm3,%xmm8,%xmm8
	shrdl	$7,%ebx,%ebx
	xorl	%edx,%edi
	movl	%eax,%esi
	addl	20(%rsp),%ebp
	vpxor	%xmm8,%xmm5,%xmm5
	xorl	%ecx,%ebx
	shldl	$5,%eax,%eax
	vmovdqa	%xmm9,0(%rsp)
	addl	%edi,%ebp
	andl	%ebx,%esi
	vpsrld	$31,%xmm5,%xmm8
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	shrdl	$7,%eax,%eax
	xorl	%ecx,%esi
	vpslldq	$12,%xmm5,%xmm10
	vpaddd	%xmm5,%xmm5,%xmm5
	movl	%ebp,%edi
	addl	24(%rsp),%edx
	xorl	%ebx,%eax
	shldl	$5,%ebp,%ebp
	vpsrld	$30,%xmm10,%xmm9
	vpor	%xmm8,%xmm5,%xmm5
	addl	%esi,%edx
	andl	%eax,%edi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	vpslld	$2,%xmm10,%xmm10
	vpxor	%xmm9,%xmm5,%xmm5
	shrdl	$7,%ebp,%ebp
	xorl	%ebx,%edi
	movl	%edx,%esi
	addl	28(%rsp),%ecx
	vpxor	%xmm10,%xmm5,%xmm5
	xorl	%eax,%ebp
	shldl	$5,%edx,%edx
	vmovdqa	-32(%r14),%xmm11
	addl	%edi,%ecx
	andl	%ebp,%esi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	shrdl	$7,%edx,%edx
	xorl	%eax,%esi
	vpalignr	$8,%xmm2,%xmm3,%xmm6
	movl	%ecx,%edi
	addl	32(%rsp),%ebx
	vpaddd	%xmm5,%xmm11,%xmm9
	xorl	%ebp,%edx
	shldl	$5,%ecx,%ecx
	vpsrldq	$4,%xmm5,%xmm8
	addl	%esi,%ebx
	andl	%edx,%edi
	vpxor	%xmm2,%xmm6,%xmm6
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	vpxor	%xmm4,%xmm8,%xmm8
	shrdl	$7,%ecx,%ecx
	xorl	%ebp,%edi
	movl	%ebx,%esi
	addl	36(%rsp),%eax
	vpxor	%xmm8,%xmm6,%xmm6
	xorl	%edx,%ecx
	shldl	$5,%ebx,%ebx
	vmovdqa	%xmm9,16(%rsp)
	addl	%edi,%eax
	andl	%ecx,%esi
	vpsrld	$31,%xmm6,%xmm8
	xorl	%edx,%ecx
	addl	%ebx,%eax
	shrdl	$7,%ebx,%ebx
	xorl	%edx,%esi
	vpslldq	$12,%xmm6,%xmm10
	vpaddd	%xmm6,%xmm6,%xmm6
	movl	%eax,%edi
	addl	40(%rsp),%ebp
	xorl	%ecx,%ebx
	shldl	$5,%eax,%eax
	vpsrld	$30,%xmm10,%xmm9
	vpor	%xmm8,%xmm6,%xmm6
	addl	%esi,%ebp
	andl	%ebx,%edi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	vpslld	$2,%xmm10,%xmm10
	vpxor	%xmm9,%xmm6,%xmm6
	shrdl	$7,%eax,%eax
	xorl	%ecx,%edi
	movl	%ebp,%esi
	addl	44(%rsp),%edx
	vpxor	%xmm10,%xmm6,%xmm6
	xorl	%ebx,%eax
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	andl	%eax,%esi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	shrdl	$7,%ebp,%ebp
	xorl	%ebx,%esi
	vpalignr	$8,%xmm3,%xmm4,%xmm7
	movl	%edx,%edi
	addl	48(%rsp),%ecx
	vpaddd	%xmm6,%xmm11,%xmm9
	xorl	%eax,%ebp
	shldl	$5,%edx,%edx
	vpsrldq	$4,%xmm6,%xmm8
	addl	%esi,%ecx
	andl	%ebp,%edi
	vpxor	%xmm3,%xmm7,%xmm7
	xorl	%eax,%ebp
	addl	%edx,%ecx
	vpxor	%xmm5,%xmm8,%xmm8
	shrdl	$7,%edx,%edx
	xorl	%eax,%edi
	movl	%ecx,%esi
	addl	52(%rsp),%ebx
	vpxor	%xmm8,%xmm7,%xmm7
	xorl	%ebp,%edx
	shldl	$5,%ecx,%ecx
	vmovdqa	%xmm9,32(%rsp)
	addl	%edi,%ebx
	andl	%edx,%esi
	vpsrld	$31,%xmm7,%xmm8
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	shrdl	$7,%ecx,%ecx
	xorl	%ebp,%esi
	vpslldq	$12,%xmm7,%xmm10
	vpaddd	%xmm7,%xmm7,%xmm7
	movl	%ebx,%edi
	addl	56(%rsp),%eax
	xorl	%edx,%ecx
	shldl	$5,%ebx,%ebx
	vpsrld	$30,%xmm10,%xmm9
	vpor	%xmm8,%xmm7,%xmm7
	addl	%esi,%eax
	andl	%ecx,%edi
	xorl	%edx,%ecx
	addl	%ebx,%eax
	vpslld	$2,%xmm10,%xmm10
	vpxor	%xmm9,%xmm7,%xmm7
	shrdl	$7,%ebx,%ebx
	xorl	%edx,%edi
	movl	%eax,%esi
	addl	60(%rsp),%ebp
	vpxor	%xmm10,%xmm7,%xmm7
	xorl	%ecx,%ebx
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	andl	%ebx,%esi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	vpalignr	$8,%xmm6,%xmm7,%xmm8
	vpxor	%xmm4,%xmm0,%xmm0
	shrdl	$7,%eax,%eax
	xorl	%ecx,%esi
	movl	%ebp,%edi
	addl	0(%rsp),%edx
	vpxor	%xmm1,%xmm0,%xmm0
	xorl	%ebx,%eax
	shldl	$5,%ebp,%ebp
	vpaddd	%xmm7,%xmm11,%xmm9
	addl	%esi,%edx
	andl	%eax,%edi
	vpxor	%xmm8,%xmm0,%xmm0
	xorl	%ebx,%eax
	addl	%ebp,%edx
	shrdl	$7,%ebp,%ebp
	xorl	%ebx,%edi
	vpsrld	$30,%xmm0,%xmm8
	vmovdqa	%xmm9,48(%rsp)
	movl	%edx,%esi
	addl	4(%rsp),%ecx
	xorl	%eax,%ebp
	shldl	$5,%edx,%edx
	vpslld	$2,%xmm0,%xmm0
	addl	%edi,%ecx
	andl	%ebp,%esi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	shrdl	$7,%edx,%edx
	xorl	%eax,%esi
	movl	%ecx,%edi
	addl	8(%rsp),%ebx
	vpor	%xmm8,%xmm0,%xmm0
	xorl	%ebp,%edx
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	andl	%edx,%edi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	addl	12(%rsp),%eax
	xorl	%ebp,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%edx,%esi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	vpalignr	$8,%xmm7,%xmm0,%xmm8
	vpxor	%xmm5,%xmm1,%xmm1
	addl	16(%rsp),%ebp
	xorl	%ecx,%esi
	movl	%eax,%edi
	shldl	$5,%eax,%eax
	vpxor	%xmm2,%xmm1,%xmm1
	addl	%esi,%ebp
	xorl	%ecx,%edi
	vpaddd	%xmm0,%xmm11,%xmm9
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	vpxor	%xmm8,%xmm1,%xmm1
	addl	20(%rsp),%edx
	xorl	%ebx,%edi
	movl	%ebp,%esi
	shldl	$5,%ebp,%ebp
	vpsrld	$30,%xmm1,%xmm8
	vmovdqa	%xmm9,0(%rsp)
	addl	%edi,%edx
	xorl	%ebx,%esi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vpslld	$2,%xmm1,%xmm1
	addl	24(%rsp),%ecx
	xorl	%eax,%esi
	movl	%edx,%edi
	shldl	$5,%edx,%edx
	addl	%esi,%ecx
	xorl	%eax,%edi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vpor	%xmm8,%xmm1,%xmm1
	addl	28(%rsp),%ebx
	xorl	%ebp,%edi
	movl	%ecx,%esi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%ebp,%esi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	vpalignr	$8,%xmm0,%xmm1,%xmm8
	vpxor	%xmm6,%xmm2,%xmm2
	addl	32(%rsp),%eax
	xorl	%edx,%esi
	movl	%ebx,%edi
	shldl	$5,%ebx,%ebx
	vpxor	%xmm3,%xmm2,%xmm2
	addl	%esi,%eax
	xorl	%edx,%edi
	vpaddd	%xmm1,%xmm11,%xmm9
	vmovdqa	0(%r14),%xmm11
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	vpxor	%xmm8,%xmm2,%xmm2
	addl	36(%rsp),%ebp
	xorl	%ecx,%edi
	movl	%eax,%esi
	shldl	$5,%eax,%eax
	vpsrld	$30,%xmm2,%xmm8
	vmovdqa	%xmm9,16(%rsp)
	addl	%edi,%ebp
	xorl	%ecx,%esi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	vpslld	$2,%xmm2,%xmm2
	addl	40(%rsp),%edx
	xorl	%ebx,%esi
	movl	%ebp,%edi
	shldl	$5,%ebp,%ebp
	addl	%esi,%edx
	xorl	%ebx,%edi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vpor	%xmm8,%xmm2,%xmm2
	addl	44(%rsp),%ecx
	xorl	%eax,%edi
	movl	%edx,%esi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%eax,%esi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vpalignr	$8,%xmm1,%xmm2,%xmm8
	vpxor	%xmm7,%xmm3,%xmm3
	addl	48(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	vpxor	%xmm4,%xmm3,%xmm3
	addl	%esi,%ebx
	xorl	%ebp,%edi
	vpaddd	%xmm2,%xmm11,%xmm9
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	vpxor	%xmm8,%xmm3,%xmm3
	addl	52(%rsp),%eax
	xorl	%edx,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	vpsrld	$30,%xmm3,%xmm8
	vmovdqa	%xmm9,32(%rsp)
	addl	%edi,%eax
	xorl	%edx,%esi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	vpslld	$2,%xmm3,%xmm3
	addl	56(%rsp),%ebp
	xorl	%ecx,%esi
	movl	%eax,%edi
	shldl	$5,%eax,%eax
	addl	%esi,%ebp
	xorl	%ecx,%edi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	vpor	%xmm8,%xmm3,%xmm3
	addl	60(%rsp),%edx
	xorl	%ebx,%edi
	movl	%ebp,%esi
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	xorl	%ebx,%esi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vpalignr	$8,%xmm2,%xmm3,%xmm8
	vpxor	%xmm0,%xmm4,%xmm4
	addl	0(%rsp),%ecx
	xorl	%eax,%esi
	movl	%edx,%edi
	shldl	$5,%edx,%edx
	vpxor	%xmm5,%xmm4,%xmm4
	addl	%esi,%ecx
	xorl	%eax,%edi
	vpaddd	%xmm3,%xmm11,%xmm9
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vpxor	%xmm8,%xmm4,%xmm4
	addl	4(%rsp),%ebx
	xorl	%ebp,%edi
	movl	%ecx,%esi
	shldl	$5,%ecx,%ecx
	vpsrld	$30,%xmm4,%xmm8
	vmovdqa	%xmm9,48(%rsp)
	addl	%edi,%ebx
	xorl	%ebp,%esi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	vpslld	$2,%xmm4,%xmm4
	addl	8(%rsp),%eax
	xorl	%edx,%esi
	movl	%ebx,%edi
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	xorl	%edx,%edi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	vpor	%xmm8,%xmm4,%xmm4
	addl	12(%rsp),%ebp
	xorl	%ecx,%edi
	movl	%eax,%esi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ecx,%esi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	vpalignr	$8,%xmm3,%xmm4,%xmm8
	vpxor	%xmm1,%xmm5,%xmm5
	addl	16(%rsp),%edx
	xorl	%ebx,%esi
	movl	%ebp,%edi
	shldl	$5,%ebp,%ebp
	vpxor	%xmm6,%xmm5,%xmm5
	addl	%esi,%edx
	xorl	%ebx,%edi
	vpaddd	%xmm4,%xmm11,%xmm9
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vpxor	%xmm8,%xmm5,%xmm5
	addl	20(%rsp),%ecx
	xorl	%eax,%edi
	movl	%edx,%esi
	shldl	$5,%edx,%edx
	vpsrld	$30,%xmm5,%xmm8
	vmovdqa	%xmm9,0(%rsp)
	addl	%edi,%ecx
	xorl	%eax,%esi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vpslld	$2,%xmm5,%xmm5
	addl	24(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	xorl	%ebp,%edi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	vpor	%xmm8,%xmm5,%xmm5
	addl	28(%rsp),%eax
	shrdl	$7,%ecx,%ecx
	movl	%ebx,%esi
	xorl	%edx,%edi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%ecx,%esi
	xorl	%edx,%ecx
	addl	%ebx,%eax
	vpalignr	$8,%xmm4,%xmm5,%xmm8
	vpxor	%xmm2,%xmm6,%xmm6
	addl	32(%rsp),%ebp
	andl	%ecx,%esi
	xorl	%edx,%ecx
	shrdl	$7,%ebx,%ebx
	vpxor	%xmm7,%xmm6,%xmm6
	movl	%eax,%edi
	xorl	%ecx,%esi
	vpaddd	%xmm5,%xmm11,%xmm9
	shldl	$5,%eax,%eax
	addl	%esi,%ebp
	vpxor	%xmm8,%xmm6,%xmm6
	xorl	%ebx,%edi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	addl	36(%rsp),%edx
	vpsrld	$30,%xmm6,%xmm8
	vmovdqa	%xmm9,16(%rsp)
	andl	%ebx,%edi
	xorl	%ecx,%ebx
	shrdl	$7,%eax,%eax
	movl	%ebp,%esi
	vpslld	$2,%xmm6,%xmm6
	xorl	%ebx,%edi
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	xorl	%eax,%esi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	addl	40(%rsp),%ecx
	andl	%eax,%esi
	vpor	%xmm8,%xmm6,%xmm6
	xorl	%ebx,%eax
	shrdl	$7,%ebp,%ebp
	movl	%edx,%edi
	xorl	%eax,%esi
	shldl	$5,%edx,%edx
	addl	%esi,%ecx
	xorl	%ebp,%edi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	addl	44(%rsp),%ebx
	andl	%ebp,%edi
	xorl	%eax,%ebp
	shrdl	$7,%edx,%edx
	movl	%ecx,%esi
	xorl	%ebp,%edi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%edx,%esi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	vpalignr	$8,%xmm5,%xmm6,%xmm8
	vpxor	%xmm3,%xmm7,%xmm7
	addl	48(%rsp),%eax
	andl	%edx,%esi
	xorl	%ebp,%edx
	shrdl	$7,%ecx,%ecx
	vpxor	%xmm0,%xmm7,%xmm7
	movl	%ebx,%edi
	xorl	%edx,%esi
	vpaddd	%xmm6,%xmm11,%xmm9
	vmovdqa	32(%r14),%xmm11
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	vpxor	%xmm8,%xmm7,%xmm7
	xorl	%ecx,%edi
	xorl	%edx,%ecx
	addl	%ebx,%eax
	addl	52(%rsp),%ebp
	vpsrld	$30,%xmm7,%xmm8
	vmovdqa	%xmm9,32(%rsp)
	andl	%ecx,%edi
	xorl	%edx,%ecx
	shrdl	$7,%ebx,%ebx
	movl	%eax,%esi
	vpslld	$2,%xmm7,%xmm7
	xorl	%ecx,%edi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ebx,%esi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	addl	56(%rsp),%edx
	andl	%ebx,%esi
	vpor	%xmm8,%xmm7,%xmm7
	xorl	%ecx,%ebx
	shrdl	$7,%eax,%eax
	movl	%ebp,%edi
	xorl	%ebx,%esi
	shldl	$5,%ebp,%ebp
	addl	%esi,%edx
	xorl	%eax,%edi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	addl	60(%rsp),%ecx
	andl	%eax,%edi
	xorl	%ebx,%eax
	shrdl	$7,%ebp,%ebp
	movl	%edx,%esi
	xorl	%eax,%edi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%ebp,%esi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	vpalignr	$8,%xmm6,%xmm7,%xmm8
	vpxor	%xmm4,%xmm0,%xmm0
	addl	0(%rsp),%ebx
	andl	%ebp,%esi
	xorl	%eax,%ebp
	shrdl	$7,%edx,%edx
	vpxor	%xmm1,%xmm0,%xmm0
	movl	%ecx,%edi
	xorl	%ebp,%esi
	vpaddd	%xmm7,%xmm11,%xmm9
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	vpxor	%xmm8,%xmm0,%xmm0
	xorl	%edx,%edi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	addl	4(%rsp),%eax
	vpsrld	$30,%xmm0,%xmm8
	vmovdqa	%xmm9,48(%rsp)
	andl	%edx,%edi
	xorl	%ebp,%edx
	shrdl	$7,%ecx,%ecx
	movl	%ebx,%esi
	vpslld	$2,%xmm0,%xmm0
	xorl	%edx,%edi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%ecx,%esi
	xorl	%edx,%ecx
	addl	%ebx,%eax
	addl	8(%rsp),%ebp
	andl	%ecx,%esi
	vpor	%xmm8,%xmm0,%xmm0
	xorl	%edx,%ecx
	shrdl	$7,%ebx,%ebx
	movl	%eax,%edi
	xorl	%ecx,%esi
	shldl	$5,%eax,%eax
	addl	%esi,%ebp
	xorl	%ebx,%edi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	addl	12(%rsp),%edx
	andl	%ebx,%edi
	xorl	%ecx,%ebx
	shrdl	$7,%eax,%eax
	movl	%ebp,%esi
	xorl	%ebx,%edi
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	xorl	%eax,%esi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	vpalignr	$8,%xmm7,%xmm0,%xmm8
	vpxor	%xmm5,%xmm1,%xmm1
	addl	16(%rsp),%ecx
	andl	%eax,%esi
	xorl	%ebx,%eax
	shrdl	$7,%ebp,%ebp
	vpxor	%xmm2,%xmm1,%xmm1
	movl	%edx,%edi
	xorl	%eax,%esi
	vpaddd	%xmm0,%xmm11,%xmm9
	shldl	$5,%edx,%edx
	addl	%esi,%ecx
	vpxor	%xmm8,%xmm1,%xmm1
	xorl	%ebp,%edi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	addl	20(%rsp),%ebx
	vpsrld	$30,%xmm1,%xmm8
	vmovdqa	%xmm9,0(%rsp)
	andl	%ebp,%edi
	xorl	%eax,%ebp
	shrdl	$7,%edx,%edx
	movl	%ecx,%esi
	vpslld	$2,%xmm1,%xmm1
	xorl	%ebp,%edi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%edx,%esi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	addl	24(%rsp),%eax
	andl	%edx,%esi
	vpor	%xmm8,%xmm1,%xmm1
	xorl	%ebp,%edx
	shrdl	$7,%ecx,%ecx
	movl	%ebx,%edi
	xorl	%edx,%esi
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	xorl	%ecx,%edi
	xorl	%edx,%ecx
	addl	%ebx,%eax
	addl	28(%rsp),%ebp
	andl	%ecx,%edi
	xorl	%edx,%ecx
	shrdl	$7,%ebx,%ebx
	movl	%eax,%esi
	xorl	%ecx,%edi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ebx,%esi
	xorl	%ecx,%ebx
	addl	%eax,%ebp
	vpalignr	$8,%xmm0,%xmm1,%xmm8
	vpxor	%xmm6,%xmm2,%xmm2
	addl	32(%rsp),%edx
	andl	%ebx,%esi
	xorl	%ecx,%ebx
	shrdl	$7,%eax,%eax
	vpxor	%xmm3,%xmm2,%xmm2
	movl	%ebp,%edi
	xorl	%ebx,%esi
	vpaddd	%xmm1,%xmm11,%xmm9
	shldl	$5,%ebp,%ebp
	addl	%esi,%edx
	vpxor	%xmm8,%xmm2,%xmm2
	xorl	%eax,%edi
	xorl	%ebx,%eax
	addl	%ebp,%edx
	addl	36(%rsp),%ecx
	vpsrld	$30,%xmm2,%xmm8
	vmovdqa	%xmm9,16(%rsp)
	andl	%eax,%edi
	xorl	%ebx,%eax
	shrdl	$7,%ebp,%ebp
	movl	%edx,%esi
	vpslld	$2,%xmm2,%xmm2
	xorl	%eax,%edi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%ebp,%esi
	xorl	%eax,%ebp
	addl	%edx,%ecx
	addl	40(%rsp),%ebx
	andl	%ebp,%esi
	vpor	%xmm8,%xmm2,%xmm2
	xorl	%eax,%ebp
	shrdl	$7,%edx,%edx
	movl	%ecx,%edi
	xorl	%ebp,%esi
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	xorl	%edx,%edi
	xorl	%ebp,%edx
	addl	%ecx,%ebx
	addl	44(%rsp),%eax
	andl	%edx,%edi
	xorl	%ebp,%edx
	shrdl	$7,%ecx,%ecx
	movl	%ebx,%esi
	xorl	%edx,%edi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%edx,%esi
	addl	%ebx,%eax
	vpalignr	$8,%xmm1,%xmm2,%xmm8
	vpxor	%xmm7,%xmm3,%xmm3
	addl	48(%rsp),%ebp
	xorl	%ecx,%esi
	movl	%eax,%edi
	shldl	$5,%eax,%eax
	vpxor	%xmm4,%xmm3,%xmm3
	addl	%esi,%ebp
	xorl	%ecx,%edi
	vpaddd	%xmm2,%xmm11,%xmm9
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	vpxor	%xmm8,%xmm3,%xmm3
	addl	52(%rsp),%edx
	xorl	%ebx,%edi
	movl	%ebp,%esi
	shldl	$5,%ebp,%ebp
	vpsrld	$30,%xmm3,%xmm8
	vmovdqa	%xmm9,32(%rsp)
	addl	%edi,%edx
	xorl	%ebx,%esi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vpslld	$2,%xmm3,%xmm3
	addl	56(%rsp),%ecx
	xorl	%eax,%esi
	movl	%edx,%edi
	shldl	$5,%edx,%edx
	addl	%esi,%ecx
	xorl	%eax,%edi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vpor	%xmm8,%xmm3,%xmm3
	addl	60(%rsp),%ebx
	xorl	%ebp,%edi
	movl	%ecx,%esi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%ebp,%esi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	0(%rsp),%eax
	vpaddd	%xmm3,%xmm11,%xmm9
	xorl	%edx,%esi
	movl	%ebx,%edi
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	vmovdqa	%xmm9,48(%rsp)
	xorl	%edx,%edi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	4(%rsp),%ebp
	xorl	%ecx,%edi
	movl	%eax,%esi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ecx,%esi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	addl	8(%rsp),%edx
	xorl	%ebx,%esi
	movl	%ebp,%edi
	shldl	$5,%ebp,%ebp
	addl	%esi,%edx
	xorl	%ebx,%edi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	addl	12(%rsp),%ecx
	xorl	%eax,%edi
	movl	%edx,%esi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%eax,%esi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	cmpq	%r10,%r9
	je	.Ldone_avx
	vmovdqa	-64(%r14),%xmm11
	vmovdqu	0(%r9),%xmm0
	vmovdqu	16(%r9),%xmm1
	vmovdqu	32(%r9),%xmm2
	vmovdqu	48(%r9),%xmm3
	addq	$64,%r9
	addl	16(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	vpaddd	%xmm11,%xmm0,%xmm4
	addl	%esi,%ebx
	xorl	%ebp,%edi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	vmovdqa	%xmm4,0(%rsp)
	addl	20(%rsp),%eax
	xorl	%edx,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%edx,%esi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	24(%rsp),%ebp
	xorl	%ecx,%esi
	movl	%eax,%edi
	shldl	$5,%eax,%eax
	addl	%esi,%ebp
	xorl	%ecx,%edi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	addl	28(%rsp),%edx
	xorl	%ebx,%edi
	movl	%ebp,%esi
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	xorl	%ebx,%esi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	addl	32(%rsp),%ecx
	xorl	%eax,%esi
	movl	%edx,%edi
	shldl	$5,%edx,%edx
	vpaddd	%xmm11,%xmm1,%xmm5
	addl	%esi,%ecx
	xorl	%eax,%edi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	vmovdqa	%xmm5,16(%rsp)
	addl	36(%rsp),%ebx
	xorl	%ebp,%edi
	movl	%ecx,%esi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%ebp,%esi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	40(%rsp),%eax
	xorl	%edx,%esi
	movl	%ebx,%edi
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	xorl	%edx,%edi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	44(%rsp),%ebp
	xorl	%ecx,%edi
	movl	%eax,%esi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ecx,%esi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	addl	48(%rsp),%edx
	xorl	%ebx,%esi
	movl	%ebp,%edi
	shldl	$5,%ebp,%ebp
	vpaddd	%xmm11,%xmm2,%xmm6
	addl	%esi,%edx
	xorl	%ebx,%edi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	vmovdqa	%xmm6,32(%rsp)
	addl	52(%rsp),%ecx
	xorl	%eax,%edi
	movl	%edx,%esi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%eax,%esi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	addl	56(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	xorl	%ebp,%edi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	60(%rsp),%eax
	xorl	%edx,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	0(%r8),%eax
	addl	4(%r8),%esi
	addl	8(%r8),%ecx
	addl	12(%r8),%edx
	movl	%eax,0(%r8)
	addl	16(%r8),%ebp
	movl	%esi,4(%r8)
	movl	%esi,%ebx
	movl	%ecx,8(%r8)
	movl	%ecx,%edi
	movl	%edx,12(%r8)
	xorl	%edx,%edi
	movl	%ebp,16(%r8)
	andl	%edi,%esi
	jmp	.Loop_avx

.align	16
.Ldone_avx:
	addl	16(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	xorl	%ebp,%edi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	20(%rsp),%eax
	xorl	%edx,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	xorl	%edx,%esi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	24(%rsp),%ebp
	xorl	%ecx,%esi
	movl	%eax,%edi
	shldl	$5,%eax,%eax
	addl	%esi,%ebp
	xorl	%ecx,%edi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	addl	28(%rsp),%edx
	xorl	%ebx,%edi
	movl	%ebp,%esi
	shldl	$5,%ebp,%ebp
	addl	%edi,%edx
	xorl	%ebx,%esi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	addl	32(%rsp),%ecx
	xorl	%eax,%esi
	movl	%edx,%edi
	shldl	$5,%edx,%edx
	addl	%esi,%ecx
	xorl	%eax,%edi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	addl	36(%rsp),%ebx
	xorl	%ebp,%edi
	movl	%ecx,%esi
	shldl	$5,%ecx,%ecx
	addl	%edi,%ebx
	xorl	%ebp,%esi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	40(%rsp),%eax
	xorl	%edx,%esi
	movl	%ebx,%edi
	shldl	$5,%ebx,%ebx
	addl	%esi,%eax
	xorl	%edx,%edi
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	addl	44(%rsp),%ebp
	xorl	%ecx,%edi
	movl	%eax,%esi
	shldl	$5,%eax,%eax
	addl	%edi,%ebp
	xorl	%ecx,%esi
	shrdl	$7,%ebx,%ebx
	addl	%eax,%ebp
	addl	48(%rsp),%edx
	xorl	%ebx,%esi
	movl	%ebp,%edi
	shldl	$5,%ebp,%ebp
	addl	%esi,%edx
	xorl	%ebx,%edi
	shrdl	$7,%eax,%eax
	addl	%ebp,%edx
	addl	52(%rsp),%ecx
	xorl	%eax,%edi
	movl	%edx,%esi
	shldl	$5,%edx,%edx
	addl	%edi,%ecx
	xorl	%eax,%esi
	shrdl	$7,%ebp,%ebp
	addl	%edx,%ecx
	addl	56(%rsp),%ebx
	xorl	%ebp,%esi
	movl	%ecx,%edi
	shldl	$5,%ecx,%ecx
	addl	%esi,%ebx
	xorl	%ebp,%edi
	shrdl	$7,%edx,%edx
	addl	%ecx,%ebx
	addl	60(%rsp),%eax
	xorl	%edx,%edi
	movl	%ebx,%esi
	shldl	$5,%ebx,%ebx
	addl	%edi,%eax
	shrdl	$7,%ecx,%ecx
	addl	%ebx,%eax
	vzeroupper

	addl	0(%r8),%eax
	addl	4(%r8),%esi
	addl	8(%r8),%ecx
	movl	%eax,0(%r8)
	addl	12(%r8),%edx
	movl	%esi,4(%r8)
	addl	16(%r8),%ebp
	movl	%ecx,8(%r8)
	movl	%edx,12(%r8)
	movl	%ebp,16(%r8)
	movq	-40(%r11),%r14
.cfi_restore	%r14
	movq	-32(%r11),%r13
.cfi_restore	%r13
	movq	-24(%r11),%r12
.cfi_restore	%r12
	movq	-16(%r11),%rbp
.cfi_restore	%rbp
	movq	-8(%r11),%rbx
.cfi_restore	%rbx
	leaq	(%r11),%rsp
.cfi_def_cfa_register	%rsp
.Lepilogue_avx:
	repz	retq
.cfi_endproc
ENDPROC(sha1_cryptogams_avx_xform_le)
#endif
