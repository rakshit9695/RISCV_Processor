# RISC-V 4-Stage Pipeline CPU

This project implements a **simple 32-bit RISC-V processor** with a **four-stage pipeline** in Verilog. The README provides a clear breakdown of the architecture, key design principles, and simulation guidance towards the project.

---

## 📑 Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Module & Stage Summary](#module--stage-summary)
- [Pipeline Flow: Step by Step](#pipeline-flow-step-by-step)
- [Critical Digital Concepts](#critical-digital-concepts)
- [Computer Architecture Principles](#computer-architecture-principles)
- [Simulation Instructions](#simulation-instructions)

---

## 🔧 Overview

This CPU demonstrates the power of **instruction pipelining**, splitting instruction execution into the following stages:

1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execute (EXE)**
4. **Write Back (WB)**

Each stage operates in parallel, enabling **instruction-level parallelism** and higher throughput compared to single-cycle CPUs.

---
## ⚙️ Module & Stage Summary

| Module        | Stage(s)      | Function                                                |
|---------------|---------------|----------------------------------------------------------|
| `PC`          | IF            | Program counter - holds next instruction address         |
| `memory`      | IF            | Supplies instruction at PC address                       |
| `IF_IDstage`  | IF → ID       | Pipeline buffer for instruction and PC                   |
| `regfile`     | ID, WB        | 32 general-purpose registers (read/write)                |
| `control`     | ID            | Decodes instructions into control signals                |
| `ID_EXEstage` | ID → EXE      | Passes operands and control signals to EXE stage         |
| `alu`         | EXE           | Performs arithmetic and logic operations                 |
| `EXE_WBstage` | EXE → WB      | Buffers ALU results and control signals for WB           |
| `riscv_core`  | All           | Top-level module integrating all pipeline stages         |
| `tb_core`     | —             | Simulation testbench and stimulus                        |

---

## 🔄 Pipeline Flow: Step by Step

### 1. **Instruction Fetch (IF)**
- `PC` generates instruction address.
- `memory` fetches instruction from that address.
- `IF_IDstage` stores PC and instruction for the next cycle.

### 2. **Instruction Decode (ID)**
- Decode instruction via `control`.
- `regfile` reads source registers.
- Immediate values are extracted.
- Output passed to `ID_EXEstage`.

### 3. **Execute (EXE)**
- `alu` performs operation (ADD, SUB, AND, etc.).
- Branch decision logic runs (if needed).
- Result stored in `EXE_WBstage`.

### 4. **Write Back (WB)**
- If `regwrite` is active, result is written back to `regfile`.

---

## 💡 Critical Digital Concepts

- **Combinational vs. Sequential Logic**: ALU/control = combinational; pipeline registers = sequential.
- **Clocking**: Pipeline separated by flip-flops clocked every cycle.
- **Async Reads / Sync Writes**: Register file supports asynchronous reads and synchronous writes.
- **Pipeline Buffers**: Enable concurrent instruction execution in different stages.
- **Control Signals**: Drive the pipeline's decisions and routing logic.

---

## 🧠 Computer Architecture Principles

- **Pipelining**: Improves performance by processing multiple instructions in parallel.
- **Instruction-Level Parallelism**: Enabled by stage separation.
- **Hazards (Simplified)**: This design lacks forwarding/stalling, so instruction scheduling is important.
- **RISC Simplicity**: Easy-to-decode instructions, fixed-length encoding.
- **Memory Initialization**: Simple ROM setup with a `.hex` program file.

---

## 🧪 Simulation Instructions

1. Set up the folder structure as shown above.
2. Add Verilog source code to each `.v` file.
3. Write a test program into `program.hex` using machine code format.
4. Run `tb_core.v` in a simulator like:
   - [Icarus Verilog](http://iverilog.icarus.com/)
   - [EDA Playground](https://www.edaplayground.com/)
5. Observe waveforms or console logs to verify pipeline behavior.

### Sample `program.hex`:
```text
000005b7  // lui x11,0x0
00500113  // addi x2,x0,5
00700193  // addi x3,x0,7
003101b3  // add  x3,x2,x3
00318663  // beq  x3,x3,-4

