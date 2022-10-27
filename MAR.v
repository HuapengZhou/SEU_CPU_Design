`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 16:20:28
// Design Name: 
// Module Name: MAR
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


module MAR(
    input clk,
    input [31:0] control_signal,
    input [7:0] PC_ADDR_IN,
    input [7:0] MBR_ADDR_IN,
    output [7:0] addr_out
    );
    
reg [7:0] addr_reg = 0;
reg [7:0] addr_reg_out = 0;
always @(posedge clk)
begin
    if (control_signal[10] == 1)
        addr_reg <= PC_ADDR_IN;
    if (control_signal[5] == 1)
        addr_reg <= MBR_ADDR_IN;
end
assign addr_out = addr_reg;
endmodule
