`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 13:41:52
// Design Name: 
// Module Name: fulladder
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

module fulladder(
     input  logic a_i
    ,input  logic b_i
    ,input  logic carry_i
    ,output logic sum_o
    ,output logic carry_o
);

    assign sum_o = a_i ^ b_i ^ carry_i;
    assign carry_o = (a_i & b_i) | (a_i & carry_i) | (b_i & carry_i);

endmodule
