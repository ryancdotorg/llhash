#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../../../macros.h"
#include "../../../llhash.h"
#include "../../../gen/md/md4/hash.h"

char * MD4_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case MD4_USING_GENERIC:            return MD4_DESC_GENERIC;
    case MD4_USING_NATIVE:             return MD4_DESC_NATIVE;
    case MD4_USING_RYANC:              return MD4_DESC_RYANC;
    case MD4_USING_RYANC_NAIVE:        return MD4_DESC_RYANC_NAIVE;
    default:                           return "Unknown";
  }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void md4_xform_invalid(uint32_t *a, const void *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void md4_xform_default(uint32_t *a, const void *b, uint32_t c) {
  if (MD4_Register(-1) < 0) {
    fprintf(stderr, "No `MD4_Transform` implementation available!\n");
    MD4_Transform = md4_xform_invalid;
  }
  MD4_Transform(a, b, c);
}

void (*MD4_Transform)(uint32_t *, const void *, uint32_t) = md4_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(md4,impl,xform,built)(); \
  extern void JOIN(md4,impl,xform)(uint32_t *, const void *, uint32_t); \
  if (enable & JOIN(MD4_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(md4,impl,xform,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      MD4_Transform = JOIN(md4,impl,xform); \
      return JOIN(MD4_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) MD4_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(generic,GENERIC);
  MAYBE_REGISTER(ryanc,RYANC);
  MAYBE_REGISTER(ryanc_naive,RYANC_NAIVE);
  return err ? err : LLHASH_ERROR_NOENABLE;
}
