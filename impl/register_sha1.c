#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../rhashc.h"
#include "../sha1.h"

char * SHA1_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case SHA1_USING_GENERIC:      return SHA1_DESC_GENERIC;
    case SHA1_USING_NATIVE:       return SHA1_DESC_NATIVE;
    case SHA1_USING_NAYUKI64:     return SHA1_DESC_NAYUKI64;
    case SHA1_USING_INTEL_SSSE3:  return SHA1_DESC_INTEL_SSSE3;
    case SHA1_USING_INTEL_AVX:    return SHA1_DESC_INTEL_AVX;
    case SHA1_USING_INTEL_AVX2:   return SHA1_DESC_INTEL_AVX2;
    case SHA1_USING_INTEL_SHAEXT: return SHA1_DESC_INTEL_SHAEXT;
    default:                      return "Unknown";
  }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void sha1_xform_invalid(uint32_t *a, const char *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void sha1_xform_default(uint32_t *a, const char *b, uint32_t c) {
  if (SHA1_Register(-1) < 0) {
    fprintf(stderr, "No `SHA1_Transform` implementation available!\n");
    SHA1_Transform = sha1_xform_invalid;
  }
  SHA1_Transform(a, b, c);
}

void (*SHA1_Transform)(uint32_t *, const char *, uint32_t) = sha1_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(sha1,impl,built)(); \
  extern void JOIN(sha1,impl,xform)(uint32_t *, const char *, uint32_t); \
  if (enable & JOIN(SHA1_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(sha1,impl,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      SHA1_Transform = JOIN(sha1,impl,xform); \
      return JOIN(SHA1_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) SHA1_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(intel_shaext,INTEL_SHAEXT);
  MAYBE_REGISTER(intel_avx2,INTEL_AVX2);
  MAYBE_REGISTER(intel_avx,INTEL_AVX);
  MAYBE_REGISTER(intel_ssse3,INTEL_SSSE3);
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(nayuki64,NAYUKI64);
  MAYBE_REGISTER(generic,GENERIC);
  return err ? err : RHASHC_ERROR_NOENABLE;
}

