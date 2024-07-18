`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:54:55
// Design Name: 
// Module Name: dff_syn
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


module dff_syn(
    input wire d,
    input wire clk,
    input wire reset,
    output reg q
    );
    always@(posedge clk)begin
        if(!reset)begin
            q<=0;
        end
        else begin
            q<=d;
        end
    end
endmodule