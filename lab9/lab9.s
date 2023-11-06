.text

.globl _start

_start:

    # Read number
    la a0, input_buffer
    jal read

    # Convert to decimal
    mv a1, a0
    la a0, input_buffer
    jal to_decimal_s

    mv a1, a0
    la a0, head_node
    jal find_node

    # Print number
    la a1, input_buffer
    jal to_string_s


    mv a2, a0
    la a1, out_buffer
    li a0, 1
    li a7, 64
    ecall
   
    # exit
    li a0, 0
    li a7, 93
    ecall

find_node:
    # INPUT # # a0 - head node #
    # a1 - number #
    # OUTPUT #
    # a0 - node index #

    mv t3, a0
    li t5, 1
    li t6, 0        # Node index

    # Save ra in stack
    addi sp, sp, -4      
    sw ra, 0(sp)

node_loop:
    mv a0, t3
    jal is_node
    beq a0, t5, found   # If is node: return with index
    lw t3, 8(t3)        # Load next node

    beqz t3, null       # If node is null, end

    addi t6, t6, 1      # Increment node index
    j node_loop         # Go to beggining of loop

null:
    # If is null then we reached the end of the list without a match
    li t6, -1
    
found:
    # Load ra from stack
    lw ra, 0(sp)
    addi sp, sp, 4

    mv a0, t6
    ret

is_node:
    # INPUT #
    # a0 - node #
    # a1 - number #
    # OUTPUT #
    # a0 - 1 if yes, -1 if no #
    
    lw t0, 0(a0)
    lw t1, 4(a0)
    add t0, t0, t1
    mv a0, t0

    beq a0, a1, true
    li a0, 0

    ret

true:
    li a0, 1
    ret


read:
    # Reads until encounters a '\n'
    # Max size: 16
    # INPUT #
    # a0 - buffer #
    # OUTPUT #
    # a0 - number of bytes read #

    mv t0, a0
    li a0, 0
    mv a1, t0
    li a2, 16
    li a7, 63

    ecall

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
    bge t1, a2, 2b      # If the second pointer is lass than the start

next:
    li t1, 10           # Ascii for '\n'
    add t0, a2, a1
    sb t1, 0(t0)        # Appends '\n'

    addi a1, a1, 1

    ret



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

    sub a0, t3, a1      # Size = last - first + 1
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

to_decimal_s:
    # Converts a signed number with "+" or "-" at the
    # start to decimal
    # Registradores #
    # t0 - current pos #
    # t1 - last pos #
    # t2 - current multiplier #
    # t3 - 10 #
    # t4 - current character read #
    # a0 - resultado #
    # INPUT #
    # a0 - string address
    # a1 - size (has to be bigger than 0)
    # OUTPUT #
    # a0 - number

    # Check if pos or neg
    li t0, 45 # ascii for "-"
    lb t1, 0(a0)
    sub t1, t0, t1

    # t1 = 0 if num is positive
    # t1 = 1 if num is negative
    seqz t5, t1
    add t1, a0, t5

    mv t0, a0
    add t0, t0, a1
    addi t0, t0, -2         # Last position

    li t2, 1                # Casa inicial
    li t3, 10               # Multiplicador a cada digito

    li a0, 0

loop:
    lb t4, 0(t0)            # Le o caracter
    addi t4, t4, -48        # Converte de ascii
    mul t4, t4, t2          # Multiplica pela casa
    add a0, a0, t4          # Soma no resultado

    mul t2, t2, t3          # Aumenta a casa 
    addi t0, t0, -1         # Decrementa loop ctr
    blt t0, t1, loop_end
    j loop

loop_end:
    beqz t5, pos
    li t0, -1
    mul a0, a0, t0

pos:
    ret

.data
    input_buffer: .skip 0x20
    out_buffer: .skip 0x20
    scratch_buffer: .skip 0x20
