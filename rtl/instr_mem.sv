`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 17:17:15
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
     input  logic [31:0] read_addr_i
    ,output logic [31:0] read_data_o
);
    import memory_pkg::INSTR_MEM_SIZE_BYTES;
    import memory_pkg::INSTR_MEM_SIZE_WORDS;
    
    //Create a memory with <INSTR_MEM_SIZE_WORDS> 32 bits cells
    logic [31:0] ROM [INSTR_MEM_SIZE_WORDS];
    
    //Place content into ROM memory
    initial begin
        $readmemh("program.mem", ROM);
    end    
    
    //Implementation asynchronic port for reading
    assign read_data_o = ROM[read_addr_i[$clog2(INSTR_MEM_SIZE_WORDS)-1:2]];

endmodule 