`timescale 1ns / 1ps
module id(
    input wire rst,
    input wire[31:0] inst_i,
    input wire[31:0] reg1_data_i,
    input wire[31:0] reg2_data_i,
    output wire reg1_read_o,
    output wire[4:0] reg1_addr_o,
    output wire reg2_read_o,
    output wire[4:0] reg2_addr_o,
    output wire wreg_o,
    output wire [4:0] wd_o,
    output wire[31:0] reg1_o,
    output wire[31:0] reg2_o,
    output wire[3:0] aluop_o
    );
    wire[5:0] op;
    wire[63:0] op_d;
    wire[4:0] op1;
    wire[31:0] op1_d;
    wire[4:0] sa;
    wire[31:0] sa_d;
    wire[5:0]func;
    wire[63:0]func_d;
    assign op=inst_i[31:26];
    assign op1=inst_i[25:21];
    assign sa=inst_i[10:6];
    assign func=inst_i[5:0];
    decoder_6_64 dec0(op,op_d);
    decoder_5_32 dec1(op1,op1_d);
    decoder_5_32 dec2(sa,sa_d);
    decoder_6_64 dec3(func,func_d);
    wire inst_add;
    wire inst_addu;
    wire inst_sub;
    wire inst_subu;
    wire inst_slt;
    wire inst_sltu;
    wire inst_and;
    wire inst_or;
    wire inst_xor;
    wire inst_nor;
    wire inst_sll;
    wire inst_srl;
    wire inst_sra;
    wire inst_lui;
    assign inst_add=op_d[0]&&sa_d[0]&&func_d[6'b100000];
    assign inst_addu=op_d[0]&&sa_d[0]&&func_d[6'b100001];
    assign inst_sub=op_d[0]&&sa_d[0]&&func_d[6'b100010];
    assign inst_subu=op_d[0]&&sa_d[0]&&func_d[6'b100011];
    assign inst_slt=op_d[0]&&sa_d[0]&&func_d[6'b101010];
    assign inst_sltu=op_d[0]&&sa_d[0]&&func_d[6'b101011];
    assign inst_and=op_d[0]&&sa_d[0]&&func_d[6'b100100];
    assign inst_or=op_d[0]&&sa_d[0]&&func_d[6'b100101];
    assign inst_xor=op_d[0]&&sa_d[0]&&func_d[6'b100110];
    assign inst_nor=op_d[0]&&sa_d[0]&&func_d[6'b100111];
    assign inst_sll=op_d[0]&&op1_d[0]&&func_d[0];
    assign inst_srl=op_d[0]&&op1_d[0]&&func_d[6'b000010];
    assign inst_sra=op_d[0]&&op1_d[0]&&func_d[6'b000011];
    assign inst_lui=op_d[6'b001111]&&op1_d[0];
//    assign aluop_o={
//                    inst_add,
//                    inst_addu,
//                    inst_sub,
//                    inst_subu,
//                    inst_slt,
//                    inst_sltu,
//                    inst_and,
//                    inst_or,
//                    inst_xor,
//                    inst_nor,
//                    inst_sll,
//                    inst_srl,
//                    inst_sra,
//                    inst_lui};
    wire [15:0] inst_op;
    assign inst_op={0,0,
                    inst_add,
                    inst_addu,
                    inst_sub,
                    inst_subu,
                    inst_slt,
                    inst_sltu,
                    inst_and,
                    inst_or,
                    inst_xor,
                    inst_nor,
                    inst_sll,
                    inst_srl,
                    inst_sra,
                    inst_lui};
      encoder_16_4 enc0(inst_op,aluop_o);
      assign reg1_read_o=(rst==1)?0:!(inst_sll||inst_srl||inst_sra||inst_lui);
      assign reg2_read_o=(rst==1)?0:!(inst_lui);
      assign wreg_o=(rst==1)?0:1;
      assign reg1_addr_o=(rst==1)?0:inst_i[25:21];
      assign reg2_addr_o=(rst==1)?0:inst_i[20:16];
      assign wd_o=(rst==1)?0:(inst_lui?inst_i[20:16]:inst_i[15:11]);
      wire[31:0] imm;
      assign imm=inst_lui?{inst_i[15:0],16'b0}:{27'b0,inst_i[10:6]};
      assign reg1_o=(rst==1)?0:(reg1_read_o?reg1_data_i:imm);
      assign reg2_o=(rst==1)?0:(reg2_read_o?reg2_data_i:imm);
endmodule
