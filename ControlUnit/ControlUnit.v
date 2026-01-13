module controlUnit(
input [6:0] inst_opcode,
input take_branch,
output reg pc_write_enable,
output reg regfile_write_enable,
output reg alu_operand_a_select,
output reg alu_operand_b_select,
output reg [1:0] alu_op_type,
output reg data_mem_read_enable,
output reg data_mem_write_enable,
output reg [1:0] reg_writeback_select,
output reg [1:0] next_pc_select
);

always @(*) begin
    pc_write_enable = 1'b1; //avanza di 4 di default 
    regfile_write_enable = 1'b0; //write enable sul register file
    alu_operand_a_select = 1'b0; // selezionatore del primo registro
    alu_operand_b_select = 1'b0; //selezionatore del secondo registro
    alu_op_type = 2'b00; //alu operand di default
    data_mem_read_enable = 1'b0; //attivazione della lettura da memoria
    data_mem_write_enable = 1'b0;  //attivazione della scrittura in memoria
    reg_writeback_Select = 2'b00;  //selezione del registro su cui scrivere il valore di ritorno 
    next_pc_select = 2'b00; //PC + 4 d default

    case(inst_opcode)

            // R-TYPE (ADD, SUB, AND, OR, ...)
            7'b0110011: begin
                regfile_write_enable = 1'b1;
                alu_op_type          = 2'b10;
            end

            // I-TYPE ALU (ADDI, ANDI, ...)
            7'b0010011: begin
                regfile_write_enable = 1'b1;
                alu_operand_b_select = 1'b1; // immediate
                alu_op_type          = 2'b10;
            end

            // LOAD (LW)
            7'b0000011: begin
                regfile_write_enable  = 1'b1;
                alu_operand_b_select  = 1'b1;
                data_mem_read_enable  = 1'b1;
                reg_writeback_select  = 2'b01; // memoria
            end

            // STORE (SW)
            7'b0100011: begin
                alu_operand_b_select  = 1'b1;
                data_mem_write_enable = 1'b1;
            end

            // BRANCH (BEQ, BNE, ...)
            7'b1100011: begin
                alu_op_type = 2'b01; // SUB per confronto

                if (take_branch) 
                    next_pc_select = 2'b01; // branch target
            end

            // JAL
            7'b1101111: begin
                regfile_write_enable = 1'b1;
                reg_writeback_select = 2'b10; // PC + 4
                next_pc_select       = 2'b10; // jump
            end

            // JALR
            7'b1100111: begin
                regfile_write_enable = 1'b1;
                alu_operand_b_select = 1'b1;
                reg_writeback_select = 2'b10;
                next_pc_select       = 2'b10;
            end

            default: begin
                // istruzione non supportata → NOP
            end

        endcase
end

endmodule;