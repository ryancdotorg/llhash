#define ENTRY(name) \
	.align 32,0x90; \
	.globl name; \
	.type name, @function; \
	name:

#define ENDPROC(name) \
	.size name,.-##name; \

#define _J(A,B) A##_##B
#define J(A,B) _J(A,B)
.align 32,0x90
.globl J(FUNCPFX,built)
.type J(FUNCPFX,built), @function
J(FUNCPFX,built):
	mov $1, %eax
	ret
.size J(FUNCPFX,built),.- J(FUNCPFX,built)
#undef J
#undef _J
