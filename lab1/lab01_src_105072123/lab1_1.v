`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 10:25:44
// Design Name: 
// Module Name: lab1_1
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


module lab1_1 (a, b, c, aluctr, d, e);
	input a, b, c;
	input [1:0] aluctr;
	output d, e;

	myxor xor_0 (.out(xor0), .a(a), .b(b));
	myxor xor_1 (.out(xor1), .a(xor0), .b(c));

	and and_0 (and0, a, b);
	and and_1 (and1, b, c);
	and and_2 (and2, a, c);
	and and_3 (and3, a, not0);
	and and_4 (and4, c, not0);
	
	or or_0 (or0, and0, and1, and2);
	or or_1 (or1, and2, and3, and4);
	
	not not_0 (not0, b);
	
	mux4_to_1 mux_0 (.q_o(d), .a_i(xor1), .b_i(and0), .c_i(1'b0), .d_i(xor0), .sel_i(aluctr));
	mux4_to_1 mux_1 (.q_o(e), .a_i(or0), .b_i(1'b0), .c_i(or1), .d_i(1'b0), .sel_i(aluctr));

endmodule

