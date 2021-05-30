#include <stdint.h>
#include <stddef.h>
#include <signal.h>

#include "../rhashc.h"

int JOIN(FUNCPFX,built)() { return 0; }
void JOIN(FUNCPFX,xform)() { raise(SIGILL); }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
void JOIN(FUNCPFX,xform)(void *digest, const char *data, uint32_t nblk) {}
#pragma GCC diagnostic pop
#undef J
#undef _J
