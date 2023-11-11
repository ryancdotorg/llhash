#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>
#include <stdio.h>

#include <openssl/crypto.h>
#include <openssl/hmac.h>
#include <openssl/evp.h>

#include "openssl.h"

static char *libcrypto[] = {
  "libcrypto.so.1.1",
  "libcrypto.so.1.0",
  "libcrypto.so.1",
  "libcrypto.so",
  NULL
};

#define DLFUNC(NAME, TYPE, ARGS, ARGN) \
static TYPE _load_##NAME ARGS; \
static TYPE (*_##NAME)ARGS = _load_##NAME; \
static int _has_##NAME () { \
  int i = 0; \
  char *filename; \
  void *handle = NULL; \
  while (handle == NULL && (filename = libcrypto[i++]) != NULL) { \
    handle = dlopen(filename, RTLD_LAZY); \
  } \
  _##NAME = (typeof(_##NAME))(intptr_t)(dlsym(handle, #NAME)); \
  return (_##NAME != NULL); \
} \
static TYPE _load_##NAME ARGS { \
  if (!_has_##NAME ()) { \
    fprintf(stderr, "fatal: can't load function `%s`!\n", #NAME); \
    abort(); \
  } \
  return _##NAME ARGN; \
}

DLFUNC(EVP_Digest, int,
  (const void *a, size_t b, unsigned char *c, unsigned int *d, const EVP_MD *e, ENGINE *f),
  (a, b, c, d, e, f)
)

static const EVP_MD *md_md4, *md_md5, *md_ripemd160, *md_sha1;
static const EVP_MD *md_sha224, *md_sha256, *md_sha384, *md_sha512;

#define OPENSSL_DIGEST(NAME, QNAME, name) \
DLFUNC(EVP_##name, const EVP_MD *, (), ()) \
DLFUNC(QNAME, unsigned char *, (const unsigned char *a, unsigned long b, unsigned char *c), (a, b, c)) \
void OpenSSL_EVP_##NAME (uint8_t hash[], const uint8_t data[], size_t len) { \
  _EVP_Digest(data, len, hash, NULL, md_##name, NULL); \
} \
void OpenSSL_##NAME (uint8_t hash[], const uint8_t data[], size_t len) { \
  _##QNAME (data, len, hash); \
} \
int OpenSSL_has_##NAME() { \
  return _has_EVP_##name(); \
}

OPENSSL_DIGEST(MD4, MD4, md4)
OPENSSL_DIGEST(MD5, MD5, md5)
OPENSSL_DIGEST(RIPEMD160, RIPEMD160, ripemd160)
OPENSSL_DIGEST(SHA1, SHA1, sha1)
OPENSSL_DIGEST(SHA2_224, SHA224, sha224)
OPENSSL_DIGEST(SHA2_256, SHA256, sha256)
OPENSSL_DIGEST(SHA2_384, SHA384, sha384)
OPENSSL_DIGEST(SHA2_512, SHA512, sha512)

#define INIT_EVP(MD) md_##MD = _has_EVP_##MD () ? _EVP_##MD () : NULL
static __attribute__((constructor)) void getmd() {
  INIT_EVP(md4);
  INIT_EVP(md5);
  INIT_EVP(ripemd160);
  INIT_EVP(sha224);
  INIT_EVP(sha256);
  INIT_EVP(sha384);
  INIT_EVP(sha512);
}
