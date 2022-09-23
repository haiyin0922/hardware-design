module SevenSegment(
	output reg [6:0] display,
	output reg [3:0] digit,
	input wire [31:0] tone_c,
	input wire rst,
	input wire clk
    );
    
    reg [15:0] clk_divider;
    reg [31:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display_num <= 32'd0;
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= 32'd0;
						digit <= 4'b1011;
					end
    			4'b1011 : begin
						display_num <= 32'd0;
						digit <= 4'b0111;
					end
    			4'b0111 : begin
						display_num <= tone_c;
						digit <= 4'b1110;
					end
    			default : begin
						display_num <= 32'd0;
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    
    always @ (*) begin
    	case (display_num)
            32'd262 :display = 7'b1000110;// C
            32'd294 :display = 7'b0100001;// D
            32'd330 :display = 7'b0000110;// E
            32'd349 :display = 7'b0001110;// F
            32'd370 :display = 7'b0001110;// #F
            32'd392 :display = 7'b0010000;// G
            32'd440 :display = 7'b0001000;// A
            32'd494 :display = 7'b0000011;// B
            32'd524 :display = 7'b1000110;// C sharp
            32'd588 :display = 7'b0100001;// D sharp
            32'd660 :display = 7'b0000110;// E sharp
            32'd698 :display = 7'b0001110;// F sharp
            32'd740 :display = 7'b0001110;// #F sharp
            32'd784 :display = 7'b0010000;// G sharp
            32'd880 :display = 7'b0001000;// A sharp
            32'd988 :display = 7'b0000011;// B sharp
			default : display = 7'b0111111;
    	endcase
    end
    
endmodule