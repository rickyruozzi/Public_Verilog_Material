module traffic_light(
    input wire clk, 
    input wire rst, 
    output reg red, 
    output reg yellow, 
    output reg green
);
localparam GREEN = 2'b00;
localparam YELLOW = 2'b01;
localparam RED = 2'b10; 
reg [1:0] state, next_state;
reg [2:0] timer, next_timer; 

always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        state <= RED;
    end
    else 
    begin 
        state <= next_state; 
        timer <= next_timer; 
    end
end

always @(*) begin  
    next_timer= timer;
    next_state = state;

    case(state)
    GREEN : begin 
        if(timer == 3'd3) begin 
            next_state = YELLOW ;
        end  
        else 
        begin 
            next_timer= timer + 3'd1 ; 
        end
    end
    YELLOW : begin
         if(timer == 3'd1) begin next_state = RED; 
        end 
        else 
        begin next_timer = timer + 3'd1; end
        end
    RED : begin 
        if(timer == 3'd5) begin 
            next_state = GREEN; 
        end
        else begin 
            next_timer = timer + 3'd1; 
        end
    end
    endcase
end

always @(*) begin 
    red = 1'b0; 
    yellow = 1'b0; 
    green = 1'b0;
    case(state)
    RED: begin 
        red = 1;
    end 
    YELLOW: begin 
        yellow = 1;
    end
    GREEN : begin 
        green = 1;
    end
    endcase
end

endmodule