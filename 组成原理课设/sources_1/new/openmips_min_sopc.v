
// 基于OpenMIPS处理器的一个简单SOPC，用于验证具备了
// 为了验证，需要建立一个 SOPC，其中仅 OpenMIPS、
// 指令存储器 ROM，所以是一个最小 SOPC。
// OpenMIPS 从指令存储器中读取指令，
// 指令进入 OpenMIPS 开始执行。
// 
// 
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module openmips_min_sopc(

	input	wire clk,
	input wire rst
	
);

  //连接指令存储器
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
//例化处理器 OpenMIPS
 openmips openmips0(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce)
	
	);
	
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.inst(inst)	
	);


endmodule