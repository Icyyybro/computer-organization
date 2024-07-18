
// MEM/WB�׶εļĴ���
// ʵ�ַô����д�׶�֮��ļĴ��������ô�׶εĽ������һ��ʱ�����ڴ��ݵ���д�׶�
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module mem_wb(

	input	wire clk,
	input wire rst,

  //���Կ���ģ�����Ϣ
	input wire[5:0] stall,	

	//���Էô�׶ε���Ϣ	
	input wire[`RegAddrBus]  mem_wd,//�ô�׶ε�ָ������Ҫд���Ŀ�ļĴ�����ַ
	input wire   mem_wreg,//�ô�׶ε�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
	input wire[`RegBus] mem_wdata,//�ô�׶ε�ָ������Ҫд��Ŀ�ļĴ�����ֵ


	//�͵���д�׶ε���Ϣ
	output reg[`RegAddrBus]    wb_wd,//��д�׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
	output reg  wb_wreg,//��д�׶ε�ָ���Ƿ���Ҫд���Ŀ�ļĴ���
	output reg[`RegBus]	  wb_wdata//��д�׶ε�ָ��Ҫд��Ŀ�ļĴ�����ֵ
		       
	
);

//���ô�׶�ָ���Ƿ�ҪдĿ�ļĴ���mem_wreg��
//Ҫд��Ŀ�ļĴ�����ַ mem_wd��Ҫд������� mem_wdata
//����Ϣ���ݵ���д�׶ζ�Ӧ�Ľӿ� wb_wreg��wb_wd��wb_wdata��?
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;	
	
	
	//��1����stal1��4��Ϊ Stop��stall��5��ΪNoStopʱ����ʾ�ô�׶���ͣ��?
	//����д�׶μ���������ʹ�ÿ�ָ����Ϊ��һ�����ڽ����д�׶ε�ָ��?
	//��2����stall��4��ΪNoStop ʱ���ô�׶μ������ô���ָ������д�׶�
	//3����������£����ֻ�д�׶εļĴ��� wb_wd��wb_wreg��wb_wdata��?����
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