#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "cpuinfo.h"

#define INFO_SZ 5

int main() {
  uint32_t info[INFO_SZ];

  cpuinfo(info);

  printf(
    "#include <stdint.h>\n\n"
    "#include \"cpuinfo.h\"\n\n"
    "static const uint32_t reference[] = "
    "{0x%08x, %u, 0x%08x, 0x%08x, 0x%08x};\n\n"
    "int can_native() {\n"
    "  uint32_t info[%d];\n\n"
    "  cpuinfo(info);\n"
    "  for (int i = 0; i < %d; ++i) if (info[i] != reference[i]) return 0;\n"
    "  for (int i = 0; i < %d; ++i) if (info[i]) return 1;\n"
    "  return 0;\n"
    "}\n",
    info[0], info[1], info[2], info[3], info[4],
    INFO_SZ, INFO_SZ, INFO_SZ
  );

  return 0;
}
