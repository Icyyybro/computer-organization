//全局
`define RstEnable 1'b1//复位信号有效
`define RstDisable 1'b0//复位信号无效
`define ZeroWord 32'h00000000//32 位的数值 0
`define WriteEnable 1'b1//使能写
`define WriteDisable 1'b0//禁止写
`define ReadEnable 1'b1//使能读
`define ReadDisable 1'b0//禁止读
`define AluOpBus 7:0//译码阶段的输出 aluop_o
`define AluSelBus 2:0//译码阶段的输出 alusel o的宽度
`define InstValid 1'b0//指令有效
`define InstInvalid 1'b1//指令无效
`define Stop 1'b1//流水线暂停
`define NoStop 1'b0//流水线继续
`define InDelaySlot 1'b1//在延迟槽中
`define NotInDelaySlot 1'b0//不在延迟槽中
`define Branch 1'b1 //跳转
`define NotBranch 1'b0//不跳转
`define ChipEnable 1'b1//芯片使能
`define ChipDisable 1'b0//芯片禁止
//指令
`define EXE_AND  6'b100100
`define EXE_OR   6'b100101
`define EXE_XOR 6'b100110
`define EXE_NOR 6'b100111
`define EXE_ANDI 6'b001100
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111
`define EXE_SLL  6'b000000
`define EXE_SRL  6'b000010
`define EXE_SRA  6'b000011
`define EXE_SLT  6'b101010
`define EXE_SLTU  6'b101011
`define EXE_ADD  6'b100000
`define EXE_ADDU  6'b100001
`define EXE_SUB  6'b100010
`define EXE_SUBU  6'b100011
`define EXE_ADDI  6'b001000
`define EXE_ADDIU  6'b001001
`define EXE_JAL  6'b000011
`define EXE_JR  6'b001000
`define EXE_BEQ  6'b000100
`define EXE_BNE  6'b000101
`define EXE_NOP 6'b000000
`define EXE_SPECIAL_INST 6'b000000
//AluOp
`define EXE_OR_OP    8'b00000001
`define EXE_XOR_OP  8'b00000010
`define EXE_NOR_OP  8'b00000011
`define EXE_ANDI_OP  8'b0000100
`define EXE_LUI_OP  8'b00000101   
`define EXE_SLL_OP  8'b00000110
`define EXE_SRL_OP  8'b00000111
`define EXE_SRA_OP  8'b00001000
`define EXE_SLT_OP  8'b00001001
`define EXE_SLTU_OP  8'b00001010
`define EXE_ADD_OP  8'b00001011
`define EXE_ADDU_OP  8'b00001100
`define EXE_SUB_OP  8'b00001101
`define EXE_SUBU_OP  8'b00001110
`define EXE_ADDI_OP  8'b00001111
`define EXE_ADDIU_OP  8'b00010000
`define EXE_JAL_OP  8'b00010001
`define EXE_JR_OP  8'b00010010
`define EXE_BEQ_OP  8'b00010011
`define EXE_BNE_OP  8'b00010100
`define EXE_AND_OP   8'b00010101
`define EXE_NOP_OP    8'b00000000
//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010	
`define EXE_RES_ARITHMETIC 3'b011	
`define EXE_RES_JUMP_BRANCH 3'b101
`define EXE_RES_NOP 3'b000
//指令存储器inst_rom
`define InstAddrBus 31:0//ROM的地址总线宽度
`define InstBus 31:0//ROM的数据总线宽度
`define InstMemNum 131071//ROM实际大小为128KB
`define InstMemNumLog2 17//ROM实际使用的地址线宽度
//通用寄存器regfile
`define RegAddrBus 4:0//Regfile 模块的地址线宽度
`define RegBus 31:0//Regfile 模块的数据线宽度
`define RegWidth 32//通用寄存器的宽度
`define DoubleRegWidth 64//两倍的通用寄存器的宽度
`define DoubleRegBus 63:0//两倍的通用寄存器的数据线宽度
`define RegNum 32//通用寄存器的数量
`define RegNumLog2 5//寻址通用寄存器使用的地址位数?
`define NOPRegAddr 5'b00000