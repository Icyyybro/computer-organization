`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 21:59:54
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input wire clk,
    input wire[31:0] mem_wdata,
    input wire[4:0] mem_wd,
    input wire mem_wreg,
    output reg[31:0] wb_wdata,
    output reg[4:0] wb_wd,
    output reg wb_wreg
    );

    always @(posedge clk) begin
        wb_wdata=mem_wdata;
        wb_wd=mem_wd;
        wb_wreg=mem_wreg;
    end
endmodule
