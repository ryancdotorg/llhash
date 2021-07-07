#include <stdint.h>

#include "cpuinfo.h"

int can_dispatch() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 7) {
    cpuid(1, 0, eax, ebx, ecx, edx);
    // ecx bit  9: ssse3 Supplemental SSE3 instructions
    if (!(ecx & (1 << 9))) return 0;

    cpuid(7, 0, eax, ebx, ecx, edx);
    // ebx bit  8: bmi2 Bit Manipulation Instruction Set 2
    // ebx bit  5: avx2 Advanced Vector Extensions 2
    if (!((ebx & (1 << 8)) && (ebx & (1 << 5)))) return 0;

    return 1;
  }

  return 0;
}
