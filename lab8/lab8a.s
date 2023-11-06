.text
.globl _start

_start:

    li a0, 10
    li a1, 10
    li a7, 2201
    ecall

    jal open

    la a0, input_address
    li a1, 12
    jal read

    li a0, 10
    li a1, 10
    jal read_image

    # Exit
    li a0, 0
    li a7, 93
    ecall

read_image:
    # INPUT #
    # a0 - number of rows #
    # a1 - number of columns #
    # OUTPUT #

    # Armazena os parametros

    addi sp, sp, -4
    sw ra, 0(sp)

    mv s4, a0
    mv s5, a1
    li t0, 0

1:

    mv a1, s5           # Numero de colunas
    mv a2, t0           # Linha atual
    jal read_row        # Le a linha

    addi t0, t0, 1      # Incrementa um no loop counter
    bne t0, s4, 1b      # Continua enquanto t0 != s4

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

read_row:
    # Reads and prints the pixels of one row
    # INPUT #
    # a1 - row size #
    # a2 - current row #
    # OUTPUT #

    # Salva os parametros e seta t3 = 0 para iniciar o loop
    mv s1, a1
    mv s2, a2
    li t3, 0

    la a0, fd           # File descriptor
    mv a2, a1           # Numero de bytes
    la a1, input_address# Endereço do coiso
    li a7, 63
    ecall

1:
    add t4, s0, t3      # Endereço inicial + loop counter
    lbu t4, 0(t4)       # Carrega o número

    mv a0, t3           # x
    mv a1, s2           # y
    mv a2, t4           # Valor pixel
    li a7, 2200
    ecall
    
    addi t3, t3, 1      # incrementa loop counter
    bne t3, a1, 1b
    ret



processa_linha:
    # INPUT #
    # a0 - buffer address #
    # a1 - width #
    # OUTPUT #

    li t0, 0        # Contador do loop
    
1:
    

    bne t0, a1, 1b



to_decimal:
    # INPUT #
    # a0 - address #
    # a1 - size #
    # OUTPUT #
    # a0 - number #

    add t0, a0, a1 # comecando pela unidade: a0 + a1 - 1
    li t1, 1    # Multiplicador
    li t4, 10   # steps do multiplicador
    li t3, 0    # acumulador

1:
    addi t0, t0, -1     # prox. posição
    lb t2, 0(t0)        # carrega o byte
    addi t2, t2, -48    # converte pra decimal
    mul t2, t2, t1      # multiplica pela casa 
    add t3, t3, t2      # soma no valor

    mul t1, t1, t4      # multiplica por 10

    bne t0, a0, 1b      # Quando t0 == a0, terminamos

    mv a0, t3
    ret

print:
    # INPUT #
    # a0 - buffer address #
    # a1 - number of character #
    # OUTPUT #

    mv a2, a1
    mv a1, a0
    li a0, 1
    li a7, 64
    ecall
    ret

read:
    # INPUT #
    # a0 - buffer address #
    # a1 - number of character #
    # OUTPUT #
    mv a2, a1
    mv a1, a0
    la a0, fd
    li a7, 63
    ecall
    ret

open:
    # INPUT #
    # OUTPUT #
    la a0, input_file
    li a1, 0
    li a2, 0
    li a7, 1024
    ecall

    sw a0, fd, t0
    ret

.data
input_file: .asciz "image.pgm"
header_address: .skip 0xc
fd: .skip 0x4
height: .skip 0x4
width: .skip 0x4
input_address: .skip 0x100

