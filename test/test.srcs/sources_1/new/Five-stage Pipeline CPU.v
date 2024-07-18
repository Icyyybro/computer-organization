`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 22:06:55
// Design Name: 
// Module Name: Five-stage Pipeline CPU
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


module Five_stage_Pipeline_CPU(
    input wire rst,
    input wire clk,
    input wire[31:0] rom_inst_i,
    output wire rom_ce_o,
    output wire[31:0] rom_addr_o
    );

    //实例化PC
    PC pc0(rst, clk, rom_addr_o, rom_ce_o);

    //实例化if_id
    wire[31:0] id_inst;
    if_id if_id0(.if_inst(rom_inst_i),
                 .clk(clk),
                 .id_inst(id_inst));

    //实例化id
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
    id id0(.rst(rst),
           .inst_i(id_inst),
           .reg1_data_i(reg1_data),
           .reg2_data_i(reg2_data),
           .reg1_read_o(reg1_read),
           .reg1_addr_o(reg1_addr),
           .reg2_read_o(reg2_read),
           .reg2_addr_o(reg2_addr),
           .wreg_o(id_wreg_o),
           .wd_o(id_wd_o),
           .reg1_o(id_reg1_o),
           .reg2_o(id_reg2_o),
           .aluop_o(id_aluop_o));

    //实例化ex_id
    wire[3:0] ex_aluop_o;
    wire[31:0] ex_reg1_o;
    wire[31:0] ex_reg2_o;
    wire[4:0] ex_wd_o;
    wire ex_wreg_o;
    ex_id ex_id0(.id_aluop(id_aluop_o),
                 .id_reg1(id_reg1_o),
                 .id_reg2(id_reg2_o),
                 .id_wd(id_wd_o),
                 .id_wreg(id_wreg_o),
                 .ex_aluop(ex_aluop_o),
                 .ex_reg1(ex_reg1_o),
                 .ex_reg2(ex_reg2_o),
                 .ex_wd(ex_wd_o),
                 .ex_wreg(ex_wreg_o),
                 .clk(clk));

    //实例化alu
    wire[31:0] alu_result_o;
    wire[4:0] wd_o;
    wire wreg_o;
    alu alu0(.alu_control(ex_aluop_o),
             .alu_src1(ex_reg1_o),
             .alu_src2(ex_reg2_o),
             .wd_i(ex_wd_o),
             .wreg_i(ex_wreg_o),
             .alu_result(alu_result_o),
             .wd_o(wd_o),
             .wreg_o(wreg_o));
    
    //实例化ex_mem
    wire[31:0] ex_mem_data_o;
    wire[4:0] ex_mem_wd_o;
    wire ex_mem_wreg_o;
    ex_mem ex_mem0(.ex_wdata(alu_result_o),
                   .ex_wd(wd_o),
                   .ex_wreg(wreg_o),
                   .mem_data(ex_mem_data_o),
                   .mem_wd(ex_mem_wd_o),
                   .mem_wreg(ex_mem_wreg_o),
                   .clk(clk));

    //实例化mem
    wire[31:0] mem_wdata_o;
    wire[4:0] mem_wd_o;
    wire mem_wreg_o;
    mem mem0(.wdata_i(ex_mem_data_o),
             .wd_i(ex_mem_wd_o),
             .wreg_i(ex_mem_wreg_o),
             .wdata_o(mem_wdata_o),
             .wd_o(mem_wd_o),
             .wreg_o(mem_wreg_o));

    //实例化mem_wb
    wire[31:0] wb_wdata_o;
    wire[4:0] wb_wd_o;
    wire wb_wreg_o;
    mem_wb mem_wb0(.mem_wdata(mem_wdata_o),
                   .mem_wd(mem_wd_o),
                   .mem_wreg(mem_wreg_o),
                   .wb_wdata(wb_wdata_o),
                   .wb_wd(wb_wd_o),
                   .wb_wreg(wb_wreg_o),
                   .clk(clk));

    //实例化regfile
    regfile regfile0(
                     .clk(clk),
                     .rst(rst),
                     .waddr(wb_wd_o),
                     .wdata(wb_wdata_o),
                     .we(wb_wreg_o),
                     .raddr1(reg1_addr),
                     .re1(reg1_read),
                     .rdata1(reg1_data),
                     .raddr2(reg2_addr),
                     .re2(reg2_read),
                     .rdata2(reg2_data)
                     );



    
endmodule
