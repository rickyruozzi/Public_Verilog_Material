module Parametric_universal_register #(parameter n=8)
(
    input wire clk_i, //clock signal
    input wire reset_ni, //reset signal
    input wire [1:0] mode_i, // 00=hold, 01=shift-left, 10=shift-right, 11=load
    input wire [n-1:0] data_i, //load data input
    input wire ser_i, //input seriale per lo shift
    output reg [n-1:0] data_o //output del registro
);
    reg [n-1:0] data_next;  //reguistro che conterrà il valore successivo
    always @(posedge clk_i or negedge reset_ni) begin  //ad ogni ciclo di clock aggiorniamo il registro
        if (!reset_ni) begin //se il reset è attivo
            data_o <= {n{1'b0}}; // eseguiamo il reset del registro a 0
        end
        else begin
            data_o <= data_next; //aggiorniamo il registro con il valore successivo
        end
    end

    always @(*) begin
        case(mode_i)
            2'b00: data_next = data_o; //hold
            2'b01: data_next = {data_o[n-2:0],ser_i}; //shift-left, il valore più a sinistra viene perso e viene inserito ser_i a destra
            /*[1,0,0,1,1,0,1,1] => [data_o[n-2:0], ser_i] =>
            con ser_i=0 [0,0,1,1,0,1,1,0] (shift a sinistra eseguita)
            */
            2'b10 : data_next = {ser_i, data_o[n-1:1]}; //shift-right, il valore più a destra viene perso e viene inserito ser_i a sinistra
            /*[1,0,0,1,1,0,1,1] => [ser_i, data_o[n-1:1]] =>
            con ser_i=1 [1,1,0,0,1,1,0,1] (shift a destra eseguita)
            */
            2'b11 : data_next = data_i; //load del valore in data_i
            default: data_next = data_o; //default hold
        endcase
    end
endmodule