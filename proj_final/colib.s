# Control Library #
# Implements all the functions defined in control_api.h #
# through syscalls defined in acos.h #

.text
# int set_engine(int vertical, int horizontal);
.globl set_engine

set_engine:
	# INPUT #
	# a0 - vertical #
	# a1 - horizontal #
	# OUTPUT #
	# a0 - return code #

	li a7, 10
	ecall
	ret

# int set_handbrake(char value);
.globl set_handbrake

set_handbrake:
	# INPUT #
	# a0 - value #
	# OUTPUT #
	# a0 - return code #

	beqz a0, 1f
	li t0, 1
	beq a0, t0, 1f
	li a0, -1
	ret

1:
	li a7, 11
	ecall

	li a0, 0
	ret

# int read_sensor_distance();
.globl read_sensor_distance

read_sensor_distance:
	# INPUT #
	# OUTPUT #
	# a0 - distance of closest object #

	li a7, 13
	ecall
	ret


# void get_position(int* x, int* y, int* z);
.globl get_position

get_position:
	# INPUT #
	# a0 - &x #
	# a1 - &y #
	# a2 - &z #
	# OUTPUT #

	li a7, 14
	ecall
	ret

# void get_rotation(int* x, int* y, int* z);
.globl get_rotation

get_rotation:
	# INPUT #
	# a0 - &x #
	# a1 - &y #
	# a2 - &z #
	# OUTPUT #

	li a7, 15
	ecall
	ret

# unsigned int get_time();
.globl get_time

get_time:
	# INPUT #
	# OUTPUT #
	# a0 - system time #

	li a7, 16
	ecall
	ret

# void puts ( const char *str );
.globl puts

puts:
	# INPUT #
	# a0 - &str #
	# OUTPUT #

	addi sp, sp, -8
	sw a0, 4(sp)
	sw ra, 0(sp)

	jal strlen_custom

	mv a1, a0			# Size -> a1
	lw a0, 4(sp)		# &str -> a0

	li t0, '\n'			# '\n' ascii
	add t1, a0, a1		
	sb t0, 0(t1)
	addi a1, a1, 1

	li a7, 18
	ecall

	lw ra, 0(sp)
	addi sp, sp, 8

	ret

# char *gets ( char *str );
.globl gets

gets:
	# TODO 
	# sei que o erro ta na gets, ou read_serial
	# Tem que confirmar, pq a read_serial nao deveria armazenar o '\0'
	# na string, ela deveria retornar 0, por exemplo, e a gets adicionaria
	# o '\0' no final da string

	# INPUT #
	# a0 - &str #
	# OUTPUT #

	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)

next_char:
	sw a0, 8(sp)
	li a1, 1
	li a7, 17
	ecall

	lw a0, 8(sp)			# Endereço atual
	lb t0, 0(a0)			# Char atual
	beqz t0, end_gets		# Se t0 == 0, cabou
	addi a0, a0, 1			# Proximo char
	j next_char

end_gets:
	lw ra, 0(sp)
	addi sp, sp, 12

	ret

# int atoi (const char *str);
.globl atoi

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

# char *itoa ( int value, char *str, int base );
.globl itoa

itoa:
    # Converts a signed integer (base 10) or unsigned integer #
    # (base 16) to a null terminated string. If the number is #
    # negative is displayed with a '-' at the start #
    # INPUT #
    # a0 - value #
    # a1 - &str #
    # a2 - base #
    # OUTPUT #
    # a0 - &str #

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
    addi t4, t4, 87     # 'a' = 97

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

# int strlen_custom( char *str );
.globl strlen_custom

strlen_custom:
	# INPUT #
	# a0 - &str #
	# OUTPUT #
	# a0 - str size #

	# Inicia contador
	li t0, -1

1:
	addi t0, t0, 1			# t0++
	addi a0, a0, 1			# a0++
	lb t1, 0(a0)			# *a0 -> t1
	bnez t1, 1b				# If t1 == 0, cabo

	mv a0, t0
	ret

# int approx_sqrt(int value, int iterations);
.globl approx_sqrt

approx_sqrt:
	# INPUT #
	# a0 - value #
	# a1 - iterations #
	# OUTPUT #
	# a0 - sqrt #


	li t3, 0					# Contador
	mv t0, a0					# x -> t0
    li t1, 2
    div t1, a0, t1				# x / 2	-> t1
	
1:
    div t4, t0, t1				# X / x -> t4
    add t4, t4, t1				# (X / x) / x -> t4
    li t5, 2
    div t1, t4, t5				# (X / x) / (x*2) -> x

	addi t3, t3, 1
	bne t3, a1, 1b

	mv t1, a0

    ret

# int get_distance(int x_a, int y_a, int z_a, int x_b, int y_b, int z_b);
.globl get_distance

get_distance:
	# INPUT #
	# a0 - x_a #
	# a1 - y_a #
	# a2 - z_a #
	# a3 - x_b #
	# a4 - y_b #
	# a5 - z_b #
	# OUTPUT #
	# a0 - sqrt((x_a - x_b)^2+(y_a - y_b)^2+(z_a - z_b)^2)

	addi sp, sp, -4
	sw ra, 0(sp)

	sub t0, a0, a3
	sub t1, a1, a4
	sub t2, a2, a5

	mul t0, t0, t0
	mul t1, t1, t1
	mul t2, t2, t2

	add t0, t0, t1
	add t0, t0, t2

	mv a0, t0
	li a1, 50

	jal approx_sqrt

	lw ra, 0(sp)
	addi sp, sp, 4

	ret

# Node *fill_and_pop(Node *head, Node *fill);
.globl fill_and_pop
# TODO
# Confirmar representação binária de enum (acho que é int) e
# ponteiro (acho que é unsigned int), as duas ocupando 4 bytes

fill_and_pop:
	# INPUT #
	# a0 - &Head #
	# a1 - &Fill #
	# OUTPUT #
	# a0 - &(Head->Next) #

	lw t0, 0(a0)			#  x
	sw t0, 0(a1)
	lw t0, 4(a0)			# y
	sw t0, 4(a1)
	lw t0, 8(a0)			# z
	sw t0, 8(a1)
	lw t0, 12(a0)			# a_x
	sw t0, 12(a1)
	lw t0, 16(a0)			# a_y
	sw t0, 16(a1)
	lw t0, 20(a0)			# a_z
	sw t0, 20(a1)
	lw t0, 24(a0)			# enum Action
	sw t0, 24(a1)
	lw t0, 28(a0)			# Head -> Next
	sw t0, 28(a1)

	mv a0, t0
	ret
