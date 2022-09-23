`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 12:58:08
// Design Name: 
// Module Name: lab1_3
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


module lab1_3 (a, b, c, aluctr, d, e);
	input a, b, c;
	input [1:0] aluctr;
	output d, e;
	
	reg d, e;

	always@(*)begin
	  case(aluctr)
		2'b00: begin
			d = a ^ b ^ c;
			e = a & b | b & c | a & c;
		end
		2'b01: begin
			d = a & b;
			e = 1'b0;
		end
		2'b10: begin
			d = 1'b0;
			e = a & c | a & ~b | c & ~b;
		end
		2'b11: begin
			d = a ^ b;
			e = 1'b0;
		end
	  endcase
	end
endmodule

