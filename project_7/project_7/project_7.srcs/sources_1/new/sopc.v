`timescale 1ns / 1ps

module sopc(
    input wire clk,
    input wire rst   
    );
    wire rom_ce_o;
    wire[31:0] rom_addr_o;
    wire[31:0] inst_i;
    
    singleCycle_cpu cpu0(clk,rst,inst_i,rom_ce_o,rom_addr_o);
    
    inst_rom rom0(rom_ce_o,rom_addr_o,inst_i);
    
endmodule
