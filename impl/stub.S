#define _J(A,B) A##_##B
#define J(A,B) _J(A,B)
.text
.align 32,0x90
.globl J(FUNCPFX,built)
.type J(FUNCPFX,built), @function
J(FUNCPFX,built):
	mov $0, %eax
	ret
.size J(FUNCPFX,built),.- J(FUNCPFX,built)
.align 32,0x90
.globl J(FUNCPFX,xform)
.type J(FUNCPFX,xform), @function
J(FUNCPFX,xform):
	ud2
	ret
.size J(FUNCPFX,xform),.- J(FUNCPFX,xform)
#undef J
#undef _J
