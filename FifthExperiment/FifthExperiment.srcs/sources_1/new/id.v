`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 14:25:57
// Design Name: 
// Module Name: id
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


module id(
    input wire rst,
    input wire[31:0] inst_i,
    input wire[31:0] reg1_data_i,
    input wire[31:0] reg2_data_i,
    output wire reg1_read_o,
    output wire[4:0] reg1_addr_o,
    output wire reg2_read_o,
    output wire[4:0] reg2_addr_o,
    output wire wreg_o,
    output wire[4:0] wd_o,
    output wire[31:0] reg1_o,
    output wire[31:0] reg2_o,
    output wire[] aluop_o
    );
endmodule
