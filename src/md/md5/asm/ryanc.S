#include "../../../common/built.S"
#ifdef STUBBED
STUB(md5_ryanc_xform)
#else

//#ifdef CACHE_STATE
#if 0
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

#define END IF_ELSE(SAME_REG(RXD,rdx))(r13,rdx)

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
CONCAT(f,r): \
	IF_EQUAL(r,0)(mov %RXD, %RT1;) \
	xor %c, %RT1; \
	SUM_IRD(t, %RT0, %a); \
	and %b, %RT1; \
	mov kn*4(%rsi), %RT0; \
	xor %d, %RT1; \
	add %RT1, %a; \
	rol $s, %a; \
	IF_NOTEQ(r,15)(mov %c, %RT1;) \
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
CONCAT(g,r): \
	IF_EQUAL(r,16)(mov %RXD, %RT1;) \
	IF_EQUAL(r,16)(mov %RXD, %RT2;) \
	not %RT1; \
	and %b, %RT2; \
	SUM_IRD(t, %RT0, %a); \
	and %c, %RT1; \
	add %RT1, %a; \
	mov kn*4(%rsi), %RT0; \
	IF_NOTEQ(r,31)(mov %c, %RT1;) \
	add %RT2, %a; \
	IF_NOTEQ(r,31)(mov %c, %RT2;) \
	rol $s, %a; \
	add %b, %a;

#define ROUND_H(r, a, b, c, d, kn, s, t) \
CONCAT(h,r): \
	IF_EQUAL(r,32)(mov %RXC, %RT1;) \
	SUM_IRD(t, %RT0, %a); \
	xor %d, %RT1; \
	mov kn*4(%rsi), %RT0; \
	xor %b, %RT1; \
	add %RT1, %a; \
	IF_ELSE(ODD(r))(rol $s COMMA() %a;, IF_NOTEQ(r,47)(mov %b COMMA() %RT1;)) \
	IF_ELSE(ODD(r))(IF_NOTEQ(r,47)(mov %b COMMA() %RT1;), rol $s COMMA() %a;) \
	add %b, %a;

#define ROUND_I(r, a, b, c, d, kn, s, t) \
CONCAT(i,r): \
	IF_EQUAL(r,48)(mov $0xffffffff, %RT1;) \
	IF_EQUAL(r,48)(xor %RXD, %RT1;) \
	SUM_IRD(t, %RT0, %a); \
	or %b, %RT1; \
	IF_NOTEQ(r,63)(mov kn*4(%rsi), %RT0;) \
	xor %c, %RT1; \
	add %RT1, %a; \
	IF_NOTEQ(r,63)(mov $0xffffffff, %RT1;) \
	rol $s, %a; \
	IF_NOTEQ(r,63)(xor %c, %RT1;) \
	add %b, %a;

#define R2A(R, r, k0, s0, t0, k1, s1, t1) \
R(r,      RXA, RXB, RXC, RXD, k0, s0, t0) \
R(INC(r), RXD, RXA, RXB, RXC, k1, s1, t1)

#define R2B(R, r, k0, s0, t0, k1, s1, t1) \
R(r,      RXC, RXD, RXA, RXB, k0, s0, t0) \
R(INC(r), RXB, RXC, RXD, RXA, k1, s1, t1)

/* void md5_ryanc_xform(uint32_t state[static 4], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(md5_ryanc_xform)
save:
	/* Save registers */
	IF(CALLEE_SAVED(RT2))(movq %REG64(RT2), %xmm0)
	IF(CALLEE_SAVED(RXB))(movq %REG64(REG), %xmm1)
	IF(CALLEE_SAVED(END))(movq %REG64(END), %xmm2)

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
	mov  0(%rsi), %RT0  /* first word of block */

	/* 64 rounds of hashing */
	R2A(ROUND_F,  0,  1,  7, -0x28955B88,  2, 12, -0x173848AA)
	R2B(ROUND_F,  2,  3, 17,  0x242070DB,  4, 22, -0x3E423112)
	R2A(ROUND_F,  4,  5,  7, -0x0A83F051,  6, 12,  0x4787C62A)
	R2B(ROUND_F,  6,  7, 17, -0x57CFB9ED,  8, 22, -0x02B96AFF)
	R2A(ROUND_F,  8,  9,  7,  0x698098D8, 10, 12, -0x74BB0851)
	R2B(ROUND_F, 10, 11, 17, -0x0000A44F, 12, 22, -0x76A32842)
	R2A(ROUND_F, 12, 13,  7,  0x6B901122, 14, 12, -0x02678E6D)
	R2B(ROUND_F, 14, 15, 17, -0x5986BC72,  1, 22,  0x49B40821)

	ROUND_G(16, RXA, RXB, RXC, RXD,  6,  5, -0x09E1DA9E)
	ROUND_G(17, RXD, RXA, RXB, RXC, 11,  9, -0x3FBF4CC0)
	ROUND_G(18, RXC, RXD, RXA, RXB,  0, 14,  0x265E5A51)
	ROUND_G(19, RXB, RXC, RXD, RXA,  5, 20, -0x16493856)
	ROUND_G(20, RXA, RXB, RXC, RXD, 10,  5, -0x29D0EFA3)
	ROUND_G(21, RXD, RXA, RXB, RXC, 15,  9,  0x02441453)
	ROUND_G(22, RXC, RXD, RXA, RXB,  4, 14, -0x275E197F)
	ROUND_G(23, RXB, RXC, RXD, RXA,  9, 20, -0x182C0438)
	ROUND_G(24, RXA, RXB, RXC, RXD, 14,  5,  0x21E1CDE6)
	ROUND_G(25, RXD, RXA, RXB, RXC,  3,  9, -0x3CC8F82A)
	ROUND_G(26, RXC, RXD, RXA, RXB,  8, 14, -0x0B2AF279)
	ROUND_G(27, RXB, RXC, RXD, RXA, 13, 20,  0x455A14ED)
	ROUND_G(28, RXA, RXB, RXC, RXD,  2,  5, -0x561C16FB)
	ROUND_G(29, RXD, RXA, RXB, RXC,  7,  9, -0x03105C08)
	ROUND_G(30, RXC, RXD, RXA, RXB, 12, 14,  0x676F02D9)
	ROUND_G(31, RXB, RXC, RXD, RXA,  5, 20, -0x72D5B376)

	ROUND_H(32, RXA, RXB, RXC, RXD,  8,  4, -0x0005C6BE)
	ROUND_H(33, RXD, RXA, RXB, RXC, 11, 11, -0x788E097F)
	ROUND_H(34, RXC, RXD, RXA, RXB, 14, 16,  0x6D9D6122)
	ROUND_H(35, RXB, RXC, RXD, RXA,  1, 23, -0x021AC7F4)
	ROUND_H(36, RXA, RXB, RXC, RXD,  4,  4, -0x5B4115BC)
	ROUND_H(37, RXD, RXA, RXB, RXC,  7, 11,  0x4BDECFA9)
	ROUND_H(38, RXC, RXD, RXA, RXB, 10, 16, -0x0944B4A0)
	ROUND_H(39, RXB, RXC, RXD, RXA, 13, 23, -0x41404390)
	ROUND_H(40, RXA, RXB, RXC, RXD,  0,  4,  0x289B7EC6)
	ROUND_H(41, RXD, RXA, RXB, RXC,  3, 11, -0x155ED806)
	ROUND_H(42, RXC, RXD, RXA, RXB,  6, 16, -0x2B10CF7B)
	ROUND_H(43, RXB, RXC, RXD, RXA,  9, 23,  0x04881D05)
	ROUND_H(44, RXA, RXB, RXC, RXD, 12,  4, -0x262B2FC7)
	ROUND_H(45, RXD, RXA, RXB, RXC, 15, 11, -0x1924661B)
	ROUND_H(46, RXC, RXD, RXA, RXB,  2, 16,  0x1FA27CF8)
	ROUND_H(47, RXB, RXC, RXD, RXA,  0, 23, -0x3B53A99B)

	ROUND_I(48, RXA, RXB, RXC, RXD,  7,  6, -0x0BD6DDBC)
	ROUND_I(49, RXD, RXA, RXB, RXC, 14, 10,  0x432AFF97)
	ROUND_I(50, RXC, RXD, RXA, RXB,  5, 15, -0x546BDC59)
	ROUND_I(51, RXB, RXC, RXD, RXA, 12, 21, -0x036C5FC7)
	ROUND_I(52, RXA, RXB, RXC, RXD,  3,  6,  0x655B59C3)
	ROUND_I(53, RXD, RXA, RXB, RXC, 10, 10, -0x70F3336E)
	ROUND_I(54, RXC, RXD, RXA, RXB,  1, 15, -0x00100B83)
	ROUND_I(55, RXB, RXC, RXD, RXA,  8, 21, -0x7A7BA22F)
	ROUND_I(56, RXA, RXB, RXC, RXD, 15,  6,  0x6FA87E4F)
	ROUND_I(57, RXD, RXA, RXB, RXC,  6, 10, -0x01D31920)
	ROUND_I(58, RXC, RXD, RXA, RXB, 13, 15, -0x5CFEBCEC)
	ROUND_I(59, RXB, RXC, RXD, RXA,  4, 21,  0x4E0811A1)
	ROUND_I(60, RXA, RXB, RXC, RXD, 11,  6, -0x08AC817E)
	ROUND_I(61, RXD, RXA, RXB, RXC,  2, 10, -0x42C50DCB)
	ROUND_I(62, RXC, RXD, RXA, RXB,  9, 15,  0x2AD7D2BB)
	ROUND_I(63, RXB, RXC, RXD, RXA,  _, 21, -0x14792C6F)

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
	IF(CALLEE_SAVED(END))(movq %xmm2, %REG64(END))
	IF(CALLEE_SAVED(RXB))(movq %xmm1, %REG64(REG))
	IF(CALLEE_SAVED(RT2))(movq %xmm0, %REG64(RT2))
	retq
ENDPROC(md5_ryanc_xform)
#endif
