`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:40:23
// Design Name: 
// Module Name: dff_asyn
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


module dff_asyn(
    input wire d,
    input wire clk,
    input wire reset,
    output reg q
    );
    always@(posedge clk or negedge reset)begin
        if(!reset)begin
            q<=0;
        end
        else begin
            q<=d;
        end
    end
endmodule
