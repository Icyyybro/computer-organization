`timescale 1ns / 1ps
module tb(
    );
    reg clk;
    reg rst;
    reg pause;
    DigitalWatch DigitalWatch0(clk,rst,pause);
    initial begin
        clk=1;
        forever #1 clk=~clk;
    end
    initial begin
        rst=1;pause=0;#5
        rst=0;#500          //开始计时
        pause=1;#10         //百分之一秒进位时暂停
        pause=0;#20         //继续计时
        rst=1;#20           //清0
        rst=0;#1000000          //重新计时
        $finish;
    end
endmodule
