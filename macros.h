#pragma once

#include "param.h"
#include "libh/libh.h"

/* assorted utility functions */
#define STR(S) _STR(S)
#define _STR(S) #S

#define IDENTITY(S) S

/* help keep things short */
#define HASH(A)   JOIN(VA_SEP(HASH_NAME,A))
#define HMAC(A)   JOIN(HMAC,HASH(A))
#define HKDF(A)   JOIN(HKDF,HASH(A))
#define PBKDF2(A) JOIN(PBKDF2,HMAC(A))

#define HMAC_NAME   HMAC()
#define HKDF_NAME   HKDF()
#define PBKDF2_NAME PBKDF2()

#define HASH_ALIASED IF_ELSE(GETTABLE(JOIN(HASH_NAME,ALIAS)))(1,0)
#define HASH_ALIAS GET(JOIN(HASH_NAME,ALIAS))
#define ALIAS(A) JOIN(HASH_ALIAS,A)

/* constant names */
#define HASH_DIGEST_LENGTH HASH(DIGEST_LENGTH)
#define HASH_BLOCK_LENGTH HASH(BLOCK_LENGTH)
#define HASH_STATE_WORDS HASH(STATE_WORDS)
#define HASH_WORD_SIZE HASH(WORD_SIZE)
#define HASH_WORD_BITS HASH_WORD_SIZE
#define HASH_WORD_BYTES BYTES(HASH_WORD_BITS)
#define HASH_STATE_BYTES (HASH_WORD_BYTES*HASH_STATE_WORDS)
#define HASH_BLOCK_WORDS IDIV(HASH_BLOCK_LENGTH,BYTES(HASH_WORD_BITS))
#define HASH_ENDIAN HASH(ENDIAN)

#ifdef HASH_NAME
/* ensure word size is valid */
#if !defined(HASH_WORD_SIZE)
#error "undefined HASH_WORD_SIZE"
#elif HASH_WORD_SIZE != 32 && HASH_WORD_SIZE != 64
#error "unsupported HASH_WORD_SIZE"
#endif

/* ensure endianness is valid */
#if !defined(HASH_ENDIAN)
#error "undefined HASH_ENDIAN"
#elif HASH_ENDIAN != __ORDER_BIG_ENDIAN__ && HASH_ENDIAN !=  __ORDER_LITTLE_ENDIAN__
#error "unsupported HASH_ENDIAN"
#endif
#endif

/* type/size definition */
#define uintWS_t CONCAT(uint,HASH_WORD_BITS,_t)

#if HASH_ENDIAN != __BYTE_ORDER__
#define statehtoDe(S) { \
  uintWS_t *w = (uintWS_t *)(S); \
  STR_PRAGMA(GCC unroll HASH_STATE_WORDS) \
  for (int i = 0; i < HASH_STATE_WORDS; ++i) w[i] = UWSH2DE(w[i]); \
}
#define stateDetoh(S) { \
  uintWS_t *w = (uintWS_t *)(S); \
  STR_PRAGMA(GCC unroll HASH_STATE_WORDS) \
  for (int i = 0; i < HASH_STATE_WORDS; ++i) w[i] = UWSDE2H(w[i]); \
}
#define blockhtoDe(S) { \
  uintWS_t *w = (uintWS_t *)(S); \
  STR_PRAGMA(GCC unroll HASH_BLOCK_WORDS) \
  for (int i = 0; i < HASH_BLOCK_WORDS; ++i) w[i] = UWSH2DE(w[i]); \
}
#define blockDetoh(S) { \
  uintWS_t *w = (uintWS_t *)(S); \
  STR_PRAGMA(GCC unroll HASH_BLOCK_WORDS) \
  for (int i = 0; i < HASH_BLOCK_WORDS; ++i) w[i] = UWSDE2H(w[i]); \
}
#else
#define statehtoDe(S)
#define stateDetoh(S)
#define blockhtoDe(S)
#define blockDetoh(S)
#endif

/* rotate operators */
#define ROL8(x,n)  __extension__({ uint8_t  _x=(x), _n=(n); (_x << _n) | (_x >> ( 8-_n)); })
#define ROR8(x,n)  __extension__({ uint8_t  _x=(x), _n=(n); (_x >> _n) | (_x << ( 8-_n)); })
#define ROL16(x,n) __extension__({ uint16_t _x=(x), _n=(n); (_x << _n) | (_x >> (16-_n)); })
#define ROR16(x,n) __extension__({ uint16_t _x=(x), _n=(n); (_x >> _n) | (_x << (16-_n)); })
#define ROL32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x << _n) | (_x >> (32-_n)); })
#define ROR32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x >> _n) | (_x << (32-_n)); })
#define ROL64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x << _n) | (_x >> (64-_n)); })
#define ROR64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x >> _n) | (_x << (64-_n)); })

#define PTR_ADD(P, N) ((typeof(P))(((unsigned char *)(P)) + (N)))
#define PTR_SUB(P, N) ((typeof(P))(((unsigned char *)(P)) - (N)))
#define TAILCPY(D, S, O, N) memcpy(((unsigned char *)(D)) + (O), ((unsigned char *)(S)) + (O), (N)-(O))

#define _OFFSETCPY4(D, DO, S, N) memcpy(((unsigned char *)(D)) + (DO), S, N)
#define _OFFSETCPY5(D, DO, S, SO, N) memcpy(((unsigned char *)(D)) + (DO), ((unsigned char *)(S)) + (SO), N)
#define OFFSETCPY(D, DO, S, ...) VA_SELECT((D, DO, S), (__VA_ARGS__), _OFFSETCPY4, _OFFSETCPY5)

#define OFFSETFILL(D, O, V, N) memset(((unsigned char *)(D)) + (O), (V), (N)-(O));

#if HASH_ENDIAN == __ORDER_BIG_ENDIAN__ && HASH_WORD_SIZE == 64
#define NTH_BYTE_OF_WORD(W, N) (((W) >> (56-BITS(N))) & 0xff)
#elif HASH_ENDIAN == __ORDER_BIG_ENDIAN__ && HASH_WORD_SIZE == 32
#define NTH_BYTE_OF_WORD(W, N) (((W) >> (24-BITS(N))) & 0xff)
#elif HASH_ENDIAN == __ORDER_LITTLE_ENDIAN__
#define NTH_BYTE_OF_WORD(W, N) (((W) >> BITS(N)) & 0xff)
#endif
