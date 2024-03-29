/* SPDX-License-Identifier: BSD-3-Clause OR GPL-1.0-or-later */
#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha2_256_cryptogams_avx_xform_le)
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


ENTRY(sha2_256_cryptogams_avx_xform_le)
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
	shlq	$4,%rdx
	subq	$96,%rsp
	leaq	(%rsi,%rdx,4),%rdx
	andq	$-64,%rsp
	movq	%rdi,64+0(%rsp)
	movq	%rsi,64+8(%rsp)
	movq	%rdx,64+16(%rsp)
	movq	%rax,88(%rsp)
.cfi_escape	0x0f,0x06,0x77,0xd8,0x00,0x06,0x23,0x08
.Lprologue_avx:

	vzeroupper
	movl	0(%rdi),%eax
	movl	4(%rdi),%ebx
	movl	8(%rdi),%ecx
	movl	12(%rdi),%edx
	movl	16(%rdi),%r8d
	movl	20(%rdi),%r9d
	movl	24(%rdi),%r10d
	movl	28(%rdi),%r11d
	vmovdqa	K256+512+32(%rip),%xmm8
	vmovdqa	K256+512+64(%rip),%xmm9
	jmp	.Lloop_avx
.align	16
.Lloop_avx:
	vmovdqu	0(%rsi),%xmm0
	vmovdqu	16(%rsi),%xmm1
	vmovdqu	32(%rsi),%xmm2
	vmovdqu	48(%rsi),%xmm3
	leaq	K256(%rip),%rbp
	vpaddd	0(%rbp),%xmm0,%xmm4
	vpaddd	32(%rbp),%xmm1,%xmm5
	vpaddd	64(%rbp),%xmm2,%xmm6
	vpaddd	96(%rbp),%xmm3,%xmm7
	vmovdqa	%xmm4,0(%rsp)
	movl	%eax,%r14d
	vmovdqa	%xmm5,16(%rsp)
	movl	%ebx,%edi
	vmovdqa	%xmm6,32(%rsp)
	xorl	%ecx,%edi
	vmovdqa	%xmm7,48(%rsp)
	movl	%r8d,%r13d
	jmp	.Lavx_00_47

.align	16
.Lavx_00_47:
	subq	$-128,%rbp
	vpalignr	$4,%xmm0,%xmm1,%xmm4
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%eax
	movl	%r9d,%r12d
	vpalignr	$4,%xmm2,%xmm3,%xmm7
	shrdl	$9,%r14d,%r14d
	xorl	%r8d,%r13d
	xorl	%r10d,%r12d
	vpsrld	$7,%xmm4,%xmm6
	shrdl	$5,%r13d,%r13d
	xorl	%eax,%r14d
	andl	%r8d,%r12d
	vpaddd	%xmm7,%xmm0,%xmm0
	xorl	%r8d,%r13d
	addl	0(%rsp),%r11d
	movl	%eax,%r15d
	vpsrld	$3,%xmm4,%xmm7
	xorl	%r10d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ebx,%r15d
	vpslld	$14,%xmm4,%xmm5
	addl	%r12d,%r11d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	vpxor	%xmm6,%xmm7,%xmm4
	xorl	%eax,%r14d
	addl	%r13d,%r11d
	xorl	%ebx,%edi
	vpshufd	$250,%xmm3,%xmm7
	shrdl	$2,%r14d,%r14d
	addl	%r11d,%edx
	addl	%edi,%r11d
	vpsrld	$11,%xmm6,%xmm6
	movl	%edx,%r13d
	addl	%r11d,%r14d
	shrdl	$14,%r13d,%r13d
	vpxor	%xmm5,%xmm4,%xmm4
	movl	%r14d,%r11d
	movl	%r8d,%r12d
	shrdl	$9,%r14d,%r14d
	vpslld	$11,%xmm5,%xmm5
	xorl	%edx,%r13d
	xorl	%r9d,%r12d
	shrdl	$5,%r13d,%r13d
	vpxor	%xmm6,%xmm4,%xmm4
	xorl	%r11d,%r14d
	andl	%edx,%r12d
	xorl	%edx,%r13d
	vpsrld	$10,%xmm7,%xmm6
	addl	4(%rsp),%r10d
	movl	%r11d,%edi
	xorl	%r9d,%r12d
	vpxor	%xmm5,%xmm4,%xmm4
	shrdl	$11,%r14d,%r14d
	xorl	%eax,%edi
	addl	%r12d,%r10d
	vpsrlq	$17,%xmm7,%xmm7
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r11d,%r14d
	vpaddd	%xmm4,%xmm0,%xmm0
	addl	%r13d,%r10d
	xorl	%eax,%r15d
	shrdl	$2,%r14d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	addl	%r10d,%ecx
	addl	%r15d,%r10d
	movl	%ecx,%r13d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%r10d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r10d
	vpxor	%xmm7,%xmm6,%xmm6
	movl	%edx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ecx,%r13d
	vpshufb	%xmm8,%xmm6,%xmm6
	xorl	%r8d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r10d,%r14d
	vpaddd	%xmm6,%xmm0,%xmm0
	andl	%ecx,%r12d
	xorl	%ecx,%r13d
	addl	8(%rsp),%r9d
	vpshufd	$80,%xmm0,%xmm7
	movl	%r10d,%r15d
	xorl	%r8d,%r12d
	shrdl	$11,%r14d,%r14d
	vpsrld	$10,%xmm7,%xmm6
	xorl	%r11d,%r15d
	addl	%r12d,%r9d
	shrdl	$6,%r13d,%r13d
	vpsrlq	$17,%xmm7,%xmm7
	andl	%r15d,%edi
	xorl	%r10d,%r14d
	addl	%r13d,%r9d
	vpxor	%xmm7,%xmm6,%xmm6
	xorl	%r11d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r9d,%ebx
	vpsrlq	$2,%xmm7,%xmm7
	addl	%edi,%r9d
	movl	%ebx,%r13d
	addl	%r9d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r9d
	movl	%ecx,%r12d
	vpshufb	%xmm9,%xmm6,%xmm6
	shrdl	$9,%r14d,%r14d
	xorl	%ebx,%r13d
	xorl	%edx,%r12d
	vpaddd	%xmm6,%xmm0,%xmm0
	shrdl	$5,%r13d,%r13d
	xorl	%r9d,%r14d
	andl	%ebx,%r12d
	vpaddd	0(%rbp),%xmm0,%xmm6
	xorl	%ebx,%r13d
	addl	12(%rsp),%r8d
	movl	%r9d,%edi
	xorl	%edx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r10d,%edi
	addl	%r12d,%r8d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r9d,%r14d
	addl	%r13d,%r8d
	xorl	%r10d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r8d,%eax
	addl	%r15d,%r8d
	movl	%eax,%r13d
	addl	%r8d,%r14d
	vmovdqa	%xmm6,0(%rsp)
	vpalignr	$4,%xmm1,%xmm2,%xmm4
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r8d
	movl	%ebx,%r12d
	vpalignr	$4,%xmm3,%xmm0,%xmm7
	shrdl	$9,%r14d,%r14d
	xorl	%eax,%r13d
	xorl	%ecx,%r12d
	vpsrld	$7,%xmm4,%xmm6
	shrdl	$5,%r13d,%r13d
	xorl	%r8d,%r14d
	andl	%eax,%r12d
	vpaddd	%xmm7,%xmm1,%xmm1
	xorl	%eax,%r13d
	addl	16(%rsp),%edx
	movl	%r8d,%r15d
	vpsrld	$3,%xmm4,%xmm7
	xorl	%ecx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r9d,%r15d
	vpslld	$14,%xmm4,%xmm5
	addl	%r12d,%edx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	vpxor	%xmm6,%xmm7,%xmm4
	xorl	%r8d,%r14d
	addl	%r13d,%edx
	xorl	%r9d,%edi
	vpshufd	$250,%xmm0,%xmm7
	shrdl	$2,%r14d,%r14d
	addl	%edx,%r11d
	addl	%edi,%edx
	vpsrld	$11,%xmm6,%xmm6
	movl	%r11d,%r13d
	addl	%edx,%r14d
	shrdl	$14,%r13d,%r13d
	vpxor	%xmm5,%xmm4,%xmm4
	movl	%r14d,%edx
	movl	%eax,%r12d
	shrdl	$9,%r14d,%r14d
	vpslld	$11,%xmm5,%xmm5
	xorl	%r11d,%r13d
	xorl	%ebx,%r12d
	shrdl	$5,%r13d,%r13d
	vpxor	%xmm6,%xmm4,%xmm4
	xorl	%edx,%r14d
	andl	%r11d,%r12d
	xorl	%r11d,%r13d
	vpsrld	$10,%xmm7,%xmm6
	addl	20(%rsp),%ecx
	movl	%edx,%edi
	xorl	%ebx,%r12d
	vpxor	%xmm5,%xmm4,%xmm4
	shrdl	$11,%r14d,%r14d
	xorl	%r8d,%edi
	addl	%r12d,%ecx
	vpsrlq	$17,%xmm7,%xmm7
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%edx,%r14d
	vpaddd	%xmm4,%xmm1,%xmm1
	addl	%r13d,%ecx
	xorl	%r8d,%r15d
	shrdl	$2,%r14d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	addl	%ecx,%r10d
	addl	%r15d,%ecx
	movl	%r10d,%r13d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%ecx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ecx
	vpxor	%xmm7,%xmm6,%xmm6
	movl	%r11d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r10d,%r13d
	vpshufb	%xmm8,%xmm6,%xmm6
	xorl	%eax,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ecx,%r14d
	vpaddd	%xmm6,%xmm1,%xmm1
	andl	%r10d,%r12d
	xorl	%r10d,%r13d
	addl	24(%rsp),%ebx
	vpshufd	$80,%xmm1,%xmm7
	movl	%ecx,%r15d
	xorl	%eax,%r12d
	shrdl	$11,%r14d,%r14d
	vpsrld	$10,%xmm7,%xmm6
	xorl	%edx,%r15d
	addl	%r12d,%ebx
	shrdl	$6,%r13d,%r13d
	vpsrlq	$17,%xmm7,%xmm7
	andl	%r15d,%edi
	xorl	%ecx,%r14d
	addl	%r13d,%ebx
	vpxor	%xmm7,%xmm6,%xmm6
	xorl	%edx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%ebx,%r9d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%edi,%ebx
	movl	%r9d,%r13d
	addl	%ebx,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ebx
	movl	%r10d,%r12d
	vpshufb	%xmm9,%xmm6,%xmm6
	shrdl	$9,%r14d,%r14d
	xorl	%r9d,%r13d
	xorl	%r11d,%r12d
	vpaddd	%xmm6,%xmm1,%xmm1
	shrdl	$5,%r13d,%r13d
	xorl	%ebx,%r14d
	andl	%r9d,%r12d
	vpaddd	32(%rbp),%xmm1,%xmm6
	xorl	%r9d,%r13d
	addl	28(%rsp),%eax
	movl	%ebx,%edi
	xorl	%r11d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ecx,%edi
	addl	%r12d,%eax
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%ebx,%r14d
	addl	%r13d,%eax
	xorl	%ecx,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%eax,%r8d
	addl	%r15d,%eax
	movl	%r8d,%r13d
	addl	%eax,%r14d
	vmovdqa	%xmm6,16(%rsp)
	vpalignr	$4,%xmm2,%xmm3,%xmm4
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%eax
	movl	%r9d,%r12d
	vpalignr	$4,%xmm0,%xmm1,%xmm7
	shrdl	$9,%r14d,%r14d
	xorl	%r8d,%r13d
	xorl	%r10d,%r12d
	vpsrld	$7,%xmm4,%xmm6
	shrdl	$5,%r13d,%r13d
	xorl	%eax,%r14d
	andl	%r8d,%r12d
	vpaddd	%xmm7,%xmm2,%xmm2
	xorl	%r8d,%r13d
	addl	32(%rsp),%r11d
	movl	%eax,%r15d
	vpsrld	$3,%xmm4,%xmm7
	xorl	%r10d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ebx,%r15d
	vpslld	$14,%xmm4,%xmm5
	addl	%r12d,%r11d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	vpxor	%xmm6,%xmm7,%xmm4
	xorl	%eax,%r14d
	addl	%r13d,%r11d
	xorl	%ebx,%edi
	vpshufd	$250,%xmm1,%xmm7
	shrdl	$2,%r14d,%r14d
	addl	%r11d,%edx
	addl	%edi,%r11d
	vpsrld	$11,%xmm6,%xmm6
	movl	%edx,%r13d
	addl	%r11d,%r14d
	shrdl	$14,%r13d,%r13d
	vpxor	%xmm5,%xmm4,%xmm4
	movl	%r14d,%r11d
	movl	%r8d,%r12d
	shrdl	$9,%r14d,%r14d
	vpslld	$11,%xmm5,%xmm5
	xorl	%edx,%r13d
	xorl	%r9d,%r12d
	shrdl	$5,%r13d,%r13d
	vpxor	%xmm6,%xmm4,%xmm4
	xorl	%r11d,%r14d
	andl	%edx,%r12d
	xorl	%edx,%r13d
	vpsrld	$10,%xmm7,%xmm6
	addl	36(%rsp),%r10d
	movl	%r11d,%edi
	xorl	%r9d,%r12d
	vpxor	%xmm5,%xmm4,%xmm4
	shrdl	$11,%r14d,%r14d
	xorl	%eax,%edi
	addl	%r12d,%r10d
	vpsrlq	$17,%xmm7,%xmm7
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r11d,%r14d
	vpaddd	%xmm4,%xmm2,%xmm2
	addl	%r13d,%r10d
	xorl	%eax,%r15d
	shrdl	$2,%r14d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	addl	%r10d,%ecx
	addl	%r15d,%r10d
	movl	%ecx,%r13d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%r10d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r10d
	vpxor	%xmm7,%xmm6,%xmm6
	movl	%edx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ecx,%r13d
	vpshufb	%xmm8,%xmm6,%xmm6
	xorl	%r8d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r10d,%r14d
	vpaddd	%xmm6,%xmm2,%xmm2
	andl	%ecx,%r12d
	xorl	%ecx,%r13d
	addl	40(%rsp),%r9d
	vpshufd	$80,%xmm2,%xmm7
	movl	%r10d,%r15d
	xorl	%r8d,%r12d
	shrdl	$11,%r14d,%r14d
	vpsrld	$10,%xmm7,%xmm6
	xorl	%r11d,%r15d
	addl	%r12d,%r9d
	shrdl	$6,%r13d,%r13d
	vpsrlq	$17,%xmm7,%xmm7
	andl	%r15d,%edi
	xorl	%r10d,%r14d
	addl	%r13d,%r9d
	vpxor	%xmm7,%xmm6,%xmm6
	xorl	%r11d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r9d,%ebx
	vpsrlq	$2,%xmm7,%xmm7
	addl	%edi,%r9d
	movl	%ebx,%r13d
	addl	%r9d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r9d
	movl	%ecx,%r12d
	vpshufb	%xmm9,%xmm6,%xmm6
	shrdl	$9,%r14d,%r14d
	xorl	%ebx,%r13d
	xorl	%edx,%r12d
	vpaddd	%xmm6,%xmm2,%xmm2
	shrdl	$5,%r13d,%r13d
	xorl	%r9d,%r14d
	andl	%ebx,%r12d
	vpaddd	64(%rbp),%xmm2,%xmm6
	xorl	%ebx,%r13d
	addl	44(%rsp),%r8d
	movl	%r9d,%edi
	xorl	%edx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r10d,%edi
	addl	%r12d,%r8d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r9d,%r14d
	addl	%r13d,%r8d
	xorl	%r10d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r8d,%eax
	addl	%r15d,%r8d
	movl	%eax,%r13d
	addl	%r8d,%r14d
	vmovdqa	%xmm6,32(%rsp)
	vpalignr	$4,%xmm3,%xmm0,%xmm4
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r8d
	movl	%ebx,%r12d
	vpalignr	$4,%xmm1,%xmm2,%xmm7
	shrdl	$9,%r14d,%r14d
	xorl	%eax,%r13d
	xorl	%ecx,%r12d
	vpsrld	$7,%xmm4,%xmm6
	shrdl	$5,%r13d,%r13d
	xorl	%r8d,%r14d
	andl	%eax,%r12d
	vpaddd	%xmm7,%xmm3,%xmm3
	xorl	%eax,%r13d
	addl	48(%rsp),%edx
	movl	%r8d,%r15d
	vpsrld	$3,%xmm4,%xmm7
	xorl	%ecx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r9d,%r15d
	vpslld	$14,%xmm4,%xmm5
	addl	%r12d,%edx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	vpxor	%xmm6,%xmm7,%xmm4
	xorl	%r8d,%r14d
	addl	%r13d,%edx
	xorl	%r9d,%edi
	vpshufd	$250,%xmm2,%xmm7
	shrdl	$2,%r14d,%r14d
	addl	%edx,%r11d
	addl	%edi,%edx
	vpsrld	$11,%xmm6,%xmm6
	movl	%r11d,%r13d
	addl	%edx,%r14d
	shrdl	$14,%r13d,%r13d
	vpxor	%xmm5,%xmm4,%xmm4
	movl	%r14d,%edx
	movl	%eax,%r12d
	shrdl	$9,%r14d,%r14d
	vpslld	$11,%xmm5,%xmm5
	xorl	%r11d,%r13d
	xorl	%ebx,%r12d
	shrdl	$5,%r13d,%r13d
	vpxor	%xmm6,%xmm4,%xmm4
	xorl	%edx,%r14d
	andl	%r11d,%r12d
	xorl	%r11d,%r13d
	vpsrld	$10,%xmm7,%xmm6
	addl	52(%rsp),%ecx
	movl	%edx,%edi
	xorl	%ebx,%r12d
	vpxor	%xmm5,%xmm4,%xmm4
	shrdl	$11,%r14d,%r14d
	xorl	%r8d,%edi
	addl	%r12d,%ecx
	vpsrlq	$17,%xmm7,%xmm7
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%edx,%r14d
	vpaddd	%xmm4,%xmm3,%xmm3
	addl	%r13d,%ecx
	xorl	%r8d,%r15d
	shrdl	$2,%r14d,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	addl	%ecx,%r10d
	addl	%r15d,%ecx
	movl	%r10d,%r13d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%ecx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ecx
	vpxor	%xmm7,%xmm6,%xmm6
	movl	%r11d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r10d,%r13d
	vpshufb	%xmm8,%xmm6,%xmm6
	xorl	%eax,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ecx,%r14d
	vpaddd	%xmm6,%xmm3,%xmm3
	andl	%r10d,%r12d
	xorl	%r10d,%r13d
	addl	56(%rsp),%ebx
	vpshufd	$80,%xmm3,%xmm7
	movl	%ecx,%r15d
	xorl	%eax,%r12d
	shrdl	$11,%r14d,%r14d
	vpsrld	$10,%xmm7,%xmm6
	xorl	%edx,%r15d
	addl	%r12d,%ebx
	shrdl	$6,%r13d,%r13d
	vpsrlq	$17,%xmm7,%xmm7
	andl	%r15d,%edi
	xorl	%ecx,%r14d
	addl	%r13d,%ebx
	vpxor	%xmm7,%xmm6,%xmm6
	xorl	%edx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%ebx,%r9d
	vpsrlq	$2,%xmm7,%xmm7
	addl	%edi,%ebx
	movl	%r9d,%r13d
	addl	%ebx,%r14d
	vpxor	%xmm7,%xmm6,%xmm6
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ebx
	movl	%r10d,%r12d
	vpshufb	%xmm9,%xmm6,%xmm6
	shrdl	$9,%r14d,%r14d
	xorl	%r9d,%r13d
	xorl	%r11d,%r12d
	vpaddd	%xmm6,%xmm3,%xmm3
	shrdl	$5,%r13d,%r13d
	xorl	%ebx,%r14d
	andl	%r9d,%r12d
	vpaddd	96(%rbp),%xmm3,%xmm6
	xorl	%r9d,%r13d
	addl	60(%rsp),%eax
	movl	%ebx,%edi
	xorl	%r11d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ecx,%edi
	addl	%r12d,%eax
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%ebx,%r14d
	addl	%r13d,%eax
	xorl	%ecx,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%eax,%r8d
	addl	%r15d,%eax
	movl	%r8d,%r13d
	addl	%eax,%r14d
	vmovdqa	%xmm6,48(%rsp)
	cmpb	$0,131(%rbp)
	jne	.Lavx_00_47
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%eax
	movl	%r9d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r8d,%r13d
	xorl	%r10d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%eax,%r14d
	andl	%r8d,%r12d
	xorl	%r8d,%r13d
	addl	0(%rsp),%r11d
	movl	%eax,%r15d
	xorl	%r10d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ebx,%r15d
	addl	%r12d,%r11d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%eax,%r14d
	addl	%r13d,%r11d
	xorl	%ebx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r11d,%edx
	addl	%edi,%r11d
	movl	%edx,%r13d
	addl	%r11d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r11d
	movl	%r8d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%edx,%r13d
	xorl	%r9d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r11d,%r14d
	andl	%edx,%r12d
	xorl	%edx,%r13d
	addl	4(%rsp),%r10d
	movl	%r11d,%edi
	xorl	%r9d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%eax,%edi
	addl	%r12d,%r10d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r11d,%r14d
	addl	%r13d,%r10d
	xorl	%eax,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r10d,%ecx
	addl	%r15d,%r10d
	movl	%ecx,%r13d
	addl	%r10d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r10d
	movl	%edx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ecx,%r13d
	xorl	%r8d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r10d,%r14d
	andl	%ecx,%r12d
	xorl	%ecx,%r13d
	addl	8(%rsp),%r9d
	movl	%r10d,%r15d
	xorl	%r8d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r11d,%r15d
	addl	%r12d,%r9d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%r10d,%r14d
	addl	%r13d,%r9d
	xorl	%r11d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r9d,%ebx
	addl	%edi,%r9d
	movl	%ebx,%r13d
	addl	%r9d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r9d
	movl	%ecx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ebx,%r13d
	xorl	%edx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r9d,%r14d
	andl	%ebx,%r12d
	xorl	%ebx,%r13d
	addl	12(%rsp),%r8d
	movl	%r9d,%edi
	xorl	%edx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r10d,%edi
	addl	%r12d,%r8d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r9d,%r14d
	addl	%r13d,%r8d
	xorl	%r10d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r8d,%eax
	addl	%r15d,%r8d
	movl	%eax,%r13d
	addl	%r8d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r8d
	movl	%ebx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%eax,%r13d
	xorl	%ecx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r8d,%r14d
	andl	%eax,%r12d
	xorl	%eax,%r13d
	addl	16(%rsp),%edx
	movl	%r8d,%r15d
	xorl	%ecx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r9d,%r15d
	addl	%r12d,%edx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%r8d,%r14d
	addl	%r13d,%edx
	xorl	%r9d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%edx,%r11d
	addl	%edi,%edx
	movl	%r11d,%r13d
	addl	%edx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%edx
	movl	%eax,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r11d,%r13d
	xorl	%ebx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%edx,%r14d
	andl	%r11d,%r12d
	xorl	%r11d,%r13d
	addl	20(%rsp),%ecx
	movl	%edx,%edi
	xorl	%ebx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r8d,%edi
	addl	%r12d,%ecx
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%edx,%r14d
	addl	%r13d,%ecx
	xorl	%r8d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%ecx,%r10d
	addl	%r15d,%ecx
	movl	%r10d,%r13d
	addl	%ecx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ecx
	movl	%r11d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r10d,%r13d
	xorl	%eax,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ecx,%r14d
	andl	%r10d,%r12d
	xorl	%r10d,%r13d
	addl	24(%rsp),%ebx
	movl	%ecx,%r15d
	xorl	%eax,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%edx,%r15d
	addl	%r12d,%ebx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%ecx,%r14d
	addl	%r13d,%ebx
	xorl	%edx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%ebx,%r9d
	addl	%edi,%ebx
	movl	%r9d,%r13d
	addl	%ebx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ebx
	movl	%r10d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r9d,%r13d
	xorl	%r11d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ebx,%r14d
	andl	%r9d,%r12d
	xorl	%r9d,%r13d
	addl	28(%rsp),%eax
	movl	%ebx,%edi
	xorl	%r11d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ecx,%edi
	addl	%r12d,%eax
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%ebx,%r14d
	addl	%r13d,%eax
	xorl	%ecx,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%eax,%r8d
	addl	%r15d,%eax
	movl	%r8d,%r13d
	addl	%eax,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%eax
	movl	%r9d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r8d,%r13d
	xorl	%r10d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%eax,%r14d
	andl	%r8d,%r12d
	xorl	%r8d,%r13d
	addl	32(%rsp),%r11d
	movl	%eax,%r15d
	xorl	%r10d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ebx,%r15d
	addl	%r12d,%r11d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%eax,%r14d
	addl	%r13d,%r11d
	xorl	%ebx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r11d,%edx
	addl	%edi,%r11d
	movl	%edx,%r13d
	addl	%r11d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r11d
	movl	%r8d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%edx,%r13d
	xorl	%r9d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r11d,%r14d
	andl	%edx,%r12d
	xorl	%edx,%r13d
	addl	36(%rsp),%r10d
	movl	%r11d,%edi
	xorl	%r9d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%eax,%edi
	addl	%r12d,%r10d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r11d,%r14d
	addl	%r13d,%r10d
	xorl	%eax,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r10d,%ecx
	addl	%r15d,%r10d
	movl	%ecx,%r13d
	addl	%r10d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r10d
	movl	%edx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ecx,%r13d
	xorl	%r8d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r10d,%r14d
	andl	%ecx,%r12d
	xorl	%ecx,%r13d
	addl	40(%rsp),%r9d
	movl	%r10d,%r15d
	xorl	%r8d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r11d,%r15d
	addl	%r12d,%r9d
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%r10d,%r14d
	addl	%r13d,%r9d
	xorl	%r11d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%r9d,%ebx
	addl	%edi,%r9d
	movl	%ebx,%r13d
	addl	%r9d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r9d
	movl	%ecx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%ebx,%r13d
	xorl	%edx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r9d,%r14d
	andl	%ebx,%r12d
	xorl	%ebx,%r13d
	addl	44(%rsp),%r8d
	movl	%r9d,%edi
	xorl	%edx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r10d,%edi
	addl	%r12d,%r8d
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%r9d,%r14d
	addl	%r13d,%r8d
	xorl	%r10d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%r8d,%eax
	addl	%r15d,%r8d
	movl	%eax,%r13d
	addl	%r8d,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%r8d
	movl	%ebx,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%eax,%r13d
	xorl	%ecx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%r8d,%r14d
	andl	%eax,%r12d
	xorl	%eax,%r13d
	addl	48(%rsp),%edx
	movl	%r8d,%r15d
	xorl	%ecx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r9d,%r15d
	addl	%r12d,%edx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%r8d,%r14d
	addl	%r13d,%edx
	xorl	%r9d,%edi
	shrdl	$2,%r14d,%r14d
	addl	%edx,%r11d
	addl	%edi,%edx
	movl	%r11d,%r13d
	addl	%edx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%edx
	movl	%eax,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r11d,%r13d
	xorl	%ebx,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%edx,%r14d
	andl	%r11d,%r12d
	xorl	%r11d,%r13d
	addl	52(%rsp),%ecx
	movl	%edx,%edi
	xorl	%ebx,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%r8d,%edi
	addl	%r12d,%ecx
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%edx,%r14d
	addl	%r13d,%ecx
	xorl	%r8d,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%ecx,%r10d
	addl	%r15d,%ecx
	movl	%r10d,%r13d
	addl	%ecx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ecx
	movl	%r11d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r10d,%r13d
	xorl	%eax,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ecx,%r14d
	andl	%r10d,%r12d
	xorl	%r10d,%r13d
	addl	56(%rsp),%ebx
	movl	%ecx,%r15d
	xorl	%eax,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%edx,%r15d
	addl	%r12d,%ebx
	shrdl	$6,%r13d,%r13d
	andl	%r15d,%edi
	xorl	%ecx,%r14d
	addl	%r13d,%ebx
	xorl	%edx,%edi
	shrdl	$2,%r14d,%r14d
	addl	%ebx,%r9d
	addl	%edi,%ebx
	movl	%r9d,%r13d
	addl	%ebx,%r14d
	shrdl	$14,%r13d,%r13d
	movl	%r14d,%ebx
	movl	%r10d,%r12d
	shrdl	$9,%r14d,%r14d
	xorl	%r9d,%r13d
	xorl	%r11d,%r12d
	shrdl	$5,%r13d,%r13d
	xorl	%ebx,%r14d
	andl	%r9d,%r12d
	xorl	%r9d,%r13d
	addl	60(%rsp),%eax
	movl	%ebx,%edi
	xorl	%r11d,%r12d
	shrdl	$11,%r14d,%r14d
	xorl	%ecx,%edi
	addl	%r12d,%eax
	shrdl	$6,%r13d,%r13d
	andl	%edi,%r15d
	xorl	%ebx,%r14d
	addl	%r13d,%eax
	xorl	%ecx,%r15d
	shrdl	$2,%r14d,%r14d
	addl	%eax,%r8d
	addl	%r15d,%eax
	movl	%r8d,%r13d
	addl	%eax,%r14d
	movq	64+0(%rsp),%rdi
	movl	%r14d,%eax

	addl	0(%rdi),%eax
	leaq	64(%rsi),%rsi
	addl	4(%rdi),%ebx
	addl	8(%rdi),%ecx
	addl	12(%rdi),%edx
	addl	16(%rdi),%r8d
	addl	20(%rdi),%r9d
	addl	24(%rdi),%r10d
	addl	28(%rdi),%r11d

	cmpq	64+16(%rsp),%rsi

	movl	%eax,0(%rdi)
	movl	%ebx,4(%rdi)
	movl	%ecx,8(%rdi)
	movl	%edx,12(%rdi)
	movl	%r8d,16(%rdi)
	movl	%r9d,20(%rdi)
	movl	%r10d,24(%rdi)
	movl	%r11d,28(%rdi)
	jb	.Lloop_avx

	movq	88(%rsp),%rsi
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
.Lepilogue_avx:
	.byte	0xf3,0xc3
.cfi_endproc
ENDPROC(sha2_256_cryptogams_avx_xform_le)
#endif
