	.text
	.file	"teste.c"
	.globl	write                           # -- Begin function write
	.p2align	4, 0x90
	.type	write,@function
write:                                  # @write
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movl	%ecx, -24(%rbp)
	movl	-4(%rbp), %ecx
	movq	-16(%rbp), %r8
	movl	-20(%rbp), %r9d
	movl	-24(%rbp), %r10d
	#APP
	movl	%rdi, %ecx	# file descriptor
	movq	%rsi, %r8	# buffer 
	movl	%rdx, %r9d	# size 
	movl	%rax, %r10d	# syscall write (64) 
	syscall

	#NO_APP
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	write, .Lfunc_end0-write
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -4(%rbp)
	movq	.L__const.main.str(%rip), %rax
	movq	%rax, -18(%rbp)
	movl	.L__const.main.str+8(%rip), %eax
	movl	%eax, -10(%rbp)
	movw	.L__const.main.str+12(%rip), %ax
	movw	%ax, -6(%rbp)
	leaq	-18(%rbp), %rsi
	movl	$1, %edi
	movl	$13, %edx
	movl	$64, %ecx
	callq	write
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.globl	_start                          # -- Begin function _start
	.p2align	4, 0x90
	.type	_start,@function
_start:                                 # @_start
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	callq	main
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	_start, .Lfunc_end2-_start
	.cfi_endproc
                                        # -- End function
	.type	.L__const.main.str,@object      # @__const.main.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__const.main.str:
	.asciz	"Hello World!\n"
	.size	.L__const.main.str, 14

	.ident	"Ubuntu clang version 15.0.7"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym write
	.addrsig_sym main
