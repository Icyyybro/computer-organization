//ID/EX阶段的寄存器
// 实现译码与执行阶段之间的寄存器，将译码阶段的结果在下一个时钟周期传递到执行阶段
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module id_ex(

	input	wire clk,
	input wire rst,

	//来自控制模块的信息
	input wire[5:0]	 stall,
	
	//从译码阶段传递的信息
	input wire[`AluOpBus]         id_aluop,//译码阶段的指令要进行的运算的类型
	input wire[`AluSelBus]        id_alusel,//译码阶段的指令要进行的运算的子类型
	input wire[`RegBus]           id_reg1,//译码阶段的指令要进行的运算的源操作数1
	input wire[`RegBus]           id_reg2,//译码阶段的指令要进行的运算的源操作数2?
	input wire[`RegAddrBus]       id_wd,//译码阶段的指令要写入的目的寄存器地址
	input wire                    id_wreg,//译码阶段的指令是否有要写入的目的寄存器
	input wire[`RegBus]           id_link_address,//当前处于译码阶段的指令是否位于延迟槽
	input wire                    id_is_in_delayslot,//处于译码阶段的转移指令要保存的返回地址
	input wire                    next_inst_in_delayslot_i,	//下一条进入译码阶段的指令是否位于延迟槽	
	
	//传递到执行阶段的信息
	output reg[`AluOpBus]         ex_aluop,//执行阶段的指令要进行的运算的类型
	output reg[`AluSelBus]        ex_alusel,//执行阶段的指令要进行的运算的子类型
	output reg[`RegBus]           ex_reg1,//执行阶段的指令要进行的运算的源操作数1
	output reg[`RegBus]           ex_reg2,//执行阶段的指令要进行的运算的源操作数2
	output reg[`RegAddrBus]       ex_wd,//执行阶段的指令要写入的目的寄存器地址
	output reg                    ex_wreg,//执行阶段的指令是否有要写入的目的寄存器
	output reg[`RegBus]           ex_link_address,//处于执行阶段的转移指令要保存的返回地址
  output reg                    ex_is_in_delayslot,//当前处于执行阶段的指令是否位于延迟槽
	output reg                    is_in_delayslot_o	//当前处于译码阶段的指令是否位于延迟槽
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_link_address <= `ZeroWord;
			ex_is_in_delayslot <= `NotInDelaySlot;
	    is_in_delayslot_o <= `NotInDelaySlot;			
	    
	    //1）当 stall〔2】为 Stop，stall【3】为NoStop时，表示译码阶段暂停，
	    //而执行阶段继续，所以使用空指令作为下一个周期进入执行阶段的指令
	    //2）当stall【2】为NoStop 时，译码阶段继续，译码后的指令进入执行阶段
	    //3）其余情况下，保持执行阶段的寄存器ex aluop、
	    //ex_alusel、ex_reg1、?ex_reg2、ex _wd、ex_wreg 不变·
	  
		end else if(stall[2] == `Stop && stall[3] == `NoStop) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;	
			ex_link_address <= `ZeroWord;
	    ex_is_in_delayslot <= `NotInDelaySlot;			
	    
	//当流水线译码阶段没有被暂停时，ID/EX模块在时钟上升沿将新增加的输入传递到对应的输出    
		end else if(stall[2] == `NoStop) begin		
			ex_aluop <= id_aluop;
			ex_alusel <= id_alusel;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;		
			
			
			ex_link_address <= id_link_address;
			ex_is_in_delayslot <= id_is_in_delayslot;
	    is_in_delayslot_o <= next_inst_in_delayslot_i;				
		end
	end
	
endmodule