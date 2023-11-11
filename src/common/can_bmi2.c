#include <stdint.h>

#include "cpuinfo.h"

int can_bmi2() {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, eax, ebx, ecx, edx);
  if (eax >= 7) {
    cpuid(7, 0, eax, ebx, ecx, edx);
    // ebx bit 8: BMI2
    if (ebx & (1 << 8)) return 1;
  }

  return 0;
}
