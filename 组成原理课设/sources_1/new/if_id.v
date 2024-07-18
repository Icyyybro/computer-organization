// IF/ID阶段的寄存器
//实现取指与译码阶段之间的寄存器，将取指阶段的结果（取得的指令、指令地址等信息）在下一个时钟传递到译码阶段
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module if_id(
	input	wire	 clk,
	input wire	  rst,

	//来自控制模块的信息
	input wire[5:0]   stall,	
	//来自取指阶段的信号，其中宏定义 InstBus 表示指令宽度，为 32
	input wire[`InstAddrBus]	 if_pc,//取指阶段取得的指令对应的地址
	input wire[`InstBus]     if_inst,//取指阶段取得的指令
	//对应译码阶段的信号
	output reg[`InstAddrBus]    id_pc,//译码阶段的指令对应的地址
	output reg[`InstBus]   id_inst // 译码阶段的指令
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;//复位的时候 pc 为 0
			id_inst <= `ZeroWord;//复位的时候指令也为0，实际就是空指令
			
		//当stall【1】为Stop，Stall【2】为NoStop时，表示取指阶段暂停，而译码阶段继续，
		//所以使用空指令作为下一个周期进入译码阶段的指令
		//当Stall【1】为NoStop 时，取指阶段继续，取得的指令进入译码阶段其余情况下，
		//保持译码阶段的寄存器 id_pc、id_inst 不变?
		end else if(stall[1] == `Stop && stall[2] == `NoStop) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;	
	  end else if(stall[1] == `NoStop) begin
		  id_pc <= if_pc;//其余时刻向下传递取指阶段的值?
		  id_inst <= if_inst;
		end
	end

endmodule