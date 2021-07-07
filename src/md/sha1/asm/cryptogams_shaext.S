#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha1_cryptogams_shaext_xform)
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


ENTRY(sha1_cryptogams_shaext_xform)
.cfi_startproc
	movdqu	(%rdi),%xmm0
	movd	16(%rdi),%xmm1
	movdqa	K_XX_XX+160(%rip),%xmm3

	movdqu	(%rsi),%xmm4
	pshufd	$27,%xmm0,%xmm0
	movdqu	16(%rsi),%xmm5
	pshufd	$27,%xmm1,%xmm1
	movdqu	32(%rsi),%xmm6
	pshufb	%xmm3,%xmm4
	movdqu	48(%rsi),%xmm7
	pshufb	%xmm3,%xmm5
	pshufb	%xmm3,%xmm6
	movdqa	%xmm1,%xmm9
	pshufb	%xmm3,%xmm7
	jmp	.Loop_shaext

.align	16
.Loop_shaext:
	decq	%rdx
	leaq	64(%rsi),%r8
	paddd	%xmm4,%xmm1
	cmovneq	%r8,%rsi
	movdqa	%xmm0,%xmm8
	sha1msg1	%xmm5,%xmm4
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x0,%xmm1,%xmm0
	sha1nexte	%xmm5,%xmm2
	pxor	%xmm6,%xmm4
	sha1msg1	%xmm6,%xmm5
	sha1msg2	%xmm7,%xmm4

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x0,%xmm2,%xmm0
	sha1nexte	%xmm6,%xmm1
	pxor	%xmm7,%xmm5
	sha1msg2	%xmm4,%xmm5
	sha1msg1	%xmm7,%xmm6
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x0,%xmm1,%xmm0
	sha1nexte	%xmm7,%xmm2
	pxor	%xmm4,%xmm6
	sha1msg1	%xmm4,%xmm7
	sha1msg2	%xmm5,%xmm6

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x0,%xmm2,%xmm0
	sha1nexte	%xmm4,%xmm1
	pxor	%xmm5,%xmm7
	sha1msg2	%xmm6,%xmm7
	sha1msg1	%xmm5,%xmm4
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x0,%xmm1,%xmm0
	sha1nexte	%xmm5,%xmm2
	pxor	%xmm6,%xmm4
	sha1msg1	%xmm6,%xmm5
	sha1msg2	%xmm7,%xmm4

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x1,%xmm2,%xmm0
	sha1nexte	%xmm6,%xmm1
	pxor	%xmm7,%xmm5
	sha1msg2	%xmm4,%xmm5
	sha1msg1	%xmm7,%xmm6
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x1,%xmm1,%xmm0
	sha1nexte	%xmm7,%xmm2
	pxor	%xmm4,%xmm6
	sha1msg1	%xmm4,%xmm7
	sha1msg2	%xmm5,%xmm6

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x1,%xmm2,%xmm0
	sha1nexte	%xmm4,%xmm1
	pxor	%xmm5,%xmm7
	sha1msg2	%xmm6,%xmm7
	sha1msg1	%xmm5,%xmm4
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x1,%xmm1,%xmm0
	sha1nexte	%xmm5,%xmm2
	pxor	%xmm6,%xmm4
	sha1msg1	%xmm6,%xmm5
	sha1msg2	%xmm7,%xmm4

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x1,%xmm2,%xmm0
	sha1nexte	%xmm6,%xmm1
	pxor	%xmm7,%xmm5
	sha1msg2	%xmm4,%xmm5
	sha1msg1	%xmm7,%xmm6
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x2,%xmm1,%xmm0
	sha1nexte	%xmm7,%xmm2
	pxor	%xmm4,%xmm6
	sha1msg1	%xmm4,%xmm7
	sha1msg2	%xmm5,%xmm6

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x2,%xmm2,%xmm0
	sha1nexte	%xmm4,%xmm1
	pxor	%xmm5,%xmm7
	sha1msg2	%xmm6,%xmm7
	sha1msg1	%xmm5,%xmm4
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x2,%xmm1,%xmm0
	sha1nexte	%xmm5,%xmm2
	pxor	%xmm6,%xmm4
	sha1msg1	%xmm6,%xmm5
	sha1msg2	%xmm7,%xmm4

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x2,%xmm2,%xmm0
	sha1nexte	%xmm6,%xmm1
	pxor	%xmm7,%xmm5
	sha1msg2	%xmm4,%xmm5
	sha1msg1	%xmm7,%xmm6
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x2,%xmm1,%xmm0
	sha1nexte	%xmm7,%xmm2
	pxor	%xmm4,%xmm6
	sha1msg1	%xmm4,%xmm7
	sha1msg2	%xmm5,%xmm6

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x3,%xmm2,%xmm0
	sha1nexte	%xmm4,%xmm1
	pxor	%xmm5,%xmm7
	sha1msg2	%xmm6,%xmm7
	movdqu	(%rsi),%xmm4
	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x3,%xmm1,%xmm0
	sha1nexte	%xmm5,%xmm2
	movdqu	16(%rsi),%xmm5
	pshufb	%xmm3,%xmm4

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x3,%xmm2,%xmm0
	sha1nexte	%xmm6,%xmm1
	movdqu	32(%rsi),%xmm6
	pshufb	%xmm3,%xmm5

	movdqa	%xmm0,%xmm2
	sha1rnds4	$0x3,%xmm1,%xmm0
	sha1nexte	%xmm7,%xmm2
	movdqu	48(%rsi),%xmm7
	pshufb	%xmm3,%xmm6

	movdqa	%xmm0,%xmm1
	sha1rnds4	$0x3,%xmm2,%xmm0
	sha1nexte	%xmm9,%xmm1
	pshufb	%xmm3,%xmm7

	paddd	%xmm8,%xmm0
	movdqa	%xmm1,%xmm9

	jnz	.Loop_shaext

	pshufd	$27,%xmm0,%xmm0
	pshufd	$27,%xmm1,%xmm1
	movdqu	%xmm0,(%rdi)
	movd	%xmm1,16(%rdi)
	.byte	0xf3,0xc3
.cfi_endproc
ENDPROC(sha1_cryptogams_shaext_xform)
#endif
