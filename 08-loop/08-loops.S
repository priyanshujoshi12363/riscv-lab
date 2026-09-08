addi t0, zero, 0
addi t1, zero, 10

loop:
    addi t0, t0, 1
    bne t0, t1, loop

label:
    # finished