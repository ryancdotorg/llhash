#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../rhashc.h"
#include "../sha2_512.h"

char * SHA2_512_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case SHA2_512_USING_GENERIC:         return SHA2_512_DESC_GENERIC;
    case SHA2_512_USING_NATIVE:          return SHA2_512_DESC_NATIVE;
    case SHA2_512_USING_NAYUKI64:        return SHA2_512_DESC_NAYUKI64;
    case SHA2_512_USING_INTEL_SSSE3:     return SHA2_512_DESC_INTEL_SSSE3;
    case SHA2_512_USING_INTEL_AVX:       return SHA2_512_DESC_INTEL_AVX;
    case SHA2_512_USING_INTEL_AVX2:      return SHA2_512_DESC_INTEL_AVX2;
    case SHA2_512_USING_CRYPTOGAMS_GEN:  return SHA2_512_DESC_CRYPTOGAMS_GEN;
    case SHA2_512_USING_CRYPTOGAMS_XOP:  return SHA2_512_DESC_CRYPTOGAMS_XOP;
    case SHA2_512_USING_CRYPTOGAMS_AVX:  return SHA2_512_DESC_CRYPTOGAMS_AVX;
    case SHA2_512_USING_CRYPTOGAMS_AVX2: return SHA2_512_DESC_CRYPTOGAMS_AVX2;
    default:                             return "Unknown";
  }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void sha2_512_xform_invalid(uint64_t *a, const char *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void sha2_512_xform_default(uint64_t *a, const char *b, uint32_t c) {
  if (SHA2_512_Register(-1) < 0) {
    fprintf(stderr, "No `SHA2_512_Transform` implementation available!\n");
    SHA2_512_Transform = sha2_512_xform_invalid;
  }
  SHA2_512_Transform(a, b, c);
}

void (*SHA2_512_Transform)(uint64_t *, const char *, uint32_t) = sha2_512_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(sha2_512,impl,built)(); \
  extern void JOIN(sha2_512,impl,xform)(uint64_t *, const char *, uint32_t); \
  if (enable & JOIN(SHA2_512_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(sha2_512,impl,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      SHA2_512_Transform = JOIN(sha2_512,impl,xform); \
      return JOIN(SHA2_512_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) SHA2_512_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(cryptogams_avx2,CRYPTOGAMS_AVX2);
  MAYBE_REGISTER(intel_avx2,INTEL_AVX2);
  MAYBE_REGISTER(cryptogams_avx,CRYPTOGAMS_AVX);
  MAYBE_REGISTER(intel_avx,INTEL_AVX);
  MAYBE_REGISTER(cryptogams_xop,CRYPTOGAMS_XOP);
  MAYBE_REGISTER(intel_ssse3,INTEL_SSSE3);
  MAYBE_REGISTER(cryptogams_gen,CRYPTOGAMS_GEN);
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(nayuki64,NAYUKI64);
  MAYBE_REGISTER(generic,GENERIC);
  return err ? err : RHASHC_ERROR_NOENABLE;
}

