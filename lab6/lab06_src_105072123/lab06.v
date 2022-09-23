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


module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule


module lab06(clk, rst, LED, PS2_CLK, PS2_DATA, DISPLAY, DIGIT);

input clk, rst;
inout PS2_CLK, PS2_DATA;
output [3:0] DIGIT;
output [6:0] DISPLAY;
output [11:0] LED;
	
	parameter [8:0] KEY_CODES [0:2] = {
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010 // right_3 => 7A
	};

	parameter [1:0] STAY = 2'b00, UP = 2'b01, DOWN = 2'b10; 
	
	reg [3:0] key_num;
	reg [9:0] last_key;
	reg [11:0] LED;
	reg [3:0] value, num0, next_num0, num1, next_num1; 
	reg [1:0] state, next_state, count, next_count;
	reg [6:0] DISPLAY;
	reg [3:0] DIGIT, next_DIGIT;
	reg flag, judge1, next_judge1, judge2, next_judge2, judge3, next_judge3;
	reg [25:0] clk_count;

	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	clock_divider clkdiv26(.clk(clk), .clk_div(clk26));
	clock_divider #(13) clkdiv13(.clk(clk), .clk_div(clk13));

	debounce rstdebounce(.pb_debounced(rst_deb), .pb(rst), .clk(clk13));

    always @(posedge clk_sel) begin
		num0 <= 4'd1;
		num1 <= 4'd0;
		state <= STAY;
		count <= 2'd0;
		judge1 <= 1'b0;
		judge2 <= 1'b0;
		judge3 <= 1'b0;
		if (rst_deb) begin
			num0 <= 4'd1;
			num1 <= 4'd0;
			state <= STAY;
			count <= 2'd0;
			judge1 <= 1'b0;
			judge2 <= 1'b0;
			judge3 <= 1'b0;
		end
		else begin
			num0 <= next_num0;
			num1 <= next_num1;
			state <= next_state;
			count <= next_count;
			judge1 <= next_judge1;
			judge2 <= next_judge2;
			judge3 <= next_judge3;
		end
	end

    always @(posedge clk) begin
    	clk_count <= (judge1 || judge2 || judge3 || clk_count == 26'd67108863)? 26'd0 : clk_count + 1'b1;
    	LED[3:0] <= LED[3:0];
    	if (rst_deb) begin
    		LED[3:0] <= 4'b0;
    		clk_count <= 26'd0;
    	end
    	else begin
    		if (been_ready && key_down[last_change] == 1'b1 && key_num == 4'b0001) LED[3:0] <= {LED[2:0], 1'b1};
    		else if (judge1 || clk_count == 26'd67108863 && state == STAY && num0 == 4'd1) LED[3:0] <= LED[3:0] >> 1'b1;
    		else LED[3:0] <= LED[3:0];
    	end
    end

    always @(posedge clk) begin
    	LED[7:4] <= LED[7:4];
    	if (rst_deb) LED[7:4] <= 4'b0;
    	else begin
    		if (been_ready && key_down[last_change] == 1'b1 && key_num == 4'b0010) LED[7:4] <= {LED[6:4], 1'b1};
    		else if (judge2 || clk_count == 26'd67108863 && state == STAY && num0 == 4'd2) LED[7:4] <= LED[7:4] >> 1'b1;
    		else LED[7:4] <= LED[7:4];
    	end
    end

    always @(posedge clk) begin
    	LED[11:8] <= LED[11:8];
    	if (rst_deb) LED[11:8] <= 4'b0;
    	else begin
    		if (been_ready && key_down[last_change] == 1'b1 && key_num == 4'b0011) LED[11:8] <= {LED[10:8], 1'b1};
    		else if (judge3 || clk_count == 26'd67108863 && state == STAY && num0 == 4'd3) LED[11:8] <= LED[11:8] >> 1'b1;
    		else LED[11:8] <= LED[11:8];
    	end
    end

    assign clk_sel = (state == STAY || rst_deb)? clk : clk26;

    always @(*) begin
      next_num0 = num0;
      next_num1 = num1;
      next_state = state;
      next_count = 2'd0;
      next_judge1 = 1'b0;
      next_judge2 = 1'b0;
      next_judge3 = 1'b0;
      flag = flag;
	  case(state)
	  	STAY: begin
	  		next_num0 = num0;
	      	if (num0 == 4'd1) begin
	      		flag =1'b1;
	      		next_num1 = (LED[11:4] != 8'b0)? 4'd4 : 4'd0;
	      		next_state = (LED[11:4] != 8'b0 && LED[3:0] == 4'b0)? UP : STAY;
	      	end
	      	else if (num0 == 4'd2) begin
	      		next_num1 = (LED[11:8] != 4'b0 && LED[3:0] == 4'b0 ||
	      					 LED[11:8] != 4'b0 && LED[3:0] != 4'b0 && flag)? 4'd4 :
	      					(LED[11:8] == 4'b0 && LED[3:0] != 4'b0 ||
	      					 LED[11:8] != 4'b0 && LED[3:0] != 4'b0 && !flag)? 4'd8 : 4'd0;
	      		next_state = (LED[7:4] != 4'b0 || LED[11:8] == 4'b0 && LED[3:0] == 4'b0)? STAY :
	      					 (LED[11:8] != 4'b0 && LED[3:0] == 4'b0 ||
	      					  LED[11:8] != 4'b0 && LED[3:0] != 4'b0 && flag)? UP : DOWN;
	      	end
	      	else if (num0 == 4'd3) begin
	      		flag = 1'b0;
	      		next_num1 = (LED[7:0] != 8'b0)? 4'd8 : 4'd0;
	      		next_state = (LED[7:0] != 8'b0 && LED[11:8] == 4'b0)? DOWN : STAY;
	      	end
	  	end
	  	UP: begin
	  		next_count = (count == 2'd3)? 2'd0 : count + 1'b1;
	  		next_num0 = (num1 == 4'd7 && num0 != 4'd3)? num0 + 1'b1 : num0;
	  		next_num1 = (count == 2'd0)? 4'd4 : (num1 == 4'd4)? 4'd5 : (num1 == 4'd5)? 4'd6 : 4'd7;
	  		next_state = (num0 == 4'd1 && num1 == 4'd7 && LED[7:4] != 4'b0 || num0 == 4'd2 && num1 == 4'd7)? STAY : UP;
	  		next_judge3 = (num0 == 4'd2 && num1 == 4'd7)? 1'b1 : 1'b0;
	  		next_judge2 = (num0 == 4'd1 && num1 == 4'd7 && LED[7:4] != 4'b0)? 1'b1 : 1'b0;
	  	end
	  	DOWN: begin
	  		next_count = (count == 2'd3)? 2'd0 : count + 1'b1;
	  		next_num0 = (num1 == 4'd11 && num0 != 4'd1)? num0 - 1'b1 : num0;
	  		next_num1 = (count == 2'd0)? 4'd8 : (num1 == 4'd8)? 4'd9 : (num1 == 4'd9)? 4'd10 : 4'd11;
	  		next_state = (num0 == 4'd3 && num1 == 4'd11 && LED[7:4] != 4'b0 || num0 == 4'd2 && num1 == 4'd11)? STAY : DOWN;
	  		next_judge1 = (num0 == 4'd2 && num1 == 4'd11)? 1'b1 : 1'b0;
	  		next_judge2 = (num0 == 4'd3 && num1 == 4'd11 && LED[7:4] != 4'b0)? 1'b1 : 1'b0;
	  	end
	  endcase
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[0] : key_num = 4'b0001;
			KEY_CODES[1] : key_num = 4'b0010;
			KEY_CODES[2] : key_num = 4'b0011;
			default		 : key_num = 4'b0000;
		endcase
	end

	always @(posedge clk13) begin
		DIGIT <= next_DIGIT;
	end

	always @(*) begin
  	  value = num0;
  	  next_DIGIT = 4'b1101;
  	  case(DIGIT)
  		4'b1110: begin
  			value = num0;
  			next_DIGIT = 4'b1101;
  		end
  		4'b1101: begin
  			value = num1;
  			next_DIGIT = 4'b1110;
  		end
  	  endcase
	end

	always@(*)begin
  	  DISPLAY = 7'b1111111;
 	  case(value)
    	4'd1: DISPLAY = 7'b1111001;
    	4'd2: DISPLAY = 7'b0100100;   
    	4'd3: DISPLAY = 7'b0110000;
    	4'd4: DISPLAY = 7'b1011100; // up1
    	4'd5: DISPLAY = 7'b1110111; // up2
    	4'd6: DISPLAY = 7'b0101011; // up3
    	4'd7: DISPLAY = 7'b1011100; // up4
    	4'd8: DISPLAY = 7'b1100011; // down1
    	4'd9: DISPLAY = 7'b1111110; // down2
    	4'd10: DISPLAY = 7'b0011101; // down3
    	4'd11: DISPLAY = 7'b1100011; // down4
  	  endcase
	end

endmodule