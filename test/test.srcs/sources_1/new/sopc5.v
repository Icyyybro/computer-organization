`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 15:23:04
// Design Name: 
// Module Name: sopc5
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


module sopc5(
    input wire clk,
    input wire rst
    );
    wire rom_ce_o;
    wire[31:0] rom_addr_o;
    wire[31:0] inst_i;

    //实例化CPU
    Five_stage_Pipeline_CPU Five_stage_Pipeline_CPU0(.rst(rst),
                                     .clk(clk),
                                     .rom_inst_i(inst_i),
                                     .rom_ce_o(rom_ce_o),
                                     .rom_addr_o(rom_addr_o));

    //实例化inst_rom
    inst_rom rom0(.ce(rom_ce_o),
                  .addr(rom_addr_o),
                  .inst(inst_i));
endmodule
