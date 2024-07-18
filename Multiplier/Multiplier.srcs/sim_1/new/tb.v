`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 15:33:39
// Design Name: 
// Module Name: tb
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


module tb(
    );
    reg clk;
    reg rst;
    reg [31:0]multiplicand;   //multiplicand
    reg [31:0]multiplier;     //multiplier
    reg start;                //the calculation begin
    wire[64:0] product;   //final result
    wire finish;               //the calculation finishes

    

    Multiplier mul32(clk, rst, multiplicand, multiplier, start, product, finish);

    initial begin
    clk = 0;
    rst = 1;
    multiplicand = 0;
    multiplier   = 0;
    start        = 0;
    #100
    /*test 1*/
    rst = 0;
    start = 1;					//start = 1:Initialization the value
    multiplicand = 32'd2;
    multiplier   = 32'd3;
    #350
    start = 0;					//start = 0:Start calculation
    #350
    /*test 2*/
    start = 1;
    multiplicand = 32'd10;
    multiplier   = 32'd8;
    #350
    start = 0;
    #350
    /*test 3*/
    start = 1;
    multiplicand = 32'd9;
    multiplier   = 32'd9;
    #350
    start = 0;
    #350
    /*test 4*/
    start = 1;
    multiplicand = 32'd50;
    multiplier   = 32'd6;
    #350
    start = 0;
    #350
    /*test 5*/
    start = 1;
    multiplicand = 32'd6;
    multiplier   = 32'd60;
    #350
    start = 0;
    #350
    /*test 6*/
    start = 1;
    multiplicand = 32'hFFFFFFFF;
    multiplier   = 32'hFFFFFFFF;
    #350
    start = 0;
    #350
    #4000 $finish();
end

always #5 clk = ~clk;



endmodule
