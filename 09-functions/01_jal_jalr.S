.section .text
.global _start

_start:
    addi t0, zero, 10

    jal ra, function

    addi t1, zero, 20

loop:
    j loop

function:
    addi t2, zero, 30

    jalr zero, 0(ra)