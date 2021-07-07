#include "../../../common/built.S"
#ifdef STUBBED
STUB(sha1_dispatch_xform)
#else
.text
.extern sha1_intel_avx2_xform
.extern sha1_cryptogams_ssse3_xform
/* void sha1_dispatch_xform(uint32_t state[static 5], const uint8_t block[static 64], uint64_t nblk) */
ENTRY(sha1_dispatch_xform)
	cmp	$4, %rdx
	jle	sha1_cryptogams_ssse3_xform
	jmp	sha1_intel_avx2_xform

ENDPROC(sha1_dispatch_xform)
#endif
