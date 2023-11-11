// SPDX-License-Identifier: BSD-2-Clause
// Copyright (c) 2022, Ryan Castellucci, all rights reserved

#pragma once

#define _COMPARE_SHA2_512(x) x
#define SHA2_512_ALIAS() SHA512, ()

#define SHA2_512_DIGEST_LENGTH 64
#define SHA2_512_BLOCK_LENGTH 128
#define SHA2_512_WORD_SIZE 64
#define SHA2_512_STATE_WORDS 8
#define SHA2_512_ENDIAN __ORDER_BIG_ENDIAN__

#define SHA2_512_IV { \
  0x6a09e667f3bcc908, 0xbb67ae8584caa73b, \
  0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1, \
  0x510e527fade682d1, 0x9b05688c2b3e6c1f, \
  0x1f83d9abfb41bd6b, 0x5be0cd19137e2179  \
}

#define SHA2_512_IMPL_PRIO \
(cryptogams_avx2, avx2, CRYPTOGAMS_AVX2), \
(intel_avx2, avx2, INTEL_AVX2), \
(cryptogams_avx, avx, CRYPTOGAMS_AVX), \
(intel_avx, avx, INTEL_AVX), \
(cryptogams_xop, xop, CRYPTOGAMS_XOP), \
(intel_ssse3, ssse3, INTEL_SSSE3), \
(cryptogams_gen, x64, CRYPTOGAMS_GEN), \
(native, native, NATIVE), \
(generic, generic, GENERIC)

#define SHA2_512_USING_GENERIC         0
#define SHA2_512_USING_NATIVE          1
#define SHA2_512_USING_INTEL_SSSE3     2
#define SHA2_512_USING_INTEL_AVX       3
#define SHA2_512_USING_INTEL_AVX2      4
#define SHA2_512_USING_CRYPTOGAMS_GEN  5
#define SHA2_512_USING_CRYPTOGAMS_XOP  6
#define SHA2_512_USING_CRYPTOGAMS_AVX  7
#define SHA2_512_USING_CRYPTOGAMS_AVX2 8

#define SHA2_512_ENABLE_GENERIC         (1<<SHA2_512_USING_GENERIC)
#define SHA2_512_ENABLE_NATIVE          (1<<SHA2_512_USING_NATIVE)
#define SHA2_512_ENABLE_INTEL_SSSE3     (1<<SHA2_512_USING_INTEL_SSSE3)
#define SHA2_512_ENABLE_INTEL_AVX       (1<<SHA2_512_USING_INTEL_AVX)
#define SHA2_512_ENABLE_INTEL_AVX2      (1<<SHA2_512_USING_INTEL_AVX2)
#define SHA2_512_ENABLE_CRYPTOGAMS_GEN  (1<<SHA2_512_USING_CRYPTOGAMS_GEN)
#define SHA2_512_ENABLE_CRYPTOGAMS_XOP  (1<<SHA2_512_USING_CRYPTOGAMS_XOP)
#define SHA2_512_ENABLE_CRYPTOGAMS_AVX  (1<<SHA2_512_USING_CRYPTOGAMS_AVX)
#define SHA2_512_ENABLE_CRYPTOGAMS_AVX2 (1<<SHA2_512_USING_CRYPTOGAMS_AVX2)

#define SHA2_512_DESC_GENERIC          "llhash (C)"
#define SHA2_512_DESC_NATIVE           "llhash (C, -march=native)"
#define SHA2_512_DESC_INTEL_SSSE3      "Intel SSSE3 (x64 asm)"
#define SHA2_512_DESC_INTEL_AVX        "Intel AVX (x64 asm)"
#define SHA2_512_DESC_INTEL_AVX2       "Intel AVX2 (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_GEN   "Cryptogams Generic (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_XOP   "Cryptogams XOP (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_AVX   "Cryptogams AVX (x64 asm)"
#define SHA2_512_DESC_CRYPTOGAMS_AVX2  "Cryptogams AVX2 (x64 asm)"
