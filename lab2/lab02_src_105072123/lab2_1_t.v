`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/30 14:28:17
// Design Name: 
// Module Name: lab2_1_t
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


module lab2_1_t ();

reg clk, rst_n, en, dir;
wire [3:0] out;

lab2_1 counter (.clk(clk), .rst_n(rst_n), .en(en), .dir(dir), .out(out));

always begin
#5 clk = ~clk;
end

initial begin
clk = 1'b0;
rst_n = 1'b1;
en = 1'b0;
dir = 1'b0;
#10
//when rst_n = 1'b0, out = 4'b0000 
rst_n = 1'b0;
#10
dir = 1'b1;
#10
en = 1'b1;
dir = 1'b0;
#10
dir = 1'b1;

//when en = 1'b0, out must hold
#10
rst_n = 1'b1;
en = 1'b0;
dir = 1'b0;
#10
dir = 1'b1;

//when dir = 1'b1, out must +1
#10
en = 1'b1;

//when dir = 1'b0, out must -1
#10
dir = 1'b0;

 // +1 until out = 4'b1111
#10
dir = 1'b1;
#200

 // -1 until out = 4'b0000
#10
dir = 1'b0;
#200

$finish;
end

endmodule