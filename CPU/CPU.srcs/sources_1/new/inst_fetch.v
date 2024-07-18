`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:02:03
// Design Name: 
// Module Name: inst_fetch
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


module inst_fetch(
    input wire clk,
    input wire rst,
    output wire[31:0] inst_o
    );

    wire[31:0] pc;
    wire ce;
    PC pc0(rst, clk, pc, ce);
    inst_rom rom0(ce, pc, inst_o);

endmodule

