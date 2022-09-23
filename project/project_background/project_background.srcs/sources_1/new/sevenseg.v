module sevenseg(
 input clk,
 input rst,
 output [3:0] DIGIT,
 output [6:0] DISPLAY
 );

reg [3:0]  value, DIGIT, next_DIGIT;
reg [6:0] DISPLAY;

clock_divider #(13) clkdiv13(.clk(clk), .clk_div(clk13));

always @(posedge clk13) begin
 DIGIT <= next_DIGIT;
end

always @(*) begin
  value = 4'd0;
  next_DIGIT = 4'b1110;
  case(DIGIT)
   4'b1110: begin
    value = 3;
    next_DIGIT = 4'b1101;
   end
   4'b1101: begin
    value = 2;
    next_DIGIT = 4'b1011;
   end
   4'b1011: begin
    value = 1;
    next_DIGIT = 4'b0111;
   end
   4'b0111: begin
    value = 0;
    next_DIGIT = 4'b1110;
   end
  endcase
end

always@(*)begin
  DISPLAY = 7'b1111110;
  case(value)
    4'd0: DISPLAY = 7'b0111000;
    4'd1: DISPLAY = 7'b1111001;
    4'd2: DISPLAY = 7'b1111010;
    4'd3: DISPLAY = 7'b0110000;

  endcase
end

endmodule