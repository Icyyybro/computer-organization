`include "defines.v"//159
module ex(
	input wire rst,
	//�͵�ִ�н׶ε���Ϣ
	input wire[`AluOpBus]  aluop_i,
	input wire[`AluSelBus] alusel_i,
	input wire[`RegBus] reg1_i,			//���������Դ������1
	input wire[`RegBus] reg2_i,			//���������Դ������ 2?
	input wire[`RegAddrBus] wd_i,		//ָ��ִ��Ҫд���Ŀ�ļĴ�����ַ
	input wire wreg_i,					//�Ƿ���Ҫд���Ŀ�ļĴ���
	input wire[`RegBus] inst_i,			//ָ��
	//�Ƿ�ת�ơ��Լ�link address
	input wire[`RegBus]           link_address_i,//����ִ�н׶ε�ת��ָ��Ҫ����ķ��ص�ַ
	input wire                    is_in_delayslot_i,	//��ǰ����ִ�н׶ε�ָ���Ƿ�λ���ӳٲ�
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]			  wdata_o,
	//���������ļ��������Ϊ���ء��洢ָ��׼����
	output wire[`AluOpBus]        aluop_o,
	output wire[`RegBus]          mem_addr_o,
	output wire[`RegBus]          reg2_o,
	output reg stallreq
);

	reg[`RegBus] logicout;				//�����߼�������
	reg[`RegBus] shiftres;				//�����߼���λ������
	reg[`RegBus] arithmeticres;			//������������Ľ��	
	wire[`RegBus] reg2_i_mux;			//��������ĵڶ��������� reg2_i�Ĳ���
	wire[`RegBus] reg1_i_not;			//��������ĵ�һ��������reg1_iȡ�����ֵ
	wire[`RegBus] result_sum;			//����ӷ����
	wire ov_sum;						//����������
	wire reg1_eq_reg2;					//��һ���������Ƿ���ڵڶ���������
	wire reg1_lt_reg2;					//��һ���������Ƿ�С�ڵڶ���������

    //aluop_o���ݵ��ô�׶Σ����ڼ��ء��洢ָ��
    assign aluop_o = aluop_i;
  
    //mem_addr���ݵ��ô�׶Σ��Ǽ��ء��洢ָ���Ӧ�Ĵ洢����ַ(�ô��ַ����������memʵ�ֵ�)
    assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};

    //������������Ҳ���ݵ��ô�׶Σ�Ҳ��Ϊ���ء��洢ָ��׼����
    assign reg2_o = reg2_i;
			
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_NOR_OP:		begin
					logicout <= ~(reg1_i |reg2_i);
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_i ^ reg2_i;
				end
				default:				begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	always @ (*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP:			begin
					shiftres <= reg2_i << reg1_i[4:0] ;
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
												| reg2_i >> reg1_i[4:0];
				end
				default:				begin
					shiftres <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	//�����������
    //A.����Ǽӷ����㣬��ʱ reg2_i_mux ���ǵڶ���������reg2_i������ result_sum ���Ǽӷ�����Ľ��
    //B������Ǽ������㣬��ʱreg2_i_mux �ǵڶ���������reg2_i�Ĳ��룬���� result sum ���Ǽ�������Ľ��
    //c.������з��űȽ����㣬��ʱ reg2 i muxҲ�ǵڶ��������� reg2 i�Ĳ��룬����result_sumҲ�Ǽ�������Ľ����
    //����ͨ���жϼ����Ľ���Ƿ�С���㣬�����жϵ�һ�������� reg1_i �Ƿ�С�ڵڶ��������� reg2_i
	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SUBU_OP) ||
											 (aluop_i == `EXE_SLT_OP) ) 
											 ? (~reg2_i)+1 : reg2_i;

	assign result_sum = reg1_i + reg2_i_mux;										 

	//�����Ƿ���� �ӷ�ָ�add��addi��������ָ�sub��ִ�е�ʱ��
	//��Ҫ�ж��Ƿ���������������������֮һʱ���������
	// A��reg1_i Ϊ������reg2_i_muxΪ��������������֮��Ϊ���� 
	//B��reg1 iΪ������reg2 i muxΪ��������������֮��Ϊ����	
	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
									((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));  

	//���������1�Ƿ�С�ڲ�����2�������������
	//A. aluop_iΪEXE SLT OP��ʾ�з��űȽ����㣬��ʱ�ַ� 3����� 
	//A1��reg1_iΪ������reg2_iΪ��������Ȼregl_iС��reg2_i
	//A2.reg1_iΪ������reg2_iΪ����������reg1_i��ȥreg2_i��ֵС��0?���� result_sumΪ��������ʱҲ��reg1_iС��reg2_i								
	//A3��regl_iΪ������reg2_iΪ����������reg1_i��ȥ reg2_i��ֵС�� 0?���� result_sumΪ��������ʱҲ�� reg1_iС�� reg2_i?
	//B���޷������Ƚϵ�ʱ��ֱ��ʹ�ñȽ�������Ƚ� reg1_i��reg2_i									
	assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
												 ((reg1_i[31] && !reg2_i[31]) || 
												 (!reg1_i[31] && !reg2_i[31] && result_sum[31])||
			                   (reg1_i[31] && reg2_i[31] && result_sum[31]))
			                   :	(reg1_i < reg2_i);
  
	//ȡ��
    assign reg1_i_not = ~reg1_i;
							
	always @ (*) begin
		if(rst == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLT_OP, `EXE_SLTU_OP: begin
					arithmeticres <= reg1_lt_reg2 ;
				end
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDIU_OP, `EXE_ADDI_OP:begin
					arithmeticres <= result_sum; 
				end
				`EXE_SUB_OP, `EXE_SUBU_OP:begin
					arithmeticres <= result_sum; 
				end		
				default:begin
					arithmeticres <= `ZeroWord;
				end
			endcase
		end
	end

    always @ (*) begin
         wd_o <= wd_i;          
         if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) || 
              (aluop_i == `EXE_SUB_OP)) && (ov_sum == 1'b1)) begin
            wreg_o <= `WriteDisable;
         end else begin
          wreg_o <= wreg_i;
	 end
	 
	 case ( alusel_i ) 
	 	`EXE_RES_LOGIC:begin
	 		wdata_o <= logicout;
	 	end
	 	`EXE_RES_SHIFT:begin
	 		wdata_o <= shiftres;
	 	end
	 	`EXE_RES_ARITHMETIC:begin
	 		wdata_o <= arithmeticres;
	 	end
	 	`EXE_RES_JUMP_BRANCH:begin
	 		wdata_o <= link_address_i;
	 	end	 	
	 	default:begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end

endmodule