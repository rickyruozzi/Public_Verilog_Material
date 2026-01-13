`timescale 1ns / 1ps

module testbench;

parameter NREGS = 32;
parameter XLEN = 32;
parameter LOG2_NREGS = $clog2(NREGS);

// Signals
reg clk;
reg reset;
reg write_enable;
reg [LOG2_NREGS-1:0] waddr_i;
reg [XLEN-1:0] write_data_i;
reg [LOG2_NREGS-1:0] read_addr1;
wire [XLEN-1:0] read_data1;
reg [LOG2_NREGS-1:0] read_addr2;
wire [XLEN-1:0] read_data2;

// Instantiate the register file
registerFile #(NREGS, XLEN) rf (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .waddr_i(waddr_i),
    .write_data_i(write_data_i),
    .read_addr1(read_addr1),
    .read_data1(read_data1),
    .read_addr2(read_addr2),
    .read_data2(read_data2)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars(0, testbench);
    // Initialize
    clk = 0;
    reset = 0;
    write_enable = 0;
    waddr_i = 0;
    write_data_i = 0;
    read_addr1 = 0;
    read_addr2 = 0;

    // Reset
    #10 reset = 1;

    // Test writing to register 1
    #10 write_enable = 1;
    waddr_i = 1;
    write_data_i = 32'hDEADBEEF;
    #10 write_enable = 0;

    // Read register 1
    read_addr1 = 1;
    #10;
    if (read_data1 !== 32'hDEADBEEF) $display("ERROR: Register 1 read failed");

    // Test writing to register 2
    write_enable = 1;
    waddr_i = 2;
    write_data_i = 32'hCAFEBABE;
    #10 write_enable = 0;

    // Read both registers
    read_addr1 = 1;
    read_addr2 = 2;
    #10;
    if (read_data1 !== 32'hDEADBEEF) $display("ERROR: Register 1 read failed");
    if (read_data2 !== 32'hCAFEBABE) $display("ERROR: Register 2 read failed");

    // Test register 0 is always 0
    read_addr1 = 0;
    #10;
    if (read_data1 !== 0) $display("ERROR: Register 0 should be 0");

    // Test reset
    reset = 0;
    #10 reset = 1;
    read_addr1 = 1;
    #10;
    if (read_data1 !== 0) $display("ERROR: Reset failed");

    $display("Test completed");
    $finish;
end

endmodule