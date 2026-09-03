.section .data
.align 3

value:
    .dword 0

.section .text
.global _start

_start:
    addi t0, zero, 42     
    la a0, value          
    sd t0, 0(a0)          
    ld t1, 0(a0)          

loop:
    j loop                