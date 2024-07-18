`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 15:33:11
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 15:21:47
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input wire rst,
    input wire clk,
    input wire[4:0] waddr,
    input wire[31:0] wdata,
    input wire we,
    input wire[4:0] raddr1,
    input wire re1,
    output reg[31:0] rdata1,
    input wire[4:0] raddr2,
    input wire re2,
    output reg[31:0] rdata2
    );
    reg [31:0] regs[31:0];
    initial begin
        regs[0]=32'h12345678;
        regs[1]=32'h12345678;
        regs[2]=32'h12345678;
        regs[3]=32'h12345678;
        regs[4]=32'h12345678;
        regs[5]=32'h12345678;
        regs[6]=32'h12345678;
        regs[7]=32'h12345678;
        regs[8]=32'h12345678;
        regs[9]=32'h12345678;
        regs[10]=32'h12345671;
        regs[11]=32'h12345672;
        regs[12]=32'h12345673;
        regs[13]=32'h12345678;
        regs[14]=32'h12345678;
        regs[15]=32'h12345678;
        regs[16]=32'h12345678;
        regs[17]=32'h12345677;
        regs[18]=32'h12345678;
        regs[19]=32'h12345679;
        regs[20]=32'h12345678;
        regs[21]=32'h12345678;
        regs[22]=32'h12345678;
        regs[23]=32'h12345678;
        regs[24]=32'h12345678;
        regs[25]=32'h12345678;
        regs[26]=32'h12345678;
        regs[27]=32'h12345678;
        regs[28]=32'h12345678;
        regs[29]=32'h12345678;
        regs[30]=32'h12345678;
        regs[31]=32'h12345678;
    end
    always@(posedge clk)begin
        if(rst==0) begin
           if((we==1)&&(waddr!=0)) begin
                regs[waddr]<=wdata;
            end
        end
    end
    
    always@(*)begin
        if(rst==1)begin
            rdata1<=32'h0;
        end else if ((re1==1)&&(raddr1==0)) begin
            rdata1<=32'h0;
        end else if ((re1==1)&&(raddr1==waddr)&&(we==1)) begin
            rdata1<=wdata;
        end else if (re1==1) begin
            rdata1<=regs[raddr1];
        end else begin
            rdata1<=32'h0;
        end
    end
    
    always@(*)begin
    if(rst==1) begin
        rdata2<=32'h0;
    end else if ((re2==1)&&(raddr2==0)) begin
        rdata2<=32'h0;
    end else if((re2==1)&&(raddr2==waddr)&&(we==1)) begin
        rdata2<=wdata;
    end else if(re2==1) begin
        rdata2<=regs[raddr2];
    end else begin
        rdata2<=32'h0;
    end
end
endmodule


