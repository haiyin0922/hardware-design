`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/01 20:53:17
// Design Name: 
// Module Name: lab2_3
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


module lab2_3(clk, rst_n, out);

input clk, rst_n;
output out;

reg [4:0]F, next_F;
reg out;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        F <= 5'b00001;
        out <= 1'b0;
    end
    else begin
        out <= F[4];
        F[0] <= next_F[0];
        F[1] <= next_F[1];
        F[2] <= next_F[2];
        F[3] <= next_F[3];
        F[4] <= next_F[4];
    end
end

always@(*)begin
    next_F[0] = LFB;
    next_F[1] = F[0]; 
    next_F[2] = F[1];
    next_F[3] = F[2];
    next_F[4] = F[3];
end
    
assign LFB = F[1] ^ F[4];

endmodule
