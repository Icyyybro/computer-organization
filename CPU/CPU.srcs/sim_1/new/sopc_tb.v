`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/21 15:02:12
// Design Name: 
// Module Name: sopc_tb
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


module sopc_tb(
    );

    reg clk;
    reg rst;
    sopc sopc0(clk,rst);
    initial begin
        clk=1;
        forever begin
            #10 clk=~clk;
        end
    end

    initial begin
        rst=0;
        #50;
        rst=1;
        #50;
        rst=0;
    end
endmodule
