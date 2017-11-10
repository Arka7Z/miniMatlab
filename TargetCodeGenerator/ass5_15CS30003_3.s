	.file	"TEST.c"
	.section	.rodata
.LC0:
	.string	"The fibonacci number is : "
.LC1:
	.string	"Enter the i for finding its fibonacci number : "
.LC2:
	.string	"You Entered : "
.LC3:
	.string	"Returned from the fib function which uses a for loop for calculation"
	.text	
	.globl	fib
	.type	fib, @function
fib: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$116, %rsp
	movq	%rdi, -20(%rbp)
	movl	$1, %eax
	movl	%eax, -32(%rbp)

	movl	-32(%rbp), %eax
	movl	%eax, -28(%rbp)

	movl	$0, %eax
	movl	%eax, -40(%rbp)

	movl	-40(%rbp), %eax
	movl	%eax, -36(%rbp)

	movl	$1, %eax
	movl	%eax, -48(%rbp)

	movl	-48(%rbp), %eax
	movl	%eax, -44(%rbp)

.L2: 
		movl	-44(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl .L3
	jmp .L4
.L3: 
	movl	-28(%rbp), %eax
	movl	%eax, -52(%rbp)

		movl	-28(%rbp), %eax
	movl	-36(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -68(%rbp)

	movl	-68(%rbp), %eax
	movl	%eax, -28(%rbp)

	movl	-52(%rbp), %eax
	movl	%eax, -36(%rbp)

	movl	$1, %eax
	movl	%eax, -80(%rbp)

		movl	-44(%rbp), %eax
	movl	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -88(%rbp)

	movl	-88(%rbp), %eax
	movl	%eax, -44(%rbp)

	jmp .L2
.L4: 
	movq 	$.LC0, -100(%rbp)
	movl 	-100(%rbp), %eax
	movq 	-100(%rbp), %rdi
	call	printStr
	movl	%eax, -104(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -112(%rbp)
	movl	-28(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	fib, .-fib
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
	subq	$96, %rsp

	movq 	$.LC1, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printStr
	movl	%eax, -36(%rbp)
	leaq	-40(%rbp), %rax
	movq 	%rax, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	readInt
	movl	%eax, -56(%rbp)
	movq 	$.LC2, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -72(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movq 	-40(%rbp), %rdi
	call	fib
	movl	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl	%eax, -76(%rbp)

	movq 	$.LC3, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by Arka Pal"
	.section	.note.GNU-stack,"",@progbits
