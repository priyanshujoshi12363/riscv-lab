.section .text
.global _start

_start:

addi t0, zero , 10
addi t1 , zero , 20

add t2 , t0 , t1
sub t3 , t0 , t1

loop:
    j loop

