`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 21:14:40
// Design Name: 
// Module Name: Lab4_1
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


module Lab4_1(DIGIT, DISPLAY, clk, reset, SW); 
 
input [15:0] SW;
input clk;
input reset; 
output [3:0] DIGIT; 
output [6:0] DISPLAY;

reg [3:0] value, DIGIT, next_DIGIT, pres_DIGIT;
reg [6:0] DISPLAY;

clock_divider clkdiv(.clk(clk), .clk_div(clk_div));

always @(posedge clk_div or posedge reset) begin
    if (reset) begin
        DIGIT <= pres_DIGIT;        
    end
    else begin
        DIGIT <= next_DIGIT;        
    end
end

always@(*)begin
  pres_DIGIT = DIGIT;
  value = SW[15:12];
  next_DIGIT = 4'b1110;
  case(DIGIT)
    4'b1110: begin
        value = SW[3:0];
        next_DIGIT = 4'b1101;
    end
    4'b1101: begin
        value = SW[7:4];
        next_DIGIT = 4'b1011;
    end
    4'b1011: begin
        value = SW[11:8];
        next_DIGIT = 4'b0111;
    end
    4'b0111: begin
        value = SW[15:12];
        next_DIGIT = 4'b1110;
    end
  endcase
end    

always@(*)begin
  case(value)
    4'd0: DISPLAY = 7'b1000000;
    4'd1: DISPLAY = 7'b1111001;
    4'd2: DISPLAY = 7'b0100100;   
    4'd3: DISPLAY = 7'b0110000;
    4'd4: DISPLAY = 7'b0011001;
    4'd5: DISPLAY = 7'b0010010;
    4'd6: DISPLAY = 7'b0000010;
    4'd7: DISPLAY = 7'b1111000;
    4'd8: DISPLAY = 7'b0000000;
    default: DISPLAY = 7'b0010000;
  endcase
end

endmodule


module clock_divider(clk, clk_div);

parameter n = 19;
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