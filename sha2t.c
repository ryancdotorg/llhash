// aesrng.c - make sure you compile with -O2 -maes
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <stddef.h>
#include <fcntl.h>

#include "macros.h"
#include "llhash.h"

#define CH_32(x,y,z) (((x) & (y)) ^ (~(x) & (z)))
#define MAJ_32(x,y,z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define SIG0_32(x) (ROR32(x, 7) ^ ROR32(x,18) ^ ((x) >>  3))
#define SIG1_32(x) (ROR32(x,17) ^ ROR32(x,19) ^ ((x) >> 10))
#define EP0_32(x)  (ROR32(x, 2) ^ ROR32(x,13) ^ ROR32(x,22))
#define EP1_32(x)  (ROR32(x, 6) ^ ROR32(x,11) ^ ROR32(x,25))

void sha256iv(uint8_t *out, const uint32_t iv[8], const void *buf, size_t len) {
  uint8_t data[64], padding[128], *in = (uint8_t *)buf;

  uint32_t state[8], m[64];
  for (int i = 0; i < 8; ++i) { state[i] = iv[i]; }

  const uint32_t k[64] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
    0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
    0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
    0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
    0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
    0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  };

  // copy up to 63 bytes of input into padding buffer
  unsigned int p = 0, q = len - (len & 63);
  while (q < len) { padding[p++] = in[q++]; }
  padding[p++] = 0x80; // fill padding buffer
  if (p <= 56) { while (p <  56) { padding[p++] = 0x00; } }
  else {         while (p < 120) { padding[p++] = 0x00; } }
  for (int s = 56; s >= 0; s -= 8) { padding[p++] = (len * 8) >> s; }

  len -= len & 63;

  unsigned int ipos = 0, ppos = 0;
  while (ppos < p) {
    if (ipos < len) { memcpy(data, in + ipos, 64); ipos += 64; }
    else { memcpy(data, padding + ppos, 64); ppos += 64; }

    // sha2 32bit transform
    uint32_t a, b, c, d, e, f, g, h, i, j, t1, t2;

    for (i = 0, j = 0; i < 16; ++i, j += 4) {
      m[i] = ((uint32_t)(data[j+0]) << 24) | ((uint32_t)(data[j+1]) << 16) |
             ((uint32_t)(data[j+2]) <<  8) | ((uint32_t)(data[j+3]) <<  0);
    }

    for (; i < 64; ++i) {
      m[i] = SIG1_32(m[i -  2]) + m[i -  7] +
             SIG0_32(m[i - 15]) + m[i - 16];
    }

    a = state[0]; b = state[1]; c = state[2]; d = state[3];
    e = state[4]; f = state[5]; g = state[6]; h = state[7];

    for (i = 0; i < 64; ++i) {
      t1 = h + EP1_32(e) + CH_32(e,f,g) + k[i] + m[i];
      t2 = EP0_32(a) + MAJ_32(a,b,c);
      h = g; g = f; f = e; e = d + t1;
      d = c; c = b; b = a; a = t1 + t2;
    }

    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
  }

  // copy out big endian
  for (int i = 0; i < 32; ++i) { out[i] = state[i>>2] >> (24 - (i & 3) * 8); }
}

void sha256(uint8_t *out, const void *buf, size_t len) {
  uint32_t iv[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  };
  sha256iv(out, iv, buf, len);
}

// based on FIPS 180-4 5.3.6
int sha256t(uint32_t iv_out[8], unsigned int t) {
  uint32_t iv[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  };

  if (t == 256) {
    for (int i = 0; i < 8; ++i) { iv_out[i] = iv[i]; }
    return 0;
  } else if (t == 224) {
    iv_out[0] = 0xc1059ed8; iv_out[1] = 0x367cd507;
    iv_out[2] = 0x3070dd17; iv_out[3] = 0xf70e5939;
    iv_out[4] = 0xffc00b31; iv_out[5] = 0x68581511;
    iv_out[6] = 0x64f98fa7; iv_out[7] = 0xbefa4fa4;
    return 0;
  } else if (t > 256) {
    return -1;
  }
  for (int i = 0; i < 8; ++i) { iv[i] ^= 0xa5a5a5a5; }

  uint8_t hash[32], buf[] = "SHA-256/256";
  uint8_t *p = buf + 8;
  if (t > 99) { *p++ = '0' + t / 100; }
  if (t >  9) { *p++ = '0' + (t / 10) % 10; }
  *p++ = '0' + t % 10;
  *p = '\0';
  sha256iv(hash, iv, buf, p - buf);
  for (int i = 0, j = 0; i < 8; ++i, j += 4) {
    iv_out[i] = ((uint32_t)(hash[0+j]) << 24) | ((uint32_t)(hash[1+j]) << 16) |
                ((uint32_t)(hash[2+j]) <<  8) | ((uint32_t)(hash[3+j]) <<  0);
  }
  return 0;
}

#define CH_64(x,y,z) ((z) ^ ((x) & ((y) ^ (z))))
#define MAJ_64(x,y,z) (((x) & (y)) | ((z) & ((x) | (y))))
#define SIG0_64(x) (ROR64(x, 1) ^ ROR64(x, 8) ^ ((x) >>  7))
#define SIG1_64(x) (ROR64(x,19) ^ ROR64(x,61) ^ ((x) >>  6))
#define EP0_64(x)  (ROR64(x,28) ^ ROR64(x,34) ^ ROR64(x,39))
#define EP1_64(x)  (ROR64(x,14) ^ ROR64(x,18) ^ ROR64(x,41))

void sha512iv(uint8_t *out, const uint64_t iv[8], const void *buf, size_t len) {
  uint8_t data[128], padding[256], *in = (uint8_t *)buf;

  uint64_t state[8], m[80];
  for (int i = 0; i < 8; ++i) { state[i] = iv[i]; }

  const uint64_t k[80] = {
    0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f,
    0xe9b5dba58189dbbc, 0x3956c25bf348b538, 0x59f111f1b605d019,
    0x923f82a4af194f9b, 0xab1c5ed5da6d8118, 0xd807aa98a3030242,
    0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
    0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235,
    0xc19bf174cf692694, 0xe49b69c19ef14ad2, 0xefbe4786384f25e3,
    0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65, 0x2de92c6f592b0275,
    0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
    0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f,
    0xbf597fc7beef0ee4, 0xc6e00bf33da88fc2, 0xd5a79147930aa725,
    0x06ca6351e003826f, 0x142929670a0e6e70, 0x27b70a8546d22ffc,
    0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
    0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6,
    0x92722c851482353b, 0xa2bfe8a14cf10364, 0xa81a664bbc423001,
    0xc24b8b70d0f89791, 0xc76c51a30654be30, 0xd192e819d6ef5218,
    0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
    0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99,
    0x34b0bcb5e19b48a8, 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb,
    0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3, 0x748f82ee5defb2fc,
    0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
    0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915,
    0xc67178f2e372532b, 0xca273eceea26619c, 0xd186b8c721c0c207,
    0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178, 0x06f067aa72176fba,
    0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
    0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc,
    0x431d67c49c100d4c, 0x4cc5d4becb3e42b6, 0x597f299cfc657e2a,
    0x5fcb6fab3ad6faec, 0x6c44198c4a475817
  };

  // copy up to 127 bytes of input into padding buffer
  unsigned int p = 0, q = len - (len & 127);
  while (q < len) { padding[p++] = in[q++]; }
  padding[p++] = 0x80; // fill padding buffer
  if (p <= 112) { while (p < 120) { padding[p++] = 0x00; } }
  else {          while (p < 248) { padding[p++] = 0x00; } }
  for (int s = 56; s >= 0; s -= 8) { padding[p++] = (len * 8) >> s; }

  len -= len & 127;

  unsigned int ipos = 0, ppos = 0;
  while (ppos < p) {
    if (ipos < len) { memcpy(data, in + ipos, 128); ipos += 128; }
    else { memcpy(data, padding + ppos, 128); ppos += 128; }

    // sha2 64bit transform
    uint64_t a, b, c, d, e, f, g, h, i, j, t1, t2;

    for (i = 0, j = 0; i < 16; ++i, j += 8) {
      m[i] = ((uint64_t)(data[j+0]) << 56) | ((uint64_t)(data[j+1]) << 48) |
             ((uint64_t)(data[j+2]) << 40) | ((uint64_t)(data[j+3]) << 32) |
             ((uint64_t)(data[j+4]) << 24) | ((uint64_t)(data[j+5]) << 16) |
             ((uint64_t)(data[j+6]) <<  8) | ((uint64_t)(data[j+7]) <<  0);
    }

    for (; i < 80; ++i) {
      m[i] = SIG1_64(m[i -  2]) + m[i -  7] +
             SIG0_64(m[i - 15]) + m[i - 16];
    }

    a = state[0]; b = state[1]; c = state[2]; d = state[3];
    e = state[4]; f = state[5]; g = state[6]; h = state[7];

    for (i = 0; i < 80; ++i) {
      t1 = h + EP1_64(e) + CH_64(e,f,g) + k[i] + m[i];
      t2 = EP0_64(a) + MAJ_64(a,b,c);
      h = g; g = f; f = e; e = d + t1;
      d = c; c = b; b = a; a = t1 + t2;
    }

    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
  }

  // copy out big endian
  for (int i = 0; i < 64; ++i) { out[i] = state[i>>3] >> (56 - (i & 7) * 8); }
}

void sha512(uint8_t *out, const void *buf, size_t len) {
  uint64_t iv[8] = {
    0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b,
    0xa54ff53a5f1d36f1, 0x510e527fade682d1, 0x9b05688c2b3e6c1f,
    0x1f83d9abfb41bd6b, 0x5be0cd19137e2179
  };
  sha512iv(out, iv, buf, len);
}

// per FIPS 180-4 5.3.6
int sha512t(uint64_t iv_out[8], unsigned int t) {
  uint64_t iv[8] = {
    0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b,
    0xa54ff53a5f1d36f1, 0x510e527fade682d1, 0x9b05688c2b3e6c1f,
    0x1f83d9abfb41bd6b, 0x5be0cd19137e2179
  };

  if (t == 512) {
    for (int i = 0; i < 8; ++i) { iv_out[i] = iv[i]; }
    return 0;
  } else if (t == 384) {
    iv_out[0] = 0xcbbb9d5dc1059ed8; iv_out[1] = 0x629a292a367cd507;
    iv_out[2] = 0x9159015a3070dd17; iv_out[3] = 0x152fecd8f70e5939;
    iv_out[4] = 0x67332667ffc00b31; iv_out[5] = 0x8eb44a8768581511;
    iv_out[6] = 0xdb0c2e0d64f98fa7; iv_out[7] = 0x47b5481dbefa4fa4;
    return 0;
  } else if (t > 512) {
    return -1;
  }
  for (int i = 0; i < 8; ++i) { iv[i] ^= 0xa5a5a5a5a5a5a5a5; }

  uint8_t hash[64], buf[] = "SHA-512/512";
  uint8_t *p = buf + 8;
  if (t > 99) { *p++ = '0' + t / 100; }
  if (t >  9) { *p++ = '0' + (t / 10) % 10; }
  *p++ = '0' + t % 10;
  *p = '\0';
  sha512iv(hash, iv, buf, p - buf);
  for (int i = 0, j = 0; i < 8; ++i, j += 8) {
    iv_out[i] = ((uint64_t)(hash[0+j]) << 56) | ((uint64_t)(hash[1+j]) << 48) |
                ((uint64_t)(hash[2+j]) << 40) | ((uint64_t)(hash[3+j]) << 32) |
                ((uint64_t)(hash[4+j]) << 24) | ((uint64_t)(hash[5+j]) << 16) |
                ((uint64_t)(hash[6+j]) <<  8) | ((uint64_t)(hash[7+j]) <<  0);
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    uint32_t iv256[8];
    uint64_t iv512[8];

    printf("#include <stdint.h>\n\n");
    printf("uint32_t sha2_256_iv[][8] = {\n");
    printf("  { 0, 0, 0, 0, 0, 0, 0, 0 },\n");
    for (int bits = 1; bits < 256; bits += 1) {
      sha256t(iv256, bits);
      printf("  /* SHA256/%u */\n", bits);
      printf("  { 0x%08x, 0x%08x, 0x%08x, 0x%08x,\n", iv256[0], iv256[1], iv256[2], iv256[3]);
      printf("    0x%08x, 0x%08x, 0x%08x, 0x%08x }",  iv256[4], iv256[5], iv256[6], iv256[7]);
      if (bits < 256) printf(",");
      printf("\n");
    }
    printf("};\n\n");

    printf("uint64_t sha2_512_iv[][8] = {\n");
    printf("  { 0, 0, 0, 0, 0, 0, 0, 0 },\n");
    for (int bits = 1; bits < 512; bits += 1) {
      sha512t(iv512, bits);
      printf("  /* SHA512/%u */\n", bits);
      printf("  { 0x%016zx, 0x%016zx,\n", iv512[0], iv512[1]);
      printf("    0x%016zx, 0x%016zx,\n", iv512[2], iv512[3]);
      printf("    0x%016zx, 0x%016zx,\n", iv512[4], iv512[5]);
      printf("    0x%016zx, 0x%016zx }",  iv512[6], iv512[7]);
      if (bits < 512) printf(",");
      printf("\n");
    }
    printf("};\n");
  } else if (argc == 2) {
    uint32_t iv256[8];
    uint64_t iv512[8];
    int bits = atoi(argv[1]);

    if (bits <= 256) {
      sha256t(iv256, bits);
      printf("SHA-256/%u\n", bits);
      for (int i = 0; i < 8; ++i) {
        printf("H(0)%u = 0x%08x\n", i, iv256[i]);
      }
    }

    if (bits <= 512) {
      sha512t(iv512, bits);
      printf("SHA-512/%u\n", bits);
      for (int i = 0; i < 8; ++i) {
        printf("H(0)%u = 0x%016zx\n", i, iv512[i]);
      }
    }
  } else if (argc == 3) {
    uint32_t iv256[8];
    uint64_t iv512[8];
    uint8_t hash[64];
    int bits = atoi(argv[1]);

    if (bits <= 256) {
      sha256t(iv256, bits);
      printf("SHA-256/%u\n", bits);
      for (int i = 0; i < 8; ++i) {
        printf("H(0)%u = 0x%08x\n", i, iv256[i]);
      }
      sha256iv(hash, iv256, argv[2], strlen(argv[2]));
      for (int i = 0; i*8 < bits; ++i) { printf("%02x", hash[i]); }
      printf("\n");
    }

    if (bits <= 512) {
      sha512t(iv512, bits);
      printf("SHA-512/%u\n", bits);
      for (int i = 0; i < 8; ++i) {
        printf("H(0)%u = 0x%016zx\n", i, iv512[i]);
      }
      sha512iv(hash, iv512, argv[2], strlen(argv[2]));
      for (int i = 0; i*8 < bits; ++i) { printf("%02x", hash[i]); }
      printf("\n");
    }

    return 0;
  } else {
    return 1;
  }

  return 0;
}
