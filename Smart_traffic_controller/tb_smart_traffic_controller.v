`timescale 1ns/1ps //setting della timescale

module tb_smart_traffic_controller;

    // Segnali di test 
    reg clk; //segnale di clock 
    reg reset_ni; //segnale di reset attivo basso
    reg carB_i; //segnale del sensore  del semaforo B

    //segnale di output
    wire A_red_o; 
    wire A_yellow_o;
    wire A_green_o;
    wire B_red_o;
    wire B_yellow_o;
    wire B_green_o;

    // DUT - inizializzazione dell'istanza del modulo smart_traffic_controller
    smart_traffic_controller DUT (
        .clk_i(clk),
        .reset_ni(reset_ni),
        .carB_i(carB_i),
        .A_red_o(A_red_o),
        .A_yellow_o(A_yellow_o),
        .A_green_o(A_green_o),
        .B_red_o(B_red_o),
        .B_yellow_o(B_yellow_o),
        .B_green_o(B_green_o)
    );

    initial begin
    $dumpfile("sim.vcd");  
    $dumpvars(0, tb_smart_traffic_controller); 
    end
    
    // settiamo il periodo di clock su 10 ns, ogni 5 avviene il cambio fronte
    always #5 clk = ~clk;

    initial begin

        //ogni 5 secondi cambierrà il segnale di clock automaticamente
        // inizializziamo i segnali
        clk      = 0; 
        reset_ni = 0;
        carB_i   = 0;
    
        //aziamo il reset
        #20;
        reset_ni = 1;

        // Attesa delo stato IDLE
        #20;

        // Inviamo il segnale dal semaforo B
        carB_i = 1;
        #10;
        carB_i = 0;

        // simulazione di un ulteriore segnale da ignorare se il circuito è già in funzione
        #20;
        carB_i = 1;
        #10;
        carB_i = 0;

        // Attesa fine sequenza
        #100;

        $finish;
    end

endmodule
