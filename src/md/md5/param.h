// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_MD5(x) x

#define MD5_DIGEST_LENGTH 16
#define MD5_BLOCK_LENGTH 64
#define MD5_WORD_SIZE 32
#define MD5_STATE_WORDS 4
#define MD5_ENDIAN __ORDER_LITTLE_ENDIAN__

#define MD5_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476 \
}

#define MD5_IMPL_PRIO \
(ryanc, x64, RYANC), \
(native, native, NATIVE), \
(generic, generic, GENERIC)

#define MD5_USING_GENERIC              0
#define MD5_USING_NATIVE               1
#define MD5_USING_RYANC                2

#define MD5_ENABLE_GENERIC             (1<<MD5_USING_GENERIC)
#define MD5_ENABLE_NATIVE              (1<<MD5_USING_NATIVE)
#define MD5_ENABLE_RYANC               (1<<MD5_USING_RYANC)

#define MD5_DESC_GENERIC               "llhash (C)"
#define MD5_DESC_NATIVE                "llhash (C, -march=native)"
#define MD5_DESC_RYANC                 "RyanC (x64 asm)"
