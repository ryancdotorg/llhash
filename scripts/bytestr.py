#!/usr/bin/env python3

import sys
import hashlib

pbkdf2_sha1 = [
    (b"password", b"salt", 1, 20),
    (b"password", b"salt", 2, 20),
    (b"password", b"salt", 4096, 20),
    (b"password", b"salt", 16777216, 20),
    (b"passwordPASSWORDpassword", b"saltSALTsaltSALTsaltSALTsaltSALTsalt", 4096, 25),
    (b"pass\0word", b"sa\0lt", 1, 16),
    (b"password", b"salt", 3, 20),
    (b"hunter2", b"admin", 67108864, 64),
]

def _uchar_literal():
    n = 0
    t = {}
    def uchar_literal(b, v=None):
        nonlocal t, n
        if v is None:
            if b in t: return ('', '_v0x%04x' % t[b])
            v = '_v0x%04x' % t.setdefault(b, n)
            n += 1
        ary = '{{{}}}'.format(', '.join(map(lambda c: f'0x{c:02x}', b)))
        return (f'unsigned char {v}[] = {ary};\n', v)
    return uchar_literal

uchar_literal = _uchar_literal()

for i in range(len(pbkdf2_sha1)):
    x = pbkdf2_sha1[i]
    p, vp = uchar_literal(x[0])
    s, vs = uchar_literal(x[1])
    sys.stdout.write(p)
    sys.stdout.write(s)
    sys.stdout.flush()

print('')
print('char buf[8192];')
print('unsigned char dk[1024];')
for i in range(len(pbkdf2_sha1)):
    x = pbkdf2_sha1[i]
    p, vp = uchar_literal(x[0])
    s, vs = uchar_literal(x[1])
    dk = hashlib.pbkdf2_hmac('sha1', *x)
    print('{\n  ', end='')
    d, vd = uchar_literal(dk, f'dk{i}')
    sys.stdout.write(d)
    print(f'  printf("%s\\n", "{vd}");')
    print(f'  PBKDF2_HMAC_SHA1(dk, {x[3]}, {vp}, {len(x[0])}, {vs}, {len(x[1])}, {x[2]});')
    print(f'  if (memcmp(dk, {vd}, {x[3]}) != 0) {{')
    print(f'    printf("dk:  %s\\n", hex(buf, dk, {x[3]}, 1));')
    print(f'    printf("ref: %s\\n", hex(buf, {vd}, {x[3]}, 1));')
    print('  }')
    print('}')

for i in range(len(pbkdf2_sha1)):
    x = pbkdf2_sha1[i]
    p, vp = uchar_literal(x[0])
    s, vs = uchar_literal(x[1])
    dk = hashlib.pbkdf2_hmac('md5', *x)
    print('{\n  ', end='')
    d, vd = uchar_literal(dk, f'dk{i}')
    sys.stdout.write(d)
    print(f'  printf("%s\\n", "{vd}");')
    print(f'  PBKDF2_HMAC_MD5(dk, {x[3]}, {vp}, {len(x[0])}, {vs}, {len(x[1])}, {x[2]});')
    print(f'  if (memcmp(dk, {vd}, {x[3]}) != 0) {{')
    print(f'    printf("dk:  %s\\n", hex(buf, dk, {x[3]}, 1));')
    print(f'    printf("ref: %s\\n", hex(buf, {vd}, {x[3]}, 1));')
    print('  }')
    print('}')

for i in range(len(pbkdf2_sha1)):
    x = pbkdf2_sha1[i]
    p, vp = uchar_literal(x[0])
    s, vs = uchar_literal(x[1])
    dk = hashlib.pbkdf2_hmac('sha512', *x)
    print('{\n  ', end='')
    d, vd = uchar_literal(dk, f'dk{i}')
    sys.stdout.write(d)
    print(f'  printf("%s\\n", "{vd}");')
    print(f'  PBKDF2_HMAC_SHA2_512(dk, {x[3]}, {vp}, {len(x[0])}, {vs}, {len(x[1])}, {x[2]});')
    print(f'  if (memcmp(dk, {vd}, {x[3]}) != 0) {{')
    print(f'    printf("dk:  %s\\n", hex(buf, dk, {x[3]}, 1));')
    print(f'    printf("ref: %s\\n", hex(buf, {vd}, {x[3]}, 1));')
    print('  }')
    print('}')
