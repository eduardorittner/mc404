.text

.globl _start

_start:
    
    la a0, teste
    li a1, 4

    jal to_binary
    
    li a1, 4
    jal to_string_b

    jal print

    la a0, teste
    li a1, 4

    jal to_binary
    
    li a1, 4
    jal to_string_b

    jal print

    # exit
    li a0, 0
    li a7, 93
    ecall

to_binary:
    # INPUT #
    # a0 - buffer address
    # a1 - size
    # OUTPUT #
    # a0 - binary
    
    addi sp, sp, -4
    sw ra, 0(sp)

    add t4, a0, a1 # Endereço maximo
    mv t6, a0
    li a0, 0 # Começa a0 com 0

1:
    bge t6, t4, 2f # Se t4==t6, termina a função

    lb t5, 0(t6) # char armazenado em t6
    addi t5, t5, -48 # Convert from ascii
    mv a1, t5
    jal concat_b

    addi t6, t6, 1 # Proximo char
    j 1b

2:
    lw ra, 0(sp)
    addi sp, sp, 4

    ret

concat_b: 
    # INPUT #
    # a0 - number to concat to
    # a1 - 0 or 1
    # OUTPUT #
    # a0 - concatted number

    slli a0, a0, 1
    add a0, a0, a1

    ret

to_string_b:
    # INPUT #
    # a0 - number #
    # a1 - size #
    # OUTPUT #
    # a0 - address #
    # a1 - size #

    # get corresponding byte
    # shift to the first pos
    # add 48
    # append

    la t3, output
    mv t4, a1

loop:
    beq t4, zero, end # Se t4 = 0, salta
    addi t4, t4, -1
    srl t5, a0, t4 # Moves corresponding bit to first position
    li t6, 1
    and t5, t5, t6 # Selects only first bit
    addi t5, t5, 48 # Converts to ascii

    sb t5, 0(t3) # Stores
    addi t3, t3, 1 # Moves pointer to next position
    j loop

end:
    li t5, 10
    sb t5, 0(t3) # Appends \n to the end
    la a0, output # Stores output in a0

    ret


print:
    # INPUT #
    # a0 - string #
    # a1 - size #
    # OUTPUT #
    addi a1, a1, 1

    mv a2, a1
    mv a1, a0
    li a0, 1
    li a7, 64
    ecall

    ret



.data
linha_1: .skip 0x5
linha_2: .skip 0x8
output: .skip 0x20
numero: .word 0xf
teste: .string "1010"

