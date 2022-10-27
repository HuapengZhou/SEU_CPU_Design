`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 16:06:51
// Design Name: 
// Module Name: IR
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


module IR(
    input clk,
    input [31:0]control_signal,
    input [7:0] MBR_IN,
    output [7:0] IR_OUT
    );
    
reg [7:0] IR_reg = 0;
//reg [7:0] IR_reg_out = 0;
always @(posedge clk)
begin
    if (control_signal[4] == 1)
        IR_reg <= MBR_IN;
end
assign IR_OUT = IR_reg;

endmodule
