
// MEM/WB阶段的寄存器
// 实现访存与回写阶段之间的寄存器，将访存阶段的结果在下一个时钟周期传递到回写阶段
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module mem_wb(

	input	wire clk,
	input wire rst,

  //来自控制模块的信息
	input wire[5:0] stall,	

	//来自访存阶段的信息	
	input wire[`RegAddrBus]  mem_wd,//访存阶段的指令最终要写入的目的寄存器地址
	input wire   mem_wreg,//访存阶段的指令最终是否有要写入的目的寄存器
	input wire[`RegBus] mem_wdata,//访存阶段的指令最终要写入目的寄存器的值


	//送到回写阶段的信息
	output reg[`RegAddrBus]    wb_wd,//回写阶段的指令要写入的目的寄存器地址
	output reg  wb_wreg,//回写阶段的指令是否有要写入的目的寄存器
	output reg[`RegBus]	  wb_wdata//回写阶段的指令要写入目的寄存器的值
		       
	
);

//将访存阶段指令是否要写目的寄存器mem_wreg、
//要写的目的寄存器地址 mem_wd、要写入的数据 mem_wdata
//等信息传递到回写阶段对应的接口 wb_wreg、wb_wd、wb_wdata。?
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;	
	
	
	//（1）当stal1【4】为 Stop，stall【5】为NoStop时，表示访存阶段暂停，?
	//而回写阶段继续，所以使用空指令作为下一个周期进入回写阶段的指令?
	//（2）当stall【4】为NoStop 时，访存阶段继续，访存后的指令进入回写阶段
	//3）其余情况下，保持回写阶段的寄存器 wb_wd、wb_wreg、wb_wdata、?不变
		end else if(stall[4] == `Stop && stall[5] == `NoStop) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;
		  	  
		end else if(stall[4] == `NoStop) begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
					
		end    //if
	end      //always
			

endmodule