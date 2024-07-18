`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 15:29:45
// Design Name: 
// Module Name: PC_tb
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


module PC_tb(
    );
    reg rst;
    reg clk;
    wire[31:0] pc;
    wire ce;
    PC pc1(rst,clk,pc,ce);

    initial begin
        clk=1;
        forever begin
            #5 clk =~clk;
        end
    end

    initial begin
        rst=1;
        #20
        rst=0;
        #10 
        rst=1;
        #10 $finish;
    end

endmodule
