`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:00:39
// Design Name: 
// Module Name: decoder_5_32
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


module decoder_5_32(
    input[4:0] in,
    output[31:0]out
    );
    genvar i;
    generate
        for(i=0;i<32;i=i+1)
        begin:test
            assign out[i]=(in==i);
        end
    endgenerate
endmodule