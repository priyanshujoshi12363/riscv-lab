.section .text
.global _start

_start:
    addi t0, zero, 10
    addi t1, zero, 20

    beq t0, t1, equal
    addi t2, zero, 0
    j next

equal:
    addi t2, zero, 1

next:
    bne t0, t1, not_equal
    addi t3, zero, 0
    j next2

not_equal:
    addi t3, zero, 1

next2:
    blt t0, t1, lower
    addi t4, zero, 0
    j next3

lower:
    addi t4, zero, 1

next3:
    bge t0, t1, greater_equal
    addi t5, zero, 0
    j loop

greater_equal:
    addi t5, zero, 1

loop:
    j loop