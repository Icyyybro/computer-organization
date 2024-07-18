// 译码阶段
// 对指令进行译码，译码结果包括运算类型、运算所需的源操作数、要写入的目的寄存器地址等
//////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "defines.v"
module id(
	input wire rst,
	input wire[`InstAddrBus] pc_i,//译码阶段的指令对应的地址
	input wire[`InstBus] inst_i,//译码阶段的指令

	input wire[`RegBus] reg1_data_i,//从 Regfile 输入的第一个读寄存器端口的输入
	input wire[`RegBus] reg2_data_i,//从 Regfile 输入的第二个读寄存器端口的输入

	//如果上一条指令是转移指令，那么下一条指令在译码的时候is_in_delayslot为true
	input wire                    is_in_delayslot_i,//当前处于译码阶段的指令是否位于延迟槽

	//送到regfile的信息
	output reg                    reg1_read_o,//Regfile 模块的第一个读寄存器端口的读使能信号
	output reg                    reg2_read_o,//Regfile 模块的第二个读寄存器端口的读使能信号     
	output reg[`RegAddrBus]       reg1_addr_o,//Regfile模块的第一个读寄存器端口的读地址信号
	output reg[`RegAddrBus]       reg2_addr_o,//Regfile 模块的第二个读寄存器端口的读地址信号 	      
	
	//送到执行阶段的信息
	output reg[`AluOpBus]         aluop_o,//译码阶段的指令要进行的运算的子类型
	output reg[`AluSelBus]        alusel_o,//译码阶段的指令要进行的运算的类型
	output reg[`RegBus]           reg1_o,//译码阶段的指令要进行的运算的源操作数1
	output reg[`RegBus]           reg2_o,//译码阶段的指令要进行的运算的源操作数2
	output reg[`RegAddrBus]       wd_o,//译码阶段的指令要写入的目的寄存器地址
	output reg                    wreg_o,//译码阶段的指令是否有要写入的目的寄存器

	output reg                    next_inst_in_delayslot_o,//下一条进入译码阶段的指令是否位于延迟槽?
	
	output reg                    branch_flag_o,//是否发生转移
	output reg[`RegBus]           branch_target_address_o, //转移到的目标地址      
	output reg[`RegBus]           link_addr_o,//转移指令要保存的返回地址
	output reg                    is_in_delayslot_o,//当前处于译码阶段的指令是否位于延迟槽?
	
	output wire                   stallreq	//
);
//取得指令的指令码，功能码
  wire[5:0] op = inst_i[31:26];//指令码
  wire[4:0] op2 = inst_i[10:6];
  wire[5:0] op3 = inst_i[5:0];//功能码
  wire[4:0] op4 = inst_i[20:16];
  reg[`RegBus]	imm;//保存指令执行需要的立即数
  reg instvalid;//指示指令是否有效
  wire[`RegBus] pc_plus_8;
  wire[`RegBus] pc_plus_4;
  wire[`RegBus] imm_sll2_signedext;  
  
  assign pc_plus_8 = pc_i + 8;//保存当前译码阶段指令后面第 2 条指令的地址
  assign pc_plus_4 = pc_i +4;//保存当前译码阶段指令后面紧接着的指令的地址
 // imm_sll2_signedext 对应分支指令中的offset 左移两位，再符号扩展至 32 位的值 
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
			wd_o <= inst_i[15:11];//默认目的寄存器地址wd_o?
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];//默认通过Regfile读端口1读取的寄存器地址
			reg2_addr_o <= inst_i[20:16];//默认通过Regfile读端口2读取的寄存器地址	
			imm <= `ZeroWord;
			link_addr_o <= `ZeroWord;
			branch_target_address_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;	
			next_inst_in_delayslot_o <= `NotInDelaySlot; 		
	//首先依据指令码 op 进行判断，如果是 SPECIAL 类指令，
	//再判断指令的第 6～10bit（即 op2）是否为 0，如果为0，
	//那么再依据功能码 op3的值，进行最终判断，确定指令类型。
	//如果指令码 op 不为 SPECIAL，那么就直接依据指令码 op 的值进行判断。					
		  case (op)//依据op的值判断指令
		    `EXE_SPECIAL_INST:		begin//指令码是 SPECIAL?
		    	case (op2)
		    		5'b00000:			begin
		    			case (op3)//依据功能码判断是哪种指令?
		    				`EXE_OR:	begin
		    					wreg_o <= `WriteEnable;//wreg_o表示是否要写目的寄存器，指令需要将结果写入目的寄存器，所以wreg_o为WriteEnable
		    					aluop_o <= `EXE_OR_OP;//aluop_o 给出要执行的运算子类型，运算的子类型是逻辑"或"运算
		  						alusel_o <= `EXE_RES_LOGIC; //alusel_o 给出要执行的运算类型，运算类型是逻辑运算
		  						reg1_read_o <= 1'b1;//值为1表示需要通过 Regfile的读端口1读取寄存器	
		  						reg2_read_o <= 1'b1;
		  						instvalid <= `InstValid;	
								end  
								
		    				`EXE_AND:	begin
		    				//and 指令需要将结果写入目的寄存器，所以设置 wreg_o 为 WriteEnable
		    					wreg_o <= `WriteEnable;	
		    				//and 指令要进行的是逻辑"与"操作，所以设置 alusel_o 为 EXE_RES_LOGIC，设置 aluop_o为 EXE_AND_OP。		
		    					aluop_o <= `EXE_AND_OP;
		  						alusel_o <= `EXE_RES_LOGIC;	 
		  						//and指令需要读取 rs、rt 寄存器的值，所以设置 regl_read_o、 reg2_read_o为1
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
							//add 指令是算术运算中的加法操作，所以此处将 alusel_o 赋值为 EXE_RES_ARITHMETIC，aluop_o 赋值为 EXE_ADD_OP。			
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
		//jr指令不需要保存返回地址，所以设置 wreg_o 为WriteDisable,设置返回地址 link_addr_o为0	
		//aluop_o保持默认值 EXE_NOP_OP，alusel_o 保持默认值 EXE_RES_NOP。					
									wreg_o <= `WriteDisable;		aluop_o <= `EXE_JR_OP;
		  						alusel_o <= `EXE_RES_JUMP_BRANCH;   
		//jr 指令要转移到的目标地址是通用寄存器 rs的值，所以需要设置 reg1_read_o为1，
		//表示通过Regfile 模块的读端口1读取寄存器，读取的寄存器地址正是指令中的 rs，
		// 所以最终译码阶段的输出 reg1_o 就是地址为 rs 的寄存器的值。 						
		  						reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;
		  						link_addr_o <= `ZeroWord;
		// 设置转移目标地址 branch_target_address_o为 regl_o，也即是读取出来的通用寄存器 rs 的值。 						
			            	branch_target_address_o <= reg1_o;
		//jr 指令是绝对转移，所以设置 branch_flag_o 为 Branch。
			            	branch_flag_o <= `Branch;
		//下一条指令是延迟槽指令，所以设置 next_inst_in_delayslot_o为 InDelaySlot。	           
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
		  	// andi 指令只需要读取 rs 寄存器的值，所以设置 regl_read_o为1、reg2_reado为0	
		  		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {16'h0, inst_i[15:0]};//指令执行需要的立即数	
					wd_o <= inst_i[20:16];	//指令执行要写的目的寄存器地址?	  	
					instvalid <= `InstValid;//表示有效指令	
				end	 	
	
		  	`EXE_LUI:			begin
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_OR_OP;
		  		alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {inst_i[15:0], 16'h0};		wd_o <= inst_i[20:16];//设置 wd_o 为要写入的目的寄存器地址		  	
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
	//beq 指令不需要保存返回地址，所以设置 wreg_o 为 WriteDisable，	
	//设置返回地址 link_addr_o 为 0，aluop_o 保持默认值 EXE_NOP_OP，alusel_o 保持默认值 EXE RES NOP。?		
		  		wreg_o <= `WriteDisable;		aluop_o <= `EXE_BEQ_OP;
		  		alusel_o <= `EXE_RES_JUMP_BRANCH; 
	//beq指令是条件转移，转移的条件是两个通用寄存器的值相等，所以需要读取两个通用寄存器，	  		
	//设置 reg1_read_o、reg2_read_o为1，
	//	表示通过Regfile模块的读端口1、读端口 2读取寄存器，读取的寄存器地址分别为指令中的 rs、rt。  		
		  		reg1_read_o <= 1'b1;	reg2_read_o <= 1'b1;
		  		instvalid <= `InstValid;	
	//如果读取的两个通用寄存器的值相等（即 regl_o 等于reg2_o），那么转移发生，设置branch_flag_o为Branch，	  		
	//同时设置转移目的地址branch_target_address_0为pc_plus_4 + imm_sll2_signedext;
	//	此外，下一条指令是延迟槽指令，所以设置 hext_inst_in_delayslot_o 为 InDelaySlot。  		
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
//给出参与运算的源操作数1的值，如果regl_read_o为1，那么就将从Regfle模块读端口1读取的寄存器的值作为源操作数1，
//如果 regl_read_o为0，那么就将立即数作为源操作数 1，对于 ori 而言，此处选择从Regfile模块读端口1读取的寄存器的值作为源操作数 1。
//该值将通过 regl_o 端口被传递到执行阶段。	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;		
	  end else if(reg1_read_o == 1'b1) begin// Regfile读端口1的输出值
	  	reg1_o <= reg1_data_i;
	  end else if(reg1_read_o == 1'b0) begin
	  	reg1_o <= imm;//立即数
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
// 输出变量 is_in_delayslot o表示当前译码阶段指令是否是延迟槽指令?
	always @ (*) begin
		if(rst == `RstEnable) begin
			is_in_delayslot_o <= `NotInDelaySlot;
		end else begin
		  is_in_delayslot_o <= is_in_delayslot_i;		
	  end
	end

endmodule