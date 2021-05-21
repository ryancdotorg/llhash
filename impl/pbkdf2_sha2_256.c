#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>

#include "../rhashc.h"
#include "../sha2_256.h"

void PBKDF2_HMAC_SHA2_256(
uint8_t dk[], size_t dk_sz,
const uint8_t pass[], size_t pass_sz,
const uint8_t salt[], size_t salt_sz,
int c) {
  HMAC_SHA2_256_CTX ctx, pctx;

  HMAC_SHA2_256_Init(&pctx, pass, pass_sz);

  int i, j, nout = 0, block = 1;
  uint8_t T[SHA2_256_DIGEST_LENGTH];
  uint8_t U[SHA2_256_DIGEST_LENGTH];

  uint8_t I_BE[4];

  while (nout < dk_sz) {
    *((uint32_t*)I_BE) = be32toh(block);
    HMAC_SHA2_256_Clone(&ctx, &pctx);
    HMAC_SHA2_256_Update(&ctx, salt, salt_sz);
    HMAC_SHA2_256_Update(&ctx, I_BE, sizeof(I_BE));
    HMAC_SHA2_256_Final(U, &ctx);
    memcpy(T, U, sizeof(T));
    for (i = 1; i < c; ++i) {
      HMAC_SHA2_256_Clone(&ctx, &pctx);
      HMAC_SHA2_256_Update(&ctx, U, sizeof(U));
      HMAC_SHA2_256_Final(U, &ctx);
      for (j = 0; j < sizeof(T); ++j) { T[j] ^= U[j]; }
    }
    for (i = 0; nout < dk_sz && i < sizeof(T); ++i, ++nout) {
      dk[nout] = T[i];
    }
    ++block;
  }
}
