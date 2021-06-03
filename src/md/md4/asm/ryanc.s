#include "../../../common/built.S"
#ifdef STUBBED
STUB(md4_ryanc_xform)
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

#ifdef ADD3
#undef ADD3
#endif

#if 10
#define ADD3(ic, ra, rd) \
	add $ic, rd; \
	add ra, rd
#else
#define ADD3(ic, ra, rd) \
	lea ic(rd,ra), rd
#endif

#define ROUND_F(r, a, b, c, d, p, s) \
CONCAT(f,r): \
	mov p*4(%rsi), %RT0; \
	mov %RXC, %RT1
	xor %RXD, %RT1
	and %RXB, %RT1
	xor %RXD, %RT1
	xor %RXD, %RXC
	and %RXC, %RXB

#define ROUND_G(r, a, b, c, d, p, s) \
CONCAT(g,r): \
	IF(MOD0(r,16))(mov %RXD, %RT1;) \
	IF(MOD0(r,16))(mov %RXD, %RT2;) \
	not %RT1; \
	and %b, %RT2; \
	ADD3(t, %RT0, %a); \
	and %c, %RT1; \
	mov kn*4(%rsi), %RT0; \
	or %RT1, %RT2; \
	mov %c, %RT1; \
	add %RT2, %a; \
	mov %c, %RT2; \
	rol $s, %a; \
	add %b, %a;

#define ROUND_H(r, a, b, c, d, p, s) \
CONCAT(h,r): \
	IF(MOD0(r,16))(mov %RXC, %RT1;) \
	ADD3(t, %RT0, %a); \
	xor %d, %RT1; \
	mov kn*4(%rsi), %RT0; \
	xor %b, %RT1; \
	add %RT1, %a; \
	IF_ELSE(MOD(r,2))(rol $s COMMA() %a;,    mov %b COMMA() %RT1;) \
	IF_ELSE(MOD(r,2))(mov %b COMMA() %RT1;, rol $s COMMA() %a;) \
	add %b, %a;

/* void md4_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(md4_ryanc_xform)
save:
	/* Save registers */
	IF(SAME_REG(RT2,r12d))(movq %r12, %xmm0)
	IF(SAME_REG(RXB,ebx))(movq %rbx, %xmm1)
	IF(SAME_REG(END,r13))(movq %r13, %xmm2)

adjust:
	shl $6, %rdx
	add %rsi, %rdx
	IF(DIFF_REG(END,rdx))(mov %rdx, %END)
//	lea (%rsi,%END,1), %END
//	cmp %rsi, %END
//	je ret


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
ENDPROC(md4_ryanc_xform)
#endif
