`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:01:49
// Design Name: 
// Module Name: alu
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


module alu(
    input wire[3:0] alu_control,
    input wire[31:0] alu_src1,
    input wire[31:0] alu_src2,
    input wire[4:0] wd_i,
    input wire wreg_i,
    output wire[31:0] alu_result,
    output wire[4:0] wd_o,
    output wire wreg_o
    );
    assign wd_o=wd_i;
    assign wreg_o=wreg_i;
    wire[31:0] add_sub_result;
    wire[31:0] slt_result;
    wire[31:0] sltu_result;
    wire[31:0] and_result;
    wire[31:0] or_result;
    wire[31:0] xor_result;
    wire[31:0] nor_result;
    wire[31:0] sll_result;
    wire[31:0] srl_result;
    wire[31:0] sra_result;
    wire[31:0] lui_result;
    assign sltu_result[31:1]=31'b0;
    assign sltu_result[0]=(alu_src1<alu_src2);
    
    assign and_result=alu_src1&alu_src2;
    assign or_result=alu_src1|alu_src2;
    assign xor_result=alu_src1^alu_src2;
    assign nor_result=~(alu_src1|alu_src2);
    assign sll_result=alu_src2<<alu_src1;
    assign srl_result=alu_src2>>alu_src1;
    assign lui_result=alu_src1;
    assign sra_result=({32{alu_src2[31]}}<<(32'd32-alu_src1))
                        |(alu_src2>>alu_src1);
    wire[31:0] adder_result;
    wire adder_cout;
    wire adder_cin;
    wire[31:0] adder_a;
    wire[31:0] adder_b;
    assign adder_a=alu_src1;
    assign adder_b=(alu_control==11)||
                    (alu_control==10)||
                    (alu_control==9)?
                    ~alu_src2+1:alu_src2;
    assign adder_cin=0;
    assign {adder_cout,adder_result}
    =adder_a+adder_b+adder_cin;
    
    assign add_sub_result=adder_result;
    assign slt_result[31:1]=31'b0;
    assign slt_result[0]=(alu_src1[31]&&~alu_src2[31])
                        ||(~(alu_src1[31]^alu_src2[31])
                            &&adder_result[31]);
    assign alu_result=(alu_control==13)?add_sub_result:
                        (alu_control==12)?add_sub_result:
                        (alu_control==11)?add_sub_result:
                        (alu_control==10)?add_sub_result:
                        (alu_control==9)?slt_result:
                        (alu_control==8)?sltu_result:
                        (alu_control==7)?and_result:
                        (alu_control==6)?or_result:
                        (alu_control==5)?xor_result:
                        (alu_control==4)?nor_result:
                        (alu_control==3)?sll_result:
                        (alu_control==2)?srl_result:
                        (alu_control==1)?sra_result:
                        (alu_control==0)?lui_result:
                        32'd0;
    
endmodule

