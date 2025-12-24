module smart_traffic_controller (
    /*Ci servono 3 segnali in input: clk_i (segnale di clock), 
    reset_ni (segnale di reset attivo basso), 
    carB_i (Segnale di attivazione del semaforo B)*/
    input  wire clk_i, 
    input  wire reset_ni,
    input  wire carB_i,
    output reg  A_red_o,
    output reg  A_yellow_o,
    output reg  A_green_o,
    output reg  B_red_o,
    output reg  B_yellow_o,
    output reg  B_green_o
);

    // Definizione degli stati tramite costanti locali
    localparam S_IDLE      = 2'b00; // A verde, B rosso
    localparam S_A_YELLOW  = 2'b01; // A giallo, B rosso
    localparam S_B_GREEN   = 2'b10; // A rosso, B verde
    localparam S_B_YELLOW  = 2'b11; // A rosso, B giallo

    // Registri per lo stato corrente e successivo
    reg [1:0] cs, ns;

    // Timer per contare i cicli di clock in ogni stato
    reg [1:0] timer, next_timer;

    // --- Logica sequenziale: aggiornamento stato e timer ---
    always @(posedge clk_i or negedge reset_ni) begin
        if (!reset_ni) begin
            cs <= S_IDLE;      // stato iniziale
            timer <= 2'd0;     // timer azzerato
        end else begin
            cs <= ns;          // Aggiorna stato corrente
            timer <= next_timer; // Aggiorna timer
        end
    end

    // --- Logica combinatoria: transizione degli stati ---
    always @(*) begin
        ns = cs;             // Default: rimani nello stato corrente
        next_timer = timer;  // Default: timer non cambia

        case (cs)
            S_IDLE: begin
                next_timer = 2'd0; // Azzeriamo il timer
                if (carB_i) begin
                    ns = S_A_YELLOW; // Passa ad A giallo se arriva una macchina
                end
            end

            S_A_YELLOW: begin
                if (timer == 2'd1) begin
                    ns = S_B_GREEN;   // Passa a B verde dopo 1 ciclo
                    next_timer = 2'd0; 
                end else begin
                    next_timer = timer + 2'd1; // Incrementa timer
                end
            end

            S_B_GREEN: begin
                if (timer == 2'd2) begin
                    ns = S_B_YELLOW;  // Passa a B giallo dopo 2 cicli
                    next_timer = 2'd0;
                end else begin
                    next_timer = timer + 2'd1;
                end
            end

            S_B_YELLOW: begin
                if (timer == 2'd1) begin
                    ns = S_IDLE;      // Torna allo stato iniziale
                    next_timer = 2'd0;
                end else begin
                    next_timer = timer + 2'd1;
                end
            end

            default: begin
                ns = S_IDLE;        // Default safety
                next_timer = 2'd0;
            end
        endcase
    end

    // --- Logica combinatoria: assegnazione degli output ---
    always @(*) begin
        // Default: tutti i semafori spenti
        A_red_o     = 1'b0;
        A_yellow_o  = 1'b0;
        A_green_o   = 1'b0;
        B_red_o     = 1'b0;
        B_yellow_o  = 1'b0;
        B_green_o   = 1'b0;

        case (cs)
            S_IDLE: begin
                A_green_o = 1'b1; // A verde
                B_red_o   = 1'b1; // B rosso
            end

            S_A_YELLOW: begin
                A_yellow_o = 1'b1; // A giallo
                B_red_o    = 1'b1; // B rosso
            end

            S_B_GREEN: begin
                A_red_o   = 1'b1; // A rosso
                B_green_o = 1'b1; // B verde
            end

            S_B_YELLOW: begin
                A_red_o     = 1'b1; // A rosso
                B_yellow_o  = 1'b1; // B giallo
            end
        endcase
    end

endmodule

/* SPIEGAZIONE:
- Input: clk_i (clock), reset_ni (reset attivo basso), carB_i (sensore veicolo B)
- Output: segnali per semafori A e B

1. Always sincrono: aggiorna lo stato corrente e il timer ad ogni clock, resetta se reset_ni = 0
2. Always combinatorio stato: calcola il prossimo stato e il prossimo timer in base allo stato corrente e al sensore
3. Always combinatorio output: assegna i segnali dei semafori in base allo stato corrente
*/
