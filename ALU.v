`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/09 16:01:38
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk,
    input [15:0]BR_IN,
    input [31:0]control_signal,
    output flag,
    output [15:0]high_output,
    output [15:0]low_output
      );
      
reg signed [15:0]ACC_reg = 0;
reg signed [31:0]ALU_reg = 0;
reg signed [15:0]BR_reg = 0;
wire signed [31:0]MUL_reg = 0;
wire signed [31:0]DIV_reg = 0;
mult16x16 MY_MUL(
  .CLK(clk),  // input wire CLK
  .A(BR_reg),      // input wire [15 : 0] A
  .B(ACC_reg),      // input wire [15 : 0] B
  .P(MUL_reg)      // output wire [31 : 0] P
);
DIV MY_DIV(
  .aclk(clk),                                      // input wire aclk
  .s_axis_divisor_tvalid(),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(ACC_reg),      // input wire [15 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(BR_reg),    // input wire [15 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(DIV_reg)            // output wire [31 : 0] m_axis_dout_tdata
);
always @(posedge clk)
begin
    if(control_signal[28] == 1)
        BR_reg <= BR_IN;
    if(control_signal[8] == 1)
        ACC_reg <= 0;
    if(control_signal[9] == 1) // +
        ACC_reg <= ACC_reg + BR_reg;
    if(control_signal[15] == 1) // -
        ACC_reg <= ACC_reg - BR_reg;
    if(control_signal[16] == 1) // * 缺少有符号数
        begin
            ALU_reg = ACC_reg * BR_reg; //ALU高位
            ACC_reg = ALU_reg[15:0]; //ACC低位
        end
    if(control_signal[17] == 1) // / 缺少有符号数
        begin
            ACC_reg <= ACC_reg / BR_reg; //ACC记录商
            ALU_reg[31:16] <= ACC_reg % BR_reg; //ALU记录商
            //ALU_reg[31:16] <= DIV_reg[15:0];
            //ACC_reg <= DIV_reg[31:16];
        end
    if(control_signal[18] == 1) // 左移一位 逻辑左移
        ACC_reg <= ACC_reg << 1;
    if(control_signal[19] == 1) // 右移一位 逻辑右移
        ACC_reg <= ACC_reg >> 1;
    if(control_signal[20] == 1) // 左移一位 算术左移
        ACC_reg <= ACC_reg <<< 1;
    if(control_signal[21] == 1) // 右移一位 算术右移
        ACC_reg <= ACC_reg >>> 1;
    if(control_signal[22] == 1) // 按位与
        ACC_reg <= ACC_reg & BR_reg;
    if(control_signal[23] == 1) // 按位或
        ACC_reg <= ACC_reg | BR_reg;
    if(control_signal[24] == 1) // 按位取反
        ACC_reg <= ~ACC_reg;
    if(control_signal[25] == 1) // 按位异或
        ACC_reg <= ACC_reg ^ BR_reg;
    if(control_signal[26] == 1) // 按位同或
        ACC_reg <= ACC_reg ~^ BR_reg;
end
assign high_output = ALU_reg[31:16];
//assign low_output = ALU_reg[15:0];
assign low_output = ACC_reg;
assign flag = ACC_reg[15];
endmodule
