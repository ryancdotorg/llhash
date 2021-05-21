#pragma once

#include <stddef.h>
#include <stdint.h>

#define SHA1_DIGEST_LENGTH   20
#define SHA1_BLOCK_LENGTH    64

#define SHA1_USING_GENERIC    0
#define SHA1_USING_NATIVE     1
#define SHA1_USING_NAYUKI64   2
#define SHA1_USING_SSSE3      3
#define SHA1_USING_AVX        4
#define SHA1_USING_AVX2       5
#define SHA1_USING_SHAEXT     6

#define SHA1_ENABLE_GENERIC  (1<<SHA1_USING_GENERIC)
#define SHA1_ENABLE_NATIVE   (1<<SHA1_USING_NATIVE)
#define SHA1_ENABLE_NAYUKI64 (1<<SHA1_USING_NAYUKI64)
#define SHA1_ENABLE_SSSE3    (1<<SHA1_USING_SSSE3)
#define SHA1_ENABLE_AVX      (1<<SHA1_USING_AVX)
#define SHA1_ENABLE_AVX2     (1<<SHA1_USING_AVX2)
#define SHA1_ENABLE_SHAEXT   (1<<SHA1_USING_SHAEXT)

#define SHA1_DESC_GENERIC    "Rhashc (C)"
#define SHA1_DESC_NATIVE     "Rhashc (C, -march=native)"
#define SHA1_DESC_NAYUKI64   "Nayuki (x64 asm)"
#define SHA1_DESC_SSSE3      "Intel SSSE3 (x64 asm)"
#define SHA1_DESC_AVX        "Intel AVX (x64 asm)"
#define SHA1_DESC_AVX2       "Intel AVX2 (x64 asm)"
#define SHA1_DESC_SHAEXT     "Intel SHA-NI (x64 asm)"

char * SHA1_Describe(int impl);
int SHA1_Register(int enable);
void (*SHA1_Transform)(uint32_t *digest, const char *data, uint32_t nblk);

typedef struct {
  uint8_t data[SHA1_BLOCK_LENGTH];
  uint64_t bitlen;
  uint32_t state[5];
  uint32_t datalen;
} SHA1_CTX;

typedef struct {
  uint8_t data[SHA1_BLOCK_LENGTH];
  uint64_t bitlen;
  uint32_t state[5];
  uint32_t datalen;
  uint8_t hmac[SHA1_BLOCK_LENGTH*3];
} HMAC_SHA1_CTX;

void SHA1_Clone(SHA1_CTX *dst, const SHA1_CTX *src);
void SHA1_Init(SHA1_CTX *ctx);
void SHA1_Update(SHA1_CTX *ctx, const uint8_t data[], size_t len);
void SHA1_Final(uint8_t hash[], SHA1_CTX *ctx);
void SHA1(uint8_t hash[], const uint8_t data[], size_t len);

uint64_t SHA1_Pad(uint8_t data[], size_t len);
void SHA1_Raw(uint8_t hash[], const uint8_t data[], uint64_t nblk);

void HMAC_SHA1_Clone(HMAC_SHA1_CTX *dst, const HMAC_SHA1_CTX *src);
void HMAC_SHA1_Init(HMAC_SHA1_CTX *ctx, const void *key, size_t len);
void HMAC_SHA1_Update(HMAC_SHA1_CTX *ctx, const uint8_t data[], size_t len);
void HMAC_SHA1_Final(uint8_t hash[], HMAC_SHA1_CTX *ctx);
void HMAC_SHA1(uint8_t hash[], const uint8_t key[], size_t key_sz, const uint8_t msg[], size_t msg_sz);

void PBKDF2_HMAC_SHA1(
  uint8_t dk[], size_t dk_sz,
  const uint8_t pass[], size_t pass_sz,
  const uint8_t salt[], size_t salt_sz,
  int c
);
