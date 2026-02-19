# 8-Bit CPU Design & Simulation

This repository contains the Verilog implementation of an 8-bit CPU, developed as a group project for the Introduction to Computer Systems (ITSC) course. The project encompasses the complete design of the processor architecture, a custom instruction set, an assembler, and a demonstration application (Pocket Calculator).

## Project Overview

The goal of this project was to design and simulate a functional 8-bit CPU from scratch. The system includes:
- 8-bit Data Bus and Address Bus
- General Purpose Registers
- Arithmetic Logic Unit (ALU)
- Control Unit (CU)
- Custom Assembly Language and Assembler

## Team & Contributions

This project was a collaborative effort. Responsibilities were divided as follows:

### My Contributions
- **Memory Module**: Design and implementation of the system memory.
- **Register File**: Implementation of the general-purpose registers and their control logic.
- **Instruction Set Architecture (ISA)**: Definition of the opcodes and instruction formats.
- **Assembler**: Development of the tool to convert custom assembly language into machine code.

### Collective Contributions
- **CPU Integration**: Top-level module connecting all components (ALU, CU, Registers, Memory).
- **Control Unit**: Logic for instruction decoding and signal generation.
- **Pocket Calculator Application**: A demo assembly program implementing basic arithmetic operations (Add, Sub, Mul, Div, Mod).

## Repository Structure

- `Implementation/`: Contains all source code and simulation files.
  - `ALU/`: Arithmetic Logic Unit modules.
  - `Assembler/`: Source code for the custom assembler.
  - `CPU.v`: Top-level CPU module.
  - `ControlUnit.v`: Control logic implementation.
  - `Calculator.asm`: Assembly source for the calculator application.
  - `run_sim.sh`: Script to compile and run the simulation using Icarus Verilog.

## Getting Started

### Prerequisites
- [Icarus Verilog](http://iverilog.icarus.com/) for simulation.
- [GTKWave](http://gtkwave.sourceforge.net/) (optional, for waveform viewing).

### Running the Simulation

1. Navigate to the implementation directory:
   ```bash
   cd Implementation
   ```

2. Run the simulation script:
   ```bash
   ./run_sim.sh
   ```

   This script compiles the Verilog files using `iverilog` and executes the simulation with `vvp`. The output is logged to `output.log`.

## Calculator Application

The project includes a `Calculator.asm` program that demonstrates the CPU's capabilities. It supports basic arithmetic operations:
- Addition
- Subtraction
- Multiplication
- Division
- Modulo

The program reads commands and operands from memory addresses and stores the result.

## Testing with the C Interface

The project includes a C-based interface (`interface.c`) that allows you to interact with the CPU simulation using a terminal UI. This interface takes user input, generates the necessary memory files, runs the simulation, and displays the result.

### Prerequisites

- GCC compiler
- ncurses library (usually available by default on Linux/macOS)

### Compiling and Running

1.  Navigate to the `Implementation` directory:

    ```bash
    cd Implementation
    ```

2.  Compile the interface:

    ```bash
    gcc interface.c -o calculator -lncurses
    ```

3.  Run the application:

    ```bash
    ./calculator
    ```

### Using the Interface

-   **Input A**: Type numbers to set the first operand.
-   **Input B**: Press `TAB` or `SPACE` to switch to the second operand input.
-   **Select Operation**: Use `UP` and `DOWN` arrow keys to cycle through operations (+, -, *, /, %).
-   **Calculate**: Press `ENTER` to run the simulation and see the result.
-   **Clear**: Press `c` to reset inputs.
-   **Quit**: Press `q` to exit.
