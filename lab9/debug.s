.text

.globl _start

_start:
    li a0, 20
    la a1, input_buffer
    jal to_string_s
        
    mv a2, a0
    li a0, 1
    la a1, out_buffer
    li a7, 64
    ecall

    li a0, 0
    li a7, 93
    ecall

to_string_s:
    # Converts a signed number to string with '-'
    # negative and as is if positive
    # Registradores #
    # INPUT #
    # a0 - number #
    # a1 - buffer #
    # OUTPUT #
    # a0 - buffer size #
    # a1 - buffer #
    
    li t4, 10
    mv t3, a1

    li t5, -1
    beq t5, a0, negative
    j 1f

negative:
    la t3, out_buffer
    li t4, 45
    sb t4, 0(t3)        # ascii for '-'
    li t4, 49
    sb t4, 1(t3)
    li t4, 10
    sb t4, 2(t3)
    li a0, 3
    ret

1:
    rem t0, a0, t4      # Current digit
    addi t0, t0, 48     # To ascii
    sb t0, 0(t3)        # Store in buffer
    div a0, a0, t4      # Divide a0 by 10 (remove last digit)
    addi t3, t3, 1      # Increment buffer position

    bnez a0, 1b         # If a0 = 0, cabo

    sub a0, t3, a1      # Size = last - first

    addi sp, sp, 4
    sw ra, 0(sp)

    mv a1, a0
    la a0, input_buffer
    la a2, out_buffer

    jal invert_string

    mv a0, a1
    la a1, out_buffer

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

invert_string:
    # Inverte uma string sem '\n' e depois adiciona um
    # '\n' no final
    # Deveria retornar a string no mesmo buffer que foi
    # passado pra ela, mas por enquanto fodase
    # Registradores #
    # t0 - first pointer #
    # t1 - second pointer #
    # INPUT #
    # a0 - buffer #
    # a1 - buffer size #
    # a2 - out buffer #
    # OUTPUT #
    # a1 - size

    mv t0, a0
    add t1, a2, a1
    addi t1, t1, -1

2:

    lb t2, 0(t0)        # Read char from position
    sb t2, 0(t1)        # Write to equivalent position

    addi t0, t0, 1
    addi t1, t1, -1
    beq t1, a2, 2b      # If the second pointer is less than the start

next:
    li t1, 10           # Ascii for '\n'
    add t0, a2, a1
    sb t1, 0(t0)        # Appends '\n'

    addi a1, a1, 1

    ret
.data
    input_buffer: .skip 0x20
    out_buffer: .skip 0x20
    

