#ifdef _INDIRECT
#error "can't include util.h directly from a template"
#endif
#pragma once
#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* small helper functions */
/*
static inline void xmemcpy(void *restrict dst, const void *restrict src, size_t n) {
  uint8_t *d = (uint8_t *)dst, *s = (uint8_t *)src, *e = d + n;
  while (d < e) *d++ = *s++;
}
*/

#define _WIPEN(_1, _2, NAME, ...) NAME
#define _WIPE1(P) explicit_bzero((P), sizeof(P))
#define _WIPE2(P, N) explicit_bzero((P), (N))
#define wipe(...) _WIPEN(__VA_ARGS__, _WIPE2, _WIPE1)(__VA_ARGS__)
/*
static inline void _wipe(void *mem, size_t n) {
  volatile uint8_t *ptr = (uint8_t *)mem, *end = ptr + n;
  while (ptr < end) *ptr++ = 0;
}
//*/
