# RISC-V Practice 01 — First Register Experiment

## 🎯 Goal

This is my first practical RISC-V experiment.

The goal was to understand:

* RISC-V registers
* `x0` / `zero`
* `t0` / `x5`
* immediate values
* the `addi` instruction
* labels
* assembly → object file → ELF
* ELF entry points
* QEMU running a RISC-V machine
* GDB connecting to QEMU
* program counter (`PC`)
* observing a register change during execution

---

## 🧠 The Program

```asm
.section .text
.global _start

_start:
    addi t0, zero, 10

loop:
    j loop
```

### What does it do?

The instruction:

```asm
addi t0, zero, 10
```

means:

```text
t0 = zero + 10
```

Since:

```text
zero = 0
```

the result is:

```text
t0 = 10
```

After that, the program jumps to `loop` forever:

```asm
j loop
```

There is no output because this program does not communicate with a UART or terminal. It only changes a CPU register and loops.

---

## 🧩 RISC-V Registers

RISC-V has 32 general-purpose integer registers:

```text
x0 - x31
```

For RV64, each general-purpose register is 64 bits wide.

Important registers used here:

```text
x0 = zero
x5 = t0
```

`x0` is special:

```text
x0 = 0
```

Writing to `x0` does not change it.

---

## 🔢 Immediate Value

In:

```asm
addi t0, zero, 10
```

the `10` is an **immediate value**.

It is part of the instruction itself.

Conceptually:

```text
addi
 │
 ├── destination: t0
 ├── source:      zero
 └── immediate:   10
```

Therefore:

```text
t0 = 0 + 10
t0 = 10
```

---

## 🏷️ Labels

```asm
_start:
```

and:

```asm
loop:
```

are labels.

They give names to addresses.

Conceptually, after linking:

```text
0x80000000 → _start
0x80000004 → loop
```

The labels themselves are not CPU instructions.

---

## 🔧 Build Pipeline

The assembly source was converted into an object file:

```bash
riscv64-unknown-elf-as 01_put_value.S -o 01_put_value.o
```

Then the object file was linked into an executable ELF:

```bash
riscv64-unknown-elf-ld 01_put_value.o -o 01_put_value.elf -Ttext=0x80000000
```

The basic pipeline is:

```text
01_put_value.S
      │
      │ assembler
      ▼
01_put_value.o
      │
      │ linker
      ▼
01_put_value.elf
```

---

## 🔍 Inspecting the Machine Code

The object file was inspected using:

```bash
riscv64-unknown-elf-objdump -d 01_put_value.o
```

The important output was:

```text
0000000000000000 <_start>:
   0:   00a00293                li      t0,10

0000000000000004 <loop>:
   4:   0000006f                j       4 <loop>
```

The assembler instruction:

```asm
addi t0, zero, 10
```

was displayed by `objdump` as the pseudo-instruction:

```asm
li t0,10
```

The actual machine-code encoding was:

```text
00a00293
```

This will be studied in detail later.

---

## 📦 ELF

The final program is an ELF executable:

```text
01_put_value.elf
```

`readelf` was used to inspect it:

```bash
riscv64-unknown-elf-readelf -h 01_put_value.elf
```

Important information:

```text
Class:          ELF64
Data:           little endian
Type:           EXEC
Machine:        RISC-V
Entry point:    0x80000000
```

The entry point means execution begins at:

```text
0x80000000
```

The program was linked using:

```bash
-Ttext=0x80000000
```

which placed the `.text` section at that address.

---

## 🖥️ Running on QEMU

The program was run using:

```bash
qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel 01_put_value.elf
```

QEMU provides a virtual computer containing a RISC-V CPU, memory, and virtual devices.

The host machine is x86-64, but QEMU is executing our RISC-V program on a virtual RISC-V CPU.

Conceptually:

```text
Physical laptop
      │
      ▼
     QEMU
      │
      ▼
Virtual RISC-V RV64 CPU
      │
      ▼
01_put_value.elf
```

The program appears to do nothing because it contains no output code and intentionally loops forever.

---

## 🐛 Debugging with GDB

QEMU was started in paused/debug mode:

```bash
qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel 01_put_value.elf \
    -S \
    -gdb tcp::1234
```

`-S` pauses the virtual CPU.

`-gdb tcp::1234` opens a debugging connection on port `1234`.

A second terminal was used to start:

```bash
gdb-multiarch 01_put_value.elf
```

Inside GDB:

```gdb
set architecture riscv:rv64
target remote :1234
```

This connected GDB running on the x86-64 host to the RISC-V CPU inside QEMU.

---

## 🧭 Program Counter

After connecting, GDB showed:

```text
pc = 0x1000
```

The program's `_start` symbol was located at:

```text
_start = 0x80000000
```

The **PC (Program Counter)** tells us the address associated with the CPU's current instruction location.

A breakpoint was then set:

```gdb
break _start
```

and execution continued:

```gdb
continue
```

The CPU reached:

```text
0x80000004
```

which corresponds to:

```asm
j loop
```

This means the CPU had already executed:

```asm
addi t0, zero, 10
```

---

## 🔥 First Proof That the CPU Executed My Instruction

GDB showed:

```text
pc  0x80000004
t0  0xa  10
```

Therefore:

```text
t0 = 10
```

`0xa` is hexadecimal representation of decimal `10`.

The important sequence was:

```text
_start
  │
  ▼
addi t0, zero, 10
  │
  ▼
t0 = 10
  │
  ▼
PC moves to 0x80000004
  │
  ▼
j loop
  │
  └──────────┐
             ▼
            loop
```

This was the first practical demonstration of a RISC-V instruction executing and changing a CPU register inside a virtual machine.

---

## 🧠 Mental Model

The complete system currently looks like:

```text
                 My laptop
              AMD x86-64 CPU
                    │
                    │ runs
                    ▼
                  QEMU
                    │
                    │ emulates
                    ▼
             ┌───────────────┐
             │ RISC-V RV64   │
             │ CPU           │
             │               │
             │ PC            │
             │ x0 - x31      │
             └───────┬───────┘
                     │
                     ▼
                    RAM

              0x80000000
                    │
                    ▼
       addi t0, zero, 10
                    │
                    ▼
                 t0 = 10
                    │
                    ▼
              0x80000004
                    │
                    ▼
                 j loop
```

GDB gives us a window into this virtual CPU.

---

## 🛠️ Tools Used

```text
RISC-V cross assembler
riscv64-unknown-elf-as

RISC-V linker
riscv64-unknown-elf-ld

Disassembler
riscv64-unknown-elf-objdump

ELF inspector
riscv64-unknown-elf-readelf

Virtual machine
qemu-system-riscv64

Debugger
gdb-multiarch
```

---

## 🚀 What I Learned

The most important lesson from this experiment:

> Assembly is not executed directly by my laptop's CPU.

The pipeline is:

```text
Assembly
   ↓
Assembler
   ↓
Machine code
   ↓
ELF executable
   ↓
QEMU
   ↓
Virtual RISC-V CPU
   ↓
Instruction execution
   ↓
Register changes
```

My first instruction:

```asm
addi t0, zero, 10
```

ultimately caused:

```text
t0 = 10
```

inside the virtual RISC-V CPU.

---

## 📚 Next

Next experiments will investigate:

1. `add`
2. `sub`
3. immediate values
4. negative values
5. bitwise instructions
6. shifts
7. instruction encoding
8. memory loads/stores
9. branches
10. functions and stack
11. RISC-V ABI
12. CSRs and privilege modes
13. traps and interrupts
14. virtual memory
15. building a minimal RISC-V kernel
