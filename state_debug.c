#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>
#include <stdarg.h>
#include <stdio.h>

#define STATE_DEBUG_SIZE 65536
static char *state_debug_data = NULL;
static size_t state_debug_pos;

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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#pragma GCC visibility push(internal)
static void state_debug_init() {
  if (state_debug_data == NULL) {
    if ((state_debug_data = malloc(STATE_DEBUG_SIZE)) == NULL) abort();
    state_debug_pos = 0;
    state_debug_data[state_debug_pos] = '\0';
  }
}

void state_debug_reset() {
  state_debug_init();
  state_debug_pos = 0;
  state_debug_data[state_debug_pos] = '\0';
}

void state_debug_print() {
  state_debug_init();
  printf("%s", state_debug_data);
}

static void state_debug_append(const char *fmt, ...) {
  state_debug_init();
  va_list ap;
  va_start(ap, fmt);
  size_t remaining = (STATE_DEBUG_SIZE - 1) - state_debug_pos;
  if (remaining > 0) {
    ssize_t n = vsnprintf(state_debug_data + state_debug_pos, remaining, fmt, ap);
    if (n == (ssize_t)remaining) {
      state_debug_pos = STATE_DEBUG_SIZE;
      state_debug_data[STATE_DEBUG_SIZE-2] = '\n';
      state_debug_data[STATE_DEBUG_SIZE-1] = '\0';
    } else {
      state_debug_pos += n;
    }
  }
}

void _prstate(
void *_state,
int word_size, int state_words, int endian, int order,
const char *file, const char *func, unsigned int lineno
) {
  uint64_t state[16];

  if (word_size == 32) {
    for (int i = 0; i < state_words; ++i) state[i] = ((uint32_t*)_state)[i];
  } else if (word_size == 64) {
    for (int i = 0; i < state_words; ++i) state[i] = ((uint64_t*)_state)[i];
  } else {
    abort();
  }

#if 1
  state_debug_append("{\"type\": \"state\", ");
  state_debug_append("\"file\": \"%s\", ", file);
  state_debug_append("\"func\": \"%s\", ", func);
  state_debug_append("\"lineno\": %u, ", lineno);
  state_debug_append("\"state\": [");
  for (int i = 0; i < state_words; ++i) {
    state_debug_append("%zu%s", state[i], i < state_words - 1 ? ", " : "");
  }
  state_debug_append("]}\n");

#else
  if (endian == order) {
    state_debug_append("state:           %s:%s:%u\n", file, func, lineno);
  } else {
    state_debug_append("state: (native)  %s:%s:%u\n", file, func, lineno);
  }

  for (int i = 0; i < state_words; ++i) {
    if (word_size == 64) {
      if (i % 4 == 0) state_debug_append(" ");
      state_debug_append(" %016zx", state[i]);
      if (i % 4 == 3 || i == state_words - 1) state_debug_append("\n");
    } else {
      if (i % 8 == 0) state_debug_append(" ");
      state_debug_append(" %08zx", state[i]);
      if (i % 8 == 7 || i == state_words - 1) state_debug_append("\n");
    }
  }
#endif
}

void _prblock(
const void *_blk, size_t n,
int word_size, int block_words, int endian, int order,
const char *file, const char *func, unsigned int lineno
) {
  size_t z = 0;
  size_t block_bytes = block_words * (word_size/8);

#if 1
  state_debug_append("{\"type\": \"block\", ");
  state_debug_append("\"file\": \"%s\", ", file);
  state_debug_append("\"func\": \"%s\", ", func);
  state_debug_append("\"lineno\": %u, ", lineno);
  state_debug_append("\"blocks\": [");
  for (size_t i = 0; i < n; ++i) {
    state_debug_append("\"");
    for (size_t j = 0; j < block_bytes; ++j) {
      state_debug_append("%02x", ((uint8_t*)_blk)[z+j]);
    }
    state_debug_append("\"%s", i < n - 1 ? ", " : "");
    z += block_bytes;
  }
  state_debug_append("]}\n");
#else
  uint64_t blk[64];

  if (endian == order) {
    state_debug_append("blocks:          %s:%s:%u\n", file, func, lineno);
  } else {
    state_debug_append("blocks: (native) %s:%s:%u\n", file, func, lineno);
  }

  for (size_t j = 0; j < n; ++j) {
    state_debug_append("%zd\n", j);

    if (word_size == 32) {
      for (int i = 0; i < block_words; ++i) blk[i] = ((uint32_t*)_blk)[z+i];
    } else if (word_size == 64) {
      for (int i = 0; i < block_words; ++i) blk[i] = ((uint64_t*)_blk)[z+i];
    } else {
      abort();
    }

    for (int i = 0; i < block_words; ++i) {
      if (word_size == 64) {
        if (i % 4 == 0) state_debug_append(" ");
        state_debug_append(" %016zx", blk[i]);
        if (i % 4 == 3 || i == block_words - 1) state_debug_append("\n");
      } else {
        if (i % 8 == 0) state_debug_append(" ");
        state_debug_append(" %08zx", blk[i]);
        if (i % 8 == 7 || i == block_words - 1) state_debug_append("\n");
      }
    }
    z += block_words;
  }
  state_debug_append("\n");
#endif
}
#pragma GCC visibility pop
#pragma GCC diagnostic pop
