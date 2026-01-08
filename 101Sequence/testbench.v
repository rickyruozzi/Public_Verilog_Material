`timescale 1ns/1ps
module testbench;
    reg clk;
    reg reset;
    reg in;
    wire out;
    FSM101 uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );
    
    always #5 clk = ~clk;

    initial begin
        $dumpfile("fsm101.vcd");
        $dumpvars(0, testbench);
        clk = 0; 
        reset = 0; 
        in = 0;
        #10;
        reset = 1;
        #10; in = 1;
        #10; in = 0;
        #10; in = 1;
        $display("Output after sequence 101: %b", out);
        #10; in = 1;
        #10; in = 1;
        #10; in = 0;
        #10; in = 0;
        #10; in = 1;
        #10; in = 0;
        #10; in = 1;
        $display("Output after sequence 101: %b", out);
        #10; in = 0;
        $finish;
     end
endmodule;