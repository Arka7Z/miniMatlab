	.file	"TEST.c"
	.section	.rodata
.LC0:
	.string	"Enter two numbers for calculating there maximum :\n"
.LC1:
	.string	"Enter the number 1: "
.LC2:
	.string	"Enter the number 2: "
.LC3:
	.string	"Max is equal to :"
	.text	
	.globl	max
	.type	max, @function
max: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$48, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
		movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jg .L2
	jmp .L3
.L2: 
	movl	-20(%rbp), %eax
	movl	%eax, -28(%rbp)

	jmp .L4
.L3: 
	movl	-16(%rbp), %eax
	movl	%eax, -28(%rbp)

.L4: 
	movl	-28(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	max, .-max
	.globl	main
	.type	main, @function
main: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$124, %rsp

	movl	$2, %eax
	movl	%eax, -32(%rbp)

	movl	-32(%rbp), %eax
	movl	%eax, -28(%rbp)

	movq 	$.LC0, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	movq 	$.LC1, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printStr
	movl	%eax, -68(%rbp)
	leaq	-40(%rbp), %rax
	movq 	%rax, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	readInt
	movl	%eax, -80(%rbp)
	movq 	$.LC2, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	printStr
	movl	%eax, -88(%rbp)
	leaq	-44(%rbp), %rax
	movq 	%rax, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	readInt
	movl	%eax, -96(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movq 	-40(%rbp), %rdi
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rsi
	movq 	-44(%rbp), %rdi
	call	max
	movl	%eax, -104(%rbp)
	movl	-104(%rbp), %eax
	movl	%eax, -48(%rbp)

	movq 	$.LC3, -112(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	printStr
	movl	%eax, -116(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	movq 	-48(%rbp), %rdi
	call	printInt
	movl	%eax, -124(%rbp)
	movl	-28(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by Arka Pal"
	.section	.note.GNU-stack,"",@progbits
