	.file	"eita.c"
	.text
	.globl	funcao
	.type	funcao, @function
funcao:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$20, -4(%rbp)
	jle	.L2
	movl	$0, %eax
	jmp	.L3
.L2:
	cmpl	$9, -4(%rbp)
	jg	.L4
	movl	$1, %eax
	jmp	.L3
.L4:
	cmpl	$10, -4(%rbp)
	jg	.L5
	movl	$2, %eax
	jmp	.L3
.L5:
	cmpl	$11, -4(%rbp)
	jg	.L6
	movl	$3, %eax
	jmp	.L3
.L6:
	cmpl	$12, -4(%rbp)
	jg	.L7
	movl	$4, %eax
	jmp	.L3
.L7:
	cmpl	$13, -4(%rbp)
	jg	.L8
	movl	$5, %eax
	jmp	.L3
.L8:
	cmpl	$14, -4(%rbp)
	jg	.L9
	movl	$6, %eax
	jmp	.L3
.L9:
	movl	$7, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	funcao, .-funcao
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$30, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	funcao
	testl	%eax, %eax
	je	.L11
	movl	$1, %eax
	jmp	.L12
.L11:
	movl	$0, %eax
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
