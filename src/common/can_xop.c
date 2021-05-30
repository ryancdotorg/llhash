#include <stdint.h>

#include "cpuinfo.h"

int can_xop() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0x80000001, 0, eax, ebx, ecx, edx);
  // ecx bit 11: XOP instruction set
  if (ecx & (1 << 11)) return 1;

  return 0;
}

int can_intel_xop() { return can_xop(); }
int can_cryptogams_xop() { return can_xop(); }
