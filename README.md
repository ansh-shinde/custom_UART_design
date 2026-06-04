# UART Transceiver with FIFO Buffering (Verilog HDL)

## Overview

A modular UART Transceiver implemented in Verilog HDL featuring:

* UART Transmitter and Receiver
* FIFO-based UART buffering
* Programmable baud-rate generation
* 16x oversampling UART reception
* Even/Odd parity generation and checking
* Control path and datapath separation
* RTL verification and waveform analysis
* ASIC frontend flow using open-source EDA tools

---

# Features

## UART Transmitter

* FIFO-based transmission buffering
* Baud-rate controlled transmission
* UART frame serialization
* Even/Odd parity generation
* Parallel-In Serial-Out (PISO) transmission

---

## UART Receiver

* 16x oversampling UART reception
* Start-bit edge detection
* Serial-In Parallel-Out (SIPO) deserialization
* Even/Odd parity checking
* Stop-bit detection
* FSM-based receive control
* Frame-error detection
* Overrun-error detection

---

# Architecture

## UART Transmitter

### Datapath

Contains:

* FIFO buffer
* Baud counter
* Parity generator
* UART serializer (PISO)

### Control Path

Handles:

* FIFO read control
* UART transmission sequencing
* Baud synchronized shifting
* Transmission busy tracking

---

## UART Receiver

### Datapath

Contains:

* RX synchronizer
* Oversampling counter
* UART deserializer (SIPO)
* Parity checker
* FIFO buffer

### Control Path

FSM-based control handling:

* UART receive sequencing
* Sampling control
* FIFO write control
* Error detection
* Shift-register control

FSM States:

```text
IDLE → SAMPLE → PARITY → PUSH
```

---

# UART Frame Format

Current implementation uses fixed UART frame length:

```text
START + 8 DATA + PARITY + STOP
```

* LSB transmitted first
* Idle TX line remains HIGH

---

# Baud Rate Generation

Baud timing is generated using a programmable divider value provided externally through the `div` input.

```verilog
if(count == div-1)
    count <= 0;
```

Current implementation uses:

```verilog
input [8:0] div
```

Supported divider range:

```text
1 to 511
```

> `div = 0` is considered invalid.

---

# Baud Rate Formula

```text
Baud Rate = Clock Frequency / Divider Value
```

---

# Example (100 MHz Clock)

| Divider (`div`) | Approximate Baud Rate |
| --------------- | --------------------- |
| 104             | 9600 baud             |
| 54              | 115200 baud           |
| 8               | 12.5 Mbps             |

---

# UART Receiver Oversampling

UART RX uses:

```text
16x oversampling
```

Features:

* Mid-bit sampling
* Improved noise tolerance
* Better UART timing robustness

---

# Error Handling

The UART receiver supports:

| Error Type    | Description                          |
| ------------- | ------------------------------------ |
| Frame Error   | Invalid stop bit detected            |
| Parity Error  | Received parity mismatch             |
| Overrun Error | FIFO full during new frame reception |

---

# Verification

The project includes dedicated UART TX and RX verification testbenches.

Verification methodology:

* Manual UART serial stimulus
* FIFO operation verification
* Waveform-based debugging
* GTKWave analysis
* Gate-Level Simulation (GLS)

---

# ASIC Frontend Flow

Completed frontend ASIC flow using Sky130 open-source PDK.

Flow includes:

* RTL Design and Verification
* Logic Synthesis using Yosys
* Static Timing Analysis (STA) using OpenSTA
* Gate-Level Simulation (GLS)
* Sky130 standard-cell implementation

---

# Synthesis and Timing Results

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

# Project Structure

```text
custom_UART_design/
│
├── transmitter/
│   ├── README.md
│   ├── data_path_tx.v
│   ├── control_path_tx.v
│   ├── top_tx.v
│   └── tx_tb.v
│
├── receiver/
│   ├── README.md
│   ├── data_path_rx.v
│   ├── control_path_rx.v
│   ├── top_rx.v
│   ├── rx_tb.v
│   └── rx_tb_gls.v
│
├── README.md
└── .gitignore
```

---

# Simulation

## Compile

```bash
iverilog -o uart.out *.v
```

## Run

```bash
vvp uart.out
```

## View Waveforms

```bash
gtkwave *.vcd
```

---

# Key Concepts Demonstrated

* UART Transmitter Design
* UART Receiver Design
* FSM-Based Control Design
* FIFO-Based Buffering
* Oversampling UART Reception
* Control Path / Datapath Separation
* Parameterized RTL Design
* ASIC Synthesis Flow
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)
* Verification using Testbenches

---

# Current Limitations

* Dynamic UART framing is not yet implemented
* Current implementation supports single stop bit only
* UART transmitter control path is not FSM-based
* Runtime parity enable/disable handling is not implemented

---

# Planned Improvements

* Dynamic UART frame configuration
* FSM-based UART transmitter control
* Configurable stop-bit support
* Runtime parity enable/disable handling
* TX-to-RX loopback verification
* Randomized verification and assertions

---

# Author

Ansh Shinde


