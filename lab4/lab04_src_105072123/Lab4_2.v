`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 03:57:46
// Design Name: 
// Module Name: Lab4_2
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


module onepulse(pb_debounced,  clk,  pb_1pulse);

input pb_debounced;
input  clk;
output pb_1pulse;

reg pb_1pulse;
reg pb_debounced_delay;

always@(posedge clk) begin
	if(pb_debounced==  1'b1  &  pb_debounced_delay==  1'b0) pb_1pulse  <=  1'b1;
	else pb_1pulse  <=  1'b0;
	pb_debounced_delay<=  pb_debounced;
end

endmodule


module debounce (pb_debounced, pb, clk);

output pb_debounced; // signal of a pushbutton after being debounced
input pb; // signal from a pushbutton
input clk;

reg [3:0] DFF; // use shift_reg to filter pushbutton bounce

always @(posedge clk) begin
	DFF[3:1] <= DFF[2:0];
	DFF[0] <= pb;
end

assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

endmodule


module clock_divider13(clk, clk_div);

parameter n = 13;
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


module clock_divider25(clk, clk_div);

parameter n = 25;
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


module Lab4_2(DIGIT, DISPLAY, cout, en, reset, dir, clk);

input en;
input reset;
input dir;
input clk;
output [3:0] DIGIT;
output [6:0] DISPLAY;
output cout;

reg [3:0] value, num1, num2, next_num1, next_num2, DIGIT, next_DIGIT;
reg [6:0] DISPLAY;
reg flag_en;

clock_divider13 clkdiv13(.clk(clk), .clk_div(clk13));
clock_divider25 clkdiv25(.clk(clk), .clk_div(clk25));

onepulse onepulse_en(.pb_debounced(en_deb), .clk(clk13), .pb_1pulse(en_1pulse));
debounce debounce_en(.pb_debounced(en_deb), .pb(en), .clk(clk13));
debounce debounce_dir(.pb_debounced(dir_deb), .pb(dir), .clk(clk13));
debounce debounce_reset(.pb_debounced(reset_deb), .pb(reset), .clk(clk13));


always @(posedge clk25 or posedge reset_deb) begin
	if (reset_deb) begin
		num1 <= 4'd0;
		num2 <= 4'd0;
	end
	else begin
		num1 <= next_num1;
		num2 <= next_num2;
	end
end

always @(posedge en_1pulse or posedge reset_deb) begin
    if(reset_deb)begin
        flag_en = 1'b0;
    end
    else begin
        flag_en = ~flag_en;
    end
end

always @(posedge clk13)begin
    DIGIT <= next_DIGIT;
end

always @(*) begin
  value = 4'd0;
  next_DIGIT = 4'b1110;
  case(DIGIT)
  	4'b1110: begin
  		value = num1;
  		next_DIGIT = 4'b1101;
  	end
  	4'b1101: begin
  		value = num2;
  		next_DIGIT = 4'b1110;
  	end
  endcase
end

always@(*)begin
    if(!flag_en) begin
        next_num1 = num1;
        next_num2 = num2;
    end
    else if (dir_deb)begin
        next_num1 = (num1 == 4'd0 && num2 != 4'd0)? 4'd9 : (num1 == 4'd0 && num2 == 4'd0)? 4'd0 : num1 - 1'b1;
        next_num2 = (num1 == 4'd0 && num2 != 4'd0)? num2 - 1'b1 : (num1 == 4'd0 && num2 == 4'd0)? 4'd0 : num2;
    end
    else begin
        next_num1 = (num1 == 4'd9 && num2 == 4'd9)? num1 : (num1 == 4'd9 && num2 != 4'd9)? 4'b0 : num1 + 1'b1;
        next_num2 = (num1 == 4'd9 && num2 == 4'd9)? num2 : (num1 == 4'd9 && num2 != 4'd9)? num2 + 1'b1 : num2;
    end
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
    4'd9: DISPLAY = 7'b0010000;
    default: DISPLAY = 7'b1111111;
  endcase
end

assign cout = (num1 == 4'd9 && num2 == 4'd9)? 1'b1 : 1'b0;

endmodule