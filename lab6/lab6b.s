.section .text

.globl _start

_start:

    # What it currently does:
    # Reads input as string
    # Converts it to signed int
    # Prints signed int
    # Calcula distance certo
    # Calcula sqrt certo

    # Have to:
    # Compute the equation

    # Read whole line
    li a0, 0
    la a1, linha_1
    li a2, 12
    li a7, 63
    ecall

    # Convert first number
    mv a0, a1
    jal to_decimal_s

    # Saves By
    la t0, By
    sw a0, 0(t0)

    # Reads second number
    la a0, linha_1
    addi a0, a0, 6
    jal to_decimal_s

    # Save in Cx
    la t0, Cx
    sw a0, 0(t0)

    # Acabou de ler e processar os dados da linha 1
    # Passando pra linha 2

    li a0, 0
    la a1, linha_2
    li a2, 20
    li a7, 63
    ecall

    # Ler Ta
    la a0, linha_2
    jal to_decimal_u

    # Armazena Ta
    la t0, Ta
    sw a0, 0(t0)

    # Ler Tb
    la a0, linha_2
    addi a0, a0, 5
    jal to_decimal_u

    # Armazena Tb
    la t0, Tb
    sw a0, 0(t0)

    # Ler Tc
    la a0, linha_2
    addi a0, a0, 10
    jal to_decimal_u

    # Armazena Tc
    la t0, Tc
    sw a0, 0(t0)

    # Ler Tr
    la a0, linha_2
    addi a0, a0, 15
    jal to_decimal_u

    # Armazenar Tr
    la t0, Tr
    sw a0, 0(t0)

    # Leu todos os parâmetros do código

    # Argumentos pra distance
    la a1, Tr
    lw a1, 0(a1)
    la a2, velocidade
    lw a2, 0(a2)

    # Carrega Ta
    la a0, Ta
    lw a0, 0(a0)

    jal distance

    # Armazena Da
    la t0, Da
    sw a0, 0(t0)

    # Argumentos pra distance
    la a1, Tr
    lw a1, 0(a1)
    la a2, velocidade
    lw a2, 0(a2)

    # Carrega Tb
    la t0, Tb
    lw a0, 0(t0)

    jal distance

    # Armazena Db
    la t0, Db
    sw a0, 0(t0)

    # Argumentos pra distance
    la a1, Tr
    lw a1, 0(a1)
    la a2, velocidade
    lw a2, 0(a2)

    # Carrega Tc
    la a0, Tc
    lw a0, 0(a0)

    jal distance

    # Armazena Dc
    la t0, Dc
    sw a0, 0(t0)

    # Acabou de armazenar todas as distâncias

    la a0, Da
    lw a0, 0(a0)
    la a1, Db
    lw a1, 0(a1)
    la a2, By
    lw a2, 0(a2)

    jal calculate_y

    la t0, Y
    sw a0, 0(t0) # Armazena Y

    la a0, Da
    lw a0, 0(a0)
    la a1, Y
    lw a1, 0(a1)

    jal calculate_x

    la t0, X
    sw a0, 0(t0)

    jal to_string_s

    li a0, 1
    la a1, numero_saida
    li a2, 6
    li a7, 64
    ecall

    la a0, Y
    lw a0, 0(a0)

    jal to_string_s

    la a0, numero_saida
    li a1, 5
    jal print

    # Exit
    li a0, 0
    li a7, 93
    ecall

calculate_y:
    # INPUT #
    # a0 - Da
    # a1 - Db
    # a2 - Yb
    # OUTPUT #
    # a0 - Y

    mul t4, a0, a0 # Da^2
    mul t5, a1, a1 # Db^2
    mul t6, a2, a2 # Yb^2
    sub t4, t4, t5 # (Da^2) - (Db^2)
    add t4, t4, t6 # (Da^2) - (Db^2) + (Yb^2)

    li t5, 2
    mul t6, a2, t5 # 2.Yb

    div a0, t4, t6 # tudo/2Yb

    ret

calculate_x:
    # INPUT #
    # a0 - Da
    # a1 - Y
    # OUTPUT #
    # a0 - x

    mv s5, ra

    mul t4, a0, a0 # Da^2
    mul t5, a1, a1 # Y^2

    sub a0, t4, t5 # (Da^2) - (Y^2)

    jal sqrt # Sqrt (stuff)

    la a1, Y
    lw a1, 0(a1)
    la a2, Cx
    lw a2, 0(a2)
    la a3, Dc
    lw a3, 0(a3)
    jal compute_eq

    mv ra, s5

    ret

compute_eq:
    # INPUT #
    # a0 - X
    # a1 - Y
    # a2 - Xc
    # a3 - Dc
    # OUTPUT #
    # a0 - sqrt(da^2-y^2)

    mv s7, ra

    # For x (stored in t4)
    sub t4, a0, a2 # x - Xc
    mul t4, t4, t4 # (x - Xc)^2
    mul t5, a1, a1 # y^2
    add t4, t4, t5 # (x - Xc)^2 + y^2

    # For -x (stored in t5)
    li t5, -1
    mul t5, a0, t5 # -x
    sub t5, t5, a2 # (-x - Xc)
    mul t5, t5, t5 # (-x - Xc)^2
    mul t6, a1, a1 # y^2
    add t5, t5, t6 # (-x - Xc)^2 + y^2

    mul t6, a3, a3 # Dc^2

    mv s6, a0

    sub t4, t6, t4 # Diferença para x1 
    mv a0, t4
    jal mod
    mv t4, a0

    sub t5, t6, t5 # Diferença para x2
    mv a0, t5
    jal mod
    mv t5, a0

    bge t4, t5, 2f # Se d(x1) >= d(x2), então retornamos x2

    mv a0, s6
    mv ra, s7
    ret

2:
    li t4, -1
    mv a0, s6
    mul a0, a0, t4

    mv ra, s7
    ret
    
mod:
    # Retorna o módulo de um número
    # INPUT #
    # a0 - number
    # OUTPUT #
    # a0 - positive number

    li t3, 0x80000000
    bltu t3, a0, 1f # if unsigned a0 > 0x8000000, number is neg
    ret

1:
    li t3, -1
    mul a0, a0, t3
    ret

sqrt:
    # INPUT #
    # a0 - number
    # OUTPUT #
    # a0 - sqrt
    
    mv a1, a0
    li a7, 2
    div a0, a0, a7

    mv s4, ra
    li a7, 30

1:
    jal aprox
    addi a7, a7, -1
    bnez a7, 1b # Jumps if a7 != 0
    
    mv ra, s4

    ret

aprox:
    # INPUT #
    # a0 - guess
    # a1 - original number
    # OUTPUT #
    # a0 - next guess

    div t4, a1, a0
    add t4, t4, a0
    li t5, 2
    div a0, t4, t5

    ret

distance:
    # INPUT #
    # a0 - tempo
    # a1 - Tr (referencia)
    # a2 - velocidade
    # OUTPUT #
    # a0 - distancia

    sub t0, a1, a0
    mul a0, t0, a2
    li t0, 10
    div a0, a0, t0

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

to_decimal_u:
    # Converts an unsigned number to decimal as positive
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

to_decimal_s:
    # Converts a signed number with "+" or "-" at the
    # start to decimal
    # INPUT #
    # a0 - string address
    # OUTPUT #
    # a0 - number

    lb t3, 1(a0)
    addi t3, t3, -48
    li t4, 1000
    mul t3, t3, t4
    mv t5, t3

    lb t3, 2(a0)
    addi t3, t3, -48
    li t4, 100
    mul t3, t3, t4
    add t5, t5, t3

    lb t3, 3(a0)
    addi t3, t3, -48
    li t4, 10
    mul t3, t3, t4
    add t5, t5, t3

    lb t3, 4(a0)
    addi t3, t3, -48
    add t5, t5, t3


    # Check if pos or neg
    li t0, 45 # ascii for "-"
    lb t1, 0(a0)
    beq t0, t1, 1f

    mv a0, t5

    ret

1:
    mv a0, t5
    li t0, -1
    mul a0, a0, t0

    ret

to_string_u:
    # INPUT #
    # a0 - number
    # OUTPUT #
    # Converts number to string

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

to_string_s:
    # INPUT #
    # a0 - number
    # OUTPUT #
    # Converts number to string with "+" or "-" at the start
    # and " " at the end

    la a1, numero_saida
    li t3, 0x80000000

    bltu t3, a0, neg # if unsigned a0 > 0x8000000, number is neg
    li t3, 43 # ascii for "+"
    sb t3, 0(a1)
    j num
    
neg:
    li t3, 45 # ascii for "-"
    sb t3, 0(a1)
    li t3, -1
    mul a0, a0, t3

num:

    li t5, 1000
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 1(a1)

    rem a0, a0, t5

    li t5, 100
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 2(a1)

    rem a0, a0, t5

    li t5, 10
    div t3, a0, t5
    addi t3, t3, 48
    sb t3, 3(a1)

    rem a0, a0, t5

    mv t3, a0
    addi t3, t3, 48
    sb t3, 4(a1)

    li t3, 32 # Space in ascii
    sb t3, 5(a1)
     
    ret

.section .data
linha_1: .skip 0xc
linha_2: .skip 0x14
numero_saida: .skip 0x6
By: .skip 0x4
Cx: .skip 0x4
Tr: .skip 0x4
Ta: .skip 0x4
Tb: .skip 0x4
Tc: .skip 0x4
Da: .skip 0x4
Db: .skip 0x4
Dc: .skip 0x4
X: .skip 0x4
Y: .skip 0x4
velocidade: .word 3
eol: .string "\n"
