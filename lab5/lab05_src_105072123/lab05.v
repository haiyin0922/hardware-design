module clock_divider(clk, clk_div);

parameter n = 16;
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


module onepulse(pb_debounced, clk, pb_1pulse);

input pb_debounced;
input clk;
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


module lab05(input wire rst,
			input wire clk,
			input wire enter_btn,
			input wire digit0_btn,
			input wire digit1_btn,
			input wire cheat_btn,
			input wire cheat_sw,
			output [6:0] DISPLAY,
			output [3:0] DIGIT,
			output [15:0] LED); 
 
reg [6:0] DISPLAY;
reg [3:0] DIGIT, next_DIGIT, value,
		  num0, num1, num2, num3, next_num0, next_num1, next_num2, next_num3,
		  count0, count1, next_count0, next_count1,
		  sol0, sol1, next_sol0, next_sol1,
		  guess0, guess1, next_guess0, next_guess1,
		  range0, range1, range2, range3, next_range0, next_range1, next_range2, next_range3,
		  ans0, ans1, next_ans0, next_ans1;
reg [12:0] flag, next_flag;
reg [15:0] LED, next_LED;
reg [2:0] state, next_state;
parameter RESET = 3'b000, READY = 3'b001, SHOWRANGE = 3'b010,
		  GUESS = 3'b011, END = 3'b100; 

clock_divider clkdiv16(.clk(clk), .clk_div(clk16));
clock_divider #(13) clkdiv13(.clk(clk), .clk_div(clk13));

debounce rst_debounce(.pb_debounced(rst_deb), .pb(rst), .clk(clk16));
debounce enter_debounce(.pb_debounced(enter_deb), .pb(enter_btn), .clk(clk16));
onepulse enter_onepulse(.pb_debounced(enter_deb), .clk(clk16), .pb_1pulse(enter_one));
debounce digit0_debounce(.pb_debounced(digit0_deb), .pb(digit0_btn), .clk(clk16));
onepulse digit0_onepulse(.pb_debounced(digit0_deb), .clk(clk16), .pb_1pulse(digit0_one));
debounce digit1_debounce(.pb_debounced(digit1_deb), .pb(digit1_btn), .clk(clk16));
onepulse digit1_onepulse(.pb_debounced(digit1_deb), .clk(clk16), .pb_1pulse(digit1_one));
debounce cheat_debounce(.pb_debounced(cheat_deb), .pb(cheat_btn), .clk(clk16));

always @(posedge clk16 or posedge rst_deb) begin
	num0 = 4'd10;
  	num1 = 4'd10;
  	num2 = 4'd10;
  	num3 = 4'd10;
  	sol1 <= 4'd0;
	sol0 <= 4'd0;
	guess1 <= 4'd0;
	guess0 <= 4'd1;
	flag <= 13'b0;
	ans0 <= next_ans0;
    ans1 <= next_ans1;
	range0 <= next_range0;
  	range1 <= next_range1;
  	range2 <= next_range2;
  	range3 <= next_range3;
	state <= RESET;
	LED <= 16'b0;
	count1 <= (count1 == 4'd9 && count0 == 4'd8)? 4'd0 :
  			  (count0 == 4'd9)? count1 + 1'b1 : count1;
	count0 <= (count1 == 4'd9 && count0 == 4'd8)? 4'd1 :
  			  (count0 == 4'd9)? 4'd0 : count0 + 1'b1;
	if (rst_deb) begin
		num0 = 4'd10;
  		num1 = 4'd10;
  		num2 = 4'd10;
  		num3 = 4'd10;
  		sol1 <= 4'd0;
		sol0 <= 4'd0;
		guess1 <= 4'd0;
		guess0 <= 4'd1;
		flag <= 13'b0;
  		state <= RESET;
  		LED <= 16'b0;
	end
	else begin
	    num0 <= next_num0;
        num1 <= next_num1;
        num2 <= next_num2;
        num3 <= next_num3;
        sol1 <= next_sol1;
        sol0 <= next_sol0;
        guess1 <= next_guess1;
        guess0 <= next_guess0;
        flag <= next_flag;
        state <= next_state;
        LED <= next_LED;
	end
end

always @(*) begin
  next_num0 = num0;
  next_num1 = num1;
  next_num2 = num2;
  next_num3 = num3;
  next_guess1 = guess1;
  next_guess0 = guess0;
  next_sol1 = sol1;
  next_sol0 = sol0;
  next_ans0 = ans0;
  next_ans1 = ans1;
  next_range0 = range0;
  next_range1 = range1;
  next_range2 = range2;
  next_range3 = range3; 
  next_flag = flag; 
  next_LED = LED;
  case(state)
  	RESET: begin
  		next_num0 = 4'd10;
  		next_num1 = 4'd10;
  		next_num2 = 4'd10;
  		next_num3 = 4'd10;
  		next_sol1 = count1;
  		next_sol0 = count0;
  		next_guess1 = 4'd0;
        next_guess0 = 4'd1;
  		next_range0 = 4'd9;
  		next_range1 = 4'd9;
  		next_range2 = 4'd0;
  		next_range3 = 4'd0;
  		next_LED = 16'd0;
  		next_flag = 13'b0;
  		next_state = enter_one? READY : RESET;
  	end
  	READY: begin
  		next_num0 = cheat_deb? sol0 : range0;
  		next_num1 = cheat_deb? sol1 : range1;
  		next_num2 = cheat_deb? 4'd11 : range2;
  		next_num3 = cheat_deb? 4'd11 : range3;
  		next_LED = 16'b1111_1111_1111_1111;
  		next_state = enter_one? GUESS : READY;
  	end
  	SHOWRANGE: begin
  		next_num0 = cheat_deb? sol0 :
  					(ans1 > range1 || ans1 == range1 && ans0 > range0 ||
  					 ans1 < range3 || ans1 == range3 && ans0 < range2)? range0 :
  					(sol1 < ans1)? ans0 :
  			   		(sol1 == ans1 && sol0 < ans0)? ans0 : range0;
  		next_num1 = cheat_deb? sol1 :
  					(ans1 > range1 || ans1 == range1 && ans0 > range0 ||
  					 ans1 < range3 || ans1 == range3 && ans0 < range2)? range1 :
  					(sol1 < ans1)? ans1 :
  			   		(sol1 == ans1 && sol0 < ans0)? ans1 : range1;
  		next_num2 = cheat_deb? 4'd11 :
  					(ans1 > range1 || ans1 == range1 && ans0 > range0 ||
  					 ans1 < range3 || ans1 == range3 && ans0 < range2)? range2 :
  					(sol1 < ans1)? range2 :
  			   		(sol1 == ans1 && sol0 < ans0)? range2 : ans0;
  		next_num3 = cheat_deb? 4'd11 :
  					(ans1 > range1 || ans1 == range1 && ans0 > range0 ||
  					 ans1 < range3 || ans1 == range3 && ans0 < range2)? range3 :
  					(sol1 < ans1)? range3 :
  			   		(sol1 == ans1 && sol0 < ans0)? range3 : ans1;
  		next_guess1 = 4'd0;
  		next_guess0 = 4'd1;
  		next_range0 = enter_one? num0 : range0;
  		next_range1 = enter_one? num1 : range1;
  		next_range2 = enter_one? num2 : range2;
  		next_range3 = enter_one? num3 : range3;
  		next_state = enter_one? GUESS : SHOWRANGE;
  	end
  	GUESS: begin
  		next_num0 = guess0;
  		next_num1 = guess1;
  		next_num2 = 4'd11;
  		next_num3 = 4'd11;
  		next_guess1 = !digit1_one? guess1 : (guess1 == 4'd9)? 4'd0 : guess1 + 1'b1; 
  		next_guess0 = !digit0_one? guess0 : (guess0 == 4'd9)? 4'd0 : guess0 + 1'b1;
  		next_ans1 = enter_one? guess1 : ans1;
  		next_ans0 = enter_one? guess0 : ans0;
  		next_LED = cheat_sw? LED : 
  				   !enter_one? LED :
  				   (guess1 == sol1 && guess0 == sol0)? LED : LED << 2;
  		next_state = !enter_one? GUESS :
  					 (guess1 == sol1 && guess0 == sol0 || next_LED == 16'd0)? END : SHOWRANGE;
  	end 
  	END: begin
  		next_num0 = (LED == 16'd0)? 4'd14 : 4'd13;
  		next_num1 = (LED == 16'd0)? 4'd5 : 4'd12;
  		next_num2 = 4'd0;
  		next_num3 = (LED == 16'd0)? 4'd13 : 4'd6;
  		next_flag = flag + 1'b1;
  		next_state = (flag == 13'd4095)? RESET : END;
  	end
  endcase
end

always @(posedge clk13) begin
	DIGIT <= next_DIGIT;
end

always @(*) begin
  value = 4'd0;
  next_DIGIT = 4'b1110;
  case(DIGIT)
  	4'b1110: begin
  		value = num0;
  		next_DIGIT = 4'b1101;
  	end
  	4'b1101: begin
  		value = num1;
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
  DISPLAY = 7'b1111110;
  case(value)
    4'd0: DISPLAY = 7'b1000000; //O
    4'd1: DISPLAY = 7'b1111001;
    4'd2: DISPLAY = 7'b0100100;   
    4'd3: DISPLAY = 7'b0110000;
    4'd4: DISPLAY = 7'b0011001;
    4'd5: DISPLAY = 7'b0010010; //S
    4'd6: DISPLAY = 7'b0000010; //G
    4'd7: DISPLAY = 7'b1111000;
    4'd8: DISPLAY = 7'b0000000;
    4'd9: DISPLAY = 7'b0010000;
    4'd10: DISPLAY = 7'b0111111; //-
    4'd11: DISPLAY = 7'b1111111; //blank
    4'd12: DISPLAY = 7'b0001000; //A
    4'd13: DISPLAY = 7'b1000111; //L
    4'd14: DISPLAY = 7'b0000110; //E
  endcase
end

endmodule