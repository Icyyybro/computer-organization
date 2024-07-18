`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 14:31:28
// Design Name: 
// Module Name: decoder_38
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


module decoder_38(
    input wire [2:0]in,
    output  wire [7:0]out
    );
    assign out[0] = (in == 3'd0);
    assign out[1] = (in == 3'd1);
    assign out[2] = (in == 3'd2);
    assign out[3] = (in == 3'd3);
    assign out[4] = (in == 3'd4);
    assign out[5] = (in == 3'd5);
    assign out[6] = (in == 3'd6);
    assign out[7] = (in == 3'd7);
    
endmodule
