# Information-Mapper
Information mapping to control data flow.
Generic word size MAPPER_PARALELISM.

This project gets a mapping word and send an output word each clock, following those rules: (e.g for MAPPER_PARALELISM = 8)

first data_word      = [b0, b1, b2, b3, b4, b5, b6, b7]           (assuming LSB is the leftmost bit)

second data_word     = [b8, b9, b10, b11, b12, b13, b14, b15]


first mapping_word   = [1 0 0 1 1 0 1 0]                          (assuming LSB is the leftmost bit)

second mapping_word  = [0 1 1 1 1 0 1 1]


first output_word    = [b0 0 0 b1 b2 0 b3 0]                      (assuming LSB is the leftmost bit)

second output_word   = [0 b4 b5 b6 b7 0 b8 b9]


Project design is a visio file (.vsdx).

Implemented in Verilog, including testbench for every module.
