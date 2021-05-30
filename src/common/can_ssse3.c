#include <stdint.h>

#include "cpuinfo.h"

int can_ssse3() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(1, 0, eax, ebx, ecx, edx);
  // ecx bit  9: ssse3 Supplemental SSE3 instructions
  if (ecx & (1 << 9)) return 1;

  return 0;
}

int can_intel_ssse3() { return can_ssse3(); }
int can_cryptogams_ssse3() { return can_ssse3(); }
