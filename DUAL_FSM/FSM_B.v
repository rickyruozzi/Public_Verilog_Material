module fsm_B (
    input  clk,
    input  reset_n,
    input  enable_B,
    output done_B
);

parameter B_IDLE = 2'b00; 
parameter B_WORK = 2'b01;

reg [1:0] state, next_state; 
reg[1:0] counter; 

always @(posedge clk) begin 
    if(!reset_n) begin 
        next_state <= B_IDLE;
        counter <= 2'b00;
    end
    else begin 
        state <= next_state;
        if(state == B_WORK) begin 
            counter <= counter + 1; 
        end
        else begin 
            counter <= 2'b00;
        end
    end
end

always @(*) begin 
    next_state = state; 
    case(state)
    B_IDLE : begin 
        if(enable_B) begin 
            next_state = B_WORK;
        end
    end
    B_WORK : begin 
        if(counter == 2'b11) begin 
            next_state = B_IDLE;
        end
    end
end

assign done_B = (state == B_IDLE); //done_B is high in B_IDLE state

endmodule;