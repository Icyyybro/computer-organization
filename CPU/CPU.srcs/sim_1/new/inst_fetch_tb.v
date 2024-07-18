`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:09:08
// Design Name: 
// Module Name: inst_fetch_tb
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


module inst_fetch_tb(
    );
    reg clk;
    reg rst;
    wire [31:0] inst_o;
    inst_fetch fetch0(clk,rst,inst_o);
    initial begin
        clk=1;
        forever begin
            #10 clk=~clk;
        end
    end

    initial begin
        rst=0;
        #100
        rst=1;
        #90
        rst=0;
    end

endmodule
