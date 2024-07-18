`timescale 1ns / 1ps

module add_tb(

    );
    reg[3:0] src1;
    reg[3:0] src2;
    wire[3:0] r1;
    wire[4:0] r2;
    wire[3:0] r3;
    wire[4:0] r4;
    wire ov1;
    wire ov2;
    add add0(src1,src2,r1,r2,r3,r4,ov1,ov2);
    initial begin
        
    end
endmodule
