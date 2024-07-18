// IF/ID�׶εļĴ���
//ʵ��ȡָ������׶�֮��ļĴ�������ȡָ�׶εĽ����ȡ�õ�ָ�ָ���ַ����Ϣ������һ��ʱ�Ӵ��ݵ�����׶�
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module if_id(
	input	wire	 clk,
	input wire	  rst,

	//���Կ���ģ�����Ϣ
	input wire[5:0]   stall,	
	//����ȡָ�׶ε��źţ����к궨�� InstBus ��ʾָ���ȣ�Ϊ 32
	input wire[`InstAddrBus]	 if_pc,//ȡָ�׶�ȡ�õ�ָ���Ӧ�ĵ�ַ
	input wire[`InstBus]     if_inst,//ȡָ�׶�ȡ�õ�ָ��
	//��Ӧ����׶ε��ź�
	output reg[`InstAddrBus]    id_pc,//����׶ε�ָ���Ӧ�ĵ�ַ
	output reg[`InstBus]   id_inst // ����׶ε�ָ��
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;//��λ��ʱ�� pc Ϊ 0
			id_inst <= `ZeroWord;//��λ��ʱ��ָ��ҲΪ0��ʵ�ʾ��ǿ�ָ��
			
		//��stall��1��ΪStop��Stall��2��ΪNoStopʱ����ʾȡָ�׶���ͣ��������׶μ�����
		//����ʹ�ÿ�ָ����Ϊ��һ�����ڽ�������׶ε�ָ��
		//��Stall��1��ΪNoStop ʱ��ȡָ�׶μ�����ȡ�õ�ָ���������׶���������£�
		//��������׶εļĴ��� id_pc��id_inst ����?
		end else if(stall[1] == `Stop && stall[2] == `NoStop) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;	
	  end else if(stall[1] == `NoStop) begin
		  id_pc <= if_pc;//����ʱ�����´���ȡָ�׶ε�ֵ?
		  id_inst <= if_inst;
		end
	end

endmodule