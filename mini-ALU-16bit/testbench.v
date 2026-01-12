module ALUtestbench;
    reg [15:0] a_i;
    reg [15:0] b_i;
    reg [3:0] op_i;
    reg [3:0] shamt_i;
    wire [15:0] res_o;
    miniALU uut (
        .a_i(a_i),
        .b_i(b_i),
        .op_i(op_i),
        .shamt_i(shamt_i),
        .res_o(res_o)
    );
    initial begin
        $dumpfile("alu_testbench.vcd");
        $dumpvars(0, ALUtestbench);
        // Test ADD
        a_i = 16'h0005; b_i = 16'h0003; op_i = 4'b0000; shamt_i = 4'b0000;
        #1; // Aspetta un ciclo
        $display("ADD: a_i=%h, b_i=%h, res_o=%h, expected=%h", a_i, b_i, res_o, 16'h0008);
        if (res_o !== 16'h0008) $display("ADD Test Failed");
        else $display("ADD Test Passed");
        #10;
        // Test SUB
        a_i = 16'h0005; b_i = 16'h0003; op_i = 4'b0001; shamt_i = 4'b0000;
        #1;
        $display("SUB: a_i=%h, b_i=%h, res_o=%h, expected=%h", a_i, b_i, res_o, 16'h0002);
        if (res_o !== 16'h0002) $display("SUB Test Failed");
        else $display("SUB Test Passed");
        #10;
        // Test AND
        a_i = 16'h00FF; b_i = 16'h0F0F; op_i = 4'b0010; shamt_i = 4'b0000;
        #1;
        $display("AND: a_i=%h, b_i=%h, res_o=%h, expected=%h", a_i, b_i, res_o, 16'h000F);
        if (res_o !== 16'h000F) $display("AND Test Failed");
        else $display("AND Test Passed");
        #10;
        // Test OR
        a_i = 16'h00FF; b_i = 16'h0F0F; op_i = 4'b0011; shamt_i = 4'b0000;
        #1;
        if (res_o !== 16'h0FFF) $display("OR Test Failed: %h | %h != %h", a_i, b_i, res_o);
        else $display("OR Test Passed: %h | %h = %h", a_i, b_i, res_o);
        #10;
        // Test XOR
        #1;
        a_i = 16'h00FF; b_i = 16'h0F0F; op_i = 4'b0100; shamt_i = 4'b0000;
        if (res_o !== 16'h0FF0) $display("XOR Test Failed: %h ^ %h != %h", a_i, b_i, res_o);
        else $display("XOR Test Passed: %h ^ %h = %h", a_i, b_i, res_o);
        #10;
        // Test NOT
        a_i = 16'h00FF; b_i = 16'h0000; op_i = 4'b0101; shamt_i = 4'b0000;
        #1;
        if (res_o !== 16'hFF00) $display("NOT Test Failed: ~%h != %h", a_i, res_o);
        else $display("NOT Test Passed: ~%h = %h", a_i, res_o);
        #10;
        // Test LSL
        a_i = 16'h0001; b_i = 16'h0000; op_i = 4'b0110; shamt_i = 4'b0011;
        #1;
        if (res_o !== 16'h0008) $display("LSL Test Failed: %h << 3 != %h", a_i, res_o);
        else $display("LSL Test Passed: %h << 3 = %h", a_i, res_o);
        #10;
        // Test LSR
        a_i = 16'h8000; b_i = 16'h0000; op_i = 4'b0111; shamt_i = 4'b0011;
        #1;
        if (res_o !== 16'h1000) $display("LSR Test Failed: %h >> 3 != %h", a_i, res_o);
        else $display("LSR Test Passed: %h >> 3 = %h", a_i, res_o);
        #10;
        // Test ASR
        a_i = 16'h8000; b_i = 16'h0000; op_i = 4'b1000; shamt_i = 4'b0011;
        #1; //ritardo artificiale per attendere che l'assegnazione avvenga
        if (res_o !== 16'hF000) $display("ASR Test Failed: %h >>> 3 != %h", a_i, res_o);
        else $display("ASR Test Passed: %h >>> 3 = %h", a_i, res_o);
        #10;
        $finish;
    end
endmodule