#include <stdint.h>

#include "cpuinfo.h"

int can_movbe() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 1) {
    cpuid(1, 0, eax, ebx, ecx, edx);
    // ecx bit 22: movbe MOVBE Instruction
    if (ecx & (1 << 22)) return 1;
  }

  return 0;
}
