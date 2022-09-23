`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 12:33:49
// Design Name: 
// Module Name: lab1_2
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


module lab1_2 (a, b, c, aluctr, d, e);
	input a, b, c;
	input [1:0] aluctr;
	output d, e;

	assign d = aluctr[1]? (aluctr[0]? a ^ b : 1'b0) : (aluctr[0]? a & b : a ^ b ^ c);
	assign e = aluctr[1]? (aluctr[0]? 1'b0 : a & c | a & ~b | c & ~b) : (aluctr[0]? 1'b0 : a & b | b & c | a & c);

endmodule

