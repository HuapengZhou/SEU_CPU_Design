`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 17:00:54
// Design Name: 
// Module Name: BR
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


module BR(
    input clk,
    input [31:0]control_signal,
    input [15:0]MBR_IN,
    output [15:0]BR_OUT
    );

reg [15:0] BR_reg = 0;
always@(posedge clk)
    begin
        if(control_signal[7] == 1)
            BR_reg <= MBR_IN;
    end
assign BR_OUT = BR_reg;
endmodule
