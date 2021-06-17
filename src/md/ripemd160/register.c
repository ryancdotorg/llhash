#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../../../llhash.h"
#include "../../../macros.h"
#include "../../../gen/md/ripemd160/hash.h"

char * RIPEMD160_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case RIPEMD160_USING_GENERIC:      return RIPEMD160_DESC_GENERIC;
    case RIPEMD160_USING_NATIVE:       return RIPEMD160_DESC_NATIVE;
    default:                           return "Unknown";
  }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void ripemd160_xform_invalid(uint32_t *a, const void *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void ripemd160_xform_default(uint32_t *a, const void *b, uint32_t c) {
  if (RIPEMD160_Register(-1) < 0) {
    fprintf(stderr, "No `RIPEMD160_Transform` implementation available!\n");
    RIPEMD160_Transform = ripemd160_xform_invalid;
  }
  RIPEMD160_Transform(a, b, c);
}

void (*RIPEMD160_Transform)(uint32_t *, const void *, uint32_t) = ripemd160_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(ripemd160,impl,xform,built)(); \
  extern void JOIN(ripemd160,impl,xform)(uint32_t *, const void *, uint32_t); \
  if (enable & JOIN(RIPEMD160_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(ripemd160,impl,xform,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      RIPEMD160_Transform = JOIN(ripemd160,impl,xform); \
      return JOIN(RIPEMD160_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) RIPEMD160_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(generic,GENERIC);
  return err ? err : RHASHC_ERROR_NOENABLE;
}

