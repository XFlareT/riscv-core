`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 17:01:41
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu (
     input  logic [31:0]  a_i
    ,input  logic [31:0]  b_i
    ,input  logic  [4:0]  alu_op_i
      
    ,output logic         flag_o
    ,output logic [31:0]  result_o
);
  
    import alu_opcodes_pkg::*;
      
      
    logic [31:0] sum_result;
    logic [31:0] sub_result;
      
    rca_adder32bit sum32(
        .a_i(a_i),
        .b_i(b_i),
        .carry_i(1'b0),
        .carry_o(),
        .sum_o(sum_result)
    );
      
    rca_adder32bit sub32(
        .a_i(a_i),
        .b_i(~b_i),
        .carry_i(1'b0),
        .carry_o(),
        .sum_o(sub_result)
    );


    always_comb begin  
        case (alu_op_i)
            ALU_ADD: result_o = sum_result;
            ALU_SUB: result_o = sub_result + 1;                        
            ALU_XOR: result_o = a_i ^ b_i;
            ALU_OR: result_o = a_i | b_i;   
            ALU_AND: result_o = a_i & b_i;
            ALU_SRA: result_o = $signed(a_i) >>> b_i[4:0];
            ALU_SRL: result_o = a_i >> b_i[4:0];  
            ALU_SLL: result_o = a_i << b_i[4:0]; 
            ALU_SLTS: result_o = $signed(a_i) < $signed(b_i);  
            ALU_SLTU: result_o = a_i < b_i;
            default:result_o = 0;
         endcase
    end

    always_comb begin
            case (alu_op_i)
                ALU_LTS: flag_o = $signed(a_i) < $signed(b_i);
                ALU_LTU: flag_o = a_i < b_i;
                ALU_GES: flag_o = $signed(a_i) >= $signed(b_i);
                ALU_GEU: flag_o = a_i >= b_i;
                ALU_EQ: flag_o = (a_i == b_i);
                ALU_NE: flag_o = (a_i != b_i);
                default:flag_o = 0;
            endcase
    end
    
endmodule

