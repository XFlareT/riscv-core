`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 13:47:52
// Design Name: 
// Module Name: rca_adder32bit
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

module rca_adder32bit(
     input  logic [31:0] a_i
    ,input  logic [31:0] b_i
    ,input  logic        carry_i
    ,output logic [31:0] sum_o
    ,output logic        carry_o
);
    
    logic [32:0] carry_in;
    assign carry_in[0] = carry_i;
    
    fulladder instance_array[31:0](
         .a_i(a_i)                     
        ,.b_i(b)          
        ,.carry_i(carry_in[31:0])
        ,.sum_o(sum_o)
        ,.carry_o(carry_in[32:1]) 
    );
    
    assign carry_o = carry_in[32]; 

endmodule