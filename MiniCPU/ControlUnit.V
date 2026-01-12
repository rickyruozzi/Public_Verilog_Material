module ControlUnit(
    input  wire [1:0] opcode_i,  // Opcode [7:6]
    input  wire [1:0] rd_i,      // Registro destinazione [5:4]
    input  wire [1:0] rs1_i,     // Registro sorgente [3:2]
    input  wire [1:0] imm2_i,    // Immediato [1:0]

    output reg reg_write_en, //abilita la scrittura
    output reg mem_write_en, //abilita la scrittura in memoria
    output reg alu_op, //seleziona l'operazione dell'ALU
    output reg writeback_sel //seleziona il dato da scrivere nel registro di destinazione
);
    always @(*) begin 
        reg_write_en = 0;
        mem_write_en = 0;
        alu_op = 0;
        writeback_sel = 0;

        case(opcode_i)
            2'b00: begin 
                reg_write_en = 1; //istruzione di tipo R
                alu_op = 0; //operazione di addizione
                mem_write_en = 0; //non scriviamo in memoria
                writeback_sel = 0; //scriviamo nel register file
            end
            2'b01 : begin 
                reg_write_en = 1;
                mem_write_en = 0;
                alu_op = 1; //operazione di xor
                writeback_sel = 0; //scriviamo nel register file
            end
            2'b10 : begin 
                reg_write_en = 0; 
                mem_write_en = 0;
                alu_op = 0; //addizione per calcolare l'offset
             end
             2'b11 : begin 
                reg_write_en = 0;
                mem_write_en =1; //store
                alu_op = 0; //addizione per calcolare l'offset
             end
             default : 
                begin 
                    reg_write_en = 0;
                    mem_write_en = 0;
                    alu_op = 0;
                    writeback_sel = 0;
                end
        endcase
    end
endmodule;