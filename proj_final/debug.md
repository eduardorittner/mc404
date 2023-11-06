* SETUP INICIAL

system-stack-end: 0x12da0 **mscratch**
int-handler: 0x11160 **mtvec**
main: 0x11c2c **mepc**
sp: 0x7fffffc

mret - #25

* MAIN

sp - 16
sw ra, 12(sp)   0x7fffff8
sw s0, 8(sp)    0x7fffff4
sw a0, 4(sp)    0x7fffff0


buffer 0x12dc0
gets -0x7a0(ra)
ra = 0x11c54

* GETS

sp - 0x7ffffe0

** ECALL
(mepc = 0x114c4)
ra = 0x111b8



