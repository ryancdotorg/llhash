#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "cpuinfo.h"

int main() {
  int native = can_native();
  printf("native %d\n", native);
  return 0;
}
