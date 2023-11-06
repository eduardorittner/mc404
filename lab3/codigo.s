	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"codigo.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (64) 
	ecall	
	#NO_APP
.Lfunc_end2:
	.size	exit, .Lfunc_end2-exit

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	exit
.Lfunc_end3:
	.size	_start, .Lfunc_end3-_start

	.globl	num_size
	.p2align	2
	.type	num_size,@function
num_size:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 0
	mv	a2, a1
	sw	a2, -20(s0)
	beq	a0, a1, .LBB4_3
	j	.LBB4_2
.LBB4_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -10
	snez	a0, a0
	sw	a0, -20(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -20(s0)
	andi	a0, a0, 1
	li	a1, 0
	beq	a0, a1, .LBB4_6
	j	.LBB4_4
.LBB4_4:
	j	.LBB4_5
.LBB4_5:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB4_1
.LBB4_6:
	lw	a0, -16(s0)
	addi	a0, a0, -1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	num_size, .Lfunc_end4-num_size

	.globl	reverse
	.p2align	2
	.type	reverse,@function
reverse:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -24(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	bge	a0, a1, .LBB5_3
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	sb	a0, -25(s0)
	lw	a1, -12(s0)
	lw	a0, -24(s0)
	add	a0, a1, a0
	lb	a0, 0(a0)
	lw	a2, -16(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lb	a0, -25(s0)
	lw	a1, -12(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, -1
	sw	a0, -24(s0)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB5_1
.LBB5_3:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	reverse, .Lfunc_end5-reverse

	.globl	decimal
	.p2align	2
	.type	decimal,@function
decimal:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	call	num_size
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	li	a1, 1
	sw	a1, -28(s0)
	sw	a0, -32(s0)
	j	.LBB6_1
.LBB6_1:
	lw	a0, -20(s0)
	lw	a1, -24(s0)
	sub	a1, a0, a1
	li	a0, 0
	bge	a0, a1, .LBB6_4
	j	.LBB6_2
.LBB6_2:
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	lw	a2, -24(s0)
	sub	a1, a1, a2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	lw	a1, -28(s0)
	mul	a1, a0, a1
	lw	a0, -32(s0)
	add	a0, a0, a1
	sw	a0, -32(s0)
	lw	a0, -28(s0)
	li	a1, 10
	mul	a0, a0, a1
	sw	a0, -28(s0)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB6_1
.LBB6_4:
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	li	a1, 45
	bne	a0, a1, .LBB6_6
	j	.LBB6_5
.LBB6_5:
	lw	a1, -32(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB6_7
.LBB6_6:
	lw	a0, -32(s0)
	lw	a1, -28(s0)
	lw	a2, -16(s0)
	lbu	a2, 0(a2)
	addi	a2, a2, -48
	mul	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB6_7
.LBB6_7:
	lw	a0, -12(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end6:
	.size	decimal, .Lfunc_end6-decimal

	.globl	hexa
	.p2align	2
	.type	hexa,@function
hexa:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	num_size
	sw	a0, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	sw	a0, -28(s0)
	j	.LBB7_1
.LBB7_1:
	lw	a0, -28(s0)
	li	a1, 2
	blt	a0, a1, .LBB7_7
	j	.LBB7_2
.LBB7_2:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 97
	blt	a0, a1, .LBB7_4
	j	.LBB7_3
.LBB7_3:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -87
	sw	a0, -24(s0)
	j	.LBB7_5
.LBB7_4:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	sw	a0, -24(s0)
	j	.LBB7_5
.LBB7_5:
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	lw	a2, -28(s0)
	sub	a1, a1, a2
	slli	a1, a1, 2
	sll	a0, a0, a1
	sw	a0, -24(s0)
	lw	a0, -20(s0)
	lw	a1, -24(s0)
	or	a0, a0, a1
	sw	a0, -20(s0)
	j	.LBB7_6
.LBB7_6:
	lw	a0, -28(s0)
	addi	a0, a0, -1
	sw	a0, -28(s0)
	j	.LBB7_1
.LBB7_7:
	lw	a0, -20(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end7:
	.size	hexa, .Lfunc_end7-hexa

	.globl	print_decimal_u
	.p2align	2
	.type	print_decimal_u,@function
print_decimal_u:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	sw	a0, -44(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -12(s0)
	li	a1, 0
	beq	a0, a1, .LBB8_6
	j	.LBB8_2
.LBB8_2:
	lw	a0, -12(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a1, a0, a1
	srli	a2, a1, 3
	li	a1, 10
	mul	a2, a2, a1
	sub	a0, a0, a2
	sw	a0, -40(s0)
	lw	a0, -40(s0)
	blt	a0, a1, .LBB8_4
	j	.LBB8_3
.LBB8_3:
	lw	a0, -40(s0)
	addi	a0, a0, 87
	lw	a2, -16(s0)
	addi	a1, s0, -36
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB8_5
.LBB8_4:
	lw	a0, -40(s0)
	addi	a0, a0, 48
	lw	a2, -16(s0)
	addi	a1, s0, -36
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB8_5
.LBB8_5:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	lw	a0, -12(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -12(s0)
	j	.LBB8_1
.LBB8_6:
	lw	a1, -44(s0)
	lw	a2, -16(s0)
	addi	a0, s0, -36
	sw	a0, -48(s0)
	call	reverse
	lw	a1, -48(s0)
	lw	a0, -16(s0)
	add	a2, a1, a0
	li	a0, 10
	sb	a0, 0(a2)
	lw	a0, -16(s0)
	addi	a2, a0, 1
	li	a0, 1
	call	write
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end8:
	.size	print_decimal_u, .Lfunc_end8-print_decimal_u

	.globl	print_decimal
	.p2align	2
	.type	print_decimal,@function
print_decimal:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lui	a1, 524288
	bne	a0, a1, .LBB9_2
	j	.LBB9_1
.LBB9_1:
	lui	a0, %hi(.L.str)
	addi	a1, a0, %lo(.L.str)
	li	a0, 1
	li	a2, 12
	call	write
	j	.LBB9_10
.LBB9_2:
	li	a1, 0
	sw	a1, -16(s0)
	sw	a1, -40(s0)
	sw	a1, -48(s0)
	lw	a0, -12(s0)
	bge	a0, a1, .LBB9_4
	j	.LBB9_3
.LBB9_3:
	li	a0, 1
	sw	a0, -40(s0)
	lw	a1, -12(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB9_4
.LBB9_4:
	j	.LBB9_5
.LBB9_5:
	lw	a0, -12(s0)
	li	a1, 0
	beq	a0, a1, .LBB9_7
	j	.LBB9_6
.LBB9_6:
	lw	a0, -12(s0)
	lui	a1, 419430
	addi	a1, a1, 1639
	mulh	a2, a0, a1
	srli	a3, a2, 31
	srai	a2, a2, 2
	add	a2, a2, a3
	li	a3, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	addi	a0, a0, 48
	sw	a0, -44(s0)
	lw	a0, -44(s0)
	lw	a3, -16(s0)
	addi	a2, s0, -36
	add	a2, a2, a3
	sb	a0, 0(a2)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	lw	a0, -12(s0)
	mulh	a0, a0, a1
	srli	a1, a0, 31
	srai	a0, a0, 2
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB9_5
.LBB9_7:
	lw	a0, -40(s0)
	li	a1, 0
	beq	a0, a1, .LBB9_9
	j	.LBB9_8
.LBB9_8:
	lw	a1, -16(s0)
	addi	a0, s0, -36
	add	a1, a0, a1
	li	a0, 45
	sb	a0, 0(a1)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB9_9
.LBB9_9:
	lw	a1, -48(s0)
	lw	a2, -16(s0)
	addi	a0, s0, -36
	sw	a0, -52(s0)
	call	reverse
	lw	a1, -52(s0)
	lw	a0, -16(s0)
	add	a2, a1, a0
	li	a0, 10
	sb	a0, 0(a2)
	lw	a0, -16(s0)
	addi	a2, a0, 1
	li	a0, 1
	call	write
	j	.LBB9_10
.LBB9_10:
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end9:
	.size	print_decimal, .Lfunc_end9-print_decimal

	.globl	change_endian
	.p2align	2
	.type	change_endian,@function
change_endian:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	li	a0, 255
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	and	a0, a0, a1
	sw	a0, -24(s0)
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	slli	a1, a1, 8
	and	a0, a0, a1
	sw	a0, -28(s0)
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	slli	a1, a1, 16
	and	a0, a0, a1
	sw	a0, -32(s0)
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	slli	a1, a1, 24
	and	a0, a0, a1
	sw	a0, -36(s0)
	lbu	a0, -33(s0)
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	a1, -32(s0)
	srli	a1, a1, 8
	or	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	a1, -28(s0)
	slli	a1, a1, 8
	or	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	slli	a1, a1, 24
	or	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end10:
	.size	change_endian, .Lfunc_end10-change_endian

	.globl	print_binary
	.p2align	2
	.type	print_binary,@function
print_binary:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	li	a0, 48
	sb	a0, -52(s0)
	li	a0, 98
	sb	a0, -51(s0)
	li	a0, 1
	sw	a0, -56(s0)
	li	a0, 2
	sw	a0, -64(s0)
	j	.LBB11_1
.LBB11_1:
	lw	a1, -64(s0)
	li	a0, 33
	blt	a0, a1, .LBB11_4
	j	.LBB11_2
.LBB11_2:
	lw	a0, -56(s0)
	lw	a1, -12(s0)
	and	a0, a0, a1
	sw	a0, -60(s0)
	lw	a0, -60(s0)
	addi	a0, a0, 48
	lw	a2, -64(s0)
	addi	a1, s0, -52
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -12(s0)
	srai	a0, a0, 1
	sw	a0, -12(s0)
	j	.LBB11_3
.LBB11_3:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB11_1
.LBB11_4:
	li	a0, 34
	sw	a0, -68(s0)
	j	.LBB11_5
.LBB11_5:
	lw	a1, -68(s0)
	addi	a0, s0, -52
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 49
	beq	a0, a1, .LBB11_8
	j	.LBB11_6
.LBB11_6:
	j	.LBB11_7
.LBB11_7:
	lw	a0, -68(s0)
	addi	a0, a0, -1
	sw	a0, -68(s0)
	j	.LBB11_5
.LBB11_8:
	lw	a0, -68(s0)
	addi	a2, a0, 1
	addi	a0, s0, -52
	sw	a0, -72(s0)
	li	a1, 2
	call	reverse
	lw	a1, -72(s0)
	lw	a0, -68(s0)
	add	a2, a0, a1
	li	a0, 10
	sb	a0, 1(a2)
	lw	a0, -68(s0)
	addi	a2, a0, 2
	li	a0, 1
	call	write
	lw	ra, 76(sp)
	lw	s0, 72(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end11:
	.size	print_binary, .Lfunc_end11-print_binary

	.globl	print_hexa
	.p2align	2
	.type	print_hexa,@function
print_hexa:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	li	a0, 48
	sb	a0, -52(s0)
	li	a0, 120
	sb	a0, -51(s0)
	li	a0, 15
	sw	a0, -56(s0)
	li	a0, 2
	sw	a0, -64(s0)
	j	.LBB12_1
.LBB12_1:
	lw	a1, -64(s0)
	li	a0, 9
	blt	a0, a1, .LBB12_7
	j	.LBB12_2
.LBB12_2:
	lw	a0, -56(s0)
	lw	a1, -12(s0)
	and	a0, a0, a1
	sw	a0, -60(s0)
	lw	a0, -60(s0)
	li	a1, 10
	blt	a0, a1, .LBB12_4
	j	.LBB12_3
.LBB12_3:
	lw	a0, -60(s0)
	addi	a0, a0, 87
	lw	a2, -64(s0)
	addi	a1, s0, -52
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB12_5
.LBB12_4:
	lw	a0, -60(s0)
	addi	a0, a0, 48
	lw	a2, -64(s0)
	addi	a1, s0, -52
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB12_5
.LBB12_5:
	lw	a0, -12(s0)
	srai	a0, a0, 4
	sw	a0, -12(s0)
	j	.LBB12_6
.LBB12_6:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB12_1
.LBB12_7:
	li	a0, 9
	sw	a0, -68(s0)
	j	.LBB12_8
.LBB12_8:
	lw	a1, -68(s0)
	addi	a0, s0, -52
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 48
	bne	a0, a1, .LBB12_11
	j	.LBB12_9
.LBB12_9:
	j	.LBB12_10
.LBB12_10:
	lw	a0, -68(s0)
	addi	a0, a0, -1
	sw	a0, -68(s0)
	j	.LBB12_8
.LBB12_11:
	lw	a0, -68(s0)
	addi	a2, a0, 1
	addi	a0, s0, -52
	sw	a0, -72(s0)
	li	a1, 2
	call	reverse
	lw	a1, -72(s0)
	lw	a0, -68(s0)
	add	a2, a0, a1
	li	a0, 10
	sb	a0, 1(a2)
	lw	a0, -68(s0)
	addi	a2, a0, 2
	li	a0, 1
	call	write
	lw	ra, 76(sp)
	lw	s0, 72(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end12:
	.size	print_hexa, .Lfunc_end12-print_hexa

	.globl	print
	.p2align	2
	.type	print,@function
print:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	print_binary
	lw	a0, -12(s0)
	call	print_decimal
	lw	a0, -12(s0)
	call	print_hexa
	lw	a0, -12(s0)
	call	change_endian
	call	print_decimal_u
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end13:
	.size	print, .Lfunc_end13-print

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	li	a0, 0
	sw	a0, -12(s0)
	addi	a1, s0, -32
	li	a2, 20
	call	read
	sw	a0, -36(s0)
	lbu	a0, -31(s0)
	li	a1, 120
	bne	a0, a1, .LBB14_2
	j	.LBB14_1
.LBB14_1:
	addi	a0, s0, -32
	call	hexa
	sw	a0, -40(s0)
	lw	a0, -40(s0)
	call	print
	j	.LBB14_3
.LBB14_2:
	addi	a0, s0, -32
	call	decimal
	sw	a0, -40(s0)
	lw	a0, -40(s0)
	call	print
	j	.LBB14_3
.LBB14_3:
	li	a0, 0
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end14:
	.size	main, .Lfunc_end14-main

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"-2147483648\n"
	.size	.L.str, 13

	.type	fodase,@object
	.section	.sbss,"aw",@nobits
	.globl	fodase
	.p2align	2
fodase:
	.word	0
	.size	fodase, 4

	.ident	"Ubuntu clang version 15.0.7"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym exit
	.addrsig_sym num_size
	.addrsig_sym reverse
	.addrsig_sym decimal
	.addrsig_sym hexa
	.addrsig_sym print_decimal_u
	.addrsig_sym print_decimal
	.addrsig_sym change_endian
	.addrsig_sym print_binary
	.addrsig_sym print_hexa
	.addrsig_sym print
	.addrsig_sym main
