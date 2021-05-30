// SHA-256 implemetation, transform only
// The `sha2_256_c_xform` function here is based on the function
// `sha256_process` from public domain code in md5deep/hashdeep, originally
// written by Christophe Devine.
//
// The code has been modified to match the API of Intel's optimized assembly
// implementations of SHA256. Rather than a context struct, a simple array of
// uint32s is used to hold the state, and an argument to specify the number of
// blocks to process has been added.
//
// Modifications by Ryan Castellucci, all changes in public domain

#include <stdint.h>
#include <endian.h>

#include "../../../macros.h"

#define S0(x) (ROR32(x, 7) ^ ROR32(x,18) ^ (x >> 3))
#define S1(x) (ROR32(x,17) ^ ROR32(x,19) ^ (x >> 10))

#define S2(x) (ROR32(x, 2) ^ ROR32(x,13) ^ ROR32(x,22))
#define S3(x) (ROR32(x, 6) ^ ROR32(x,11) ^ ROR32(x,25))

#define F0(x,y,z) ((x & y) | (z & (x | y)))
#define F1(x,y,z) (z ^ (x & (y ^ z)))

#define E(r) (r<16?W[r]:(W[r&15]=S1(W[(r+14)&15])+W[(r+9)&15]+S0(W[(r+1)&15])+W[r&15]))

#define P(a,b,c,d,e,f,g,h,r,K) {              \
  temp1 = h + S3(e) + F1(e,f,g) + K + E(r);   \
  d += temp1; h = temp1 + S2(a) + F0(a,b,c);  \
}                                             \

int JOIN(sha2_256,c_impl,xform,built)() { return 1; }
// Process input in chunks of 64 bytes, caller resposible for padding
void JOIN(sha2_256,c_impl,xform)(uint32_t *digest, const char *data, uint32_t nblk)
{
  const uint32_t *input=(uint32_t *)data;
  uint32_t temp1, W[16];
  uint32_t A, B, C, D, E, F, G, H;

  for (;;) {
    // Load input
    for (int i = 0; i < 16; ++i) W[i] = htobe32(input[i]);

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    P(A,B,C,D,E,F,G,H, 0,0x428a2f98);  P(H,A,B,C,D,E,F,G, 1,0x71374491);
    P(G,H,A,B,C,D,E,F, 2,0xb5c0fbcf);  P(F,G,H,A,B,C,D,E, 3,0xe9b5dba5);
    P(E,F,G,H,A,B,C,D, 4,0x3956c25b);  P(D,E,F,G,H,A,B,C, 5,0x59f111f1);
    P(C,D,E,F,G,H,A,B, 6,0x923f82a4);  P(B,C,D,E,F,G,H,A, 7,0xab1c5ed5);
    P(A,B,C,D,E,F,G,H, 8,0xd807aa98);  P(H,A,B,C,D,E,F,G, 9,0x12835b01);
    P(G,H,A,B,C,D,E,F,10,0x243185be);  P(F,G,H,A,B,C,D,E,11,0x550c7dc3);
    P(E,F,G,H,A,B,C,D,12,0x72be5d74);  P(D,E,F,G,H,A,B,C,13,0x80deb1fe);
    P(C,D,E,F,G,H,A,B,14,0x9bdc06a7);  P(B,C,D,E,F,G,H,A,15,0xc19bf174);
    P(A,B,C,D,E,F,G,H,16,0xe49b69c1);  P(H,A,B,C,D,E,F,G,17,0xefbe4786);
    P(G,H,A,B,C,D,E,F,18,0x0fc19dc6);  P(F,G,H,A,B,C,D,E,19,0x240ca1cc);
    P(E,F,G,H,A,B,C,D,20,0x2de92c6f);  P(D,E,F,G,H,A,B,C,21,0x4a7484aa);
    P(C,D,E,F,G,H,A,B,22,0x5cb0a9dc);  P(B,C,D,E,F,G,H,A,23,0x76f988da);
    P(A,B,C,D,E,F,G,H,24,0x983e5152);  P(H,A,B,C,D,E,F,G,25,0xa831c66d);
    P(G,H,A,B,C,D,E,F,26,0xb00327c8);  P(F,G,H,A,B,C,D,E,27,0xbf597fc7);
    P(E,F,G,H,A,B,C,D,28,0xc6e00bf3);  P(D,E,F,G,H,A,B,C,29,0xd5a79147);
    P(C,D,E,F,G,H,A,B,30,0x06ca6351);  P(B,C,D,E,F,G,H,A,31,0x14292967);
    P(A,B,C,D,E,F,G,H,32,0x27b70a85);  P(H,A,B,C,D,E,F,G,33,0x2e1b2138);
    P(G,H,A,B,C,D,E,F,34,0x4d2c6dfc);  P(F,G,H,A,B,C,D,E,35,0x53380d13);
    P(E,F,G,H,A,B,C,D,36,0x650a7354);  P(D,E,F,G,H,A,B,C,37,0x766a0abb);
    P(C,D,E,F,G,H,A,B,38,0x81c2c92e);  P(B,C,D,E,F,G,H,A,39,0x92722c85);
    P(A,B,C,D,E,F,G,H,40,0xa2bfe8a1);  P(H,A,B,C,D,E,F,G,41,0xa81a664b);
    P(G,H,A,B,C,D,E,F,42,0xc24b8b70);  P(F,G,H,A,B,C,D,E,43,0xc76c51a3);
    P(E,F,G,H,A,B,C,D,44,0xd192e819);  P(D,E,F,G,H,A,B,C,45,0xd6990624);
    P(C,D,E,F,G,H,A,B,46,0xf40e3585);  P(B,C,D,E,F,G,H,A,47,0x106aa070);
    P(A,B,C,D,E,F,G,H,48,0x19a4c116);  P(H,A,B,C,D,E,F,G,49,0x1e376c08);
    P(G,H,A,B,C,D,E,F,50,0x2748774c);  P(F,G,H,A,B,C,D,E,51,0x34b0bcb5);
    P(E,F,G,H,A,B,C,D,52,0x391c0cb3);  P(D,E,F,G,H,A,B,C,53,0x4ed8aa4a);
    P(C,D,E,F,G,H,A,B,54,0x5b9cca4f);  P(B,C,D,E,F,G,H,A,55,0x682e6ff3);
    P(A,B,C,D,E,F,G,H,56,0x748f82ee);  P(H,A,B,C,D,E,F,G,57,0x78a5636f);
    P(G,H,A,B,C,D,E,F,58,0x84c87814);  P(F,G,H,A,B,C,D,E,59,0x8cc70208);
    P(E,F,G,H,A,B,C,D,60,0x90befffa);  P(D,E,F,G,H,A,B,C,61,0xa4506ceb);
    P(C,D,E,F,G,H,A,B,62,0xbef9a3f7);  P(B,C,D,E,F,G,H,A,63,0xc67178f2);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;

    if (--nblk <= 0) return;
    input += (64 / sizeof(*input));
  }
}
