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
    "#include \"src/common/cpuinfo.h\"\n\n"
  );

  printf(
    "static const uint32_t build_cpuid[] =     "
    "{0x%08x, %u, 0x%08x, 0x%08x, 0x%08x};\n",
    info[0], info[1], info[2], info[3], info[4]
  );

  printf("static const char     build_mfg_str[] =   \"");
  if (cpuid(0, 0, info[3], info[0], info[2], info[1]) == 0) {
    for (int i = 0; i < 12; ++i) {
      unsigned char c = ((unsigned char *)info)[i];
      if (c == 0) break;
      if (c >= 0x20 && c <= 0x7e) {
        printf("%c", c);
      } else {
        printf("\\%03o", c);
      }
    }
  }
  printf("\";\n");

  printf("static const char     build_brand_str[] = \"");
  for (uint32_t leaf = 0x80000002; leaf <= 0x80000004; ++leaf) {
    if (cpuid(leaf, 0, info[0], info[1], info[2], info[3]) != 0) break;
    for (int i = 0; i < 16; ++i) {
      unsigned char c = ((unsigned char *)info)[i];
      if (c == 0) { leaf += 9; break; }
      if (c >= 0x20 && c <= 0x7e) {
        printf("%c", c);
      } else {
        printf("\\%03o", c);
      }
    }
  }
  printf("\";\n");

  printf(
    "\nint can_native() {\n"
    "  uint32_t info[%d];\n\n"
    "  cpuinfo(info);\n"
    "  for (int i = 0; i < %d; ++i) if (info[i] != build_cpuid[i]) return 0;\n"
    "  for (int i = 0; i < %d; ++i) if (info[i]) return 1;\n"
    "  return 0;\n"
    "}\n",
    INFO_SZ, INFO_SZ, INFO_SZ
  );

  return 0;
}
