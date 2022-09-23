`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:35 05/02/2012 
// Design Name: 
// Module Name:    note_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module note_gen(
  clk, // clock from crystal
  rst, // active high reset
  note_div, // div for note generation
  audio_left, // left sound audio
  audio_right // right sound audio
);

// I/O declaration
input clk; // clock from crystal
input rst; // active low reset
input [21:0] note_div; // div for note generation
output [15:0] audio_left; // left sound audio
output [15:0] audio_right; // right sound audio

// Declare internal signals
reg [21:0] clk_cnt_next, clk_cnt;
reg [21:0] clk_cnt_next_2, clk_cnt_2;
reg b_clk, b_clk_next;
reg c_clk, c_clk_next;

parameter note_do = 22'd191571;
parameter note_mi = 22'd151515;

// Note frequency generation
always @(posedge clk or posedge rst)
  if (rst == 1'b1)
  begin
    clk_cnt <= 22'd0;
    clk_cnt_2 <= 22'd0;
    b_clk <= 1'b0;
    c_clk <= 1'b0;
  end
  else
  begin
    clk_cnt <= clk_cnt_next;
    clk_cnt_2 <= clk_cnt_next_2;
    b_clk <= b_clk_next;
    c_clk <= c_clk_next;
  end
	 
always @*
  if (clk_cnt == note_div)
  begin
    clk_cnt_next = 22'd0;
    b_clk_next = ~b_clk;
  end
  else
  begin
    clk_cnt_next = clk_cnt + 1'b1;
    b_clk_next = b_clk;
  end

always @*
  if (clk_cnt_2 == note_mi)
  begin
    clk_cnt_next_2 = 22'd0;
    c_clk_next = ~c_clk;
  end
  else
  begin
    clk_cnt_next_2 = clk_cnt_2 + 1'b1;
    c_clk_next = c_clk;
  end

// Assign the amplitude of the note
//assign audio_left = (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
//assign audio_right = (c_clk == 1'b0) ? 16'hE000 : 16'h2000;
assign audio_left = (note_div == 22'd1000) ? 16'h0000 : (b_clk == 1'b0) ? 16'h8001 : 16'h7FFF;
assign audio_right = (note_div == 22'd1000) ? 16'h0000 : (b_clk == 1'b0) ? 16'h8001 : 16'h7FFF;

endmodule
