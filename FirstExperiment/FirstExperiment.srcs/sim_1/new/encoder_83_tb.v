`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 15:14:43
// Design Name: 
// Module Name: encoder_83_tb
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


module encoder_83_tb();
    reg [7:0] in0;
    wire [2:0] out0;
    encoder_83 e1(in0, out0);
    integer i;
    initial begin
        in0 = 1;
        for (i = 0; i <= 6; i = i + 1) begin
            in0 = in0 << 1;
            #10;
        end
        $finish;
    end
endmodule
