// 实现了32个32位通用整数寄存器，可以同时进行两个寄存器的读操作和一个寄存器的写操作
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module regfile(

	input	wire clk,
	input wire rst,
	
	//写端口
	input wire	we,//写使能信号
	input wire[`RegAddrBus] waddr,//要写入的寄存器地址
	input wire[`RegBus] wdata,//要写入的数据
	
	//读端口1
	input wire	 re1,//第一个读寄存器端口读使能信号
	input wire[`RegAddrBus] raddr1,//第一个读寄存器端口要读取的寄存器的地址
	output reg[`RegBus] rdata1,//第一个读寄存器端口输出的寄存器值
	
	//读端口2
	input wire	 re2,//第二个读寄存器端口读使能信号
	input wire[`RegAddrBus] raddr2,//第二个读寄存器端口要读取的寄存器的地址
	output reg[`RegBus] rdata2//第二个读寄存器端口输出的寄存器值
	
);

	reg[`RegBus]  regs[0:`RegNum-1];//定义32个32位寄存器
//写操作
//当复位信号无效时（rst为RstDisable），在写使能信号 we有效（we为 WriteEnable），
//且写操作目的寄存器不等于0的情况下，可以将写输入数据保存到目的寄存器。
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	//读端口1的读操作?
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;//当复位信号有效时，第一个读寄存器端口的输出始终为 0;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;//当复位信号无效时，如果读取的是0，那么直接给出 0;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) // 如果第一个读寄存器端口要读取的目标寄存器与要写入的目的寄存器是同一个寄存?器，
	  	            && (re1 == `ReadEnable)) begin//那么直接将要写入的值作为第一个读寄存器端口的输出;
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin//如果上述情况都不满足，
	  //那么给出第一个读寄存器端口要读取的目标寄存器地址对应?寄存器的值;
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `ZeroWord;// 第一个读寄存器端口不能使用时，直接输出 0。
	  end
	end
//读端口2的读操作?
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

endmodule