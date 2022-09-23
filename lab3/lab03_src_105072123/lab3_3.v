`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/08 02:07:40
// Design Name: 
// Module Name: lab3_3
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


module lab3_3(clk, rst_n, clkDiv7);

    input clk;
    input rst_n;
    output clkDiv7;

    reg [3:0] num, next_num;
 
always@(posedge clk or negedge clk or negedge rst_n)begin
    if(!rst_n)begin
        num <= 1'b0;
    end
    else begin
        num <= next_num;
    end
 end

always@(*)begin
    next_num = (num == 4'd14)? 4'd1 : num + 1'b1;
end
 
assign clkDiv7 = (num >= 4'd8)? 1'b1 : 1'b0;

endmodule