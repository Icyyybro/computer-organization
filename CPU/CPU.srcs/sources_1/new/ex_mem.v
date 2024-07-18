`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 19:31:50
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    input wire[31:0] ex_wdata,
    input wire[4:0] ex_wd,
    input wire ex_wreg,
    input wire clk,
    output reg[31:0] mem_data,
    output reg[4:0] mem_wd,
    output reg mem_wreg
    );

    always@(posedge clk)begin
        mem_data=ex_wdata;
        mem_wd=ex_wd;
        mem_wreg=ex_wreg;
    end
endmodule
