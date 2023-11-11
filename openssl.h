#pragma once

#define OPENSSL_HASH(NAME) \
int OpenSSL_has_##NAME (); \
void OpenSSL_##NAME (uint8_t hash[], const uint8_t data[], size_t len); \
void OpenSSL_EVP_##NAME (uint8_t hash[], const uint8_t data[], size_t len);

OPENSSL_HASH(MD4)
OPENSSL_HASH(MD5)
OPENSSL_HASH(RIPEMD160)
OPENSSL_HASH(SHA1)
OPENSSL_HASH(SHA2_224)
OPENSSL_HASH(SHA2_256)
OPENSSL_HASH(SHA2_384)
OPENSSL_HASH(SHA2_512)
