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

#include "../rhashc.h"

int JOIN(sha2_512,c_impl,built)() { return 1; }
// Process input in chunks of 128 bytes, caller resposible for padding
void JOIN(sha2_512,c_impl,xform)(uint64_t *digest, const char *data, uint32_t nblk)
{
  const uint64_t *input=(uint64_t *)data;
  uint64_t temp1, temp2, W[16];
  uint64_t A, B, C, D, E, F, G, H;

#define ROR(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x >> _n) | (_x << (64-_n)); })

#define S0(x) (ROR(x, 1) ^ ROR(x, 8) ^ (x >>  7)) // s0
#define S1(x) (ROR(x,19) ^ ROR(x,61) ^ (x >>  6)) // s1

#define S2(x) (ROR(x,28) ^ ROR(x,34) ^ ROR(x,39)) // S0
#define S3(x) (ROR(x,14) ^ ROR(x,18) ^ ROR(x,41)) // S1

#define F0(x,y,z) ((x & y) | (z & (x | y)))       // ch
#define F1(x,y,z) (z ^ (x & (y ^ z)))             // maj

#define R(t)                                  \
(                                             \
  W[t] = S1(W[(t+14)&15]) + W[(t+9)&15] +     \
         S0(W[(t+1)&15]) + W[t]               \
)

#define P(a,b,c,d,e,f,g,h,x,K)                \
{                                             \
  temp1 = h + S3(e) + F1(e,f,g) + K + x;      \
  temp2 = S2(a) + F0(a,b,c);                  \
  d += temp1; h = temp1 + temp2;              \
}                                             \

  for (;;) {
    // Load input
    for (int i=0; i < 16; ++i) W[i] = htobe64(input[i]);

    A = digest[0]; B = digest[1]; C = digest[2]; D = digest[3];
    E = digest[4]; F = digest[5]; G = digest[6]; H = digest[7];

    P(A, B, C, D, E, F, G, H, W[ 0], 0x428a2f98d728ae22);
    P(H, A, B, C, D, E, F, G, W[ 1], 0x7137449123ef65cd);
    P(G, H, A, B, C, D, E, F, W[ 2], 0xb5c0fbcfec4d3b2f);
    P(F, G, H, A, B, C, D, E, W[ 3], 0xe9b5dba58189dbbc);
    P(E, F, G, H, A, B, C, D, W[ 4], 0x3956c25bf348b538);
    P(D, E, F, G, H, A, B, C, W[ 5], 0x59f111f1b605d019);
    P(C, D, E, F, G, H, A, B, W[ 6], 0x923f82a4af194f9b);
    P(B, C, D, E, F, G, H, A, W[ 7], 0xab1c5ed5da6d8118);
    P(A, B, C, D, E, F, G, H, W[ 8], 0xd807aa98a3030242);
    P(H, A, B, C, D, E, F, G, W[ 9], 0x12835b0145706fbe);
    P(G, H, A, B, C, D, E, F, W[10], 0x243185be4ee4b28c);
    P(F, G, H, A, B, C, D, E, W[11], 0x550c7dc3d5ffb4e2);
    P(E, F, G, H, A, B, C, D, W[12], 0x72be5d74f27b896f);
    P(D, E, F, G, H, A, B, C, W[13], 0x80deb1fe3b1696b1);
    P(C, D, E, F, G, H, A, B, W[14], 0x9bdc06a725c71235);
    P(B, C, D, E, F, G, H, A, W[15], 0xc19bf174cf692694);
    P(A, B, C, D, E, F, G, H, R( 0), 0xe49b69c19ef14ad2);
    P(H, A, B, C, D, E, F, G, R( 1), 0xefbe4786384f25e3);
    P(G, H, A, B, C, D, E, F, R( 2), 0x0fc19dc68b8cd5b5);
    P(F, G, H, A, B, C, D, E, R( 3), 0x240ca1cc77ac9c65);
    P(E, F, G, H, A, B, C, D, R( 4), 0x2de92c6f592b0275);
    P(D, E, F, G, H, A, B, C, R( 5), 0x4a7484aa6ea6e483);
    P(C, D, E, F, G, H, A, B, R( 6), 0x5cb0a9dcbd41fbd4);
    P(B, C, D, E, F, G, H, A, R( 7), 0x76f988da831153b5);
    P(A, B, C, D, E, F, G, H, R( 8), 0x983e5152ee66dfab);
    P(H, A, B, C, D, E, F, G, R( 9), 0xa831c66d2db43210);
    P(G, H, A, B, C, D, E, F, R(10), 0xb00327c898fb213f);
    P(F, G, H, A, B, C, D, E, R(11), 0xbf597fc7beef0ee4);
    P(E, F, G, H, A, B, C, D, R(12), 0xc6e00bf33da88fc2);
    P(D, E, F, G, H, A, B, C, R(13), 0xd5a79147930aa725);
    P(C, D, E, F, G, H, A, B, R(14), 0x06ca6351e003826f);
    P(B, C, D, E, F, G, H, A, R(15), 0x142929670a0e6e70);
    P(A, B, C, D, E, F, G, H, R( 0), 0x27b70a8546d22ffc);
    P(H, A, B, C, D, E, F, G, R( 1), 0x2e1b21385c26c926);
    P(G, H, A, B, C, D, E, F, R( 2), 0x4d2c6dfc5ac42aed);
    P(F, G, H, A, B, C, D, E, R( 3), 0x53380d139d95b3df);
    P(E, F, G, H, A, B, C, D, R( 4), 0x650a73548baf63de);
    P(D, E, F, G, H, A, B, C, R( 5), 0x766a0abb3c77b2a8);
    P(C, D, E, F, G, H, A, B, R( 6), 0x81c2c92e47edaee6);
    P(B, C, D, E, F, G, H, A, R( 7), 0x92722c851482353b);
    P(A, B, C, D, E, F, G, H, R( 8), 0xa2bfe8a14cf10364);
    P(H, A, B, C, D, E, F, G, R( 9), 0xa81a664bbc423001);
    P(G, H, A, B, C, D, E, F, R(10), 0xc24b8b70d0f89791);
    P(F, G, H, A, B, C, D, E, R(11), 0xc76c51a30654be30);
    P(E, F, G, H, A, B, C, D, R(12), 0xd192e819d6ef5218);
    P(D, E, F, G, H, A, B, C, R(13), 0xd69906245565a910);
    P(C, D, E, F, G, H, A, B, R(14), 0xf40e35855771202a);
    P(B, C, D, E, F, G, H, A, R(15), 0x106aa07032bbd1b8);
    P(A, B, C, D, E, F, G, H, R( 0), 0x19a4c116b8d2d0c8);
    P(H, A, B, C, D, E, F, G, R( 1), 0x1e376c085141ab53);
    P(G, H, A, B, C, D, E, F, R( 2), 0x2748774cdf8eeb99);
    P(F, G, H, A, B, C, D, E, R( 3), 0x34b0bcb5e19b48a8);
    P(E, F, G, H, A, B, C, D, R( 4), 0x391c0cb3c5c95a63);
    P(D, E, F, G, H, A, B, C, R( 5), 0x4ed8aa4ae3418acb);
    P(C, D, E, F, G, H, A, B, R( 6), 0x5b9cca4f7763e373);
    P(B, C, D, E, F, G, H, A, R( 7), 0x682e6ff3d6b2b8a3);
    P(A, B, C, D, E, F, G, H, R( 8), 0x748f82ee5defb2fc);
    P(H, A, B, C, D, E, F, G, R( 9), 0x78a5636f43172f60);
    P(G, H, A, B, C, D, E, F, R(10), 0x84c87814a1f0ab72);
    P(F, G, H, A, B, C, D, E, R(11), 0x8cc702081a6439ec);
    P(E, F, G, H, A, B, C, D, R(12), 0x90befffa23631e28);
    P(D, E, F, G, H, A, B, C, R(13), 0xa4506cebde82bde9);
    P(C, D, E, F, G, H, A, B, R(14), 0xbef9a3f7b2c67915);
    P(B, C, D, E, F, G, H, A, R(15), 0xc67178f2e372532b);
    P(A, B, C, D, E, F, G, H, R( 0), 0xca273eceea26619c);
    P(H, A, B, C, D, E, F, G, R( 1), 0xd186b8c721c0c207);
    P(G, H, A, B, C, D, E, F, R( 2), 0xeada7dd6cde0eb1e);
    P(F, G, H, A, B, C, D, E, R( 3), 0xf57d4f7fee6ed178);
    P(E, F, G, H, A, B, C, D, R( 4), 0x06f067aa72176fba);
    P(D, E, F, G, H, A, B, C, R( 5), 0x0a637dc5a2c898a6);
    P(C, D, E, F, G, H, A, B, R( 6), 0x113f9804bef90dae);
    P(B, C, D, E, F, G, H, A, R( 7), 0x1b710b35131c471b);
    P(A, B, C, D, E, F, G, H, R( 8), 0x28db77f523047d84);
    P(H, A, B, C, D, E, F, G, R( 9), 0x32caab7b40c72493);
    P(G, H, A, B, C, D, E, F, R(10), 0x3c9ebe0a15c9bebc);
    P(F, G, H, A, B, C, D, E, R(11), 0x431d67c49c100d4c);
    P(E, F, G, H, A, B, C, D, R(12), 0x4cc5d4becb3e42b6);
    P(D, E, F, G, H, A, B, C, R(13), 0x597f299cfc657e2a);
    P(C, D, E, F, G, H, A, B, R(14), 0x5fcb6fab3ad6faec);
    P(B, C, D, E, F, G, H, A, R(15), 0x6c44198c4a475817);

    digest[0] += A; digest[1] += B; digest[2] += C; digest[3] += D;
    digest[4] += E; digest[5] += F; digest[6] += G; digest[7] += H;

    if (--nblk <= 0) return;
    input += (128 / sizeof(*input));
  }
}
