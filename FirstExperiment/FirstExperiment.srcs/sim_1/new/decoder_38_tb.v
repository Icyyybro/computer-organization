`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 14:55:08
// Design Name: 
// Module Name: decoder_38_tb
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


module decoder_38_tb();
    reg [2:0] in0;
    wire [7:0] out0;
    decoder_38 d1(.in(in0), .out(out0));
    integer i = 0;
    initial begin
        for(i = 0; i <= 7; i = i + 1) begin
            in0 = i;
            #10;
        end
        $finish;
    end
endmodule
