`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/08 02:09:08
// Design Name: 
// Module Name: lab3_3_t
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


module lab3_3_t();

reg clk, rst_n;
wire clkDiv7;

lab3_3 test(.clk(clk), .rst_n(rst_n), .clkDiv7(clkDiv7));

always begin
#5 clk = ~clk;
end

initial begin
clk = 1'b0;
rst_n = 1'b1;
#8
rst_n = 1'b0;
#5
rst_n = 1'b1;
#300
rst_n = 1'b0;
#3
rst_n = 1'b1;
#300

$finish;
end

endmodule