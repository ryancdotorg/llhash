#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../../../llhash.h"
#include "../../../macros.h"
#include "../../../gen/md/sha2_256/hash.h"

char * SHA2_256_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case SHA2_256_USING_GENERIC:           return SHA2_256_DESC_GENERIC;
    case SHA2_256_USING_NATIVE:            return SHA2_256_DESC_NATIVE;
    case SHA2_256_USING_NAYUKI64:          return SHA2_256_DESC_NAYUKI64;
    case SHA2_256_USING_INTEL_SSSE3:       return SHA2_256_DESC_INTEL_SSSE3;
    case SHA2_256_USING_INTEL_AVX:         return SHA2_256_DESC_INTEL_AVX;
    case SHA2_256_USING_INTEL_AVX2:        return SHA2_256_DESC_INTEL_AVX2;
    case SHA2_256_USING_INTEL_SHAEXT:      return SHA2_256_DESC_INTEL_SHAEXT;
    case SHA2_256_USING_CRYPTOGAMS_GEN:    return SHA2_256_DESC_CRYPTOGAMS_GEN;
    case SHA2_256_USING_CRYPTOGAMS_SSSE3:  return SHA2_256_DESC_CRYPTOGAMS_SSSE3;
    case SHA2_256_USING_CRYPTOGAMS_AVX:    return SHA2_256_DESC_CRYPTOGAMS_AVX;
    case SHA2_256_USING_CRYPTOGAMS_AVX2:   return SHA2_256_DESC_CRYPTOGAMS_AVX2;
    case SHA2_256_USING_CRYPTOGAMS_SHAEXT: return SHA2_256_DESC_CRYPTOGAMS_SHAEXT;
    default:                          return "Unknown";
  }
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void sha2_256_xform_invalid(uint32_t *a, const void *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void sha2_256_xform_default(uint32_t *a, const void *b, uint32_t c) {
  if (SHA2_256_Register(-1) < 0) {
    fprintf(stderr, "No `SHA2_256_Transform` implementation available!\n");
    SHA2_256_Transform = sha2_256_xform_invalid;
  }
  SHA2_256_Transform(a, b, c);
}

void (*SHA2_256_Transform)(uint32_t *, const void *, uint32_t) = sha2_256_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(sha2_256,impl,xform,built)(); \
  extern void JOIN(sha2_256,impl,xform)(uint32_t *, const void *, uint32_t); \
  if (enable & JOIN(SHA2_256_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(sha2_256,impl,xform,built)()) e |= 1; \
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
  MAYBE_REGISTER(cryptogams_shaext,CRYPTOGAMS_SHAEXT);
  MAYBE_REGISTER(intel_shaext,INTEL_SHAEXT);
  MAYBE_REGISTER(cryptogams_avx2,CRYPTOGAMS_AVX2);
  MAYBE_REGISTER(intel_avx2,INTEL_AVX2);
  MAYBE_REGISTER(cryptogams_avx,CRYPTOGAMS_AVX);
  MAYBE_REGISTER(cryptogams_ssse3,CRYPTOGAMS_SSSE3);
  MAYBE_REGISTER(intel_avx,INTEL_AVX);
  MAYBE_REGISTER(intel_ssse3,INTEL_SSSE3);
  MAYBE_REGISTER(cryptogams_gen,CRYPTOGAMS_GEN);
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(nayuki64,NAYUKI64);
  MAYBE_REGISTER(generic,GENERIC);
  return err ? err : RHASHC_ERROR_NOENABLE;
}
