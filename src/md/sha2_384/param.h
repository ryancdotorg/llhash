// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_SHA2_384(x) x
#define SHA2_384_ALIAS() SHA384, ()

#define SHA2_384_DIGEST_LENGTH 48
#define SHA2_384_BLOCK_LENGTH 128
#define SHA2_384_WORD_SIZE 64
#define SHA2_384_STATE_WORDS 8
#define SHA2_384_ENDIAN __ORDER_BIG_ENDIAN__

#define SHA2_384_IV { \
  0xcbbb9d5dc1059ed8, 0x629a292a367cd507, \
  0x9159015a3070dd17, 0x152fecd8f70e5939, \
  0x67332667ffc00b31, 0x8eb44a8768581511, \
  0xdb0c2e0d64f98fa7, 0x47b5481dbefa4fa4  \
}

#define SHA2_384_IMPL_PRIO \
(cryptogams_avx2, avx2, CRYPTOGAMS_AVX2), \
(intel_avx2, avx2, INTEL_AVX2), \
(cryptogams_avx, avx, CRYPTOGAMS_AVX), \
(intel_avx, avx, INTEL_AVX), \
(cryptogams_xop, xop, CRYPTOGAMS_XOP), \
(intel_ssse3, ssse3, INTEL_SSSE3), \
(cryptogams_gen, x64, CRYPTOGAMS_GEN), \
(native, native, NATIVE), \
(generic, generic, GENERIC)

#define SHA2_384_USING_GENERIC         0
#define SHA2_384_USING_NATIVE          1
#define SHA2_384_USING_INTEL_SSSE3     2
#define SHA2_384_USING_INTEL_AVX       3
#define SHA2_384_USING_INTEL_AVX2      4
#define SHA2_384_USING_CRYPTOGAMS_GEN  5
#define SHA2_384_USING_CRYPTOGAMS_XOP  6
#define SHA2_384_USING_CRYPTOGAMS_AVX  7
#define SHA2_384_USING_CRYPTOGAMS_AVX2 8

#define SHA2_384_ENABLE_GENERIC         (1<<SHA2_384_USING_GENERIC)
#define SHA2_384_ENABLE_NATIVE          (1<<SHA2_384_USING_NATIVE)
#define SHA2_384_ENABLE_INTEL_SSSE3     (1<<SHA2_384_USING_INTEL_SSSE3)
#define SHA2_384_ENABLE_INTEL_AVX       (1<<SHA2_384_USING_INTEL_AVX)
#define SHA2_384_ENABLE_INTEL_AVX2      (1<<SHA2_384_USING_INTEL_AVX2)
#define SHA2_384_ENABLE_CRYPTOGAMS_GEN  (1<<SHA2_384_USING_CRYPTOGAMS_GEN)
#define SHA2_384_ENABLE_CRYPTOGAMS_XOP  (1<<SHA2_384_USING_CRYPTOGAMS_XOP)
#define SHA2_384_ENABLE_CRYPTOGAMS_AVX  (1<<SHA2_384_USING_CRYPTOGAMS_AVX)
#define SHA2_384_ENABLE_CRYPTOGAMS_AVX2 (1<<SHA2_384_USING_CRYPTOGAMS_AVX2)

#define SHA2_384_DESC_GENERIC          "llhash (C)"
#define SHA2_384_DESC_NATIVE           "llhash (C, -march=native)"
#define SHA2_384_DESC_INTEL_SSSE3      "Intel SSSE3 (x64 asm)"
#define SHA2_384_DESC_INTEL_AVX        "Intel AVX (x64 asm)"
#define SHA2_384_DESC_INTEL_AVX2       "Intel AVX2 (x64 asm)"
#define SHA2_384_DESC_CRYPTOGAMS_GEN   "Cryptogams Generic (x64 asm)"
#define SHA2_384_DESC_CRYPTOGAMS_XOP   "Cryptogams XOP (x64 asm)"
#define SHA2_384_DESC_CRYPTOGAMS_AVX   "Cryptogams AVX (x64 asm)"
#define SHA2_384_DESC_CRYPTOGAMS_AVX2  "Cryptogams AVX2 (x64 asm)"
