`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 17:00:55
// Design Name: 
// Module Name: decoder_6_64
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


module decoder_6_64(
        input[5:0] in,
        output[63:0]out
    );
    assign out[0]=(in==6'd0);
    assign out[1]=(in==6'd1);
    assign out[2]=(in==6'd2);
    assign out[3]=(in==6'd3);
    assign out[4]=(in==6'd4);
    assign out[5]=(in==6'd5);
    assign out[6]=(in==6'd6);
    assign out[7]=(in==6'd7);
    assign out[8]=(in==6'd8);
    assign out[9]=(in==6'd9);
    assign out[10]=(in==6'd10);
    assign out[11]=(in==6'd11);
    assign out[12]=(in==6'd12);
    assign out[13]=(in==6'd13);
    assign out[14]=(in==6'd14);
    assign out[15]=(in==6'd15);
    assign out[16]=(in==6'd16);
    assign out[17]=(in==6'd17);
    assign out[18]=(in==6'd18);
    assign out[19]=(in==6'd19);
    assign out[20]=(in==6'd20);
    assign out[21]=(in==6'd21);
    assign out[22]=(in==6'd22);
    assign out[23]=(in==6'd23);
    assign out[24]=(in==6'd24);
    assign out[25]=(in==6'd25);
    assign out[26]=(in==6'd26);
    assign out[27]=(in==6'd27);
    assign out[28]=(in==6'd28);
    assign out[29]=(in==6'd29);
    assign out[30]=(in==6'd30);
    assign out[31]=(in==6'd31);
    assign out[32]=(in==6'd32);
    assign out[33]=(in==6'd33);
    assign out[34]=(in==6'd34);
    assign out[35]=(in==6'd35);
    assign out[36]=(in==6'd36);
    assign out[37]=(in==6'd37);
    assign out[38]=(in==6'd38);
    assign out[39]=(in==6'd39);
    assign out[40]=(in==6'd40);
    assign out[41]=(in==6'd41);
    assign out[42]=(in==6'd42);
    assign out[43]=(in==6'd43);
    assign out[44]=(in==6'd44);
    assign out[45]=(in==6'd45);
    assign out[46]=(in==6'd46);
    assign out[47]=(in==6'd47);
    assign out[48]=(in==6'd48);
    assign out[49]=(in==6'd49);
    assign out[50]=(in==6'd50);
    assign out[51]=(in==6'd51);
    assign out[52]=(in==6'd52);
    assign out[53]=(in==6'd53);
    assign out[54]=(in==6'd54);
    assign out[55]=(in==6'd55);
    assign out[56]=(in==6'd56);
    assign out[57]=(in==6'd57);
    assign out[58]=(in==6'd58);
    assign out[59]=(in==6'd59);
    assign out[60]=(in==6'd60);
    assign out[61]=(in==6'd61);
    assign out[62]=(in==6'd62);
    assign out[63]=(in==6'd63);
endmodule
