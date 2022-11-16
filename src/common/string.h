#pragma once
#include <stddef.h>
#include <stdint.h>

// use internal memcpy/memset/explicit_bzero if compiling to WebAssembly
#if !defined(INTERNAL_MEMFUNCS) && (defined(__wasm) || defined(__wasm__) || defined(__WASM__))
#define INTERNAL_MEMFUNCS
#endif

#ifndef INTERNAL_MEMFUNCS
#include <string.h>
#define llh_memcpy memcpy
#define llh_memset memset
#define llh_bzero explicit_bzero
#else
void _memcpy_impl(void *restrict dst, const void *restrict src, size_t n);
void _memset_impl(void *restrict dst, uint8_t c, size_t n);
void _explicit_bzero_impl(void *d, size_t n);

#define llh_memcpy(D, S, N) { \
  size_t _n = (size_t)(N); \
  if (__builtin_constant_p(_n)) { \
    uint8_t *_d = (uint8_t*)(D); \
    const uint8_t *_s = (uint8_t*)(S); \
    for (size_t _i = 0; _i < _n; ++_i) _d[_i] = _s[_i]; \
  } else { \
    _memcpy_impl((D), (S), _n); \
  } \
}

// The loop increment of 128 bytes was determined experimentally - it results
// in good inline code optimizations in both GCC and clang.
#define llh_memset(D, C, N) { \
  uint8_t _c = (uint8_t)(C); \
  size_t _n = (size_t)(N); \
  if (__builtin_constant_p(_n)) { \
    uint8_t *_d = (uint8_t*)(D); \
    size_t _b = _n >> 7, _r = _n & 127; \
    for (size_t _i = 0; _i < _b; ++_i) { \
      size_t _j = 0; \
      for (;_j <  64; ++_j) *_d++ = 0; \
      for (;_j < 128; ++_j) *_d++ = 0; \
    } \
    size_t _i = 0; \
    if (_r >  0) for (;_i <  64 && _i < _r; ++_i) *_d++ = _c; \
    if (_r > 64) for (;_i < 128 && _i < _r; ++_i) *_d++ = _c; \
  } else { \
    _memset_impl((D), _c, _n); \
  } \
}

#define llh_bzero(D, N) { \
  size_t _n = (size_t)(N); \
  if (__builtin_constant_p(_n)) { \
    uint8_t *_d = (uint8_t*)(D); \
    for (size_t _i = 0; _i < _n; ++_i) _d[_i] = 0; \
    __asm__ __volatile__ ("" : : "r"(_d) : "memory"); \
  } else { \
    _explicit_bzero_impl((D), _n); \
  } \
}
#endif
