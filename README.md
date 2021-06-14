
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

## Subservient

This project constists of an ASIC-adapted version of the award-winning bit-serial RISC-V processor SERV. The macro was built from the subservient_wrapped repository linked later, which combines Subservient with 512 bytes of RAM (generated from RTL, as no satisfactory memory compiler was available in good time), used both as main memory and register file. For more information on subservient_wrapped, subservient and SERV, the original repositories can be accessed below. The repositories depend on each other through the Fusesoc packet management and tool abstraction system - this project was created to demonstrate Fusesoc in an ASIC context.

https://github.com/klasnordmark/subservient_wrapped

https://github.com/olofk/subservient

https://github.com/olofk/serv

## Usage

Subservient has access to the outside world through io_out[1]. To access it from the Caravel management processor (which is how you would program Subservient), keep it in "debug" mode by holding la_data_in[0] low. In this state, the 512 byte memory is accessible by the Caravel management processor over the Wishbone interface and Subservient does not run. The subservient_blinky full chip test included under verilog/dv gives an example of this, programming Subservient with a small 'blink' program toggling io_out[1].
