#pragma once

#include <stddef.h>
#include <stdint.h>

#define SHA2_512_DIGEST_LENGTH   64
#define SHA2_512_BLOCK_LENGTH   128

#define SHA2_512_USING_GENERIC         0
#define SHA2_512_USING_NATIVE          1
#define SHA2_512_USING_NAYUKI64        2
#define SHA2_512_USING_INTEL_SSSE3     3
#define SHA2_512_USING_INTEL_AVX       4
#define SHA2_512_USING_INTEL_AVX2      5
#define SHA2_512_USING_CRYPTOGAMS_GEN  6
#define SHA2_512_USING_CRYPTOGAMS_XOP  7
#define SHA2_512_USING_CRYPTOGAMS_AVX  8
#define SHA2_512_USING_CRYPTOGAMS_AVX2 9

#define SHA2_512_ENABLE_GENERIC         (1<<SHA2_512_USING_GENERIC)
#define SHA2_512_ENABLE_NATIVE          (1<<SHA2_512_USING_NATIVE)
#define SHA2_512_ENABLE_NAYUKI64        (1<<SHA2_512_USING_NAYUKI64)
#define SHA2_512_ENABLE_INTEL_SSSE3     (1<<SHA2_512_USING_INTEL_SSSE3)
#define SHA2_512_ENABLE_INTEL_AVX       (1<<SHA2_512_USING_INTEL_AVX)
#define SHA2_512_ENABLE_INTEL_AVX2      (1<<SHA2_512_USING_INTEL_AVX2)
#define SHA2_512_ENABLE_CRYPTOGAMS_GEN  (1<<SHA2_512_USING_CRYPTOGAMS_GEN)
#define SHA2_512_ENABLE_CRYPTOGAMS_XOP  (1<<SHA2_512_USING_CRYPTOGAMS_XOP)
#define SHA2_512_ENABLE_CRYPTOGAMS_AVX  (1<<SHA2_512_USING_CRYPTOGAMS_AVX)
#define SHA2_512_ENABLE_CRYPTOGAMS_AVX2 (1<<SHA2_512_USING_CRYPTOGAMS_AVX2)

#define SHA2_512_DESC_GENERIC          "Rhashc (C)"
#define SHA2_512_DESC_NATIVE           "Rhashc (C, -march=native)"
#define SHA2_512_DESC_NAYUKI64         "Nayuki (x64 asm)"
#define SHA2_512_DESC_INTEL_SSSE3      "Intel SSSE3 (x64 asm)"
#define SHA2_512_DESC_INTEL_AVX        "Intel AVX (x64 asm)"
#define SHA2_512_DESC_INTEL_AVX2       "Intel AVX2 (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_GEN   "Cryptogams Generic (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_XOP   "Cryptogams XOP (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_AVX   "Cryptogams AVX (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_AVX2  "Cryptogams AVX2 (x64 asm)"

char * SHA2_512_Describe(int impl);
int SHA2_512_Register(int enable);
void (*SHA2_512_Transform)(uint64_t *digest, const char *data, uint32_t nblk);

typedef struct {
  uint8_t data[SHA2_512_BLOCK_LENGTH];
  uint64_t bitlen;
  uint64_t state[8];
  uint32_t datalen;
} SHA2_512_CTX;

typedef struct {
  uint8_t data[SHA2_512_BLOCK_LENGTH];
  uint64_t bitlen;
  uint64_t state[8];
  uint32_t datalen;
  uint8_t hmac[SHA2_512_BLOCK_LENGTH*3];
} HMAC_SHA2_512_CTX;

void SHA2_512_Clone(SHA2_512_CTX *dst, const SHA2_512_CTX *src);
void SHA2_512_Init(SHA2_512_CTX *ctx);
void SHA2_512_Update(SHA2_512_CTX *ctx, const uint8_t data[], size_t len);
void SHA2_512_Final(uint8_t hash[], SHA2_512_CTX *ctx);
void SHA2_512(uint8_t hash[], const uint8_t data[], size_t len);

uint64_t SHA2_512_Pad(uint8_t data[], size_t len);
void SHA2_512_Raw(uint8_t hash[], const uint8_t data[], uint64_t nblk);

void HMAC_SHA2_512_Clone(HMAC_SHA2_512_CTX *dst, const HMAC_SHA2_512_CTX *src);
void HMAC_SHA2_512_Init(HMAC_SHA2_512_CTX *ctx, const void *key, size_t len);
void HMAC_SHA2_512_Update(HMAC_SHA2_512_CTX *ctx, const uint8_t data[], size_t len);
void HMAC_SHA2_512_Final(uint8_t hash[], HMAC_SHA2_512_CTX *ctx);
void HMAC_SHA2_512(uint8_t hash[], const uint8_t key[], size_t key_sz, const uint8_t msg[], size_t msg_sz);

void PBKDF2_HMAC_SHA2_512(
  uint8_t dk[], size_t dk_sz,
  const uint8_t pass[], size_t pass_sz,
  const uint8_t salt[], size_t salt_sz,
  int c
);
