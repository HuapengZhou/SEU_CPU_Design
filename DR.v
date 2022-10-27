`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 17:39:56
// Design Name: 
// Module Name: DR
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


module DR(
    input clk,
    input [15:0]DR_IN,
    output [15:0]DR_OUT
    );
reg [15:0]DR_reg = 0;
always@(posedge clk)
    DR_reg <= DR_IN;
assign DR_OUT = DR_reg;
endmodule
