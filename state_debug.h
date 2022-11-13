#ifndef __STATE_DEBUG_H_
#define __STATE_DEBUG_H_
void state_debug_reset();
void state_debug_print();
void _prstate(const void *, int, int, int, int, const char *, const char *, unsigned int);
void _prblock(const void *, int, int, int, int, int, const char *, const char *, unsigned int);
#endif//__STATE_DEBUG_H_

#if 0 && !defined(DEBUG_STATE)

#ifdef prblock
#undef prblock
#endif
#define prblock(...)

#ifdef prstate
#undef prstate
#endif
#define prstate(...)

#else //DEBUG_STATE

#ifdef prblock
#undef prblock
#endif
#define prblock(a, b) _prblock(a, b, \
  HASH_WORD_SIZE, HASH_BLOCK_WORDS, HASH_ENDIAN, __BYTE_ORDER__, \
  __FILE__, __func__, __LINE__ \
)

#ifdef prstate
#undef prstate
#endif
#define prstate(a) _prstate(a, \
  HASH_WORD_SIZE, HASH_STATE_WORDS, HASH_ENDIAN, __BYTE_ORDER__, \
  __FILE__, __func__, __LINE__ \
)
#endif//DEBUG_STATE
