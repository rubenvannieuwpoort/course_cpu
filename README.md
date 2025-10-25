# Vivado Template for Mimas A7

A ready-to-use Vivado project template for the [Mimas A7 FPGA development board](https://numato.com/product/mimas-a7-artix-7-fpga-development-board). Use Vivado as your IDE and the command line for programming.


## Quick Start

1. Open `cpu.xpr` in Vivado to edit your design
2. Generate bitstream: `make bitstream`
3. Program the board: `make program`


## Project Structure

- `cpu.xpr` - Vivado project file (open this in Vivado)
- `src/` - VHDL design files
- `sim/` - Testbench files for simulation
- `scripts/` - TCL scripts for build automation
- `board/` - Board-specific configuration files for programming
- `mimasa7.xdc` - Constraints file for the Mimas A7 board


## Programming Options

By default, `make program` uses OpenOCD for volatile programming (configuration lost on power cycle). Alternative targets:

- `make program_volatile_openocd` - Program FPGA RAM using OpenOCD (default)
- `make program_persistent_openocd` - Program FPGA flash using OpenOCD (survives power cycles)
- `make program_volatile_xc3sprog` - Program FPGA RAM using xc3sprog
- `make program_persistent_xc3sprog` - Program FPGA flash using xc3sprog

To change the default, modify the `program` target in the `Makefile`.


## Requirements

- [Vivado](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html)
- [OpenOCD](https://openocd.org) or [xc3sprog](https://xc3sprog.sourceforge.net) for programming


## Adapting to Other Boards

To use this template with a different FPGA board:
- Update `mimasa7.xdc` with your board's constraints
- Update `PART` in the project settings to match your FPGA
- Adjust the programming flow in the `Makefile` for your board
