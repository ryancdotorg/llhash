#include <stdint.h>

#include "cpuinfo.h"

static const uint32_t reference[] = {0x8e006000, 22, 0x756e6547, 0x6c65746e, 0x49656e69};

int can_native() {
  uint32_t info[5];

  cpuinfo(info);
  for (int i = 0; i < 5; ++i) if (info[i] != reference[i]) return 0;
  for (int i = 0; i < 5; ++i) if (info[i]) return 1;
  return 0;
}
