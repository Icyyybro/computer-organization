// 指令指针寄存器PC
//PC模块的功能就是给出取指令地址，同时每个时钟周期取指令地址递增。
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module pc_reg(
	input	wire	clk,
	input wire	rst,
	//来自控制模块的信息
	input wire[5:0]     stall,//来自控制模块CTRL
	//来自译码阶段的信息
	input wire    branch_flag_i,//是否发生转移
	input wire[`RegBus]  branch_target_address_i,//转移到的目标地址
	output reg[`InstAddrBus]	pc,//要读取的指令地址
	output reg  ce//指令存储器使能信号
	
);

	always @ (posedge clk) begin//在时钟信号上升沿触发
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;//指令存储器使能信号无效的时候，pc保持为0
		//当stall【0】为NoStop 时，pc加 4，否则，保持pc不变?	
		end else if(stall[0] == `NoStop) begin
		  	if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin
		  		pc <= pc + 4'h4;
		  	end
		end
	end
	
	always @ (posedge clk) begin//在时钟信号上升沿触发
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;//复位信号有效的时候，指令存储器使能信号无效
		end else begin
			ce <= `ChipEnable;//复位信号无效的时候，指令存储器使能信号有效
		end
	end

endmodule