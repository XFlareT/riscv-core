package memory_pkg;
    localparam INSTR_MEM_SIZE_BYTES = 512;
    localparam INSTR_MEM_SIZE_WORDS = INSTR_MEM_SIZE_BYTES / 4; // количество слов(ячеек)
    localparam DATA_MEM_SIZE_BYTES  = 512;
    localparam DATA_MEM_SIZE_WORDS  = DATA_MEM_SIZE_BYTES / 4;
endpackage