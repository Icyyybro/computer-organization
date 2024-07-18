`timescale 1ns / 1ps

module singleCycle_cpu(
    input wire clk,
    input wire rst,
    input wire[31:0] rom_inst_i,
    output wire rom_ce_o,
    output wire[31:0] rom_addr_o
    );
    
    pc pc0(clk,rst,rom_addr_o,rom_ce_o);
    wire[31:0] reg1_data;
    wire[31:0] reg2_data;
    wire[3:0] id_aluop_o;
    wire[31:0] id_reg1_o;
    wire[31:0] id_reg2_o;
    wire[4:0] id_wd_o;
    wire id_wreg_o;
    wire reg1_read;
    wire[4:0] reg1_addr;
    wire reg2_read;
    wire[4:0] reg2_addr;
    
    id id0(rst,rom_inst_i,reg1_data,reg2_data,
    reg1_read,reg1_addr,reg2_read,reg2_addr,
    id_wreg_o,id_wd_o,id_reg1_o,id_reg2_o,
    id_aluop_o);
    
    wire ex_wreg;
    wire[4:0] ex_wd;
    wire[31:0] ex_wdata_o;
    
    regfile regfile0(reg1_read,reg1_addr,reg2_read,reg2_addr,
    ex_wd,ex_wreg,ex_wdata_o,rst,clk,reg1_data,reg2_data);
    
    alu alu0(id_aluop_o,id_reg1_o,id_reg2_o,id_wd_o,id_wreg_o,
    ex_wdata_o,ex_wd,ex_wreg);
endmodule
