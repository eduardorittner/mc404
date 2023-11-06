.text
    .globl _start
    
_start:
    la a0, car
    li a1, 1
    li a2, 0
    li a3, 9000
    li a4, -127

run:
    sb a4, 32(a0)
    sb a1, 33(a0)
    addi a2, a2, 1
    bne a2, a3, run

    sb zero, 32(a0)
    li a3, 15000

run_2:
    sb a1, 33(a0)
    addi a2, a2, 1
    bne a2, a3, run_2

    sb zero, 33(a0)
    li a2, 0
    li a3, 500000

loop:
    addi a2, a2, 1
    bne a2, a3, loop

    li a1, 1
    sb a1, 34(a0)

    li a0, 0
    jal exit
    
exit:
    # INPUT #
    # a0 - return code #
    # OUTPUT #

    li a7, 93
    ecall


.data
    .set car, 0xFFFF0100 
