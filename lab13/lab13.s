.text

.globl _start
.globl main
.globl play_note
.globl _system_time

_start:
    la t0, isr_stack_end        # base da pilha -> t0
    csrw mscratch, t0           # t0 -> mscratch

    csrr t1, mie                # mie -> t1
    li t2, 0x800
    or t1, t1, t2               # bit 11 || mie
    csrw mie, t1                # t1 -> mie

    csrr t1, mstatus            # mstatus -> t1
    ori t1, t1, 0x8             # bit 3 || mstatus
    csrw mstatus, t1            # t1 -> mstatus

    la t0, timer                # &timer -> t0
    li t1, 100                  # generate interrupt after 100ms
    sw t1, 8(t0)                # 100 -> &timer+8

    la t0, gpt_isr
    csrw mtvec, t0

    jal main

    jal exit

gpt_isr:
    # Interrupção gerada a cada 100ms
    # Salvar o contexto
    csrrw sp, mscratch, sp      # sp <-> mscratch
    addi sp, sp, -64            # Aloca a stack de isr
    # Salva os registradores na stack
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    # Seta a flag de read time
    la t0, timer                # &timer -> t0
    li t1, 1                    # 1
    sb t1, 0(t0)                # 1 -> &timer (read flag)

    # Espera o read acabar
loop:
    lb t1, 0(t0)
    bnez t1, loop

    # Armazena o tempo em _system_time
    lw t1, 4(t0)                # (&timer + 4) -> t1 (current time)
    la t2, _system_time         # &_system_time -> t2
    sw t1, 0(t2)                # t1 -> t2 (&_system_time)

    # Seta próxima interrupção
    li t1, 100                  # 100ms
    sw t1, 8(t0)                # t1 -> (&timer + 8) (time to next interrupt)

    # Desempilha a pilha
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)

    # Desaloca a pilha e troca
    addi sp, sp, 64
    csrrw sp, mscratch, sp
    mret

play_note:
    # INPUT #
    # a0 - channel #
    # a1 - instrument #
    # a2 - musical_note #
    # a3 - velocity #
    # a4 - duration #
    # OUTPUT #

    la t0, midi
    sh a1, 2(t0)
    sb a2, 4(t0)
    sb a3, 5(t0)
    sh a4, 6(t0)
    sb a0, 0(t0)

    ret

exit:
    li a7, 93
    ecall

.data
.set timer, 0xFFFF0100
.set midi, 0xFFFF0300

.globl _system_time
.set _system_time, 0

.bss
.align 4
isr_stack: .skip 0x100
isr_stack_end:
