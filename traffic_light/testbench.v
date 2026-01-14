`timescale 1ns/1ps

module tb_traffic_light;

    // Segnali
    reg clk;
    reg rst;
    wire red, yellow, green;

    // Istanza del DUT
    traffic_light DUT(
        .clk(clk),
        .rst(rst),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Clock 10 ns (50 MHz circa)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimoli: reset e simulazione
    initial begin
        // Inizializzazione
        rst = 0;  // reset attivo basso
        #12 rst = 1; // rilascio reset

        // Simulazione lunga abbastanza per vedere più cicli del semaforo
        #100 $finish;
    end

    // Monitor dei segnali in console
    initial begin
        $display("Time\tclk\tr\tg\ty");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, clk, red, green, yellow);
    end

    // Dump per GTKWave
    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);
    end

endmodule
