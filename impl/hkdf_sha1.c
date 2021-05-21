#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <endian.h>
#include <stdlib.h>
#include <stdio.h>

#include "../rhashc.h"
#include "../sha1.h"

void HKFD_Extract_SHA1(
uint8_t hash[],
const uint8_t salt[], size_t salt_sz,
const uint8_t data[], size_t data_sz) {
  if (salt == NULL && salt_sz == 0) {
    HMAC_SHA1(hash, "", 1, data, data_sz);
  } else {
    HMAC_SHA1(hash, salt, salt_sz, data, data_sz);
  }
}

void HKFD_Expand_SHA1(
uint8_t dk[], size_t dk_sz,
const uint8_t info[], size_t info_sz,
const uint8_t data[], size_t data_sz) {
  /* RFC5869 parameter restrictions */
  if (data_sz < SHA1_DIGEST_LENGTH || dk_sz > SHA1_DIGEST_LENGTH * 255) {
    fprintf(stderr, "Invalid HKFD_Expand_SHA1 parameters!\n");
    abort();
  }
  if (info == NULL && info_sz == 0) info = "";

  uint8_t T[SHA1_BLOCK_LENGTH*4];


  

}
