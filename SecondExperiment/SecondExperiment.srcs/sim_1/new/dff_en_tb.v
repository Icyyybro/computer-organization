`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 15:05:42
// Design Name: 
// Module Name: dff_en_tb
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


module dff_en_tb(

    );
    reg d;
    reg clk;
    reg en;
    wire q;
    dff_en dff_en1(d, clk, en, q);
    
    initial begin 
        clk=1;
        forever begin
            #5 clk=~clk;    
        end
    end
    
    initial begin
        d=1;
        #10 d=0;             
        #10 d=1;
        #10 $finish;
    end
    
    initial begin
        en=1;
        #20 en=0;
    end
    
endmodule
