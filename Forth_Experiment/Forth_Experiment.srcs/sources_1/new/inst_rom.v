`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 15:12:05
// Design Name: 
// Module Name: inst_rom
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


module inst_rom(
    input wire ce,
    input wire[31:0] addr,
    output reg[31:0] inst
    );
    reg[31:0] roms[127:0];

    initial begin
        $readmemh("D:/CODE/computer_organization/Forth_Experiment/inst_rom.data", roms);
    end
    
    always @(*) begin
        if(ce==0) begin
            inst<=32'd0;
        end else begin
            inst<=roms[addr[31:2]];
        end
    end

endmodule