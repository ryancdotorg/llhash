#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

#include <time.h>
#include <x86intrin.h>

#include "rhashc.h"
#include "openssl.h"
#include "sha1.h"
#include "sha2_256.h"
#include "sha2_512.h"

extern void sha2_512_cryptogams_gen_xform(uint64_t *, void *, uint32_t);
extern void sha2_512_cryptogams_xop_xform(uint64_t *, void *, uint32_t);
extern void sha2_512_cryptogams_avx_xform(uint64_t *, void *, uint32_t);
extern void sha2_512_cryptogams_avx2_xform(uint64_t *, void *, uint32_t);

static uint64_t getns() {
  uint64_t ns;
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  ns  = ts.tv_nsec;
  ns += ts.tv_sec * 1000000000ULL;
  return ns;
}

static void hex(char *out, const void *in, size_t len) {
  for (size_t i = 0; i < len; ++i) {
    sprintf(out, "%02x", ((uint8_t *)in)[i]);
    out += 2;
  }
  *out = '\0';
}

void rc4_prng(uint8_t *out, size_t len, const char *seed) {
  size_t seedlen = strlen(seed);
  uint8_t i = 0, j = 0, t, S[256], *end = out + len;

  do { S[i] = i; } while (++i);

  do {
    j = (j + S[i] + seed[i % seedlen]) & 0xff;
    t = S[i]; S[i] = S[j]; S[j] = t;
  } while (++i);

  j = i = 0;
  while (out < end) {
    j = (j + S[++i]) & 0xff;
    t = S[i]; S[i] = S[j]; S[j] = t;
    *out = S[(S[i] + S[j]) & 0xff];
    ++out;
  }
}

#define TEST_EMPTY(NAME, SIZE) do { \
  OpenSSL_##NAME (ref, buf, 0); \
  hex(hexstr, ref, SIZE); \
  printf("OpenSSL_" #NAME "('') = %s\n", hexstr); \
  for (int i = 0; i < 32; ++i) { \
    int impl = NAME##_Register(1<<i); \
    if (impl >= 0) { \
      NAME (hash, buf, 0); \
      int fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        hex(hexstr, hash, SIZE); \
        printf("rhashc " #NAME "[%2d]('') = %s FAIL - %s\n", impl, hexstr, NAME##_Describe(impl)); \
      } else { \
        printf("rhashc " #NAME "[%2d]('') OKAY - %s\n", impl, NAME##_Describe(impl)); \
      } \
    } \
  } \
} while(0)

#define TEST_DATA(NAME, N, SIZE) do { \
  OpenSSL_##NAME (ref, buf, N); \
  for (int i = 0; i < 32; ++i) { \
    int impl = NAME##_Register(1<<i); \
    if (impl >= 0) { \
      int fail, blocks; \
      NAME##_CTX ctx; \
\
      NAME (hash, buf, N); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        hex(hexstr, hash, SIZE); \
        printf("All-in-One " #NAME "[%2d](%s[0:%u]) = %s FAIL - %s\n", impl, desc, N, hexstr, NAME##_Describe(impl)); \
        hex(hexstr, ref, SIZE); \
        printf("ref %s\n", hexstr); \
      } \
\
      NAME##_Init(&ctx); \
      NAME##_Update(&ctx, buf, N); \
      NAME##_Final(hash, &ctx); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        hex(hexstr, hash, SIZE); \
        printf("Init/Update/Final " #NAME "[%2d](%s[0:%u]) = %s FAIL - %s\n", impl, desc, N, hexstr, NAME##_Describe(impl)); \
        hex(hexstr, ref, SIZE); \
        printf("ref %s\n", hexstr); \
      } \
\
      if (N > 0) { \
      NAME##_Init(&ctx); \
      NAME##_Update(&ctx, buf, 1); \
      NAME##_Update(&ctx, buf+1, N-1); \
      NAME##_Final(hash, &ctx); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        hex(hexstr, hash, SIZE); \
        printf("Init/Update/Update/Final " #NAME "[%2d](%s[0:%u]) = %s FAIL - %s\n", impl, desc, N, hexstr, NAME##_Describe(impl)); \
        hex(hexstr, ref, SIZE); \
        printf("ref %s\n", hexstr); \
      } \
      } \
\
      memcpy(scratch, buf, N); \
      blocks = NAME##_Pad(scratch, N); \
      NAME##_Raw(hash, scratch, blocks); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        hex(hexstr, hash, SIZE); \
        printf("Pad/Raw " #NAME "[%2d](%s[0:%u]) = %s FAIL - %s\n", impl, desc, N, hexstr, NAME##_Describe(impl)); \
        hex(hexstr, ref, SIZE); \
        printf("ref %s\n", hexstr); \
      } \
    } \
  } \
} while(0)

#define BENCH_DATA(NAME, BLOCK, SIZE) do { \
  int repeat = 1000, iter = 1; \
  for (int n = 1; n <= 256; n *= 4) { \
    int len = BLOCK * n - 20; \
    rc4_prng(scratch, len, "an arbitrary string"); \
    OpenSSL_##NAME (ref, scratch, len); \
    printf("\n"); \
    int impl; \
    for (int i = 0; i < 32; ++i) { \
      if ((impl = NAME##_Register(1<<i)) != i) continue; \
      uint64_t cycles; \
      double best_cycles = 1e40, dtmp; \
      for (int x = 0; x < repeat; ++x) { \
        int fail = 0; \
        cycles = __rdtsc(); \
        for (int y = 0; y < iter; ++y) { \
          NAME (hash, scratch, len); \
        } \
        cycles = __rdtsc() - cycles; \
        dtmp = (double)cycles / (double)iter; \
        if (dtmp < best_cycles) { best_cycles = dtmp; x = 0; } \
        for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
        if (fail) { printf("whoops\n"); } \
      } \
      printf(#NAME " %-28s: ", NAME##_Describe(impl)); \
      printf("%8.1f cycles/call ", best_cycles); \
      printf("%6.1f cycles/block ", best_cycles/(double)n); \
      printf("(%d block%s)\n", n, n > 1 ? "s" : ""); \
    } \
  } \
} while(0)
/*
          NAME (hash, scratch, len); \
          uint64_t w = NAME##_Pad (scratch, len); \
          NAME##_Raw(hash, scratch, w); \
*/

int main() {
  HMAC_SHA1_CTX *dst = malloc(sizeof(HMAC_SHA1_CTX));
  printf("sz struct %u\n", sizeof(HMAC_SHA1_CTX));
  printf("sz pointer %u\n", sizeof(*dst));
  printf("sz data %u\n", sizeof(dst->data));

  char *desc;
  uint8_t scratch[65536], buf[1024], hexstr[257];
  uint8_t ref[64], hash[64];

  /*
  rc4_prng(hash, 16, "Key");
  hex(hexstr, hash, 16);
  printf("rc4_prng('Key') = %s\n", hexstr);
  */

  printf("\n");
  printf("Autoselect SHA1:     %s\n", SHA1_Describe(SHA1_Register(-1)));
  printf("Autoselect SHA2_256: %s\n", SHA2_256_Describe(SHA2_256_Register(-1)));
  printf("Autoselect SHA2_512: %s\n", SHA2_512_Describe(SHA2_512_Register(-1)));
  printf("\n");

  TEST_EMPTY(SHA1, 20);
  printf("\n");
  TEST_EMPTY(SHA2_256, 32);
  printf("\n");
  TEST_EMPTY(SHA2_512, 64);

  desc = "0x00";
  memset(buf, 0x00, sizeof(buf));
  for (int n = 0; n < sizeof(buf); ++n) {
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_512, n, 64);
  }

  desc = "0xff";
  memset(buf, 0xff, sizeof(buf));
  for (int n = 0; n < sizeof(buf); ++n) {
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_512, n, 64);
  }

  desc = "prng";
  rc4_prng(buf, sizeof(buf), "an arbitrary string");

  for (int n = 0; n < sizeof(buf); ++n) {
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_512, n, 64);
  }

  printf("\n");

  BENCH_DATA(SHA1, 64, 20);
  BENCH_DATA(SHA2_256, 64, 32);
  BENCH_DATA(SHA2_512, 128, 64);

  return 0;
}
