'`timescale 1ns/1ps
module tb_pur; 
    parameter n=8; //larghezza del registro
    reg clk_i; //clock signal
    reg reset_ni; //reset signal
    reg [1:0] mode_i; //00=hold, 01=shift-left, 10=shift-right, 11=load
    reg [n-1:0] data_i; //load data input
    wire [n-1:0] data_o; //output_del registro
    reg ser_i; //input seriale per lo shift

    pur uut(
        .clk_i(clk_i),
        .reset_ni(reset_ni),
        .mode_i(mode_i),
        .data_i(data_i),
        .ser_i(ser_i),
        .data_o(data_o)
    );

    initial begin
        $dumpfile("tb_pur.vcd");
        $dumpvars(0, tb_pur); 
     end

     always #5 clk_i = ~clk_i; //clock con periodo di 10ns, cambio di fronte ogni 5 ns

     initial begin 
        clk_i=0; 
        reset_ni=0;
        mode_i=2'b00; 
        data_i=8'b00000000;
        ser_i=1'b0;
        #15;
        reset_ni=1; //disabilitiamo il segnale di reset
        #10;
        mode_i=2'b11; //load 
        data_i=8,b 01010101; //valore da caricare nel registro
        #10;
        mode_i=2'b00; //hold
        #10;
        mode_i=2'b01; //shift-left
        ser_i=1'b1; //valore seriale da inserire nello shift
        #10;
        mode_i=2'b10; //shift-right 
        ser_i=1'b0; //valore seriale da inserire nello shift
        #10;
     end
endmodule