// SHA-256 implemetation, transform only
// The `sha2_512_c_xform` function here is based on the function
// `sha256_process` from public domain code in md5deep/hashdeep, originally
// written by Christophe Devine.
//
// The code has been modified to match the API of Intel's optimized assembly
// implementations of SHA512. Rather than a context struct, a simple array of
// uint32s is used to hold the state, and an argument to specify the number of
// blocks to process has been added.
//
// Modifications by Ryan Castellucci, all changes in public domain

#include <stdint.h>
#include <endian.h>

#include "../../../macros.h"

#define S0(x) (ROR64(x, 1) ^ ROR64(x, 8) ^ (x >>  7))   // s0
#define S1(x) (ROR64(x,19) ^ ROR64(x,61) ^ (x >>  6))   // s1

#define S2(x) (ROR64(x,28) ^ ROR64(x,34) ^ ROR64(x,39)) // S0
#define S3(x) (ROR64(x,14) ^ ROR64(x,18) ^ ROR64(x,41)) // S1

#define F0(x,y,z) ((x & y) | (z & (x | y)))   // ch
#define F1(x,y,z) (z ^ (x & (y ^ z)))         // maj

#define E(r) (r<16?W[r]:(W[r&15]=S1(W[(r+14)&15])+W[(r+9)&15]+S0(W[(r+1)&15])+W[r&15]))

#define P(a,b,c,d,e,f,g,h,r,K) {              \
  temp1 = h + S3(e) + F1(e,f,g) + K + E(r);   \
  d += temp1; h = temp1 + S2(a) + F0(a,b,c);  \
}                                             \

int JOIN(sha2_512,c_impl,xform,built)() { return 1; }
// Process input in chunks of 128 bytes, caller resposible for padding
void JOIN(sha2_512,c_impl,xform)(uint64_t *digest, const char *data, uint32_t nblk)
{
  const uint64_t *input=(uint64_t *)data;
  uint64_t temp1, W[16];
  uint64_t A, B, C, D, E, F, G, H;

  for (;;) {
    // Load input
    for (int i=0; i < 16; ++i) W[i] = htobe64(input[i]);

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    P(A,B,C,D,E,F,G,H, 0,0x428a2f98d728ae22); P(H,A,B,C,D,E,F,G, 1,0x7137449123ef65cd);
    P(G,H,A,B,C,D,E,F, 2,0xb5c0fbcfec4d3b2f); P(F,G,H,A,B,C,D,E, 3,0xe9b5dba58189dbbc);
    P(E,F,G,H,A,B,C,D, 4,0x3956c25bf348b538); P(D,E,F,G,H,A,B,C, 5,0x59f111f1b605d019);
    P(C,D,E,F,G,H,A,B, 6,0x923f82a4af194f9b); P(B,C,D,E,F,G,H,A, 7,0xab1c5ed5da6d8118);
    P(A,B,C,D,E,F,G,H, 8,0xd807aa98a3030242); P(H,A,B,C,D,E,F,G, 9,0x12835b0145706fbe);
    P(G,H,A,B,C,D,E,F,10,0x243185be4ee4b28c); P(F,G,H,A,B,C,D,E,11,0x550c7dc3d5ffb4e2);
    P(E,F,G,H,A,B,C,D,12,0x72be5d74f27b896f); P(D,E,F,G,H,A,B,C,13,0x80deb1fe3b1696b1);
    P(C,D,E,F,G,H,A,B,14,0x9bdc06a725c71235); P(B,C,D,E,F,G,H,A,15,0xc19bf174cf692694);
    P(A,B,C,D,E,F,G,H,16,0xe49b69c19ef14ad2); P(H,A,B,C,D,E,F,G,17,0xefbe4786384f25e3);
    P(G,H,A,B,C,D,E,F,18,0x0fc19dc68b8cd5b5); P(F,G,H,A,B,C,D,E,19,0x240ca1cc77ac9c65);
    P(E,F,G,H,A,B,C,D,20,0x2de92c6f592b0275); P(D,E,F,G,H,A,B,C,21,0x4a7484aa6ea6e483);
    P(C,D,E,F,G,H,A,B,22,0x5cb0a9dcbd41fbd4); P(B,C,D,E,F,G,H,A,23,0x76f988da831153b5);
    P(A,B,C,D,E,F,G,H,24,0x983e5152ee66dfab); P(H,A,B,C,D,E,F,G,25,0xa831c66d2db43210);
    P(G,H,A,B,C,D,E,F,26,0xb00327c898fb213f); P(F,G,H,A,B,C,D,E,27,0xbf597fc7beef0ee4);
    P(E,F,G,H,A,B,C,D,28,0xc6e00bf33da88fc2); P(D,E,F,G,H,A,B,C,29,0xd5a79147930aa725);
    P(C,D,E,F,G,H,A,B,30,0x06ca6351e003826f); P(B,C,D,E,F,G,H,A,31,0x142929670a0e6e70);
    P(A,B,C,D,E,F,G,H,32,0x27b70a8546d22ffc); P(H,A,B,C,D,E,F,G,33,0x2e1b21385c26c926);
    P(G,H,A,B,C,D,E,F,34,0x4d2c6dfc5ac42aed); P(F,G,H,A,B,C,D,E,35,0x53380d139d95b3df);
    P(E,F,G,H,A,B,C,D,36,0x650a73548baf63de); P(D,E,F,G,H,A,B,C,37,0x766a0abb3c77b2a8);
    P(C,D,E,F,G,H,A,B,38,0x81c2c92e47edaee6); P(B,C,D,E,F,G,H,A,39,0x92722c851482353b);
    P(A,B,C,D,E,F,G,H,40,0xa2bfe8a14cf10364); P(H,A,B,C,D,E,F,G,41,0xa81a664bbc423001);
    P(G,H,A,B,C,D,E,F,42,0xc24b8b70d0f89791); P(F,G,H,A,B,C,D,E,43,0xc76c51a30654be30);
    P(E,F,G,H,A,B,C,D,44,0xd192e819d6ef5218); P(D,E,F,G,H,A,B,C,45,0xd69906245565a910);
    P(C,D,E,F,G,H,A,B,46,0xf40e35855771202a); P(B,C,D,E,F,G,H,A,47,0x106aa07032bbd1b8);
    P(A,B,C,D,E,F,G,H,48,0x19a4c116b8d2d0c8); P(H,A,B,C,D,E,F,G,49,0x1e376c085141ab53);
    P(G,H,A,B,C,D,E,F,50,0x2748774cdf8eeb99); P(F,G,H,A,B,C,D,E,51,0x34b0bcb5e19b48a8);
    P(E,F,G,H,A,B,C,D,52,0x391c0cb3c5c95a63); P(D,E,F,G,H,A,B,C,53,0x4ed8aa4ae3418acb);
    P(C,D,E,F,G,H,A,B,54,0x5b9cca4f7763e373); P(B,C,D,E,F,G,H,A,55,0x682e6ff3d6b2b8a3);
    P(A,B,C,D,E,F,G,H,56,0x748f82ee5defb2fc); P(H,A,B,C,D,E,F,G,57,0x78a5636f43172f60);
    P(G,H,A,B,C,D,E,F,58,0x84c87814a1f0ab72); P(F,G,H,A,B,C,D,E,59,0x8cc702081a6439ec);
    P(E,F,G,H,A,B,C,D,60,0x90befffa23631e28); P(D,E,F,G,H,A,B,C,61,0xa4506cebde82bde9);
    P(C,D,E,F,G,H,A,B,62,0xbef9a3f7b2c67915); P(B,C,D,E,F,G,H,A,63,0xc67178f2e372532b);
    P(A,B,C,D,E,F,G,H,64,0xca273eceea26619c); P(H,A,B,C,D,E,F,G,65,0xd186b8c721c0c207);
    P(G,H,A,B,C,D,E,F,66,0xeada7dd6cde0eb1e); P(F,G,H,A,B,C,D,E,67,0xf57d4f7fee6ed178);
    P(E,F,G,H,A,B,C,D,68,0x06f067aa72176fba); P(D,E,F,G,H,A,B,C,69,0x0a637dc5a2c898a6);
    P(C,D,E,F,G,H,A,B,70,0x113f9804bef90dae); P(B,C,D,E,F,G,H,A,71,0x1b710b35131c471b);
    P(A,B,C,D,E,F,G,H,72,0x28db77f523047d84); P(H,A,B,C,D,E,F,G,73,0x32caab7b40c72493);
    P(G,H,A,B,C,D,E,F,74,0x3c9ebe0a15c9bebc); P(F,G,H,A,B,C,D,E,75,0x431d67c49c100d4c);
    P(E,F,G,H,A,B,C,D,76,0x4cc5d4becb3e42b6); P(D,E,F,G,H,A,B,C,77,0x597f299cfc657e2a);
    P(C,D,E,F,G,H,A,B,78,0x5fcb6fab3ad6faec); P(B,C,D,E,F,G,H,A,79,0x6c44198c4a475817);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;

    if (--nblk <= 0) return;
    input += (128 / sizeof(*input));
  }
}
