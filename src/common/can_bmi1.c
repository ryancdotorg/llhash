#include <stdint.h>

#include "cpuinfo.h"

int can_bmi1() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 7) {
    cpuid(7, 0, eax, ebx, ecx, edx);
    // ebx bit 3: BMI1
    if (ebx & (1 << 3)) return 1;
  }

  return 0;
}
