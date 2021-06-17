#include <stdint.h>
#include <endian.h>

#include "../../../macros.h"

#define F(x, y, z) ((x) ^ (y) ^ (z))
//#define G(x, y, z) (((x) & (y)) | (~(x) & (z)))
#define G(x, y, z) ((((y) ^ (z)) & (x)) ^ (z))
#define H(x, y, z) (((x) | ~(y)) ^ (z))
#define I(x, y, z) (((x) & (z)) | ((y) & ~(z)))
//define I(x, y, z) (((x) ^ (y)) & (z)) ^ (y))
#define J(x, y, z) (((y) | ~(z)) ^ (x))

#define RND(FN, A, B, C, D, E, W, K, S) {    \
  A = ROL32(A + FN(B, C, D) + W + K, S) + E; \
  C = ROL32(C, 10);                          \
}

#define RMD11(A, B, C, D, E, W, S) RND(F, A, B, C, D, E, W, 0x00000000, S)
#define RMD21(A, B, C, D, E, W, S) RND(G, A, B, C, D, E, W, 0x5A827999, S)
#define RMD31(A, B, C, D, E, W, S) RND(H, A, B, C, D, E, W, 0x6ED9EBA1, S)
#define RMD41(A, B, C, D, E, W, S) RND(I, A, B, C, D, E, W, 0x8F1BBCDC, S)
#define RMD51(A, B, C, D, E, W, S) RND(J, A, B, C, D, E, W, 0xA953FD4E, S)

#define RMD12(A, B, C, D, E, W, S) RND(J, A, B, C, D, E, W, 0x50A28BE6, S)
#define RMD22(A, B, C, D, E, W, S) RND(I, A, B, C, D, E, W, 0x5C4DD124, S)
#define RMD32(A, B, C, D, E, W, S) RND(H, A, B, C, D, E, W, 0x6D703EF3, S)
#define RMD42(A, B, C, D, E, W, S) RND(G, A, B, C, D, E, W, 0x7A6D76E9, S)
#define RMD52(A, B, C, D, E, W, S) RND(F, A, B, C, D, E, W, 0x00000000, S)

int JOIN(ripemd160,c_impl,xform,built)() { return 1; }
#pragma GCC push_options
//#pragma GCC optimize ("-fno-schedule-insns")
#pragma GCC optimize ("-fno-schedule-insns2")
void JOIN(ripemd160,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input = (uint32_t*)data;
  uint32_t t, a1, b1, c1, d1, e1, a2, b2, c2, d2, e2;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = htole32(input[i]);
#else
    const uint32_t *W = input;
#endif

    a1 = a2 = digest[0];
    b1 = b2 = digest[1];
    c1 = c2 = digest[2];
    d1 = d2 = digest[3];
    e1 = e2 = digest[4];

    RMD11(a1, b1, c1, d1, e1, W[ 0], 11); RMD12(a2, b2, c2, d2, e2, W[ 5],  8);
    RMD11(e1, a1, b1, c1, d1, W[ 1], 14); RMD12(e2, a2, b2, c2, d2, W[14],  9);
    RMD11(d1, e1, a1, b1, c1, W[ 2], 15); RMD12(d2, e2, a2, b2, c2, W[ 7],  9);
    RMD11(c1, d1, e1, a1, b1, W[ 3], 12); RMD12(c2, d2, e2, a2, b2, W[ 0], 11);
    RMD11(b1, c1, d1, e1, a1, W[ 4],  5); RMD12(b2, c2, d2, e2, a2, W[ 9], 13);
    RMD11(a1, b1, c1, d1, e1, W[ 5],  8); RMD12(a2, b2, c2, d2, e2, W[ 2], 15);
    RMD11(e1, a1, b1, c1, d1, W[ 6],  7); RMD12(e2, a2, b2, c2, d2, W[11], 15);
    RMD11(d1, e1, a1, b1, c1, W[ 7],  9); RMD12(d2, e2, a2, b2, c2, W[ 4],  5);
    RMD11(c1, d1, e1, a1, b1, W[ 8], 11); RMD12(c2, d2, e2, a2, b2, W[13],  7);
    RMD11(b1, c1, d1, e1, a1, W[ 9], 13); RMD12(b2, c2, d2, e2, a2, W[ 6],  7);
    RMD11(a1, b1, c1, d1, e1, W[10], 14); RMD12(a2, b2, c2, d2, e2, W[15],  8);
    RMD11(e1, a1, b1, c1, d1, W[11], 15); RMD12(e2, a2, b2, c2, d2, W[ 8], 11);
    RMD11(d1, e1, a1, b1, c1, W[12],  6); RMD12(d2, e2, a2, b2, c2, W[ 1], 14);
    RMD11(c1, d1, e1, a1, b1, W[13],  7); RMD12(c2, d2, e2, a2, b2, W[10], 14);
    RMD11(b1, c1, d1, e1, a1, W[14],  9); RMD12(b2, c2, d2, e2, a2, W[ 3], 12);
    RMD11(a1, b1, c1, d1, e1, W[15],  8); RMD12(a2, b2, c2, d2, e2, W[12],  6);

    RMD21(e1, a1, b1, c1, d1, W[ 7],  7); RMD22(e2, a2, b2, c2, d2, W[ 6],  9);
    RMD21(d1, e1, a1, b1, c1, W[ 4],  6); RMD22(d2, e2, a2, b2, c2, W[11], 13);
    RMD21(c1, d1, e1, a1, b1, W[13],  8); RMD22(c2, d2, e2, a2, b2, W[ 3], 15);
    RMD21(b1, c1, d1, e1, a1, W[ 1], 13); RMD22(b2, c2, d2, e2, a2, W[ 7],  7);
    RMD21(a1, b1, c1, d1, e1, W[10], 11); RMD22(a2, b2, c2, d2, e2, W[ 0], 12);
    RMD21(e1, a1, b1, c1, d1, W[ 6],  9); RMD22(e2, a2, b2, c2, d2, W[13],  8);
    RMD21(d1, e1, a1, b1, c1, W[15],  7); RMD22(d2, e2, a2, b2, c2, W[ 5],  9);
    RMD21(c1, d1, e1, a1, b1, W[ 3], 15); RMD22(c2, d2, e2, a2, b2, W[10], 11);
    RMD21(b1, c1, d1, e1, a1, W[12],  7); RMD22(b2, c2, d2, e2, a2, W[14],  7);
    RMD21(a1, b1, c1, d1, e1, W[ 0], 12); RMD22(a2, b2, c2, d2, e2, W[15],  7);
    RMD21(e1, a1, b1, c1, d1, W[ 9], 15); RMD22(e2, a2, b2, c2, d2, W[ 8], 12);
    RMD21(d1, e1, a1, b1, c1, W[ 5],  9); RMD22(d2, e2, a2, b2, c2, W[12],  7);
    RMD21(c1, d1, e1, a1, b1, W[ 2], 11); RMD22(c2, d2, e2, a2, b2, W[ 4],  6);
    RMD21(b1, c1, d1, e1, a1, W[14],  7); RMD22(b2, c2, d2, e2, a2, W[ 9], 15);
    RMD21(a1, b1, c1, d1, e1, W[11], 13); RMD22(a2, b2, c2, d2, e2, W[ 1], 13);
    RMD21(e1, a1, b1, c1, d1, W[ 8], 12); RMD22(e2, a2, b2, c2, d2, W[ 2], 11);

    RMD31(d1, e1, a1, b1, c1, W[ 3], 11); RMD32(d2, e2, a2, b2, c2, W[15],  9);
    RMD31(c1, d1, e1, a1, b1, W[10], 13); RMD32(c2, d2, e2, a2, b2, W[ 5],  7);
    RMD31(b1, c1, d1, e1, a1, W[14],  6); RMD32(b2, c2, d2, e2, a2, W[ 1], 15);
    RMD31(a1, b1, c1, d1, e1, W[ 4],  7); RMD32(a2, b2, c2, d2, e2, W[ 3], 11);
    RMD31(e1, a1, b1, c1, d1, W[ 9], 14); RMD32(e2, a2, b2, c2, d2, W[ 7],  8);
    RMD31(d1, e1, a1, b1, c1, W[15],  9); RMD32(d2, e2, a2, b2, c2, W[14],  6);
    RMD31(c1, d1, e1, a1, b1, W[ 8], 13); RMD32(c2, d2, e2, a2, b2, W[ 6],  6);
    RMD31(b1, c1, d1, e1, a1, W[ 1], 15); RMD32(b2, c2, d2, e2, a2, W[ 9], 14);
    RMD31(a1, b1, c1, d1, e1, W[ 2], 14); RMD32(a2, b2, c2, d2, e2, W[11], 12);
    RMD31(e1, a1, b1, c1, d1, W[ 7],  8); RMD32(e2, a2, b2, c2, d2, W[ 8], 13);
    RMD31(d1, e1, a1, b1, c1, W[ 0], 13); RMD32(d2, e2, a2, b2, c2, W[12],  5);
    RMD31(c1, d1, e1, a1, b1, W[ 6],  6); RMD32(c2, d2, e2, a2, b2, W[ 2], 14);
    RMD31(b1, c1, d1, e1, a1, W[13],  5); RMD32(b2, c2, d2, e2, a2, W[10], 13);
    RMD31(a1, b1, c1, d1, e1, W[11], 12); RMD32(a2, b2, c2, d2, e2, W[ 0], 13);
    RMD31(e1, a1, b1, c1, d1, W[ 5],  7); RMD32(e2, a2, b2, c2, d2, W[ 4],  7);
    RMD31(d1, e1, a1, b1, c1, W[12],  5); RMD32(d2, e2, a2, b2, c2, W[13],  5);

    RMD41(c1, d1, e1, a1, b1, W[ 1], 11); RMD42(c2, d2, e2, a2, b2, W[ 8], 15);
    RMD41(b1, c1, d1, e1, a1, W[ 9], 12); RMD42(b2, c2, d2, e2, a2, W[ 6],  5);
    RMD41(a1, b1, c1, d1, e1, W[11], 14); RMD42(a2, b2, c2, d2, e2, W[ 4],  8);
    RMD41(e1, a1, b1, c1, d1, W[10], 15); RMD42(e2, a2, b2, c2, d2, W[ 1], 11);
    RMD41(d1, e1, a1, b1, c1, W[ 0], 14); RMD42(d2, e2, a2, b2, c2, W[ 3], 14);
    RMD41(c1, d1, e1, a1, b1, W[ 8], 15); RMD42(c2, d2, e2, a2, b2, W[11], 14);
    RMD41(b1, c1, d1, e1, a1, W[12],  9); RMD42(b2, c2, d2, e2, a2, W[15],  6);
    RMD41(a1, b1, c1, d1, e1, W[ 4],  8); RMD42(a2, b2, c2, d2, e2, W[ 0], 14);
    RMD41(e1, a1, b1, c1, d1, W[13],  9); RMD42(e2, a2, b2, c2, d2, W[ 5],  6);
    RMD41(d1, e1, a1, b1, c1, W[ 3], 14); RMD42(d2, e2, a2, b2, c2, W[12],  9);
    RMD41(c1, d1, e1, a1, b1, W[ 7],  5); RMD42(c2, d2, e2, a2, b2, W[ 2], 12);
    RMD41(b1, c1, d1, e1, a1, W[15],  6); RMD42(b2, c2, d2, e2, a2, W[13],  9);
    RMD41(a1, b1, c1, d1, e1, W[14],  8); RMD42(a2, b2, c2, d2, e2, W[ 9], 12);
    RMD41(e1, a1, b1, c1, d1, W[ 5],  6); RMD42(e2, a2, b2, c2, d2, W[ 7],  5);
    RMD41(d1, e1, a1, b1, c1, W[ 6],  5); RMD42(d2, e2, a2, b2, c2, W[10], 15);
    RMD41(c1, d1, e1, a1, b1, W[ 2], 12); RMD42(c2, d2, e2, a2, b2, W[14],  8);

    RMD51(b1, c1, d1, e1, a1, W[ 4],  9); RMD52(b2, c2, d2, e2, a2, W[12],  8);
    RMD51(a1, b1, c1, d1, e1, W[ 0], 15); RMD52(a2, b2, c2, d2, e2, W[15],  5);
    RMD51(e1, a1, b1, c1, d1, W[ 5],  5); RMD52(e2, a2, b2, c2, d2, W[10], 12);
    RMD51(d1, e1, a1, b1, c1, W[ 9], 11); RMD52(d2, e2, a2, b2, c2, W[ 4],  9);
    RMD51(c1, d1, e1, a1, b1, W[ 7],  6); RMD52(c2, d2, e2, a2, b2, W[ 1], 12);
    RMD51(b1, c1, d1, e1, a1, W[12],  8); RMD52(b2, c2, d2, e2, a2, W[ 5],  5);
    RMD51(a1, b1, c1, d1, e1, W[ 2], 13); RMD52(a2, b2, c2, d2, e2, W[ 8], 14);
    RMD51(e1, a1, b1, c1, d1, W[10], 12); RMD52(e2, a2, b2, c2, d2, W[ 7],  6);
    RMD51(d1, e1, a1, b1, c1, W[14],  5); RMD52(d2, e2, a2, b2, c2, W[ 6],  8);
    RMD51(c1, d1, e1, a1, b1, W[ 1], 12); RMD52(c2, d2, e2, a2, b2, W[ 2], 13);
    RMD51(b1, c1, d1, e1, a1, W[ 3], 13); RMD52(b2, c2, d2, e2, a2, W[13],  6);
    RMD51(a1, b1, c1, d1, e1, W[ 8], 14); RMD52(a2, b2, c2, d2, e2, W[14],  5);
    RMD51(e1, a1, b1, c1, d1, W[11], 11); RMD52(e2, a2, b2, c2, d2, W[ 0], 15);
    RMD51(d1, e1, a1, b1, c1, W[ 6],  8); RMD52(d2, e2, a2, b2, c2, W[ 3], 13);
    RMD51(c1, d1, e1, a1, b1, W[15],  5); RMD52(c2, d2, e2, a2, b2, W[ 9], 11);
    RMD51(b1, c1, d1, e1, a1, W[13],  6); RMD52(b2, c2, d2, e2, a2, W[11], 11);

    t = digest[0];
    digest[0] = digest[1] + c1 + d2;
    digest[1] = digest[2] + d1 + e2;
    digest[2] = digest[3] + e1 + a2;
    digest[3] = digest[4] + a1 + b2;
    digest[4] = t + b1 + c2;
  }
}
#pragma GCC pop_options
