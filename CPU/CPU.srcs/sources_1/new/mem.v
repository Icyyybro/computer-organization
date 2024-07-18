`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 21:49:17
// Design Name: 
// Module Name: mem
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


module mem(
    input wire[31:0] wdata_i,
    input wire[4:0] wd_i,
    input wire wreg_i,
    output wire[31:0] wdata_o,
    output wire[4:0] wd_o,
    output wire wreg_o
    );

    assign wdata_o=wdata_i;
    assign wd_o=wd_i;
    assign wreg_o=wreg_i;
endmodule
