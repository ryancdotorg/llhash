// SPDX-License-Identifier: 0BSD OR OR MIT-0 OR Unlicense OR CC0-1.0+
// Copyright (c) 2022, Ryan Castellucci, no rights reserved
// MD4 implemetation, transform only

#include <stdint.h>

#include "../../../macros.h"

// Mixing functions
#define F(b, c, d) (d ^ (b & (c ^ d)))
#define G(b, c, d) ((b & c) | (b & d) | (c & d))
#define H(b, c, d) (b ^ c ^ d)

// Let's make the compiler do a ton of work...
#define S0(r) ((r&3)==0 ?  3 : ((r&3)==1 ?  7 : ((r&3)==2 ? 11 : 19 )))
#define S1(r) ((r&3)==0 ?  3 : ((r&3)==1 ?  5 : ((r&3)==2 ?  9 : 13 )))
#define S2(r) ((r&3)==0 ?  3 : ((r&3)==1 ?  9 : ((r&3)==2 ? 11 : 15 )))

#define R0(r,a,b,c,d,p) a=ROL32(a+F(b,c,d)+W[p]+0x00000000, S0(r));
#define R1(r,a,b,c,d,p) a=ROL32(a+G(b,c,d)+W[p]+0x5a827999, S1(r));
#define R2(r,a,b,c,d,p) a=ROL32(a+H(b,c,d)+W[p]+0x6ed9eba1, S2(r));

#define P(r,a,b,c,d,p) do {            \
  if      (r < 16) { R0(r,a,b,c,d,p) } \
  else if (r < 32) { R1(r,a,b,c,d,p) } \
  else if (r < 48) { R2(r,a,b,c,d,p) } \
} while(0)

#define R(r,p) do {                        \
  if      ((r%4) == 0) { P(r,A,B,C,D,p); } \
  else if ((r%4) == 1) { P(r,D,A,B,C,p); } \
  else if ((r%4) == 2) { P(r,C,D,A,B,p); } \
  else if ((r%4) == 3) { P(r,B,C,D,A,p); } \
} while(0)

#if !(defined(__wasm) || defined(__wasm__) || defined(__WASM__))
int JOIN(md4,c_impl,xform,built)() { return 1; }
#endif
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(md4,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk)
{
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
    // load input
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = U32H2LE(input[i]);
#else
    const uint32_t *W = input;
#endif

    A=digest[0]; B=digest[1]; C=digest[2]; D=digest[3];

    R( 0, 0); R( 1, 1); R( 2, 2); R( 3, 3);
    R( 4, 4); R( 5, 5); R( 6, 6); R( 7, 7);
    R( 8, 8); R( 9, 9); R(10,10); R(11,11);
    R(12,12); R(13,13); R(14,14); R(15,15);

    R(16, 0); R(17, 4); R(18, 8); R(19,12);
    R(20, 1); R(21, 5); R(22, 9); R(23,13);
    R(24, 2); R(25, 6); R(26,10); R(27,14);
    R(28, 3); R(29, 7); R(30,11); R(31,15);

    R(32, 0); R(33, 8); R(34, 4); R(35,12);
    R(36, 2); R(37,10); R(38, 6); R(39,14);
    R(40, 1); R(41, 9); R(42, 5); R(43,13);
    R(44, 3); R(45,11); R(46, 7); R(47,15);

    digest[0]+=A; digest[1]+=B; digest[2]+=C; digest[3]+=D;
  }
}
