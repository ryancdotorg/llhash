#pragma once

void OpenSSL_MD4(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_MD5(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_RIPEMD160(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_SHA1(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_SHA2_224(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_SHA2_256(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_SHA2_384(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_SHA2_512(uint8_t hash[], const uint8_t data[], size_t len);

void OpenSSL_EVP_MD4(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_MD5(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_RIPEMD160(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_SHA1(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_SHA2_224(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_SHA2_256(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_SHA2_384(uint8_t hash[], const uint8_t data[], size_t len);
void OpenSSL_EVP_SHA2_512(uint8_t hash[], const uint8_t data[], size_t len);
