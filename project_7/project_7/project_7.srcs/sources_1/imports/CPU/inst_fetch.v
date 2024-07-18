`timescale 1ns / 1ps

module inst_fetch(
    input wire clk,
    input wire rst,
    output wire[31:0] inst_o
     );
     
     wire ce;
     wire[31:0] pc;
     pc pc0(clk,rst,pc,ce);
     inst_rom rom0(ce,pc,inst_o);
endmodule
