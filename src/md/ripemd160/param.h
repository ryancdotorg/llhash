// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_RIPEMD160(x) x

#define RIPEMD160_DIGEST_LENGTH 20
#define RIPEMD160_BLOCK_LENGTH 64
#define RIPEMD160_WORD_SIZE 32
#define RIPEMD160_STATE_WORDS 5
#define RIPEMD160_ENDIAN __ORDER_LITTLE_ENDIAN__

#define RIPEMD160_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 \
}

#define RIPEMD160_IMPL_PRIO \
(ryanc, x64, RYANC), \
(native, native, NATIVE), \
(generic, generic, GENERIC),

#define RIPEMD160_USING_GENERIC              0
#define RIPEMD160_USING_NATIVE               1
#define RIPEMD160_USING_RYANC                2

#define RIPEMD160_ENABLE_GENERIC             (1<<RIPEMD160_USING_GENERIC)
#define RIPEMD160_ENABLE_NATIVE              (1<<RIPEMD160_USING_NATIVE)
#define RIPEMD160_ENABLE_RYANC               (1<<RIPEMD160_USING_RYANC)

#define RIPEMD160_DESC_GENERIC               "llhash (C)"
#define RIPEMD160_DESC_NATIVE                "llhash (C, -march=native)"
#define RIPEMD160_DESC_RYANC                 "RyanC (x64 asm)"
