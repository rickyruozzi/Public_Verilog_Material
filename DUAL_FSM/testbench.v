`timescale 1ns/1ps
module testbench;

    reg clk; 
    reg reset_n;
    reg start;

    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .start(start)
    );

    always #5 clk = ~clk;

    initial begin 
        dumpfile("dual_fsm.vcd");
        dumpvars(0, testbench);

        clk=0; 
        reset_n=0; 
        start=0; 

        #10;
        reset_n=1;
        #20;
        //start
        start=1;
        #10;
        start=0;
        #100;
        //fine prima sequenza
        //seconda sequenza
        #20;
        start=1;
        #10;
        start=0;
        #100;
        $finish; //serve per terminare la simulazoìione
    end
endmodule