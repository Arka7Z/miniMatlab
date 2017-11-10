	.file	"TEST.c"
	.section	.rodata
.LC0:
	.string	"the test file for testing some of matrix  initialization and readflt and printflt\n\n"
.LC1:
	.string	"Matrix addition demo\n"
.LC2:
	.string	"Matrix subtraction demo\n"
	.align 8
.LCt04:
	.long	0
	.long	1073741824
	.align 8
.LCt05:
	.long	3435973837
	.long	1073007820
	.align 8
.LCt06:
	.long	858993459
	.long	1074475827
	.align 8
.LCt07:
	.long	0
	.long	1075183616
	.align 8
.LCt10:
	.long	0
	.long	1072693248
	.align 8
.LCt11:
	.long	1717986918
	.long	1073899110
	.align 8
.LCt12:
	.long	858993459
	.long	1074475827
	.align 8
.LCt13:
	.long	0
	.long	1074921472
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
	subq	$2120, %rsp

	movq 	$.LC0, -28(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printStr
	movl	%eax, -32(%rbp)
	movl	$2, %eax
	movl	%eax, -76(%rbp)

	movl	$2, %eax
	movl	%eax, -80(%rbp)

	movq	.LCt04(%rip), %rax
	movq 	%rax, -84(%rbp)
	movq	.LCt05(%rip), %rax
	movq 	%rax, -92(%rbp)
	movq	.LCt06(%rip), %rax
	movq 	%rax, -100(%rbp)
	movq	.LCt07(%rip), %rax
	movq 	%rax, -108(%rbp)
		movq	-84(%rbp), %rdx
	movq	%rdx, -68(%rbp)

		movq	-92(%rbp), %rdx
	movq	%rdx, -60(%rbp)

		movq	-100(%rbp), %rdx
	movq	%rdx, -52(%rbp)

		movq	-108(%rbp), %rdx
	movq	%rdx, -44(%rbp)

	movl	$2, %eax
	movl	%eax, -148(%rbp)

	movl	$2, %eax
	movl	%eax, -152(%rbp)

	movq	.LCt10(%rip), %rax
	movq 	%rax, -156(%rbp)
	movq	.LCt11(%rip), %rax
	movq 	%rax, -164(%rbp)
	movq	.LCt12(%rip), %rax
	movq 	%rax, -172(%rbp)
	movq	.LCt13(%rip), %rax
	movq 	%rax, -180(%rbp)
		movq	-156(%rbp), %rdx
	movq	%rdx, -140(%rbp)

		movq	-164(%rbp), %rdx
	movq	%rdx, -132(%rbp)

		movq	-172(%rbp), %rdx
	movq	%rdx, -124(%rbp)

		movq	-180(%rbp), %rdx
	movq	%rdx, -116(%rbp)

	movl	$2, %eax
	movl	%eax, -220(%rbp)

	movl	$2, %eax
	movl	%eax, -224(%rbp)

	movl	$2, %eax
	movl	%eax, -260(%rbp)

	movl	$2, %eax
	movl	%eax, -264(%rbp)

	movl	$0, %eax
	movl	%eax, -292(%rbp)

	movl	$0, %eax
	movl	%eax, -296(%rbp)

	movl 	-292(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -300(%rbp)
	movl 	-296(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -304(%rbp)
		movl	-300(%rbp), %eax
	movl	-304(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -308(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-308(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -284(%rbp)

	movl	$0, %eax
	movl	%eax, -336(%rbp)

	movl	$1, %eax
	movl	%eax, -340(%rbp)

	movl 	-336(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -344(%rbp)
	movl 	-340(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -348(%rbp)
		movl	-344(%rbp), %eax
	movl	-348(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -352(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-352(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -328(%rbp)

	movl	$1, %eax
	movl	%eax, -380(%rbp)

	movl	$0, %eax
	movl	%eax, -384(%rbp)

	movl 	-380(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -388(%rbp)
	movl 	-384(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -392(%rbp)
		movl	-388(%rbp), %eax
	movl	-392(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -396(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-396(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -372(%rbp)

	movl	$1, %eax
	movl	%eax, -424(%rbp)

	movl	$1, %eax
	movl	%eax, -428(%rbp)

	movl 	-424(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -432(%rbp)
	movl 	-428(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -436(%rbp)
		movl	-432(%rbp), %eax
	movl	-436(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -440(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-440(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -416(%rbp)

	movl	$0, %eax
	movl	%eax, -476(%rbp)

	movl	$0, %eax
	movl	%eax, -480(%rbp)

	movl 	-476(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -484(%rbp)
	movl 	-480(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -488(%rbp)
		movl	-484(%rbp), %eax
	movl	-488(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -492(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-492(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -468(%rbp)

	movl	$0, %eax
	movl	%eax, -520(%rbp)

	movl	$1, %eax
	movl	%eax, -524(%rbp)

	movl 	-520(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -528(%rbp)
	movl 	-524(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -532(%rbp)
		movl	-528(%rbp), %eax
	movl	-532(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -536(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-536(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -512(%rbp)

	movl	$1, %eax
	movl	%eax, -564(%rbp)

	movl	$0, %eax
	movl	%eax, -568(%rbp)

	movl 	-564(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -572(%rbp)
	movl 	-568(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -576(%rbp)
		movl	-572(%rbp), %eax
	movl	-576(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -580(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-580(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -556(%rbp)

	movl	$1, %eax
	movl	%eax, -608(%rbp)

	movl	$1, %eax
	movl	%eax, -612(%rbp)

	movl 	-608(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -616(%rbp)
	movl 	-612(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -620(%rbp)
		movl	-616(%rbp), %eax
	movl	-620(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -624(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-624(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -600(%rbp)

	movl	$0, %eax
	movl	%eax, -644(%rbp)

	movl	$0, %eax
	movl	%eax, -648(%rbp)

	movl 	-644(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -652(%rbp)
	movl 	-648(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -656(%rbp)
		movl	-652(%rbp), %eax
	movl	-656(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -660(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-660(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -672(%rbp)

	movl	$0, %eax
	movl	%eax, -688(%rbp)

	movl	$0, %eax
	movl	%eax, -692(%rbp)

	movl 	-688(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -696(%rbp)
	movl 	-692(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -700(%rbp)
		movl	-696(%rbp), %eax
	movl	-700(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -704(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-704(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -680(%rbp)

		movsd	-672(%rbp), %xmm0
	movsd	-680(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -716(%rbp)

	movl	$0, %eax
	movl	%eax, -724(%rbp)

	movl	$1, %eax
	movl	%eax, -728(%rbp)

	movl 	-724(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -732(%rbp)
	movl 	-728(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -736(%rbp)
		movl	-732(%rbp), %eax
	movl	-736(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -740(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-740(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -752(%rbp)

	movl	$0, %eax
	movl	%eax, -768(%rbp)

	movl	$1, %eax
	movl	%eax, -772(%rbp)

	movl 	-768(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -776(%rbp)
	movl 	-772(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -780(%rbp)
		movl	-776(%rbp), %eax
	movl	-780(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -784(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-784(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -760(%rbp)

		movsd	-752(%rbp), %xmm0
	movsd	-760(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -796(%rbp)

	movl	$1, %eax
	movl	%eax, -804(%rbp)

	movl	$0, %eax
	movl	%eax, -808(%rbp)

	movl 	-804(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -812(%rbp)
	movl 	-808(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -816(%rbp)
		movl	-812(%rbp), %eax
	movl	-816(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -820(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-820(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -832(%rbp)

	movl	$1, %eax
	movl	%eax, -848(%rbp)

	movl	$0, %eax
	movl	%eax, -852(%rbp)

	movl 	-848(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -856(%rbp)
	movl 	-852(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -860(%rbp)
		movl	-856(%rbp), %eax
	movl	-860(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -864(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-864(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -840(%rbp)

		movsd	-832(%rbp), %xmm0
	movsd	-840(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -876(%rbp)

	movl	$1, %eax
	movl	%eax, -884(%rbp)

	movl	$1, %eax
	movl	%eax, -888(%rbp)

	movl 	-884(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -892(%rbp)
	movl 	-888(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -896(%rbp)
		movl	-892(%rbp), %eax
	movl	-896(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -900(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-900(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -912(%rbp)

	movl	$1, %eax
	movl	%eax, -928(%rbp)

	movl	$1, %eax
	movl	%eax, -932(%rbp)

	movl 	-928(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -936(%rbp)
	movl 	-932(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -940(%rbp)
		movl	-936(%rbp), %eax
	movl	-940(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -944(%rbp)

	leaq	-68(%rbp), %rdx
	movl	-944(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -920(%rbp)

		movsd	-912(%rbp), %xmm0
	movsd	-920(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	%xmm1, -956(%rbp)

	movq	-716(%rbp), %rax
	movq	%rax, -964(%rbp)

	movl	$0, %eax
	movl	%eax, -972(%rbp)

	movl	$0, %eax
	movl	%eax, -976(%rbp)

	movl 	-972(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -980(%rbp)
	movl 	-976(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -984(%rbp)
		movl	-980(%rbp), %eax
	movl	-984(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -988(%rbp)

	movl	-988(%rbp), %eax
	leaq	-212(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-964(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-796(%rbp), %rax
	movq	%rax, -1000(%rbp)

	movl	$0, %eax
	movl	%eax, -1008(%rbp)

	movl	$1, %eax
	movl	%eax, -1012(%rbp)

	movl 	-1008(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1016(%rbp)
	movl 	-1012(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1020(%rbp)
		movl	-1016(%rbp), %eax
	movl	-1020(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1024(%rbp)

	movl	-1024(%rbp), %eax
	leaq	-212(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1000(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-876(%rbp), %rax
	movq	%rax, -1036(%rbp)

	movl	$1, %eax
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

	movl	-1060(%rbp), %eax
	leaq	-212(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1036(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-956(%rbp), %rax
	movq	%rax, -1072(%rbp)

	movl	$1, %eax
	movl	%eax, -1080(%rbp)

	movl	$1, %eax
	movl	%eax, -1084(%rbp)

	movl 	-1080(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1088(%rbp)
	movl 	-1084(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1092(%rbp)
		movl	-1088(%rbp), %eax
	movl	-1092(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1096(%rbp)

	movl	-1096(%rbp), %eax
	leaq	-212(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1072(%rbp), %rdx
	movq	%rdx, (%rax)

	movl	$0, %eax
	movl	%eax, -1132(%rbp)

	movl	$0, %eax
	movl	%eax, -1136(%rbp)

	movl 	-1132(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1140(%rbp)
	movl 	-1136(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1144(%rbp)
		movl	-1140(%rbp), %eax
	movl	-1144(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1148(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1148(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1124(%rbp)

	movl	$0, %eax
	movl	%eax, -1176(%rbp)

	movl	$1, %eax
	movl	%eax, -1180(%rbp)

	movl 	-1176(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1184(%rbp)
	movl 	-1180(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1188(%rbp)
		movl	-1184(%rbp), %eax
	movl	-1188(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1192(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1192(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1168(%rbp)

	movl	$1, %eax
	movl	%eax, -1220(%rbp)

	movl	$0, %eax
	movl	%eax, -1224(%rbp)

	movl 	-1220(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1228(%rbp)
	movl 	-1224(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1232(%rbp)
		movl	-1228(%rbp), %eax
	movl	-1232(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1236(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1236(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1212(%rbp)

	movl	$1, %eax
	movl	%eax, -1264(%rbp)

	movl	$1, %eax
	movl	%eax, -1268(%rbp)

	movl 	-1264(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1272(%rbp)
	movl 	-1268(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1276(%rbp)
		movl	-1272(%rbp), %eax
	movl	-1276(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1280(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1280(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1256(%rbp)

	movl	$0, %eax
	movl	%eax, -1316(%rbp)

	movl	$0, %eax
	movl	%eax, -1320(%rbp)

	movl 	-1316(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1324(%rbp)
	movl 	-1320(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1328(%rbp)
		movl	-1324(%rbp), %eax
	movl	-1328(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1332(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1332(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1308(%rbp)

	movl	$0, %eax
	movl	%eax, -1360(%rbp)

	movl	$1, %eax
	movl	%eax, -1364(%rbp)

	movl 	-1360(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1368(%rbp)
	movl 	-1364(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1372(%rbp)
		movl	-1368(%rbp), %eax
	movl	-1372(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1376(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1376(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1352(%rbp)

	movl	$1, %eax
	movl	%eax, -1404(%rbp)

	movl	$0, %eax
	movl	%eax, -1408(%rbp)

	movl 	-1404(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1412(%rbp)
	movl 	-1408(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1416(%rbp)
		movl	-1412(%rbp), %eax
	movl	-1416(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1420(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1420(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1396(%rbp)

	movl	$1, %eax
	movl	%eax, -1448(%rbp)

	movl	$1, %eax
	movl	%eax, -1452(%rbp)

	movl 	-1448(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1456(%rbp)
	movl 	-1452(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1460(%rbp)
		movl	-1456(%rbp), %eax
	movl	-1460(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1464(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1464(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1440(%rbp)

	movl	$0, %eax
	movl	%eax, -1484(%rbp)

	movl	$0, %eax
	movl	%eax, -1488(%rbp)

	movl 	-1484(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1492(%rbp)
	movl 	-1488(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1496(%rbp)
		movl	-1492(%rbp), %eax
	movl	-1496(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1500(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1500(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1512(%rbp)

	movl	$0, %eax
	movl	%eax, -1528(%rbp)

	movl	$0, %eax
	movl	%eax, -1532(%rbp)

	movl 	-1528(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1536(%rbp)
	movl 	-1532(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1540(%rbp)
		movl	-1536(%rbp), %eax
	movl	-1540(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1544(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1544(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1520(%rbp)

		movsd	-1512(%rbp), %xmm1
	movsd	-1520(%rbp), %xmm0
	subsd	%xmm0, %xmm1
	movsd	%xmm1, -1556(%rbp)

	movl	$0, %eax
	movl	%eax, -1564(%rbp)

	movl	$1, %eax
	movl	%eax, -1568(%rbp)

	movl 	-1564(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1572(%rbp)
	movl 	-1568(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1576(%rbp)
		movl	-1572(%rbp), %eax
	movl	-1576(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1580(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1580(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1592(%rbp)

	movl	$0, %eax
	movl	%eax, -1608(%rbp)

	movl	$1, %eax
	movl	%eax, -1612(%rbp)

	movl 	-1608(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1616(%rbp)
	movl 	-1612(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1620(%rbp)
		movl	-1616(%rbp), %eax
	movl	-1620(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1624(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1624(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1600(%rbp)

		movsd	-1592(%rbp), %xmm1
	movsd	-1600(%rbp), %xmm0
	subsd	%xmm0, %xmm1
	movsd	%xmm1, -1636(%rbp)

	movl	$1, %eax
	movl	%eax, -1644(%rbp)

	movl	$0, %eax
	movl	%eax, -1648(%rbp)

	movl 	-1644(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1652(%rbp)
	movl 	-1648(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1656(%rbp)
		movl	-1652(%rbp), %eax
	movl	-1656(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1660(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1660(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1672(%rbp)

	movl	$1, %eax
	movl	%eax, -1688(%rbp)

	movl	$0, %eax
	movl	%eax, -1692(%rbp)

	movl 	-1688(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1696(%rbp)
	movl 	-1692(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1700(%rbp)
		movl	-1696(%rbp), %eax
	movl	-1700(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1704(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1704(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1680(%rbp)

		movsd	-1672(%rbp), %xmm1
	movsd	-1680(%rbp), %xmm0
	subsd	%xmm0, %xmm1
	movsd	%xmm1, -1716(%rbp)

	movl	$1, %eax
	movl	%eax, -1724(%rbp)

	movl	$1, %eax
	movl	%eax, -1728(%rbp)

	movl 	-1724(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1732(%rbp)
	movl 	-1728(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1736(%rbp)
		movl	-1732(%rbp), %eax
	movl	-1736(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1740(%rbp)

	leaq	-140(%rbp), %rdx
	movl	-1740(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1752(%rbp)

	movl	$1, %eax
	movl	%eax, -1768(%rbp)

	movl	$1, %eax
	movl	%eax, -1772(%rbp)

	movl 	-1768(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1776(%rbp)
	movl 	-1772(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1780(%rbp)
		movl	-1776(%rbp), %eax
	movl	-1780(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1784(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-1784(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -1760(%rbp)

		movsd	-1752(%rbp), %xmm1
	movsd	-1760(%rbp), %xmm0
	subsd	%xmm0, %xmm1
	movsd	%xmm1, -1796(%rbp)

	movq	-1556(%rbp), %rax
	movq	%rax, -1804(%rbp)

	movl	$0, %eax
	movl	%eax, -1812(%rbp)

	movl	$0, %eax
	movl	%eax, -1816(%rbp)

	movl 	-1812(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1820(%rbp)
	movl 	-1816(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1824(%rbp)
		movl	-1820(%rbp), %eax
	movl	-1824(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1828(%rbp)

	movl	-1828(%rbp), %eax
	leaq	-252(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1804(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1636(%rbp), %rax
	movq	%rax, -1840(%rbp)

	movl	$0, %eax
	movl	%eax, -1848(%rbp)

	movl	$1, %eax
	movl	%eax, -1852(%rbp)

	movl 	-1848(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1856(%rbp)
	movl 	-1852(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1860(%rbp)
		movl	-1856(%rbp), %eax
	movl	-1860(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1864(%rbp)

	movl	-1864(%rbp), %eax
	leaq	-252(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1840(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1716(%rbp), %rax
	movq	%rax, -1876(%rbp)

	movl	$1, %eax
	movl	%eax, -1884(%rbp)

	movl	$0, %eax
	movl	%eax, -1888(%rbp)

	movl 	-1884(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1892(%rbp)
	movl 	-1888(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1896(%rbp)
		movl	-1892(%rbp), %eax
	movl	-1896(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1900(%rbp)

	movl	-1900(%rbp), %eax
	leaq	-252(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1876(%rbp), %rdx
	movq	%rdx, (%rax)

	movq	-1796(%rbp), %rax
	movq	%rax, -1912(%rbp)

	movl	$1, %eax
	movl	%eax, -1920(%rbp)

	movl	$1, %eax
	movl	%eax, -1924(%rbp)

	movl 	-1920(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -1928(%rbp)
	movl 	-1924(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -1932(%rbp)
		movl	-1928(%rbp), %eax
	movl	-1932(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -1936(%rbp)

	movl	-1936(%rbp), %eax
	leaq	-252(%rbp), %rdx
	leaq	(%rdx,%rax), %rax
	movq	-1912(%rbp), %rdx
	movq	%rdx, (%rax)

	movq 	$.LC1, -1948(%rbp)
	movl 	-1948(%rbp), %eax
	movq 	-1948(%rbp), %rdi
	call	printStr
	movl	%eax, -1952(%rbp)
	movl	$0, %eax
	movl	%eax, -1956(%rbp)

	movl	-1956(%rbp), %eax
	movl	%eax, -36(%rbp)

.L2: 
	movl	$2, %eax
	movl	%eax, -1964(%rbp)

		movl	-36(%rbp), %eax
	cmpl	-1964(%rbp), %eax
	jl .L4
	jmp .L8
.L3: 
	movl	-36(%rbp), %eax
	movl	%eax, -1972(%rbp)

	addl 	$1, -36(%rbp)
	jmp .L2
.L4: 
	movl	$0, %eax
	movl	%eax, -1976(%rbp)

	movl	-1976(%rbp), %eax
	movl	%eax, -40(%rbp)

.L5: 
	movl	$2, %eax
	movl	%eax, -1984(%rbp)

		movl	-40(%rbp), %eax
	cmpl	-1984(%rbp), %eax
	jl .L7
	jmp .L3
.L6: 
	movl	-40(%rbp), %eax
	movl	%eax, -1992(%rbp)

	addl 	$1, -40(%rbp)
	jmp .L5
.L7: 
	movl 	-36(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -2004(%rbp)
	movl 	-40(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -2008(%rbp)
		movl	-2004(%rbp), %eax
	movl	-2008(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -2012(%rbp)

	leaq	-212(%rbp), %rdx
	movl	-2012(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -2024(%rbp)

	movl 	-2024(%rbp), %eax
	movsd 	-2024(%rbp), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-2024(%rbp), %rdi
	call	printFlt
	movl	%eax, -2032(%rbp)
	jmp .L6
	jmp .L3
.L8: 
	movq 	$.LC2, -2036(%rbp)
	movl 	-2036(%rbp), %eax
	movq 	-2036(%rbp), %rdi
	call	printStr
	movl	%eax, -2040(%rbp)
	movl	$0, %eax
	movl	%eax, -2044(%rbp)

	movl	-2044(%rbp), %eax
	movl	%eax, -36(%rbp)

.L9: 
	movl	$2, %eax
	movl	%eax, -2052(%rbp)

		movl	-36(%rbp), %eax
	cmpl	-2052(%rbp), %eax
	jl .L11
	jmp .L15
.L10: 
	movl	-36(%rbp), %eax
	movl	%eax, -2060(%rbp)

	addl 	$1, -36(%rbp)
	jmp .L9
.L11: 
	movl	$0, %eax
	movl	%eax, -2064(%rbp)

	movl	-2064(%rbp), %eax
	movl	%eax, -40(%rbp)

.L12: 
	movl	$2, %eax
	movl	%eax, -2072(%rbp)

		movl	-40(%rbp), %eax
	cmpl	-2072(%rbp), %eax
	jl .L14
	jmp .L10
.L13: 
	movl	-40(%rbp), %eax
	movl	%eax, -2080(%rbp)

	addl 	$1, -40(%rbp)
	jmp .L12
.L14: 
	movl 	-36(%rbp), %eax
	imull 	$16, %eax
	movl 	%eax, -2088(%rbp)
	movl 	-40(%rbp), %eax
	imull 	$8, %eax
	movl 	%eax, -2092(%rbp)
		movl	-2088(%rbp), %eax
	movl	-2092(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -2096(%rbp)

	leaq	-252(%rbp), %rdx
	movl	-2096(%rbp), %eax
	movq	(%rdx,%rax), %rax
	movq	%rax, -2108(%rbp)

	movl 	-2108(%rbp), %eax
	movsd 	-2108(%rbp), %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movq 	-2108(%rbp), %rdi
	call	printFlt
	movl	%eax, -2116(%rbp)
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
