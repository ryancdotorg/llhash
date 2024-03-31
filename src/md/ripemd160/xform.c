// SPDX-License-Identifier: 0BSD OR OR MIT-0 OR CC0-1.0+
// Copyright (c) 2022, Ryan Castellucci, no rights reserved
// RIPEMD160 implemetation, transform only

#include <stdint.h>

#include "../../../macros.h"

#define F(x, y, z) ((x) ^ (y) ^ (z))

#define G1(x, y, z) (((y) & (x)) | ((z) & ~(x)))
#define G2(x, y, z) (((y) & (x)) + ((z) & ~(x)))
#define G3(x, y, z) ((((y) ^ (z)) & (x)) ^ (z))

#define H(x, y, z) (((x) | ~(y)) ^ (z))

#define I1(x, y, z) G1(z, x, y)
#define I2(x, y, z) G2(z, x, y)
#define I3(x, y, z) G3(z, x, y)

#define J(x, y, z) H(y, z, x)

#ifdef __BMI2__
#define G(x, y, z) G3(x, y, z)
#define I(x, y, z) I2(x, y, z)
#else
#define G(x, y, z) G3(x, y, z)
#define I(x, y, z) I3(x, y, z)
#endif

#define RND(FN, R, LR, A, B, C, D, E, W, K, S) {    \
  A = ROL32(A + FN(B, C, D) + W + K, S) + E; \
  C = ROL32(C, 10);                          \
}

#define RMD1L(R, A, B, C, D, E, W, S) RND(F, R, "L", A, B, C, D, E, W, 0x00000000, S)
#define RMD2L(R, A, B, C, D, E, W, S) RND(G, R, "L", A, B, C, D, E, W, 0x5A827999, S)
#define RMD3L(R, A, B, C, D, E, W, S) RND(H, R, "L", A, B, C, D, E, W, 0x6ED9EBA1, S)
#define RMD4L(R, A, B, C, D, E, W, S) RND(I, R, "L", A, B, C, D, E, W, 0x8F1BBCDC, S)
#define RMD5L(R, A, B, C, D, E, W, S) RND(J, R, "L", A, B, C, D, E, W, 0xA953FD4E, S)

#define RMD1R(R, A, B, C, D, E, W, S) RND(J, R, "R", A, B, C, D, E, W, 0x50A28BE6, S)
#define RMD2R(R, A, B, C, D, E, W, S) RND(I, R, "R", A, B, C, D, E, W, 0x5C4DD124, S)
#define RMD3R(R, A, B, C, D, E, W, S) RND(H, R, "R", A, B, C, D, E, W, 0x6D703EF3, S)
#define RMD4R(R, A, B, C, D, E, W, S) RND(G, R, "R", A, B, C, D, E, W, 0x7A6D76E9, S)
#define RMD5R(R, A, B, C, D, E, W, S) RND(F, R, "R", A, B, C, D, E, W, 0x00000000, S)

#if !(defined(__wasm) || defined(__wasm__) || defined(__WASM__))
int JOIN(ripemd160,c_impl,xform,built)() { return 1; }
#endif
#pragma GCC push_options
//#pragma GCC optimize ("-fno-schedule-insns")
#pragma GCC optimize ("-fno-schedule-insns2")
void JOIN(ripemd160,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input = (uint32_t*)data;
  uint32_t t, a1, b1, c1, d1, e1, a2, b2, c2, d2, e2;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = U32H2LE(input[i]);
#else
    const uint32_t *W = input;
#endif

    a1 = a2 = digest[0];
    b1 = b2 = digest[1];
    c1 = c2 = digest[2];
    d1 = d2 = digest[3];
    e1 = e2 = digest[4];

    RMD1L( 0, a1, b1, c1, d1, e1, W[ 0], 11); RMD1R( 0, a2, b2, c2, d2, e2, W[ 5],  8);
    RMD1L( 1, e1, a1, b1, c1, d1, W[ 1], 14); RMD1R( 1, e2, a2, b2, c2, d2, W[14],  9);
    RMD1L( 2, d1, e1, a1, b1, c1, W[ 2], 15); RMD1R( 2, d2, e2, a2, b2, c2, W[ 7],  9);
    RMD1L( 3, c1, d1, e1, a1, b1, W[ 3], 12); RMD1R( 3, c2, d2, e2, a2, b2, W[ 0], 11);
    RMD1L( 4, b1, c1, d1, e1, a1, W[ 4],  5); RMD1R( 4, b2, c2, d2, e2, a2, W[ 9], 13);
    RMD1L( 5, a1, b1, c1, d1, e1, W[ 5],  8); RMD1R( 5, a2, b2, c2, d2, e2, W[ 2], 15);
    RMD1L( 6, e1, a1, b1, c1, d1, W[ 6],  7); RMD1R( 6, e2, a2, b2, c2, d2, W[11], 15);
    RMD1L( 7, d1, e1, a1, b1, c1, W[ 7],  9); RMD1R( 7, d2, e2, a2, b2, c2, W[ 4],  5);
    RMD1L( 8, c1, d1, e1, a1, b1, W[ 8], 11); RMD1R( 8, c2, d2, e2, a2, b2, W[13],  7);
    RMD1L( 9, b1, c1, d1, e1, a1, W[ 9], 13); RMD1R( 9, b2, c2, d2, e2, a2, W[ 6],  7);
    RMD1L(10, a1, b1, c1, d1, e1, W[10], 14); RMD1R(10, a2, b2, c2, d2, e2, W[15],  8);
    RMD1L(11, e1, a1, b1, c1, d1, W[11], 15); RMD1R(11, e2, a2, b2, c2, d2, W[ 8], 11);
    RMD1L(12, d1, e1, a1, b1, c1, W[12],  6); RMD1R(12, d2, e2, a2, b2, c2, W[ 1], 14);
    RMD1L(13, c1, d1, e1, a1, b1, W[13],  7); RMD1R(13, c2, d2, e2, a2, b2, W[10], 14);
    RMD1L(14, b1, c1, d1, e1, a1, W[14],  9); RMD1R(14, b2, c2, d2, e2, a2, W[ 3], 12);
    RMD1L(15, a1, b1, c1, d1, e1, W[15],  8); RMD1R(15, a2, b2, c2, d2, e2, W[12],  6);

    RMD2L(16, e1, a1, b1, c1, d1, W[ 7],  7); RMD2R(16, e2, a2, b2, c2, d2, W[ 6],  9);
    RMD2L(17, d1, e1, a1, b1, c1, W[ 4],  6); RMD2R(17, d2, e2, a2, b2, c2, W[11], 13);
    RMD2L(18, c1, d1, e1, a1, b1, W[13],  8); RMD2R(18, c2, d2, e2, a2, b2, W[ 3], 15);
    RMD2L(19, b1, c1, d1, e1, a1, W[ 1], 13); RMD2R(19, b2, c2, d2, e2, a2, W[ 7],  7);
    RMD2L(20, a1, b1, c1, d1, e1, W[10], 11); RMD2R(20, a2, b2, c2, d2, e2, W[ 0], 12);
    RMD2L(21, e1, a1, b1, c1, d1, W[ 6],  9); RMD2R(21, e2, a2, b2, c2, d2, W[13],  8);
    RMD2L(22, d1, e1, a1, b1, c1, W[15],  7); RMD2R(22, d2, e2, a2, b2, c2, W[ 5],  9);
    RMD2L(23, c1, d1, e1, a1, b1, W[ 3], 15); RMD2R(23, c2, d2, e2, a2, b2, W[10], 11);
    RMD2L(24, b1, c1, d1, e1, a1, W[12],  7); RMD2R(24, b2, c2, d2, e2, a2, W[14],  7);
    RMD2L(25, a1, b1, c1, d1, e1, W[ 0], 12); RMD2R(25, a2, b2, c2, d2, e2, W[15],  7);
    RMD2L(26, e1, a1, b1, c1, d1, W[ 9], 15); RMD2R(26, e2, a2, b2, c2, d2, W[ 8], 12);
    RMD2L(27, d1, e1, a1, b1, c1, W[ 5],  9); RMD2R(27, d2, e2, a2, b2, c2, W[12],  7);
    RMD2L(28, c1, d1, e1, a1, b1, W[ 2], 11); RMD2R(28, c2, d2, e2, a2, b2, W[ 4],  6);
    RMD2L(29, b1, c1, d1, e1, a1, W[14],  7); RMD2R(29, b2, c2, d2, e2, a2, W[ 9], 15);
    RMD2L(30, a1, b1, c1, d1, e1, W[11], 13); RMD2R(30, a2, b2, c2, d2, e2, W[ 1], 13);
    RMD2L(31, e1, a1, b1, c1, d1, W[ 8], 12); RMD2R(31, e2, a2, b2, c2, d2, W[ 2], 11);

    RMD3L(32, d1, e1, a1, b1, c1, W[ 3], 11); RMD3R(32, d2, e2, a2, b2, c2, W[15],  9);
    RMD3L(33, c1, d1, e1, a1, b1, W[10], 13); RMD3R(33, c2, d2, e2, a2, b2, W[ 5],  7);
    RMD3L(34, b1, c1, d1, e1, a1, W[14],  6); RMD3R(34, b2, c2, d2, e2, a2, W[ 1], 15);
    RMD3L(35, a1, b1, c1, d1, e1, W[ 4],  7); RMD3R(35, a2, b2, c2, d2, e2, W[ 3], 11);
    RMD3L(36, e1, a1, b1, c1, d1, W[ 9], 14); RMD3R(36, e2, a2, b2, c2, d2, W[ 7],  8);
    RMD3L(37, d1, e1, a1, b1, c1, W[15],  9); RMD3R(37, d2, e2, a2, b2, c2, W[14],  6);
    RMD3L(38, c1, d1, e1, a1, b1, W[ 8], 13); RMD3R(38, c2, d2, e2, a2, b2, W[ 6],  6);
    RMD3L(39, b1, c1, d1, e1, a1, W[ 1], 15); RMD3R(39, b2, c2, d2, e2, a2, W[ 9], 14);
    RMD3L(40, a1, b1, c1, d1, e1, W[ 2], 14); RMD3R(40, a2, b2, c2, d2, e2, W[11], 12);
    RMD3L(41, e1, a1, b1, c1, d1, W[ 7],  8); RMD3R(41, e2, a2, b2, c2, d2, W[ 8], 13);
    RMD3L(42, d1, e1, a1, b1, c1, W[ 0], 13); RMD3R(42, d2, e2, a2, b2, c2, W[12],  5);
    RMD3L(43, c1, d1, e1, a1, b1, W[ 6],  6); RMD3R(43, c2, d2, e2, a2, b2, W[ 2], 14);
    RMD3L(44, b1, c1, d1, e1, a1, W[13],  5); RMD3R(44, b2, c2, d2, e2, a2, W[10], 13);
    RMD3L(45, a1, b1, c1, d1, e1, W[11], 12); RMD3R(45, a2, b2, c2, d2, e2, W[ 0], 13);
    RMD3L(46, e1, a1, b1, c1, d1, W[ 5],  7); RMD3R(46, e2, a2, b2, c2, d2, W[ 4],  7);
    RMD3L(47, d1, e1, a1, b1, c1, W[12],  5); RMD3R(47, d2, e2, a2, b2, c2, W[13],  5);

    RMD4L(48, c1, d1, e1, a1, b1, W[ 1], 11); RMD4R(48, c2, d2, e2, a2, b2, W[ 8], 15);
    RMD4L(49, b1, c1, d1, e1, a1, W[ 9], 12); RMD4R(49, b2, c2, d2, e2, a2, W[ 6],  5);
    RMD4L(50, a1, b1, c1, d1, e1, W[11], 14); RMD4R(50, a2, b2, c2, d2, e2, W[ 4],  8);
    RMD4L(51, e1, a1, b1, c1, d1, W[10], 15); RMD4R(51, e2, a2, b2, c2, d2, W[ 1], 11);
    RMD4L(52, d1, e1, a1, b1, c1, W[ 0], 14); RMD4R(52, d2, e2, a2, b2, c2, W[ 3], 14);
    RMD4L(53, c1, d1, e1, a1, b1, W[ 8], 15); RMD4R(53, c2, d2, e2, a2, b2, W[11], 14);
    RMD4L(54, b1, c1, d1, e1, a1, W[12],  9); RMD4R(54, b2, c2, d2, e2, a2, W[15],  6);
    RMD4L(55, a1, b1, c1, d1, e1, W[ 4],  8); RMD4R(55, a2, b2, c2, d2, e2, W[ 0], 14);
    RMD4L(56, e1, a1, b1, c1, d1, W[13],  9); RMD4R(56, e2, a2, b2, c2, d2, W[ 5],  6);
    RMD4L(57, d1, e1, a1, b1, c1, W[ 3], 14); RMD4R(57, d2, e2, a2, b2, c2, W[12],  9);
    RMD4L(58, c1, d1, e1, a1, b1, W[ 7],  5); RMD4R(58, c2, d2, e2, a2, b2, W[ 2], 12);
    RMD4L(59, b1, c1, d1, e1, a1, W[15],  6); RMD4R(59, b2, c2, d2, e2, a2, W[13],  9);
    RMD4L(60, a1, b1, c1, d1, e1, W[14],  8); RMD4R(60, a2, b2, c2, d2, e2, W[ 9], 12);
    RMD4L(61, e1, a1, b1, c1, d1, W[ 5],  6); RMD4R(61, e2, a2, b2, c2, d2, W[ 7],  5);
    RMD4L(62, d1, e1, a1, b1, c1, W[ 6],  5); RMD4R(62, d2, e2, a2, b2, c2, W[10], 15);
    RMD4L(63, c1, d1, e1, a1, b1, W[ 2], 12); RMD4R(63, c2, d2, e2, a2, b2, W[14],  8);

    RMD5L(64, b1, c1, d1, e1, a1, W[ 4],  9); RMD5R(64, b2, c2, d2, e2, a2, W[12],  8);
    RMD5L(65, a1, b1, c1, d1, e1, W[ 0], 15); RMD5R(65, a2, b2, c2, d2, e2, W[15],  5);
    RMD5L(66, e1, a1, b1, c1, d1, W[ 5],  5); RMD5R(66, e2, a2, b2, c2, d2, W[10], 12);
    RMD5L(67, d1, e1, a1, b1, c1, W[ 9], 11); RMD5R(67, d2, e2, a2, b2, c2, W[ 4],  9);
    RMD5L(68, c1, d1, e1, a1, b1, W[ 7],  6); RMD5R(68, c2, d2, e2, a2, b2, W[ 1], 12);
    RMD5L(69, b1, c1, d1, e1, a1, W[12],  8); RMD5R(69, b2, c2, d2, e2, a2, W[ 5],  5);
    RMD5L(70, a1, b1, c1, d1, e1, W[ 2], 13); RMD5R(70, a2, b2, c2, d2, e2, W[ 8], 14);
    RMD5L(71, e1, a1, b1, c1, d1, W[10], 12); RMD5R(71, e2, a2, b2, c2, d2, W[ 7],  6);
    RMD5L(72, d1, e1, a1, b1, c1, W[14],  5); RMD5R(72, d2, e2, a2, b2, c2, W[ 6],  8);
    RMD5L(73, c1, d1, e1, a1, b1, W[ 1], 12); RMD5R(73, c2, d2, e2, a2, b2, W[ 2], 13);
    RMD5L(74, b1, c1, d1, e1, a1, W[ 3], 13); RMD5R(74, b2, c2, d2, e2, a2, W[13],  6);
    RMD5L(75, a1, b1, c1, d1, e1, W[ 8], 14); RMD5R(75, a2, b2, c2, d2, e2, W[14],  5);
    RMD5L(76, e1, a1, b1, c1, d1, W[11], 11); RMD5R(76, e2, a2, b2, c2, d2, W[ 0], 15);
    RMD5L(77, d1, e1, a1, b1, c1, W[ 6],  8); RMD5R(77, d2, e2, a2, b2, c2, W[ 3], 13);
    RMD5L(78, c1, d1, e1, a1, b1, W[15],  5); RMD5R(78, c2, d2, e2, a2, b2, W[ 9], 11);
    RMD5L(79, b1, c1, d1, e1, a1, W[13],  6); RMD5R(79, b2, c2, d2, e2, a2, W[11], 11);

    t = digest[0];
    digest[0] = digest[1] + c1 + d2;
    digest[1] = digest[2] + d1 + e2;
    digest[2] = digest[3] + e1 + a2;
    digest[3] = digest[4] + a1 + b2;
    digest[4] = t + b1 + c2;
  }
}
#pragma GCC pop_options
