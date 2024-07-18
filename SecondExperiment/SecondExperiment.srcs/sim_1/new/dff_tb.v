`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:17:48
// Design Name: 
// Module Name: dff_tb
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


module dff_tb(

    );
    reg d;
    reg clk;
    wire q;
    dff dff1(d, clk, q);
    
    initial begin 
        clk=1;
        forever begin
            #5 clk=~clk;    //时钟周期为10
        end
    end
    
    initial begin
        d=1;
        #5 d=0;             //q不会发生改变
        #10 d=1;
        #5 $finish;
    end
    
endmodule
