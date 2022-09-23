`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 01:53:28
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(clk, clk_div);

		parameter n = 13;
		input clk;
		output clk_div;


		reg [n-1:0] num;
		wire [n-1:0] next_num;
		
		always @ (posedge clk)begin
				num <=next_num;
	    end
        
		assign next_num = num +1;
		assign clk_div = num[n-1];
		
endmodule
