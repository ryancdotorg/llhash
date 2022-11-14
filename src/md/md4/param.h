// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_MD4(x) x

#define MD4_DIGEST_LENGTH 16
#define MD4_BLOCK_LENGTH 64
#define MD4_WORD_SIZE 32
#define MD4_STATE_WORDS 4
#define MD4_ENDIAN __ORDER_LITTLE_ENDIAN__

#define MD4_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476 \
}

#define MD4_IMPL_PRIO \
(native, NATIVE), \
(generic, GENERIC), \
(ryanc, RYANC), \
(ryanc_naive, RYANC_NAIVE)

#define MD4_USING_GENERIC           0
#define MD4_USING_NATIVE            1
#define MD4_USING_RYANC             2
#define MD4_USING_RYANC_NAIVE       3

#define MD4_ENABLE_GENERIC           (1<<MD4_USING_GENERIC)
#define MD4_ENABLE_NATIVE            (1<<MD4_USING_NATIVE)
#define MD4_ENABLE_RYANC             (1<<MD4_USING_RYANC)
#define MD4_ENABLE_RYANC_NAIVE       (1<<MD4_USING_RYANC_NAIVE)

#define MD4_DESC_GENERIC           "llhash (C)"
#define MD4_DESC_NATIVE            "llhash (C, -march=native)"
#define MD4_DESC_RYANC             "RyanC Optimized (asm)"
#define MD4_DESC_RYANC_NAIVE       "RyanC Naive (asm)"
