#pragma once
#include "../../macros.h"

#if (defined(STUBBED) && !__ASSEMBLER__)
#include <stdint.h>
#include <stddef.h>
#include <signal.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
#define STUB(name) \
int JOIN(name,built)() { return 0; } \
void JOIN(name)(void *digest, const char *data, uint32_t nblk) { raise(SIGILL); }
#pragma GCC diagnostic pop
#elif __ASSEMBLER__
#ifdef __CET__
#define ENDBR64 .byte 0xf3,0x0f,0x1e,0xfa;
#else
#define ENDBR64
#endif
#if 0
#define SUM_IRD(ic, ra, rd) \
	add $ic, rd; \
	add ra, rd
#else
#define SUM_IRD(ic, ra, rd) \
	lea ic(rd,ra), rd
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
	JOIN(name,end):; \
	.size name,.-##name; \
	.data; \
	.align 8; \
	.globl JOIN(name,size); \
	JOIN(name,size):; \
	.2byte JOIN(name,end)-name; \
	.size JOIN(name,size),2

#else
#error bad build options
#endif
