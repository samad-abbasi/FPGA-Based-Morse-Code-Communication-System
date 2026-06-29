# FPGA-Based Morse Code Communication System

A **SystemVerilog-based FPGA implementation** of a dual-mode Morse Code Communication System developed on the **Digilent Nexys A7** FPGA board. The project converts numeric digits into standardized Morse code patterns and supports both **single-digit** and **multi-digit** encoding modes using Finite State Machines (FSMs), FIFO buffering, and combinational logic.

---

## Project Overview

This project was developed as part of the **C/C++ for Hardware Engineers** training module. It demonstrates the implementation of a digital Morse code encoder capable of transmitting numeric digits through LED blinking patterns while adhering to standard Morse code timing specifications.

The system supports:

* **Phase 1:** Single-digit Morse code encoding
* **Phase 2:** Multi-digit sequence storage and playback using a FIFO buffer

---

## Features

* Dual-mode Morse code encoder
* Single-digit and multi-digit operation
* FSM-based control logic
* FIFO-based digit storage
* Standard Morse code timing implementation
* LED-based Morse code transmission
* Simulation using SystemVerilog testbenches
* Hardware implementation on Digilent Nexys A7 FPGA

---

## Hardware Platform

* **Development Board:** Digilent Nexys A7
* **Language:** SystemVerilog
* **Design Tool:** Xilinx Vivado Design Suite

---

## Project Structure

```text
FPGA-Morse-Code-Communication-System
│
├── rtl/
│   ├── phase_1.sv
│   └── phase_2.sv
│
├── tb/
│   ├── phase_1_tb.sv
│   └── phase_2_tb.sv
│
├── constraints/
│   └── NexysA7.xdc
│
├── docs/
│   ├── Project_Report.pdf
│   └── Presentation.pdf
│
├── images/
│   ├── phase1_waveform.png
│   ├── phase2_waveform.png
│   └── board_demo.jpg
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## Functional Overview

### Phase 1 – Single-Digit Encoding

* Accepts a 4-bit binary input (0–9)
* Converts the selected digit into its Morse code representation
* Displays the Morse sequence through LED blinking
* BTN0 resets the system
* BTN1 starts transmission

---

### Phase 2 – Multi-Digit Encoding

* Stores up to six numeric digits using a FIFO buffer
* BTN1 stores each input digit
* BTN2 initiates sequential Morse code transmission
* Maintains a 2-second gap between consecutive digits

---

## Timing Specifications

| Signal              |   Duration |
| ------------------- | ---------: |
| Dot                 |   1 second |
| Dash                |  3 seconds |
| Gap between symbols | 0.5 second |
| Gap between digits  |  2 seconds |

---

## Simulation Results

The simulation validates accurate Morse code generation for multiple input digits by ensuring correct LED ON durations for dots and dashes, along with the specified OFF intervals between symbols. It also confirms successful storage and sequential transmission of multiple digits while maintaining the required 2-second gap between consecutive Morse code sequences.

### Phase 1 Waveform

![Phase 1](images/phase1_waveform.png)

### Phase 2 Waveform

![Phase 2](images/phase2_waveform.png)

---

## Hardware Demonstration

The design was successfully synthesized, implemented, and tested on the **Digilent Nexys A7 FPGA** development board.

The implementation verifies:

* Correct Morse code generation
* Accurate FSM state transitions
* Reliable FIFO operation
* Standard Morse code timing

---

## Future Improvements

* Support full alphanumeric Morse code
* UART communication interface
* Wireless transmission
* OLED/LCD display support
* Adjustable transmission speed


---

## License

This project is released under the **MIT License**.

