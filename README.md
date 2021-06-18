# llhash
A permissively licensed, low-level, high-performance cryptographic hash
library for hackers.

The code makes extensive use of
[metaprogramming](https://en.wikipedia.org/wiki/Metaprogramming)
techniques in order to reduce repetition and shift work to compile time.

Currently under development.

## Supported Hash Functions

* MD4
* MD5
* RIPEMD160
* SHA1
* SHA2-224
* SHA2-256
* SHA2-384
* SHA2-512

## Compression Function Implementations

Many cryptographic hash functions consist of a core
[compression function](https://en.wikipedia.org/wiki/One-way_compression_function)
that does the bulk of the work plus some simple wrapper code. In llhash, the
core functions are set up so that an implementation can be chosen at run time,
depending on what CPU features are available. I’ve collected a number of
implementations and modified them to conform to a common API. With the
exception of the Intel SHA1 SSSE3 and AVX implementations (which are
GPLv2-or-later and behind a build flag), everything is under a permissive
license (BSD/MIT/Public Domain/etc).

* C ([Ryan Castellucci](https://github.com/ryancdotorg))
* x86_64 assembly
    * [CRYPTOGAMS](https://github.com/dot-asm/cryptogams)
      (SHA1, SHA2 - [Andy Polyakov](https://github.com/dot-asm))
    * [Intel/Linux](https://github.com/torvalds/linux/tree/v5.12/arch/x86/crypto)
      (SHA1, SHA2)
    * [Project Nayuki](https://www.nayuki.io/category/x86)
      (MD5, SHA1, SHA2))
    * [Ryan Castellucci](https://github.com/ryancdotorg) (MD4, MD5)

## Wrapper Code

The wrapper API has functions that are mostly compatible with OpenSSL’s legacy
hash APIs, though the CTX structures.

Where `HASH` is the name of a supported hash, the following functions are
available:

`uint8_t * HASH(const uint8_t data[], size_t len, uint8_t hash[])`

Computes hash of `len` bytes of `data[]` and stores it in `hash[]`. Returns a
pointer to `hash[]`. If `hash[]` is NULL, a static array is used. Note that
using the static array is not reentrant or thread safe.

`void HASH_Init(HASH_CTX *ctx)`

Initializes a `HASH_CTX` structure.

`void HASH_Update(HASH_CTX *ctx, const uint8_t data[], size_t len)`

Hashes `len` bytes of `data[]` with the context `ctx`. This can be used to
incrementally process an arbitrarily large message.

`void HASH_Final(uint8_t hash[], HASH_CTX *ctx)`

Computes the final hash value for the context `ctx` and writes it to `hash[]`.
Note that unlike OpenSSL’s `*_Final` functions, this one *does not* clear the
context.

`void HASH_Clear(HASH_CTX *ctx)`

Clears a `HASH_CTX` structure.

`void HASH_Clone(HASH_CTX *dst, const HASH_CTX *src)`

Copies the hash context from `src` to `dst`.

`uint64_t HASH_Pad(uint8_t data[], size_t len)`

Adds padding for `len` bytes of data to buffer `data[]`. Returns the number of
blocks after padding. Note that the caller is responsible for ensuring the
buffer is big enough.

`void HASH_Raw(uint8_t hash[], const uint8_t data[], uint64_t nblk)`

Hashes `nblk` blocks stored in `data[]` and writes the result to `hash[]`.
Note that this function does not do any padding and the length is number of
blocks, not number of bytes.

`void HASH_Extend(HASH_CTX *ctx, uint8_t hash[], uint64_t nblk)`

Reads a hash value from `hash[]` and stores the recreated state as of block
`nblk` (post padding) in `ctx`. Useful for length extension attacks, not
available for truncated hashes.
