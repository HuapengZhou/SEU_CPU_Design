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
wire [15:0]ALU_MBR; //ALU��λ
wire [15:0]RAM_MBR;
wire [15:0]BR_ALU;
wire [15:0]ALU_HIGH;
wire [7:0]ROM_address;
wire [7:0]RAM_address;
wire flag;

// IRȡMBR�еĸ�λ��Ϊָ����Ϊ����CU�еĻ���
IR MY_IR(
    .clk(clk),
    .control_signal(control_signal),
    .MBR_IN(MBR_OUT[15:8]),
    .IR_OUT(IR_CU)
);

//MARȡPC�е�������Ϊָ���ַ(����ת)����ȡMBR�е�������Ϊ��ַ������תָ�� JMP 3 
//����load A0 A0ͬ����Ϊ��ַ ��JMP 3 �еĵ�ַ�ı�PC��load A0��AO������ֱ�Ӵ���MAR
MAR MY_MAR(
    .clk(clk),
    .control_signal(control_signal),
    .PC_ADDR_IN(PC_MAR),
    .MBR_ADDR_IN(MBR_OUT[7:0]),
    .addr_out(RAM_address)
);
//MBR�����������ALU��Ԫ���������,�����ǼӼ��˳��ĸ�λ���ߵ�λ(16λ),
//ͬʱҲ������RAM��ָ������ݵĸ�ʽ��������load X load��8λ��IRָ�X�������ݼĴ����ĵ�ַ
//Ҳ���Ǹ�λָ���λ���ݵ�ַ(Ҳ��RAM����,����Ҳ��16λ)
MBR MY_MBR(
    .clk(clk),
    .control_signal(control_signal),
    .ACC_IN(ALU_MBR),
    .RAM_IN(RAM_MBR),
    .MR_IN(MR_MBR),
    .DR_IN(DR_MBR),
    .MBR_OUT(MBR_OUT)
);
//BR��ΪMBR��ALU�е�ý��,��MBR�е�����������(16λ)
BR MY_BR(
    .clk(clk),
    .control_signal(control_signal),
    .MBR_IN(MBR_OUT),
    .BR_OUT(BR_ALU)
);
//������һ��ָ�������1����ȡMBR�е�λ������Ϊ��ַ����MAR,MAR�ٴ���RAM��
PC MY_PC(
    .clk(clk),
    .control_signal(control_signal),
    .PC_IN(MBR_OUT[7:0]),
    .PC_OUT(PC_MAR)
);
//����ALU�г˷��ĸ�λ����16λ
MR MY_MR(
    .clk(clk),
    .MR_IN(ALU_HIGH),
    .control_signal(control_signal),
    .MR_OUT(MR_MBR),
    .ALU_LOW(ALU_MBR)
);
//����ALU�����е���16λ
DR MY_DR(
    .clk(clk),
    .DR_IN(ALU_HIGH),
    .DR_OUT(DR_MBR)
);
//����BR�е�����,����ALU����������λ����ALU_MBR����λ����MR����DR��
ALU MY_ALU(
    .clk(clk),
    .control_signal(control_signal),
    .BR_IN(BR_ALU),
    .flag(flag),
    .high_output(ALU_HIGH),
    .low_output(ALU_MBR)
);
//����IR�е�ָ��,������Ӧ��IR�ҵ�ROM�еĵ�ַ,ROMΪָ�������load����IRΪ02���ҵ���Ӧ��ROM��ĵ�ַCA
//���һϵ�е�΢������,�ٽ�CA��ֵ00H��ȡ��һ��IRָ��,�ٽ���ӦIR��CA��ַ����ROM��
CU MY_CU(
    .clk(clk),
    .control_signal(control_signal),
    .flag(flag),
    .IR_CU(IR_CU),
    .ROM_address(ROM_address)
);
//RAM�п��Ը���MAR�ж�Ӧ��RAM��ַ�������������ݣ�����load A0�ȿ��Խ�����ָ���MBR��
//Ҳ���Խ�A0��ַ������ݴ���MBR�С�д����ʱ����ȡMBR���Ѿ�����������ݷ����Ӧ��ַ��RAM��
RAM MY_RAM(
  .clka(~clk),    // input wire clka
  .wea(control_signal[27]),      // input wire [0 : 0] wea д/����1д0��
  .addra(RAM_address),  // input wire [7 : 0] addra
  .dina(MBR_OUT),    // input wire [15 : 0] dina
  .douta(RAM_MBR)  // output wire [15 : 0] douta
);
// ����Ӧ��ROM��������һϵ�е�΢����,Ȼ����������ź�
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
