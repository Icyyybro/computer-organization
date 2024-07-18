
//EX/MEM阶段的寄存器
// 实现执行与访存阶段之间的寄存器，将执行阶段的结果在下一个时钟周期传递到访存阶段
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module ex_mem(

	input	wire clk,
	input wire rst,

	//来自控制模块的信息
	input wire[5:0]	 stall,	
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]  ex_wd,//执行阶段的指令执行后要写入的目的寄存器地址
	input wire   ex_wreg,//执行阶段的指令执行后是否有要写入的目的寄存器
	input wire[`RegBus] ex_wdata,// 执行阶段的指令执行后要写入目的寄存器的值	
	
	
	//送到访存阶段的信息
	output reg[`RegAddrBus]  mem_wd,//访存阶段的指令要写入的目的寄存器地址
	output reg   mem_wreg,//访存阶段的指令是否有要写入的目的寄存器
	output reg[`RegBus]  mem_wdata//访存阶段的指令要写入目的寄存器的值
	
	

	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;	
		
	//（1）当stall【3】为 Stop，stall【4】为NoStop时，表示执行阶段暂停，
	//而访存阶段继续，所以使用空指令作为下一个周期进入访存阶段的指令
	//(2）当stall【3】为NoStop 时，执行阶段继续，执行后的指令进入访存阶段?
	//（3）其余情况下，保持访存阶段的寄存器 mem_wb、mem_wreg、mem_wdata、不变?
	

		end else if(stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;
						    
		end else if(stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;	
		
		
	end  
			
end
endmodule