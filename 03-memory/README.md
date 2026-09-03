Practice 03 — Memory: Load & Store

This practice demonstrates how RISC-V moves data between registers and memory.

Goal

Put 42 into t0.

Get the address of value into a0.

Store 42 into memory.

Load it back into t1.

Loop forever.

Code

.section .data
.align 3

value:
    .dword 0

.section .text
.global _start

_start:
    addi t0, zero, 42     # t0 = 42
    la a0, value          # a0 = address of value
    sd t0, 0(a0)          # store t0 into memory
    ld t1, 0(a0)          # load memory into t1

loop:
    j loop                # infinite loop

What each instruction does

addi t0, zero, 42

t0 = 0 + 42
t0 = 42

la a0, value gets the address of value and puts it in a0.

sd t0, 0(a0) stores the 64-bit value in t0 into memory.

ld t1, 0(a0) loads the 64-bit value from memory into t1.

Data flow

t0 = 42
   |
   | sd
   v
RAM[0x80001018] = 42
   |
   | ld
   v
t1 = 42

So:

Register → Memory = store (`sd`)
Memory   → Register = load (`ld`)

.data, .dword, and .align

.text contains instructions.

.data contains program data.

.dword 0 creates an 8-byte value initialized to zero.

.align 3 aligns the value to an 8-byte boundary because 2^3 = 8.

Why la instead of our earlier lui?

We previously tried:

lui a0, 0x80001

but on RV64 this produced:

0xffffffff80001000

because of sign extension.

la a0, value lets the assembler/linker calculate the correct address of our data.

In the final ELF, la became:

auipc a0, 0x1
addi  a0, a0, 20

which calculates:

a0 = 0x80001018

Build

riscv64-unknown-elf-as 01_load_store.S -o 01_load_store.o

riscv64-unknown-elf-ld 01_load_store.o -o 01_load_store.elf -Ttext=0x80000000

Inspect the machine instructions:

riscv64-unknown-elf-objdump -d 01_load_store.elf

Run with QEMU + GDB

Terminal 1:

env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin qemu-system-riscv64 -machine virt -bios none -kernel 01_load_store.elf -nographic -S -gdb tcp::1234

Terminal 2:

gdb-multiarch 01_load_store.elf

Inside GDB:

set architecture riscv:rv64
target remote :1234
break _start
continue

Check registers:

info registers t0 a0 t1

After sd and ld:

t0 = 42
a0 = 0x80001018
t1 = 42

Inspect the actual memory:

x/gx 0x80001018

Expected:

0x000000000000002a

0x2a is hexadecimal for 42.

What we learned

.text → instructions

.data → program data

.dword → 8-byte value

.align 3 → 8-byte alignment

la → load an address

sd → store 64-bit data

ld → load 64-bit data

GDB can inspect registers and memory

Pseudo-instructions can become multiple real machine instructions

Core concept

CPU register
     |
     | store
     v
   Memory
     |
     | load
     v
CPU register