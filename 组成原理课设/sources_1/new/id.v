// ����׶�
// ��ָ��������룬�����������������͡����������Դ��������Ҫд���Ŀ�ļĴ�����ַ��
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module id(
	input wire rst,
	input wire[`InstAddrBus] pc_i,//����׶ε�ָ���Ӧ�ĵ�ַ
	input wire[`InstBus] inst_i,//����׶ε�ָ��

	input wire[`RegBus] reg1_data_i,//�� Regfile ����ĵ�һ�����Ĵ����˿ڵ�����
	input wire[`RegBus] reg2_data_i,//�� Regfile ����ĵڶ������Ĵ����˿ڵ�����

	//�����һ��ָ����ת��ָ���ô��һ��ָ���������ʱ��is_in_delayslotΪtrue
	input wire                    is_in_delayslot_i,//��ǰ��������׶ε�ָ���Ƿ�λ���ӳٲ�

	//�͵�regfile����Ϣ
	output reg                    reg1_read_o,//Regfile ģ��ĵ�һ�����Ĵ����˿ڵĶ�ʹ���ź�
	output reg                    reg2_read_o,//Regfile ģ��ĵڶ������Ĵ����˿ڵĶ�ʹ���ź�     
	output reg[`RegAddrBus]       reg1_addr_o,//Regfileģ��ĵ�һ�����Ĵ����˿ڵĶ���ַ�ź�
	output reg[`RegAddrBus]       reg2_addr_o,//Regfile ģ��ĵڶ������Ĵ����˿ڵĶ���ַ�ź� 	      
	
	//�͵�ִ�н׶ε���Ϣ
	output reg[`AluOpBus]         aluop_o,//����׶ε�ָ��Ҫ���е������������
	output reg[`AluSelBus]        alusel_o,//����׶ε�ָ��Ҫ���е����������
	output reg[`RegBus]           reg1_o,//����׶ε�ָ��Ҫ���е������Դ������1
	output reg[`RegBus]           reg2_o,//����׶ε�ָ��Ҫ���е������Դ������2
	output reg[`RegAddrBus]       wd_o,//����׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
	output reg                    wreg_o,//����׶ε�ָ���Ƿ���Ҫд���Ŀ�ļĴ���

	output reg                    next_inst_in_delayslot_o,//��һ����������׶ε�ָ���Ƿ�λ���ӳٲ�?
	
	output reg                    branch_flag_o,//�Ƿ���ת��
	output reg[`RegBus]           branch_target_address_o, //ת�Ƶ���Ŀ���ַ      
	output reg[`RegBus]           link_addr_o,//ת��ָ��Ҫ����ķ��ص�ַ
	output reg                    is_in_delayslot_o,//��ǰ��������׶ε�ָ���Ƿ�λ���ӳٲ�?
	
	output wire                   stallreq	//
);
//ȡ��ָ���ָ���룬������
  wire[5:0] op = inst_i[31:26];//ָ����
  wire[4:0] op2 = inst_i[10:6];
  wire[5:0] op3 = inst_i[5:0];//������
  wire[4:0] op4 = inst_i[20:16];
  reg[`RegBus]	imm;//����ָ��ִ����Ҫ��������
  reg instvalid;//ָʾָ���Ƿ���Ч
  wire[`RegBus] pc_plus_8;
  wire[`RegBus] pc_plus_4;
  wire[`RegBus] imm_sll2_signedext;  
  
  assign pc_plus_8 = pc_i + 8;//���浱ǰ����׶�ָ������ 2 ��ָ��ĵ�ַ
  assign pc_plus_4 = pc_i +4;//���浱ǰ����׶�ָ���������ŵ�ָ��ĵ�ַ
 // imm_sll2_signedext ��Ӧ��ָ֧���е�offset ������λ���ٷ�����չ�� 32 λ��ֵ 
  assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00 };  
  assign stallreq = `NoStop;
  
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;	
			link_addr_o <= `ZeroWord;
			branch_target_address_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			next_inst_in_delayslot_o <= `NotInDelaySlot;					
	  end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];//Ĭ��Ŀ�ļĴ�����ַwd_o?
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];//Ĭ��ͨ��Regfile���˿�1��ȡ�ļĴ�����ַ
			reg2_addr_o <= inst_i[20:16];//Ĭ��ͨ��Regfile���˿�2��ȡ�ļĴ�����ַ	
			imm <= `ZeroWord;
			link_addr_o <= `ZeroWord;
			branch_target_address_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;	
			next_inst_in_delayslot_o <= `NotInDelaySlot; 		
	//��������ָ���� op �����жϣ������ SPECIAL ��ָ�
	//���ж�ָ��ĵ� 6��10bit���� op2���Ƿ�Ϊ 0�����Ϊ0��
	//��ô�����ݹ����� op3��ֵ�����������жϣ�ȷ��ָ�����͡�
	//���ָ���� op ��Ϊ SPECIAL����ô��ֱ������ָ���� op ��ֵ�����жϡ�					
		  case (op)//����op��ֵ�ж�ָ��
		    `EXE_SPECIAL_INST:		begin//ָ������ SPECIAL?
		    	case (op2)
		    		5'b00000:			begin
		    			case (op3)//���ݹ������ж�������ָ��?
		    				`EXE_OR:	begin
		    					wreg_o <= `WriteEnable;//wreg_o��ʾ�Ƿ�ҪдĿ�ļĴ�����ָ����Ҫ�����д��Ŀ�ļĴ���������wreg_oΪWriteEnable
		    					aluop_o <= `EXE_OR_OP;//aluop_o ����Ҫִ�е����������ͣ���������������߼�"��"����
		  						alusel_o <= `EXE_RES_LOGIC; //alusel_o ����Ҫִ�е��������ͣ������������߼�����
		  						reg1_read_o <= 1'b1;//ֵΪ1��ʾ��Ҫͨ�� Regfile�Ķ��˿�1��ȡ�Ĵ���	
		  						reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end  
								
		    				`EXE_AND:	begin
		    				//and ָ����Ҫ�����д��Ŀ�ļĴ������������� wreg_o Ϊ WriteEnable
		    					wreg_o <= `WriteEnable;	
		    				//and ָ��Ҫ���е����߼�"��"�������������� alusel_o Ϊ EXE_RES_LOGIC������ aluop_oΪ EXE_AND_OP��		
		    					aluop_o <= `EXE_AND_OP;
		  						alusel_o <= `EXE_RES_LOGIC;	 
		  						//andָ����Ҫ��ȡ rs��rt �Ĵ�����ֵ���������� regl_read_o�� reg2_read_oΪ1
		  						 reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;	
		  						instvalid <= `InstValid;	
								end  	
		    				`EXE_XOR:	begin
		    					wreg_o <= `WriteEnable;		aluop_o <= `EXE_XOR_OP;
		  						alusel_o <= `EXE_RES_LOGIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;	
		  						instvalid <= `InstValid;	
								end  				
		    				`EXE_NOR:	begin
		    					wreg_o <= `WriteEnable;		aluop_o <= `EXE_NOR_OP;
		  						alusel_o <= `EXE_RES_LOGIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;	
		  						instvalid <= `InstValid;	
								end 

								

								`EXE_SLT: begin
									wreg_o <= `WriteEnable;		aluop_o <= `EXE_SLT_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
								`EXE_SLTU: begin
									wreg_o <= `WriteEnable;		aluop_o <= `EXE_SLTU_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
								`EXE_ADD: begin
									wreg_o <= `WriteEnable;	
							//add ָ�������������еļӷ����������Դ˴��� alusel_o ��ֵΪ EXE_RES_ARITHMETIC��aluop_o ��ֵΪ EXE_ADD_OP��			
									aluop_o <= `EXE_ADD_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
								`EXE_ADDU: begin
									wreg_o <= `WriteEnable;		aluop_o <= `EXE_ADDU_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
								`EXE_SUB: begin
									wreg_o <= `WriteEnable;		aluop_o <= `EXE_SUB_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
								`EXE_SUBU: begin
									wreg_o <= `WriteEnable;		aluop_o <= `EXE_SUBU_OP;
		  						alusel_o <= `EXE_RES_ARITHMETIC;		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end
	
								`EXE_JR: begin
		//jrָ���Ҫ���淵�ص�ַ���������� wreg_o ΪWriteDisable,���÷��ص�ַ link_addr_oΪ0	
		//aluop_o����Ĭ��ֵ EXE_NOP_OP��alusel_o ����Ĭ��ֵ EXE_RES_NOP��					
									wreg_o <= `WriteDisable;		aluop_o <= `EXE_JR_OP;
		  						alusel_o <= `EXE_RES_JUMP_BRANCH;   
		//jr ָ��Ҫת�Ƶ���Ŀ���ַ��ͨ�üĴ��� rs��ֵ��������Ҫ���� reg1_read_oΪ1��
		//��ʾͨ��Regfile ģ��Ķ��˿�1��ȡ�Ĵ�������ȡ�ļĴ�����ַ����ָ���е� rs��
		// ������������׶ε���� reg1_o ���ǵ�ַΪ rs �ļĴ�����ֵ�� 						
		  						reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;
		  						link_addr_o <= `ZeroWord;
		// ����ת��Ŀ���ַ branch_target_address_oΪ regl_o��Ҳ���Ƕ�ȡ������ͨ�üĴ��� rs ��ֵ�� 						
			            	branch_target_address_o <= reg1_o;
		//jr ָ���Ǿ���ת�ƣ��������� branch_flag_o Ϊ Branch��
			            	branch_flag_o <= `Branch;
		//��һ��ָ�����ӳٲ�ָ��������� next_inst_in_delayslot_oΪ InDelaySlot��	           
			            next_inst_in_delayslot_o <= `InDelaySlot;
			            instvalid <= `InstValid;	
								end
										 											  											
						    default:	begin
						    end
						  endcase
						 end
						default: begin
						end
					endcase	
					end									  

		  	`EXE_ANDI:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_AND_OP;
		  		alusel_o <= `EXE_RES_LOGIC;	
		  	// andi ָ��ֻ��Ҫ��ȡ rs �Ĵ�����ֵ���������� regl_read_oΪ1��reg2_readoΪ0	
		  		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {16'h0, inst_i[15:0]};//ָ��ִ����Ҫ��������	
					wd_o <= inst_i[20:16];	//ָ��ִ��Ҫд��Ŀ�ļĴ�����ַ?	  	
					instvalid <= `InstValid;//��ʾ��Чָ��	
				end	 	
	
		  	`EXE_LUI:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_OR_OP;
		  		alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {inst_i[15:0], 16'h0};		wd_o <= inst_i[20:16];//���� wd_o ΪҪд���Ŀ�ļĴ�����ַ		  	
					instvalid <= `InstValid;	
				end			

				`EXE_ADDI:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_ADDI_OP;
		  		alusel_o <= `EXE_RES_ARITHMETIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};		wd_o <= inst_i[20:16];		  	
					instvalid <= `InstValid;	
				end
				`EXE_ADDIU:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_ADDIU_OP;
		  		alusel_o <= `EXE_RES_ARITHMETIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};		wd_o <= inst_i[20:16];		  	
					instvalid <= `InstValid;	
				end

				`EXE_JAL:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_JAL_OP;
		  		alusel_o <= `EXE_RES_JUMP_BRANCH; reg1_read_o <= 1'b0;	reg2_read_o <= 1'b0;
		  		wd_o <= 5'b11111;	
		  		link_addr_o <= pc_plus_8 ;
			    branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
			    branch_flag_o <= `Branch;
			    next_inst_in_delayslot_o <= `InDelaySlot;		  	
			    instvalid <= `InstValid;	
				end
				`EXE_BEQ:			begin
	//beq ָ���Ҫ���淵�ص�ַ���������� wreg_o Ϊ WriteDisable��	
	//���÷��ص�ַ link_addr_o Ϊ 0��aluop_o ����Ĭ��ֵ EXE_NOP_OP��alusel_o ����Ĭ��ֵ EXE RES NOP��?		
		  		wreg_o <= `WriteDisable;		aluop_o <= `EXE_BEQ_OP;
		  		alusel_o <= `EXE_RES_JUMP_BRANCH; 
	//beqָ��������ת�ƣ�ת�Ƶ�����������ͨ�üĴ�����ֵ��ȣ�������Ҫ��ȡ����ͨ�üĴ�����	  		
	//���� reg1_read_o��reg2_read_oΪ1��
	//	��ʾͨ��Regfileģ��Ķ��˿�1�����˿� 2��ȡ�Ĵ�������ȡ�ļĴ�����ַ�ֱ�Ϊָ���е� rs��rt��  		
		  		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  		instvalid <= `InstValid;	
	//�����ȡ������ͨ�üĴ�����ֵ��ȣ��� regl_o ����reg2_o������ôת�Ʒ���������branch_flag_oΪBranch��	  		
	//ͬʱ����ת��Ŀ�ĵ�ַbranch_target_address_0Ϊpc_plus_4 + imm_sll2_signedext;
	//	���⣬��һ��ָ�����ӳٲ�ָ��������� hext_inst_in_delayslot_o Ϊ InDelaySlot��  		
		  		if(reg1_o == reg2_o) begin
			    	branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
			    	branch_flag_o <= `Branch;
			    	next_inst_in_delayslot_o <= `InDelaySlot;		  	
			    end
				end
	
				`EXE_BNE:			begin
				
		  		wreg_o <= `WriteDisable;		aluop_o <= `EXE_BNE_OP;
		  		alusel_o <= `EXE_RES_JUMP_BRANCH; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  		instvalid <= `InstValid;	
		  		if(reg1_o != reg2_o) begin
			    	branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
			    	branch_flag_o <= `Branch;
			    	next_inst_in_delayslot_o <= `InDelaySlot;		  	
			    end
				end
																	  	
		    default:			begin
		    end
		  endcase		  //case op
		  
		  if (inst_i[31:21] == 11'b00000000000) begin
		  	if (op3 == `EXE_SLL) begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_SLL_OP;
		  		alusel_o <= `EXE_RES_SHIFT; reg1_read_o <= 1'b0;	reg2_read_o <= 1'b1;	  	
					imm[4:0] <= inst_i[10:6];		wd_o <= inst_i[15:11];
					instvalid <= `InstValid;	
				end else if ( op3 == `EXE_SRL ) begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_SRL_OP;
		  		alusel_o <= `EXE_RES_SHIFT; reg1_read_o <= 1'b0;	reg2_read_o <= 1'b1;	  	
					imm[4:0] <= inst_i[10:6];		wd_o <= inst_i[15:11];
					instvalid <= `InstValid;	
				end else if ( op3 == `EXE_SRA ) begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_SRA_OP;
		  		alusel_o <= `EXE_RES_SHIFT; reg1_read_o <= 1'b0;	reg2_read_o <= 1'b1;	  	
					imm[4:0] <= inst_i[10:6];		wd_o <= inst_i[15:11];
					instvalid <= `InstValid;	
				end
			end		  
		  
		end       //if
	end         //always
//�������������Դ������1��ֵ�����regl_read_oΪ1����ô�ͽ���Regfleģ����˿�1��ȡ�ļĴ�����ֵ��ΪԴ������1��
//��� regl_read_oΪ0����ô�ͽ���������ΪԴ������ 1������ ori ���ԣ��˴�ѡ���Regfileģ����˿�1��ȡ�ļĴ�����ֵ��ΪԴ������ 1��
//��ֵ��ͨ�� regl_o �˿ڱ����ݵ�ִ�н׶Ρ�	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;		
	  end else if(reg1_read_o == 1'b1) begin// Regfile���˿�1�����ֵ
	  	reg1_o <= reg1_data_i;
	  end else if(reg1_read_o == 1'b0) begin
	  	reg1_o <= imm;//������
	  end else begin
	    reg1_o <= `ZeroWord;
	  end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;			
	  end else if(reg2_read_o == 1'b1) begin
	  	reg2_o <= reg2_data_i;
	  end else if(reg2_read_o == 1'b0) begin
	  	reg2_o <= imm;
	  end else begin
	    reg2_o <= `ZeroWord;
	  end
	end
// ������� is_in_delayslot o��ʾ��ǰ����׶�ָ���Ƿ����ӳٲ�ָ��?
	always @ (*) begin
		if(rst == `RstEnable) begin
			is_in_delayslot_o <= `NotInDelaySlot;
		end else begin
		  is_in_delayslot_o <= is_in_delayslot_i;		
	  end
	end

endmodule