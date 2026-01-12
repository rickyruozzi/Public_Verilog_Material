module miniALU(
    input wire [15:0] a_i, //first operand
    input wire [15:0] b_i, //second operand
    input wire [3:0] op_i, //opcode
    input wire [3:0] shamt_i, 
    //specifica il numero di posizioni di cui spostare i bit durante le operazioni di shift 
    output reg [15:0] res_o, //result
    output reg zero_o //serve per indicare se il risultato è zero    
);

    reg [15:0] temp;
    reg sign;

    always @(*) begin 
        case (op_i)
            4'b0000: res_o = a_i + b_i; //ADD
            4'b0001: res_o = a_i - b_i; //SUB
            4'b0010: res_o = a_i & b_i; //AND
            4'b0011: res_o = a_i | b_i; //OR
            4'b0100: res_o = a_i ^ b_i; //XOR
            4'b0101: res_o = ~a_i; //NOT
            4'b0110: begin 
                temp = a_i;
                if(shamt_i[0] == 1'b1) begin 
                    temp = {temp[14:0], 1'b0}; 
                end
                if(shamt_i[1] == 1'b1) begin 
                    temp = {temp[13:0], 2'b00};
                end
                if (shamt_i[2] == 1'b1) begin 
                    temp = {temp[11:0], 4'b0000};
                end
                if (shamt_i[3] == 1'b1) begin 
                    temp = {temp[7:0], 8'b00000000};
                end
                res_o = temp; //modifichiamo temp invece che a_ direttamente, poi impostiamo l'uscita sul suo valore
            end
            4'b0111: begin 
                temp = a_i; 
                if(shamt_i[0] == 1'b1) begin 
                    temp = {1'b0, temp[15:1]};
                end
                if(shamt_i[1] == 1'b1) begin 
                    temp = {2'b00, temp[15:2]};
                end
                if(shamt_i[2] == 1'b1) begin 
                    temp = {4'b0000, temp[15:4]};
                end
                if(shamt_i[3] == 1'b1) begin 
                    temp = {8'b00000000, temp[15:8]};
                end
                res_o = temp; //modifichiamo temp invece che a_ direttamente, poi impostiamo l'uscita sul suo valore
            end
            4'b1000: begin 
                //ASR
                temp =a_i;
                sign = a_i[15];
                if(shamt_i[0] == 1'b1) begin 
                    temp = {sign, temp[15:1]};
                end
                if(shamt_i[1] == 1'b1) begin 
                    temp = { {2{sign}}, temp[15:2]}; //2{sign} è una replicazione del bit di segno
                end
                if(shamt_i[2] == 1'b1) begin 
                    temp = {{4{sign}}, temp[15:4]};
                end
                if(shamt_i[3] == 1'b1) begin 
                    temp = {{8{sign}}, temp[15:8]};
                end
                res_o=temp;
            end
            /*Lo shift a destra porta sempre ad una decrescita e a sinistra sempre ad una crescita indipendentemente dal segno*/
            default: res_o = 16'h0000;
        endcase
        zero_o = (res_o == 16'h0000);
    end

endmodule;