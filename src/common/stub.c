#include <stdint.h>
#include <stddef.h>

#include "../../macros.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int JOIN(STUB_PFX,built)() { return 0; }
void JOIN(STUB_PFX)(void *digest, const char *data, uint32_t nblk) {
  __builtin_trap();
}
#ifdef STUB_LE
int JOIN(STUB_PFX,le,built)() { return 0; }
void JOIN(STUB_PFX,le)(void *digest, const char *data, uint32_t nblk) {
  __builtin_trap();
}
#endif
#pragma GCC diagnostic pop
