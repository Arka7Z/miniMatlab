	.file	"TEST.c"
	.section	.rodata
.LC0:
	.string	"the test file for testing some of matrix operations\n\n"
.LC1:
	.string	"What is being done is we declared the matrix m and assigned it to a new matrix y as y=m\n"
.LC2:
	.string	"Printing y in row major order\n"
.LC3:
	.string	"Now let us square y as in y=y*y\n"
.LC4:
	.string	"Printing y in row major order\n"
	.align 8
.LCt05:
	.long	3435973837
	.long	1073007820
	.align 8
.LCt06:
	.long	1717986918
	.long	1073112678
	.align 8
.LCt07:
	.long	0
	.long	1073217536
	.align 8
.LCt08:
	.long	3435973837
	.long	1073794252
	.text	
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
	subq	$1772, %rsp

	movq 	$.LC0, -28(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printStr
	movl	%eax, -32(%rbp)
	movl	$0, %eax
	movl	%eax, -40(%rbp)

	movl	-40(%rbp), %eax
	movl	%eax, -36(%rbp)

	movl	$2, %eax
	movl	%eax, -80(%rbp)

	movl	$2, %eax
	movl	%eax, -84(%rbp)

	movq	.LCt05(%rip), %rax
	movq 	%rax, -88(%rbp)
	movq	.LCt06(%rip), %rax
	movq 	%rax, -96(%rbp)
	movq	.LCt07(%rip), %rax
	movq 	%rax, -104(%rbp)
	movq	.LCt08(%rip), %rax
	movq 	%rax, -112(%rbp)
		movq	-88(%rbp), %rdx
	movq	%rdx, -72(%rbp)

		movq	-96(%rbp), %rdx
	movq	%rdx, -64(%rbp)

		movq	-104(%rbp), %rdx
	movq	%rdx, -56(%rbp)

		movq	-112(%rbp), %rdx
	movq	%rdx, -48(%rbp)

	movl	$2, %eax
	movl	%eax, -152(%rbp)

	movl	$2, %eax
	movl	%eax, -156(%rbp)

	movl	$2, %eax
	movl	%eax, -192(%rbp)

	movl	$2, %eax
	movl	%eax, -196(%rbp)

	movq 	$.LC1, -200(%rbp)
	movl 	-200(%rbp), %eax
	movq 	-200(%rbp), %rdi
	call	printStr
	movl	%eax, -204(%rbp)
	movl	$0, %eax
	movl	%eax, -232(%rbp)

	movl	$0, %eax
	movl	%eax, -236(%rbp)

	movl 	-232(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -240(%rbp)
	movl 	-236(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -244(%rbp)
		movl	-240(%rbp), %eax
	movl	-244(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -248(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-248(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -224(%rbp)

	movl	$0, %eax
	movl	%eax, -276(%rbp)

	movl	$1, %eax
	movl	%eax, -280(%rbp)

	movl 	-276(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -284(%rbp)
	movl 	-280(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -288(%rbp)
		movl	-284(%rbp), %eax
	movl	-288(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -292(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-292(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -268(%rbp)

	movl	$1, %eax
	movl	%eax, -320(%rbp)

	movl	$0, %eax
	movl	%eax, -324(%rbp)

	movl 	-320(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -328(%rbp)
	movl 	-324(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -332(%rbp)
		movl	-328(%rbp), %eax
	movl	-332(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -336(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-336(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -312(%rbp)

	movl	$1, %eax
	movl	%eax, -364(%rbp)

	movl	$1, %eax
	movl	%eax, -368(%rbp)

	movl 	-364(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -372(%rbp)
	movl 	-368(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -376(%rbp)
		movl	-372(%rbp), %eax
	movl	-376(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -380(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-380(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -356(%rbp)

		movq	-72(%rbp), %rax
	movq	%rax, -144(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -136(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -128(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -120(%rbp)

	movl	$0, %eax
	movl	%eax, -416(%rbp)

	movl	$0, %eax
	movl	%eax, -420(%rbp)

	movl 	-416(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -424(%rbp)
	movl 	-420(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -428(%rbp)
		movl	-424(%rbp), %eax
	movl	-428(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -432(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-432(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -408(%rbp)

	movl	$0, %eax
	movl	%eax, -460(%rbp)

	movl	$1, %eax
	movl	%eax, -464(%rbp)

	movl 	-460(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -468(%rbp)
	movl 	-464(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -472(%rbp)
		movl	-468(%rbp), %eax
	movl	-472(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -476(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-476(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -452(%rbp)

	movl	$1, %eax
	movl	%eax, -504(%rbp)

	movl	$0, %eax
	movl	%eax, -508(%rbp)

	movl 	-504(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -512(%rbp)
	movl 	-508(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -516(%rbp)
		movl	-512(%rbp), %eax
	movl	-516(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -520(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-520(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -496(%rbp)

	movl	$1, %eax
	movl	%eax, -548(%rbp)

	movl	$1, %eax
	movl	%eax, -552(%rbp)

	movl 	-548(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -556(%rbp)
	movl 	-552(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -560(%rbp)
		movl	-556(%rbp), %eax
	movl	-560(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -564(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-564(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -540(%rbp)

		movq	-72(%rbp), %rax
	movq	%rax, -184(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -176(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -168(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -160(%rbp)

	movq 	$.LC2, -576(%rbp)
	movl 	-576(%rbp), %eax
	movq 	-576(%rbp), %rdi
	call	printStr
	movl	%eax, -580(%rbp)
	movl	$0, %eax
	movl	%eax, -584(%rbp)

	movl	-584(%rbp), %eax
	movl	%eax, -44(%rbp)

	movl	$0, %eax
	movl	%eax, -588(%rbp)

	movl	-588(%rbp), %eax
	movl	%eax, -36(%rbp)

.L2: 
	movl	$2, %eax
	movl	%eax, -596(%rbp)

		movl	-36(%rbp), %eax
	cmpl	-596(%rbp), %eax
	jl .L4
	jmp .L8
.L3: 
	movl	-36(%rbp), %eax
	movl	%eax, -604(%rbp)

	addl 	$1, -36(%rbp)
	jmp .L2
.L4: 
	movl	$0, %eax
	movl	%eax, -608(%rbp)

	movl	-608(%rbp), %eax
	movl	%eax, -44(%rbp)

.L5: 
	movl	$2, %eax
	movl	%eax, -616(%rbp)

		movl	-44(%rbp), %eax
	cmpl	-616(%rbp), %eax
	jl .L7
	jmp .L3
.L6: 
	movl	-44(%rbp), %eax
	movl	%eax, -624(%rbp)

	addl 	$1, -44(%rbp)
	jmp .L5
.L7: 
	movl 	-36(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -636(%rbp)
	movl 	-44(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -640(%rbp)
		movl	-636(%rbp), %eax
	movl	-640(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -644(%rbp)

	leaq	-144(%rbp), %rdx
	movl	-644(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -656(%rbp)

	movl 	-656(%rbp), %eax
	movsd 	-656(%rbp), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-656(%rbp), %rdi
	call	printFlt
	movl	%eax, -664(%rbp)
	jmp .L6
	jmp .L3
.L8: 
	movq 	$.LC3, -668(%rbp)
	movl 	-668(%rbp), %eax
	movq 	-668(%rbp), %rdi
	call	printStr
	movl	%eax, -672(%rbp)
	movl	$0, %eax
	movl	%eax, -700(%rbp)

	movl	$0, %eax
	movl	%eax, -704(%rbp)

	movl 	-700(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -708(%rbp)
	movl 	-704(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -712(%rbp)
		movl	-708(%rbp), %eax
	movl	-712(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -716(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-716(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -692(%rbp)

	movl	$0, %eax
	movl	%eax, -744(%rbp)

	movl	$1, %eax
	movl	%eax, -748(%rbp)

	movl 	-744(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -752(%rbp)
	movl 	-748(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -756(%rbp)
		movl	-752(%rbp), %eax
	movl	-756(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -760(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-760(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -736(%rbp)

	movl	$1, %eax
	movl	%eax, -788(%rbp)

	movl	$0, %eax
	movl	%eax, -792(%rbp)

	movl 	-788(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -796(%rbp)
	movl 	-792(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -800(%rbp)
		movl	-796(%rbp), %eax
	movl	-800(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -804(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-804(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -780(%rbp)

	movl	$1, %eax
	movl	%eax, -832(%rbp)

	movl	$1, %eax
	movl	%eax, -836(%rbp)

	movl 	-832(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -840(%rbp)
	movl 	-836(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -844(%rbp)
		movl	-840(%rbp), %eax
	movl	-844(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -848(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-848(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -824(%rbp)

	movl	$0, %eax
	movl	%eax, -876(%rbp)

	movl	$0, %eax
	movl	%eax, -880(%rbp)

	movl 	-876(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -884(%rbp)
	movl 	-880(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -888(%rbp)
		movl	-884(%rbp), %eax
	movl	-888(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -892(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-892(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -904(%rbp)

	movl	$0, %eax
	movl	%eax, -920(%rbp)

	movl	$0, %eax
	movl	%eax, -924(%rbp)

	movl 	-920(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -928(%rbp)
	movl 	-924(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -932(%rbp)
		movl	-928(%rbp), %eax
	movl	-932(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -936(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-936(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -912(%rbp)

		movsd	-904(%rbp), %xmm0
	movsd	-912(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -948(%rbp)

		movsd	-868(%rbp), %xmm0
	movsd	-948(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -868(%rbp)

	movl	$0, %eax
	movl	%eax, -956(%rbp)

	movl	$1, %eax
	movl	%eax, -960(%rbp)

	movl 	-956(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -964(%rbp)
	movl 	-960(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -968(%rbp)
		movl	-964(%rbp), %eax
	movl	-968(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -972(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-972(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -984(%rbp)

	movl	$1, %eax
	movl	%eax, -1000(%rbp)

	movl	$0, %eax
	movl	%eax, -1004(%rbp)

	movl 	-1000(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1008(%rbp)
	movl 	-1004(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1012(%rbp)
		movl	-1008(%rbp), %eax
	movl	-1012(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1016(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1016(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -992(%rbp)

		movsd	-984(%rbp), %xmm0
	movsd	-992(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1028(%rbp)

		movsd	-868(%rbp), %xmm0
	movsd	-1028(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -868(%rbp)

	movl	$0, %eax
	movl	%eax, -1044(%rbp)

	movl	$0, %eax
	movl	%eax, -1048(%rbp)

	movl 	-1044(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1052(%rbp)
	movl 	-1048(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1056(%rbp)
		movl	-1052(%rbp), %eax
	movl	-1056(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1060(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1060(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1072(%rbp)

	movl	$0, %eax
	movl	%eax, -1088(%rbp)

	movl	$1, %eax
	movl	%eax, -1092(%rbp)

	movl 	-1088(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1096(%rbp)
	movl 	-1092(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1100(%rbp)
		movl	-1096(%rbp), %eax
	movl	-1100(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1104(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1104(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1080(%rbp)

		movsd	-1072(%rbp), %xmm0
	movsd	-1080(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1116(%rbp)

		movsd	-1036(%rbp), %xmm0
	movsd	-1116(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1036(%rbp)

	movl	$0, %eax
	movl	%eax, -1124(%rbp)

	movl	$1, %eax
	movl	%eax, -1128(%rbp)

	movl 	-1124(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1132(%rbp)
	movl 	-1128(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1136(%rbp)
		movl	-1132(%rbp), %eax
	movl	-1136(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1140(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1140(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1152(%rbp)

	movl	$1, %eax
	movl	%eax, -1168(%rbp)

	movl	$1, %eax
	movl	%eax, -1172(%rbp)

	movl 	-1168(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1176(%rbp)
	movl 	-1172(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1180(%rbp)
		movl	-1176(%rbp), %eax
	movl	-1180(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1184(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1184(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1160(%rbp)

		movsd	-1152(%rbp), %xmm0
	movsd	-1160(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1196(%rbp)

		movsd	-1036(%rbp), %xmm0
	movsd	-1196(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1036(%rbp)

	movl	$1, %eax
	movl	%eax, -1212(%rbp)

	movl	$0, %eax
	movl	%eax, -1216(%rbp)

	movl 	-1212(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1220(%rbp)
	movl 	-1216(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1224(%rbp)
		movl	-1220(%rbp), %eax
	movl	-1224(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1228(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1228(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1240(%rbp)

	movl	$0, %eax
	movl	%eax, -1256(%rbp)

	movl	$0, %eax
	movl	%eax, -1260(%rbp)

	movl 	-1256(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1264(%rbp)
	movl 	-1260(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1268(%rbp)
		movl	-1264(%rbp), %eax
	movl	-1268(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1272(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1272(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1248(%rbp)

		movsd	-1240(%rbp), %xmm0
	movsd	-1248(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1284(%rbp)

		movsd	-1204(%rbp), %xmm0
	movsd	-1284(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1204(%rbp)

	movl	$1, %eax
	movl	%eax, -1292(%rbp)

	movl	$1, %eax
	movl	%eax, -1296(%rbp)

	movl 	-1292(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1300(%rbp)
	movl 	-1296(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1304(%rbp)
		movl	-1300(%rbp), %eax
	movl	-1304(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1308(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1308(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1320(%rbp)

	movl	$1, %eax
	movl	%eax, -1336(%rbp)

	movl	$0, %eax
	movl	%eax, -1340(%rbp)

	movl 	-1336(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1344(%rbp)
	movl 	-1340(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1348(%rbp)
		movl	-1344(%rbp), %eax
	movl	-1348(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1352(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1352(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1328(%rbp)

		movsd	-1320(%rbp), %xmm0
	movsd	-1328(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1364(%rbp)

		movsd	-1204(%rbp), %xmm0
	movsd	-1364(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1204(%rbp)

	movl	$1, %eax
	movl	%eax, -1380(%rbp)

	movl	$0, %eax
	movl	%eax, -1384(%rbp)

	movl 	-1380(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1388(%rbp)
	movl 	-1384(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1392(%rbp)
		movl	-1388(%rbp), %eax
	movl	-1392(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1396(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1396(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1408(%rbp)

	movl	$0, %eax
	movl	%eax, -1424(%rbp)

	movl	$1, %eax
	movl	%eax, -1428(%rbp)

	movl 	-1424(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1432(%rbp)
	movl 	-1428(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1436(%rbp)
		movl	-1432(%rbp), %eax
	movl	-1436(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1440(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1440(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1416(%rbp)

		movsd	-1408(%rbp), %xmm0
	movsd	-1416(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1452(%rbp)

		movsd	-1372(%rbp), %xmm0
	movsd	-1452(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1372(%rbp)

	movl	$1, %eax
	movl	%eax, -1460(%rbp)

	movl	$1, %eax
	movl	%eax, -1464(%rbp)

	movl 	-1460(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1468(%rbp)
	movl 	-1464(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1472(%rbp)
		movl	-1468(%rbp), %eax
	movl	-1472(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1476(%rbp)

	leaq	-184(%rbp), %rdx
	movl	-1476(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1488(%rbp)

	movl	$1, %eax
	movl	%eax, -1504(%rbp)

	movl	$1, %eax
	movl	%eax, -1508(%rbp)

	movl 	-1504(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1512(%rbp)
	movl 	-1508(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1516(%rbp)
		movl	-1512(%rbp), %eax
	movl	-1516(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1520(%rbp)

	leaq	-72(%rbp), %rdx
	movl	-1520(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1496(%rbp)

		movsd	-1488(%rbp), %xmm0
	movsd	-1496(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -1532(%rbp)

		movsd	-1372(%rbp), %xmm0
	movsd	-1532(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -1372(%rbp)

	movq	-868(%rbp), %rax
	movq	%rax, -1540(%rbp)

	movl	$0, %eax
	movl	%eax, -1548(%rbp)

	movl	$0, %eax
	movl	%eax, -1552(%rbp)

	movl 	-1548(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1556(%rbp)
	movl 	-1552(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1560(%rbp)
		movl	-1556(%rbp), %eax
	movl	-1560(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1564(%rbp)

	movl	-1564(%rbp), %eax
	leaq	-144(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1540(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1036(%rbp), %rax
	movq	%rax, -1576(%rbp)

	movl	$0, %eax
	movl	%eax, -1584(%rbp)

	movl	$1, %eax
	movl	%eax, -1588(%rbp)

	movl 	-1584(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1592(%rbp)
	movl 	-1588(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1596(%rbp)
		movl	-1592(%rbp), %eax
	movl	-1596(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1600(%rbp)

	movl	-1600(%rbp), %eax
	leaq	-144(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1576(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1204(%rbp), %rax
	movq	%rax, -1612(%rbp)

	movl	$1, %eax
	movl	%eax, -1620(%rbp)

	movl	$0, %eax
	movl	%eax, -1624(%rbp)

	movl 	-1620(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1628(%rbp)
	movl 	-1624(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1632(%rbp)
		movl	-1628(%rbp), %eax
	movl	-1632(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1636(%rbp)

	movl	-1636(%rbp), %eax
	leaq	-144(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1612(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1372(%rbp), %rax
	movq	%rax, -1648(%rbp)

	movl	$1, %eax
	movl	%eax, -1656(%rbp)

	movl	$1, %eax
	movl	%eax, -1660(%rbp)

	movl 	-1656(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1664(%rbp)
	movl 	-1660(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1668(%rbp)
		movl	-1664(%rbp), %eax
	movl	-1668(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1672(%rbp)

	movl	-1672(%rbp), %eax
	leaq	-144(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1648(%rbp), %rdx
	movq	%rdx, (%rax)

	movq 	$.LC4, -1684(%rbp)
	movl 	-1684(%rbp), %eax
	movq 	-1684(%rbp), %rdi
	call	printStr
	movl	%eax, -1688(%rbp)
	movl	$0, %eax
	movl	%eax, -1700(%rbp)

	movl	-1700(%rbp), %eax
	movl	%eax, -36(%rbp)

.L9: 
	movl	$2, %eax
	movl	%eax, -1708(%rbp)

		movl	-36(%rbp), %eax
	cmpl	-1708(%rbp), %eax
	jl .L11
	jmp .L15
.L10: 
	movl	-36(%rbp), %eax
	movl	%eax, -1716(%rbp)

	addl 	$1, -36(%rbp)
	jmp .L9
.L11: 
	movl	$0, %eax
	movl	%eax, -1720(%rbp)

	movl	-1720(%rbp), %eax
	movl	%eax, -44(%rbp)

.L12: 
	movl	$2, %eax
	movl	%eax, -1728(%rbp)

		movl	-44(%rbp), %eax
	cmpl	-1728(%rbp), %eax
	jl .L14
	jmp .L10
.L13: 
	movl	-44(%rbp), %eax
	movl	%eax, -1736(%rbp)

	addl 	$1, -44(%rbp)
	jmp .L12
.L14: 
	movl 	-36(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1744(%rbp)
	movl 	-44(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1748(%rbp)
		movl	-1744(%rbp), %eax
	movl	-1748(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1752(%rbp)

	leaq	-144(%rbp), %rdx
	movl	-1752(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1764(%rbp)

	movl 	-1764(%rbp), %eax
	movsd 	-1764(%rbp), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-1764(%rbp), %rdi
	call	printFlt
	movl	%eax, -1772(%rbp)
	jmp .L13
	jmp .L10
.L15: 
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by Arka Pal"
	.section	.note.GNU-stack,"",@progbits
