#pragma once
#include "../../macros.h"

#ifdef STUBBED
#include <stdint.h>
#include <stddef.h>
#include <signal.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
#define STUB(name) \
int JOIN(name,built)() { return 0; } \
void JOIN(name)(void *digest, const char *data, uint32_t nblk) { raise(SIGILL); }
#pragma GCC diagnostic pop
#else
#ifdef __CET__
#define ENDBR64 .byte 0xf3,0x0f,0x1e,0xfa;
#else
#define ENDBR64
#endif
#if 0
#define ADD3(ra, rb, ic) \
	add ic, %ra; \
	add %rb, %ra
#else
#define ADD3(ra, rb, ic) \
	lea ic(%rb,%ra), %ra
#endif
#define ENTRY(name) \
	.align 32; \
	.globl JOIN(name,built); \
	.type JOIN(name,built), @function; \
	JOIN(name,built):; \
	ENDBR64 \
	push $1; \
	pop %rax; \
	ret; \
	.size JOIN(name,built),.-JOIN(name,built); \
	.align 32; \
	.globl name; \
	.type name, @function; \
	name:; \
	ENDBR64

#define ENDPROC(name) \
	.size name,.-##name;
#endif
