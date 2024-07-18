
// 执行阶段
// 依据译码阶段的结果，进行指定的运算，给出运算结果。
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(

	input wire rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]     aluop_i,//执行阶段要进行的运算的类型
	input wire[`AluSelBus]   alusel_i,//执行阶段要进行的运算的子类型
	input wire[`RegBus]      reg1_i,//参与运算的源操作数1
	input wire[`RegBus]   reg2_i,//参与运算的源操作数 2?
	input wire[`RegAddrBus]    wd_i,//指令执行要写入的目的寄存器地址
	input wire        wreg_i,//是否有要写入的目的寄存器


	//是否转移、以及link address
	input wire[`RegBus]    link_address_i,//处于执行阶段的转移指令要保存的返回地址
	input wire      is_in_delayslot_i,	//当前处于执行阶段的指令是否位于延迟槽
	
	output reg[`RegAddrBus] wd_o,//执行阶段的指令最终要写入的目的寄存器地址
	output reg  wreg_o,//执行阶段的指令最终是否有要写入的目的寄存器
	output reg[`RegBus] wdata_o,//执行阶段的指令最终要写入目的寄存器的值
	output reg stallreq       			
	
);

	reg[`RegBus] logicout;//保存逻辑运算结果
	reg[`RegBus] shiftres;//保存逻辑运算结果
	reg[`RegBus] arithmeticres;//保存算术运算的结果


	wire[`RegBus] reg2_i_mux;//保存输入的第二个操作数 reg2_i的补码
	wire[`RegBus] reg1_i_not;	//保存输入的第一个操作数reg1_i取反后的值
	wire[`RegBus] result_sum;//保存加法结果
	wire ov_sum;//保存溢出情况?
	wire reg1_eq_reg2;//第一个操作数是否等于第二个操作数
	wire reg1_lt_reg2;//第一个操作数是否小于第二个操作数
	
	//依据 aluop i指示的运算子类型进行运算,
	//运算结果保存在 logicout中，这个变量专门用来保存逻辑操作的结果		
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;//逻辑或运算
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_i & reg2_i;//逻辑与运算
				end
				`EXE_NOR_OP:		begin
					logicout <= ~(reg1_i |reg2_i);//逻辑或非运算
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_i ^ reg2_i;//逻辑异或运算
				end
				default:				begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always
//给出最终的运算结果，包括是否要写目的寄存器 wreg_o、要写的目的寄存器地址 wd_o、要写入的数据 wdata_o
//其中 wreg_o、wd_o的值都直接来自译码阶段，不需要改变，wdata_o的值要依据运算类型进行选择，
//如果是逻辑运算，那么将logicout的值赋给 wdata_o。
	always @ (*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP:			begin
					shiftres <= reg2_i << reg1_i[4:0] ;//逻辑左移
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg2_i >> reg1_i[4:0];//逻辑右移
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
												| reg2_i >> reg1_i[4:0];//算术右移
				end
				default:				begin
					shiftres <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	
    //分三种情况∶
    //A.如果是加法运算，此时 reg2_i_mux 就是第二个操作数reg2_i，所以 result_sum 就是加法运算的结果
    //B．如果是减法运算，此时reg2_i_mux 是第二个操作数reg2_i的补码，所以 result sum 就是减法运算的结果
    //c.如果是有符号比较运算，此时 reg2 i mux也是第二个操作数 reg2 i的补码，所以result_sum也是减法运算的结果，
    //可以通过判断减法的结果是否小于零，进而判断第一个操作数 reg1_i 是否小于第二个操作数 reg2_i
    assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SUBU_OP) ||
											 (aluop_i == `EXE_SLT_OP) ) 
											 ? (~reg2_i)+1 : reg2_i;
	assign result_sum = reg1_i + reg2_i_mux;										 
//计算是否溢出 加法指令（add和addi）、减法指令（sub）执行的时候，
//需要判断是否溢出，满足以下两种情况之一时，有溢出∶
// A．reg1_i 为正数，reg2_i_mux为正数，但是两者之和为负数 
//B．reg1 i为负数，reg2 i mux为负数，但是两者之和为正数

	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
									((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));  

//计算操作数1是否小于操作数2，分两种情况∶
//A. aluop_i为EXE SLT OP表示有符号比较运算，此时又分 3种情况 
//A1。rea1，i为负数、reg2_i为正数，显然regl_i小于reg2_i
//A2.reg1_i为正数、reg2_i为正数，并且reg1_i减去reg2_i的值小于0?（即 result_sum为负），此时也有reg1_i小于reg2_i								
//A3．regl_i为负数、reg2_i为负数，并且reg1_i减去 reg2_i的值小于 0?（即 result_sum为负），此时也有 reg1_i小于 reg2_i?
//	B、无符号数比较的时候，直接使用比较运算符比较 reg1_i与reg2_i
	
	assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
												 ((reg1_i[31] && !reg2_i[31]) || 
												 (!reg1_i[31] && !reg2_i[31] && result_sum[31])||
			                   (reg1_i[31] && reg2_i[31] && result_sum[31]))
			                   :	(reg1_i < reg2_i);
 //对操作数1逐位取反，赋给 reg1_i_not 
  assign reg1_i_not = ~reg1_i;
	
	
	//	依据不同的算术运算类型，给 arithmeticres 变量赋值					
	always @ (*) begin
		if(rst == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end else begin
			case (aluop_i)// aluop_i就是运算类型?
				`EXE_SLT_OP, `EXE_SLTU_OP:		begin
					arithmeticres <= reg1_lt_reg2 ;//比较运算
				end
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP:		begin
					arithmeticres <= result_sum; //加法运算
				end
				`EXE_SUB_OP, `EXE_SUBU_OP:		begin
					arithmeticres <= result_sum; //减法运算
				end		
			
				default:				begin
					arithmeticres <= `ZeroWord;
				end
			endcase
		end
	end


//确定要写入目的寄存器的数据	
 always @ (*) begin
	 wd_o <= wd_i;
	 	// 	 如果是 add、addi、sub、subi指令，且发生溢出，
	 	//那么设置wreg_o为 WriteDisable，表示不写目的寄存器?	
	 if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) || 
	      (aluop_i == `EXE_SUB_OP)) && (ov_sum == 1'b1)) begin
	 	wreg_o <= `WriteDisable;
	 end else begin
	  wreg_o <= wreg_i;
	 end
	 // 依据alusel i选择最终的运算结果
	 case ( alusel_i ) 
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;//选择逻辑运算结果为最终运算结果?
	 	end
	 	`EXE_RES_SHIFT:		begin
	 		wdata_o <= shiftres;//选择移位运算结果为最终运算结果?
	 	end	 		
	 	`EXE_RES_ARITHMETIC:	begin
	 		wdata_o <= arithmeticres;
	 	end

	 	//如果 alusel_o为EXE_RES_JUMP_BRANCH，
	 	//那么就将返回地址 link_addressi作为要写入目的寄存器的值赋给 wdata_o。?
	 	`EXE_RES_JUMP_BRANCH:	begin
	 		wdata_o <= link_address_i;
	 	end	 	
	 	default:					begin
	 		wdata_o <= `ZeroWord;
	 	end
	 endcase
 end	

	

endmodule