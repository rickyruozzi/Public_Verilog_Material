module top_module(
    input  clk,
    input  reset_n,
    input  start
);

    wire enable_b; 
    wire done_b;

    FSM_A a_inst (
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .done_B(done_b),    
        .enable_B(enable_b)
    );

    /*In pratica FSM_A parte in IDLE, quando start è attivo FSM_A entra in fase di 
    esecuzione e quando A è in esecuzione si attiva il segnale di attivazione di B.
    Dopo l'attivazione di B, esso svolge lavoro per 3 cicli di clock e poi termina tornando in IDLE. 
    Quando termina si attiva il segnale Done_B che porta A alla terminazione.*/

    FSM_B b_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable_B(enable_b),
        .done_B(done_b)
    );

endmodule