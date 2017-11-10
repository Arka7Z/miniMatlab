	.file	"TEST.c"
	.globl	d
	.data
	.align 8
	.type	d, @object
	.size	d, 8
d:
	.long	1717986918
	.long	1073899110
	.globl	t00
	.data
	.align 8
	.type	t00, @object
	.size	t00, 8
t00:
	.long	1717986918
	.long	1073899110
	.globl	t01
	.data
	.align 4
	.type	t01, @object
	.size	t01, 4
t01:
	.long	2
	.globl	t02
	.data
	.align 4
	.type	t02, @object
	.size	t02, 4
t02:
	.long	3
	.globl	a
	.data
	.align 4
	.type	a, @object
	.size	a, 4
a:
	.long	4
	.globl	t03
	.data
	.align 4
	.type	t03, @object
	.size	t03, 4
t03:
	.long	4
	.comm	b,4,4
	.comm	c,1,1
	.section	.rodata
.LC0:
	.string	"Checking printFlt and Matrix initialization : "
.LC1:
	.string	"\n"
.LC2:
	.string	"The value of global double d :"
.LC3:
	.string	"\n"
.LC4:
	.string	"checking printInt and readInt:\n"
.LC5:
	.string	"Enter an integer N: "
.LC6:
	.string	"The value of N is : "
	.align 8
.LCt00:
	.long	1717986918
	.long	1073899110
	.align 8
.LCt03:
	.long	2576980378
	.long	1072798105
	.align 8
.LCt04:
	.long	3435973837
	.long	1073794252
	.align 8
.LCt05:
	.long	1717986918
	.long	1074423398
	.align 8
.LCt06:
	.long	858993459
	.long	1074475827
	.text	
	movq	.LCt00(%rip), %rax
	movq 	%rax, 0(%rbp)
	movq	0(%rbp), %rax
	movq	%rax, 0(%rbp)
	movq	%rax, d(%rip)
	movl	$2, %eax
	movl	%eax, 0(%rbp)

	movl	$3, %eax
	movl	%eax, 0(%rbp)

	movl	$4, %eax
	movl	%eax, 0(%rbp)

	movl	0(%rbp), %eax
	movl	%eax, 0(%rbp)

	movl	$2, %eax
	movl	%eax, 0(%rbp)
	movq	%rax, t00(%rip)
	movl	$2, %eax
	movl	%eax, 0(%rbp)

	.globl	main
	.type	main, @function
main: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$268, %rsp

	movq	.LCt00(%rip), %rax
	movq 	%rax, -36(%rbp)
	movq	-36(%rbp), %rax
	movq	%rax, -28(%rbp)

	movl	$2, %eax
	movl	%eax, -80(%rbp)

	movl	$2, %eax
	movl	%eax, -84(%rbp)

	movq	.LCt03(%rip), %rax
	movq 	%rax, -88(%rbp)
	movq	.LCt04(%rip), %rax
	movq 	%rax, -96(%rbp)
	movq	.LCt05(%rip), %rax
	movq 	%rax, -104(%rbp)
	movq	.LCt06(%rip), %rax
	movq 	%rax, -112(%rbp)
		movq	-88(%rbp), %rdx
	movq	%rdx, -72(%rbp)

		movq	-96(%rbp), %rdx
	movq	%rdx, -64(%rbp)

		movq	-104(%rbp), %rdx
	movq	%rdx, -56(%rbp)

		movq	-112(%rbp), %rdx
	movq	%rdx, -48(%rbp)

	movq 	$.LC0, -124(%rbp)
	movl 	-124(%rbp), %eax
	movq 	-124(%rbp), %rdi
	call	printStr
	movl	%eax, -128(%rbp)
	movl	$1, %eax
	movl	%eax, -136(%rbp)

	movl	$1, %eax
	movl	%eax, -140(%rbp)

	movl 	-136(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -148(%rbp)
	movl 	-140(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -152(%rbp)
		movl	-148(%rbp), %eax
	movl	-152(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -156(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-156(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -168(%rbp)

	movl 	-168(%rbp), %eax
	movsd 	-168(%rbp), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-168(%rbp), %rdi
	call	printFlt
	movl	%eax, -176(%rbp)
	movq 	$.LC1, -180(%rbp)
	movl 	-180(%rbp), %eax
	movq 	-180(%rbp), %rdi
	call	printStr
	movl	%eax, -184(%rbp)
	movl	$4, %eax
	movl	%eax, -192(%rbp)

	movl	-192(%rbp), %eax
	movl	%eax, -188(%rbp)

	movq 	$.LC2, -204(%rbp)
	movl 	-204(%rbp), %eax
	movq 	-204(%rbp), %rdi
	call	printStr
	movl	%eax, -208(%rbp)
	movl 	-212(%rbp), %eax
	movsd 	d(%rip), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-212(%rbp), %rdi
	call	printFlt
	movl	%eax, -216(%rbp)
	movq 	$.LC3, -220(%rbp)
	movl 	-220(%rbp), %eax
	movq 	-220(%rbp), %rdi
	call	printStr
	movl	%eax, -224(%rbp)
	movq 	$.LC4, -228(%rbp)
	movl 	-228(%rbp), %eax
	movq 	-228(%rbp), %rdi
	call	printStr
	movl	%eax, -232(%rbp)
	movq 	$.LC5, -236(%rbp)
	movl 	-236(%rbp), %eax
	movq 	-236(%rbp), %rdi
	call	printStr
	movl	%eax, -240(%rbp)
	leaq	-188(%rbp), %rax
	movq 	%rax, -248(%rbp)
	movl 	-248(%rbp), %eax
	movq 	-248(%rbp), %rdi
	call	readInt
	movl	%eax, -252(%rbp)
	movq 	$.LC6, -256(%rbp)
	movl 	-256(%rbp), %eax
	movq 	-256(%rbp), %rdi
	call	printStr
	movl	%eax, -260(%rbp)
	movl 	-188(%rbp), %eax
	movq 	-188(%rbp), %rdi
	movq 	-188(%rbp), %rdi
	call	printInt
	movl	%eax, -268(%rbp)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by Arka Pal"
	.section	.note.GNU-stack,"",@progbits
