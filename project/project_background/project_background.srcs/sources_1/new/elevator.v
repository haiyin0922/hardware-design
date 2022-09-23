`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/14 16:15:51
// Design Name: 
// Module Name: elevator
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


module elevator(
   input clk,
   input rst,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr,
   output [8:0] position2
   );
    
    parameter UP = 3'b000 , DOWN = 3'b001;
    
    reg [8:0] position2 , next_position2;
    reg [2:0] state , next_state;
  
  
   assign pixel_addr = (190<=h_cnt && h_cnt<=223 && 352-position2<=v_cnt && v_cnt<=383-position2) ?(h_cnt-190)+30720+(v_cnt-352+position2)*32:
                       (448<=h_cnt && h_cnt<=481 && 352-position2<=v_cnt && v_cnt<=383-position2) ?(h_cnt-448)+30720+(v_cnt-352+position2)*32:
                       31743;
   
   always@ (posedge clk , posedge rst)begin
        if(rst)begin
            position2 <= 0;
            state <= UP;
        end
        else begin
            position2 <= next_position2;
            state = next_state;
        end
   end
   
   always@(*)begin
        case(state)
            UP:begin
                next_state = (position2 == 192) ?DOWN:UP;
                next_position2 = (position2 == 192) ?position2-1:position2+1;
            end
            DOWN:begin
                next_state = (position2 == 0) ?UP:DOWN;
                next_position2 = (position2 == 0) ?position2+1:position2-1;
            end
        endcase
   end
    
endmodule
