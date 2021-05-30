#include <stddef.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "../../../rhashc.h"
#include "../../../gen/md/md5/hash.h"

char * MD5_Describe(int impl) {
  switch (impl > 0 ? impl : 0) {
    case MD5_USING_GENERIC:           return MD5_DESC_GENERIC;
    case MD5_USING_NATIVE:            return MD5_DESC_NATIVE;
    case MD5_USING_NAYUKI64:          return MD5_DESC_NAYUKI64;
    default:                           return "Unknown";
  }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
static void md5_xform_invalid(uint32_t *a, const void *b, uint32_t c) {
  raise(SIGILL);
}
#pragma GCC diagnostic pop

static void md5_xform_default(uint32_t *a, const void *b, uint32_t c) {
  if (MD5_Register(-1) < 0) {
    fprintf(stderr, "No `MD5_Transform` implementation available!\n");
    MD5_Transform = md5_xform_invalid;
  }
  MD5_Transform(a, b, c);
}

void (*MD5_Transform)(uint32_t *, const void *, uint32_t) = md5_xform_default;

#define MAYBE_REGISTER(impl,IMPL) \
  extern int JOIN(can,impl)(); \
  extern int JOIN(md5,impl,xform,built)(); \
  extern void JOIN(md5,impl,xform)(uint32_t *, const void *, uint32_t); \
  if (enable & JOIN(MD5_ENABLE,IMPL)) { \
    int e = 0; \
    if (!JOIN(md5,impl,xform,built)()) e |= 1; \
    if (!JOIN(can,impl)())        e |= 2; \
    if (e) { \
      err |= ~e; \
    } else { \
      MD5_Transform = JOIN(md5,impl,xform); \
      return JOIN(MD5_USING,IMPL); \
    } \
  }

int __attribute__((noinline)) MD5_Register(int enable) {
  int err = 0;
  MAYBE_REGISTER(native,NATIVE);
  MAYBE_REGISTER(generic,GENERIC);
  MAYBE_REGISTER(nayuki64,NAYUKI64);
  return err ? err : RHASHC_ERROR_NOENABLE;
}

