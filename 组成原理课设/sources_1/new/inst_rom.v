// ָ��洢��ROM �������Ǵ洢ָ�����������ĵ�ַ��������Ӧ��ַ��ָ�
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"

module inst_rom(

    input	wire	clk,
	input wire	ce,//ʹ���ź�
	input wire[`InstAddrBus]	addr,//Ҫ����ָ��ĵ�ַ
	output reg[`InstBus]	inst//������ָ��
);
// ����һ�����飬��С�� InstMemNum��Ԫ�ؿ���� InstBus
	reg[`InstBus]  inst_mem[0:`InstMemNum-1];//ʹ�ö�ά��������洢��
//ʹ���ļ�inst rom.data��ʼ��ָ��洢��
	initial $readmemh("D:/CODE/computer_organization/Forth_Experiment/inst_rom.data", inst_mem);
// ����λ�ź���Чʱ����������ĵ�ַ������ָ��洢�� ROM�ж�Ӧ��Ԫ��
	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;//ʹ���ź���Чʱ��������������0
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];//ʹ���ź���Чʱ��������ַaddr��Ӧ��ָ��
		end
	end

endmodule