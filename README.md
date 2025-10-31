# Example Vivado project for Mimas A7

This is a VHDL project for the [Mimas A7 FPGA development board](https://numato.com/product/mimas-a7-artix-7-fpga-development-board) using Xilinx Vivado. The project uses TCL commands in project-mode for build automation. This way, you can develop projects for Mimas A7 dev board without using Vivado as your IDE. Alternatively, you can run `make create` to generate the Vivado project, then open `build/<project_name>.xpr` in Vivado.


## Getting started

You can run `make <target>` for the following targets:

- `make create` creates the Vivado project using TCL scripts
- `make bitstream` generates the bitstream file (includes synthesis and implementation)
- `make program` programs the FPGA (defaults to volatile programming via OpenOCD)
- `MODULE=<testbench> make sim` opens the simulator and simulates the testbench corresponding to `MODULE` (which is assumed to be `${MODULE}_tb`) in Vivado (in this project, `top_level_tb` and `clock_divider_tb` are implemented).

The project should be adaptable to other boards supported by Vivado by
- Updating the user constraints file (`mimasa7.xdc`)
- Updating the `PART` variable in the `Makefile` to match the FPGA
- (Optionally) updating the frequency of the clock in the testbench to match the clock speed of the actual device
- Implement any changes needed in the programming flow


## Project Structure

- `src/` - VHDL design files
- `sim/` - Testbench files for simulation
- `scripts/` - TCL scripts for Vivado automation.
- `board/` - Board-specific configuration files for programming
- `build/` - Generated Vivado project files and build artifacts
- `mimasa7.xdc` - Constraints file for the Mimas A7 board


## Programming Options

The `Makefile` has multiple targets for programming the FPGA either volatile or persistent, and with either OpenOCD or xc3sprog:
- `program_volatile_openocd` programs FPGA RAM using OpenOCD (configuration lost on power cycle)
- `program_persistent_openocd` programs FPGA flash memory using OpenOCD (survives power cycles)
- `program_volatile_xc3sprog` programs FPGA RAM using xc3sprog tool (configuration lost on power cycle)
- `program_persistent_xc3sprog` programs FPGA flash memory using xc3sprog tool (survives power cycles)

To use a different default programming method (e.g. persistent instead of volatile, or xc3sprog instead of OpenOCD), update the `program` target in the Makefile. The targets for programming the FPGA are based on [the instructions provided by Numato Lab](https://numato.com/kb/programming-mimas-a7-using-openocd-and-xc3sprog-in-linux).


## Requirements

You'll need to have the following tools installed:
- [Vivado](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html)
- Either [OpenOCD](https://openocd.org) or [xc3sprog](https://xc3sprog.sourceforge.net) to actually program the board
