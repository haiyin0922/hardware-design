`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/01 20:39:32
// Design Name: 
// Module Name: lab2_2
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


module one_digit(clk, rst_n, en, dir, gray, cout);

input clk, rst_n, en, dir;
output [3:0] gray;
output cout;

reg cout;
reg [3:0] out, next_out, gray;

always@(negedge clk or negedge rst_n)begin
	if (!rst_n) begin
		out <= 4'h0;
	end
	else begin
	    out <= next_out;
	end
end

always@(*)begin
    if(en && dir)begin
        next_out = (out == 4'hf)? 4'h0 : out + 4'h1;
    end
    else if (en && !dir)begin
        next_out = (out == 4'h0) ? 4'hf : out - 4'h1;
    end
    else begin
        next_out = out;
    end
end

always@(*)begin
	cout = (!en)? 1'b0 :
	(dir && out == 4'hf) ? 1'b1 :
	(!dir && out == 4'h0) ? 1'b1 : 1'b0;
end

always@(*)begin
        case(out[3:0])
            4,5,6,7,8,9,10,11: gray[2] = 1'b1 ;
            default: gray[2] = 1'b0 ;     
        endcase
        case(out[3:0])     
            2,3,4,5,10,11,12,13: gray[1] = 1'b1;
            default: gray[1] = 1'b0;
        endcase
        case(out[3:0])
            1,2,5,6,9,10,13,14 : gray[0] = 1'b1;
            default: gray[0] = 1'b0;
        endcase
        gray[3] = out[3];
    end
    
endmodule 


module lab2_2(clk, rst_n, en, dir, gray, cout);

input clk, rst_n, en, dir;
output [7:0] gray;
output cout;

one_digit one(.clk(clk), .rst_n(rst_n), .en(en), .dir(dir), .gray(gray[3:0]), .cout(c1));
one_digit two(.clk(clk), .rst_n(rst_n), .en(en1), .dir(dir), .gray(gray[7:4]), .cout(c2));

assign en1 = (gray[3:0] == 4'b0000 && !dir || gray[3:0] == 4'b1000 && dir)? 1'b1 : 1'b0;
assign cout = (c1 && c2)? 1'b1 : 1'b0;
 
endmodule
