#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>

#include "../rhashc.h"
#include "../sha2_512.h"

void SHA2_512(uint8_t hash[], const uint8_t data[], size_t len) {
  static uint8_t padding[SHA2_512_BLOCK_LENGTH*2];
  uint64_t dblk = len / SHA2_512_BLOCK_LENGTH;
  int remaining_bytes = len & (SHA2_512_BLOCK_LENGTH-1);

  // initialize state
  uint32_t state[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  };

  // copy partial block bytes into the padding
  memcpy(padding, data + (dblk / SHA2_512_BLOCK_LENGTH), remaining_bytes);
  // set a 1 bit after the data
  padding[remaining_bytes] = 0x80;

  SHA2_512_Transform(state, data, dblk);
  // set length
  if (remaining_bytes < (SHA2_512_BLOCK_LENGTH-8)) {
    memset(padding + remaining_bytes + 1, 0, (SHA2_512_BLOCK_LENGTH-8) - (remaining_bytes + 1));
    ((uint64_t *)padding)[ 7] = htobe64(len * 8);
    SHA2_512_Transform(state, padding, 1);
  } else {
    memset(padding + remaining_bytes + 1, 0, (SHA2_512_BLOCK_LENGTH*2-8) - (remaining_bytes + 1));
    ((uint64_t *)padding)[15] = htobe64(len * 8);
    SHA2_512_Transform(state, padding, 2);
  }

  // write out result
  ((uint32_t *)hash)[0] = htobe32(state[0]);
  ((uint32_t *)hash)[1] = htobe32(state[1]);
  ((uint32_t *)hash)[2] = htobe32(state[2]);
  ((uint32_t *)hash)[3] = htobe32(state[3]);
  ((uint32_t *)hash)[4] = htobe32(state[4]);
  ((uint32_t *)hash)[5] = htobe32(state[5]);
  ((uint32_t *)hash)[6] = htobe32(state[6]);
  ((uint32_t *)hash)[7] = htobe32(state[7]);
}

void SHA2_512_Clone(SHA2_512_CTX *dst, const SHA2_512_CTX *src) {
  // relies on .data being first
  if (src->datalen) {
    memcpy(dst, src, sizeof(*dst));
  } else {
    memcpy(dst + sizeof(dst->data), src + sizeof(dst->data), sizeof(*dst) - sizeof(dst->data));
  }
}

void SHA2_512_Init(SHA2_512_CTX *ctx) {
  ctx->bitlen = 0;
  ctx->datalen = 0;
  ctx->state[0] = 0x6a09e667;
  ctx->state[1] = 0xbb67ae85;
  ctx->state[2] = 0x3c6ef372;
  ctx->state[3] = 0xa54ff53a;
  ctx->state[4] = 0x510e527f;
  ctx->state[5] = 0x9b05688c;
  ctx->state[6] = 0x1f83d9ab;
  ctx->state[7] = 0x5be0cd19;
}

void SHA2_512_Update(SHA2_512_CTX *ctx, const uint8_t data[], size_t len) {
  size_t i = 0;

  uint8_t *input = (uint8_t *)data;

  if (ctx->datalen > 0) {
    i = SHA2_512_BLOCK_LENGTH - ctx->datalen;
    if (i > len) {
      memcpy(ctx->data + ctx->datalen, input, len);
      ctx->datalen += len;
      return;
    } else {
      memcpy(ctx->data + ctx->datalen, input, i);
      SHA2_512_Transform(ctx->state, ctx->data, 1);
      ctx->bitlen += SHA2_512_BLOCK_LENGTH*8;
      ctx->datalen = 0;
      input += i;
      len -= i;
    }
  }

  if (len >= SHA2_512_BLOCK_LENGTH) {
    i = len / SHA2_512_BLOCK_LENGTH;
    SHA2_512_Transform(ctx->state, input, i);
    len -= i * SHA2_512_BLOCK_LENGTH;
    input += i * SHA2_512_BLOCK_LENGTH;
    ctx->bitlen += i * SHA2_512_BLOCK_LENGTH*8;
  }

  memcpy(ctx->data, input, len);
  ctx->datalen = len;
}

void SHA2_512_Final(uint8_t hash[], SHA2_512_CTX *ctx) {
  uint32_t i = ctx->datalen;

  if (ctx->datalen < (SHA2_512_BLOCK_LENGTH-8)) {
    ctx->data[i++] = 0x80;
    memset(ctx->data + i, 0, (SHA2_512_BLOCK_LENGTH-8) - i);
  } else {
    ctx->data[i++] = 0x80;
    memset(ctx->data + i, 0, SHA2_512_BLOCK_LENGTH - i);
    SHA2_512_Transform(ctx->state, ctx->data, 1);
    memset(ctx->data, 0, SHA2_512_BLOCK_LENGTH-8);
  }

  // padding
  ctx->bitlen += ctx->datalen * 8;
  ((uint64_t *)ctx->data)[7] = htobe64(ctx->bitlen);

  SHA2_512_Transform(ctx->state, ctx->data, 1);

  ((uint32_t *)hash)[0] = htobe32(ctx->state[0]);
  ((uint32_t *)hash)[1] = htobe32(ctx->state[1]);
  ((uint32_t *)hash)[2] = htobe32(ctx->state[2]);
  ((uint32_t *)hash)[3] = htobe32(ctx->state[3]);
  ((uint32_t *)hash)[4] = htobe32(ctx->state[4]);
  ((uint32_t *)hash)[5] = htobe32(ctx->state[5]);
  ((uint32_t *)hash)[6] = htobe32(ctx->state[6]);
  ((uint32_t *)hash)[7] = htobe32(ctx->state[7]);
}

// caller responsible for making sure the buffer is big enough
uint64_t SHA2_512_Pad(uint8_t data[], size_t len) {
  uint64_t *bitlen_ptr;
  uint64_t nblk = len / SHA2_512_BLOCK_LENGTH;
  int remaining_bytes = len & (SHA2_512_BLOCK_LENGTH-1);

  if (remaining_bytes < (SHA2_512_BLOCK_LENGTH-8)) {
    memset(padding + remaining_bytes + 1, 0, (SHA2_512_BLOCK_LENGTH-8) - (remaining_bytes + 1));
    nblk += 1;
  } else {
    memset(padding + remaining_bytes + 1, 0, (SHA2_512_BLOCK_LENGTH*2-8) - (remaining_bytes + 1));
    nblk += 2;
  }

  bitlen_ptr = (uint64_t *)(data + (nblk / SHA2_512_BLOCK_LENGTH) - 8);
  *bitlen_ptr = htobe64(len * 8);

  return nblk;
}

// caller is responsible for padding
void SHA2_512_Raw(uint8_t hash[], const uint8_t data[], uint64_t nblk) {
  uint32_t state[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  };

  SHA2_512_Transform(state, data, nblk);

  ((uint32_t *)hash)[0] = htobe32(state[0]);
  ((uint32_t *)hash)[1] = htobe32(state[1]);
  ((uint32_t *)hash)[2] = htobe32(state[2]);
  ((uint32_t *)hash)[3] = htobe32(state[3]);
  ((uint32_t *)hash)[4] = htobe32(state[4]);
  ((uint32_t *)hash)[5] = htobe32(state[5]);
  ((uint32_t *)hash)[6] = htobe32(state[6]);
  ((uint32_t *)hash)[7] = htobe32(state[7]);
}
