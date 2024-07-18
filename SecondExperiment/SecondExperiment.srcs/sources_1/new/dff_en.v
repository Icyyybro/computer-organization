`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 15:03:39
// Design Name: 
// Module Name: dff_en
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


module dff_en(
    input wire d,
    input wire clk,
    input wire en,
    output reg q
    );
    always@(posedge clk)begin
        if(en)begin
            q<=d;
        end
    end
endmodule