`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:56:35
// Design Name: 
// Module Name: dff_syn_tb
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


module dff_syn_tb(

    );
    reg d;
    reg clk;
    reg reset;
    wire q;
    dff_syn dff_syn1(d, clk, reset, q);
    
    initial begin 
        clk=1;
        forever begin
            #5 clk=~clk;    
        end
    end
    
    initial begin
        d=1;
        #20 d=0;             
        #10 $finish;
    end
    
    initial begin
        reset=1;
        #5 reset=0;
        #10 reset=1;
    end
endmodule
