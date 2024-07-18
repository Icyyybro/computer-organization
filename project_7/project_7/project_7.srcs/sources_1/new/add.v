`timescale 1ns / 1ps

module add(
    input wire[3:0] src1,
    input wire[3:0] src2,
    output wire[3:0] r1,
    output wire[4:0] r2,
    output wire[3:0] r3,
    output wire[4:0] r4,
    output wire ov1,
    output wire ov2
    );
    
    assign r1=src1+src2;
    assign r2=src1+src2;
    assign r3=src1-src2;
    assign r4=src1-src2;
endmodule
