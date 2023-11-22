# Autonomous Car Operating System #

# Implementa a lógica de boot do sistema: #
# Habilitar Interrupções #
# Rodar o código de controle em modo de usuário #
# Implementa todas as syscalls de interface com o hardware #

.text

# Ponto de entrada do código
.globl _start
# Função main em colo.c
.globl main

_start:
    # Inicialização do sistema, interrupções
    # e stacks de usuário e de interrupção

    # Pilha de interrupções
    la t0, system_stack_end         # sys_stack -> t0
    csrw mscratch, t0               # t0 -> mscratch

    # Habilita interrupções externas
    csrr t1, mie                    # mie -> t1
    li t2, 0x800                    # 0x800 -> t2
    or t1, t1, t2                   # t1 || t2 -> t1
    csrw mie, t1                    # t1 -> mie

    # Habilita interrupções globais
    csrr t1, mstatus                # mstatus -> t1
    ori t1, t1, 0x8                 # t1 || 0x8 -> t1
    csrw mstatus, t1                # t1 -> mstatus

    # Rotina de tratamento de interrupção
    la t0, int_handler              # &int_handler -> t0
    csrw mtvec, t0                  # t0 -> mtvec

    # Muda o modo para usuário
    csrr t1, mstatus                # mstatus -> t1
    li t2, ~0x1800                  # t2 -> ~0x1800
    and t1, t1, t2                  # t1 && ~0x1800 -> t1
    csrw mstatus, t1                # t1 -> mstatus

    # Configurar a entrada do código do usuário
    la t0, main                     # &main -> t0
    csrw mepc, t0                   # t0 -> mepc

    # Carrega a pilha do usuário
    la sp, user_stack               # &user_stack -> sp

    # Vai pro código do usuário
    mret

int_handler:
	# Rotina de tratamento das interrupções

    # Salva os valores na pilha de interrupção

    csrrw sp, mscratch, sp          # sp <-> mscratch
    addi sp, sp, -64
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    sw a1, 28(sp)
    sw a2, 32(sp)
	sw a7, 36(sp)
	sw ra, 40(sp)

    # Identifica a syscall e chama ela

    csrr t0, mepc                   # (&ecall) - endereço da ecall que gerou a interrupção
    addi t0, t0, 4                  # (&ecall + 4) - instrução seguinte a ecall
    csrw mepc, t0                   # (&ecall + 4) -> mepc

	addi a7, a7, -10			# a7 - 10 -> a7
	slli a7, a7, 2				# a7 * 4 -> a7
	la t0, lookup_table			# &lut -> t0
	add a7, a7, t0				# a7 + t0 -> a7
	lw a7, 0(a7)				# Carrega endereço da label correspondente
	jalr a7						# Chama a função de tratamento de interrupção

	# Recupera os valores dos registradores

	lw ra, 40(sp)
	lw a7, 36(sp)
    lw a2, 32(sp)
    lw a1, 28(sp)
	lw t6, 24(sp)
    lw t5, 20(sp)
    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 64

    # Retorna à pilha do usuário
    csrrw sp, mscratch, sp          # sp <-> mscratch

    mret

# ----- System calls ----- #

Syscall_set_engine_and_steering:
    # Controla o motor e o volante #
    # Retorna 0 se os valores passados são válidos #
    # E -1 caso contrário #
    # Code - 10 #
    # INPUT #
    # a0 - Movement direction (-1/0/1) #
    # a1 - Steering wheel angle (-127 - 127)#
    # OUTPUT #
    # a0 - status code (0/-1)#

    # If a0 > 1
    li t0, 1
    bgt a0, t0, error

    # If a0 < -1
    li t0, -1
    blt a0, t0, error

    # If a1 > 127
    li t0, 127
    bgt a1, t0, error

    # If a1 < -127
    li t0, -127
    blt a1, t0, error
    
    # Se os valores forem válidos, executa a função
    la t0, car_engine               # &car_engine -> t0
    sb a0, 0(t0)                    # a0 -> t0

    la t1, car_wheel                # &car_wheel -> t1
    sb a1, 0(t1)                    # a1 -> t1

    li a0, 0
	ret

error:
    li a0, -1
	ret


Syscall_set_handbrake:
    # Controla o freio de mão do carro #
	# Retorna 0 se o valor for válido e -1 c.c. #
    # Code - 11 #
    # INPUT #
    # a0 - 1 if handbrake must be set #
    # OUTPUT #

    li t0, 1	
    beq a0, t0, set_handbrake       # Se a0 == 1, executa
	beqz a0, set_handbrake			# Se a0 == 0, executa
	li a0, -1

	ret
    
set_handbrake:
    la t0, car_handbreak            # &car_handbreak -> t0
    sb a0, 0(t0)                    # a0 -> t0
	li a0, 0

	ret


Syscall_read_sensors:
    # Lê um vetor de 256 bytes de luminosidade e armazena no #
    # endereço dado #
    # Code - 12 #
    # INPUT #
    # a0 - address of 256 byte buffer #
    # OUTPUT#

    # Armazena o endereço do vetor
    addi sp, sp, -4
    sw a0, 0(sp)

    # Pede a leitura do sensor
    la t0, car_camera_flag              # &camera_flag -> t0
    li t1, 1                            
    sb t1, 0(t0)                        # 1 -> &t0

1:
    # Espera a operação ser completada
    lb t1, 0(t0)
    bnez t1, 1b

    # Posição inicial do vetor
    la t0, car_camera_image
    # Posição final
    addi t2, t0, 256

1:
    # Lê 4 bytes
    lw t1, 0(t0)
    # Armazena 4 bytes
    sw t1, 0(a0)

    # Próximos 4 bytes
    addi t0, t0, 4
    addi a0, a0, 4

    # Se t0 < t2, continue
    blt t0, t2, 1b

    # Retorna o início do vetor
    # Essa parte não é necessário já que a função não precisa retornar nada
    lw a0, 0(sp)
    addi sp, sp, 4

	ret


Syscall_read_sensor_distance:
    # Realiza a leitura do sensor ultrassônico, que retorna #
    # a distância do objeto mais próximo (m) até 20 metros #
    # Se nenhum objeto for encontrado, o sensor retorna -1 #
    # Essa função não requer nenhum tipo de "processamento" #
    # Visto que não possui entrada e a saída do sensor é sempre #
    # válida #
    # Code - 13 #
    # INPUT #
    # OUTPUT #
    # a0 - valor da leitura #

    # Pede a leitura do sensor
    la t0, car_ultrasonic_flag              # &ultrasonic_flag -> t0
    li t1, 1
    sb t1, 0(t0)                            # 1 -> &t0

1:
    # Espera a operação ser completada
    lb t1, 0(t0)
    bnez t1, 1b

	# Carrega a leitura em a0
    la t0, car_ultrasonic_nearest           # &ultrasonic_nearest -> t0
    lw a0, 0(t0)                            # t0 -> a0

	ret


Syscall_get_position:
    # Retorna a posição do carro nos eixos x, y e z #
    # INPUT #
    # a0 - &x #
    # a1 - &y #
    # a2 - &z #
    # OUTPUT #

    # Pede a leitura do gps
    la t0, car_gps_flag                 # &gps_flag -> t0
    li t1, 1
    sb t1, 0(t0)                        # 1 -> &t0

1:
    # Espera a leitura
    lb t1, 0(t0)
    bnez t1, 1b

    # Read x position
    la t0, car_gps_x_axis               # &gps_x_axis -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a0)                        # t1 -> &a0
  
    # Read y position
    la t0, car_gps_y_axis               # &gps_y_axis -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a1)                        # t1 -> &a1

    # Read z position
    la t0, car_gps_z_axis               # &gps_z_axis -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a2)                        # t1 -> &a2

	ret

Syscall_get_rotation:
    # Retorna a angulação do carro em relação aos eixos #
    # x, y e z #
    # Code - 16 #
    # INPUT #
    # a0 - &x #
    # a1 - &y #
    # a2 - &z #
    # OUTPUT #

    # Pede a leitura do gps
    la t0, car_gps_flag
    li t1, 1
    sb t1, 0(t0)

    # Espera a leitura
1:
    lb t1, 0(t0)
    bnez t1, 1b

    # Read x position
    la t0, car_gps_x_angle              # &gps_x_angle -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a0)                        # t1 -> &a0
  
    # Read y position
    la t0, car_gps_y_angle              # &gps_y_angle -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a1)                        # t1 -> &a1

    # Read z position
    la t0, car_gps_z_angle              # &gps_z_angle -> t0
    lw t1, 0(t0)                        # *t0 -> t1
    sw t1, 0(a2)                        # t1 -> &a2

	ret

Syscall_read_serial:
    # Lê até N caracteres do port serial #
    # Code - 17 #
    # INPUT #
    # a0 - buffer #
    # a1 - size #
    # OUTPUT #
    # a0 - Número de bytes lidos #

	li t6, '\n'				# Constante
	li t0, 0				# Contador

1:
	beq t0, a1, read_ret	# Se t0 == a1, leu a1 bytes e termina a função

	# Pede a leitura
	la t2, read_flag
	li t1, 1
	sb t1, 0(t2)

2:
	# Espera a leitura terminar
	lb t1, 0(t2)
	bnez t1, 2b

	# Carrega o byte lido em t1
	la t1, read_byte
	lb t1, 0(t1)

	# Compara o byte lido com '\0' e '\n'
	beqz t1, add_null		# '\0'
	beq t1, t6, add_null	# '\n'

	# Se não for final da string, armazena e vai pro próximo
	sb t1, 0(a0)			# Armazena o valor
	addi a0, a0, 1			# Prox endereço
	addi t0, t0, 1			# Prox byte

	j 1b

add_null:
	# Armazena '\0' na final da string
	sb zero, 0(a0)

read_ret:
	mv a0, t0				# Numero de bytes lidos
	ret

Syscall_write_serial:
    # Code - 18 #
    # INPUT #
    # a0 - buffer #
    # a1 - size #
    # OUTPUT #

    mv t0, a0               # a0 -> t0
    add t1, a0, a1          # Último endereço

write_char:
    # Escreve o byte
    lb t2, 0(t0)
    la t3, write_byte
    sb t2, 0(t3)
    
    # Pede a escrita do byte
    la t2, write_flag
    li t3, 1
    sb t3, 0(t2)
    
1:
    # Espera a escrita terminar
    lb t3, 0(t2)
    bnez t3, 1b

	# Incrementa a quantdade
	addi t0, t0, 1
    bne t0, t1, write_char 

	ret


Syscall_get_systime:
    # Code - 20 #
    # INPUT #
    # OUTPUT #
    # a0 - Tempo desde que o sistema iniciou (ms) #

    # Pede a leitura do tempo
    la t0, timer_flag
	li t1, 1
    sb t1, 0(t0)

    # Espera a leitura acabar
1:
    lb t1, 0(t0)
    bnez t1, 1b

    # Lê o tempo atual
    la t0, timer_byte
    lw a0, 0(t0)

	ret

.set user_stack, 0x07FFFFFC
.data

lookup_table:
    .word Syscall_set_engine_and_steering   # 10
    .word Syscall_set_handbrake             # 11
    .word Syscall_read_sensors              # 12
    .word Syscall_read_sensor_distance      # 13
    .skip 0x4                               # 14
    .word Syscall_get_position              # 15
    .word Syscall_get_rotation              # 16
    .word Syscall_read_serial               # 17
    .word Syscall_write_serial              # 18
    .skip 0x4                               # 19
    .word Syscall_get_systime               # 20

.set car_gps_flag, 0xFFFF0300           # Byte
.set car_gps_x_angle, 0xFFFF0304        # Word
.set car_gps_y_angle, 0xFFFF0308        # Word
.set car_gps_z_angle, 0xFFFF030C        # Word
.set car_gps_x_axis, 0xFFFF0310         # Word
.set car_gps_y_axis, 0xFFFF0314         # Word
.set car_gps_z_axis, 0xFFFF0318         # Word

.set car_camera_flag, 0xFFFF0301        # Byte
.set car_camera_image, 0xFFFF0324       # 256 bytes

.set car_ultrasonic_flag, 0xFFFF0302    # Byte
.set car_ultrasonic_nearest, 0xFFFF031C # Word

.set car_wheel, 0xFFFF0320              # Byte
.set car_engine, 0xFFFF0321             # Byte
.set car_handbreak, 0xFFFF0322          # Byte

.set timer_flag, 0xFFFF0100             # Byte
.set timer_byte, 0xFFFF0104             # Byte

.set write_flag, 0xFFFF0500             # Byte
.set write_byte, 0xFFFF0501             # Byte
.set read_flag, 0xFFFF0502              # Byte
.set read_byte, 0xFFFF0503              # Byte

.bss
system_stack: .skip 0x100
system_stack_end:
