# UART Transceiver with FIFO Buffering (Verilog HDL)

## Overview

A modular and parameterized UART Transceiver implemented in Verilog HDL featuring:

* UART Transmitter and Receiver
* FIFO-based buffering
* FSM-based receiver control
* 16x oversampling UART reception
* Programmable baud-rate generation
* Parity generation and checking
* Control path and datapath separation
* Verification testbenches

---

# Features

## UART Transmitter

* FIFO-based transmission buffering
* Baud-rate controlled transmission
* UART frame serialization
* Even/Odd parity generation
* Parallel-In Serial-Out (PISO) transmission

## UART Receiver

* 16x oversampling UART reception
* Start-bit edge detection
* Serial-In Parallel-Out (SIPO) deserialization
* Even/Odd parity checking
* Stop-bit detection
* FSM-based receive control
* Frame error detection
* Overrun error detection

## FIFO Features

* Parameterized FIFO depth and width
* Gray-code pointer synchronization
* Dual clock-domain FIFO architecture
* Full / Empty detection
* Almost Full / Almost Empty detection

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

The divider value is supplied by the upper-level system, allowing configurable UART baud-rate operation without modifying RTL.

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

# Divider Width and Baud-Rate Range

The supported baud-rate range depends on divider width.

Current implementation uses a 9-bit divider.

Increasing divider width allows:

* Wider baud-rate range
* Slower UART baud rates
* Finer baud-rate configurability

Example:

```verilog
input [15:0] div
```

would allow significantly larger divider values and lower baud rates.

---

# UART Receiver Oversampling

UART RX uses:

```text
16x oversampling
```

to improve asynchronous serial-data sampling reliability.

Features:

* Mid-bit sampling
* Improved noise tolerance
* Better UART timing robustness

---

# FIFO Architecture

The FIFO implementation includes:

* Dual clock-domain support
* Gray-code pointer synchronization
* Binary-to-Gray pointer conversion
* Pointer synchronization using 2FF synchronizers

FIFO status handling:

* Full detection
* Empty detection
* Almost Full detection
* Almost Empty detection

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
* Internal FIFO memory observation

---

# Project Structure

```text
custom_UART_design/
│
├── transmitter/
│   ├── data_path_tx.v
│   ├── control_path_tx.v
│   ├── top_tx.v
│   └── tx_tb.v
│
├── receiver/
│   ├── data_path_rx.v
│   ├── control_path_rx.v
│   ├── top_rx.v
│   └── rx_tb.v
│
├── async_fifo/
│   ├── data.v
│   ├── control.v
│   ├── top.v
│   └── test_fifo.v
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
* CDC Synchronization
* Gray-Code Pointer Synchronization
* Oversampling UART Reception
* Control Path / Datapath Separation
* Parameterized RTL Design
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
