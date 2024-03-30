#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>
#include <stdio.h>

#include <openssl/crypto.h>
#include <openssl/hmac.h>
#include <openssl/evp.h>

#include "openssl.h"
#include "macros.h"

static char *libcrypto[] = {
  "libcrypto.so.1.1",
  "libcrypto.so.1.0",
  "libcrypto.so.1",
  "libcrypto.so.3",
  "libcrypto.so",
  NULL
};

/* dynmaic function loading macro */
#define _COMPARE_void(x) x
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
  IF_NOTEQ(TYPE, void)(return) _##NAME ARGN; \
}

DLFUNC(EVP_Digest, int,
  (const void *a, size_t b, unsigned char *c, unsigned int *d, const EVP_MD *e, ENGINE *f),
  (a, b, c, d, e, f)
)

DLFUNC(EVP_DigestSignInit, int,
  (EVP_MD_CTX *a, EVP_PKEY_CTX **b, const EVP_MD *c, ENGINE *d, EVP_PKEY *e),
  (a, b, c, d, e)
)

DLFUNC(EVP_DigestUpdate, int,
  (EVP_MD_CTX *a, const void *b, size_t c),
  (a, b, c)
)

DLFUNC(EVP_DigestSignFinal, int,
  (EVP_MD_CTX *a, unsigned char *b, size_t *c),
  (a, b, c)
)

DLFUNC(EVP_DigestSign, int,
  (EVP_MD_CTX *a, unsigned char *b, size_t *c, const unsigned char *d, size_t e),
  (a, b, c, d, e)
)

DLFUNC(EVP_PKEY_new_raw_private_key, EVP_PKEY *,
  (int a, ENGINE *b, const unsigned char *c, size_t d),
  (a, b, c, d)
)

DLFUNC(EVP_MD_CTX_new, EVP_MD_CTX *,
  (),
  ()
)
DLFUNC(EVP_MD_CTX_free, void,
  (EVP_MD_CTX *a),
  (a)
)
DLFUNC(EVP_PKEY_free, void,
  (EVP_PKEY *a),
  (a)
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
} \
void OpenSSL_HMAC_##NAME ( \
  uint8_t hash[], \
  const uint8_t key[], size_t klen, \
  const uint8_t data[], size_t dlen \
) { \
  /*fprintf(stderr, "%s: %d %zu %zu %zu\n", __func__, 0, hlen, klen, dlen);*/ \
  size_t hlen = 64; \
  EVP_MD_CTX *ctx = _EVP_MD_CTX_new(); \
  EVP_PKEY *pkey = _EVP_PKEY_new_raw_private_key(EVP_PKEY_HMAC, NULL, key, klen); \
  _EVP_DigestSignInit(ctx, NULL, md_##name, NULL, pkey); \
  _EVP_DigestUpdate(ctx, data, dlen); \
  _EVP_DigestSignFinal(ctx, hash, &hlen); \
  _EVP_PKEY_free(pkey); \
  _EVP_MD_CTX_free(ctx); \
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
  INIT_EVP(sha1);
  INIT_EVP(sha224);
  INIT_EVP(sha256);
  INIT_EVP(sha384);
  INIT_EVP(sha512);
}
