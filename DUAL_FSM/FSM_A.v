module fsm_A (
    input  clk,
    input  reset_n,
    input  start,
    input  done_B,
    output enable_B
);

parameter A_IDLE = 2'b00;
parameter A_RUN = 2'b01;
parameter A_WAIT = 2'b10; 

reg[1:0] state, next_state; 
reg[1:0] counter; 

always @(posedge clk) begin 
    if(!reset) begin //active low reset
        state <= A_IDLE;  
        counter <= 2'b00;
    end
    else
    begin 
        state <= next_state; //state transition 
        if(state  == A_RUN) begin  //counter only increments in B_RUN state
            counter <= counter +1 ; 
        end
        else begin 
            counter <= 2'b00 ; //keep counter at 0 in other states
        end
    end
end

always @(*) begin 
    next_state = state; //default next state
    case (state) 
    IDLE: begin  //wait for start signal
        if(start) begin 
            next_state = A_RUN; 
        end
    A_RUN: begin
        if(counter == 2'b10) begin  //after 2 clock cycles in A_RUN, move to A_WAIT
            next_state = A_WAIT;
        end
    end
    A_WAIT: begin //move to B_RUN immediately 
        if(done_B) begin 
            next_state = A_IDLE; 
        end
    end
    end
end
assign enable_B = (state == A_RUN) ? 1'b1 : 1'b0; //enable_B is high in A_WAIT state
endmodule
