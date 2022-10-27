`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 16:30:29
// Design Name: 
// Module Name: TOP
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


module TOP(
    input clk,
    output [7:0]display_control,
    output [7:0]display_data
    );

wire [31:0]control_signal;
wire [15:0]MBR_OUT;
wire [7:0]IR_CU;
wire [7:0]PC_MAR;
wire [15:0]DR_MBR;
wire [15:0]MR_MBR;
wire [15:0]DR_MBR;
wire [15:0]ALU_MBR; //ALU低位
wire [15:0]RAM_MBR;
wire [15:0]BR_ALU;
wire [15:0]ALU_HIGH;
wire [7:0]ROM_address;
wire [7:0]RAM_address;
wire flag;

// IR取MBR中的高位作为指令作为传到CU中的缓冲
IR MY_IR(
    .clk(clk),
    .control_signal(control_signal),
    .MBR_IN(MBR_OUT[15:8]),
    .IR_OUT(IR_CU)
);

//MAR取PC中的数据作为指令地址(不跳转)或者取MBR中的数据作为地址例如跳转指令 JMP 3 
//或者load A0 A0同样作为地址 但JMP 3 中的地址改变PC，load A0上AO的数据直接传入MAR
MAR MY_MAR(
    .clk(clk),
    .control_signal(control_signal),
    .PC_ADDR_IN(PC_MAR),
    .MBR_ADDR_IN(MBR_OUT[7:0]),
    .addr_out(RAM_address)
);
//MBR的输入可以是ALU单元计算的数据,无论是加减乘除的高位或者低位(16位),
//同时也可以是RAM中指令加数据的格式传入例如load X load是8位的IR指令，X代表数据寄存器的地址
//也就是高位指令，低位数据地址(也在RAM里面,数据也是16位)
MBR MY_MBR(
    .clk(clk),
    .control_signal(control_signal),
    .ACC_IN(ALU_MBR),
    .RAM_IN(RAM_MBR),
    .MR_IN(MR_MBR),
    .DR_IN(DR_MBR),
    .MBR_OUT(MBR_OUT)
);
//BR作为MBR和ALU中的媒介,将MBR中的数据做缓冲(16位)
BR MY_BR(
    .clk(clk),
    .control_signal(control_signal),
    .MBR_IN(MBR_OUT),
    .BR_OUT(BR_ALU)
);
//可以在一个指令后自增1或者取MBR中低位数据作为地址传入MAR,MAR再传入RAM中
PC MY_PC(
    .clk(clk),
    .control_signal(control_signal),
    .PC_IN(MBR_OUT[7:0]),
    .PC_OUT(PC_MAR)
);
//缓冲ALU中乘法的高位数据16位
MR MY_MR(
    .clk(clk),
    .MR_IN(ALU_HIGH),
    .control_signal(control_signal),
    .MR_OUT(MR_MBR),
    .ALU_LOW(ALU_MBR)
);
//缓冲ALU除法中的商16位
DR MY_DR(
    .clk(clk),
    .DR_IN(ALU_HIGH),
    .DR_OUT(DR_MBR)
);
//接受BR中的数据,产生ALU运算结果，低位传入ALU_MBR，高位放入MR或者DR中
ALU MY_ALU(
    .clk(clk),
    .control_signal(control_signal),
    .BR_IN(BR_ALU),
    .flag(flag),
    .high_output(ALU_HIGH),
    .low_output(ALU_MBR)
);
//接受IR中的指令,根据相应的IR找到ROM中的地址,ROM为指令集。例如load操作IR为02就找到对应在ROM里的地址CA
//完成一系列的微操作后,再将CA赋值00H，取下一条IR指令,再讲对应IR的CA地址传入ROM中
CU MY_CU(
    .clk(clk),
    .control_signal(control_signal),
    .flag(flag),
    .IR_CU(IR_CU),
    .ROM_address(ROM_address)
);
//RAM中可以根据MAR中对应的RAM地址读操作或者数据，例如load A0既可以将这条指令传入MBR中
//也可以将A0地址后的数据传入MBR中。写操作时，读取MBR中已经计算过的数据放入对应地址的RAM中
RAM MY_RAM(
  .clka(~clk),    // input wire clka
  .wea(control_signal[27]),      // input wire [0 : 0] wea 写/读，1写0读
  .addra(RAM_address),  // input wire [7 : 0] addra
  .dina(MBR_OUT),    // input wire [15 : 0] dina
  .douta(RAM_MBR)  // output wire [15 : 0] douta
);
// 将对应的ROM操作产生一系列的微操作,然后产生控制信号
//ROM MY_ROM(
//  .clka(clk),    // input wire clka
//  .addra(ROM_address),  // input wire [7 : 0] addra
//  .douta(control_signal)  // output wire [31 : 0] douta
//);
ROMMM haoye (
  .a(ROM_address),      // input wire [7 : 0] a
  .spo(control_signal)  // output wire [31 : 0] spo
);
SHOW MY_SHOW(
    .clk(clk),
    .control_signal(control_signal),
    .MBR_IN(MBR_OUT),
    .MR_IN(MR_MBR),
    .display_control(display_control),
    .display_data(display_data)
);
endmodule
