`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/26 19:46:23
// Design Name: 
// Module Name: PlayerCtrl
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
module PlayerCtrl (
	input clk,
	input reset,
	output reg [8:0] ibeat
);
parameter BEATLEAGTH = 127;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 0;
	else begin
	    if(ibeat < BEATLEAGTH) begin
               ibeat <= ibeat + 1;
        end
        else if (ibeat == BEATLEAGTH)begin
            ibeat <= ibeat;
        end
		else ibeat <= 0;
	end
end

endmodule