`timescale 1ns / 1ps

module inst_rom(
    input wire ce,
    input wire[31:0] addr,//0-2(32)-1  byte    0-2(30)-1 4byte
    output reg[31:0] inst
    );
    
    reg[31:0] rom[127:0];
    initial begin
        $readmemh("D:/fpga_data/rom.data",rom);
    end
    always@(*)begin
        if(ce==0)begin
            inst=32'd0;
        end else begin
            inst=rom[addr[31:2]];
        end
    end
endmodule
