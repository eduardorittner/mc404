.text

.globl _start

_start:

    # Ler primeira entrada
    la a0, linha_1
    li a1, 5
    jal read

    la a0, linha_1
    li a1, 4
    jal to_binary

    jal to_hamming

    li a1, 7
    la a2, numero_saida
    jal to_string_b

    # Acabou primeira entrada

    # Ler segunda entrada
    la a0, linha_2
    li a1, 7
    jal read

    la a0, linha_2
    li a1, 7
    jal to_binary
    
    sw a0, check, t0 # Stores the full code

    jal from_hamming # Strip hamming code

    mv t0, a0

    li a1, 4
    la a2, numero_saida
    addi a2, a2, 8
    jal to_string_b

    mv a0, t0

    jal to_hamming # Regenerate the hamming code

    lw a1, check
    sub a0, a0, a1 # Difference between generated and given code
    snez a0, a0

    li a1, 1
    la a2, numero_saida
    addi a2, a2, 13
    jal to_string_b

    li a1, 15
    jal print

    li a0, 0
    li a7, 93
    ecall

from_hamming:
    # INPUT #
    # a0 - number
    # OUTPUT #
    # a0 - result

    andi t3, a0, 7 # Selects first 3 bytes
    andi t4, a0, 16 # Selects fifth byte
    srli t4, t4, 1 # Converts to 4th byte
    add a0, t3, t4 # adds them

    ret

to_hamming:
    # Encodes a binary number in hamming code
    # INPUT #
    # a0 - number
    # OUTPUT #
    # a0 - result

    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)
    
    li a1, 8
    li a2, 4
    li a3, 1
    jal xor_three
    mv s2, a0 # p1

    lw a0, 4(sp)
    li a1, 8
    li a2, 2
    li a3, 1
    jal xor_three
    mv s3, a0 # p2

    lw a0, 4(sp)
    li a1, 4
    li a2, 2
    li a3, 1
    jal xor_three
    mv s4, a0 # p3

    # Now to create the result

    li a0, 0
    mv a1, s2 # p1
    jal concat_b

    mv a1, s3 # p2
    jal concat_b

    lw t3, 4(sp)
    andi a1, t3, 8 
    snez a1, a1 # d1
    jal concat_b
    
    mv a1, s4 # p3
    jal concat_b

    lw t3, 4(sp)
    andi a1, t3, 4 
    snez a1, a1 # d2
    jal concat_b

    lw t3, 4(sp)
    andi a1, t3, 2
    snez a1, a1 # d3
    jal concat_b

    lw t3, 4(sp)
    andi a1, t3, 1
    snez a1, a1 # d4
    jal concat_b

    lw ra, 0(sp)
    addi sp, sp, 8

    ret


xor_three:
    # Performs the xor operation to 3 bits in a number
    # The inputs are masks that select the bits
    # INPUT #
    # a0 - number
    # a1 - first bit
    # a2 - second bit
    # a3 - third bit
    # OUTPUT #
    # a0 - result
    
    and t3, a0, a1 # Selects the bit
    snez t3, t3 # "Shifts" the bit to the first position

    and t4, a0, a2
    snez t4, t4

    and t5, a0, a3
    snez t5, t5

    xor t3, t3, t4
    xor t3, t3, t5

    snez a0, t3
    ret


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

to_string_b:
    # INPUT #
    # a0 - number #
    # a1 - size #
    # a2 - address #
    # OUTPUT #
    # a0 - address #
    # a1 - size #

    # get corresponding byte
    # shift to the first pos
    # add 48
    # append

    mv t3, a2
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
    la a0, numero_saida # Stores output in a0

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

read:
    # INPUT #
    # a0 - buffer address
    # a1 - size
    # OUTPUT #

    mv a2, a1
    mv a1, a0
    li a0, 0
    li a7, 63
    ecall

    ret

print:
    # INPUT #
    # a0 - buffer address
    # a1 - buffer size
    # OUTPUT #

    mv a2, a1
    mv a1, a0
    li a0, 1
    li a7, 64
    ecall

    ret 

.data
linha_1: .skip 0x4
linha_2: .skip 0x7
numero_saida: .skip 0x20
teste: .string "tacaralho"
eob: .string "\n "
fodase: .skip 0x4
check: .skip 0x4
