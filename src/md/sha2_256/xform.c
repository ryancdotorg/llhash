/* SPDX-License-Identifier: 0BSD or CC0-1.0 or MIT-0 or Unlicense */
// SHA-256 implemetation, transform only
// Copyright (c) 2021, Ryan Castellucci, No Rights Reserved

#include <stdint.h>

#include "../../../macros.h"

#define S0(x) (ROR32(x, 7) ^ ROR32(x,18) ^ (x >> 3))    // s0
#define S1(x) (ROR32(x,17) ^ ROR32(x,19) ^ (x >> 10))   // s1

#define S2(x) (ROR32(x, 2) ^ ROR32(x,13) ^ ROR32(x,22)) // S0
#define S3(x) (ROR32(x, 6) ^ ROR32(x,11) ^ ROR32(x,25)) // S1

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

int JOIN(sha2_256,c_impl,xform,built)() { return 1; }
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha2_256,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, E, F, G, H, temp;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
    // Load input
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = U32H2BE(input[i]);

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    R( 0,0x428a2f98); R( 1,0x71374491); R( 2,0xb5c0fbcf); R( 3,0xe9b5dba5);
    R( 4,0x3956c25b); R( 5,0x59f111f1); R( 6,0x923f82a4); R( 7,0xab1c5ed5);
    R( 8,0xd807aa98); R( 9,0x12835b01); R(10,0x243185be); R(11,0x550c7dc3);
    R(12,0x72be5d74); R(13,0x80deb1fe); R(14,0x9bdc06a7); R(15,0xc19bf174);
    R(16,0xe49b69c1); R(17,0xefbe4786); R(18,0x0fc19dc6); R(19,0x240ca1cc);
    R(20,0x2de92c6f); R(21,0x4a7484aa); R(22,0x5cb0a9dc); R(23,0x76f988da);
    R(24,0x983e5152); R(25,0xa831c66d); R(26,0xb00327c8); R(27,0xbf597fc7);
    R(28,0xc6e00bf3); R(29,0xd5a79147); R(30,0x06ca6351); R(31,0x14292967);
    R(32,0x27b70a85); R(33,0x2e1b2138); R(34,0x4d2c6dfc); R(35,0x53380d13);
    R(36,0x650a7354); R(37,0x766a0abb); R(38,0x81c2c92e); R(39,0x92722c85);
    R(40,0xa2bfe8a1); R(41,0xa81a664b); R(42,0xc24b8b70); R(43,0xc76c51a3);
    R(44,0xd192e819); R(45,0xd6990624); R(46,0xf40e3585); R(47,0x106aa070);
    R(48,0x19a4c116); R(49,0x1e376c08); R(50,0x2748774c); R(51,0x34b0bcb5);
    R(52,0x391c0cb3); R(53,0x4ed8aa4a); R(54,0x5b9cca4f); R(55,0x682e6ff3);
    R(56,0x748f82ee); R(57,0x78a5636f); R(58,0x84c87814); R(59,0x8cc70208);
    R(60,0x90befffa); R(61,0xa4506ceb); R(62,0xbef9a3f7); R(63,0xc67178f2);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;
  }
}

int JOIN(sha2_256,c_impl,xform_le,built)() { return 1; }
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha2_256,c_impl,xform_le)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, E, F, G, H, temp;

  for (const uint32_t *end=input+nblk*16; input < end; input += 16) {
    // Load input
    uint32_t W[16];
    for (int i = 0; i < 16; ++i) W[i] = input[i];

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    R( 0,0x428a2f98); R( 1,0x71374491); R( 2,0xb5c0fbcf); R( 3,0xe9b5dba5);
    R( 4,0x3956c25b); R( 5,0x59f111f1); R( 6,0x923f82a4); R( 7,0xab1c5ed5);
    R( 8,0xd807aa98); R( 9,0x12835b01); R(10,0x243185be); R(11,0x550c7dc3);
    R(12,0x72be5d74); R(13,0x80deb1fe); R(14,0x9bdc06a7); R(15,0xc19bf174);
    R(16,0xe49b69c1); R(17,0xefbe4786); R(18,0x0fc19dc6); R(19,0x240ca1cc);
    R(20,0x2de92c6f); R(21,0x4a7484aa); R(22,0x5cb0a9dc); R(23,0x76f988da);
    R(24,0x983e5152); R(25,0xa831c66d); R(26,0xb00327c8); R(27,0xbf597fc7);
    R(28,0xc6e00bf3); R(29,0xd5a79147); R(30,0x06ca6351); R(31,0x14292967);
    R(32,0x27b70a85); R(33,0x2e1b2138); R(34,0x4d2c6dfc); R(35,0x53380d13);
    R(36,0x650a7354); R(37,0x766a0abb); R(38,0x81c2c92e); R(39,0x92722c85);
    R(40,0xa2bfe8a1); R(41,0xa81a664b); R(42,0xc24b8b70); R(43,0xc76c51a3);
    R(44,0xd192e819); R(45,0xd6990624); R(46,0xf40e3585); R(47,0x106aa070);
    R(48,0x19a4c116); R(49,0x1e376c08); R(50,0x2748774c); R(51,0x34b0bcb5);
    R(52,0x391c0cb3); R(53,0x4ed8aa4a); R(54,0x5b9cca4f); R(55,0x682e6ff3);
    R(56,0x748f82ee); R(57,0x78a5636f); R(58,0x84c87814); R(59,0x8cc70208);
    R(60,0x90befffa); R(61,0xa4506ceb); R(62,0xbef9a3f7); R(63,0xc67178f2);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;
  }
}
