//openmips_min_sopc�Ĳ����ļ�
//////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module openmips_min_sopc_tb();

  reg     CLOCK_50;//�����źţ�����ʱ���ź�
  reg     rst;//�����źţ����Ǹ�λ�ź�
  //����CLOCK_50�źţ�ÿ��10��ʱ�䵥λ��CLOCK_50��ֵ��ת���ɴ˵õ�һ�������źš�
  // �ڷ����ʱ��һ��ʱ�䵥λĬ����1ns������CLOCK_50��ֵÿ10ns��תһ�Σ���Ӧ
  // ���� 50MHz ��ʱ��
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
  // ����rst�źţ��ʼΪ1����ʾ��λ�ź���Ч������195 ��ʱ�䵥λ����195ns��
  // ����rst �źŵ�ֵΪ0����λ�ź���Ч����λ������������1000ns����ͣ����
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #4100 $stop;
  end
  //������ģ�������     
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

endmodule