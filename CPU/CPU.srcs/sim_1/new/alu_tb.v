`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:08:13
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(

    );
    reg[3:0] alu_control;
    reg[31:0] alu_src1;
    reg[31:0] alu_src2;
    reg[4:0] wd_i;
    reg wreg_i;
    wire[31:0] alu_result;
    wire[4:0] wd_o;
    wire wreg_o;
    alu alu0(alu_control,alu_src1,alu_src2,wd_i,wreg_i,alu_result,wd_o,wreg_o);
    integer i=0;

    initial begin
        wreg_i=1;
        wd_i=5'd3;
        alu_src1=32'h4;
        alu_src2=32'h10101010;
        for(i=0;i<14;i=i+1)begin
            alu_control=i;
            #20;
        end
    end
endmodule