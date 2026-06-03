# UART Receiver (Verilog HDL)

## Overview

A modular and parameterized UART receiver implemented in Verilog HDL featuring:

* FIFO-based receive buffering
* 16x oversampling UART reception
* UART frame deserialization
* Parity checking
* Frame and overrun error handling
* Control path and datapath separation
* Verification testbench
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)

---

# Features

* Parameterized FIFO depth and data width
* FIFO-based receive buffering
* 16x oversampling UART reception
* UART start-bit edge detection
* Serial-In Parallel-Out (SIPO) deserialization
* Even and Odd parity checking
* Frame-error detection
* Overrun-error detection
* RX synchronization
* Modular RTL architecture
* Verification testbench with waveform analysis
* Gate-level synthesis and timing verification

---

# Technology and Tools

| Category               | Tool / Technology |
| ---------------------- | ----------------- |
| RTL Design             | Verilog HDL       |
| Synthesis              | Yosys             |
| Static Timing Analysis | OpenSTA           |
| Waveform Viewer        | GTKWave           |
| PDK                    | Sky130            |
| Technology Node        | 130 nm            |
| Standard Cell Library  | sky130_fd_sc_hd   |
| Library Corner         | tt_025C_1v80      |

---

# Architecture

## Datapath

The datapath contains:

* FIFO buffer
* Oversampling baud counter
* UART deserializer (SIPO)
* Parity checker
* RX synchronizer

### Modules

* top → FIFO buffer
* baud_counter → Oversampling timing generator
* parity → UART parity checker
* sipo → UART deserializer
* data_path_rx → Datapath integration

---

## Control Path

The control path handles:

* UART receive sequencing
* Sampling control
* FIFO read/write control
* Frame validation
* Parity validation
* Overrun detection

### FSM States

* IDLE
* SAMPLE
* FRAME
* PARITY
* OVERRUN
* PUSH

### Modules

* control_path_rx → UART receiver control logic

---

# UART Reception Flow

1. Falling edge on RX detected
2. Oversampling counter enabled
3. UART frame sampled using 16x oversampling
4. Serial data shifted into SIPO register
5. Stop-bit validation performed
6. Parity validation performed
7. Received byte pushed into FIFO

---

# UART Frame Format

Current implementation uses fixed UART frame length:

START + 8 DATA + PARITY + STOP

* LSB received first
* Single stop bit supported

---

# Oversampling

UART reception uses 16x oversampling for improved sampling reliability.

Sampling occurs at the middle of each UART bit:

sample_count == 7

This improves tolerance against timing mismatch and input noise.

---

# Baud Configuration

Oversampling timing is derived from an external divider input:

```verilog
input [8:0] div
```

Supported divider range:

1 to 511

Baud Rate Formula:

Baud Rate = Clock Frequency / Divider Value

---

# Error Handling

## Frame Error

Generated when stop bit is invalid.

## Parity Error

Generated when received parity does not match calculated parity.

## Overrun Error

Generated when FIFO is full during incoming UART frame reception.

---

# RX Synchronization

The asynchronous RX input is synchronized using a two-stage synchronizer to reduce metastability risk.

---

# Verification Testbench

The project includes a verification testbench featuring:

* UART frame reception testing
* Start-bit detection verification
* Oversampling verification
* Parity checking verification
* FIFO buffering verification
* Error handling verification
* VCD waveform dumping
* GTKWave-based verification
* Gate-level simulation (GLS)

---

# Synthesis Results

Synthesized using Sky130 HD standard-cell library.

## Static Timing Analysis (STA)

STA performed using OpenSTA.

### Setup Timing

| Metric            | Result                                |
| ----------------- | ------------------------------------- |
| Worst Setup Slack | Positive after frequency optimization |
| Timing Status     | MET                                   |

### Hold Timing

| Metric           | Result   |
| ---------------- | -------- |
| Worst Hold Slack | Positive |
| Timing Status    | MET      |

---

# Gate-Level Simulation (GLS)

Gate-level simulation was performed using synthesized netlist generated from Yosys synthesis flow and verified using GTKWave.

---

# Simulation

## RTL Simulation

### Compile

```bash
iverilog -o rx.out *.v
```

### Run

```bash
vvp rx.out
```

### View Waveform

```bash
gtkwave rx.vcd
```

---

# Key Concepts Demonstrated

* UART Receiver Design
* FIFO-based buffering
* UART oversampling
* UART deserialization
* Error handling
* Control Path / Datapath separation
* Parameterized RTL Design
* ASIC synthesis flow
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)
* Verification using Testbench

---

# Current Limitations

* Current implementation uses fixed UART frame length
* Dynamic UART framing is not yet implemented
* Configurable stop-bit support is not implemented
* Runtime parity enable/disable handling is limited
* Current architecture supports single stop bit only

---

# Planned Improvements

* Dynamic UART frame configuration
* Configurable stop-bit support
* Runtime parity enable/disable handling
* Enhanced randomized verification
* Full SystemVerilog/UVM-based verification

---

# Author

Ansh Shinde
