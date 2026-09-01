# RISC-V Practice

## Why am I doing this?

This directory contains my practical journey of learning **RISC-V from the ground up**.

The goal is to understand how a processor actually works at the instruction level — not just learn assembly syntax.

I am using small experiments to understand the connection between:

```text
RISC-V Assembly
      ↓
Machine Code
      ↓
CPU Registers
      ↓
Memory
      ↓
CPU Execution
```

Each practice focuses on a small concept so I can understand what is happening inside the CPU before moving to more advanced topics.

---

## 🎯 What I am learning

This practice will gradually cover:

* RISC-V architecture
* RV64
* Registers
* Immediate values
* Arithmetic instructions
* Logical and bitwise instructions
* Shift instructions
* Memory operations
* Branches and jumps
* Functions
* Stack
* Calling convention / ABI
* Instruction encoding
* Machine code
* CSRs
* Privilege modes
* Traps and interrupts
* Virtual memory
* MMU and page tables
* Multicore and atomics
* MMIO

Eventually, these concepts will be used to build a **RISC-V operating-system kernel** and later a **custom RISC-V CPU**.

---

## 🧠 Learning Method

For each concept, I follow:

```text
Learn
  ↓
Write
  ↓
Assemble
  ↓
Inspect
  ↓
Run
  ↓
Debug
  ↓
Explain
```

The purpose is to understand **why something works**, not simply make it run.

---

## 🧪 Practice Structure

Each numbered directory contains a small experiment:

```text
riscv/
├── 01-registers/
├── 02-arithmetic/
├── 03-memory/
├── 04-branches/
├── 05-functions/
└── ...
```

Each experiment should focus on one concept and contain the relevant source code and notes.

---

## 🖥️ Environment

The initial target is:

```text
Architecture: RISC-V RV64
Machine:      QEMU virt
Host:         x86-64 Linux
```

QEMU provides a virtual RISC-V machine so the programs can be executed and debugged without physical RISC-V hardware.

Later, the same RISC-V concepts will be used when implementing a custom CPU in SystemVerilog.

---

## 🛠️ Tools

The main tools used are:

* RISC-V GNU Toolchain
* GNU Assembler
* GNU Linker
* `objdump`
* `readelf`
* QEMU
* GDB
* Git
* SystemVerilog
* Verilator
* GTKWave

---

## 🚀 First Practice

The first experiment is:

```text
01-registers
```

It starts with one simple instruction:

```asm
addi t0, zero, 10
```

This teaches the fundamental relationship between an instruction and the CPU register file:

```text
zero = 0

addi t0, zero, 10

        ↓

t0 = 10
```

The instruction is assembled into machine code, placed into an ELF executable, loaded into QEMU, and then inspected using GDB.

The goal is to go from:

```text
"this instruction looks like it should work"
```

to:

```text
"I can see the RISC-V CPU execute the instruction
and observe the register change."
```

---

## 🔥 Goal

Start with individual RISC-V instructions.

Understand the CPU underneath them.

Then use those fundamentals to build increasingly complex software — eventually reaching the operating-system and hardware level.

> **Small instructions. Deep understanding.**
