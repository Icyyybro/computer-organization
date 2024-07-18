`timescale 1ns / 1ps
module DigitalWatch(
    input wire clk,
    input wire rst,
    input wire pause,
    output reg test
    );
    reg[3:0] minite_high;
    reg[3:0] minite_low;
    reg[3:0] seond_high;
    reg[3:0] seond_low;
    reg[3:0] hundredseond_high;
    reg[3:0] hundredseond_low;
    reg flag1,flag2;//flag1百分之一秒进位，flag2秒进位
    //百分之一秒模块 满100进位
    always @(posedge clk or posedge rst)begin
        if(rst)begin//重置
            hundredseond_low=4'b0000;
            hundredseond_high=4'b0000;
        end else if(!pause)begin//正常计数时未暂停
            if(hundredseond_low==9)begin//低位进位
                   hundredseond_low=0;
                   if(hundredseond_high==9)begin//高位进位
                        hundredseond_high=0;
                        flag1=1;//进位标志
                   end else
                        hundredseond_high=hundredseond_high+1;//高位+1
            end else begin//低位+1
                hundredseond_low=hundredseond_low+1;
                flag1=0;
            end
        end
    end
    //秒模块 满60进位
    always @(posedge flag1 or posedge rst)begin
        if(rst)begin//重置
            seond_high=4'b0000;
            seond_low=4'b0000;
            flag2=0;
        end else if(seond_low==9)begin//低位进位
            seond_low=0;
            if(seond_high==5)begin//高位进位
                seond_high=0;
                flag2=1;//进位标志
            end else//高位+1
                seond_high=seond_high+1;
        end else begin//低位+1
            seond_low=seond_low+1;
            flag2=0;
        end
    end
    //分模块 满60清零
    always @(posedge flag2 or posedge rst)begin
        if(rst)begin//重置
            minite_high=4'b0000;
            minite_low=4'b0000;
        end else if(minite_low==9)begin//低位进位
            minite_low=0;
            if(minite_high==5)//溢出归0
                minite_high=0;
            else//高位+1
                minite_high=minite_high+1;
        end else//低位进位
            minite_low=minite_low+1;
    end
endmodule
