#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../rhashc.h"
#include "../sha2_256.h"

char * SHA2_256_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case SHA2_256_USING_GENERIC:  return SHA2_256_DESC_GENERIC;
    case SHA2_256_USING_NATIVE:   return SHA2_256_DESC_NATIVE;
    case SHA2_256_USING_NAYUKI64: return SHA2_256_DESC_NAYUKI64;
    case SHA2_256_USING_SSSE3:    return SHA2_256_DESC_SSSE3;
    case SHA2_256_USING_AVX:      return SHA2_256_DESC_AVX;
    case SHA2_256_USING_AVX2:     return SHA2_256_DESC_AVX2;
    case SHA2_256_USING_SHAEXT:   return SHA2_256_DESC_SHAEXT;
    default:                      return "Unknown";
  }
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void sha2_256_xform_invalid(uint32_t *a, const char *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void sha2_256_xform_default(uint32_t *a, const char *b, uint32_t c) {
  if (SHA2_256_Register(-1) < 0) {
    fprintf(stderr, "No `SHA2_256_Transform` implementation available!\n");
    SHA2_256_Transform = sha2_256_xform_invalid;
  }
  SHA2_256_Transform(a, b, c);
}

void (*SHA2_256_Transform)(uint32_t *, const char *, uint32_t) = sha2_256_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(sha2_256,impl,built)(); \
  extern void JOIN(sha2_256,impl,xform)(uint32_t *, const char *, uint32_t); \
  if (enable & JOIN(SHA2_256_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(sha2_256,impl,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      SHA2_256_Transform = JOIN(sha2_256,impl,xform); \
      return JOIN(SHA2_256_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) SHA2_256_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(shaext,SHAEXT);
  MAYBE_REGISTER(avx2,AVX2);
  MAYBE_REGISTER(avx,AVX);
  MAYBE_REGISTER(ssse3,SSSE3);
  MAYBE_REGISTER(nayuki64,NAYUKI64);
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(generic,GENERIC);
  return err ? err : RHASHC_ERROR_NOENABLE;
}

