	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"a.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	mv	a3, a2
	mv	a4, a1
	mv	a5, a0
	#APP
	mv	a0, a5	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a3	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	mv	a0, a3
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	mv	a3, a2
	mv	a4, a1
	mv	a5, a0
	#APP
	mv	a0, a5	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a3	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	mv	a1, a0
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (64) 
	ecall	
	#NO_APP
.Lfunc_end2:
	.size	exit, .Lfunc_end2-exit

	.globl	square
	.p2align	2
	.type	square,@function
square:
	srli	a1, a0, 31
	add	a1, a0, a1
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a2, a0, a1
	add	a1, a2, a1
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	div	a0, a0, a1
	add	a0, a0, a1
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	ret
.Lfunc_end3:
	.size	square, .Lfunc_end3-square

	.globl	decimal
	.p2align	2
	.type	decimal,@function
decimal:
	lbu	a1, 3(a0)
	lbu	a2, 4(a0)
	li	a3, 10
	mul	a1, a1, a3
	lbu	a3, 2(a0)
	add	a2, a1, a2
	li	a1, 100
	lbu	a4, 1(a0)
	mul	a3, a3, a1
	li	a5, 1000
	lbu	a1, 0(a0)
	mul	a0, a4, a5
	add	a0, a0, a3
	li	a3, 45
	add	a0, a0, a2
	beq	a1, a3, .LBB4_2
	lui	a2, 2
	addi	a2, a2, 1808
	mul	a1, a1, a2
	lui	a2, 1048446
	addi	a2, a2, -848
	add	a1, a1, a2
	add	a0, a1, a0
	ret
.LBB4_2:
	lui	a1, 13
	addi	a1, a1, 80
	sub	a0, a1, a0
	ret
.Lfunc_end4:
	.size	decimal, .Lfunc_end4-decimal

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -32
	addi	a3, sp, 28
	li	a4, 4
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a3	# buffer 
	mv	a2, a4	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	addi	a3, sp, 6
	li	a5, 1
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a3	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a6, a0	# move return value to ret_val

	#NO_APP
	addi	a6, sp, 24
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a6	# buffer 
	mv	a2, a4	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a6, a0	# move return value to ret_val

	#NO_APP
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a3	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a6, a0	# move return value to ret_val

	#NO_APP
	addi	a6, sp, 20
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a6	# buffer 
	mv	a2, a4	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a6, a0	# move return value to ret_val

	#NO_APP
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a3	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	addi	a3, sp, 16
	#APP
	li	a0, 0	# file descriptor
	mv	a1, a3	# buffer 
	mv	a2, a4	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	li	a0, 0
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.ident	"clang version 16.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
