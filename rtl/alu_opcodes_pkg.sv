package alu_opcodes_pkg;
localparam ALU_OP_WIDTH = 5;

localparam ALU_ADD  = 5'b00000;
localparam ALU_SUB  = 5'b01000;

localparam ALU_XOR  = 5'b00100;
localparam ALU_OR   = 5'b00110;
localparam ALU_AND  = 5'b00111;

// shifts
localparam ALU_SRA  = 5'b01101;  // Shift_Right_Ariphmetic
localparam ALU_SRL  = 5'b00101;  // Shift Right Logic
localparam ALU_SLL  = 5'b00001;  // Shift Left Logic

// comparisons
localparam ALU_LTS  = 5'b11100;  // Less Than Signed
localparam ALU_LTU  = 5'b11110;  // Less Than Unsigned
localparam ALU_GES  = 5'b11101;  // Great [or] Equal signed
localparam ALU_GEU  = 5'b11111;  // Great [or] Equal unsigned
localparam ALU_EQ   = 5'b11000;  // Equal
localparam ALU_NE   = 5'b11001;  // Not Equal

// set lower than operations
localparam ALU_SLTS = 5'b00010;  // Set Less Than Signed
localparam ALU_SLTU = 5'b00011;  // Set Less Than Unsigned

endpackage
