
// ����ģ�飬������ˮ�ߵ�ˢ�¡���ͣ��
// 
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module ctrl(

	input wire rst,

	input wire   stallreq_from_id,//��������׶ε�ָ���Ƿ�������ˮ����ͣ

  //����ִ�н׶ε���ͣ����
	input wire    stallreq_from_ex,//ִ�н׶ε�ָ���Ƿ�������ˮ����ͣ
	output reg[5:0]   stall  //  ��ͣ��ˮ�߿����ź�   
	//stal��0����ʾȡָ��ַ PC�Ƿ񱣳ֲ��䣬Ϊ1��ʾ���ֲ��䡣
	// stall��1����ʾ��ˮ��ȡָ�׶��Ƿ���ͣ��Ϊ1��ʾ��ͣ��
	//stall��2����ʾ��ˮ������׶��Ƿ���ͣ��Ϊ1��ʾ��ͣ��
	// stall��3����ʾ��ˮ��ִ�н׶��Ƿ���ͣ��Ϊ1��ʾ��ͣ��
	//stall��4����ʾ��ˮ�߷ô�׶��Ƿ���ͣ��Ϊ1��ʾ��ͣ��
	//stall��5����ʾ��ˮ�߻�д�׶��Ƿ���ͣ��Ϊ1��ʾ��ͣ��
);


	always @ (*) begin
		if(rst == `RstEnable) begin
			stall <= 6'b000000;
		end else if(stallreq_from_ex == `Stop) begin
			stall <= 6'b001111;
		end else if(stallreq_from_id == `Stop) begin
			stall <= 6'b000111;			
		end else begin
			stall <= 6'b000000;
		end    //if
	end      //always
			

endmodule