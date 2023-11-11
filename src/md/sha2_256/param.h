// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_SHA2_256(x) x
#define SHA2_256_ALIAS() SHA256, ()

#define SHA2_256_DIGEST_LENGTH 32
#define SHA2_256_BLOCK_LENGTH 64
#define SHA2_256_WORD_SIZE 32
#define SHA2_256_STATE_WORDS 8
#define SHA2_256_ENDIAN __ORDER_BIG_ENDIAN__

#define SHA2_256_IV { \
  0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, \
  0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19  \
}

#define SHA2_256_IMPL_PRIO \
(cryptogams_shaext, shaext, CRYPTOGAMS_SHAEXT), \
(intel_shaext, shaext, INTEL_SHAEXT), \
(cryptogams_avx2, avx2, CRYPTOGAMS_AVX2), \
(intel_avx2, avx2, INTEL_AVX2), \
(cryptogams_avx, avx, CRYPTOGAMS_AVX), \
(cryptogams_ssse3, ssse3, CRYPTOGAMS_SSSE3), \
(intel_avx, avx, INTEL_AVX), \
(intel_ssse3, ssse3, INTEL_SSSE3), \
(cryptogams_gen, x64, CRYPTOGAMS_GEN), \
(native, native, NATIVE), \
(generic, generic, GENERIC)

#define SHA2_256_USING_GENERIC            0
#define SHA2_256_USING_NATIVE             1
#define SHA2_256_USING_INTEL_SSSE3        2
#define SHA2_256_USING_INTEL_AVX          3
#define SHA2_256_USING_INTEL_AVX2         4
#define SHA2_256_USING_INTEL_SHAEXT       5
#define SHA2_256_USING_CRYPTOGAMS_GEN     6
#define SHA2_256_USING_CRYPTOGAMS_SSSE3   7
#define SHA2_256_USING_CRYPTOGAMS_AVX     8
#define SHA2_256_USING_CRYPTOGAMS_AVX2    9
#define SHA2_256_USING_CRYPTOGAMS_SHAEXT 10

#define SHA2_256_ENABLE_GENERIC           (1<<SHA2_256_USING_GENERIC)
#define SHA2_256_ENABLE_NATIVE            (1<<SHA2_256_USING_NATIVE)
#define SHA2_256_ENABLE_INTEL_SSSE3       (1<<SHA2_256_USING_INTEL_SSSE3)
#define SHA2_256_ENABLE_INTEL_AVX         (1<<SHA2_256_USING_INTEL_AVX)
#define SHA2_256_ENABLE_INTEL_AVX2        (1<<SHA2_256_USING_INTEL_AVX2)
#define SHA2_256_ENABLE_INTEL_SHAEXT      (1<<SHA2_256_USING_INTEL_SHAEXT)
#define SHA2_256_ENABLE_CRYPTOGAMS_GEN    (1<<SHA2_256_USING_CRYPTOGAMS_GEN)
#define SHA2_256_ENABLE_CRYPTOGAMS_SSSE3  (1<<SHA2_256_USING_CRYPTOGAMS_SSSE3)
#define SHA2_256_ENABLE_CRYPTOGAMS_AVX    (1<<SHA2_256_USING_CRYPTOGAMS_AVX)
#define SHA2_256_ENABLE_CRYPTOGAMS_AVX2   (1<<SHA2_256_USING_CRYPTOGAMS_AVX2)
#define SHA2_256_ENABLE_CRYPTOGAMS_SHAEXT (1<<SHA2_256_USING_CRYPTOGAMS_SHAEXT)

#define SHA2_256_DESC_GENERIC           "llhash (C)"
#define SHA2_256_DESC_NATIVE            "llhash (C, -march=native)"
#define SHA2_256_DESC_INTEL_SSSE3       "Intel SSSE3 (x64 asm)"
#define SHA2_256_DESC_INTEL_AVX         "Intel AVX (x64 asm)"
#define SHA2_256_DESC_INTEL_AVX2        "Intel AVX2 (x64 asm)"
#define SHA2_256_DESC_INTEL_SHAEXT      "Intel SHA-NI (x64 asm)"
#define SHA2_256_DESC_CRYPTOGAMS_GEN    "Cryptogams Generic (x64 asm)"
#define SHA2_256_DESC_CRYPTOGAMS_SSSE3  "Cryptogams SSSE3 (x64 asm)"
#define SHA2_256_DESC_CRYPTOGAMS_AVX    "Cryptogams AVX (x64 asm)"
#define SHA2_256_DESC_CRYPTOGAMS_AVX2   "Cryptogams AVX2 (x64 asm)"
#define SHA2_256_DESC_CRYPTOGAMS_SHAEXT "Cryptogams SHA-NI (x64 asm)"
