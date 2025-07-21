# RISC-V Core Testbench

This project contains a simple SystemVerilog testbench (`tb_core`) designed to simulate a basic RISC-V processor core using a small instruction program. It is intended for use with simulation environments such as **EDA Playground**, **ModelSim**, or **VCS**.

---

## 🧪 Testbench Overview

**File:** `tb_core.sv`

**Main Features:**
- Instantiates the RISC-V core module (`riscv_core`)
- Drives a clock signal (`clk`) with a 10ns period
- Applies a reset (`rst`) signal for the first 12ns
- Loads a small program into instruction memory (`imem`)
- Automatically terminates simulation after 400ns

---

## 🔁 Program Flow

The program loaded into instruction memory performs the following:
1. Load value `5` into register `x1`
2. Load value `7` into register `x2`
3. Add `x1` and `x2`, store result in `x3`
4. Enter an infinite loop: `beq x3, x3, loop`

This is a minimal test to verify correct instruction decoding, execution, and control flow.

---

## 📂 File Requirements

Make sure the following files are in the same directory or correctly referenced:
- `tb_core.sv` – the testbench file
- `riscv_core.sv` – your core implementation
- `program.hex` – a hex file containing the assembled program in memory format
- (Optional) `imem.sv` – if `DUT.imem.mem` refers to a specific instruction memory module

---

## 🧰 Simulation Instructions (EDA Playground)

1. Paste `tb_core.sv` into the testbench panel.
2. Add or link your `riscv_core` module and `imem` implementation.
3. Upload `program.hex` under the “Files” section.
4. Run the simulation.

---

## 📎 Notes

- Ensure that the `program.hex` format matches what `DUT.imem.mem` expects (typically word-aligned instructions).
- For longer tests, modify the `#400` delay to allow more time for execution.
- Add `$display()` or `$monitor()` statements to observe register values or memory contents.


