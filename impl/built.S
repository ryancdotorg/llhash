#define ENTRY(name) \
        .align 32,0x90; \
        .globl name; \
        name:

#define ENDPROC(name) \
        .type name, @function; \

#define _J(A,B) A##_##B
#define J(A,B) _J(A,B)
.align 32,0x90
.globl J(FUNCPFX,built)
J(FUNCPFX,built):
	mov $1, %eax
	ret
.type J(FUNCPFX,built), @function
#undef J
#undef _J
