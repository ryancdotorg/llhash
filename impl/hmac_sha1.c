#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>

#include "../rhashc.h"
#include "../sha1.h"

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

void HMAC_SHA1_Clone(HMAC_SHA1_CTX *dst, const HMAC_SHA1_CTX *src) {
  // relies on .data being first
  if (src->datalen) {
    memcpy(dst, src, sizeof(*dst));
  } else {
    memcpy(dst + sizeof(dst->data), src + sizeof(dst->data), sizeof(*dst) - sizeof(dst->data));
  }
}

void HMAC_SHA1_Init(HMAC_SHA1_CTX *ctx, const void *key, size_t len) {
  uint8_t *hash = ctx->hmac + SHA1_BLOCK_LENGTH;

  SHA1_Init((SHA1_CTX*)ctx);
  memset(ctx->hmac, 0, sizeof(ctx->hmac));

  if (len > SHA1_BLOCK_LENGTH) {
    SHA1(hash, key, len);
  } else {
    memcpy(hash, key, len);
  }

  for (int i = 0; i < SHA1_BLOCK_LENGTH; ++i) {
    ctx->hmac[i] = 0x5c ^ hash[i]; // opad
    hash[i] ^= 0x36;               // ipad
  }

  ctx->bitlen = SHA1_BLOCK_LENGTH*8;
  // pre-process the first block of HASH(ipad || data)
  SHA1_Transform(ctx->state, hash, 1);
  memcpy(ctx->hmac + SHA1_BLOCK_LENGTH*2, pad1024, SHA1_BLOCK_LENGTH);
}

void HMAC_SHA1_Update(HMAC_SHA1_CTX *ctx, const uint8_t data[], size_t len) {
  SHA1_Update((SHA1_CTX*)ctx, data, len);
}

void HMAC_SHA1_Final(uint8_t hash[], HMAC_SHA1_CTX *ctx) {
  SHA1_Final(ctx->hmac + SHA1_BLOCK_LENGTH, (SHA1_CTX*)ctx);
  SHA1_Raw(hash, ctx->hmac, 3);
}

void HMAC_SHA1(uint8_t hash[], const uint8_t key[], size_t key_sz, const uint8_t msg[], size_t msg_sz) {
  HMAC_SHA1_CTX ctx;

  HMAC_SHA1_Init(&ctx, key, key_sz);
  HMAC_SHA1_Update(&ctx, msg, msg_sz);
  HMAC_SHA1_Final(hash, &ctx);
}
