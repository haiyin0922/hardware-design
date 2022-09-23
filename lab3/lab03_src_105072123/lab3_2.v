`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/06 22:51:56
// Design Name: 
// Module Name: lab3_2
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


module clock_divider23(clk, clk_div);

parameter n = 23;
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


module lab3_2(clk, rst_n, en, speed, led); 
    input clk;     
    input rst_n;     
    input en;  
    input speed;     
    output[15:0] led;
    
    reg[15:0] led;
    reg[2:0] flag, next_flag, num, next_num;
    reg[3:0] state1, next_state1, state2, next_state2;
    parameter[3:0] S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5,
                   S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9, S10 = 4'd10,
                   S11 = 4'd11, S12 = 4'd12, S13 = 4'd13, S14 = 4'd14, S15 = 4'd15;
    
clock_divider23 div23(.clk(clk), .clk_div(clk23));

always@(posedge clk23 or negedge rst_n)begin
	if(!rst_n)begin
		state1 <= S15;
		state2 <= S7;
		flag <= 3'b0;
		num <= 3'b0;
	end
	else begin
		state1 <= next_state1;
		state2 <= next_state2;
		flag <= next_flag;
		num <= next_num;
	end
end

always@(*)begin
  next_flag = flag;
  case(state1)
	S15: begin
        led[15:8] = 8'b1000_0000;
        next_state1 = !en? S15 : speed? S14 : led[0]? S14 : S15;
	end
	S14: begin
        led[15:8] = 8'b0100_0000;
        next_state1 = !en? S14 : speed? S13 : led[0]? S13 : S14;
	end
	S13: begin
        led[15:8] = 8'b0010_0000;
        next_state1 = !en? S13 : speed? S12 : led[0]? S12 : S13;
	end
	S12: begin
        led[15:8] = 8'b0001_0000;
        next_state1 = !en? S12 : speed? S11 : led[0]? S11 : S12;
	end
	S11: begin
        led[15:8] = 8'b0000_1000;
        next_state1 = !en? S11 : speed? S10 : led[0]? S10 : S11;
	end
	S10: begin
        led[15:8] = 8'b0000_0100;
        next_state1 = !en? S10 : speed? S9 : led[0]? S9 : S10;
	end
	S9: begin
        led[15:8] = 8'b0000_0010;
        next_state1 = !en? S9 : speed? S8 : led[0]? S8 : S9;
	end
	S8: begin
        led[15:8] = 8'b0000_0001;
        next_state1 = (flag == 3'd4)? S8 : !en? S8 : speed? S15 : led[0]? S15 : S8;
        next_flag = (next_state1 == S8)? flag : (flag == 3'd4)? flag : flag + 1'b1;
	end
  endcase
end

always@(*)begin
  next_num = (num == 3'd7)? 3'd0 : num + 1'b1;
  case(state2)
	S7:	begin
        led[7:0] = 8'b1000_0000;
        next_state2 = !en? S7 : !speed? S6 : (num == 3'd7)? S6 : S7;
	end
	S6: begin
        led[7:0] = 8'b0100_0000;
        next_state2 = !en? S6 : !speed? S5 : (num == 3'd7)? S5 : S6;
	end
	S5: begin
        led[7:0] = 8'b0010_0000;
        next_state2 = !en? S5 : !speed? S4 : (num == 3'd7)? S4 : S5;
	end
	S4: begin
        led[7:0] = 8'b0001_0000;
        next_state2 = !en? S4 : !speed? S3 : (num == 3'd7)? S3 : S4;
	end
	S3: begin
        led[7:0] = 8'b0000_1000;
        next_state2 = !en? S3 : !speed? S2 : (num == 3'd7)? S2 : S3;
    end
	S2: begin
        led[7:0] = 8'b0000_0100;
        next_state2 = !en? S2 : !speed? S1 : (num == 3'd7)? S1 : S2;
	end
	S1: begin
        led[7:0] = 8'b0000_0010;
        next_state2 = !en? S1 : !speed? S0 : (num == 3'd7)? S0 : S1;
	end
	S0: begin
        led[7:0] = 8'b0000_0001;
        next_state2 = !en? S0 : !speed? S7 : (num == 3'd7)? S7 : S0;
	end
  endcase
end

endmodule