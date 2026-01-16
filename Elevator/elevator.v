module elevator(
    input wire clk, 
    input wire rst, 
    input wire [1:0] call, 
    input wire [1:0] floor, 
    output reg motor_up, 
    output reg motor_down, 
    output reg door_open
);

localparam IDLE = 2'b00;
localparam MOVING_UP = 2'b01;
localparam MOVING_DOWN = 2'b10;
localparam DOOR_OPEN = 2'b11;

reg [1:0] state, next_state; 
reg [2:0] timer, next_timer;

localparam D_O_TIME = 3'd3;

always @(posedge clk or negedge rst) begin
    if(!rst ) begin 
        state<=IDLE;
        timer<=0;
    end
    else begin 
        state<=next_state; 
        timer<=next_timer; 
    end
end

always @(*) begin 
    next_state = state; 
    next_timer = timer; 
    case(state) 
    IDLE : begin 
        if(call > floor) begin 
            next_state = MOVING_UP;
        end
        if(call < floor) begin 
            next_state = MOVING_DOWN;
        end
        else begin 
            next_state = DOOR_OPEN; 
        end
    end
    MOVING_UP : Begin 
        if(floor == call) begin 
            next_state = DOOR_OPEN; 
        else
    end
    MOVING_DOWN : begin 
        if(floor == call) begin 
            next_state = DOOR_OPEN; 
        end
    end
    DOOR_OPEN : begin 
        if( timer == D_O_TIME) begin 
            next_state = IDLE; 
            next_timer = 0; 
        end
        begin 
            next_timer = timer + 1; 
        end
    end
    endcase
end

always @(*) begin 
    motor_up = 0;
    motor_down = 0;
    door_open = 0; 

    case(state) begin 
        MOVING_UP : motor_up = 1; 
        MOVING_DOWN : motor_down = 1; 
        DOOR_OPEN : door_open = 1;
    end
end

endmodule