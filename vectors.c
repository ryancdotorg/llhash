#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>

#include <math.h>
#include <time.h>
#include <x86intrin.h>

#include "gen/test_vectors.h"

#include "llhash.h"

#include "gen/md/md4/hmac.h"
#include "gen/md/md4/hash.h"

#include "gen/md/md5/hmac.h"
#include "gen/md/md5/hash.h"

#include "gen/md/ripemd160/hmac.h"
#include "gen/md/ripemd160/hash.h"

#include "gen/md/sha1/hmac.h"
#include "gen/md/sha1/hash.h"

#include "gen/md/sha2_224/hash.h"
#include "gen/md/sha2_224/hmac.h"

#include "gen/md/sha2_256/hash.h"
#include "gen/md/sha2_256/hmac.h"

#include "gen/md/sha2_384/hmac.h"
#include "gen/md/sha2_384/hash.h"

#include "gen/md/sha2_512/hmac.h"
#include "gen/md/sha2_512/hash.h"

static char * hex(char *out, const void *in, size_t len, int color) {
  char *ret = out;
  uint8_t p = 1;
  for (size_t i = 0; i < len; ++i) {
    uint8_t c = ((uint8_t *)in)[i];
    if (color) {
      if (c == 0 && p != 0) {
        out += sprintf(out, "\033[38;5;23m");
      } else if (c != 0 && p == 0) {
        out += sprintf(out, "\033[m");
      }
    }
    out += sprintf(out, "%02x", ((uint8_t *)in)[i]);
    p = c;
  }
  if (color) out += sprintf(out, "\033[m");
  *out = '\0';
  return ret;
}

#define RUN_HASH(H) \
  id = total = fail = 0; \
  for (;;) { \
    m_sz = sizeof(m); d_sz = sizeof(d); \
    ret = H##_hash_vector(m, &m_sz, d, &d_sz, ++id); \
    if (ret < 0) { \
      if (ret != -9) { \
        fprintf(stderr, "id: %d -> %d\n", id, ret); \
        continue; \
      } else { \
        break; \
      } \
    } \
 \
    H(m, m_sz, x); \
    if (memcmp(d, x, d_sz) != 0) { \
      ++fail; \
      printf("{\"algo\": \"" #H "\", \"id\": %d, ", id); \
      printf("\"message\": \"%s\", ", hex(buf, m, m_sz, 0)); \
      printf("\"expect\": \"%s\", ",  hex(buf, d, d_sz, 0)); \
      printf("\"actual\": \"%s\"}\n", hex(buf, x, d_sz, 0)); \
    } \
    ++total; \
  } \
  fprintf(stderr, "Hash vectors for " #H ": %d/%d\n", total - fail, total);

#define RUN_HMAC(H) \
  id = total = fail = 0; \
  for (;;) { \
    k_sz = sizeof(k); m_sz = sizeof(m); d_sz = sizeof(d); \
    ret = H##_hmac_vector(k, &k_sz, m, &m_sz, d, &d_sz, ++id); \
    if (ret < 0) { \
      if (ret != -9) { \
        fprintf(stderr, "id: %d -> %d\n", id, ret); \
        continue; \
      } else { \
        break; \
      } \
    } \
 \
    HMAC_##H(x, k, k_sz, m, m_sz); \
    if (memcmp(d, x, d_sz) != 0) { \
      ++fail; \
      printf("{\"algo\": \"" #H "\", \"id\": %d, ", id); \
      printf("\"key\": \"%s\", ",     hex(buf, k, k_sz, 0)); \
      printf("\"message\": \"%s\", ", hex(buf, m, m_sz, 0)); \
      printf("\"expect\": \"%s\", ",  hex(buf, d, d_sz, 0)); \
      printf("\"actual\": \"%s\"}\n", hex(buf, x, d_sz, 0)); \
    } \
    ++total; \
  } \
  fprintf(stderr, "HMAC vectors for " #H ": %d/%d\n", total - fail, total); \

int main(int argc, char *argv[]) {
  unsigned char buf[65536];
  unsigned char k[1024], m[1024], d[1024], x[1024];
  size_t k_sz, m_sz, d_sz;

  int id, ret, fail, total;

  RUN_HASH(MD4);
  RUN_HASH(MD5);
  RUN_HASH(RIPEMD160);
  RUN_HASH(SHA1);
  RUN_HASH(SHA2_224);
  RUN_HASH(SHA2_256);
  RUN_HASH(SHA2_384);
  RUN_HASH(SHA2_512);

  RUN_HMAC(MD4);
  RUN_HMAC(MD5);
  RUN_HMAC(RIPEMD160);
  RUN_HMAC(SHA1);
  RUN_HMAC(SHA2_224);
  RUN_HMAC(SHA2_256);
  RUN_HMAC(SHA2_384);
  RUN_HMAC(SHA2_512);

  return 0;
}
