# UART Transceiver with FIFO Buffering (Verilog HDL)

## Overview

A modular UART Transceiver implemented in Verilog HDL featuring:

* UART Transmitter and Receiver
* FIFO-based UART buffering
* Programmable baud-rate generation
* 16x oversampling UART reception
* Even/Odd parity support
* Control path and datapath separation
* RTL verification and waveform analysis
* ASIC frontend flow using open-source EDA tools

---

# Features

## UART Transmitter

* FIFO-based transmission buffering
* Baud-rate controlled transmission
* UART frame serialization using PISO
* Even/Odd parity generation
* Modular datapath and control-path architecture

---

## UART Receiver

* FIFO-based receive buffering
* 16x oversampling UART reception
* UART deserialization using SIPO
* Start-bit edge detection
* RX synchronization
* Even/Odd parity checking
* Frame-error and overrun-error handling
* FSM-based receive control

---

# ASIC Frontend Flow

Completed frontend ASIC flow using Sky130 open-source PDK:

* RTL Design and Verification
* Logic Synthesis using Yosys
* Static Timing Analysis (STA) using OpenSTA
* Gate-Level Simulation (GLS)
* Sky130 standard-cell implementation

---

# Technology Details

| Category               | Tool / Technology |
| ---------------------- | ----------------- |
| RTL Design             | Verilog HDL       |
| Synthesis              | Yosys             |
| Static Timing Analysis | OpenSTA           |
| Waveform Viewer        | GTKWave           |
| PDK                    | Sky130            |
| Technology Node        | 130nm             |
| Standard Cell Library  | sky130_fd_sc_hd   |

---

# UART Frame Format

Current implementation uses fixed UART frame length:

```text
START + 8 DATA + PARITY + STOP
```

* LSB transmitted first
* Single stop-bit support

---

# Baud Rate Generation

Baud timing is generated using a programmable divider input:

```verilog
input [8:0] div
```

Baud Rate Formula:

```text
Baud Rate = Clock Frequency / Divider Value
```

Supported divider range:

```text
1 to 511
```

---

# UART Receiver Oversampling

UART RX uses:

```text
16x oversampling
```

Features:

* Mid-bit sampling
* Improved timing robustness
* Better noise tolerance

---

# Error Handling

Receiver supports:

| Error Type    | Description                |
| ------------- | -------------------------- |
| Frame Error   | Invalid stop-bit detected  |
| Parity Error  | Received parity mismatch   |
| Overrun Error | FIFO full during reception |

---

# Verification

Verification methodology includes:

* UART serial stimulus
* FIFO operation verification
* RTL simulation
* Gate-Level Simulation (GLS)
* GTKWave waveform analysis

---

# Synthesis and STA Results

## UART Transmitter

* Timing closure achieved at 250 MHz
* Successful setup and hold timing verification
* Functional RTL and GLS verification completed

## UART Receiver

* Initial setup timing violation observed at 250 MHz
* Timing closure achieved after frequency optimization to 200 MHz
* Successful setup and hold timing verification
* Functional RTL and GLS waveform matching

---

# Repository Structure

```text
custom_UART_design/
│
├── transmitter/
│   ├── README.md
│   ├── control_path_tx.v
│   ├── data_path_tx.v
│   ├── top_tx.v
│   └── tx_tb.v
│
├── receiver/
│   ├── README.md
│   ├── control_path_rx.v
│   ├── data_path_rx.v
│   ├── top_rx.v
│   ├── rx_tb.v
│   └── rx_tb_gls.v
│
├── README.md
└── .gitignore
```

---

# Simulation

## RTL Simulation

### Compile

```bash
iverilog -o uart.out *.v
```

### Run

```bash
vvp uart.out
```

### View Waveforms

```bash
gtkwave *.vcd
```

---

# Key Concepts Demonstrated

* UART Transmitter Design
* UART Receiver Design
* FIFO-Based Buffering
* UART Oversampling
* FSM-Based Control Design
* Control Path / Datapath Separation
* ASIC Synthesis Flow
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)
* Verification using Testbenches

---

# Current Limitations

* Fixed UART frame format
* Single stop-bit support
* Dynamic UART framing not implemented
* Runtime parity configuration limited

---

# Planned Improvements

* Configurable UART frame format
* Multiple stop-bit support
* Randomized verification
* SystemVerilog/UVM-based verification
* TX-to-RX loopback integration

---

# Author

Ansh Shinde

