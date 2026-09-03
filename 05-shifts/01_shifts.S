.section .text
.global _start

_start:
    addi t0, zero, 5

    slli t1, t0, 2
    srli t2, t1, 1
    srai t3, t1, 1

loop:
    j loop
    