// SPDX-License-Identifier: 0BSD OR OR MIT-0 OR CC0-1.0+
// Copyright (c) 2022, Ryan Castellucci, no rights reserved
// SHA1 implemetation, transform only

#include <stdint.h>

#include "../../../macros.h"

// Mixing functions
#define F0(x,y,z) (z ^ (x & (y ^ z)))
#define F1(x,y,z) (x ^ y ^ z)
#define F2(x,y,z) ((x & y) | (z & (x | y)))
#define F3 F1

// Message scheduling
#define W(r) (r<16?W[r]:(W[r&15]=ROL32(W[(r+13)&15]^W[(r+8)&15]^W[(r+2)&15]^W[r&15],1)))

// R0, R1, R2, R3 are the different operations used in SHA1
#define R0(r,a,b,c,d,e) e+=F0(b,c,d)+W(r)+0x5A827999+ROL32(a,5);b=ROL32(b,30);
#define R1(r,a,b,c,d,e) e+=F1(b,c,d)+W(r)+0x6ED9EBA1+ROL32(a,5);b=ROL32(b,30);
#define R2(r,a,b,c,d,e) e+=F2(b,c,d)+W(r)+0x8F1BBCDC+ROL32(a,5);b=ROL32(b,30);
#define R3(r,a,b,c,d,e) e+=F3(b,c,d)+W(r)+0xCA62C1D6+ROL32(a,5);b=ROL32(b,30);

// The conditions should be resolved at compile time
#define P(r,a,b,c,d,e) {                 \
  if (r < 20) {      R0(r,a,b,c,d,e); }  \
  else if (r < 40) { R1(r,a,b,c,d,e); }  \
  else if (r < 60) { R2(r,a,b,c,d,e); }  \
  else {             R3(r,a,b,c,d,e); }  \
}

#define R(r) do {                          \
  if ((r%5) == 0) {      P(r,A,B,C,D,E); } \
  else if ((r%5) == 1) { P(r,E,A,B,C,D); } \
  else if ((r%5) == 2) { P(r,D,E,A,B,C); } \
  else if ((r%5) == 3) { P(r,C,D,E,A,B); } \
  else {                 P(r,B,C,D,E,A); } \
} while(0)

#if !(defined(__wasm) || defined(__wasm__) || defined(__WASM__))
int JOIN(sha1,c_impl,xform,built)() { return 1; }
#endif
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha1,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, E;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
    // load input
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = U32H2BE(input[i]);

    A=digest[0]; B=digest[1]; C=digest[2]; D=digest[3]; E=digest[4];

    R( 0); R( 1); R( 2); R( 3); R( 4); R( 5); R( 6); R( 7); R( 8); R( 9);
    R(10); R(11); R(12); R(13); R(14); R(15); R(16); R(17); R(18); R(19);
    R(20); R(21); R(22); R(23); R(24); R(25); R(26); R(27); R(28); R(29);
    R(30); R(31); R(32); R(33); R(34); R(35); R(36); R(37); R(38); R(39);
    R(40); R(41); R(42); R(43); R(44); R(45); R(46); R(47); R(48); R(49);
    R(50); R(51); R(52); R(53); R(54); R(55); R(56); R(57); R(58); R(59);
    R(60); R(61); R(62); R(63); R(64); R(65); R(66); R(67); R(68); R(69);
    R(70); R(71); R(72); R(73); R(74); R(75); R(76); R(77); R(78); R(79);

    digest[0]+=A; digest[1]+=B; digest[2]+=C; digest[3]+=D; digest[4]+=E;
  }
}

#if !(defined(__wasm) || defined(__wasm__) || defined(__WASM__))
int JOIN(sha1,c_impl,xform_le,built)() { return 1; }
#endif
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha1,c_impl,xform_le)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, E;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
    // load input
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = input[i];

    A=digest[0]; B=digest[1]; C=digest[2]; D=digest[3]; E=digest[4];

    R( 0); R( 1); R( 2); R( 3); R( 4); R( 5); R( 6); R( 7); R( 8); R( 9);
    R(10); R(11); R(12); R(13); R(14); R(15); R(16); R(17); R(18); R(19);
    R(20); R(21); R(22); R(23); R(24); R(25); R(26); R(27); R(28); R(29);
    R(30); R(31); R(32); R(33); R(34); R(35); R(36); R(37); R(38); R(39);
    R(40); R(41); R(42); R(43); R(44); R(45); R(46); R(47); R(48); R(49);
    R(50); R(51); R(52); R(53); R(54); R(55); R(56); R(57); R(58); R(59);
    R(60); R(61); R(62); R(63); R(64); R(65); R(66); R(67); R(68); R(69);
    R(70); R(71); R(72); R(73); R(74); R(75); R(76); R(77); R(78); R(79);

    digest[0]+=A; digest[1]+=B; digest[2]+=C; digest[3]+=D; digest[4]+=E;
  }
}
