#include <stdint.h>

#include "cpuinfo.h"

int can_sha512() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 7) {
    cpuid(7, 1, eax, ebx, ecx, edx);
    // eax bit 0: sha512 Intel SHA-512 extensions
    if (eax & (1 << 0)) return 1;
  }

  return 0;
}
