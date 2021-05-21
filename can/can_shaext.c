#include <stdint.h>

#include "cpuinfo.h"

int can_shaext() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 7) {
    cpuid(7, 0, eax, ebx, ecx, edx);
    // ebx bit 29: sha  Intel SHA extensions
    if (ebx & (1 << 29)) return 1;
  }

  return 0;
}
