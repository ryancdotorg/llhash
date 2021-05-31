# llhash
A permissively licensed, low-level, high-performance cryptographic hash
library for hackers.

Currently under development.

## Supported Hash Functions

* MD4
* MD5
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

## Wrapper Code

TODO: Write something here.
