#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha2_256_cryptogams_shaext_xform_le)
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


ENTRY(sha2_256_cryptogams_shaext_xform_le)
.cfi_startproc
	leaq	K256+128(%rip),%rcx
	movdqu	(%rdi),%xmm1
	movdqu	16(%rdi),%xmm2

	pshufd	$0x1b,%xmm1,%xmm0
	pshufd	$0xb1,%xmm1,%xmm1
	pshufd	$0x1b,%xmm2,%xmm2
	palignr	-ex8,%xmm2,%xmm1
	punpcklqdq	%xmm0,%xmm2
	jmp	.Loop_shaext

.align	16
.Loop_shaext:
	movdqu	(%rsi),%xmm3
	movdqu	16(%rsi),%xmm4
	movdqu	32(%rsi),%xmm5
	movdqu	48(%rsi),%xmm6

	movdqa	0-128(%rcx),%xmm0
	paddd	%xmm3,%xmm0
	movdqa	%xmm2,%xmm10
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	nop
	movdqa	%xmm1,%xmm9
	sha256rnds2	%xmm0,%xmm2,%xmm1

	movdqa	32-128(%rcx),%xmm0
	paddd	%xmm4,%xmm0
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	leaq	64(%rsi),%rsi
	sha256msg1	%xmm4,%xmm3
	sha256rnds2	%xmm0,%xmm2,%xmm1

	movdqa	64-128(%rcx),%xmm0
	paddd	%xmm5,%xmm0
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm6,%xmm7
	palignr	-ex4,%xmm5,%xmm7
	nop
	paddd	%xmm7,%xmm3
	sha256msg1	%xmm5,%xmm4
	sha256rnds2	%xmm0,%xmm2,%xmm1

	movdqa	96-128(%rcx),%xmm0
	paddd	%xmm6,%xmm0
	sha256msg2	%xmm6,%xmm3
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm3,%xmm7
	palignr	-ex4,%xmm6,%xmm7
	nop
	paddd	%xmm7,%xmm4
	sha256msg1	%xmm6,%xmm5
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	128-128(%rcx),%xmm0
	paddd	%xmm3,%xmm0
	sha256msg2	%xmm3,%xmm4
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm4,%xmm7
	palignr	-ex4,%xmm3,%xmm7
	nop
	paddd	%xmm7,%xmm5
	sha256msg1	%xmm3,%xmm6
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	160-128(%rcx),%xmm0
	paddd	%xmm4,%xmm0
	sha256msg2	%xmm4,%xmm5
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm5,%xmm7
	palignr	-ex4,%xmm4,%xmm7
	nop
	paddd	%xmm7,%xmm6
	sha256msg1	%xmm4,%xmm3
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	192-128(%rcx),%xmm0
	paddd	%xmm5,%xmm0
	sha256msg2	%xmm5,%xmm6
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm6,%xmm7
	palignr	-ex4,%xmm5,%xmm7
	nop
	paddd	%xmm7,%xmm3
	sha256msg1	%xmm5,%xmm4
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	224-128(%rcx),%xmm0
	paddd	%xmm6,%xmm0
	sha256msg2	%xmm6,%xmm3
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm3,%xmm7
	palignr	-ex4,%xmm6,%xmm7
	nop
	paddd	%xmm7,%xmm4
	sha256msg1	%xmm6,%xmm5
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	256-128(%rcx),%xmm0
	paddd	%xmm3,%xmm0
	sha256msg2	%xmm3,%xmm4
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm4,%xmm7
	palignr	-ex4,%xmm3,%xmm7
	nop
	paddd	%xmm7,%xmm5
	sha256msg1	%xmm3,%xmm6
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	288-128(%rcx),%xmm0
	paddd	%xmm4,%xmm0
	sha256msg2	%xmm4,%xmm5
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm5,%xmm7
	palignr	-ex4,%xmm4,%xmm7
	nop
	paddd	%xmm7,%xmm6
	sha256msg1	%xmm4,%xmm3
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	320-128(%rcx),%xmm0
	paddd	%xmm5,%xmm0
	sha256msg2	%xmm5,%xmm6
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm6,%xmm7
	palignr	-ex4,%xmm5,%xmm7
	nop
	paddd	%xmm7,%xmm3
	sha256msg1	%xmm5,%xmm4
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	352-128(%rcx),%xmm0
	paddd	%xmm6,%xmm0
	sha256msg2	%xmm6,%xmm3
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm3,%xmm7
	palignr	-ex4,%xmm6,%xmm7
	nop
	paddd	%xmm7,%xmm4
	sha256msg1	%xmm6,%xmm5
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	384-128(%rcx),%xmm0
	paddd	%xmm3,%xmm0
	sha256msg2	%xmm3,%xmm4
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm4,%xmm7
	palignr	-ex4,%xmm3,%xmm7
	nop
	paddd	%xmm7,%xmm5
	sha256msg1	%xmm3,%xmm6
	sha256rnds2	%xmm0,%xmm2,%xmm1
	movdqa	416-128(%rcx),%xmm0
	paddd	%xmm4,%xmm0
	sha256msg2	%xmm4,%xmm5
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	movdqa	%xmm5,%xmm7
	palignr	-ex4,%xmm4,%xmm7
	sha256rnds2	%xmm0,%xmm2,%xmm1
	paddd	%xmm7,%xmm6

	movdqa	448-128(%rcx),%xmm0
	paddd	%xmm5,%xmm0
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	sha256msg2	%xmm5,%xmm6
	sha256rnds2	%xmm0,%xmm2,%xmm1

	movdqa	480-128(%rcx),%xmm0
	paddd	%xmm6,%xmm0
	nop
	sha256rnds2	%xmm0,%xmm1,%xmm2
	pshufd	$0x0e,%xmm0,%xmm0
	decq	%rdx
	nop
	sha256rnds2	%xmm0,%xmm2,%xmm1

	paddd	%xmm10,%xmm2
	paddd	%xmm9,%xmm1
	jnz	.Loop_shaext

	pshufd	$0xb1,%xmm2,%xmm2
	pshufd	$0x1b,%xmm1,%xmm7
	pshufd	$0xb1,%xmm1,%xmm1
	punpckhqdq	%xmm2,%xmm1
	palignr	-ex8,%xmm7,%xmm2

	movdqu	%xmm1,(%rdi)
	movdqu	%xmm2,16(%rdi)
	.byte	0xf3,0xc3
.cfi_endproc
ENDPROC(sha2_256_cryptogams_shaext_xform_le)
#endif
