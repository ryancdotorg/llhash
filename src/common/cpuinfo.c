#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "cpuinfo.h"

void cpuinfo(uint32_t *res) {
  uint32_t eax, ebx, ecx, edx;
  cpuid(0, 0, res[1], res[2], res[3], res[4]);

  cpuid(1, 0, eax, ebx, ecx, edx);
  uint32_t model =  (eax >>  4) & 0xf;
  uint32_t family = (eax >>  8) & 0xf;
  uint32_t type =   (eax >> 12) & 0x3;
  uint32_t extmod = (eax >> 16) & 0xf;
  uint32_t extfam = (eax >> 20) & 0xff;
  uint32_t brand = ebx & 0xff;
  res[0] = (model << 24) | (family << 12) | (type << 8) | brand;
  if (family == 15) res[0] |= extfam << 16;
  if (family == 6 || family == 15) res[0] |= extmod << 28;
}

void cpuinfo(uint32_t *);
int can_native();
