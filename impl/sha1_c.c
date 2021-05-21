// SHA-256 implemetation, transform only
// The `sha1_c_xform` function here is based on the function
// `sha256_process` from public domain code in md5deep/hashdeep, originally
// written by Christophe Devine.
//
// The code has been modified to match the API of Intel's optimized assembly
// implementations of SHA1. Rather than a context struct, a simple array of
// uint32s is used to hold the state, and an argument to specify the number of
// blocks to process has been added.
//
// Modifications by Ryan Castellucci, all changes in public domain

#include <stdint.h>
#include <endian.h>

#include "../rhashc.h"

#define K0 0x5A827999
#define K1 0x6ED9EBA1
#define K2 0x8F1BBCDC
#define K3 0xCA62C1D6

#define F0(x,y,z) (z ^ (x & (y ^ z)))
#define F1(x,y,z) (x ^ y ^ z)
#define F2(x,y,z) ((x & y) | (z & (x | y)))
#define F3 F1

#define E(r) (r<16?W[r]:(W[r&15]=ROL32(W[(r+13)&15]^W[(r+8)&15]^W[(r+2)&15]^W[r&15],1)))

/* (R0+R1), R2, R3, R4 are the different operations used in SHA1 */
#define R0(a,b,c,d,e,r) e+=F0(b,c,d)+E(r)+K0+ROL32(a,5);b=ROL32(b,30);
#define R1(a,b,c,d,e,r) e+=F1(b,c,d)+E(r)+K1+ROL32(a,5);b=ROL32(b,30);
#define R2(a,b,c,d,e,r) e+=F2(b,c,d)+E(r)+K2+ROL32(a,5);b=ROL32(b,30);
#define R3(a,b,c,d,e,r) e+=F3(b,c,d)+E(r)+K3+ROL32(a,5);b=ROL32(b,30);

#define P(a,b,c,d,e,r)  \
{  \
  if (r < 20) {      R0(a,b,c,d,e,r); }  \
  else if (r < 40) { R1(a,b,c,d,e,r); }  \
  else if (r < 60) { R2(a,b,c,d,e,r); }  \
  else {             R3(a,b,c,d,e,r); }  \
}

int JOIN(sha1,c_impl,built)() { return 1; }
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha1,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk)
{
  const uint32_t *input=(uint32_t *)data;
  uint32_t A, B, C, D, E, W[16];

  for (;;) {
    for (int i = 0; i < 16; ++i) W[i] = htobe32(input[i]);

    A=digest[0]; B=digest[1]; C=digest[2]; D=digest[3]; E=digest[4];

    P(A,B,C,D,E, 0); P(E,A,B,C,D, 1); P(D,E,A,B,C, 2); P(C,D,E,A,B, 3);
    P(B,C,D,E,A, 4); P(A,B,C,D,E, 5); P(E,A,B,C,D, 6); P(D,E,A,B,C, 7);
    P(C,D,E,A,B, 8); P(B,C,D,E,A, 9); P(A,B,C,D,E,10); P(E,A,B,C,D,11);
    P(D,E,A,B,C,12); P(C,D,E,A,B,13); P(B,C,D,E,A,14); P(A,B,C,D,E,15);
    P(E,A,B,C,D,16); P(D,E,A,B,C,17); P(C,D,E,A,B,18); P(B,C,D,E,A,19);
    P(A,B,C,D,E,20); P(E,A,B,C,D,21); P(D,E,A,B,C,22); P(C,D,E,A,B,23);
    P(B,C,D,E,A,24); P(A,B,C,D,E,25); P(E,A,B,C,D,26); P(D,E,A,B,C,27);
    P(C,D,E,A,B,28); P(B,C,D,E,A,29); P(A,B,C,D,E,30); P(E,A,B,C,D,31);
    P(D,E,A,B,C,32); P(C,D,E,A,B,33); P(B,C,D,E,A,34); P(A,B,C,D,E,35);
    P(E,A,B,C,D,36); P(D,E,A,B,C,37); P(C,D,E,A,B,38); P(B,C,D,E,A,39);
    P(A,B,C,D,E,40); P(E,A,B,C,D,41); P(D,E,A,B,C,42); P(C,D,E,A,B,43);
    P(B,C,D,E,A,44); P(A,B,C,D,E,45); P(E,A,B,C,D,46); P(D,E,A,B,C,47);
    P(C,D,E,A,B,48); P(B,C,D,E,A,49); P(A,B,C,D,E,50); P(E,A,B,C,D,51);
    P(D,E,A,B,C,52); P(C,D,E,A,B,53); P(B,C,D,E,A,54); P(A,B,C,D,E,55);
    P(E,A,B,C,D,56); P(D,E,A,B,C,57); P(C,D,E,A,B,58); P(B,C,D,E,A,59);
    P(A,B,C,D,E,60); P(E,A,B,C,D,61); P(D,E,A,B,C,62); P(C,D,E,A,B,63);
    P(B,C,D,E,A,64); P(A,B,C,D,E,65); P(E,A,B,C,D,66); P(D,E,A,B,C,67);
    P(C,D,E,A,B,68); P(B,C,D,E,A,69); P(A,B,C,D,E,70); P(E,A,B,C,D,71);
    P(D,E,A,B,C,72); P(C,D,E,A,B,73); P(B,C,D,E,A,74); P(A,B,C,D,E,75);
    P(E,A,B,C,D,76); P(D,E,A,B,C,77); P(C,D,E,A,B,78); P(B,C,D,E,A,79);

    digest[0]+=A; digest[1]+=B; digest[2]+=C; digest[3]+=D; digest[4]+=E;

    if (--nblk <= 0) return;
    input += (64 / sizeof(*input));
  }
}
