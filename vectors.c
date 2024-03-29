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

#include "state_debug.h"

#include "gen/md/md4/ext.h"
#include "gen/md/md4/hmac.h"
#include "gen/md/md4/hash.h"

#include "gen/md/md5/ext.h"
#include "gen/md/md5/hmac.h"
#include "gen/md/md5/hash.h"

#include "gen/md/ripemd160/ext.h"
#include "gen/md/ripemd160/hmac.h"
#include "gen/md/ripemd160/hash.h"

#include "gen/md/sha1/ext.h"
#include "gen/md/sha1/hmac.h"
#include "gen/md/sha1/hash.h"

#include "gen/md/sha2_224/ext.h"
#include "gen/md/sha2_224/hmac.h"
#include "gen/md/sha2_224/hash.h"

#include "gen/md/sha2_256/ext.h"
#include "gen/md/sha2_256/hmac.h"
#include "gen/md/sha2_256/hash.h"

#include "gen/md/sha2_384/ext.h"
#include "gen/md/sha2_384/hmac.h"
#include "gen/md/sha2_384/hash.h"

#include "gen/md/sha2_512/ext.h"
#include "gen/md/sha2_512/hmac.h"
#include "gen/md/sha2_512/hash.h"

#include <unistd.h>
#include <sys/time.h>
#include <sys/times.h>

typedef clock_t proctime;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
static clock_t cpu_now(void)
{
  struct tms tms;
  times(&tms);
  return tms.tms_utime;
}

static double proctime2secs(clock_t start, clock_t end)
{
  return (end - start) / (double) sysconf(_SC_CLK_TCK);
}

static double wall_now(void)
{
  struct timeval tv = { 0, 0 };
  gettimeofday(&tv, NULL);
  double r = tv.tv_sec;
  r += (double) tv.tv_usec * 1e-6;
  return r;
}
#pragma GCC diagnostic pop

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
  printf("Hash vectors for " #H ": %d/%d\n", total - fail, total);

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
    state_debug_reset(); \
    HMAC_##H(k, k_sz, m, m_sz, x); \
    if (memcmp(d, x, d_sz) != 0) { \
      ++fail; \
      printf("{\"type\": \"test\", "); \
      printf("\"algo\": \"" #H "\", \"id\": %d, ", id); \
      printf("\"key\": [%zu, \"%s\"], ",     k_sz, hex(buf, k, k_sz, 0)); \
      printf("\"message\": [%zu, \"%s\"], ", m_sz, hex(buf, m, m_sz, 0)); \
      printf("\"expect\": [%zu, \"%s\"], ",  d_sz, hex(buf, d, d_sz, 0)); \
      printf("\"actual\": [%zu, \"%s\"], ",  d_sz, hex(buf, x, d_sz, 0)); \
      printf("\"correct\": false}\n"); \
      state_debug_print(); \
    } else if (0) { \
      printf("{\"type\": \"test\", "); \
      printf("\"algo\": \"" #H "\", \"id\": %d, ", id); \
      printf("\"key\": [%zu, \"%s\"], ",     k_sz, hex(buf, k, k_sz, 0)); \
      printf("\"message\": [%zu, \"%s\"], ", m_sz, hex(buf, m, m_sz, 0)); \
      printf("\"expect\": [%zu, \"%s\"], ",  d_sz, hex(buf, d, d_sz, 0)); \
      printf("\"correct\": true}\n"); \
      state_debug_print(); \
    } \
    ++total; \
  } \
  printf("HMAC vectors for " #H ": %d/%d\n", total - fail, total); \

int main() {
  char buf[65536];
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


  unsigned char _v0x0000[] = {0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64};
  unsigned char _v0x0001[] = {0x73, 0x61, 0x6c, 0x74};
  unsigned char _v0x0002[] = {0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64, 0x50, 0x41, 0x53, 0x53, 0x57, 0x4f, 0x52, 0x44, 0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64};
  unsigned char _v0x0003[] = {0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74};
  unsigned char _v0x0004[] = {0x70, 0x61, 0x73, 0x73, 0x00, 0x77, 0x6f, 0x72, 0x64};
  unsigned char _v0x0005[] = {0x73, 0x61, 0x00, 0x6c, 0x74};
  unsigned char _v0x0006[] = {0x68, 0x75, 0x6e, 0x74, 0x65, 0x72, 0x32};
  unsigned char _v0x0007[] = {0x61, 0x64, 0x6d, 0x69, 0x6e};

  unsigned char dk[1024];
  unsigned char dk0[] = {0x0c, 0x60, 0xc8, 0x0f, 0x96, 0x1f, 0x0e, 0x71, 0xf3, 0xa9, 0xb5, 0x24, 0xaf, 0x60, 0x12, 0x06, 0x2f, 0xe0, 0x37, 0xa6};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0001, 4, 1);
  printf("sha1-dk0: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk0, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk0, 20, 1));
    return 1;
  }
  unsigned char dk0m[] = {0xf3, 0x1a, 0xfb, 0x6d, 0x93, 0x13, 0x92, 0xda, 0xa5, 0xe3, 0x13, 0x0f, 0x47, 0xf9, 0xa9, 0xb6, 0xe8, 0xe7, 0x20, 0x29};
  PBKDF2_HMAC_MD5(dk, 20, _v0x0000, 8, _v0x0001, 4, 1);
  printf("md5-dk0:  %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk0m, 20) != 0) {
    printf("md5-ref:  %s\n", hex(buf, dk0m, 20, 1));
    return 1;
  }
  unsigned char dk1[] = {0xea, 0x6c, 0x01, 0x4d, 0xc7, 0x2d, 0x6f, 0x8c, 0xcd, 0x1e, 0xd9, 0x2a, 0xce, 0x1d, 0x41, 0xf0, 0xd8, 0xde, 0x89, 0x57};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0001, 4, 2);
  printf("sha1-dk1: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk1, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk1, 20, 1));
    return 1;
  }
  unsigned char dk_[] = {0x6b, 0x4e, 0x26, 0x12, 0x5c, 0x25, 0xcf, 0x21, 0xae, 0x35, 0xea, 0xd9, 0x55, 0xf4, 0x79, 0xea, 0x2e, 0x71, 0xf6, 0xff};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0001, 4, 3);
  printf("sha1-dk_: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk_, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk_, 20, 1));
    return 1;
  }
  unsigned char dk2[] = {0x4b, 0x00, 0x79, 0x01, 0xb7, 0x65, 0x48, 0x9a, 0xbe, 0xad, 0x49, 0xd9, 0x26, 0xf7, 0x21, 0xd0, 0x65, 0xa4, 0x29, 0xc1};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0001, 4, 4096);
  printf("sha1-dk2: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk2, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk2, 20, 1));
    return 1;
  }
  unsigned char dk3[] = {0xee, 0xfe, 0x3d, 0x61, 0xcd, 0x4d, 0xa4, 0xe4, 0xe9, 0x94, 0x5b, 0x3d, 0x6b, 0xa2, 0x15, 0x8c, 0x26, 0x34, 0xe9, 0x84};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0001, 4, 16777216);
  printf("sha1-dk3: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk3, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk3, 20, 1));
    return 1;
  }
  unsigned char dk4[] = {0x3d, 0x2e, 0xec, 0x4f, 0xe4, 0x1c, 0x84, 0x9b, 0x80, 0xc8, 0xd8, 0x36, 0x62, 0xc0, 0xe4, 0x4a, 0x8b, 0x29, 0x1a, 0x96, 0x4c, 0xf2, 0xf0, 0x70, 0x38};
  PBKDF2_HMAC_SHA1(dk, 25, _v0x0002, 24, _v0x0003, 36, 4096);
  printf("sha1-dk4: %s\n", hex(buf, dk, 25, 1));
  if (memcmp(dk, dk4, 25) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk4, 25, 1));
    return 1;
  }
  unsigned char dk5[] = {0x7f, 0xb4, 0x9c, 0xcc, 0x3b, 0x30, 0xc6, 0x09, 0xd1, 0xd1, 0xbc, 0x86, 0xac, 0x5a, 0xcf, 0x87};
  PBKDF2_HMAC_SHA1(dk, 16, _v0x0004, 9, _v0x0005, 5, 1);
  printf("sha1-dk5: %s\n", hex(buf, dk, 16, 1));
  if (memcmp(dk, dk5, 16) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk5, 16, 1));
    return 1;
  }
  /*
  unsigned char dk7[] = {0x14, 0x4c, 0x12, 0xea, 0xf5, 0xba, 0x29, 0x3c, 0x45, 0x44, 0x2b, 0xec, 0xb5, 0xe6, 0xa5, 0x77, 0xa7, 0x73, 0x06, 0xdb, 0x6f, 0x22, 0xba, 0x3f, 0xf6, 0x89, 0xa1, 0x7b, 0x72, 0x67, 0xea, 0x78, 0x22, 0x40, 0x8d, 0xb7, 0x56, 0xdb, 0x0d, 0x32, 0x05, 0x06, 0xd2, 0xf0, 0x4c, 0x17, 0xa0, 0x40, 0xb3, 0xfa, 0xfe, 0x4b, 0x01, 0x6e, 0xa8, 0xf5, 0xf5, 0x1d, 0x3c, 0xa1, 0xbb, 0xb8, 0x56, 0xba};
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0006, 7, _v0x0007, 5, 67108864);
  printf("sha1-dk7: %s\n", hex(buf, dk, 20, 1));
  if (memcmp(dk, dk7, 20) != 0) {
    printf("sha1-ref: %s\n", hex(buf, dk7, 20, 1));
    return 1;
  }
  */
  unsigned char dk7x[] = {0x83, 0x73, 0x78, 0xd9, 0xc8, 0x28, 0x9f, 0x81, 0x6c, 0x58, 0x6c, 0x23, 0xf4, 0x10, 0x33, 0x26, 0x90, 0x14, 0x9c, 0xde, 0x3a, 0xac, 0x0f, 0xcf, 0x18, 0x52, 0x4c, 0xd1, 0x23, 0xaf, 0xc4, 0x4e, 0x21, 0xe2, 0xa3, 0x32, 0xc4, 0x6f, 0x1e, 0xbf, 0xcd, 0x99, 0xeb, 0x28, 0x89, 0x96, 0xde, 0x37, 0xd6, 0x1b, 0x04, 0x34, 0x72, 0x9d, 0xf7, 0x5a, 0xb0, 0xd6, 0x0b, 0xdd, 0xd1, 0xb3, 0xa6, 0x1c};
  unsigned char dk7y[] = {0x2f, 0xb7, 0x0b, 0xd6, 0xaa, 0x8f, 0x93, 0xab, 0xa7, 0x19, 0xfe, 0xb0, 0x9d, 0x4f, 0x53, 0x25, 0xa4, 0x29, 0xca, 0x59, 0x0e, 0xd2, 0xdd, 0x4d, 0x6e, 0xeb, 0xce, 0xee, 0xfd, 0x21, 0x28, 0x6b, 0xf8, 0x87, 0xb3, 0x40, 0x2b, 0xce, 0x04, 0x6a, 0x94, 0x23, 0x93, 0xa7, 0x62, 0x99, 0x6f, 0xf7, 0x5b, 0x9e, 0xe5, 0x97, 0x6d, 0xe6, 0xab, 0xfb, 0x14, 0xb8, 0xc8, 0x61, 0x9c, 0xc9, 0xbb, 0x37};

#define RANGE_VECTOR(FN, REF, START, END) \
  memset(dk, 0, sizeof(dk)); \
  memset(buf, 0x20, sizeof(buf)); \
  FN(dk, START, END, _v0x0006, 7, _v0x0007, 5, 1024); \
  hex(buf+(START*2), dk, END-START, 1); \
  printf(#REF "[%02d:%02d]: %s\n", START, END, buf); \
  if (memcmp(dk, REF+START, END-START) != 0) { \
    printf("ref:         %s\n", hex(buf, REF+START, END-START, 1)); \
    return 1; \
  }

  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x,  0, 64);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x,  1, 33);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x,  5, 37);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 10, 42);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 20, 60);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 20, 40);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 40, 60);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 16, 24);
  RANGE_VECTOR(PBKDF2_HMAC_SHA1_Range, dk7x, 16, 48);

  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y,  0, 64);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y,  1, 33);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y,  5, 37);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 10, 42);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 20, 60);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 20, 40);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 40, 60);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 16, 24);
  RANGE_VECTOR(PBKDF2_HMAC_MD5_Range,  dk7y, 16, 48);

  /*
  SHA1_Register(SHA1_ENABLE_CRYPTOGAMS_SSSE3);
  unsigned char _v0x0008[] = {0x73, 0x61, 0x6c, 0x74, 0x73, 0x61, 0x6c, 0x74};
  proctime end, start;
  start = cpu_now();
  PBKDF2_HMAC_SHA1(dk, 20, _v0x0000, 8, _v0x0008, 8, 67108864);
  end = cpu_now();
  printf("llhash,sha1,%u,%u,%.3f\n", 67108864, 1, proctime2secs(start, end));
  start = cpu_now();
  PBKDF2_HMAC_SHA2_256(dk, 32, _v0x0000, 8, _v0x0008, 8, 67108864);
  end = cpu_now();
  printf("llhash,sha256,%u,%u,%.3f\n", 67108864, 1, proctime2secs(start, end));
  start = cpu_now();
  PBKDF2_HMAC_SHA2_512(dk, 64, _v0x0000, 8, _v0x0008, 8, 67108864);
  end = cpu_now();
  printf("llhash,sha512,%u,%u,%.3f\n", 67108864, 1, proctime2secs(start, end));
  */

  return 0;
}
