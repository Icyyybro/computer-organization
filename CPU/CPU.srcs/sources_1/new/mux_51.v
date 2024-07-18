`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 15:22:59
// Design Name: 
// Module Name: mux_51
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


module mux_51(
    input wire [2:0] sel,
    input wire [7:0] in0, in1, in2, in3, in4,
    output wire [7:0] out
    );
    assign out = (sel == 3'd0) ? in0:
                 (sel == 3'd1) ? in1:
                 (sel == 3'd2) ? in2:
                 (sel == 3'd3) ? in3:
                 (sel == 3'd4) ? in4:
                 8'd0;
                 
endmodule
