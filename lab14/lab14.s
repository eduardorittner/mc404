.text

int_handler:
    ###### Syscall and Interrupts handler ######

    # Salvar valores na stack
    # Registradores usados #
    # a0, a1
    # t0, t1, t2, t3
    
    csrrw sp, mscratch, sp
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a1, 12(sp)
  
    # <= Implement your syscall handler here 

    li t0, 10
    bne t0, a7, 1f
    jal Syscall_set_engine_and_steering
1:
    li t0, 11
    bne t0, a7, 2f
    jal Syscall_set_handbrake
2:
    li t0, 12
    bne t0, a7, 3f
    jal Syscall_read_sensors
3:
    #li t0, 15
    #bne t0, a1, 4f                 Não checamos pq se nao foi uma das 
    # ultimas 3 tem que ser essa de qualquer jeito
    jal Syscall_get_position
    
    csrr t0, mepc                   # (&ecall) - endereço da ecall que gerou a interrupção
    addi t0, t0, 4                  # (&ecall + 4) - instrução seguinte a ecall
    csrw mepc, t0                   # (&ecall + 4) -> mepc

    # Recuperar valores da stack

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw a1, 12(sp)
    addi sp, sp, 16
    csrrw sp, mscratch, sp

    mret           # Recover remaining context (pc <- mepc)

# ----- System calls ----- #

Syscall_set_engine_and_steering:
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
    
    la t0, car_engine
    sb a0, 0(t0)

    la t1, car_wheel
    sb a1, 0(t1)

    ret

error:
    li a0, -1
    ret

Syscall_set_handbrake:
    # INPUT #
    # a0 - 1 if handbrake must be set #
    # OUTPUT #
    
    la t0, car_handbreak
    sb a0, 0(t0)

    ret
    
Syscall_read_sensors:
    # INPUT #
    # a0 - address of 256 byte buffer #
    # OUTPUT#

    addi sp, sp, -4
    sw a0, 0(sp)

    # Toggle read operation
    la t0, car_camera_flag
    li t1, 1
    sb t1, 0(t0)

1:
    # Wait until it's done
    lb t1, 0(t0)
    bnez t1, 1b

    # Initial position
    la t0, car_camera_image
    # Final position
    addi t2, t0, 256

1:
    # Read 4 bytes
    lw t1, 0(t0)
    # Store 4 bytes
    sw t1, 0(a0)

    # Goto next 4 bytes
    addi t0, t0, 4
    addi a0, a0, 4

    # If t0 < t2, continue
    blt t0, t2, 1b

    # Return the start of array
    lw a0, 0(sp)
    addi sp, sp, 4

    ret


Syscall_get_position:
    # INPUT #
    # a0 - address of x pos #
    # a1 - address of y pos #
    # a2 - address of z pos #
    # OUTPUT #

    # Read gps postion
    la t0, car_gps_flag
    li t1, 1
    sb t1, 0(t0)

1:
    # Wait until it's done
    lb t1, 0(t0)
    bnez t1, 1b

    # Read x position
    la t0, car_gps_x_axis
    lb t1, 0(t0)
    sb t1, 0(a0)
  
    # Read y position
    la t0, car_gps_y_axis
    lb t1, 0(t0)
    sb t1, 0(a1)

    # Read z position
    la t0, car_gps_z_axis
    lb t1, 0(t0)
    sb t1, 0(a2)

    ret

# ----- Start ----- #

.globl _start
_start:
    # Inicialização das interrupções
        
    # Pilha de interrupção
    la t0, isr_stack_end        # base da pilha -> t0
    csrw mscratch, t0           # t0 -> mscratch

    # Interrupções externas
    csrr t1, mie                # mie -> t1
    li t2, 0x800
    or t1, t1, t2               # bit 11 || mie
    csrw mie, t1                # t1 -> mie

    # Interrupções globais
    csrr t1, mstatus            # mstatus -> t1
    ori t1, t1, 0x8             # bit 3 || mstatus
    csrw mstatus, t1            # t1 -> mstatus

    # Rotina de interrupt handler
    la t0, int_handler
    csrw mtvec, t0

    # Mudar o usuário
    csrr t1, mstatus            # mstatus -> t1
    li t2, ~0x1800              # bits 11 e 12  = 0 -> t2
    and t1, t1, t2              # t1 && t2
    csrw mstatus, t1            # t1 -> mstatus

    # Setar a entrada do código de usuário
    la t0, user_main            # user_main -> t0
    csrw mepc, t0               # t0 -> mepc

    # Carrega a pilha do usuário
    la sp, user_stack_end

    # Vai pro código do usuário
    mret

.globl control_logic
control_logic:
    # implement your control logic here, using only the defined syscalls

    li t0, 24
loopi:
    li a0, 1
    li a1, -127
    li a7, 10
    ecall
    addi t0, t0, -1
    bnez t0, loopi

    li t0, 4000
loopa:
    li a0, 1
    li a1, 0
    li a7, 10
    ecall
    addi t0, t0, -1
    bnez t0, loopa

loopo:
    j loopo

.data
.set car_gps_flag, 0xFFFF0100            # Byte
.set car_gps_x_angle, 0xFFFF0104         # Word
.set car_gps_y_angle, 0xFFFF0108         # Word
.set car_gps_z_angle, 0xFFFF010C         # Word
.set car_gps_x_axis, 0xFFFF0110          # Word
.set car_gps_y_axis, 0xFFFF0114          # Word
.set car_gps_z_axis, 0xFFFF0118          # Word

.set car_camera_flag, 0xFFFF0101         # Byte
.set car_camera_image, 0xFFFF0124        # 256 bytes

.set car_ultrasonic_flag, 0xFFFF0102     # Byte
.set car_ultrasonic_nearest, 0xFFFF011C  # Word

.set car_wheel, 0xFFFF0120               # Byte
.set car_engine, 0xFFFF0121              # Byte
.set car_handbreak, 0xFFFF0122           # Byte

.bss
isr_stack: .skip 0x100
isr_stack_end:

user_stack: .skip 0x1000
user_stack_end:
