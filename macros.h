#pragma once
#include "libh/libh.h"

/* assorted utility functions */
#define _STR(S) #S
#define STR(S) _STR(S)

#define IDENTITY(S) S

#define _H #
#define DIRECTIVE(S) _H S

#define _GET_VA4(_1, _2, _3, _4, NAME, ...) NAME

#define _JOIN2(A,B) A##_##B
#define _JOIN3(A,B,C) A##_##B##_##C
#define _JOIN4(A,B,C,D) A##_##B##_##C##_##D
#define JOIN(...) _GET_VA4(__VA_ARGS__, _JOIN4, _JOIN3, _JOIN2, IDENTITY)(__VA_ARGS__)

#define _CONCAT2(A,B) A##B
#define _CONCAT3(A,B,C) A##B##C
#define _CONCAT4(A,B,C,D) A##B##C##D
#define CONCAT(...) _GET_VA4(__VA_ARGS__, _CONCAT4, _CONCAT3, _CONCAT2, IDENTITY)(__VA_ARGS__)

/* help keep things short */
#define HASH(A) JOIN(HASH_NAME,A)
#define HMAC(A) JOIN(HMAC,HASH_NAME,A)

/* constant names */
#define HASH_DIGEST_LENGTH HASH(DIGEST_LENGTH)
#define HASH_BLOCK_LENGTH HASH(BLOCK_LENGTH)
#define HASH_STATE_WORDS HASH(STATE_WORDS)
#define HASH_WORD_SIZE HASH(WORD_SIZE)
#define HASH_ENDIAN HASH(ENDIAN)

/* type/size/endian definition macros */
#define uintWS_t CONCAT(uint,HASH_WORD_SIZE,_t)
#define htoDeWS CONCAT(hto,HASH_ENDIAN,e,HASH_WORD_SIZE)
#define htoDe32 CONCAT(hto,HASH_ENDIAN,e32)
#define htoDe64 CONCAT(hto,HASH_ENDIAN,e64)

/* rotate operators */
#define ROL8(x,n)  __extension__({ uint8_t  _x=(x), _n=(n); (_x << _n) | (_x >> ( 8-_n)); })
#define ROR8(x,n)  __extension__({ uint8_t  _x=(x), _n=(n); (_x >> _n) | (_x << ( 8-_n)); })
#define ROL16(x,n) __extension__({ uint16_t _x=(x), _n=(n); (_x << _n) | (_x >> (16-_n)); })
#define ROR16(x,n) __extension__({ uint16_t _x=(x), _n=(n); (_x >> _n) | (_x << (16-_n)); })
#define ROL32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x << _n) | (_x >> (32-_n)); })
#define ROR32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x >> _n) | (_x << (32-_n)); })
#define ROL64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x << _n) | (_x >> (64-_n)); })
#define ROR64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x >> _n) | (_x << (64-_n)); })
