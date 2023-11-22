.text
.set write_flag, 0xFFFF0100
.set write_byte, 0xFFFF0101
.set read_flag, 0xFFFF0102 
.set read_byte, 0xFFFF0103
.align 16

.globl _start

_start:

    # Read first line
    la a0, buffer
    jal read

    la a0, buffer
    lb a3, 0(a0)
    addi a3, a3, -48
    addi a0, a0, 2      # Increment buffer addr by 2

    jal read
    jal do_operation

    jal exit

do_operation:
    # INPUT #
    # a0 - buffer address #
    # a1 - buffer size #
    # a2 - operation #
    # OUTPUT #

    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 1
    beq t0, a3, op_1

    li t0, 2
    beq t0, a3, op_2

    li t0, 3
    beq t0, a3, op_3

    li t0, 4
    beq t0, a3, op_4

op_1:
    jal write
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

op_2:
    addi a1, a1, -1
    jal invert_string
    jal write
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

op_3:
    jal atoi
    la a1, buffer
    li a2, 16
    jal itoa
    jal write
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
op_4:
    # TODO prints nothing
    mv s7, a0           # Buffer address
    jal atoi
    mv s6, a0           # First number in decimal

    # WHY
    la a1, buffer
    li a2, 10
    jal itoa

    jal which_operation
    mv s5, a0           # Operation to be done

    mv a0, a1           # Adress of second number
    jal atoi
    mv s4, a0           # Second number in decimal

    mv a0, s6
    mv a1, s4
    mv a2, s5
    jal calculate       # Calculate result

    la a1, buffer
    li a2, 10
    
    jal itoa            # Convert result to str
    jal write           # Write result

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

calculate:
    # INPUT #
    # a0 - number 1 #
    # a1 - number 2 #
    # a2 - op number #
    # OUTPUT #
    # a0 - result #

    li t0, 1
    beq a2, t0, do_sum
    li t0, 2
    beq a2, t0, do_neg
    li t0, 3
    beq a2, t0, do_mul
    li t0, 4
    beq a2, t0, do_div

do_sum:
    add a0, a0, a1
    ret

do_neg:
    div a0, a0, a1
    ret

do_mul:
    mul a0, a0, a1
    ret

do_div:
    div a0, a0, a1
    ret

which_operation:
    # Finds out what operation to do and the address #
    # of the second number #
    # INPUT #
    # a0 - buffer address #
    # OUTPUT #
    # a0 - operation (1 to 4) #
    # a1 - second number address #

    li t0, 43       # 1 - '+'
    li t1, 45       # 2 - '-'
    li t2, 42       # 3 - '*'
    li t3, 47       # 4 - '/'

    mv a1, a0       # Current address

1:
    lb t4, 0(a1)    # Load current char

    beq t0, t4, plus_op
    beq t1, t4, minus_op
    beq t2, t4, multiply_op
    beq t3, t4, divide_op
    addi a1, a1, 1
    j 1b

plus_op:
    li a0, 1
    addi a1, a1, 2
    ret

minus_op:
    li a0, 2
    addi a1, a1, 2
    ret

multiply_op:
    li a0, 3
    addi a1, a1, 2
    ret

divide_op:
    li a0, 4
    addi a1, a1, 2
    ret

read:
    # INPUT #
    # a0 - buffer address #
    # OUTPUT #
    # a0 - buffer address #
    # a1 - size of buffer #

    # VARIABLES #
    # t2 - holds 10 ('\n') #
    # a1 - holds the string count #

    # Initialize variables
    li a1, 0
    li t2, 10

read_char:
    # Request one char
    li t0, read_flag
    li t1, 1
    sb t1, 0(t0)

1:
    lb t1, 0(t0)        # Reread byte
    # If t1 == 0, then the char is at read_byte
    beqz t1, load_char
    j 1b

load_char:
    li t0, read_byte
    lb t1, 0(t0)
    add t3, a1, a0      # Address of current char
    sb t1, 0(t3)        # Store char in buffer
    addi a1, a1, 1      # Increment size of buffer

    beq t1, t2, end_read    # If char == '\n', ret
    j read_char             # Else, continue

end_read:
    ret

write:
    # INPUT #
    # a0 - buffer address #
    # OUTPUT #

    # VARIABLES #
    # t0 - counter #
    # t1 - address #
    # t6 - 1 (constant) #

    # Initialize variables
    li t0, 0
    li t1, write_flag
    li t5, 10
    li t6, 1

    # Puts the char in byte and sets flag
write_char:
    add t1, a0, t0          # Address of current char
    lb t2, 0(t1)            # Read char
    li t1, write_byte       # Address of write_byte
    sb t2, 0(t1)            # Put char in write byte
    li t1, write_flag       # Get address of write_flag
    sb t6, 0(t1)            # Signal that char should be written

    # Waits for write to complete
1:
    lb t3, 0(t1)
    beqz t3, check
    j 1b

    # Checks if char is '\n'
check:
    addi t0, t0, 1          # Increment counter
    bne t2, t5, write_char
    ret

invert_string:
    # Inverts a string given a start address and a size #
    # Inverts in place without using a secondary buffer #
    # INPUT #
    # a0 - string address #
    # a1 - string size #
    # OUTPUT #
    # a0 - string address #

    mv t0, a0           # First position
    add t1, a0, a1      
    addi t1, t1, -1     # Last position
    li t4, 2
    div t4, a1, t4
    add t4, t0, t4      # Middle position

1:
    lb t2, 0(t0)        # Read byte from position 1
    lb t3, 0(t1)        # Read byte from position 2 
    sb t2, 0(t1)        # Store first byte into position 2
    sb t3, 0(t0)        # Store second byte into position 1

    addi t0, t0, 1      # position 1 + 1
    addi t1, t1, -1     # position 2 - 1

    bge t1, t4, 1b

    ret

exit:
    # INPUT #
    # a0 - return code #
    # OUTPUT #

    li a7, 93
    ecall

itoa:
    # Converts a signed integer (base 10) or unsigned integer #
    # (base 16) to a null terminated string. If the number is #
    # negative is displayed with a '-' at the start #
    # INPUT #
    # a0 - number #
    # a1 - string where to store the result #
    # a2 - base #
    # OUTPUT #
    # a0 - string where number is stored #

    # Save string address and ra in stack
    addi sp, sp, -8
    sw a1, 4(sp)
    sw ra, 0(sp)

    li t0, 16
    beq a2, t0, base_16     # If base 16
    # Else base 10:
    li t0, 0x80000000
    bltu t0, a0, itoa_neg # if unsigned a0 > 0x8000000, number is neg

base_10:
    mv t0, a1       # Current position
    li t1, 0        # Current size
    li t2, 10       # Multiplier

1:
    rem t4, a0, t2  # a0 % 10
    addi t4, t4, 48 # ascii
    sb t4, 0(t0)    # store byte

    addi t0, t0, 1  # next position
    div a0, a0, t2  # a0 / 10
    bnez a0, 1b     # if a0 != 0, continue

    j end_itoa

itoa_neg:
    li t0, 45       # ascii for minus
    sb t0, 0(a1)    # Store - in first position
    addi a1, a1, 1  # From here consider that the string starts at index 1
    li t0, -1
    mul a0, a0, t0  # Consider number as positive
    j base_10

base_16:
    mv t0, a1       # Current position
    li t1, 0        # Current size
    li t2, 16       # Multiplier
    li t5, 10       # Reference

1:
    rem t4, a0, t2      # a0 % 16 = current number
    bge t4, t5, letter  # If its a letter
    addi t4, t4, 48     # Else, add 48 to get ascii
    j 2f

letter:
    addi t4, t4, 55     # 'a' = 97

2:
    sb t4, 0(t0)        # Store character in current pos
    addi t0, t0, 1      # Increment position
    div a0, a0, t2      # a0 / 16
    bnez a0, 1b         # If a0 != 0, continue

end_itoa:
    
    li t1, 10
    sb t1, 0(t0)      # null-terminated string
    mv a0, a1           # a1 is the first byte
    sub a1, t0, a1      # t0 - a1 = size
    jal invert_string

    # Reset stack
    lw ra, 0(sp)
    lw a0, 4(sp)        # Load string address
    addi sp, sp, 8
    ret

atoi:
    # Converts a string ended in ' ' or '\n' to an int #
    # The string may only contain alphanumeric digits #
    # and the '+' or '-' symbols at the start #
    # REGISTERS #
    # t6 - whether number is negative (-1) or positive (1) #
    # INPUT #
    # a0 - null terminated buffer #
    # OUTPUT #
    # a0 - (signed?) int #

    # Save ra in stack
    addi sp, sp, -8
    sw a0, 4(sp)
    sw ra, 0(sp)

    li t6, 1            # Default case is positive
    
    lb t0, 0(a0)        # Loads first byte
    li t1, 43           # Ascii for '+'
    beq t0, t1, plus_sign

    li t1, 45           # Ascii for '-'
    beq t0, t1, minus_sign 
    j atoi_start         # If there is no sign, just start the loop
    
plus_sign:              # If there is a plus sign, t6 is already
    addi a0, a0, 1      # 1, so just increment starting position
    sw a0, 4(sp)
    j atoi_start

minus_sign:             # If minus sign: set t6 to -1 and increment
    addi a0, a0, 1      # starting position
    sw a0, 4(sp)
    li t6, -1

atoi_start:
    # start of function
    li t3, 10           # multiplier
    li t4, 1            # current index
    jal str_end
    mv t1, a0           # End of string
    lw t0, 4(sp)
    li a0, 0            # Set current result to 0

    # Goes from least significant to most significant
    # right to left, last to first
    # main function loop
atoi_loop:
    lb t2, 0(t1)        # Load current byte
    addi t2, t2, -48    # Convert to decimal
    mul t2, t2, t4      # Multiply by position
    add a0, a0, t2      # Sum to current result
    addi t1, t1, -1     # Go to previous byte
    mul t4, t4, t3      # Multiply position by 10
    bge t1, t0, atoi_loop 

    # Load ra from stack and return
    lw ra, 0(sp)
    addi sp, sp, 8

    mul a0, a0, t6      # Multiply result by its sign
    ret

str_end:
    # Returns the address of the last character before a space #
    # Or '\n' Or null character #
    # in a null terminated string #
    # INPUT #
    # a0 - null terminated string #
    # OUTPUT #
    # a0 - address of last character #

    li s1, 32
    li s2, 10

1:
    lb t0, 0(a0)        # Loads current byte
    beq t0, s1, 2f      # If current byte is 0x20 (space), end function
    beq t0, s2, 2f
    beqz t0, 2f
    addi a0, a0, 1      # Else go to next byte
    j 1b

2:
    addi a0, a0, -1     # We want the first character before the null byte
    ret

.data
.bss
buffer: .skip 0x80
