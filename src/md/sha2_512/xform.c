/* SPDX-License-Identifier: 0BSD or CC0-1.0 or MIT-0 or Unlicense */
// SHA-512 implemetation, transform only
// Copyright (c) 2021, Ryan Castellucci, No Rights Reserved

#include <stdint.h>
#include <endian.h>

#include "../../../macros.h"

#define S0(x) (ROR64(x, 1) ^ ROR64(x, 8) ^ (x >>  7))   // s0
#define S1(x) (ROR64(x,19) ^ ROR64(x,61) ^ (x >>  6))   // s1

#define S2(x) (ROR64(x,28) ^ ROR64(x,34) ^ ROR64(x,39)) // S0
#define S3(x) (ROR64(x,14) ^ ROR64(x,18) ^ ROR64(x,41)) // S1

#define F0(x,y,z) ((x & y) | (z & (x | y)))   // ch
#define F1(x,y,z) (z ^ (x & (y ^ z)))         // maj

#define W(r) \
(r<16?W[r]:(W[r&15]=S1(W[(r+14)&15])+W[(r+9)&15]+S0(W[(r+1)&15])+W[r&15]))

#define P(r,a,b,c,d,e,f,g,h,K) {           \
  temp = h + S3(e) + F1(e,f,g) + K + W(r); \
  d += temp; h = temp + S2(a) + F0(a,b,c); \
}

#define R(r,K) do {                                \
  if ((r%8) == 0) {      P(r,A,B,C,D,E,F,G,H,K); } \
  else if ((r%8) == 1) { P(r,H,A,B,C,D,E,F,G,K); } \
  else if ((r%8) == 2) { P(r,G,H,A,B,C,D,E,F,K); } \
  else if ((r%8) == 3) { P(r,F,G,H,A,B,C,D,E,K); } \
  else if ((r%8) == 4) { P(r,E,F,G,H,A,B,C,D,K); } \
  else if ((r%8) == 5) { P(r,D,E,F,G,H,A,B,C,K); } \
  else if ((r%8) == 6) { P(r,C,D,E,F,G,H,A,B,K); } \
  else {                 P(r,B,C,D,E,F,G,H,A,K); } \
} while(0)

int JOIN(sha2_512,c_impl,xform,built)() { return 1; }
// Process input in chunks of 128 bytes, caller resposible for padding
void JOIN(sha2_512,c_impl,xform)(uint64_t *digest, const char *data, uint32_t nblk) {
  const uint64_t *input=(uint64_t *)data;
  uint64_t temp, W[16];
  uint64_t A, B, C, D, E, F, G, H;

  for (const uint64_t *end=input+nblk*16; input < end; input += 16) {
    // Load input
    for (int i=0; i < 16; ++i) W[i] = htobe64(input[i]);

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    R( 0,0x428a2f98d728ae22); R( 1,0x7137449123ef65cd);
    R( 2,0xb5c0fbcfec4d3b2f); R( 3,0xe9b5dba58189dbbc);
    R( 4,0x3956c25bf348b538); R( 5,0x59f111f1b605d019);
    R( 6,0x923f82a4af194f9b); R( 7,0xab1c5ed5da6d8118);
    R( 8,0xd807aa98a3030242); R( 9,0x12835b0145706fbe);
    R(10,0x243185be4ee4b28c); R(11,0x550c7dc3d5ffb4e2);
    R(12,0x72be5d74f27b896f); R(13,0x80deb1fe3b1696b1);
    R(14,0x9bdc06a725c71235); R(15,0xc19bf174cf692694);
    R(16,0xe49b69c19ef14ad2); R(17,0xefbe4786384f25e3);
    R(18,0x0fc19dc68b8cd5b5); R(19,0x240ca1cc77ac9c65);
    R(20,0x2de92c6f592b0275); R(21,0x4a7484aa6ea6e483);
    R(22,0x5cb0a9dcbd41fbd4); R(23,0x76f988da831153b5);
    R(24,0x983e5152ee66dfab); R(25,0xa831c66d2db43210);
    R(26,0xb00327c898fb213f); R(27,0xbf597fc7beef0ee4);
    R(28,0xc6e00bf33da88fc2); R(29,0xd5a79147930aa725);
    R(30,0x06ca6351e003826f); R(31,0x142929670a0e6e70);
    R(32,0x27b70a8546d22ffc); R(33,0x2e1b21385c26c926);
    R(34,0x4d2c6dfc5ac42aed); R(35,0x53380d139d95b3df);
    R(36,0x650a73548baf63de); R(37,0x766a0abb3c77b2a8);
    R(38,0x81c2c92e47edaee6); R(39,0x92722c851482353b);
    R(40,0xa2bfe8a14cf10364); R(41,0xa81a664bbc423001);
    R(42,0xc24b8b70d0f89791); R(43,0xc76c51a30654be30);
    R(44,0xd192e819d6ef5218); R(45,0xd69906245565a910);
    R(46,0xf40e35855771202a); R(47,0x106aa07032bbd1b8);
    R(48,0x19a4c116b8d2d0c8); R(49,0x1e376c085141ab53);
    R(50,0x2748774cdf8eeb99); R(51,0x34b0bcb5e19b48a8);
    R(52,0x391c0cb3c5c95a63); R(53,0x4ed8aa4ae3418acb);
    R(54,0x5b9cca4f7763e373); R(55,0x682e6ff3d6b2b8a3);
    R(56,0x748f82ee5defb2fc); R(57,0x78a5636f43172f60);
    R(58,0x84c87814a1f0ab72); R(59,0x8cc702081a6439ec);
    R(60,0x90befffa23631e28); R(61,0xa4506cebde82bde9);
    R(62,0xbef9a3f7b2c67915); R(63,0xc67178f2e372532b);
    R(64,0xca273eceea26619c); R(65,0xd186b8c721c0c207);
    R(66,0xeada7dd6cde0eb1e); R(67,0xf57d4f7fee6ed178);
    R(68,0x06f067aa72176fba); R(69,0x0a637dc5a2c898a6);
    R(70,0x113f9804bef90dae); R(71,0x1b710b35131c471b);
    R(72,0x28db77f523047d84); R(73,0x32caab7b40c72493);
    R(74,0x3c9ebe0a15c9bebc); R(75,0x431d67c49c100d4c);
    R(76,0x4cc5d4becb3e42b6); R(77,0x597f299cfc657e2a);
    R(78,0x5fcb6fab3ad6faec); R(79,0x6c44198c4a475817);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;
  }
}
