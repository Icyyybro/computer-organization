`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/21 14:21:28
// Design Name: 
// Module Name: singleCycle_cpu
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


module singleCycle_cpu(
    input wire rst,
    input wire clk,
    input wire[31:0] rom_inst_i,
    output wire rom_ce_o,
    output wire[31:0] rom_addr_o
    );

    //实例化PC
    PC pc0(rst, clk, rom_addr_o, rom_ce_o);

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
           .inst_i(rom_inst_i),
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

    //实例化regfile
    wire ex_wreg;
    wire [4:0] ex_wd;
    wire [31:0] ex_wdata_o;
    regfile regfile0(.rst(rst),
                     .clk(clk),
                     .waddr(ex_wd),
                     .wdata(ex_wdata_o),
                     .we(ex_wreg),
                     .raddr1(reg1_addr),
                     .re1(reg1_read),
                     .rdata1(reg1_data),
                     .raddr2(reg2_addr),
                     .re2(reg2_read),
                     .rdata2(reg2_data)
                     );

    //实例化alu
    alu alu0(.alu_control(id_aluop_o),
             .alu_src1(id_reg1_o),
             .alu_src2(id_reg2_o),
             .wd_i(id_wd_o),
             .wreg_i(id_wreg_o),
             .alu_result(ex_wdata_o),
             .wd_o(ex_wd),
             .wreg_o(ex_wreg));

    

endmodule
