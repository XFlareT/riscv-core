`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 15:00:27
// Design Name: 
// Module Name: data_mem
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

module data_mem(
     input  logic        clk_i
    ,input  logic        mem_req_i
    ,input  logic        write_enable_i
    
    ,input  logic [3:0]  byte_enable_i
    ,input  logic [31:0] addr_i
    ,input  logic [31:0] write_data_i
    
    ,output logic [31:0] read_data_o
    ,output logic        ready_o
);
    import memory_pkg::DATA_MEM_SIZE_BYTES;
    import memory_pkg::DATA_MEM_SIZE_WORDS;
    
    //Create a main memory
    logic [31:0] ram [DATA_MEM_SIZE_WORDS];
    
    //Implementation synchronous port for write/read
    always_ff @(posedge clk_i) begin
        if (mem_req_i) begin
            if(write_enable_i) begin
                if (byte_enable_i[0]) ram[addr_i[31:2]][7:0] <= write_data_i[7:0];
                if (byte_enable_i[1]) ram[addr_i[31:2]][15:8] <= write_data_i[15:8];
                if (byte_enable_i[2]) ram[addr_i[31:2]][23:16] <= write_data_i[23:16];
                if (byte_enable_i[3]) ram[addr_i[31:2]][31:24] <= write_data_i[31:24];
            end else begin
                read_data_o <= ram[addr_i[31:2]];
            end
        end
    end
    
    assign ready_o = 1'b1;

endmodule

