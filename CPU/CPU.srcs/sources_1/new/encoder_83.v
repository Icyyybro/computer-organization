`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 15:10:18
// Design Name: 
// Module Name: encoder_83
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


module encoder_83(
    input wire [7:0] in,
    output wire [2:0] out
    );
    assign out = in[0] ? 3'd0:
                  in[1] ? 3'd1:
                  in[2] ? 3'd2:
                  in[3] ? 3'd3:
                  in[4] ? 3'd4:
                  in[5] ? 3'd5:
                  in[6] ? 3'd6:
                  in[7] ? 3'd7:
                  3'd0;
endmodule
