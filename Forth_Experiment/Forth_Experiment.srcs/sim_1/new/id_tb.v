`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 14:03:43
// Design Name: 
// Module Name: id_tb
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


module id_tb(
    
    );

    reg rst;
    reg[31:0] inst_i;
    reg[31:0] reg1_data_i;
    reg[31:0] reg2_data_i;
    wire reg1_read_o;
    wire[4:0] reg1_addr_o;
    wire reg2_read_o;
    wire[4:0] reg2_addr_o;
    wire wreg_o;
    wire[4:0] wd_o;
    wire[31:0] reg1_o;
    wire[31:0] reg2_o;
    wire[3:0] aluop_o;
    integer i;

    id id0(rst,inst_i,reg1_data_i,reg2_data_i,
            aluop_o,reg1_o,reg2_o,wd_o,wreg_o,
            reg1_addr_o,reg1_read_o,reg2_addr_o,reg2_read_o);
    reg[31:0] roms[13:0];

    initial begin
        $readmemh("D:/CODE/computer_organization/Forth_Experiment/inst_rom.data",roms);
    end

    initial begin
        rst=0;
        reg1_data_i=32'h10101010;
        reg2_data_i=32'h01010101;
        for(i=0;i<14;i=i+1) begin
            inst_i=roms[i];
            #20;
        end
    end


endmodule
