`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/01 16:20:53
// Design Name: 
// Module Name: lab2_3_t
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

module lab2_3_t ();

reg clk, rst_n;
wire out;

lab2_3 test(.clk(clk), .rst_n(rst_n), .out(out));

always begin
#5 clk = ~clk;
end

initial begin
clk = 1'b0;
rst_n = 1'b1;
#10
rst_n = 1'b0;
#10
rst_n = 1'b1;
#100
rst_n = 1'b0;
#10
rst_n = 1'b1;
#300

$finish;
end

endmodule