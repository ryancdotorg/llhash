#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>

#include "../rhashc.h"
#include "../sha2_256.h"

static unsigned char pad1024[] = {
  0x80, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,

  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  /* length 1024 bits, big endian uint64_t */
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x04, 0x00
};

void HMAC_SHA2_256_Clone(HMAC_SHA2_256_CTX *dst, const HMAC_SHA2_256_CTX *src) {
  // relies on .data being first
  if (src->datalen) {
    memcpy(dst, src, sizeof(*dst));
  } else {
    memcpy(dst + sizeof(dst->data), src + sizeof(dst->data), sizeof(*dst) - sizeof(dst->data));
  }
}

void HMAC_SHA2_256_Init(HMAC_SHA2_256_CTX *ctx, const void *key, size_t len) {
  uint8_t *hash = ctx->hmac + SHA2_256_BLOCK_LENGTH;

  SHA2_256_Init((SHA2_256_CTX*)ctx);
  memset(ctx->hmac, 0, sizeof(ctx->hmac));

  if (len > SHA2_256_BLOCK_LENGTH) {
    SHA2_256(hash, key, len);
  } else {
    memcpy(hash, key, len);
  }

  for (int i = 0; i < SHA2_256_BLOCK_LENGTH; ++i) {
    ctx->hmac[i] = 0x5c ^ hash[i]; // opad
    hash[i] ^= 0x36;               // ipad
  }

  ctx->bitlen = SHA2_256_BLOCK_LENGTH*8;
  // pre-process the first block of HASH(ipad || data)
  SHA2_256_Transform(ctx->state, hash, 1);
  memcpy(ctx->hmac + SHA2_256_BLOCK_LENGTH*2, pad1024, SHA2_256_BLOCK_LENGTH);
}

void HMAC_SHA2_256_Update(HMAC_SHA2_256_CTX *ctx, const uint8_t data[], size_t len) {
  SHA2_256_Update((SHA2_256_CTX*)ctx, data, len);
}

void HMAC_SHA2_256_Final(uint8_t hash[], HMAC_SHA2_256_CTX *ctx) {
  SHA2_256_Final(ctx->hmac + SHA2_256_BLOCK_LENGTH, (SHA2_256_CTX*)ctx);
  SHA2_256_Raw(hash, ctx->hmac, 3);
}

void HMAC_SHA2_256(uint8_t hash[], const uint8_t key[], size_t key_sz, const uint8_t msg[], size_t msg_sz) {
  HMAC_SHA2_256_CTX ctx;

  HMAC_SHA2_256_Init(&ctx, key, key_sz);
  HMAC_SHA2_256_Update(&ctx, msg, msg_sz);
  HMAC_SHA2_256_Final(hash, &ctx);
}
