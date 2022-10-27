`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/22 21:06:38
// Design Name: 
// Module Name: CU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU(
    input clk,
    input flag,
    input [7:0]IR_CU,
    input [31:0]control_signal,
    output [7:0]ROM_address
    );
    
reg [7:0] CA_reg = 0;
assign ROM_address = CA_reg;
always @(posedge clk)
begin
    if (control_signal[0] == 1)
        CA_reg <= CA_reg + 1;
    if (control_signal[2] == 1)
        CA_reg <= 0;
    if (control_signal[1] == 1)
        begin
            case(IR_CU)
                8'b0000_0001: CA_reg<=41;// store x
                8'b0000_0010: CA_reg<=43;// load x
                8'b0000_0011: CA_reg<=21;// add x
                8'b0000_0100: CA_reg<=25;// sub x
                8'b0000_0101:
                begin // jmpgez x
                if (flag==0) CA_reg <= 47;
                else CA_reg <= 48;
                end
                8'b0000_0110: CA_reg<=49;// jmp x
                8'b0000_0111: CA_reg<=50;// halt
                8'b0000_1000: CA_reg<=29;// mpy x
                8'b0000_1001: CA_reg<=33;// div x
                8'b0000_1010: CA_reg<=04;// and x
                8'b0000_1011: CA_reg<=08;// or x
                8'b0000_1100: CA_reg<=12;// not x
                8'b0000_1101: CA_reg<=37;// shiftR
                8'b0000_1110: CA_reg<=38;// shiftL
                8'b0000_1111: CA_reg<=39;// saL
                8'b0001_0000: CA_reg<=40;// saR
                8'b0001_0001: CA_reg<=13;// XOR
                8'b0001_0010: CA_reg<=17;// NXOR
                8'b0001_0011: CA_reg<=51;// SHOW
            endcase
        end    

end


endmodule
