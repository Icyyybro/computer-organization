// 指令存储器ROM 的作用是存储指令，并依据输入的地址，给出对应地址的指令。
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module inst_rom(

    input	wire	clk,
	input wire	ce,//使能信号
	input wire[`InstAddrBus]	addr,//要读出指令的地址
	output reg[`InstBus]	inst//读出的指令
);
// 定义一个数组，大小是 InstMemNum，元素宽度是 InstBus
	reg[`InstBus]  inst_mem[0:`InstMemNum-1];//使用二维向量定义存储器
//使用文件inst rom.data初始化指令存储器
	initial $readmemh("D:/CODE/computer_organization/Forth_Experiment/inst_rom.data", inst_mem);
// 当复位信号无效时，依据输入的地址，给出指令存储器 ROM中对应的元素
	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;//使能信号无效时，给出的数据是0
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];//使能信号有效时，给出地址addr对应的指令
		end
	end

endmodule