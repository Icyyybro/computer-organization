// ָ��ָ��Ĵ���PC
//PCģ��Ĺ��ܾ��Ǹ���ȡָ���ַ��ͬʱÿ��ʱ������ȡָ���ַ������
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module pc_reg(
	input	wire	clk,
	input wire	rst,
	//���Կ���ģ�����Ϣ
	input wire[5:0]     stall,//���Կ���ģ��CTRL
	//��������׶ε���Ϣ
	input wire    branch_flag_i,//�Ƿ���ת��
	input wire[`RegBus]  branch_target_address_i,//ת�Ƶ���Ŀ���ַ
	output reg[`InstAddrBus]	pc,//Ҫ��ȡ��ָ���ַ
	output reg  ce//ָ��洢��ʹ���ź�
	
);

	always @ (posedge clk) begin//��ʱ���ź������ش���
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;//ָ��洢��ʹ���ź���Ч��ʱ��pc����Ϊ0
		//��stall��0��ΪNoStop ʱ��pc�� 4�����򣬱���pc����?	
		end else if(stall[0] == `NoStop) begin
		  	if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin
		  		pc <= pc + 4'h4;
		  	end
		end
	end
	
	always @ (posedge clk) begin//��ʱ���ź������ش���
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;//��λ�ź���Ч��ʱ��ָ��洢��ʹ���ź���Ч
		end else begin
			ce <= `ChipEnable;//��λ�ź���Ч��ʱ��ָ��洢��ʹ���ź���Ч
		end
	end

endmodule