`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 21:21:40
// Design Name: 
// Module Name: decoder
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


module decoder (
   input  logic [31:0]  fetched_instr_i
  ,output logic [1:0]   a_sel_o
  ,output logic [2:0]   b_sel_o
  ,output logic [4:0]   alu_op_o
  ,output logic [2:0]   csr_op_o
  ,output logic         csr_we_o
  ,output logic         mem_req_o
  ,output logic         mem_we_o
  ,output logic [2:0]   mem_size_o
  ,output logic         gpr_we_o
  ,output logic [1:0]   wb_sel_o
  ,output logic         illegal_instr_o
  ,output logic         branch_o
  ,output logic         jal_o
  ,output logic         jalr_o
  ,output logic         mret_o
);
    import decoder_pkg::*;

    logic [4:0] op_code; // operation code
    
    logic [2:0] funct3;  // first addition to operation code
    logic [6:0] funct7;  // second addition to operation code
    
    logic [4:0] rs1;     // address of the first operand
    logic [4:0] rs2;     // address of the second operand
    logic [4:0] rd;      // address for result
    
    //decode instruction
    
    assign op_code = fetched_instr_i[6:2];
    
    assign funct3 = fetched_instr_i[14:12];
    assign funct7 = fetched_instr_i[31:25];
    
    assign rs1 = fetched_instr_i[19:15];
    assign rs2 = fetched_instr_i[24:20];
    assign rd = fetched_instr_i[11:7];
    
    
    logic [31:0] imm; 


    always_comb begin
        a_sel_o = OP_A_RS1;
        b_sel_o = OP_B_RS2;
        alu_op_o = ALU_ADD;
        csr_op_o = CSR_RW;
        csr_we_o = 1'b0;
        mem_req_o = 1'b0;
        mem_we_o = 1'b0;
        mem_size_o = LDST_W;
        gpr_we_o = 1'b0;
        wb_sel_o = WB_EX_RESULT;
        illegal_instr_o = 1'b0;
        branch_o = 1'b0;
        jal_o = 1'b0;
        jalr_o = 1'b0;
        mret_o = 1'b0;
        
        if(fetched_instr_i[1:0] != 2'b11) // illegal instruction
            illegal_instr_o = 1'b1;
            
        else begin
            case(op_code)
            
                 //LUI
                LUI_OPCODE:begin
                    a_sel_o = OP_A_ZERO;
                    b_sel_o = OP_B_IMM_U;
                    alu_op_o = ALU_ADD;
                    gpr_we_o = 1'b1;
                end
                
                //AUIPC
                AUIPC_OPCODE:begin 
                    a_sel_o = OP_A_CURR_PC;
                    b_sel_o = OP_B_IMM_U;
                    gpr_we_o = 1'b1;
                end
                
                // JAL 
                JAL_OPCODE: begin
                    jal_o = 1'b1;
                    gpr_we_o = 1'b1;
                    a_sel_o = OP_A_CURR_PC;
                    b_sel_o = OP_B_INCR;
                end
                
                //JALR
                JALR_OPCODE: begin
                    if(funct3 == 3'b000) begin
                        jalr_o = 1'b1;
                        gpr_we_o = 1'b1;
                        a_sel_o = OP_A_CURR_PC;
                        b_sel_o = OP_B_INCR;
                    end else begin
                        illegal_instr_o = 1'b1;
                    end
                end
                
                //BRANCH
                BRANCH_OPCODE:begin
                    branch_o = 1'b1;
                    case(funct3)
                        3'b000: alu_op_o = ALU_EQ;  //BEQ
                        3'b001: alu_op_o = ALU_NE;  //BNE
                        3'b100: alu_op_o = ALU_LTS; //BLT
                        3'b101: alu_op_o = ALU_GES; //BGE
                        3'b110: alu_op_o = ALU_LTU; //BLTU
                        3'b111: alu_op_o = ALU_GEU; //BGEU
                        default: begin
                            illegal_instr_o = 1'b1;
                            branch_o = 1'b0;
                        end
                    endcase 
                end
                
                //LOAD
                LOAD_OPCODE:begin
                    gpr_we_o = 1'b1;
                    b_sel_o = OP_B_IMM_I;
                    mem_req_o = 1'b1;
                    mem_we_o = 1'b0;
                    wb_sel_o = WB_LSU_DATA;
                    case(funct3)
                        3'b000: mem_size_o = LDST_B;  //LB
                        3'b001: mem_size_o = LDST_H;  //LH
                        3'b010: mem_size_o = LDST_W;  //LW
                        3'b100: mem_size_o = LDST_BU; //LBU
                        3'b101: mem_size_o = LDST_HU; //LHU
                        default: begin
                            mem_we_o = 1'b0;
                            gpr_we_o = 1'b0;
                            mem_req_o = 1'b0;
                            illegal_instr_o = 1'b1;
                        end
                    endcase
                end
                
                //STORE
                STORE_OPCODE:begin
                    mem_req_o = 1'b1;
                    mem_we_o = 1'b1;
                    b_sel_o = OP_B_IMM_S;
                    wb_sel_o = WB_LSU_DATA;
                    case(funct3)
                        3'b000: mem_size_o = LDST_B; //SB
                        3'b001: mem_size_o = LDST_H; //SH
                        3'b010: mem_size_o = LDST_W; //SW
                        default: begin
                            gpr_we_o = 1'b0;
                            mem_req_o = 1'b0;
                            mem_we_o = 1'b0;
                            illegal_instr_o = 1'b1;
                        end
                    endcase
                end
                
                //I-TYPE
                OP_IMM_OPCODE:begin
                    b_sel_o = OP_B_IMM_I;
                    gpr_we_o = 1'b1;
                    case(funct3)
                        3'b000: alu_op_o = ALU_ADD;  //ADDI
                        3'b010: alu_op_o = ALU_SLTS; //SLTI
                        3'b011: alu_op_o = ALU_SLTU; //SLTIU
                        3'b100: alu_op_o = ALU_XOR;  //XORI
                        3'b110: alu_op_o = ALU_OR;   //ORI
                        3'b111: alu_op_o = ALU_AND;  //ANDI
                        
                        //SLLI
                        3'b001:begin
                            illegal_instr_o = (funct7 != 7'b0000000);
                            gpr_we_o = !illegal_instr_o;
                            alu_op_o = (!illegal_instr_o) ? ALU_SLL : ALU_ADD;
                        end
                        
                        //SRLI or SRAI
                        3'b101:begin
                            case(funct7)
                                7'b0000000: alu_op_o = ALU_SRL; //SRLI
                                7'b0100000: alu_op_o = ALU_SRA; //SRAI
                                default: begin
                                    illegal_instr_o = 1'b1;
                                    gpr_we_o = 1'b0;
                                end 
                            endcase
                        end
                        
                        default: begin
                            illegal_instr_o = 1'b1;
                            gpr_we_o = 1'b0;
                        end
                    endcase
                end
                
                //R-TYPE
                OP_OPCODE:begin
                    gpr_we_o = 1'b1;
                        case(funct7)
                        7'b0000000:begin
                            case(funct3)
                                3'b000: alu_op_o = ALU_ADD;  //ADD
                                3'b001: alu_op_o = ALU_SLL;  //SLL
                                3'b010: alu_op_o = ALU_SLTS; //SLT
                                3'b011: alu_op_o = ALU_SLTU; //SLTU 
                                3'b100: alu_op_o = ALU_XOR;  //XOR
                                3'b101: alu_op_o = ALU_SRL;  //SRL
                                3'b110: alu_op_o = ALU_OR;   //OR
                                3'b111: alu_op_o = ALU_AND;  //AND
                                
                                default: begin
                                    illegal_instr_o = 1'b1;
                                    gpr_we_o = 1'b0;
                                end 
                            endcase
                        end
                        
                        7'b0100000:begin
                            case(funct3)
                                3'b000: alu_op_o = ALU_SUB; //SUB
                                3'b101:alu_op_o = ALU_SRA;  //SRA
                                
                                default: begin
                                    illegal_instr_o = 1'b1;
                                    gpr_we_o = 1'b0;
                                end 
                            endcase
                        end
                        default: begin
                            illegal_instr_o = 1'b1;
                            gpr_we_o = 1'b0;
                        end 
                    endcase
                
                end 
    
                //FENCE
                //NO OPERATION
                MISC_MEM_OPCODE:begin
                    if(funct3 != 3'b000)
                        illegal_instr_o = 1'b1;
                end
                
                
                SYSTEM_OPCODE:begin
                    if(funct3 != 3'b000)begin
                        csr_we_o = 1'b1;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                        case(funct3)
                            3'b001: csr_op_o = CSR_RW;  //CSRRW
                            3'b010: csr_op_o = CSR_RS;  //CSRRS
                            3'b011: csr_op_o = CSR_RC;  //CSRRC
                            3'b101: csr_op_o = CSR_RWI; //CSRRWI
                            3'b110: csr_op_o = CSR_RSI; //CSRRSI
                            3'b111: csr_op_o = CSR_RCI; //CSRRCI
                            default:begin
                                csr_we_o = 1'b0;
                                gpr_we_o = 1'b0;
                                illegal_instr_o = 1'b1;
                            end
                        endcase
                    end
    
                    //MRET
                    else if(funct7 == 7'b0011000 && rs2 == 5'b010 && rs1 == 5'b0 && rd == 5'b0)
                        mret_o = 1'b1;
                    
                    //ECALL + EBREAK
                    else 
                        illegal_instr_o = 1'b1;
    
                    end
                    
                default: begin
                    illegal_instr_o = 1'b1;
                end
                
            endcase 
        end
    end
    
endmodule
