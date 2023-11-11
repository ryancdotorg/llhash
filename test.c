#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <dlfcn.h>

#include <math.h>
#include <time.h>
#include <x86intrin.h>

#include "llhash.h"
#include "openssl.h"

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

#include "macros.h"

// https://securityboulevard.com/2022/09/benchmarking-in-c-for-x86-and-x64/
#define CYCLES_START(H0, L0) { \
  __asm__ __volatile__( \
    "\tlfence\n" \
    "\trdtsc\n" \
    "\tmov %%edx, %0\n" \
    "\tmov %%eax, %1\n" \
    : "=r" (H0), "=r" (L0) \
    : \
    : "%rax", "%rdx" \
  ); \
}

#define CYCLES_END(DEST, H0, L0) { \
  uint32_t h1, l1; \
  __asm__ __volatile__( \
    "\trdtscp\n" \
    "\tmov %%edx, %0\n" \
    "\tmov %%eax, %1\n" \
    "\tlfence\n" \
    : "=r" (h1), "=r" (l1) \
    : \
    : "%rax", "%rdx" \
  ); \
  (DEST)  = ((unsigned long long)(h1) << 32ULL) + (l1); \
  (DEST) -= ((unsigned long long)(H0) << 32ULL) + (L0); \
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#define BILLION 1000000000ULL;
static uint64_t getns() {
  uint64_t ns;
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  ns  = ts.tv_nsec;
  ns += ts.tv_sec * BILLION;
  return ns;
}
static uint64_t fstons(double s) {
  double ns = s * 1e9;
  return (uint64_t)ns;
}
#pragma GCC diagnostic pop

static char * rpadf(size_t w, const char *fmt, ...) {
  static size_t len = 0;
  static char *str = NULL, *tmp = NULL;
  char wf[24];
  size_t n;

  va_list ap;
  va_start(ap, fmt);

  if (str == NULL && (str = (char *)malloc(len = w + 1)) == NULL) { perror("malloc"); abort(); }
  if (tmp == NULL && (tmp = (char *)malloc(len)) == NULL) { perror("malloc"); abort(); }

  while ((n = vsnprintf(tmp, len, fmt, ap) + 1) > len) {
    fprintf(stderr, "realloc %zu %zu\n", len, n);
    if ((str = (char *)realloc(str, len = n)) == NULL) { perror("realloc"); abort(); }
    if ((tmp = (char *)realloc(tmp, len)) == NULL) { perror("realloc"); abort(); }
  }

  sprintf(wf, "%%-%zus", w);
  sprintf(str, wf, tmp);

  return str;
}

static char * hex(char *out, const void *in, size_t len) {
  char *ret = out;
  uint8_t p = 1;
  for (size_t i = 0; i < len; ++i) {
    uint8_t c = ((uint8_t *)in)[i];
    if (c == 0 && p != 0) {
      out += sprintf(out, "\033[38;5;23m");
    } else if (c != 0 && p == 0) {
      out += sprintf(out, "\033[m");
    }
    out += sprintf(out, "%02x", ((uint8_t *)in)[i]);
    p = c;
  }
  out += sprintf(out, "\033[m");
  *out = '\0';
  return ret;
}

static void rc4_prng(uint8_t *out, size_t len, const char *seed) {
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

static int should(char *list[], const char *str) {
  const char *item;
  for (int i = 0; (item = list[i]) != NULL; ++i) {
    // case insensitive string compare, assumes str is uppercase
    for (int p = 0;;++p) {
      char a = item[p], b = str[p];
      if (a >= 'a' && a <= 'z') a -= ('a' - 'A');
      if (a == '\0' && b == '\0') return 1;
      if (a != b) break;
    }
  }

  return 0;
}

/*
printf("OpenSSL_" #NAME "('') = %s\n", hex(hexstr, ref, SIZE)); \
*/

#define TEST_EMPTY(NAME, SIZE) do { \
  if (!should(hashes, #NAME)) break; \
  if (!OpenSSL_has_##NAME ()) { \
    printf("OpenSSL_" #NAME "() is not available, skipping tests!\n"); \
    break; \
  } \
  OpenSSL_##NAME (ref, buf, 0); \
  printf("OpenSSL_" #NAME "('') = %s\n", hex(hexstr, ref, SIZE)); \
  for (int i = 0; i < 32; ++i) { \
    int impl = NAME##_Register(1<<i); \
    if (impl >= 0) { \
      NAME (buf, 0, hash); \
      int fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("llhash %s - FAIL - %s\n", rpadf(17, #NAME "[%2d]('')", impl), NAME##_Describe(impl)); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
    } \
  } \
} while(0)

#define TEST_DATA(NAME, N, SIZE) do { \
  if (!should(hashes, #NAME)) break; \
  if (!OpenSSL_has_##NAME ()) { \
    printf("OpenSSL_" #NAME "() is not available, skipping tests!\n"); \
    break; \
  } \
  OpenSSL_##NAME (ref, buf, N); \
  for (int i = 0; i < 32; ++i) { \
    int impl = NAME##_Register(1<<i); \
    if (impl >= 0) { \
      int fail, blocks; \
      NAME##_CTX ctx; \
\
      NAME (buf, N, hash); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("All-in-One               %s - FAIL - %s\n", rpadf(26, #NAME "[%2d](%s[0:%u])", impl, desc, N), NAME##_Describe(impl)); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
\
      memset(ctx.data, 0xa5, sizeof(ctx.data)); \
      NAME##_Init(&ctx); \
      NAME##_Update(&ctx, buf, N); \
      NAME##_Final(hash, &ctx); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("Init/Update/Final        %s - FAIL - %s\n", rpadf(26, #NAME "[%2d](%s[0:%u])", impl, desc, N), NAME##_Describe(impl)); \
        printf("data:    %s\n", hex(hexstr, ctx.data, sizeof(ctx.data))); \
        printf("bytelen: %zu\n", ctx.bytelen); \
        printf("datalen: %u\n", ctx.datalen); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
\
      if (!fail && N > 0) { \
      memset(ctx.data, 0xa5, sizeof(ctx.data)); \
      NAME##_Init(&ctx); \
      NAME##_Update(&ctx, buf, 1); \
      NAME##_Update(&ctx, buf+1, N-1); \
      NAME##_Final(hash, &ctx); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("Init/Update/Update/Final %s - FAIL - %s\n", rpadf(26, #NAME "[%2d](%s[0:%u])", impl, desc, N), NAME##_Describe(impl)); \
        printf("data:    %s\n", hex(hexstr, ctx.data, sizeof(ctx.data))); \
        printf("bytelen: %zu\n", ctx.bytelen); \
        printf("datalen: %u\n", ctx.datalen); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
      } \
\
      memcpy(scratch, buf, N); \
      blocks = NAME##_Pad(scratch, N); \
      NAME##_Raw(hash, scratch, blocks); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("Pad/Raw                  %s - FAIL - %s\n", rpadf(26, #NAME "[%2d](%s[0:%u])", impl, desc, N), NAME##_Describe(impl)); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
\
      memcpy(scratch, buf, N); \
      blocks = NAME##_Pad(scratch, N); \
      NAME##_Bswap((CONCAT(uint,NAME##_WORD_SIZE,_t)*)scratch, blocks); \
      NAME##_Init(&ctx); \
      NAME##_Native(ctx.state, (CONCAT(uint,NAME##_WORD_SIZE,_t)*)scratch, blocks); \
      NAME##_Serialize(hash, ctx.state); \
      fail = 0; \
      for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
      if (fail) { \
        printf("Bswap/Native/Serialize   %s - FAIL - %s\n", rpadf(26, #NAME "[%2d](%s[0:%u])", impl, desc, N), NAME##_Describe(impl)); \
        printf("bad %s\n", hex(hexstr, hash, SIZE)); \
        printf("ref %s\n", hex(hexstr, ref, SIZE)); \
      } \
    } \
  } \
} while(0)

#define BENCH_DATA(NAME, QNAME, BLOCK, SIZE) do { \
  if (!should(hashes, #NAME)) break; \
  int start_impl_this = start_impl; \
  if (start_impl_this < 0 && !OpenSSL_has_##NAME ()) { \
    start_impl_this = 0; \
  } \
  int iter = 1; \
  for (int n = 1; n <= 64; n *= 4) { \
    int len = BLOCK * n - 20; \
    rc4_prng(scratch, len, "an arbitrary string"); \
    OpenSSL_##NAME (ref, scratch, len); \
    printf("\n"); \
    int impl = 0; \
    for (int i = start_impl_this; i < 32; ++i) { \
      if (i >= 0 && (impl = NAME##_Register(1<<i)) != i) continue; \
      uint32_t cycles_h0, cycles_l0; \
      uint64_t cycles; \
      double best_cycles = 1e40; \
      uint64_t t_end = getns() + fstons(0.5); \
      CYCLES_START(cycles_h0, cycles_l0); \
      CYCLES_END(cycles, cycles_h0, cycles_l0); \
      CYCLES_START(cycles_h0, cycles_l0); \
      CYCLES_END(cycles, cycles_h0, cycles_l0); \
      CYCLES_START(cycles_h0, cycles_l0); \
      CYCLES_END(cycles, cycles_h0, cycles_l0); \
      for (int x = 1; (x & 0xff) || getns() < t_end; ++x) { \
        if (i >= 0) { \
          CYCLES_START(cycles_h0, cycles_l0); \
          for (int y = 0; y < iter; ++y) { \
            NAME (scratch, len, hash); \
          } \
          CYCLES_END(cycles, cycles_h0, cycles_l0); \
        } else if (i == -2) { \
          CYCLES_START(cycles_h0, cycles_l0); \
          for (int y = 0; y < iter; ++y) { \
            OpenSSL_EVP_##NAME (ref, scratch, len); \
          } \
          CYCLES_END(cycles, cycles_h0, cycles_l0); \
        } else if (i == -1) { \
          CYCLES_START(cycles_h0, cycles_l0); \
          for (int y = 0; y < iter; ++y) { \
            OpenSSL_##NAME (ref, scratch, len); \
          } \
          CYCLES_END(cycles, cycles_h0, cycles_l0); \
        } \
        int fail = 0; \
        if (i >= 0) { \
          for (int j = 0; j < SIZE; ++j) fail |= ref[j] ^ hash[j]; \
        } \
        /*if (fail) { best_cycles = NAN; break; }*/ \
        double dtmp = (double)cycles / (double)iter; \
        if (dtmp < best_cycles) { best_cycles = dtmp; } \
      } \
      char *desc; \
      if (i >= 0) { \
        desc = NAME##_Describe(impl); \
      } else if (i == -2) { \
        desc = "OpenSSL (EVP_Digest)"; \
      } else if (i == -1) { \
        desc = "OpenSSL (simple)"; \
      } \
      printf(#NAME " %-28s: ", desc); \
      printf("%8.1f cycles/call ", best_cycles); \
      printf("%6.1f cycles/block ", best_cycles/(double)n); \
      printf("(%d block%s)\n", n, n > 1 ? "s" : ""); \
    } \
  } \
} while(0)

int main(int argc, char *argv[]) {
  int nobench = 0;
  int start_impl = -2;
  while (argc > 1) {
    if (strcmp(argv[1], "nobench") == 0) {
      nobench = 1;
    } else if (strcmp(argv[1], "noopenssl") == 0) {
      start_impl = 0;
    } else if (strcmp(argv[1], "noc") == 0) {
      start_impl = 2;
    } else {
      break;
    }
    ++argv; --argc;
  }

  /*
  HMAC_SHA1_CTX *dst = malloc(sizeof(HMAC_SHA1_CTX));
  printf("sz struct %lu\n", sizeof(HMAC_SHA1_CTX));
  printf("sz pointer %lu\n", sizeof(*dst));
  printf("sz data %lu\n", sizeof(dst->data));
  printf("\n");
  //*/

  char *desc, hexstr[128*(16)+1];
  uint8_t scratch[65536], buf[256];
  uint8_t ref[64], hash[64];

  char *_h[] = {
    "MD4", "MD5",
    "SHA1", "RIPEMD160",
    "SHA2_224", "SHA2_256",
    "SHA2_384", "SHA2_512",
  NULL };
  char **hashes = argc > 1 ? argv+1 : _h;

  TEST_EMPTY(MD4, 16);
  TEST_EMPTY(MD5, 16);
  TEST_EMPTY(RIPEMD160, 20);
  TEST_EMPTY(SHA1, 20);
  TEST_EMPTY(SHA2_224, 28);
  TEST_EMPTY(SHA2_256, 32);
  TEST_EMPTY(SHA2_384, 48);
  TEST_EMPTY(SHA2_512, 64);

  desc = "0x00";
  memset(buf, 0x00, sizeof(buf));
  for (size_t n = 0; n < sizeof(buf); ++n) {
    TEST_DATA(MD4, n, 16);
    TEST_DATA(MD5, n, 16);
    TEST_DATA(RIPEMD160, n, 20);
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_224, n, 28);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_384, n, 48);
    TEST_DATA(SHA2_512, n, 64);
  }

  desc = "0xff";
  memset(buf, 0xff, sizeof(buf));
  for (size_t n = 0; n < sizeof(buf); ++n) {
    TEST_DATA(MD4, n, 16);
    TEST_DATA(MD5, n, 16);
    TEST_DATA(RIPEMD160, n, 20);
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_224, n, 28);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_384, n, 48);
    TEST_DATA(SHA2_512, n, 64);
  }

  desc = "prng";
  rc4_prng(buf, sizeof(buf), "an arbitrary string");

  for (size_t n = 0; n < 4 && n < sizeof(buf); ++n) {
    TEST_DATA(MD4, n, 16);
    TEST_DATA(MD5, n, 16);
    TEST_DATA(RIPEMD160, n, 20);
    TEST_DATA(SHA1, n, 20);
    TEST_DATA(SHA2_224, n, 28);
    TEST_DATA(SHA2_256, n, 32);
    TEST_DATA(SHA2_384, n, 48);
    TEST_DATA(SHA2_512, n, 64);
  }

  if (!nobench) {
    BENCH_DATA(MD4, MD4, 64, 16);
    BENCH_DATA(MD5, MD5, 64, 16);
    BENCH_DATA(RIPEMD160, RIPEMD160,  64, 20);
    BENCH_DATA(SHA1, SHA1, 64, 20);
    BENCH_DATA(SHA2_256, SHA256, 64, 32);
    BENCH_DATA(SHA2_512, SHA512, 128, 64);
  }

  printf("\n");
  printf("Runtime Default MD4:       %s\n", MD4_Describe(MD4_Register(-1)));
  printf("Runtime Default MD5:       %s\n", MD5_Describe(MD5_Register(-1)));
  printf("Runtime Default RIPEMD160: %s\n", RIPEMD160_Describe(RIPEMD160_Register(-1)));
  printf("Runtime Default SHA1:      %s\n", SHA1_Describe(SHA1_Register(-1)));
  printf("Runtime Default SHA2_224:  %s\n", SHA2_224_Describe(SHA2_224_Register(-1)));
  printf("Runtime Default SHA2_256:  %s\n", SHA2_256_Describe(SHA2_256_Register(-1)));
  printf("Runtime Default SHA2_384:  %s\n", SHA2_384_Describe(SHA2_384_Register(-1)));
  printf("Runtume Default SHA2_512:  %s\n", SHA2_512_Describe(SHA2_512_Register(-1)));

  return 0;
}
