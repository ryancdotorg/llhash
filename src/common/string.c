#include <stddef.h>
#include <stdint.h>

#include "string.h"

#ifdef INTERNAL_MEMFUNCS
#pragma GCC visibility push(internal)
#pragma GCC push_options
#pragma GCC optimize ("O3")
// rely on compiler to provide optimized version
void _memcpy_impl(void *restrict dst, const void *restrict src, size_t n) {
    uint8_t *d = dst;
    const uint8_t *s = src;
    for (size_t i = 0; i < n; ++i) d[i] = s[i];
}

// rely on compiler to provide optimized version
void _memset_impl(void *restrict dst, uint8_t c, size_t n) {
    uint8_t *d = dst;
    for (size_t i = 0; i < n; ++i) d[i] = c;
}

void _explicit_bzero_impl(void *d, size_t n) {
  _memset_impl(d, 0, n);
  __asm__ __volatile__ ("" : : "r"(d) : "memory");
}
#pragma GCC pop_options
#pragma GCC visibility pop
#endif
