.section .text
.global _start

_start:

addi t0 , zero , 10
addi t1 , zero , 20

and t2 , t0 , t1
or t3 , t0 , t1
xor t4 , t0 , t1

loop:
    j loop