#include <stdint.h>

#include "cpuinfo.h"

int can_avx() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(1, 0, eax, ebx, ecx, edx);
  // ecx bit 28: avx   Advanced Vector Extensions
  if (ecx & (1 << 28)) return 1;

  return 0;
}

int can_intel_avx() { return can_avx(); }
int can_cryptogams_avx() { return can_avx(); }
