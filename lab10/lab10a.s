.text

.globl linked_list_search
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

linked_list_search:
    # ABI Compliant linked list search #
    # INPUT #
    # a0 - Head node #
    # a1 - value #
    # OUTPUT #
    # a0 - index of value #
    mv t0, a0
    li t1, 0        # Current node index

node_loop:
    lw t2, 0(t0)        # Val 1
    lw t3, 4(t0)        # Val 2
    add t2, t2, t3      # Val 1 + Val 2
    beq t2, a1, found   # If is node
    
    addi t1, t1, 1      # Next index
    lw t0, 8(t0)        # Load next node
    beqz t0, not_found  # If node is null, then value was not found
    j node_loop

not_found:
    li a0, -1
    ret

found:
    mv a0, t1
    ret

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
    addi t4, t4, 55     # 'A' = 65

2:
    sb t4, 0(t0)        # Store character in current pos
    addi t0, t0, 1      # Increment position
    div a0, a0, t2      # a0 / 16
    bnez a0, 1b         # If a0 != 0, continue

end_itoa:
    
    sb zero, 0(t0)      # null-terminated string
    mv a0, a1           # a1 is the first byte
    sub a1, t0, a1      # t0 - a1 = size
    jal invert_string

    # Reset stack
    lw ra, 0(sp)
    lw a0, 4(sp)        # Load string address
    addi sp, sp, 8
    ret

invert_string:
    # Inverts a string given a start address and a size #
    # Inverts in place without using a secondary buffer #
    # Does not append a '\0' at the end of the string #
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

    
atoi:
    # Converts a null terminated string to an int #
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
    # Returns the address of the last non-null character #
    # in a null terminated string #
    # INPUT #
    # a0 - null terminated string #
    # OUTPUT #
    # a0 - address of last character #

1:
    lb t0, 0(a0)        # Loads current byte
    beqz t0, 2f         # If current byte is 0x0 (null), end function
    addi a0, a0, 1      # Else go to next byte
    j 1b

2:
    addi a0, a0, -1     # We want the first character before the null byte
    ret

gets:
    # Reads characters from stdin and stores in buffer until
    # a newline character or eof is found.
    # The newline character is not copied into string
    # A terminating null character is automatically appended
    # after the characters copied into buffer.
    # INPUT #
    # a0 - buffer #
    # OUTPUT #
    # a0 - buffer #

    addi sp, sp, -4
    sw a0, 0(sp)

    mv t0, a0
    li t2, 10           # Ascii for '\n' to be used as reference for comparison


gets_loop:
    # Read exactly one byte into t0 (current buffer index)
    li a0, 0
    mv a1, t0
    li a2, 1
    li a7, 63
    ecall

    lb t1, 0(t0)            # Loads current byte
    beq t1, t2, end_gets    # If byte is '\n', substitute with \0 and end function
    beqz t1, end_gets       # If byte is '\0', do the same
    addi t0, t0, 1           # Else, read next byte
    j gets_loop

end_gets:
    sb zero, 0(t0)          # Store null character in current position

    # Reset stack
    lw a0, 0(sp)
    addi sp, sp, 4
                    
    ret


puts:
    # Writes the buffer to stdout and appends a '\n' at the end #
    # The buffer must be null terminated #
    # Should use a temporary buffer #
    # INPUT #
    # a0 - buffer #
    # OUTPUT #
    # a0 - return value (error if a0 < 0) #

    mv t0, a0           # Current index
    la t2, temp

puts_loop:

    lb t1, 0(t0)        # Read current byte
    sb t1, 0(t2)        # Store in temp buffer
    beqz t1, newline    # If not null character, continue
    addi t0, t0, 1      # Next index
    addi t2, t2, 1 
    j puts_loop

newline:
    li t1, 10           # Newline in ascii
    sb t1, 0(t2)        # Stores newline in temp buffer only
    addi t2, t2, 1      # Adds 1 

    li a0, 1            # Stdout
    la a1, temp    # 
    sub a2, t2, a1      # Size of buffer
    li a7, 64
    ecall

    ret

exit:
    # INPUT #
    # a0 - return code #
    # OUTPUT #

    li a7, 93
    ecall

.data 
    # 0x3e8 = 1000 bytes
    temp: .skip 0x3e8
    test_str: .skip 0x3e8
