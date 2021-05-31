#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>

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
static TYPE _load_##NAME ARGS { \
  int i = 0; \
  char *filename; \
  void *handle = NULL; \
  while (handle == NULL && (filename = libcrypto[i++]) != NULL) { \
    handle = dlopen(filename, RTLD_LAZY); \
  } \
  _##NAME = dlsym(handle, #NAME); \
  return _##NAME ARGN; \
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
DLFUNC(EVP_Digest, int,
  (const void *a, size_t b, unsigned char *c, unsigned int *d, const EVP_MD *e, ENGINE *f),
  (a, b, c, d, e, f)
)

DLFUNC(EVP_md4, const EVP_MD *, (), ())
DLFUNC(EVP_md5, const EVP_MD *, (), ())
DLFUNC(EVP_ripemd160, const EVP_MD *, (), ())
DLFUNC(EVP_sha1, const EVP_MD *, (), ())
DLFUNC(EVP_sha224, const EVP_MD *, (), ())
DLFUNC(EVP_sha256, const EVP_MD *, (), ())
DLFUNC(EVP_sha384, const EVP_MD *, (), ())
DLFUNC(EVP_sha512, const EVP_MD *, (), ())
#pragma GCC diagnostic pop

static const EVP_MD *md_md4, *md_md5, *md_ripemd160, *md_sha1;
static const EVP_MD *md_sha224, *md_sha256, *md_sha384, *md_sha512;

static __attribute__((constructor)) void getmd() {
  md_md4 = _EVP_md4();
  md_md5 = _EVP_md5();
  md_ripemd160 = _EVP_ripemd160();
  md_sha1 = _EVP_sha1();
  md_sha224 = _EVP_sha224();
  md_sha256 = _EVP_sha256();
  md_sha384 = _EVP_sha384();
  md_sha512 = _EVP_sha512();
}

#define OPENSSL_DIGEST(NAME, name) \
void OpenSSL_##NAME (uint8_t hash[], const uint8_t data[], size_t len) { \
  _EVP_Digest(data, len, hash, NULL, md_##name, NULL); \
}

OPENSSL_DIGEST(MD4, md4)
OPENSSL_DIGEST(MD5, md5)
OPENSSL_DIGEST(RIPEMD160, ripemd160)
OPENSSL_DIGEST(SHA1, sha1)
OPENSSL_DIGEST(SHA2_224, sha224)
OPENSSL_DIGEST(SHA2_256, sha256)
OPENSSL_DIGEST(SHA2_384, sha384)
OPENSSL_DIGEST(SHA2_512, sha512)
