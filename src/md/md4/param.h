#pragma once

#define MD4_DIGEST_LENGTH 20
#define MD4_BLOCK_LENGTH 64
#define MD4_WORD_SIZE 32
#define MD4_STATE_WORDS 5
#define MD4_ENDIAN b

#define MD4_IV { \
  0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 \
}

#define MD4_USING_GENERIC           0
#define MD4_USING_NATIVE            1
#define MD4_USING_NAYUKI64          2
#define MD4_USING_INTEL_SSSE3       3
#define MD4_USING_INTEL_AVX         4
#define MD4_USING_INTEL_AVX2        5
#define MD4_USING_INTEL_SHAEXT      6
#define MD4_USING_CRYPTOGAMS_GEN    7
#define MD4_USING_CRYPTOGAMS_SSSE3  8
#define MD4_USING_CRYPTOGAMS_SHAEXT 9

#define MD4_ENABLE_GENERIC           (1<<MD4_USING_GENERIC)
#define MD4_ENABLE_NATIVE            (1<<MD4_USING_NATIVE)
#define MD4_ENABLE_NAYUKI64          (1<<MD4_USING_NAYUKI64)
#define MD4_ENABLE_INTEL_SSSE3       (1<<MD4_USING_INTEL_SSSE3)
#define MD4_ENABLE_INTEL_AVX         (1<<MD4_USING_INTEL_AVX)
#define MD4_ENABLE_INTEL_AVX2        (1<<MD4_USING_INTEL_AVX2)
#define MD4_ENABLE_INTEL_SHAEXT      (1<<MD4_USING_INTEL_SHAEXT)
#define MD4_ENABLE_CRYPTOGAMS_GEN    (1<<MD4_USING_CRYPTOGAMS_GEN)
#define MD4_ENABLE_CRYPTOGAMS_SSSE3  (1<<MD4_USING_CRYPTOGAMS_SSSE3)
#define MD4_ENABLE_CRYPTOGAMS_SHAEXT (1<<MD4_USING_CRYPTOGAMS_SHAEXT)

#define MD4_DESC_GENERIC           "Rhashc (C)"
#define MD4_DESC_NATIVE            "Rhashc (C, -march=native)"
#define MD4_DESC_NAYUKI64          "Nayuki (x64 asm)"
#define MD4_DESC_INTEL_SSSE3       "Intel SSSE3 (x64 asm)"
#define MD4_DESC_INTEL_AVX         "Intel AVX (x64 asm)"
#define MD4_DESC_INTEL_AVX2        "Intel AVX2 (x64 asm)"
#define MD4_DESC_INTEL_SHAEXT      "Intel SHA-NI (x64 asm)"
#define MD4_DESC_CRYPTOGAMS_GEN    "Cryptogams Generic (x64 asm)"
#define MD4_DESC_CRYPTOGAMS_SSSE3  "Cryptogams SSSE3 (x64 asm)"
#define MD4_DESC_CRYPTOGAMS_SHAEXT "Cryptogams SHA-NI (x64 asm)"
