`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 15:19:25
// Design Name: 
// Module Name: regfile_tb
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


module regfile_tb(
    );
    reg re1;
    reg[4:0] raddr1;
    reg re2;
    reg[4:0] raddr2;
    reg we;
    reg[4:0] waddr;
    reg[31:0] wdata;
    reg rst;
    reg clk;
    wire[31:0] rdata1;
    wire[31:0] rdata2;
    regfile reg1(rst,clk,waddr,wdata,we,raddr1,re1,rdata1,raddr2,re2,rdata2);
    integer i=0;
    
    initial begin 
        rst=0;
        #100;
        rst=1;
        #50;
        rst=0;
        #900 $finish;
    end
    
    initial begin 
        clk=1;
        forever begin 
            #5 clk=~clk;
        end
    end
    
    initial begin
        wdata=32'habcd5678;
        we=1;
        for(i=0;i<=31;i=i+1)begin
            waddr=i;
            wdata=wdata+32'h01010101;
            #15;
        end
        re1=1;
        re2=1;
        for(i=0;i<=31;i=i+1)begin 
            raddr1=1;
            raddr2=31-i;
            #10;
        end
    end
    
endmodule

