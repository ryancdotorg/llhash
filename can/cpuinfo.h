#pragma once

#if defined(__x86_64__) || defined(__i386__)
  uint32_t eax, ebx, ecx, edx;
#define cpuid(level, arg, a, b, c, d) \
  asm("cpuid" \
      : "=a" (a), "=b" (b), "=c" (c), "=d" (d) \
      : "0" (level), "2" (arg))
#else
#define cpuid(level, arg, a, b, c, d) \
do { a = 0; b = 0; c = 0; d = 0; } while (0)
#endif

void cpuinfo(uint32_t *);
int can_native();
