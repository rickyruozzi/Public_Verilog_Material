module FSM101(
    input clk, 
    input reset, 
    input in,
    output reg out
)

localparam s0 = 2'b00; 
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or negedge reset) begin 
    if(!reset)
        state <= S0; 
    else
        state <= next_state;
end

always @(*) begin 
    case(state)
    S0: begin 
        if(in)
            next_state = S1; 
        else 
            next_state
    end
    S1: begin 
        if(in)
            next_state = S1;
        else 
            next_state = S2;
    end
    S2: begin 
        if(in)
            next_state = S3;
        else 
            next_state = S0;
    end
    S3: begin 
        if(in)
            next_state = S1;
        else 
            next_state = S2;
    end
end

assign out = (state == S3);

endmodule;