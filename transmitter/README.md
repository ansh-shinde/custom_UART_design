# UART Transmitter (Verilog HDL)

## Overview

A modular and parameterized UART transmitter implemented in Verilog HDL featuring:

* FIFO-based transmission buffering
* Baud-rate controlled transmission
* UART frame serialization
* Parity generation
* Control path and datapath separation
* Verification testbench
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)

---

# Features

* Parameterized FIFO depth and data width
* FIFO buffering before transmission
* Baud-rate generation using programmable divider
* Parallel-In Serial-Out (PISO) transmission
* Even and Odd parity generation
* UART serial transmission
* Modular RTL architecture
* Verification testbench with waveform analysis
* Gate-level synthesis and timing verification

---

# Technology and Tools

| Category | Tool / Technology |
|---|---|
| RTL Design | Verilog HDL |
| Synthesis | Yosys |
| Static Timing Analysis | OpenSTA |
| Waveform Viewer | GTKWave |
| PDK | Sky130 |
| Technology Node | 130 nm |
| Standard Cell Library | sky130_fd_sc_hd |
| Library Corner | tt_025C_1v80 |

---

# Architecture

## Datapath

The datapath contains:

* FIFO buffer
* Baud counter
* Parity generator
* UART serializer (PISO)

### Modules

* `top`              → FIFO buffer
* `baud_counter`     → Baud-rate timing generator
* `parity`           → Parity bit generation
* `piso`             → UART serializer
* `data_path_tx`     → Datapath integration

---

## Control Path

The control path handles:

* FIFO read control
* UART transmission control
* Baud synchronized shifting
* Transmission busy handling
* UART frame bit counting

### Modules

* `control_path_tx` → UART transmitter control logic

---

# UART Transmission Flow

1. Data is written into FIFO
2. Control path checks FIFO availability
3. Data is read from FIFO
4. UART frame is loaded into PISO
5. Baud counter controls shifting rate
6. Serialized data is transmitted through `tx`

---

# UART Frame Format

Current implementation uses fixed frame length:

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

The divider register is 9 bits wide:

```verilog
input [8:0] div
```

Supported divider range:

```text
1 to 511
```

> `div = 0` is considered invalid.

---

## Baud Rate Formula

```text
Baud Rate = Clock Frequency / Divider Value
```

---

## Example (100 MHz Clock)

| Divider (`div`) | Approximate Baud Rate |
|---|---|
| 104 | 9600 baud |
| 54 | 115200 baud |
| 8 | 12.5 Mbps |

This allows the UART transmitter to support multiple baud rates using the same RTL implementation.

---

## Divider Width and Baud-Rate Range

The supported baud-rate range depends on the width of the divider register.

Current implementation uses:

```verilog
input [8:0] div
```

This provides a divider range of:

```text
1 to 511
```

Increasing the width of the divider register allows support for:

* Wider baud-rate range
* Slower UART baud rates
* Finer baud-rate configurability

---

## Example

### Current 9-bit Divider

Maximum divider value:

```text
511
```

With a 100 MHz clock:

```text
Minimum baud rate ≈ 100 MHz / 511 ≈ 195 kbaud
```

---

### Example Using 16-bit Divider

```verilog
input [15:0] div
```

Maximum divider value:

```text
65535
```

With a 100 MHz clock:

```text
Minimum baud rate ≈ 100 MHz / 65535 ≈ 1525 baud
```

Thus, increasing divider width expands the range of selectable UART baud rates.

---

# Parity Generation

Parity bit is generated using XOR reduction:

```verilog
assign parity_calc = ^in;
```

Supports:

* Even parity
* Odd parity

---

# Serializer (PISO)

The PISO module:

* Loads parallel UART frame
* Shifts data serially
* Transmits one bit per baud interval

Transmission order:

```text
START → DATA[0:7] → PARITY → STOP
```

---

# Verification Testbench

The project includes a verification testbench featuring:

* FIFO write testing
* UART transmission testing
* Baud-rate synchronized shifting
* Parity-enabled transmission
* VCD waveform dumping
* GTKWave-based verification
* Gate-level simulation (GLS)

---

# Synthesis Results

Synthesized using Sky130 HD standard-cell library.

## Synthesis Summary

| Metric | Result |
|---|---|
| Total Standard Cells | 531 |
| Chip Area | 5906.9152 |
| Operating Frequency | 250 MHz |

---

# Static Timing Analysis (STA)

STA performed using OpenSTA at:

```text
250 MHz clock frequency (4 ns clock period)
```

## Setup Timing

| Metric | Result |
|---|---|
| Worst Setup Slack | 0.6487 ns |
| Timing Status | MET |

## Hold Timing

| Metric | Result |
|---|---|
| Worst Hold Slack | 0.3312 ns |
| Timing Status | MET |

Timing closure successfully achieved at 250 MHz.

---

# Gate-Level Simulation (GLS)

Gate-level simulation was performed using synthesized netlist generated from Yosys synthesis flow and verified using GTKWave.

---

# Simulation

## RTL Simulation

### Compile

```bash
iverilog -o tx.out *.v
```

### Run

```bash
vvp tx.out
```

### View Waveform

```bash
gtkwave tx.vcd
```

---

# Key Concepts Demonstrated

* UART Transmitter Design
* FIFO-based buffering
* Control Path / Datapath separation
* Baud-rate generation
* UART serialization
* Parity generation
* Parameterized RTL Design
* ASIC synthesis flow
* Static Timing Analysis (STA)
* Gate-Level Simulation (GLS)
* Verification using Testbench

---

# Current Limitations

* Current implementation uses fixed UART frame length
* Dynamic UART framing is not yet implemented
* Current transmitter control logic is not FSM-based
* Parity-disabled frame skipping is not yet supported
* Configurable stop-bit support is not implemented

---

# Planned Improvements

* Dynamic UART frame configuration
* FSM-based UART transmitter control
* Configurable stop-bit support
* Runtime parity enable/disable handling
* Enhanced verification and randomized testing

---

# Author

Ansh Shinde
