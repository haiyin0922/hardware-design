`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/06 19:39:52
// Design Name: 
// Module Name: lab3_1
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

parameter n = 26;
input clk;
output clk_div;

reg [n-1:0] num;
wire [n-1:0] next_num;

always@(posedge clk)begin
    num <= next_num; 
end

assign next_num = num + 1'b1;
assign clk_div = num[n-1];
 
endmodule


module lab3_1(clk, rst_n, en, dir, led);
    input clk;
    input rst_n;
    input en;
    input dir;
    output[15:0] led;
    
    reg[3:0] n, next_n;
    reg[15:0] led;
    
    clock_divider divider(.clk(clk), .clk_div(clk26));
    
always@(posedge clk26 or negedge rst_n)begin
    led[15:0] = 16'd0;
    if(!rst_n)begin
        n <= 4'd15;
        led[15] <= 1'd1;
        led[14:0] <= 15'd0;        
    end
    else begin
        n <= next_n;
        led[next_n] <= 1'b1;
    end
end
    
always@(*)begin
    if(en && dir)begin
        next_n = (n == 4'd0)? 4'd15 : n - 1'b1;
    end
    else if(en && !dir)begin
        next_n = (n == 4'd15)? 4'd0 : n + 1'b1;
    end
    else begin
        next_n = n;
    end
end
 
endmodule