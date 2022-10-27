`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 17:08:08
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input [31:0]control_signal,
    input [7:0]PC_IN,
    output [7:0]PC_OUT
    );
reg [7:0] PC_reg = 0;
always@(posedge clk)
    begin
        if(control_signal[6] == 1)
            PC_reg <= PC_reg + 1;
        if(control_signal[14] == 1)
            PC_reg <= PC_IN;
    end
assign PC_OUT = PC_reg;
endmodule
