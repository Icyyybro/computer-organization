// ʵ����32��32λͨ�������Ĵ���������ͬʱ���������Ĵ����Ķ�������һ���Ĵ�����д����
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module regfile(

	input	wire clk,
	input wire rst,
	
	//д�˿�
	input wire	we,//дʹ���ź�
	input wire[`RegAddrBus] waddr,//Ҫд��ļĴ�����ַ
	input wire[`RegBus] wdata,//Ҫд�������
	
	//���˿�1
	input wire	 re1,//��һ�����Ĵ����˿ڶ�ʹ���ź�
	input wire[`RegAddrBus] raddr1,//��һ�����Ĵ����˿�Ҫ��ȡ�ļĴ����ĵ�ַ
	output reg[`RegBus] rdata1,//��һ�����Ĵ����˿�����ļĴ���ֵ
	
	//���˿�2
	input wire	 re2,//�ڶ������Ĵ����˿ڶ�ʹ���ź�
	input wire[`RegAddrBus] raddr2,//�ڶ������Ĵ����˿�Ҫ��ȡ�ļĴ����ĵ�ַ
	output reg[`RegBus] rdata2//�ڶ������Ĵ����˿�����ļĴ���ֵ
	
);

	reg[`RegBus]  regs[0:`RegNum-1];//����32��32λ�Ĵ���
//д����
//����λ�ź���Чʱ��rstΪRstDisable������дʹ���ź� we��Ч��weΪ WriteEnable����
//��д����Ŀ�ļĴ���������0������£����Խ�д�������ݱ��浽Ŀ�ļĴ�����
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	//���˿�1�Ķ�����?
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;//����λ�ź���Чʱ����һ�����Ĵ����˿ڵ����ʼ��Ϊ 0;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;//����λ�ź���Чʱ�������ȡ����0����ôֱ�Ӹ��� 0;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) // �����һ�����Ĵ����˿�Ҫ��ȡ��Ŀ��Ĵ�����Ҫд���Ŀ�ļĴ�����ͬһ���Ĵ�?����
	  	            && (re1 == `ReadEnable)) begin//��ôֱ�ӽ�Ҫд���ֵ��Ϊ��һ�����Ĵ����˿ڵ����;
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin//�����������������㣬
	  //��ô������һ�����Ĵ����˿�Ҫ��ȡ��Ŀ��Ĵ�����ַ��Ӧ?�Ĵ�����ֵ;
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `ZeroWord;// ��һ�����Ĵ����˿ڲ���ʹ��ʱ��ֱ����� 0��
	  end
	end
//���˿�2�Ķ�����?
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