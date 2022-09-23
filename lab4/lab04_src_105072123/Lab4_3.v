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

module Lab4_3(DIGIT, DISPLAY, Dot, en, reset, clk);

input en;
input reset;
input clk;
output [3:0] DIGIT;
output [6:0] DISPLAY;
output Dot;

reg [3:0] DIGIT, next_DIGIT;
reg [6:0] DISPLAY;
reg [4:0] num0, num1, num2, num3, value, next_num0, next_num1, next_num2, next_num3;
reg[1:0] state, next_state;
reg flag_en, Dot;

parameter RESET = 2'b00, WAIT = 2'b01, COUNT = 2'b10;

clock_divider13 clkdiv13(.clk(clk), .clk_div(clk13));
clock_divider23 clkdiv23(.clk(clk), .clk_div(clk23));

debounce debounce_rst(.pb_debounced(rst_deb), .pb(reset), .clk(clk13));
onepulse onepulse_rst(.pb_debounced(rst_deb), .clk(clk13), .pb_1pulse(rst_1pulse));
debounce debounce_en(.pb_debounced(en_deb), .pb(en), .clk(clk13));
onepulse onepulse_en(.pb_debounced(en_deb), .clk(clk13), .pb_1pulse(en_1pulse));

always @(posedge clk23 or posedge rst_1pulse) begin
	if (rst_1pulse) begin
		state <= RESET;
		num0 <= 4'd0;
		num1 <= 4'd0;
		num2 <= 4'd0;
		num3 <= 4'd0;
	end
	else begin
		state <= next_state;
		num0 <= next_num0;
		num1 <= next_num1;
		num2 <= next_num2;
		num3 <= next_num3;
	end
end

always @(posedge en_1pulse or posedge rst_1pulse) begin
	if (rst_1pulse) begin
		flag_en = 1'b0;
	end
	else begin
		flag_en = ~flag_en;
	end
end

always @(*) begin
  next_num0 = num0;
  next_num1 = num1;
  next_num2 = num2;
  next_num3 = num3;
  next_state = WAIT;
  case(state)
  	RESET: begin
  		next_state = (!rst_1pulse)? WAIT : RESET;
  	end
  	WAIT: begin
  		next_state = flag_en? COUNT : WAIT;
	end
	COUNT: begin
		next_num0 = (num3 == 4'd2)? 4'd0 :
					(num0 == 4'd9)? 4'd0 : num0 + 1'b1;
		next_num1 = (num3 == 4'd2)? 4'd0 : 
					(num0 == 4'd9 && num1 != 4'd9)? num1 + 1'b1 :
    				(num0 == 4'd9 && num1 == 4'd9)? 1'b0 : num1;
    	next_num2 = (num3 == 4'd2)? 4'd0 :
    				(num0 == 4'd9 && num1 == 4'd9 && num2 != 4'd5)? num2 + 1'b1 :
    				(num0 == 4'd9 && num1 == 4'd9 && num2 == 4'd5)? 1'b0 : num2;
    	next_num3 = (num3 == 4'd2)? num3 :
    				(num0 == 4'd9 && num1 == 4'd9 && num2 == 4'd5)? num3 + 1'b1 : num3;
		next_state = !flag_en? WAIT : COUNT;		
	end
  endcase
end

always @(posedge clk13)begin
    DIGIT <= next_DIGIT;
end

always @(*) begin
  value = 4'd0;
  Dot = 1'b1;
  next_DIGIT = 4'b1110;
  case(DIGIT)
  	4'b1110: begin
  		value = num0;
  		next_DIGIT = 4'b1101;
    end
    4'b1101: begin
    	value = num1;
    	Dot = 1'b0;
    	next_DIGIT = 4'b1011;
    end
    4'b1011: begin
    	value = num2;
    	next_DIGIT = 4'b0111;
    end
    4'b0111: begin
    	value = num3;
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
    4'd9: DISPLAY = 7'b0010000;
    default: DISPLAY = 7'b1111111;
  endcase
end

endmodule