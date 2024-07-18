`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 15:28:32
// Design Name: 
// Module Name: mux_51_tb
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


module mux_51_tb(

    );
    reg [2:0] sel;
    reg [7:0] in0, in1, in2, in3, in4;
    wire [7:0] out;
    mux_51 m1(sel, in0, in1, in2, in3, in4, out);
    integer i;
    initial begin
        in0 = 8'h20;
        in1 = 8'h23;
        in2 = 8'h10;
        in3 = 8'h10;
        in4 = 8'h15;
        for (i = 0; i <= 4; i = i + 1) begin
            sel = i;
            #10;
        end
        $finish;
    end
endmodule
