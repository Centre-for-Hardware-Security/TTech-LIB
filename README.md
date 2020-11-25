# TTech-LIB

This library contains several multipliers described in verilog. The multiplier generator utility, described in C++, generates RTL code that is platform agnostic and can be synthesized for either ASIC or FPGA. The user can fine tune the multipliers by selecting architecture, target frequency, operand sizes, and digit sizes.

To compile the project files, set your current directory /TMlib/src and then source compile.sh. Similarly, to run the project files, set your current directory /TMlib/run and then run the command ../bin/libgen.exe. Generated .v and .tcl files will appear in their corresponding directories. 
