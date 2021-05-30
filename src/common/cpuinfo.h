#pragma once

#if defined(__x86_64__) || defined(__i386__)
#include <cpuid.h>
#define cpuid(level, arg, a, b, c, d) \
(a=b=c=d=0, __get_cpuid_count(level, arg, &(a), &(b), &(c), &(d)) ? 0 : -1)
/*
  asm("cpuid" \
      : "=a" (a), "=b" (b), "=c" (c), "=d" (d) \
      : "0" (level), "2" (arg))
*/
#else
#define cpuid(level, arg, a, b, c, d) \
(a=b=c=d=0, -1)
#endif

void cpuinfo(uint32_t *);
int can_native();
