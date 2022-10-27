`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/23 16:34:33
// Design Name: 
// Module Name: SHOW
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


module SHOW(
    input clk,
    input [31:0]control_signal,
    input [15:0]MBR_IN,
    input [15:0]MR_IN,
    output [7:0]display_control,
    output [7:0]display_data
    );
    
integer i = 0;
integer display_index;

reg [15:0]MBR_reg = 0;
reg [7:0]display_control_reg = 0;
reg [7:0]display_data_reg = 0;

function  [7:0] digital_display;
    input[3:0] DATA_IN;
        begin
            case(DATA_IN)
                4'b0000: digital_display=8'b00000011;
                4'b0001: digital_display=8'b10011111;
                4'b0010: digital_display=8'b00100101;
                4'b0011: digital_display=8'b00001101;
                4'b0100: digital_display=8'b10011001;
                4'b0101: digital_display=8'b01001001;
                4'b0110: digital_display=8'b01000001;
                4'b0111: digital_display=8'b00011111;
                4'b1000: digital_display=8'b00000001;
                4'b1001: digital_display=8'b00001001;
                4'b1010: digital_display=8'b00010001;
                4'b1011: digital_display=8'b11000001;
                4'b1100: digital_display=8'b01100011;
                4'b1101: digital_display=8'b10000101;
                4'b1110: digital_display=8'b01100001;
                4'b1111: digital_display=8'b01110001;
                default: digital_display=8'b00000011;
            endcase
    end
endfunction
always@(posedge clk)
begin
    if(i >= 800000)
        i = 0;
    else
        i = i + 1;
    if(i >=0 && i<100000) display_index=0;
    else if(i>=100000 && i<200000) display_index=1;
    else if(i>=200000 && i<300000) display_index=2;
    else if(i>=300000 && i<400000) display_index=3;
    else if(i>=400000 && i<500000) display_index=4;
    else if(i>=500000 && i<600000) display_index=5;
    else if(i>=600000 && i<700000) display_index=6;
    else display_index=7; //保证所有数码管都在亮着
    
    if(control_signal[29] == 1)
        MBR_reg <= MBR_IN;
    case(display_index)
        0:
        begin
            display_control_reg <= 8'b11111110;
            display_data_reg <= digital_display(MBR_reg[3:0]);
        end
        1:
        begin
            display_control_reg <= 8'b11111101;
            display_data_reg <= digital_display(MBR_reg[7:4]);
        end
        2:
        begin
            display_control_reg=8'b11111011;
            display_data_reg <= digital_display(MBR_reg[11:8]);
        end
        3:
        begin
            display_control_reg=8'b11110111;
            display_data_reg <= digital_display(MBR_reg[15:12]);
        end
        4:
        begin
            display_control_reg=8'b11101111;
            display_data_reg <= digital_display(MR_IN[3:0]);
        end
        5:
        begin
            display_control_reg=8'b11011111;
            display_data_reg <= digital_display(MR_IN[7:4]);
        end
        6:
        begin
            display_control_reg=8'b10111111;
            display_data_reg <= digital_display(MR_IN[11:8]);
        end
        7:
        begin
            display_control_reg=8'b01111111;
            display_data_reg <= digital_display(MR_IN[15:12]);
        end
        default;
endcase
end

assign display_control = display_control_reg;
assign display_data = display_data_reg;
endmodule
