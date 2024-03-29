// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_SHA2_224(x) x
#define SHA2_224_ALIAS() SHA224, ()

#define SHA2_224_DIGEST_LENGTH 28
#define SHA2_224_BLOCK_LENGTH 64
#define SHA2_224_WORD_SIZE 32
#define SHA2_224_STATE_WORDS 8
#define SHA2_224_ENDIAN __ORDER_BIG_ENDIAN__

#define SHA2_224_IV { \
  0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939, \
  0xffc00b31, 0x68581511, 0x64f98fa7, 0xbefa4fa4  \
}

#define SHA2_224_IMPL_PRIO \
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

#define SHA2_224_USING_GENERIC            0
#define SHA2_224_USING_NATIVE             1
#define SHA2_224_USING_INTEL_SSSE3        2
#define SHA2_224_USING_INTEL_AVX          3
#define SHA2_224_USING_INTEL_AVX2         4
#define SHA2_224_USING_INTEL_SHAEXT       5
#define SHA2_224_USING_CRYPTOGAMS_GEN     6
#define SHA2_224_USING_CRYPTOGAMS_SSSE3   7
#define SHA2_224_USING_CRYPTOGAMS_AVX     8
#define SHA2_224_USING_CRYPTOGAMS_AVX2    9
#define SHA2_224_USING_CRYPTOGAMS_SHAEXT 10

#define SHA2_224_ENABLE_GENERIC           (1<<SHA2_224_USING_GENERIC)
#define SHA2_224_ENABLE_NATIVE            (1<<SHA2_224_USING_NATIVE)
#define SHA2_224_ENABLE_INTEL_SSSE3       (1<<SHA2_224_USING_INTEL_SSSE3)
#define SHA2_224_ENABLE_INTEL_AVX         (1<<SHA2_224_USING_INTEL_AVX)
#define SHA2_224_ENABLE_INTEL_AVX2        (1<<SHA2_224_USING_INTEL_AVX2)
#define SHA2_224_ENABLE_INTEL_SHAEXT      (1<<SHA2_224_USING_INTEL_SHAEXT)
#define SHA2_224_ENABLE_CRYPTOGAMS_GEN    (1<<SHA2_224_USING_CRYPTOGAMS_GEN)
#define SHA2_224_ENABLE_CRYPTOGAMS_SSSE3  (1<<SHA2_224_USING_CRYPTOGAMS_SSSE3)
#define SHA2_224_ENABLE_CRYPTOGAMS_AVX    (1<<SHA2_224_USING_CRYPTOGAMS_AVX)
#define SHA2_224_ENABLE_CRYPTOGAMS_AVX2   (1<<SHA2_224_USING_CRYPTOGAMS_AVX2)
#define SHA2_224_ENABLE_CRYPTOGAMS_SHAEXT (1<<SHA2_224_USING_CRYPTOGAMS_SHAEXT)

#define SHA2_224_DESC_GENERIC           "llhash (C)"
#define SHA2_224_DESC_NATIVE            "llhash (C, -march=native)"
#define SHA2_224_DESC_INTEL_SSSE3       "Intel SSSE3 (x64 asm)"
#define SHA2_224_DESC_INTEL_AVX         "Intel AVX (x64 asm)"
#define SHA2_224_DESC_INTEL_AVX2        "Intel AVX2 (x64 asm)"
#define SHA2_224_DESC_INTEL_SHAEXT      "Intel SHA-NI (x64 asm)"
#define SHA2_224_DESC_CRYPTOGAMS_GEN    "Cryptogams Generic (x64 asm)"
#define SHA2_224_DESC_CRYPTOGAMS_SSSE3  "Cryptogams SSSE3 (x64 asm)"
#define SHA2_224_DESC_CRYPTOGAMS_AVX    "Cryptogams AVX (x64 asm)"
#define SHA2_224_DESC_CRYPTOGAMS_AVX2   "Cryptogams AVX2 (x64 asm)"
#define SHA2_224_DESC_CRYPTOGAMS_SHAEXT "Cryptogams SHA-NI (x64 asm)"
