#!/usr/bin/env python3

print("""static void serialize(uint8_t hash[], uintWS_t *state) {
  uintWS_t *outW = (uintWS_t *)hash;
""")

for i in range(8):
    print(f'#if HASH_STATE_WORDS > {i}')
    print(f'# if HASH_DIGEST_LENGTH >= {i+1}*(HASH_WORD_SIZE/8)')
    print(f'  outW[{i}] = htoDeWS(state[{i}]);')
    print(f'# elif HASH_DIGEST_LENGTH > {i}*(HASH_WORD_SIZE/8)')
    print(f'  uintWS_t temp = htoDeWS(state[{i}]);')
    print(f'#  if HASH_WORD_SIZE == 32')
    for j in range(4):
        p = i * 4 + j
        print(f'#   if HASH_DIGEST_LENGTH > {p}')
        print(f'  hash[{p}] = ((uint8_t *)&temp)[{j}];')
        print(f'#   endif')
    print(f'#  elif HASH_WORD_SIZE == 64')
    for j in range(8):
        p = i * 8 + j
        print(f'#   if HASH_DIGEST_LENGTH > {p}')
        print(f'  hash[{p}] = ((uint8_t *)&temp)[{j}];')
        print(f'#   endif')
    print(f'#  else')
    print(f'#   error unsupported hash word size')
    print(f'#  endif')
    print(f'# endif')
    print(f'#endif')

print('}')
'''
#if HASH_STATE_WORDS > 1
# if HASH_DIGEST_LENGTH >= 1*(HASH_WORD_SIZE/8)
  outW[0] = htoDeWS(state[0]);
# else
  temp = htoDeWS(state[0]);
#  if HASH_WORD_SIZE == 32
#   if HASH_DIGEST_LENGTH >= 1
  hash[0] = temp[0];
#   endif
#   if HASH_DIGEST_LENGTH >= 2
  hash[1] = temp[1];
#   endif
#   if HASH_DIGEST_LENGTH >= 3
  hash[2] = temp[2];
#   endif
#   if HASH_DIGEST_LENGTH >= 4
  hash[3] = temp[3];
#   endif
#  elif HASH_WORD_SIZE == 64
#   if HASH_DIGEST_LENGTH >= 1
  hash[0] = temp[0];
#   endif
#   if HASH_DIGEST_LENGTH >= 2
  hash[1] = temp[1];
#   endif
#   if HASH_DIGEST_LENGTH >= 3
  hash[2] = temp[2];
#   endif
#   if HASH_DIGEST_LENGTH >= 4
  hash[3] = temp[3];
#   endif
#   if HASH_DIGEST_LENGTH >= 5
  hash[4] = temp[4];
#   endif
#   if HASH_DIGEST_LENGTH >= 6
  hash[5] = temp[5];
#   endif
#   if HASH_DIGEST_LENGTH >= 7
  hash[6] = temp[6];
#   endif
#   if HASH_DIGEST_LENGTH >= 8
  hash[7] = temp[7];
#   endif
#  else
#   error invalid hash word size
#  endif
# endif
#endif

#if HASH_STATE_WORDS > 2
#if HASH_DIGEST_LENGTH >= 2*(HASH_WORD_SIZE/8)
  outW[1] = htoDeWS(state[1]);
#endif
#endif
#if HASH_STATE_WORDS > 3
#if HASH_DIGEST_LENGTH >= 3*(HASH_WORD_SIZE/8)
  outW[2] = htoDeWS(state[2]);
#endif
#endif
#if HASH_STATE_WORDS > 4
#if HASH_DIGEST_LENGTH >= 4*(HASH_WORD_SIZE/8)
  outW[3] = htoDeWS(state[3]);
#endif
#endif
#if HASH_STATE_WORDS > 5
#if HASH_DIGEST_LENGTH >= 5*(HASH_WORD_SIZE/8)
  outW[4] = htoDeWS(state[4]);
#endif
#endif
#if HASH_STATE_WORDS > 6
#if HASH_DIGEST_LENGTH >= 6*(HASH_WORD_SIZE/8)
  outW[5] = htoDeWS(state[5]);
#endif
#endif
#if HASH_STATE_WORDS > 7
#if HASH_DIGEST_LENGTH >= 7*(HASH_WORD_SIZE/8)
  outW[6] = htoDeWS(state[6]);
#endif
#endif
#if HASH_STATE_WORDS > 8
#if HASH_DIGEST_LENGTH >= 8*(HASH_WORD_SIZE/8)
  outW[7] = htoDeWS(state[7]);
#endif
#endif
}
'''
