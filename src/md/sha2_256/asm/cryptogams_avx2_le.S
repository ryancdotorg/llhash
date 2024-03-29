/* SPDX-License-Identifier: BSD-3-Clause OR GPL-1.0-or-later */
#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha2_256_cryptogams_avx2_xform_le)
#else
/* Copyright (c) 2006-2017, CRYPTOGAMS by <appro@openssl.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *       * Redistributions of source code must retain copyright notices,
 *         this list of conditions and the following disclaimer.
 *
 *       * Redistributions in binary form must reproduce the above
 *         copyright notice, this list of conditions and the following
 *         disclaimer in the documentation and/or other materials
 *         provided with the distribution.
 *
 *       * Neither the name of the CRYPTOGAMS nor the names of its
 *         copyright holder and contributors may be used to endorse or
 *         promote products derived from this software without specific
 *         prior written permission.
 *
 * ALTERNATIVELY, provided that this notice is retained in full, this
 * product may be distributed under the terms of the GNU General Public
 * License (GPL), in which case the provisions of the GPL apply INSTEAD OF
 * those given above.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

.text

.align	64
.type	K256,@object
K256:
.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
.long	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
.long	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
.long	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
.long	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
.long	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
.long	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
.long	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
.long	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
.long	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
.long	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
.long	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
.long	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
.long	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
.long	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
.long	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
.long	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
.long	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
.long	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
.long	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
.long	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
.long	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
.long	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
.long	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
.long	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
.long	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
.long	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
.long	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
.long	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2

.long	0x00010203,0x04050607,0x08090a0b,0x0c0d0e0f
.long	0x00010203,0x04050607,0x08090a0b,0x0c0d0e0f

.long	0x03020100,0x0b0a0908,0xffffffff,0xffffffff
.long	0x03020100,0x0b0a0908,0xffffffff,0xffffffff

.long	0xffffffff,0xffffffff,0x03020100,0x0b0a0908
.long	0xffffffff,0xffffffff,0x03020100,0x0b0a0908

.byte	83,72,65,50,53,54,32,98,108,111,99,107,32,116,114,97,110,115,102,111,114,109,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0


ENTRY(sha2_256_cryptogams_avx2_xform_le)
.cfi_startproc
	movq	%rsp,%rax
.cfi_def_cfa_register	%rax
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
	pushq	%r15
.cfi_offset	%r15,-56
	subq	$544,%rsp
	shlq	$4,%rdx
	andq	$-1024,%rsp
	leaq	(%rsi,%rdx,4),%rdx
	addq	$448,%rsp
	movq	%rdi,64+0(%rsp)
	movq	%rsi,64+8(%rsp)
	movq	%rdx,64+16(%rsp)
	movq	%rax,88(%rsp)
.cfi_escape	0x0f,0x06,0x77,0xd8,0x00,0x06,0x23,0x08
.Lprologue_avx2:

	vzeroupper
	subq	$-64,%rsi
	movl	0(%rdi),%eax
	movq	%rsi,%r12
	movl	4(%rdi),%ebx
	cmpq	%rdx,%rsi
	movl	8(%rdi),%ecx
	cmoveq	%rsp,%r12
	movl	12(%rdi),%edx
	movl	16(%rdi),%r8d
	movl	20(%rdi),%r9d
	movl	24(%rdi),%r10d
	movl	28(%rdi),%r11d
	vmovdqa	K256+512+32(%rip),%ymm8
	vmovdqa	K256+512+64(%rip),%ymm9
	jmp	.Loop_avx2
.align	16
.Loop_avx2:
	vmovdqu	-64+0(%rsi),%xmm0
	vmovdqu	-64+16(%rsi),%xmm1
	vmovdqu	-64+32(%rsi),%xmm2
	vmovdqu	-64+48(%rsi),%xmm3

	vinserti128	$1,(%r12),%ymm0,%ymm0
	vinserti128	$1,16(%r12),%ymm1,%ymm1
	vinserti128	$1,32(%r12),%ymm2,%ymm2
	vinserti128	$1,48(%r12),%ymm3,%ymm3

	leaq	K256(%rip),%rbp
	vpaddd	0(%rbp),%ymm0,%ymm4
	vpaddd	32(%rbp),%ymm1,%ymm5
	vpaddd	64(%rbp),%ymm2,%ymm6
	vpaddd	96(%rbp),%ymm3,%ymm7
	vmovdqa	%ymm4,0(%rsp)
	xorl	%r14d,%r14d
	vmovdqa	%ymm5,32(%rsp)

	movq	88(%rsp),%rdi
.cfi_def_cfa	%rdi,8
	leaq	-64(%rsp),%rsp



	movq	%rdi,-8(%rsp)
.cfi_escape	0x0f,0x05,0x77,0x78,0x06,0x23,0x08
	movl	%ebx,%edi
	vmovdqa	%ymm6,0(%rsp)
	xorl	%ecx,%edi
	vmovdqa	%ymm7,32(%rsp)
	movl	%r9d,%r12d
	subq	$-32*4,%rbp
	jmp	.Lavx2_00_47

.align	16
.Lavx2_00_47:
	leaq	-64(%rsp),%rsp
.cfi_escape	0x0f,0x05,0x77,0x38,0x06,0x23,0x08

	pushq	64-8(%rsp)
.cfi_escape	0x0f,0x05,0x77,0x00,0x06,0x23,0x08
	leaq	8(%rsp),%rsp
.cfi_escape	0x0f,0x05,0x77,0x78,0x06,0x23,0x08
	vpalignr	$4,%ymm0,%ymm1,%ymm4
	addl	0+128(%rsp),%r11d
	andl	%r8d,%r12d
	rorxl	$25,%r8d,%r13d
	vpalignr	$4,%ymm2,%ymm3,%ymm7
	rorxl	$11,%r8d,%r15d
	leal	(%rax,%r14,1),%eax
	leal	(%r11,%r12,1),%r11d
	vpsrld	$7,%ymm4,%ymm6
	andnl	%r10d,%r8d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r8d,%r14d
	vpaddd	%ymm7,%ymm0,%ymm0
	leal	(%r11,%r12,1),%r11d
	xorl	%r14d,%r13d
	movl	%eax,%r15d
	vpsrld	$3,%ymm4,%ymm7
	rorxl	$22,%eax,%r12d
	leal	(%r11,%r13,1),%r11d
	xorl	%ebx,%r15d
	vpslld	$14,%ymm4,%ymm5
	rorxl	$13,%eax,%r14d
	rorxl	$2,%eax,%r13d
	leal	(%rdx,%r11,1),%edx
	vpxor	%ymm6,%ymm7,%ymm4
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%ebx,%edi
	vpshufd	$250,%ymm3,%ymm7
	xorl	%r13d,%r14d
	leal	(%r11,%rdi,1),%r11d
	movl	%r8d,%r12d
	vpsrld	$11,%ymm6,%ymm6
	addl	4+128(%rsp),%r10d
	andl	%edx,%r12d
	rorxl	$25,%edx,%r13d
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$11,%edx,%edi
	leal	(%r11,%r14,1),%r11d
	leal	(%r10,%r12,1),%r10d
	vpslld	$11,%ymm5,%ymm5
	andnl	%r9d,%edx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%edx,%r14d
	vpxor	%ymm6,%ymm4,%ymm4
	leal	(%r10,%r12,1),%r10d
	xorl	%r14d,%r13d
	movl	%r11d,%edi
	vpsrld	$10,%ymm7,%ymm6
	rorxl	$22,%r11d,%r12d
	leal	(%r10,%r13,1),%r10d
	xorl	%eax,%edi
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$13,%r11d,%r14d
	rorxl	$2,%r11d,%r13d
	leal	(%rcx,%r10,1),%ecx
	vpsrlq	$17,%ymm7,%ymm7
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%eax,%r15d
	vpaddd	%ymm4,%ymm0,%ymm0
	xorl	%r13d,%r14d
	leal	(%r10,%r15,1),%r10d
	movl	%edx,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	8+128(%rsp),%r9d
	andl	%ecx,%r12d
	rorxl	$25,%ecx,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%ecx,%r15d
	leal	(%r10,%r14,1),%r10d
	leal	(%r9,%r12,1),%r9d
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%r8d,%ecx,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%ecx,%r14d
	vpshufb	%ymm8,%ymm6,%ymm6
	leal	(%r9,%r12,1),%r9d
	xorl	%r14d,%r13d
	movl	%r10d,%r15d
	vpaddd	%ymm6,%ymm0,%ymm0
	rorxl	$22,%r10d,%r12d
	leal	(%r9,%r13,1),%r9d
	xorl	%r11d,%r15d
	vpshufd	$80,%ymm0,%ymm7
	rorxl	$13,%r10d,%r14d
	rorxl	$2,%r10d,%r13d
	leal	(%rbx,%r9,1),%ebx
	vpsrld	$10,%ymm7,%ymm6
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r11d,%edi
	vpsrlq	$17,%ymm7,%ymm7
	xorl	%r13d,%r14d
	leal	(%r9,%rdi,1),%r9d
	movl	%ecx,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	12+128(%rsp),%r8d
	andl	%ebx,%r12d
	rorxl	$25,%ebx,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%ebx,%edi
	leal	(%r9,%r14,1),%r9d
	leal	(%r8,%r12,1),%r8d
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%edx,%ebx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%ebx,%r14d
	vpshufb	%ymm9,%ymm6,%ymm6
	leal	(%r8,%r12,1),%r8d
	xorl	%r14d,%r13d
	movl	%r9d,%edi
	vpaddd	%ymm6,%ymm0,%ymm0
	rorxl	$22,%r9d,%r12d
	leal	(%r8,%r13,1),%r8d
	xorl	%r10d,%edi
	vpaddd	0(%rbp),%ymm0,%ymm6
	rorxl	$13,%r9d,%r14d
	rorxl	$2,%r9d,%r13d
	leal	(%rax,%r8,1),%eax
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r10d,%r15d
	xorl	%r13d,%r14d
	leal	(%r8,%r15,1),%r8d
	movl	%ebx,%r12d
	vmovdqa	%ymm6,0(%rsp)
	vpalignr	$4,%ymm1,%ymm2,%ymm4
	addl	32+128(%rsp),%edx
	andl	%eax,%r12d
	rorxl	$25,%eax,%r13d
	vpalignr	$4,%ymm3,%ymm0,%ymm7
	rorxl	$11,%eax,%r15d
	leal	(%r8,%r14,1),%r8d
	leal	(%rdx,%r12,1),%edx
	vpsrld	$7,%ymm4,%ymm6
	andnl	%ecx,%eax,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%eax,%r14d
	vpaddd	%ymm7,%ymm1,%ymm1
	leal	(%rdx,%r12,1),%edx
	xorl	%r14d,%r13d
	movl	%r8d,%r15d
	vpsrld	$3,%ymm4,%ymm7
	rorxl	$22,%r8d,%r12d
	leal	(%rdx,%r13,1),%edx
	xorl	%r9d,%r15d
	vpslld	$14,%ymm4,%ymm5
	rorxl	$13,%r8d,%r14d
	rorxl	$2,%r8d,%r13d
	leal	(%r11,%rdx,1),%r11d
	vpxor	%ymm6,%ymm7,%ymm4
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r9d,%edi
	vpshufd	$250,%ymm0,%ymm7
	xorl	%r13d,%r14d
	leal	(%rdx,%rdi,1),%edx
	movl	%eax,%r12d
	vpsrld	$11,%ymm6,%ymm6
	addl	36+128(%rsp),%ecx
	andl	%r11d,%r12d
	rorxl	$25,%r11d,%r13d
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$11,%r11d,%edi
	leal	(%rdx,%r14,1),%edx
	leal	(%rcx,%r12,1),%ecx
	vpslld	$11,%ymm5,%ymm5
	andnl	%ebx,%r11d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r11d,%r14d
	vpxor	%ymm6,%ymm4,%ymm4
	leal	(%rcx,%r12,1),%ecx
	xorl	%r14d,%r13d
	movl	%edx,%edi
	vpsrld	$10,%ymm7,%ymm6
	rorxl	$22,%edx,%r12d
	leal	(%rcx,%r13,1),%ecx
	xorl	%r8d,%edi
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$13,%edx,%r14d
	rorxl	$2,%edx,%r13d
	leal	(%r10,%rcx,1),%r10d
	vpsrlq	$17,%ymm7,%ymm7
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r8d,%r15d
	vpaddd	%ymm4,%ymm1,%ymm1
	xorl	%r13d,%r14d
	leal	(%rcx,%r15,1),%ecx
	movl	%r11d,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	40+128(%rsp),%ebx
	andl	%r10d,%r12d
	rorxl	$25,%r10d,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%r10d,%r15d
	leal	(%rcx,%r14,1),%ecx
	leal	(%rbx,%r12,1),%ebx
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%eax,%r10d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r10d,%r14d
	vpshufb	%ymm8,%ymm6,%ymm6
	leal	(%rbx,%r12,1),%ebx
	xorl	%r14d,%r13d
	movl	%ecx,%r15d
	vpaddd	%ymm6,%ymm1,%ymm1
	rorxl	$22,%ecx,%r12d
	leal	(%rbx,%r13,1),%ebx
	xorl	%edx,%r15d
	vpshufd	$80,%ymm1,%ymm7
	rorxl	$13,%ecx,%r14d
	rorxl	$2,%ecx,%r13d
	leal	(%r9,%rbx,1),%r9d
	vpsrld	$10,%ymm7,%ymm6
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%edx,%edi
	vpsrlq	$17,%ymm7,%ymm7
	xorl	%r13d,%r14d
	leal	(%rbx,%rdi,1),%ebx
	movl	%r10d,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	44+128(%rsp),%eax
	andl	%r9d,%r12d
	rorxl	$25,%r9d,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%r9d,%edi
	leal	(%rbx,%r14,1),%ebx
	leal	(%rax,%r12,1),%eax
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%r11d,%r9d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r9d,%r14d
	vpshufb	%ymm9,%ymm6,%ymm6
	leal	(%rax,%r12,1),%eax
	xorl	%r14d,%r13d
	movl	%ebx,%edi
	vpaddd	%ymm6,%ymm1,%ymm1
	rorxl	$22,%ebx,%r12d
	leal	(%rax,%r13,1),%eax
	xorl	%ecx,%edi
	vpaddd	32(%rbp),%ymm1,%ymm6
	rorxl	$13,%ebx,%r14d
	rorxl	$2,%ebx,%r13d
	leal	(%r8,%rax,1),%r8d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%ecx,%r15d
	xorl	%r13d,%r14d
	leal	(%rax,%r15,1),%eax
	movl	%r9d,%r12d
	vmovdqa	%ymm6,32(%rsp)
	leaq	-64(%rsp),%rsp
.cfi_escape	0x0f,0x05,0x77,0x38,0x06,0x23,0x08

	pushq	64-8(%rsp)
.cfi_escape	0x0f,0x05,0x77,0x00,0x06,0x23,0x08
	leaq	8(%rsp),%rsp
.cfi_escape	0x0f,0x05,0x77,0x78,0x06,0x23,0x08
	vpalignr	$4,%ymm2,%ymm3,%ymm4
	addl	0+128(%rsp),%r11d
	andl	%r8d,%r12d
	rorxl	$25,%r8d,%r13d
	vpalignr	$4,%ymm0,%ymm1,%ymm7
	rorxl	$11,%r8d,%r15d
	leal	(%rax,%r14,1),%eax
	leal	(%r11,%r12,1),%r11d
	vpsrld	$7,%ymm4,%ymm6
	andnl	%r10d,%r8d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r8d,%r14d
	vpaddd	%ymm7,%ymm2,%ymm2
	leal	(%r11,%r12,1),%r11d
	xorl	%r14d,%r13d
	movl	%eax,%r15d
	vpsrld	$3,%ymm4,%ymm7
	rorxl	$22,%eax,%r12d
	leal	(%r11,%r13,1),%r11d
	xorl	%ebx,%r15d
	vpslld	$14,%ymm4,%ymm5
	rorxl	$13,%eax,%r14d
	rorxl	$2,%eax,%r13d
	leal	(%rdx,%r11,1),%edx
	vpxor	%ymm6,%ymm7,%ymm4
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%ebx,%edi
	vpshufd	$250,%ymm1,%ymm7
	xorl	%r13d,%r14d
	leal	(%r11,%rdi,1),%r11d
	movl	%r8d,%r12d
	vpsrld	$11,%ymm6,%ymm6
	addl	4+128(%rsp),%r10d
	andl	%edx,%r12d
	rorxl	$25,%edx,%r13d
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$11,%edx,%edi
	leal	(%r11,%r14,1),%r11d
	leal	(%r10,%r12,1),%r10d
	vpslld	$11,%ymm5,%ymm5
	andnl	%r9d,%edx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%edx,%r14d
	vpxor	%ymm6,%ymm4,%ymm4
	leal	(%r10,%r12,1),%r10d
	xorl	%r14d,%r13d
	movl	%r11d,%edi
	vpsrld	$10,%ymm7,%ymm6
	rorxl	$22,%r11d,%r12d
	leal	(%r10,%r13,1),%r10d
	xorl	%eax,%edi
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$13,%r11d,%r14d
	rorxl	$2,%r11d,%r13d
	leal	(%rcx,%r10,1),%ecx
	vpsrlq	$17,%ymm7,%ymm7
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%eax,%r15d
	vpaddd	%ymm4,%ymm2,%ymm2
	xorl	%r13d,%r14d
	leal	(%r10,%r15,1),%r10d
	movl	%edx,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	8+128(%rsp),%r9d
	andl	%ecx,%r12d
	rorxl	$25,%ecx,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%ecx,%r15d
	leal	(%r10,%r14,1),%r10d
	leal	(%r9,%r12,1),%r9d
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%r8d,%ecx,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%ecx,%r14d
	vpshufb	%ymm8,%ymm6,%ymm6
	leal	(%r9,%r12,1),%r9d
	xorl	%r14d,%r13d
	movl	%r10d,%r15d
	vpaddd	%ymm6,%ymm2,%ymm2
	rorxl	$22,%r10d,%r12d
	leal	(%r9,%r13,1),%r9d
	xorl	%r11d,%r15d
	vpshufd	$80,%ymm2,%ymm7
	rorxl	$13,%r10d,%r14d
	rorxl	$2,%r10d,%r13d
	leal	(%rbx,%r9,1),%ebx
	vpsrld	$10,%ymm7,%ymm6
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r11d,%edi
	vpsrlq	$17,%ymm7,%ymm7
	xorl	%r13d,%r14d
	leal	(%r9,%rdi,1),%r9d
	movl	%ecx,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	12+128(%rsp),%r8d
	andl	%ebx,%r12d
	rorxl	$25,%ebx,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%ebx,%edi
	leal	(%r9,%r14,1),%r9d
	leal	(%r8,%r12,1),%r8d
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%edx,%ebx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%ebx,%r14d
	vpshufb	%ymm9,%ymm6,%ymm6
	leal	(%r8,%r12,1),%r8d
	xorl	%r14d,%r13d
	movl	%r9d,%edi
	vpaddd	%ymm6,%ymm2,%ymm2
	rorxl	$22,%r9d,%r12d
	leal	(%r8,%r13,1),%r8d
	xorl	%r10d,%edi
	vpaddd	64(%rbp),%ymm2,%ymm6
	rorxl	$13,%r9d,%r14d
	rorxl	$2,%r9d,%r13d
	leal	(%rax,%r8,1),%eax
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r10d,%r15d
	xorl	%r13d,%r14d
	leal	(%r8,%r15,1),%r8d
	movl	%ebx,%r12d
	vmovdqa	%ymm6,0(%rsp)
	vpalignr	$4,%ymm3,%ymm0,%ymm4
	addl	32+128(%rsp),%edx
	andl	%eax,%r12d
	rorxl	$25,%eax,%r13d
	vpalignr	$4,%ymm1,%ymm2,%ymm7
	rorxl	$11,%eax,%r15d
	leal	(%r8,%r14,1),%r8d
	leal	(%rdx,%r12,1),%edx
	vpsrld	$7,%ymm4,%ymm6
	andnl	%ecx,%eax,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%eax,%r14d
	vpaddd	%ymm7,%ymm3,%ymm3
	leal	(%rdx,%r12,1),%edx
	xorl	%r14d,%r13d
	movl	%r8d,%r15d
	vpsrld	$3,%ymm4,%ymm7
	rorxl	$22,%r8d,%r12d
	leal	(%rdx,%r13,1),%edx
	xorl	%r9d,%r15d
	vpslld	$14,%ymm4,%ymm5
	rorxl	$13,%r8d,%r14d
	rorxl	$2,%r8d,%r13d
	leal	(%r11,%rdx,1),%r11d
	vpxor	%ymm6,%ymm7,%ymm4
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r9d,%edi
	vpshufd	$250,%ymm2,%ymm7
	xorl	%r13d,%r14d
	leal	(%rdx,%rdi,1),%edx
	movl	%eax,%r12d
	vpsrld	$11,%ymm6,%ymm6
	addl	36+128(%rsp),%ecx
	andl	%r11d,%r12d
	rorxl	$25,%r11d,%r13d
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$11,%r11d,%edi
	leal	(%rdx,%r14,1),%edx
	leal	(%rcx,%r12,1),%ecx
	vpslld	$11,%ymm5,%ymm5
	andnl	%ebx,%r11d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r11d,%r14d
	vpxor	%ymm6,%ymm4,%ymm4
	leal	(%rcx,%r12,1),%ecx
	xorl	%r14d,%r13d
	movl	%edx,%edi
	vpsrld	$10,%ymm7,%ymm6
	rorxl	$22,%edx,%r12d
	leal	(%rcx,%r13,1),%ecx
	xorl	%r8d,%edi
	vpxor	%ymm5,%ymm4,%ymm4
	rorxl	$13,%edx,%r14d
	rorxl	$2,%edx,%r13d
	leal	(%r10,%rcx,1),%r10d
	vpsrlq	$17,%ymm7,%ymm7
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r8d,%r15d
	vpaddd	%ymm4,%ymm3,%ymm3
	xorl	%r13d,%r14d
	leal	(%rcx,%r15,1),%ecx
	movl	%r11d,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	40+128(%rsp),%ebx
	andl	%r10d,%r12d
	rorxl	$25,%r10d,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%r10d,%r15d
	leal	(%rcx,%r14,1),%ecx
	leal	(%rbx,%r12,1),%ebx
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%eax,%r10d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r10d,%r14d
	vpshufb	%ymm8,%ymm6,%ymm6
	leal	(%rbx,%r12,1),%ebx
	xorl	%r14d,%r13d
	movl	%ecx,%r15d
	vpaddd	%ymm6,%ymm3,%ymm3
	rorxl	$22,%ecx,%r12d
	leal	(%rbx,%r13,1),%ebx
	xorl	%edx,%r15d
	vpshufd	$80,%ymm3,%ymm7
	rorxl	$13,%ecx,%r14d
	rorxl	$2,%ecx,%r13d
	leal	(%r9,%rbx,1),%r9d
	vpsrld	$10,%ymm7,%ymm6
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%edx,%edi
	vpsrlq	$17,%ymm7,%ymm7
	xorl	%r13d,%r14d
	leal	(%rbx,%rdi,1),%ebx
	movl	%r10d,%r12d
	vpxor	%ymm7,%ymm6,%ymm6
	addl	44+128(%rsp),%eax
	andl	%r9d,%r12d
	rorxl	$25,%r9d,%r13d
	vpsrlq	$2,%ymm7,%ymm7
	rorxl	$11,%r9d,%edi
	leal	(%rbx,%r14,1),%ebx
	leal	(%rax,%r12,1),%eax
	vpxor	%ymm7,%ymm6,%ymm6
	andnl	%r11d,%r9d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r9d,%r14d
	vpshufb	%ymm9,%ymm6,%ymm6
	leal	(%rax,%r12,1),%eax
	xorl	%r14d,%r13d
	movl	%ebx,%edi
	vpaddd	%ymm6,%ymm3,%ymm3
	rorxl	$22,%ebx,%r12d
	leal	(%rax,%r13,1),%eax
	xorl	%ecx,%edi
	vpaddd	96(%rbp),%ymm3,%ymm6
	rorxl	$13,%ebx,%r14d
	rorxl	$2,%ebx,%r13d
	leal	(%r8,%rax,1),%r8d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%ecx,%r15d
	xorl	%r13d,%r14d
	leal	(%rax,%r15,1),%eax
	movl	%r9d,%r12d
	vmovdqa	%ymm6,32(%rsp)
	leaq	128(%rbp),%rbp
	cmpb	$0,3(%rbp)
	jne	.Lavx2_00_47
	addl	0+64(%rsp),%r11d
	andl	%r8d,%r12d
	rorxl	$25,%r8d,%r13d
	rorxl	$11,%r8d,%r15d
	leal	(%rax,%r14,1),%eax
	leal	(%r11,%r12,1),%r11d
	andnl	%r10d,%r8d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r8d,%r14d
	leal	(%r11,%r12,1),%r11d
	xorl	%r14d,%r13d
	movl	%eax,%r15d
	rorxl	$22,%eax,%r12d
	leal	(%r11,%r13,1),%r11d
	xorl	%ebx,%r15d
	rorxl	$13,%eax,%r14d
	rorxl	$2,%eax,%r13d
	leal	(%rdx,%r11,1),%edx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%ebx,%edi
	xorl	%r13d,%r14d
	leal	(%r11,%rdi,1),%r11d
	movl	%r8d,%r12d
	addl	4+64(%rsp),%r10d
	andl	%edx,%r12d
	rorxl	$25,%edx,%r13d
	rorxl	$11,%edx,%edi
	leal	(%r11,%r14,1),%r11d
	leal	(%r10,%r12,1),%r10d
	andnl	%r9d,%edx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%edx,%r14d
	leal	(%r10,%r12,1),%r10d
	xorl	%r14d,%r13d
	movl	%r11d,%edi
	rorxl	$22,%r11d,%r12d
	leal	(%r10,%r13,1),%r10d
	xorl	%eax,%edi
	rorxl	$13,%r11d,%r14d
	rorxl	$2,%r11d,%r13d
	leal	(%rcx,%r10,1),%ecx
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%eax,%r15d
	xorl	%r13d,%r14d
	leal	(%r10,%r15,1),%r10d
	movl	%edx,%r12d
	addl	8+64(%rsp),%r9d
	andl	%ecx,%r12d
	rorxl	$25,%ecx,%r13d
	rorxl	$11,%ecx,%r15d
	leal	(%r10,%r14,1),%r10d
	leal	(%r9,%r12,1),%r9d
	andnl	%r8d,%ecx,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%ecx,%r14d
	leal	(%r9,%r12,1),%r9d
	xorl	%r14d,%r13d
	movl	%r10d,%r15d
	rorxl	$22,%r10d,%r12d
	leal	(%r9,%r13,1),%r9d
	xorl	%r11d,%r15d
	rorxl	$13,%r10d,%r14d
	rorxl	$2,%r10d,%r13d
	leal	(%rbx,%r9,1),%ebx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r11d,%edi
	xorl	%r13d,%r14d
	leal	(%r9,%rdi,1),%r9d
	movl	%ecx,%r12d
	addl	12+64(%rsp),%r8d
	andl	%ebx,%r12d
	rorxl	$25,%ebx,%r13d
	rorxl	$11,%ebx,%edi
	leal	(%r9,%r14,1),%r9d
	leal	(%r8,%r12,1),%r8d
	andnl	%edx,%ebx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%ebx,%r14d
	leal	(%r8,%r12,1),%r8d
	xorl	%r14d,%r13d
	movl	%r9d,%edi
	rorxl	$22,%r9d,%r12d
	leal	(%r8,%r13,1),%r8d
	xorl	%r10d,%edi
	rorxl	$13,%r9d,%r14d
	rorxl	$2,%r9d,%r13d
	leal	(%rax,%r8,1),%eax
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r10d,%r15d
	xorl	%r13d,%r14d
	leal	(%r8,%r15,1),%r8d
	movl	%ebx,%r12d
	addl	32+64(%rsp),%edx
	andl	%eax,%r12d
	rorxl	$25,%eax,%r13d
	rorxl	$11,%eax,%r15d
	leal	(%r8,%r14,1),%r8d
	leal	(%rdx,%r12,1),%edx
	andnl	%ecx,%eax,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%eax,%r14d
	leal	(%rdx,%r12,1),%edx
	xorl	%r14d,%r13d
	movl	%r8d,%r15d
	rorxl	$22,%r8d,%r12d
	leal	(%rdx,%r13,1),%edx
	xorl	%r9d,%r15d
	rorxl	$13,%r8d,%r14d
	rorxl	$2,%r8d,%r13d
	leal	(%r11,%rdx,1),%r11d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r9d,%edi
	xorl	%r13d,%r14d
	leal	(%rdx,%rdi,1),%edx
	movl	%eax,%r12d
	addl	36+64(%rsp),%ecx
	andl	%r11d,%r12d
	rorxl	$25,%r11d,%r13d
	rorxl	$11,%r11d,%edi
	leal	(%rdx,%r14,1),%edx
	leal	(%rcx,%r12,1),%ecx
	andnl	%ebx,%r11d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r11d,%r14d
	leal	(%rcx,%r12,1),%ecx
	xorl	%r14d,%r13d
	movl	%edx,%edi
	rorxl	$22,%edx,%r12d
	leal	(%rcx,%r13,1),%ecx
	xorl	%r8d,%edi
	rorxl	$13,%edx,%r14d
	rorxl	$2,%edx,%r13d
	leal	(%r10,%rcx,1),%r10d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r8d,%r15d
	xorl	%r13d,%r14d
	leal	(%rcx,%r15,1),%ecx
	movl	%r11d,%r12d
	addl	40+64(%rsp),%ebx
	andl	%r10d,%r12d
	rorxl	$25,%r10d,%r13d
	rorxl	$11,%r10d,%r15d
	leal	(%rcx,%r14,1),%ecx
	leal	(%rbx,%r12,1),%ebx
	andnl	%eax,%r10d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r10d,%r14d
	leal	(%rbx,%r12,1),%ebx
	xorl	%r14d,%r13d
	movl	%ecx,%r15d
	rorxl	$22,%ecx,%r12d
	leal	(%rbx,%r13,1),%ebx
	xorl	%edx,%r15d
	rorxl	$13,%ecx,%r14d
	rorxl	$2,%ecx,%r13d
	leal	(%r9,%rbx,1),%r9d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%edx,%edi
	xorl	%r13d,%r14d
	leal	(%rbx,%rdi,1),%ebx
	movl	%r10d,%r12d
	addl	44+64(%rsp),%eax
	andl	%r9d,%r12d
	rorxl	$25,%r9d,%r13d
	rorxl	$11,%r9d,%edi
	leal	(%rbx,%r14,1),%ebx
	leal	(%rax,%r12,1),%eax
	andnl	%r11d,%r9d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r9d,%r14d
	leal	(%rax,%r12,1),%eax
	xorl	%r14d,%r13d
	movl	%ebx,%edi
	rorxl	$22,%ebx,%r12d
	leal	(%rax,%r13,1),%eax
	xorl	%ecx,%edi
	rorxl	$13,%ebx,%r14d
	rorxl	$2,%ebx,%r13d
	leal	(%r8,%rax,1),%r8d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%ecx,%r15d
	xorl	%r13d,%r14d
	leal	(%rax,%r15,1),%eax
	movl	%r9d,%r12d
	addl	0(%rsp),%r11d
	andl	%r8d,%r12d
	rorxl	$25,%r8d,%r13d
	rorxl	$11,%r8d,%r15d
	leal	(%rax,%r14,1),%eax
	leal	(%r11,%r12,1),%r11d
	andnl	%r10d,%r8d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r8d,%r14d
	leal	(%r11,%r12,1),%r11d
	xorl	%r14d,%r13d
	movl	%eax,%r15d
	rorxl	$22,%eax,%r12d
	leal	(%r11,%r13,1),%r11d
	xorl	%ebx,%r15d
	rorxl	$13,%eax,%r14d
	rorxl	$2,%eax,%r13d
	leal	(%rdx,%r11,1),%edx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%ebx,%edi
	xorl	%r13d,%r14d
	leal	(%r11,%rdi,1),%r11d
	movl	%r8d,%r12d
	addl	4(%rsp),%r10d
	andl	%edx,%r12d
	rorxl	$25,%edx,%r13d
	rorxl	$11,%edx,%edi
	leal	(%r11,%r14,1),%r11d
	leal	(%r10,%r12,1),%r10d
	andnl	%r9d,%edx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%edx,%r14d
	leal	(%r10,%r12,1),%r10d
	xorl	%r14d,%r13d
	movl	%r11d,%edi
	rorxl	$22,%r11d,%r12d
	leal	(%r10,%r13,1),%r10d
	xorl	%eax,%edi
	rorxl	$13,%r11d,%r14d
	rorxl	$2,%r11d,%r13d
	leal	(%rcx,%r10,1),%ecx
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%eax,%r15d
	xorl	%r13d,%r14d
	leal	(%r10,%r15,1),%r10d
	movl	%edx,%r12d
	addl	8(%rsp),%r9d
	andl	%ecx,%r12d
	rorxl	$25,%ecx,%r13d
	rorxl	$11,%ecx,%r15d
	leal	(%r10,%r14,1),%r10d
	leal	(%r9,%r12,1),%r9d
	andnl	%r8d,%ecx,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%ecx,%r14d
	leal	(%r9,%r12,1),%r9d
	xorl	%r14d,%r13d
	movl	%r10d,%r15d
	rorxl	$22,%r10d,%r12d
	leal	(%r9,%r13,1),%r9d
	xorl	%r11d,%r15d
	rorxl	$13,%r10d,%r14d
	rorxl	$2,%r10d,%r13d
	leal	(%rbx,%r9,1),%ebx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r11d,%edi
	xorl	%r13d,%r14d
	leal	(%r9,%rdi,1),%r9d
	movl	%ecx,%r12d
	addl	12(%rsp),%r8d
	andl	%ebx,%r12d
	rorxl	$25,%ebx,%r13d
	rorxl	$11,%ebx,%edi
	leal	(%r9,%r14,1),%r9d
	leal	(%r8,%r12,1),%r8d
	andnl	%edx,%ebx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%ebx,%r14d
	leal	(%r8,%r12,1),%r8d
	xorl	%r14d,%r13d
	movl	%r9d,%edi
	rorxl	$22,%r9d,%r12d
	leal	(%r8,%r13,1),%r8d
	xorl	%r10d,%edi
	rorxl	$13,%r9d,%r14d
	rorxl	$2,%r9d,%r13d
	leal	(%rax,%r8,1),%eax
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r10d,%r15d
	xorl	%r13d,%r14d
	leal	(%r8,%r15,1),%r8d
	movl	%ebx,%r12d
	addl	32(%rsp),%edx
	andl	%eax,%r12d
	rorxl	$25,%eax,%r13d
	rorxl	$11,%eax,%r15d
	leal	(%r8,%r14,1),%r8d
	leal	(%rdx,%r12,1),%edx
	andnl	%ecx,%eax,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%eax,%r14d
	leal	(%rdx,%r12,1),%edx
	xorl	%r14d,%r13d
	movl	%r8d,%r15d
	rorxl	$22,%r8d,%r12d
	leal	(%rdx,%r13,1),%edx
	xorl	%r9d,%r15d
	rorxl	$13,%r8d,%r14d
	rorxl	$2,%r8d,%r13d
	leal	(%r11,%rdx,1),%r11d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r9d,%edi
	xorl	%r13d,%r14d
	leal	(%rdx,%rdi,1),%edx
	movl	%eax,%r12d
	addl	36(%rsp),%ecx
	andl	%r11d,%r12d
	rorxl	$25,%r11d,%r13d
	rorxl	$11,%r11d,%edi
	leal	(%rdx,%r14,1),%edx
	leal	(%rcx,%r12,1),%ecx
	andnl	%ebx,%r11d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r11d,%r14d
	leal	(%rcx,%r12,1),%ecx
	xorl	%r14d,%r13d
	movl	%edx,%edi
	rorxl	$22,%edx,%r12d
	leal	(%rcx,%r13,1),%ecx
	xorl	%r8d,%edi
	rorxl	$13,%edx,%r14d
	rorxl	$2,%edx,%r13d
	leal	(%r10,%rcx,1),%r10d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r8d,%r15d
	xorl	%r13d,%r14d
	leal	(%rcx,%r15,1),%ecx
	movl	%r11d,%r12d
	addl	40(%rsp),%ebx
	andl	%r10d,%r12d
	rorxl	$25,%r10d,%r13d
	rorxl	$11,%r10d,%r15d
	leal	(%rcx,%r14,1),%ecx
	leal	(%rbx,%r12,1),%ebx
	andnl	%eax,%r10d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r10d,%r14d
	leal	(%rbx,%r12,1),%ebx
	xorl	%r14d,%r13d
	movl	%ecx,%r15d
	rorxl	$22,%ecx,%r12d
	leal	(%rbx,%r13,1),%ebx
	xorl	%edx,%r15d
	rorxl	$13,%ecx,%r14d
	rorxl	$2,%ecx,%r13d
	leal	(%r9,%rbx,1),%r9d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%edx,%edi
	xorl	%r13d,%r14d
	leal	(%rbx,%rdi,1),%ebx
	movl	%r10d,%r12d
	addl	44(%rsp),%eax
	andl	%r9d,%r12d
	rorxl	$25,%r9d,%r13d
	rorxl	$11,%r9d,%edi
	leal	(%rbx,%r14,1),%ebx
	leal	(%rax,%r12,1),%eax
	andnl	%r11d,%r9d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r9d,%r14d
	leal	(%rax,%r12,1),%eax
	xorl	%r14d,%r13d
	movl	%ebx,%edi
	rorxl	$22,%ebx,%r12d
	leal	(%rax,%r13,1),%eax
	xorl	%ecx,%edi
	rorxl	$13,%ebx,%r14d
	rorxl	$2,%ebx,%r13d
	leal	(%r8,%rax,1),%r8d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%ecx,%r15d
	xorl	%r13d,%r14d
	leal	(%rax,%r15,1),%eax
	movl	%r9d,%r12d
	movq	512(%rsp),%rdi
	addl	%r14d,%eax

	leaq	448(%rsp),%rbp

	addl	0(%rdi),%eax
	addl	4(%rdi),%ebx
	addl	8(%rdi),%ecx
	addl	12(%rdi),%edx
	addl	16(%rdi),%r8d
	addl	20(%rdi),%r9d
	addl	24(%rdi),%r10d
	addl	28(%rdi),%r11d

	movl	%eax,0(%rdi)
	movl	%ebx,4(%rdi)
	movl	%ecx,8(%rdi)
	movl	%edx,12(%rdi)
	movl	%r8d,16(%rdi)
	movl	%r9d,20(%rdi)
	movl	%r10d,24(%rdi)
	movl	%r11d,28(%rdi)

	cmpq	80(%rbp),%rsi
	je	.Ldone_avx2

	xorl	%r14d,%r14d
	movl	%ebx,%edi
	xorl	%ecx,%edi
	movl	%r9d,%r12d
	jmp	.Lower_avx2
.align	16
.Lower_avx2:
	addl	0+16(%rbp),%r11d
	andl	%r8d,%r12d
	rorxl	$25,%r8d,%r13d
	rorxl	$11,%r8d,%r15d
	leal	(%rax,%r14,1),%eax
	leal	(%r11,%r12,1),%r11d
	andnl	%r10d,%r8d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r8d,%r14d
	leal	(%r11,%r12,1),%r11d
	xorl	%r14d,%r13d
	movl	%eax,%r15d
	rorxl	$22,%eax,%r12d
	leal	(%r11,%r13,1),%r11d
	xorl	%ebx,%r15d
	rorxl	$13,%eax,%r14d
	rorxl	$2,%eax,%r13d
	leal	(%rdx,%r11,1),%edx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%ebx,%edi
	xorl	%r13d,%r14d
	leal	(%r11,%rdi,1),%r11d
	movl	%r8d,%r12d
	addl	4+16(%rbp),%r10d
	andl	%edx,%r12d
	rorxl	$25,%edx,%r13d
	rorxl	$11,%edx,%edi
	leal	(%r11,%r14,1),%r11d
	leal	(%r10,%r12,1),%r10d
	andnl	%r9d,%edx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%edx,%r14d
	leal	(%r10,%r12,1),%r10d
	xorl	%r14d,%r13d
	movl	%r11d,%edi
	rorxl	$22,%r11d,%r12d
	leal	(%r10,%r13,1),%r10d
	xorl	%eax,%edi
	rorxl	$13,%r11d,%r14d
	rorxl	$2,%r11d,%r13d
	leal	(%rcx,%r10,1),%ecx
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%eax,%r15d
	xorl	%r13d,%r14d
	leal	(%r10,%r15,1),%r10d
	movl	%edx,%r12d
	addl	8+16(%rbp),%r9d
	andl	%ecx,%r12d
	rorxl	$25,%ecx,%r13d
	rorxl	$11,%ecx,%r15d
	leal	(%r10,%r14,1),%r10d
	leal	(%r9,%r12,1),%r9d
	andnl	%r8d,%ecx,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%ecx,%r14d
	leal	(%r9,%r12,1),%r9d
	xorl	%r14d,%r13d
	movl	%r10d,%r15d
	rorxl	$22,%r10d,%r12d
	leal	(%r9,%r13,1),%r9d
	xorl	%r11d,%r15d
	rorxl	$13,%r10d,%r14d
	rorxl	$2,%r10d,%r13d
	leal	(%rbx,%r9,1),%ebx
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r11d,%edi
	xorl	%r13d,%r14d
	leal	(%r9,%rdi,1),%r9d
	movl	%ecx,%r12d
	addl	12+16(%rbp),%r8d
	andl	%ebx,%r12d
	rorxl	$25,%ebx,%r13d
	rorxl	$11,%ebx,%edi
	leal	(%r9,%r14,1),%r9d
	leal	(%r8,%r12,1),%r8d
	andnl	%edx,%ebx,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%ebx,%r14d
	leal	(%r8,%r12,1),%r8d
	xorl	%r14d,%r13d
	movl	%r9d,%edi
	rorxl	$22,%r9d,%r12d
	leal	(%r8,%r13,1),%r8d
	xorl	%r10d,%edi
	rorxl	$13,%r9d,%r14d
	rorxl	$2,%r9d,%r13d
	leal	(%rax,%r8,1),%eax
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r10d,%r15d
	xorl	%r13d,%r14d
	leal	(%r8,%r15,1),%r8d
	movl	%ebx,%r12d
	addl	32+16(%rbp),%edx
	andl	%eax,%r12d
	rorxl	$25,%eax,%r13d
	rorxl	$11,%eax,%r15d
	leal	(%r8,%r14,1),%r8d
	leal	(%rdx,%r12,1),%edx
	andnl	%ecx,%eax,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%eax,%r14d
	leal	(%rdx,%r12,1),%edx
	xorl	%r14d,%r13d
	movl	%r8d,%r15d
	rorxl	$22,%r8d,%r12d
	leal	(%rdx,%r13,1),%edx
	xorl	%r9d,%r15d
	rorxl	$13,%r8d,%r14d
	rorxl	$2,%r8d,%r13d
	leal	(%r11,%rdx,1),%r11d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%r9d,%edi
	xorl	%r13d,%r14d
	leal	(%rdx,%rdi,1),%edx
	movl	%eax,%r12d
	addl	36+16(%rbp),%ecx
	andl	%r11d,%r12d
	rorxl	$25,%r11d,%r13d
	rorxl	$11,%r11d,%edi
	leal	(%rdx,%r14,1),%edx
	leal	(%rcx,%r12,1),%ecx
	andnl	%ebx,%r11d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r11d,%r14d
	leal	(%rcx,%r12,1),%ecx
	xorl	%r14d,%r13d
	movl	%edx,%edi
	rorxl	$22,%edx,%r12d
	leal	(%rcx,%r13,1),%ecx
	xorl	%r8d,%edi
	rorxl	$13,%edx,%r14d
	rorxl	$2,%edx,%r13d
	leal	(%r10,%rcx,1),%r10d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%r8d,%r15d
	xorl	%r13d,%r14d
	leal	(%rcx,%r15,1),%ecx
	movl	%r11d,%r12d
	addl	40+16(%rbp),%ebx
	andl	%r10d,%r12d
	rorxl	$25,%r10d,%r13d
	rorxl	$11,%r10d,%r15d
	leal	(%rcx,%r14,1),%ecx
	leal	(%rbx,%r12,1),%ebx
	andnl	%eax,%r10d,%r12d
	xorl	%r15d,%r13d
	rorxl	$6,%r10d,%r14d
	leal	(%rbx,%r12,1),%ebx
	xorl	%r14d,%r13d
	movl	%ecx,%r15d
	rorxl	$22,%ecx,%r12d
	leal	(%rbx,%r13,1),%ebx
	xorl	%edx,%r15d
	rorxl	$13,%ecx,%r14d
	rorxl	$2,%ecx,%r13d
	leal	(%r9,%rbx,1),%r9d
	andl	%r15d,%edi
	xorl	%r12d,%r14d
	xorl	%edx,%edi
	xorl	%r13d,%r14d
	leal	(%rbx,%rdi,1),%ebx
	movl	%r10d,%r12d
	addl	44+16(%rbp),%eax
	andl	%r9d,%r12d
	rorxl	$25,%r9d,%r13d
	rorxl	$11,%r9d,%edi
	leal	(%rbx,%r14,1),%ebx
	leal	(%rax,%r12,1),%eax
	andnl	%r11d,%r9d,%r12d
	xorl	%edi,%r13d
	rorxl	$6,%r9d,%r14d
	leal	(%rax,%r12,1),%eax
	xorl	%r14d,%r13d
	movl	%ebx,%edi
	rorxl	$22,%ebx,%r12d
	leal	(%rax,%r13,1),%eax
	xorl	%ecx,%edi
	rorxl	$13,%ebx,%r14d
	rorxl	$2,%ebx,%r13d
	leal	(%r8,%rax,1),%r8d
	andl	%edi,%r15d
	xorl	%r12d,%r14d
	xorl	%ecx,%r15d
	xorl	%r13d,%r14d
	leal	(%rax,%r15,1),%eax
	movl	%r9d,%r12d
	leaq	-64(%rbp),%rbp
	cmpq	%rsp,%rbp
	jae	.Lower_avx2

	movq	512(%rsp),%rdi
	addl	%r14d,%eax

	leaq	448(%rsp),%rsp

.cfi_escape	0x0f,0x06,0x77,0xd8,0x00,0x06,0x23,0x08

	addl	0(%rdi),%eax
	addl	4(%rdi),%ebx
	addl	8(%rdi),%ecx
	addl	12(%rdi),%edx
	addl	16(%rdi),%r8d
	addl	20(%rdi),%r9d
	leaq	128(%rsi),%rsi
	addl	24(%rdi),%r10d
	movq	%rsi,%r12
	addl	28(%rdi),%r11d
	cmpq	64+16(%rsp),%rsi

	movl	%eax,0(%rdi)
	cmoveq	%rsp,%r12
	movl	%ebx,4(%rdi)
	movl	%ecx,8(%rdi)
	movl	%edx,12(%rdi)
	movl	%r8d,16(%rdi)
	movl	%r9d,20(%rdi)
	movl	%r10d,24(%rdi)
	movl	%r11d,28(%rdi)

	jbe	.Loop_avx2
	leaq	(%rsp),%rbp


.cfi_escape	0x0f,0x06,0x76,0xd8,0x00,0x06,0x23,0x08

.Ldone_avx2:
	movq	88(%rbp),%rsi
.cfi_def_cfa	%rsi,8
	vzeroupper
	movq	-48(%rsi),%r15
.cfi_restore	%r15
	movq	-40(%rsi),%r14
.cfi_restore	%r14
	movq	-32(%rsi),%r13
.cfi_restore	%r13
	movq	-24(%rsi),%r12
.cfi_restore	%r12
	movq	-16(%rsi),%rbp
.cfi_restore	%rbp
	movq	-8(%rsi),%rbx
.cfi_restore	%rbx
	leaq	(%rsi),%rsp
.cfi_def_cfa_register	%rsp
.Lepilogue_avx2:
	.byte	0xf3,0xc3
.cfi_endproc	
ENDPROC(sha2_256_cryptogams_avx2_xform_le)
#endif
