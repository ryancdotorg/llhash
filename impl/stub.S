#define _J(A,B) A##_##B
#define J(A,B) _J(A,B)
.text
.align 32,0x90
.globl J(FUNCPFX,built)
J(FUNCPFX,built):
	mov $0, %eax
	ret
.type J(FUNCPFX,built), @function
.align 32,0x90
.globl J(FUNCPFX,xform)
J(FUNCPFX,xform):
	ud2
	ret
.type J(FUNCPFX,xform), @function
#undef J
#undef _J
