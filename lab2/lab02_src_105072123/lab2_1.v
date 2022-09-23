`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/01 19:49:31
// Design Name: 
// Module Name: lab2_1
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

module lab2_1(clk, rst_n, en, dir, out);

input clk, rst_n, en, dir;
output [3:0] out; 

reg [3:0] out, next_out;
 
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        out <= 4'h0;
    end
    else begin
        out <= next_out;
    end
end

always@(*)begin
    if(en && dir && out != 4'hf)begin
        next_out = out + 1'b1;
    end
    else if(en && !dir && out != 4'h0)begin
        next_out = out - 1'b1;   
    end
    else begin
        next_out = out;
    end
end

endmodule