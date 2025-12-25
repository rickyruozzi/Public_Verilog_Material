`timescale 1ns/1ps
module tb_pur; 
    parameter n=8; //larghezza del registro
    reg clk_i; //clock signal
    reg reset_ni; //reset signal
    reg [1:0] mode_i; //00=hold, 01=shift-left, 10=shift-right, 11=load
    reg [n-1:0] data_i; //load data input
    wire [n-1:0] data_o; //output_del registro
    reg ser_i; //input seriale per lo shift

    initial begin
        clk_i = 0;
    end

    Parametric_universal_register #(.n(n)) uut(
        .clk_i(clk_i),
        .reset_ni(reset_ni),
        .mode_i(mode_i),
        .data_i(data_i),
        .ser_i(ser_i),
        .data_o(data_o)
    );

    initial begin
        $dumpfile("tb_pur.vcd"); //nome del file di dump
        $dumpvars(0, tb_pur);  //variabili di dump 
     end

     always #5 clk_i = ~clk_i; //clock con periodo di 10ns, cambio di fronte ogni 5 ns

initial begin
    reset_ni=0;
    mode_i=2'b00;
    data_i=0;
    ser_i=0;
    #2;
    if (data_o !== 0)
        $display("TEST FAILED: reset non funzionante"); //verifica del reset

    reset_ni = 1; //attivazionde del reset
    @(posedge clk_i); //attesa del fronta di salita del clock    
    #1; //ritardo usato per permettere l'aggiornamento dei segnali 
    $display("After reset release, data_o = %b", data_o); 
    //stampiamo il valore di data_o dopo il rilascio del reset

    mode_i = 2'b11; //modalità per il caricamento 
    data_i = 8'b01010101; //valore da caricare 
    @(posedge clk_i); //attesa del clock
    #1; 
    $display("After load, data_o = %b", data_o);

    if (data_o !== 8'b01010101)
        $display("TEST FAILED: load non funzionante");

    mode_i = 2'b00; //modalità hold
    @(posedge clk_i);
    #1;
    $display("After hold, data_o = %b", data_o);

    if (data_o !== 8'b01010101)
        $display("TEST FAILED: hold non funzionante");

    mode_i = 2'b01; //modalità shift-left
    ser_i  = 1'b1;
    @(posedge clk_i);
    #1;
    $display("After shift left, data_o = %b", data_o);

    if (data_o !== 8'b10101011)
        $display("TEST FAILED: shift-left non funzionante");

    mode_i = 2'b10; //modalità shift-right
    ser_i  = 1'b0;
    @(posedge clk_i);
    #1;
    $display("After shift right, data_o = %b", data_o);

    if (data_o !== 8'b01010101)
        $display("TEST FAILED: shift-right non funzionante");

    $display("ALL TESTS PASSED");
    $finish;
end

endmodule