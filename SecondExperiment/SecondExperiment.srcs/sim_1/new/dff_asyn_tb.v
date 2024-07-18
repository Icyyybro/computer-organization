`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:43:05
// Design Name: 
// Module Name: dff_asyn_tb
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


module dff_asyn_tb(

    );
    reg d;
    reg clk;
    reg reset;
    wire q;
    dff_asyn dff_asyn1(d, clk, reset, q);
    
    initial begin 
        clk=1;
        forever begin
            #5 clk=~clk;    //时钟周期为10
        end
    end
    
    initial begin
        d=1;
        #15 d=0;             //q不会发生改变
        #10 $finish;
    end
    
    initial begin
        reset=1;
        #5 reset=0;
        #5 reset=1;
        #10 reset=0;
    end
endmodule
