`timescale 1ns / 1ps

module decoder_5_32(
    input wire[4:0] in,
    output wire[31:0] out
    );
    genvar i;
    generate
        for(i=0;i<32;i=i+1)
            begin:test
                assign out[i]=(in==i);    
            end
    endgenerate            
endmodule
