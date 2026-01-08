`timescale 1ns/1ps
module testbench;
    reg clk;
    reg reset_in;
    reg in_bit;
    wire seq_detected;
    FSM101 uut (
        .clk(clk),
        .reset_in(reset_in),
        .in_bit(in_bit),
        .seq_detected(seq_detected)
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