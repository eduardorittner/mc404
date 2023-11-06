.section .text

.globl _start

_start:
    li a0, 0
    la a1, input
    li a2, 21
    li a7, 63
    ecall

    mv s1, a1
    mv a0, a1
    jal process_num

    mv a0, s1
    addi a0, a0, 5
    jal process_num

    mv a0, s1
    addi a0, a0, 10
    jal process_num

    mv a0, s1
    addi a0, a0, 15
    jal process_num

    li a0, 1
    la a1, eol
    li a2, 1
    li a7, 64
    ecall

    # exit
    li a0, 0
    li a7, 93
    ecall

process_num:
    # a0 - string address

    # transforma em inteiro
    # roda sqrt 10 vezes
    # printa sem o "\n"
    
    mv s9, ra # save ra to use in the end of function
    
    jal to_decimal

    mv a1, a0
    li t0, 2
    div a0, a0, t0

    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt
    jal sqrt


    jal to_string

    li a0, 1
    la a1, numero_saida
    li a2, 5
    li a7, 64
    ecall
    
    mv ra, s9

    ret

sqrt:
    # INPUT #
    # a0 - guess
    # a1 - original number
    # OUTPUT #

    div t4, a1, a0
    add t4, t4, a0
    li t5, 2
    div a0, t4, t5

    ret


to_decimal:
    # INPUT #
    # a0 - string address
    # OUTPUT #
    # a0 - number

    lb t3, 0(a0)
    addi t3, t3, -48
    li t4, 1000
    mul t3, t3, t4
    mv t5, t3

    lb t3, 1(a0)
    addi t3, t3, -48
    li t4, 100
    mul t3, t3, t4
    add t5, t5, t3

    lb t3, 2(a0)
    addi t3, t3, -48
    li t4, 10
    mul t3, t3, t4
    add t5, t5, t3

    lb t3, 3(a0)
    addi t3, t3, -48
    add t5, t5, t3

    mv a0, t5

    ret

to_string:
    # INPUT #
    # a0 - number
    # OUTPUT #

    la a1, numero_saida

    li t5, 1000
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 0(a1)

    rem a0, a0, t5

    li t5, 100
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 1(a1)

    rem a0, a0, t5

    li t5, 10
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 2(a1)

    rem a0, a0, t5

    mv t3, a0
    addi t3, t3, 48
    sb t3, 3(a1)

    li t3, 32 # Space in ascii
    sb t3, 4(a1)
     
    ret



print:
    # INPUT #
    # a0 - string address
    # a1 - size
    # OUTPUT #
    # nil

    mv a2, a1
    mv a1, a0
    li a0, 1
    li a7, 64
    ecall

    # print "\n"
    li a0, 1
    la a1, eol
    li a2, 1
    li a7, 64
    ecall

    ret

.section .data
eol: .string "\n"
input: .skip 0x14
numero_saida: .skip 0x5
