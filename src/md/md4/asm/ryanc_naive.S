#define NAME md4_ryanc_naive
#include "../../../common/built.S"
#ifdef STUBBED
STUB(JOIN(NAME,xform))
#elif !(defined(WITH_RYANC_SLOW))
#error "implementation disabled"
#else

//#ifdef CACHE_STATE
#if 1
#define RXA eax
#define RXB ebx
#define RXC ecx
#define RXD edx
#define RT0 r10d
#define RT1 r11d
#define RT2 r12d
#else
#define RXA eax
#define RXB ecx
#define RXC r8d
#define RXD r9d
#define RT0 r10d
#define RT1 r11d
#define RT2 r12d
#endif

#define END IF_ELSE(SAME_REG(RXD,edx))(r13,rdx)

// rdi  1st arg, Base address of state array argument
// rsi  2nd arg, Base address of block array argument
// rdx  3rd arg, Number of blocks to process

/* a = rol((d ^ (b & (c ^ d))) + w + a, s)
 * =
 * a = a + (d ^ (b & (c ^ d)))
 * a = rol(a, s)
 * =
 * t0 = w
 * t1 = c
 * t1 ^= d : (c ^ d)
 * t1 &= b : (b & (c ^ d))
 * t1 ^= d : (d ^ (b & (c ^ d)))
 * t1 += t0 : (d ^ (b & (c ^ d))) + w
 * a += t1 : (d ^ (b & (c ^ d))) + w + a
 * a = rol(a, s)
 */
#define ROUND_F(r, a, b, c, d, p, s) \
CONCAT(NAME,_f,PAD02(r)): \
	mov p*4(%rsi), %RT0; \
	mov %c, %RT1; \
	xor %d, %RT1; \
	and %b, %RT1; \
	xor %d, %RT1; \
	add %RT0, %RT1; \
	add %RT1, %a; \
	rol $s, %a;

#define ROUND4_F(r, a, b, c, d, p0, s0, p1, s1, p2, s2, p3, s3) \
CONCAT(f4_,r): \
	mov p*4(%rsi), %RT0; \
	mov %c, %RT1; \
	xor %d, %RT1; \
	and %b, %RT1; \
	xor %d, %RT1; \
	add %RT0, %RT1; \
	add %RT1, %a; \
	rol $s, %a;

/* a = rol(((b & c) | (b & d) | (c & d)) + a + w + 0x5a827999, s);
 * t0 = w
 * t1 = d
 * t2 = b
 * t1 &= c : (c & d)
 * t2 &= d : (b & d)
 * t1 |= t2 : ((b & d) | (c & d))
 * t2 = b
 * t2 &= c : (b & c)
 * t1 |= t2 : ((b & c) | ((b & d) | (c & d)))
 * a += 0x5a827999 + t0
 * a += t1
 * a = rol(a, s)
 */
#define ROUND_G(r, a, b, c, d, p, s) \
CONCAT(NAME,_g,PAD02(r)): \
	mov p*4(%rsi), %RT0; \
	mov %d, %RT1; \
	mov %b, %RT2; \
	and %c, %RT1; \
	and %d, %RT2; \
	or %RT2, %RT1; \
	mov %b, %RT2; \
	and %c, %RT2; \
	or %RT2, %RT1; \
	add $0x5a827999, %a; \
	add %RT0, %a; \
	add %RT1, %a; \
	rol $s, %a;

/*
 216:   44 09 fa                or     %r15d,%edx
 219:   21 ca                   and    %ecx,%edx
 21b:   09 d0                   or     %edx,%eax
 21d:   41 8b 52 04             mov    0x4(%r10),%edx
 221:   45 8d b4 16 99 79 82    lea    0x5a827999(%r14,%rdx,1),%r14d
 228:   5a 
 229:   89 ca                   mov    %ecx,%edx
 22b:   41 01 c6                add    %eax,%r14d
 22e:   89 c8                   mov    %ecx,%eax
 230:   21 f2                   and    %esi,%edx
 232:   41 c1 c6 03             rol    $0x3,%r14d

 236:   09 f0                   or     %esi,%eax
 238:   44 21 f0                and    %r14d,%eax
 23b:   09 c2                   or     %eax,%edx
 23d:   41 8b 42 14             mov    0x14(%r10),%eax
 241:   41 8d 84 07 99 79 82    lea    0x5a827999(%r15,%rax,1),%eax
 248:   5a 
 249:   45 89 f7                mov    %r14d,%r15d
 24c:   01 c2                   add    %eax,%edx
 24e:   41 09 cf                or     %ecx,%r15d
 251:   44 89 f0                mov    %r14d,%eax
 254:   c1 c2 05                rol    $0x5,%edx
*/

/* a = rol((b ^ c ^ d)  + a + w + 0x6ed9eba1, s);
 */
#define ROUND_H(r, a, b, c, d, p, s) \
CONCAT(NAME,_h,PAD02(r)): \
	mov p*4(%rsi), %RT0; \
	mov %b, %RT1; \
	xor %c, %RT1; \
	xor %d, %RT1; \
	add $0x6ed9eba1, %a; \
	add %RT0, %a; \
	add %RT1, %a; \
	rol $s, %a;

#define ROUNDS4(R, r, p0, s0, p1, s1, p2, s2, p3, s3) \
R(r,             RXA, RXB, RXC, RXD, p0, s0) \
R(INC(r),        RXD, RXA, RXB, RXC, p1, s1) \
R(INC(INC(r)),   RXC, RXD, RXA, RXB, p2, s2) \
R(INC((INC(r))), RXB, RXC, RXD, RXA, p3, s3)

/* void md4_ryanc_naive_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(JOIN(NAME,xform))
save:
	/* Save registers */
	IF(SAME_REG(RT2,r12d))(movq %r12, %xmm0)
	IF(SAME_REG(RXB,ebx))(movq %rbx, %xmm1)
	IF(SAME_REG(END,r13))(movq %r13, %xmm2)

adjust:
	shl $6, %rdx
	add %rsi, %rdx
	IF(DIFF_REG(END,rdx))(mov %rdx, %END)

load:
	/* Load state */
	mov  0(%rdi), %RXA  /* a */
	mov  4(%rdi), %RXB  /* b */
	mov  8(%rdi), %RXC  /* c */
	mov 12(%rdi), %RXD  /* d */

	/* 48 rounds of hashing */
	ROUND_F( 0, RXA, RXB, RXC, RXD,  0,  3)
	ROUND_F( 1, RXD, RXA, RXB, RXC,  1,  7)
	ROUND_F( 2, RXC, RXD, RXA, RXB,  2, 11)
	ROUND_F( 3, RXB, RXC, RXD, RXA,  3, 19)
	ROUND_F( 4, RXA, RXB, RXC, RXD,  4,  3)
	ROUND_F( 5, RXD, RXA, RXB, RXC,  5,  7)
	ROUND_F( 6, RXC, RXD, RXA, RXB,  6, 11)
	ROUND_F( 7, RXB, RXC, RXD, RXA,  7, 19)
	ROUND_F( 8, RXA, RXB, RXC, RXD,  8,  3)
	ROUND_F( 9, RXD, RXA, RXB, RXC,  9,  7)
	ROUND_F(10, RXC, RXD, RXA, RXB, 10, 11)
	ROUND_F(11, RXB, RXC, RXD, RXA, 11, 19)
	ROUND_F(12, RXA, RXB, RXC, RXD, 12,  3)
	ROUND_F(13, RXD, RXA, RXB, RXC, 13,  7)
	ROUND_F(14, RXC, RXD, RXA, RXB, 14, 11)
	ROUND_F(15, RXB, RXC, RXD, RXA, 15, 19)

	ROUND_G(16, RXA, RXB, RXC, RXD,  0,  3)
	ROUND_G(17, RXD, RXA, RXB, RXC,  4,  5)
	ROUND_G(18, RXC, RXD, RXA, RXB,  8,  9)
	ROUND_G(19, RXB, RXC, RXD, RXA, 12, 13)
	ROUND_G(20, RXA, RXB, RXC, RXD,  1,  3)
	ROUND_G(21, RXD, RXA, RXB, RXC,  5,  5)
	ROUND_G(22, RXC, RXD, RXA, RXB,  9,  9)
	ROUND_G(23, RXB, RXC, RXD, RXA, 13, 13)
	ROUND_G(24, RXA, RXB, RXC, RXD,  2,  3)
	ROUND_G(25, RXD, RXA, RXB, RXC,  6,  5)
	ROUND_G(26, RXC, RXD, RXA, RXB, 10,  9)
	ROUND_G(27, RXB, RXC, RXD, RXA, 14, 13)
	ROUND_G(28, RXA, RXB, RXC, RXD,  3,  3)
	ROUND_G(29, RXD, RXA, RXB, RXC,  7,  5)
	ROUND_G(30, RXC, RXD, RXA, RXB, 11,  9)
	ROUND_G(31, RXB, RXC, RXD, RXA, 15, 13)

	ROUND_H(32, RXA, RXB, RXC, RXD,  0,  3)
	ROUND_H(33, RXD, RXA, RXB, RXC,  8,  9)
	ROUND_H(34, RXC, RXD, RXA, RXB,  4, 11)
	ROUND_H(35, RXB, RXC, RXD, RXA, 12, 15)
	ROUND_H(36, RXA, RXB, RXC, RXD,  2,  3)
	ROUND_H(37, RXD, RXA, RXB, RXC, 10,  9)
	ROUND_H(38, RXC, RXD, RXA, RXB,  6, 11)
	ROUND_H(39, RXB, RXC, RXD, RXA, 14, 15)
	ROUND_H(40, RXA, RXB, RXC, RXD,  1,  3)
	ROUND_H(41, RXD, RXA, RXB, RXC,  9,  9)
	ROUND_H(42, RXC, RXD, RXA, RXB,  5, 11)
	ROUND_H(43, RXB, RXC, RXD, RXA, 13, 15)
	ROUND_H(44, RXA, RXB, RXC, RXD,  3,  3)
	ROUND_H(45, RXD, RXA, RXB, RXC, 11,  9)
	ROUND_H(46, RXC, RXD, RXA, RXB,  7, 11)
	ROUND_H(47, RXB, RXC, RXD, RXA, 15, 15)

update:
	/* Save updated state */
	add %RXA,  0(%rdi)
	add %RXB,  4(%rdi)
	add %RXC,  8(%rdi)
	add %RXD, 12(%rdi)

next:
	/* maybe process another block */
	add  $64, %rsi
	cmp  %rsi, %END
	jne  load

ret:
	/* Restore registers */
	IF(SAME_REG(END,r13))(movq %xmm2, %r13)
	IF(SAME_REG(RXB,ebx))(movq %xmm1, %rbx)
	IF(SAME_REG(RT2,r12d))(movq %xmm0, %r12)
	retq
ENDPROC(JOIN(NAME,xform))
#endif
