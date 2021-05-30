#include <stdint.h>

#include "cpuinfo.h"

int can_cryptogams_gen() {
#ifdef __x86_64__
  return 1;
#else
  return 0;
#endif
}
