#!/usr/bin/env python3

from sys import argv, stderr, stdout, version_info
from functools import partial
eprint = partial(print, file=stderr)

import json
import hmac
import hashlib

from os import urandom
from hashlib import md5, sha1, sha224, sha256, sha384, sha512
from binascii import hexlify, unhexlify

algos = {}
for h in ('md4', 'md5', 'ripemd160', 'sha224'):
    if h in hashlib.algorithms_available:
        algos[h] = partial(hashlib.new, h)

with open('hmac_sha256_test.json') as f:
    tests = json.load(f)
    for g in tests['testGroups']:
        t_prime = []
        for t in g['tests']:
            if t['result'] == 'valid':
                t_prime.append(t)

        g['tests'] = t_prime

for name, new in algos.items():
    digest_size = new().digest_size
    derived = json.loads(json.dumps(tests))
    derived['algorithm'] = f'HMAC{name.upper()}'
    derived['generatorVersion'] = '???'
    i = 0
    for g in derived['testGroups']:
        if g['keySize'] == 256:
            keySize = digest_size
        elif g['keySize'] == 128:
            keySize = digest_size // 2
        else:
            keySize = g['keySize'] // 8

        if g['tagSize'] == 256:
            tagSize = digest_size
        elif g['tagSize'] == 128:
            tagSize = digest_size // 2
        else:
            tagSize = g['tagSize'] // 8

        g['keySize'] = keySize * 8
        g['tagSize'] = tagSize * 8

        for t in g['tests']:
            key = urandom(keySize)
            msg = urandom(len(t['msg'])//2)
            tag = hmac.digest(key, msg, new)[0:tagSize]
            t['key'] = hexlify(key).decode('ascii')
            t['msg'] = hexlify(msg).decode('ascii')
            t['tag'] = hexlify(tag).decode('ascii')
            i += 1
            t['tcId'] = i

    derived['numberOfTests'] = i

    with open(f'hmac_{name}_test.json', 'w') as f:
        json.dump(derived, f, indent=2)
