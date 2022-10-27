`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 16:38:11
// Design Name: 
// Module Name: MBR
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


module MBR(
    input clk,
    input [31:0] control_signal,
    input [15:0] ACC_IN,
    input [15:0] RAM_IN,
    input [15:0] MR_IN,
    input [15:0] DR_IN,
    output [15:0] MBR_OUT
    );

reg [15:0]MBR_reg_in = 0;

always@(posedge clk)
    begin
        if(control_signal[11] == 1)
            MBR_reg_in <= ACC_IN;
        if(control_signal[3] == 1)
            MBR_reg_in <= RAM_IN;
        if(control_signal[12] == 1)
            MBR_reg_in <= MR_IN;
        if(control_signal[13] == 1)
            MBR_reg_in <= DR_IN;
    end
assign MBR_OUT = MBR_reg_in;
endmodule
