module miniCPU(
    input wire clk, 
    input wire reset
);
    //campi dell'istruzione
    reg [7:0] pc; 
    reg [7:0] instruction;
    wire [1:0] opcode;
    wire [1:0] rd;
    wire [1:0] rs1;
    wire [1:0] imm2;

    // Assegnamento dei campi dell'istruzione
    assign opcode = instruction[7:6];
    assign rd = instruction[5:4];
    assign rs1 = instruction[3:2];
    assign imm2 = instruction[1:0];

    //segnali per il register file
    wire reg_rite_en; 
    wire mem_write_en;
    wire alu_op;
    wire writeback_sel;

    //dati 
    wire [7:0] rs1_data, rd_data, mem_data, alu_res, wb_data;

    always @(posedge clk or posedge reset) begin //permette di aggiornare il pc in maniera sincrona
        if (reset) pc <= 8'b0;
        else     pc <= pc + 1;
    end

    //instruction memory 
    reg [7:0] instruction_memory [7:0];
    assign instruction = instruction_memory[pc];

    //istanza del register file
    registerFile RF (
        .clk(clk),
        .reset(reset),
        .reg1_addr(rs1),
        .regDest(rd),
        .write_data(wb_data),
        .w_enable(reg_write_en),
        .reg1_data(rs1_data),
        .read_data(rd_data)
    );

    //alu operations
    assign alu_res = (alu_op == 1'b00) ? (rs1_data + {6'b0, imm2}) : (rs1_data ^ {6'b0, imm2});
    
    //data memory
    reg [7:0] data_memory [3:0];
    assign mem_data = data_memory[rd_data[1:0]]; 
    //uso i bit meno significativi di rd_data come indirizzo
    always @(posedge clk) begin 
        if(mem_write_en) begin 
            data_memory[rd_data[1:0]] <= rs1_data; 
            //scrivo in memoria il dato proveniente dal registro sorgente
        end        
    end
    //writeback mux
    assign wb_data = (writeback_sel == 1'b00) ? alu_res : mem_data; 

    initial begin
        // Inizializzare a zero per sicurezza
        for (integer i=0; i<8; i++) instruction_memory[i] = 8'h0;
    end

endmodule