#pragma once

#define MD4_DIGEST_LENGTH 16
#define MD4_BLOCK_LENGTH 64
#define MD4_WORD_SIZE 32
#define MD4_STATE_WORDS 4
#define MD4_ENDIAN l

#define MD4_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476 \
}

#define MD4_USING_GENERIC           0
#define MD4_USING_NATIVE            1

#define MD4_ENABLE_GENERIC           (1<<MD4_USING_GENERIC)
#define MD4_ENABLE_NATIVE            (1<<MD4_USING_NATIVE)

#define MD4_DESC_GENERIC           "llhash (C)"
#define MD4_DESC_NATIVE            "llhash (C, -march=native)"
