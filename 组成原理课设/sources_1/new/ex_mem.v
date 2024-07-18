
//EX/MEM�׶εļĴ���
// ʵ��ִ����ô�׶�֮��ļĴ�������ִ�н׶εĽ������һ��ʱ�����ڴ��ݵ��ô�׶�
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module ex_mem(

	input	wire clk,
	input wire rst,

	//���Կ���ģ�����Ϣ
	input wire[5:0]	 stall,	
	
	//����ִ�н׶ε���Ϣ	
	input wire[`RegAddrBus]  ex_wd,//ִ�н׶ε�ָ��ִ�к�Ҫд���Ŀ�ļĴ�����ַ
	input wire   ex_wreg,//ִ�н׶ε�ָ��ִ�к��Ƿ���Ҫд���Ŀ�ļĴ���
	input wire[`RegBus] ex_wdata,// ִ�н׶ε�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ	
	
	
	//�͵��ô�׶ε���Ϣ
	output reg[`RegAddrBus]  mem_wd,//�ô�׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
	output reg   mem_wreg,//�ô�׶ε�ָ���Ƿ���Ҫд���Ŀ�ļĴ���
	output reg[`RegBus]  mem_wdata//�ô�׶ε�ָ��Ҫд��Ŀ�ļĴ�����ֵ
	
	

	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;	
		
	//��1����stall��3��Ϊ Stop��stall��4��ΪNoStopʱ����ʾִ�н׶���ͣ��
	//���ô�׶μ���������ʹ�ÿ�ָ����Ϊ��һ�����ڽ���ô�׶ε�ָ��
	//(2����stall��3��ΪNoStop ʱ��ִ�н׶μ�����ִ�к��ָ�����ô�׶�?
	//��3����������£����ַô�׶εļĴ��� mem_wb��mem_wreg��mem_wdata������?
	

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