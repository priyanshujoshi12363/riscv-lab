.section .text
.global _start

_start:
    addi t0, zero, 10
    addi t1, zero, 20

    slt t2, t0, t1

loop:
    j loop