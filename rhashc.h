#pragma once

#define _STR(S) #S
#define STR(S) _STR(S)

#define _JOIN2(A,B) A##_##B
#define _JOIN3(A,B,C) A##_##B##_##C
#define _JOIN4(A,B,C,D) A##_##B##_##C##_##D
#define _GET_JOIN(_1, _2, _3, _4, NAME, ...) NAME
#define JOIN(...) _GET_JOIN(__VA_ARGS__, _JOIN4, _JOIN3, _JOIN2)(__VA_ARGS__)

#define RHASHC_ERROR_NOENABLE  -4
#define RHASHC_ERROR_UNAVAL    -3
#define RHASHC_ERROR_NOSUPPORT -2
#define RHASHC_ERROR_NOTBUILT  -1

#define ROL32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x << _n) | (_x >> (32-_n)); })
#define ROR32(x,n) __extension__({ uint32_t _x=(x), _n=(n); (_x >> _n) | (_x << (32-_n)); })
#define ROL64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x << _n) | (_x >> (64-_n)); })
#define ROR64(x,n) __extension__({ uint64_t _x=(x), _n=(n); (_x >> _n) | (_x << (64-_n)); })
