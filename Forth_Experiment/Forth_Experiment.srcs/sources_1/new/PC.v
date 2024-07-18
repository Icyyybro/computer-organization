`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 15:13:13
// Design Name: 
// Module Name: PC
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


module PC(
    input wire rst,
    input wire clk,
    output reg[31:0] pc,
    output reg ce
    );

    always@(posedge clk)begin
        if(rst==1) begin
            ce<=0;
        end else begin
            ce<=1;
        end
    end 

    always@(posedge clk)begin
        if(ce==0)begin
            pc<=0;
        end else begin 
            pc<=pc+32'd4;
        end
    end

endmodule
