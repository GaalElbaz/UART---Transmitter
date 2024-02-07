# Basys 3 UART Transmitter Project

## Overview
This project aims to establish UART communication between the Basys 3 development board and a computer terminal. The Basys 3 board will transmit 8-bit data to the computer using switches, which will then be displayed in the terminal via a USB-UART connector on the Basys 3 board.

## Functionality
The project operates as follows:
- Binary values of ASCII characters are formed by toggling switches on/off.
- The 8-bit character generated from the switches is transmitted via UART to the computer.
- Transmission is initiated when a specific button is pressed.

## Components Used
The project utilizes the following components:
1. **Switches (0 through 7):** Used to input data by forming binary values of ASCII characters.
2. **Button:** Triggered to initiate the transmission of data.

## Implementation
The project is implemented using SystemVerilog within Xilinx Vivado. SystemVerilog facilitates the design and simulation of digital circuits, while Vivado serves as the development environment for Xilinx FPGAs.
