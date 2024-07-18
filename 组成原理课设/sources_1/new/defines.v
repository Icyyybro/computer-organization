//ȫ��
`define RstEnable 1'b1//��λ�ź���Ч
`define RstDisable 1'b0//��λ�ź���Ч
`define ZeroWord 32'h00000000//32 λ����ֵ 0
`define WriteEnable 1'b1//ʹ��д
`define WriteDisable 1'b0//��ֹд
`define ReadEnable 1'b1//ʹ�ܶ�
`define ReadDisable 1'b0//��ֹ��
`define AluOpBus 7:0//����׶ε���� aluop_o
`define AluSelBus 2:0//����׶ε���� alusel o�Ŀ��
`define InstValid 1'b0//ָ����Ч
`define InstInvalid 1'b1//ָ����Ч
`define Stop 1'b1//��ˮ����ͣ
`define NoStop 1'b0//��ˮ�߼���
`define InDelaySlot 1'b1//���ӳٲ���
`define NotInDelaySlot 1'b0//�����ӳٲ���
`define Branch 1'b1 //��ת
`define NotBranch 1'b0//����ת
`define ChipEnable 1'b1//оƬʹ��
`define ChipDisable 1'b0//оƬ��ֹ
//ָ��
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
//ָ��洢��inst_rom
`define InstAddrBus 31:0//ROM�ĵ�ַ���߿��
`define InstBus 31:0//ROM���������߿��
`define InstMemNum 131071//ROMʵ�ʴ�СΪ128KB
`define InstMemNumLog2 17//ROMʵ��ʹ�õĵ�ַ�߿��
//ͨ�üĴ���regfile
`define RegAddrBus 4:0//Regfile ģ��ĵ�ַ�߿��
`define RegBus 31:0//Regfile ģ��������߿��
`define RegWidth 32//ͨ�üĴ����Ŀ��
`define DoubleRegWidth 64//������ͨ�üĴ����Ŀ��
`define DoubleRegBus 63:0//������ͨ�üĴ����������߿��
`define RegNum 32//ͨ�üĴ���������
`define RegNumLog2 5//Ѱַͨ�üĴ���ʹ�õĵ�ַλ��?
`define NOPRegAddr 5'b00000