# TTech-LIB

This library contains several multipliers described in verilog. The multiplier generator utility, described in C++, generates RTL code that is platform agnostic and can be synthesized for either ASIC or FPGA. The user can fine tune the multipliers by selecting architecture, target frequency, operand sizes, and digit sizes.

To compile the project files using a sample GCC script, set your current directory /TMlib/src and then source compile.sh. Similarly, to run the project files, set your current directory /TMlib/run and then run the command ../bin/libgen.exe. Generated .v and .tcl files will appear in their corresponding directories. 


Initial results for NIST binary and prime field multipliers are reported in the following paper:
https://ieeexplore.ieee.org/document/9417065

To cite this paper:

@INPROCEEDINGS{9417065,  author={Imran, Malik and Abideen, Zain Ul and Pagliarini, Samuel},  booktitle={2021 24th International Symposium on Design and Diagnostics of Electronic Circuits   Systems (DDECS)},   title={An Open-source Library of Large Integer Polynomial Multipliers},   year={2021},  volume={},  number={},  pages={145-150},  doi={10.1109/DDECS52668.2021.9417065}}
