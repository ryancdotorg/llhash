// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_SHA1(x) x

#define SHA1_DIGEST_LENGTH 20
#define SHA1_BLOCK_LENGTH 64
#define SHA1_WORD_SIZE 32
#define SHA1_STATE_WORDS 5
#define SHA1_ENDIAN __ORDER_BIG_ENDIAN__

#define SHA1_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 \
}

#define SHA1_IMPL_PRIO \
(cryptogams_shaext, shaext, CRYPTOGAMS_SHAEXT), \
(intel_shaext, shaext, INTEL_SHAEXT), \
(cryptogams_avx2, avx2, CRYPTOGAMS_AVX2), \
(intel_avx2, avx2, INTEL_AVX2), \
(cryptogams_avx, avx, CRYPTOGAMS_AVX), \
(intel_avx, avx, INTEL_AVX), \
(cryptogams_ssse3, ssse3, CRYPTOGAMS_SSSE3), \
(intel_ssse3, ssse3, INTEL_SSSE3), \
(cryptogams_gen, x64, CRYPTOGAMS_GEN), \
(native, native, NATIVE), \
(generic, generic, GENERIC)

#define SHA1_USING_GENERIC             0
#define SHA1_USING_NATIVE              1
#define SHA1_USING_INTEL_SSSE3         2
#define SHA1_USING_INTEL_AVX           3
#define SHA1_USING_INTEL_AVX2          4
#define SHA1_USING_INTEL_SHAEXT        5
#define SHA1_USING_CRYPTOGAMS_GEN      6
#define SHA1_USING_CRYPTOGAMS_SSSE3    7
#define SHA1_USING_CRYPTOGAMS_AVX      8
#define SHA1_USING_CRYPTOGAMS_AVX2     9
#define SHA1_USING_CRYPTOGAMS_SHAEXT  10

#define SHA1_ENABLE_GENERIC           (1<<SHA1_USING_GENERIC)
#define SHA1_ENABLE_NATIVE            (1<<SHA1_USING_NATIVE)
#define SHA1_ENABLE_INTEL_SSSE3       (1<<SHA1_USING_INTEL_SSSE3)
#define SHA1_ENABLE_INTEL_AVX         (1<<SHA1_USING_INTEL_AVX)
#define SHA1_ENABLE_INTEL_AVX2        (1<<SHA1_USING_INTEL_AVX2)
#define SHA1_ENABLE_INTEL_SHAEXT      (1<<SHA1_USING_INTEL_SHAEXT)
#define SHA1_ENABLE_CRYPTOGAMS_GEN    (1<<SHA1_USING_CRYPTOGAMS_GEN)
#define SHA1_ENABLE_CRYPTOGAMS_SSSE3  (1<<SHA1_USING_CRYPTOGAMS_SSSE3)
#define SHA1_ENABLE_CRYPTOGAMS_AVX    (1<<SHA1_USING_CRYPTOGAMS_AVX)
#define SHA1_ENABLE_CRYPTOGAMS_AVX2   (1<<SHA1_USING_CRYPTOGAMS_AVX2)
#define SHA1_ENABLE_CRYPTOGAMS_SHAEXT (1<<SHA1_USING_CRYPTOGAMS_SHAEXT)

#define SHA1_DESC_GENERIC             "llhash (C)"
#define SHA1_DESC_NATIVE              "llhash (C, -march=native)"
#define SHA1_DESC_INTEL_SSSE3         "Intel SSSE3 (x64 asm)"
#define SHA1_DESC_INTEL_AVX           "Intel AVX (x64 asm)"
#define SHA1_DESC_INTEL_AVX2          "Intel AVX2 (x64 asm)"
#define SHA1_DESC_INTEL_SHAEXT        "Intel SHA-NI (x64 asm)"
#define SHA1_DESC_CRYPTOGAMS_GEN      "Cryptogams Generic (x64 asm)"
#define SHA1_DESC_CRYPTOGAMS_SSSE3    "Cryptogams SSSE3 (x64 asm)"
#define SHA1_DESC_CRYPTOGAMS_AVX      "Cryptogams AVX (x64 asm)"
#define SHA1_DESC_CRYPTOGAMS_AVX2     "Cryptogams AVX2 (x64 asm)"
#define SHA1_DESC_CRYPTOGAMS_SHAEXT   "Cryptogams SHA-NI (x64 asm)"
