module FSM101 (
    input  clk,
    input  reset_in,        // reset sincrono attivo basso
    input  in_bit,
    output seq_detected
);

    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (!reset_in)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S0: begin
                if (in_bit) next_state = S1;
                else        next_state = S0;
            end

            S1: begin
                if (in_bit) next_state = S1;
                else        next_state = S2;
            end

            S2: begin
                if (in_bit) next_state = S3;
                else        next_state = S0;
            end

            S3: begin
                if (in_bit) next_state = S1;
                else        next_state = S2;
            end
        endcase
    end

    assign seq_detected = (state == S3);

endmodule
