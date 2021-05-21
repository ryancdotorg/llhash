#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>

#include "../rhashc.h"
#include "../sha1.h"

void SHA1(uint8_t hash[], const uint8_t data[], size_t len) {
  static uint8_t padding[SHA1_BLOCK_LENGTH*2];
  uint64_t dblk = len / SHA1_BLOCK_LENGTH;
  int remaining_bytes = len & (SHA1_BLOCK_LENGTH-1);

  // initialize state
  uint32_t state[5] = {
    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0
  };

  // copy partial block bytes into the padding
  memcpy(padding, data + (dblk * SHA1_BLOCK_LENGTH), remaining_bytes);
  // set a 1 bit after the data
  padding[remaining_bytes] = 0x80;

  if (dblk) SHA1_Transform(state, data, dblk);
  // set length
  if (remaining_bytes < (SHA1_BLOCK_LENGTH-8)) {
    memset(padding + remaining_bytes + 1, 0, (SHA1_BLOCK_LENGTH-8) - (remaining_bytes + 1));
    ((uint64_t *)padding)[ 7] = htobe64(len * 8);
    SHA1_Transform(state, padding, 1);
  } else {
    memset(padding + remaining_bytes + 1, 0, (SHA1_BLOCK_LENGTH*2-8) - (remaining_bytes + 1));
    ((uint64_t *)padding)[15] = htobe64(len * 8);
    SHA1_Transform(state, padding, 2);
  }

  // write out result
  ((uint32_t *)hash)[0] = htobe32(state[0]);
  ((uint32_t *)hash)[1] = htobe32(state[1]);
  ((uint32_t *)hash)[2] = htobe32(state[2]);
  ((uint32_t *)hash)[3] = htobe32(state[3]);
  ((uint32_t *)hash)[4] = htobe32(state[4]);
}

void SHA1_Clone(SHA1_CTX *dst, const SHA1_CTX *src) {
  // relies on .data being first
  if (src->datalen) {
    memcpy(dst, src, sizeof(*dst));
  } else {
    // don't copy the data if there isn't any
    memcpy(dst + sizeof(dst->data), src + sizeof(dst->data), sizeof(*dst) - sizeof(dst->data));
  }
}

void SHA1_Init(SHA1_CTX *ctx) {
  ctx->bitlen = 0;
  ctx->datalen = 0;
  ctx->state[0] = 0x67452301;
  ctx->state[1] = 0xefcdab89;
  ctx->state[2] = 0x98badcfe;
  ctx->state[3] = 0x10325476;
  ctx->state[4] = 0xc3d2e1f0;
}

void SHA1_Update(SHA1_CTX *ctx, const uint8_t data[], size_t len) {
  size_t i = 0;

  uint8_t *input = (uint8_t *)data;

  if (ctx->datalen > 0) {
    i = SHA1_BLOCK_LENGTH - ctx->datalen;
    if (i > len) {
      memcpy(ctx->data + ctx->datalen, input, len);
      ctx->datalen += len;
      return;
    } else {
      memcpy(ctx->data + ctx->datalen, input, i);
      SHA1_Transform(ctx->state, ctx->data, 1);
      ctx->bitlen += SHA1_BLOCK_LENGTH*8;
      ctx->datalen = 0;
      input += i;
      len -= i;
    }
  }

  if (len >= SHA1_BLOCK_LENGTH) {
    i = len / SHA1_BLOCK_LENGTH;
    SHA1_Transform(ctx->state, input, i);
    len -= i * SHA1_BLOCK_LENGTH;
    input += i * SHA1_BLOCK_LENGTH;
    ctx->bitlen += i * SHA1_BLOCK_LENGTH*8;
  }

  memcpy(ctx->data, input, len);
  ctx->datalen = len;
}

void SHA1_Final(uint8_t hash[], SHA1_CTX *ctx) {
  uint32_t i = ctx->datalen;

  if (ctx->datalen < (SHA1_BLOCK_LENGTH-8)) {
    ctx->data[i++] = 0x80;
    memset(ctx->data + i, 0, (SHA1_BLOCK_LENGTH-8) - i);
  } else {
    ctx->data[i++] = 0x80;
    memset(ctx->data + i, 0, SHA1_BLOCK_LENGTH - i);
    SHA1_Transform(ctx->state, ctx->data, 1);
    memset(ctx->data, 0, SHA1_BLOCK_LENGTH-8);
  }

  // padding
  ctx->bitlen += ctx->datalen * 8;
  ((uint64_t *)ctx->data)[7] = htobe64(ctx->bitlen);

  SHA1_Transform(ctx->state, ctx->data, 1);

  ((uint32_t *)hash)[0] = htobe32(ctx->state[0]);
  ((uint32_t *)hash)[1] = htobe32(ctx->state[1]);
  ((uint32_t *)hash)[2] = htobe32(ctx->state[2]);
  ((uint32_t *)hash)[3] = htobe32(ctx->state[3]);
  ((uint32_t *)hash)[4] = htobe32(ctx->state[4]);
}

// caller responsible for making sure the buffer is big enough
uint64_t SHA1_Pad(uint8_t data[], size_t len) {
  uint64_t *bitlen_ptr;
  uint64_t nblk = len / SHA1_BLOCK_LENGTH;
  int remaining_bytes = len & (SHA1_BLOCK_LENGTH-1);

  // set a 1 bit after the data
  data[len] = 0x80;
  if (remaining_bytes < (SHA1_BLOCK_LENGTH-8)) {
    memset(data + len + 1, 0, (SHA1_BLOCK_LENGTH-8) - (remaining_bytes + 1));
    nblk += 1;
  } else {
    memset(data + len + 1, 0, (SHA1_BLOCK_LENGTH*2-8) - (remaining_bytes + 1));
    nblk += 2;
  }

  bitlen_ptr = (uint64_t *)(data + (nblk * SHA1_BLOCK_LENGTH) - 8);
  *bitlen_ptr = htobe64(len * 8);

  return nblk;
}

// caller is responsible for padding
void SHA1_Raw(uint8_t hash[], const uint8_t data[], uint64_t nblk) {
  uint32_t state[5] = {
    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0
  };

  SHA1_Transform(state, data, nblk);

  ((uint32_t *)hash)[0] = htobe32(state[0]);
  ((uint32_t *)hash)[1] = htobe32(state[1]);
  ((uint32_t *)hash)[2] = htobe32(state[2]);
  ((uint32_t *)hash)[3] = htobe32(state[3]);
  ((uint32_t *)hash)[4] = htobe32(state[4]);
}
