module registerFile(
    input wire clk, 
    input wire reset, 
    input wire [1:0] reg1_addr, //indirizzo del primo registro da leggere 
    input wire [1:0] regDest, //indirizzo del registro su cui scrivere
    input wire [7:0] write_data, //dato da scrivere nel registro
    input wire w_enable; //flag di abilitazione della scrittura
    output wire [7:0] reg1_data, //dato letto dal primo registro
    output wire [7:0] read_data //dato letto dal registro di destinazione
);
reg [7:0] registers[3:0]; //registri del register file
assign reg1_data = (reg1_addr == 2'b00) ? 8'b0 : registers[reg1_addr]; //assegniamo il valore del primo registro da leggere a reg1_data
assign read_data  = (regDest  == 2'b00) ? 8'b0 : registers[regDest]; //assegniamo il valore del registro di destinazione a read_data
always @(posedge clk or negedge reset) begin //in maniera sincrona
    if(reset==0) begin 
        registers[0]<=8'b0; //in caso resettiamo il register file
        registers[1]<=8'b0; 
        registers[2]<=8'b0; 
        registers[3]<=8'b0; 
    end else begin 
        if(w_enable && regDest != 2'b00) begin //altrimenti se è abilitata la scrittura 
            registers[regDest]<=write_data; //scrivo il valore nel registro di destinazione
        end
    end
end
endmodule
