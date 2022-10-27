`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 17:27:26
// Design Name: 
// Module Name: MR
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


module MR(
    input clk,
    input [15:0]MR_IN,
    input [15:0]ALU_LOW,
    input [31:0]control_signal,
    output [15:0]MR_OUT
    );
reg signed[15:0]MR_reg = 0;
assign MR_OUT = MR_reg;
always @(posedge clk)
    begin
        //if(control_signal[31] == 1)
            MR_reg <= MR_IN;
        if(control_signal[18] == 1) // 左移一位 逻辑左移
            MR_reg <= {MR_reg[14:0],ALU_LOW[15]};
        if(control_signal[24] == 1) // 按位取反
            MR_reg <= ~MR_reg;
    end

endmodule
