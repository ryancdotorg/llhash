/* SPDX-License-Identifier: 0BSD or CC0-1.0 or MIT-0 or Unlicense */
// MD5 implemetation, transform only
// Copyright (c) 2021, Ryan Castellucci, No Rights Reserved

#include <stdint.h>
#include <endian.h>

#include "../../../macros.h"

// Mixing functions
#define F(x, y, z)   (z ^ (x & (y ^ z)))
//#define G(x, y, z)   (y ^ (z & (x ^ y)))
#define G(x, y, z)   ((z & x) | (~z & y))
#define H(x, y, z)   (x ^ y ^ z)
#define I(x, y, z)   (y ^ (x | ~z))

// Let's make the compiler do a ton of work...
#define S0(r) ((r&3)==0 ?  7 : ((r&3)==1 ? 12 : ((r&3)==2 ? 17 : 22 )))
#define S1(r) ((r&3)==0 ?  5 : ((r&3)==1 ?  9 : ((r&3)==2 ? 14 : 20 )))
#define S2(r) ((r&3)==0 ?  4 : ((r&3)==1 ? 11 : ((r&3)==2 ? 16 : 23 )))
#define S3(r) ((r&3)==0 ?  6 : ((r&3)==1 ? 10 : ((r&3)==2 ? 15 : 21 )))

#define R0(r,a,b,c,d,K) (a=ROL32(a+F(b,c,d)+W[(r*1+0)&15]+K,S0(r))+b)
#define R1(r,a,b,c,d,K) (a=ROL32(a+G(b,c,d)+W[(r*5+1)&15]+K,S1(r))+b)
#define R2(r,a,b,c,d,K) (a=ROL32(a+H(b,c,d)+W[(r*3+5)&15]+K,S2(r))+b)
#define R3(r,a,b,c,d,K) (a=ROL32(a+I(b,c,d)+W[(r*7+0)&15]+K,S3(r))+b)

#define P(r,a,b,c,d,K) do {            \
  if (r < 16) {      R0(r,a,b,c,d,K); } \
  else if (r < 32) { R1(r,a,b,c,d,K); } \
  else if (r < 48) { R2(r,a,b,c,d,K); } \
  else {             R3(r,a,b,c,d,K); } \
} while(0)

#define R(r,K) do {                        \
  if ((r%4) == 0) {      P(r,A,B,C,D,K); } \
  else if ((r%4) == 1) { P(r,D,A,B,C,K); } \
  else if ((r%4) == 2) { P(r,C,D,A,B,K); } \
  else {                 P(r,B,C,D,A,K); } \
} while(0)

int JOIN(md5,c_impl,xform,built)() { return 1; }
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(md5,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk) {
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, W[16];

  for (;;) {
    // load input
    for (int i = 0; i < 16; ++i) W[i] = htole32(input[i]);

    A=digest[0]; B=digest[1]; C=digest[2]; D=digest[3];

    R( 0,0xd76aa478); R( 1,0xe8c7b756); R( 2,0x242070db); R( 3,0xc1bdceee);
    R( 4,0xf57c0faf); R( 5,0x4787c62a); R( 6,0xa8304613); R( 7,0xfd469501);
    R( 8,0x698098d8); R( 9,0x8b44f7af); R(10,0xffff5bb1); R(11,0x895cd7be);
    R(12,0x6b901122); R(13,0xfd987193); R(14,0xa679438e); R(15,0x49b40821);
    R(16,0xf61e2562); R(17,0xc040b340); R(18,0x265e5a51); R(19,0xe9b6c7aa);
    R(20,0xd62f105d); R(21,0x02441453); R(22,0xd8a1e681); R(23,0xe7d3fbc8);
    R(24,0x21e1cde6); R(25,0xc33707d6); R(26,0xf4d50d87); R(27,0x455a14ed);
    R(28,0xa9e3e905); R(29,0xfcefa3f8); R(30,0x676f02d9); R(31,0x8d2a4c8a);
    R(32,0xfffa3942); R(33,0x8771f681); R(34,0x6d9d6122); R(35,0xfde5380c);
    R(36,0xa4beea44); R(37,0x4bdecfa9); R(38,0xf6bb4b60); R(39,0xbebfbc70);
    R(40,0x289b7ec6); R(41,0xeaa127fa); R(42,0xd4ef3085); R(43,0x04881d05);
    R(44,0xd9d4d039); R(45,0xe6db99e5); R(46,0x1fa27cf8); R(47,0xc4ac5665);
    R(48,0xf4292244); R(49,0x432aff97); R(50,0xab9423a7); R(51,0xfc93a039);
    R(52,0x655b59c3); R(53,0x8f0ccc92); R(54,0xffeff47d); R(55,0x85845dd1);
    R(56,0x6fa87e4f); R(57,0xfe2ce6e0); R(58,0xa3014314); R(59,0x4e0811a1);
    R(60,0xf7537e82); R(61,0xbd3af235); R(62,0x2ad7d2bb); R(63,0xeb86d391);

    digest[0]+=A; digest[1]+=B; digest[2]+=C; digest[3]+=D;

    if (--nblk <= 0) return;
    input += (64 / sizeof(*input));
  }
}
