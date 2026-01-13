module registerFile(
    input wire clk, //segnale di clock
    input wire reset, //segnale di reset, attivo basso
    input wire write_enable, //autorizzazione per la scrittura
    input wire [LOG2_NREGS-1:0] waddr_i,  //registro su cui vogliamo scrivere
    input wire [XLEN-1:0] write_data_i, //dato da scrivere nel registro
    input wire [LOG2_NREGS-1:0] read_addr1, //indirizzo da leggere 1
    output wire [XLEN-1:0] read_data1,  //dato letto dall'inidirzzo 1
    input wire [LOG2_NREGS-1:0] read_addr2,  //indirizzo da leggere 2
    output wire [XLEN-1:0] read_data2 //dato letto dall'indirizzo 2
);

parameter NREGS= 32; //numero di registri
parameter XLEN = 32; //lunghezza dei registri
parameter LOG2_NREGS = $clog2(NREGS);  //numero di bit che ci servono per rappresentare i nosri registri

integer i; //intero per l'interazione, non possiamo dichiararlo nel ciclo con iverilog
reg [XLEN-1:0] regs [0:NREGS-1]; //array per i registri 
always @(posedge clk or negedge reset) begin //aspettando il prossimo clock 
    if(reset==0) begin //se il rset è attivo resettiamo i registri 
        for(i=0; i<NREGS; i=i+1) begin 
            regs[i] <= {XLEN{1'b0}}; //scrive il valore 0 in tutti i registri
        end
    end //se è abilitata la scrittura
    else if(write_enable && waddr_i != 0)
    begin 
        regs[waddr_i] <= write_data_i; //scriviamo il dato specificato nel registro di dato 
    end
end
assign read_data1 = (read_addr1 == {LOG2_NREGS{1'b0}}) ? {XLEN{1'b0}} : regs[read_addr1]; //lettura dei due indirizzi specificati
assign read_data2 = (read_addr2 == {LOG2_NREGS{1'b0}}) ? {XLEN{1'b0}} : regs[read_addr2];

endmodule