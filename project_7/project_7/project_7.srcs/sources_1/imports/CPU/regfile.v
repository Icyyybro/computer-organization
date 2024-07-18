`timescale 1ns / 1ps

module regfile(
    input wire re1,
    input wire[4:0] raddr1,
    input wire re2,
    input wire[4:0] raddr2,
    input wire[4:0] waddr,
    input wire we,
    input wire[31:0] wdata,
    input wire rst,
    input wire clk,
    output reg[31:0] rdata1,
    output reg[31:0] rdata2
    ); 
    reg[31:0] regs [31:0];
    
    initial begin
        regs[1]=32'h00000002;
        regs[2]=32'h12345678;
        regs[3]=32'h00000001;
        regs[4]=32'h00000002;
        regs[5]=32'h12345678;
        regs[6]=32'h00000001;
        regs[7]=32'h00000002;
        regs[8]=32'h12345678;
        regs[9]=32'h00000001;
        regs[10]=32'h00000002;
        regs[11]=32'h12345678;
        regs[12]=32'h00000001;
        regs[13]=32'h00000002;
        regs[14]=32'h12345678;
        regs[15]=32'h00000001;
        regs[16]=32'h00000002;
        regs[17]=32'h12345678;
        regs[18]=32'h00000001;
        regs[19]=32'h00000002;
        regs[20]=32'h12345678;
        regs[21]=32'h00000001;
        regs[22]=32'h00000002;
        regs[23]=32'h12345678;
        regs[24]=32'h00000001;
        regs[25]=32'h00000002;
        regs[26]=32'h12345678;
        regs[27]=32'h00000001;
        regs[28]=32'h00000002;
        regs[29]=32'h12345678;
        regs[30]=32'h00000001;
        regs[31]=32'h00000002;
    end
    
    always@(posedge clk)begin
        if((rst==0)&&(we==1)&&(waddr!=0))begin
            regs[waddr]<=wdata;
        end
    end
    always@(*)begin
        if(rst==1)begin
            rdata1<=0;
        end else if((rst==0)&&(re1==1)&&(raddr1==0))begin
            rdata1<=0;
        end else if((rst==0)&&(re1==1))begin
            rdata1<=regs[raddr1];
        end else begin
            rdata1<=0;
        end
    end
    always@(*)begin
        if(rst==1)begin
            rdata2<=0;
        end else if((rst==0)&&(re2==1)&&(raddr2==0))begin
            rdata2<=0;
        end else if((rst==0)&&(re2==1))begin
            rdata2<=regs[raddr2];
        end else begin
            rdata2<=0;
        end
    end
endmodule