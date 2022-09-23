`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/12 23:38:45
// Design Name: 
// Module Name: background
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


module background(
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
  
   assign pixel_addr = (0<=h_cnt && h_cnt<=95 && 384<=v_cnt && v_cnt<=415) ?(h_cnt%32)+2048+(v_cnt-384)*32:
                       (0<=h_cnt && h_cnt<=95 && 416<=v_cnt && v_cnt<=447) ?(h_cnt%32)+3072+(v_cnt-416)*32:
                       (0<=h_cnt && h_cnt<=95 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+3072+(v_cnt-448)*32:
                       (96<=h_cnt && h_cnt<=127 && 384<=v_cnt && v_cnt<=415) ?1055-(h_cnt-96)+(v_cnt-384)*32:
                       (96<=h_cnt && h_cnt<=127 && 416<=v_cnt && v_cnt<=447) ?4127-(h_cnt-96)+(v_cnt-416)*32:
                       (96<=h_cnt && h_cnt<=127 && 448<=v_cnt && v_cnt<=479) ?4127-(h_cnt-96)+(v_cnt-448)*32:
                       (128<=h_cnt && h_cnt<=159 && 384<=v_cnt && v_cnt<=415) ?31-(h_cnt-128)+(v_cnt-384)*32:
                       (0<=h_cnt && h_cnt<=31 && 352<=v_cnt && v_cnt<=383) ?1055-h_cnt+(v_cnt-352)*32:
                       (32<=h_cnt && h_cnt<=63 && 352<=v_cnt && v_cnt<=383) ?31-(h_cnt-32)+(v_cnt-352)*32:
                       (0<=h_cnt && h_cnt<=31 && 320<=v_cnt && v_cnt<=351) ?h_cnt+6144+(v_cnt-320)*32:
                       (32<=h_cnt && h_cnt<=63 && 320<=v_cnt && v_cnt<=351) ?(h_cnt-32)+8192+(v_cnt-320)*32:
                       (64<=h_cnt && h_cnt<=159 && 288<=v_cnt && v_cnt<=383) ?(h_cnt-64)+11264+(v_cnt-288)*96://左下
                       (256<=h_cnt && h_cnt<=287 && 384<=v_cnt && v_cnt<=415) ?(h_cnt-256)+(v_cnt-384)*32:
                       (288<=h_cnt && h_cnt<=319 && 384<=v_cnt && v_cnt<=415) ?(h_cnt-288)+1024+(v_cnt-384)*32:
                       (288<=h_cnt && h_cnt<=319 && 416<=v_cnt && v_cnt<=447) ?(h_cnt-288)+4096+(v_cnt-416)*32:
                       (288<=h_cnt && h_cnt<=319 && 448<=v_cnt && v_cnt<=479) ?(h_cnt-288)+4096+(v_cnt-448)*32:
                       (320<=h_cnt && h_cnt<=351 && 384<=v_cnt && v_cnt<=415) ?(h_cnt-320)+2048+(v_cnt-384)*32:
                       (320<=h_cnt && h_cnt<=351 && 416<=v_cnt && v_cnt<=447) ?(h_cnt-320)+3072+(v_cnt-416)*32:
                       (320<=h_cnt && h_cnt<=351 && 448<=v_cnt && v_cnt<=479) ?(h_cnt-320)+3072+(v_cnt-448)*32:
                       (352<=h_cnt && h_cnt<=383 && 384<=v_cnt && v_cnt<=415) ?1055-(h_cnt-352)+(v_cnt-384)*32:
                       (352<=h_cnt && h_cnt<=383 && 416<=v_cnt && v_cnt<=447) ?4127-(h_cnt-352)+(v_cnt-416)*32:
                       (352<=h_cnt && h_cnt<=383 && 448<=v_cnt && v_cnt<=479) ?4127-(h_cnt-352)+(v_cnt-448)*32:
                       (384<=h_cnt && h_cnt<=415 && 384<=v_cnt && v_cnt<=415) ?31-(h_cnt-384)+(v_cnt-384)*32:
                       (288<=h_cnt && h_cnt<=383 && 352<=v_cnt && v_cnt<=383) ?(h_cnt%32)+8192+(v_cnt-352)*32://中下
                       (512<=h_cnt && h_cnt<=543 && 384<=v_cnt && v_cnt<=415) ?(h_cnt-512)+(v_cnt-384)*32:
                       (544<=h_cnt && h_cnt<=575 && 384<=v_cnt && v_cnt<=415) ?(h_cnt-544)+1024+(v_cnt-384)*32:
                       (544<=h_cnt && h_cnt<=575 && 416<=v_cnt && v_cnt<=447) ?(h_cnt-544)+4096+(v_cnt-416)*32:
                       (544<=h_cnt && h_cnt<=575 && 448<=v_cnt && v_cnt<=479) ?(h_cnt-544)+4096+(v_cnt-448)*32:
                       (576<=h_cnt && h_cnt<=639 && 384<=v_cnt && v_cnt<=415) ?(h_cnt%32)+2048+(v_cnt-384)*32:
                       (576<=h_cnt && h_cnt<=639 && 416<=v_cnt && v_cnt<=447) ?(h_cnt%32)+3072+(v_cnt-416)*32:
                       (576<=h_cnt && h_cnt<=639 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+3072+(v_cnt-448)*32:
                       (512<=h_cnt && h_cnt<=543 && 352<=v_cnt && v_cnt<=383) ?(h_cnt-512)+6144+(v_cnt-352)*32:
                       (544<=h_cnt && h_cnt<=607 && 352<=v_cnt && v_cnt<=383) ?(h_cnt%32)+8192+(v_cnt-352)*32:
                       (608<=h_cnt && h_cnt<=639 && 352<=v_cnt && v_cnt<=383) ?(h_cnt-608)+7168+(v_cnt-352)*32://右下
                       (128<=h_cnt && h_cnt<=287 && 416<=v_cnt && v_cnt<=447) ?(h_cnt%32)+9216+(v_cnt-416)*32:
                       (384<=h_cnt && h_cnt<=543 && 416<=v_cnt && v_cnt<=447) ?(h_cnt%32)+9216+(v_cnt-416)*32:
                       (128<=h_cnt && h_cnt<=159 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+10240+(v_cnt-448)*32:
                       (224<=h_cnt && h_cnt<=255 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+10240+(v_cnt-448)*32:
                       (416<=h_cnt && h_cnt<=447 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+10240+(v_cnt-448)*32:
                       (512<=h_cnt && h_cnt<=543 && 448<=v_cnt && v_cnt<=479) ?(h_cnt%32)+10240+(v_cnt-448)*32:
                       (160<=h_cnt && h_cnt<=223 && 448<=v_cnt && v_cnt<=479) ?10239:
                       (256<=h_cnt && h_cnt<=287 && 448<=v_cnt && v_cnt<=479) ?10239:
                       (384<=h_cnt && h_cnt<=415 && 448<=v_cnt && v_cnt<=479) ?10239:
                       (448<=h_cnt && h_cnt<=511 && 448<=v_cnt && v_cnt<=479) ?10239://SEA
                       (544<=h_cnt && h_cnt<=575 && 160<=v_cnt && v_cnt<=191) ?(h_cnt-544)+(v_cnt-160)*32:
                       (576<=h_cnt && h_cnt<=607 && 160<=v_cnt && v_cnt<=191) ?(h_cnt-576)+1024+(v_cnt-160)*32:
                       (608<=h_cnt && h_cnt<=639 && 160<=v_cnt && v_cnt<=191) ?1055-(h_cnt-608)+(v_cnt-160)*32:
                       (576<=h_cnt && h_cnt<=607 && 192<=v_cnt && v_cnt<=223) ?(h_cnt-576)+5120+(v_cnt-192)*32:
                       (608<=h_cnt && h_cnt<=639 && 192<=v_cnt && v_cnt<=223) ?5151-(h_cnt-608)+(v_cnt-192)*32:
                       (544<=h_cnt && h_cnt<=639 && 64<=v_cnt && v_cnt<=159) ?(h_cnt-544)+11264+(v_cnt-64)*96://右上
                       (384<=h_cnt && h_cnt<=415 && 160<=v_cnt && v_cnt<=191) ?(h_cnt-384)+(v_cnt-160)*32:
                       (416<=h_cnt && h_cnt<=447 && 160<=v_cnt && v_cnt<=191) ?31-(h_cnt-416)+(v_cnt-160)*32:
                       (384<=h_cnt && h_cnt<=415 && 128<=v_cnt && v_cnt<=159) ?(h_cnt-384)+6144+(v_cnt-128)*32:
                       (416<=h_cnt && h_cnt<=447 && 128<=v_cnt && v_cnt<=159) ?(h_cnt-416)+8192+(v_cnt-128)*32://上右2
                       (64<=h_cnt && h_cnt<=95 && 160<=v_cnt && v_cnt<=191) ?(h_cnt-64)+(v_cnt-160)*32:
                       (96<=h_cnt && h_cnt<=127 && 160<=v_cnt && v_cnt<=191) ?31-(h_cnt-96)+(v_cnt-160)*32:
                       (64<=h_cnt && h_cnt<=95 && 128<=v_cnt && v_cnt<=159) ?(h_cnt-64)+7168+(v_cnt-128)*32:
                       (96<=h_cnt && h_cnt<=127 && 128<=v_cnt && v_cnt<=159) ?(h_cnt-96)+8192+(v_cnt-128)*32://左上
                       (224<=h_cnt && h_cnt<=255 && 160<=v_cnt && v_cnt<=191) ?(h_cnt-224)+(v_cnt-160)*32:
                       (256<=h_cnt && h_cnt<=287 && 160<=v_cnt && v_cnt<=191) ?31-(h_cnt-256)+(v_cnt-160)*32:
                       (224<=h_cnt && h_cnt<=287 && 128<=v_cnt && v_cnt<=159) ?(h_cnt%32)+8192+(v_cnt-128)*32://上左2
                       (0<=h_cnt && h_cnt<=159 && 192<=v_cnt && v_cnt<=255) ?(h_cnt-0)+20480+(v_cnt-192)*160:
                       (288<=h_cnt && h_cnt<=447 && 224<=v_cnt && v_cnt<=287) ?(h_cnt-288)+20480+(v_cnt-224)*160:
                       (64<=h_cnt && h_cnt<=223 && 32<=v_cnt && v_cnt<=95) ?(h_cnt-64)+20480+(v_cnt-32)*160:
                       (352<=h_cnt && h_cnt<=511 && 0<=v_cnt && v_cnt<=63) ?(h_cnt-352)+20480+(v_cnt)*160://cloud
                       (192<=h_cnt && h_cnt<=223 && 352-position2<=v_cnt && v_cnt<=383-position2) ?(h_cnt-192)+30720+(v_cnt-352+position2)*32:
                       (448<=h_cnt && h_cnt<=479 && 352-position2<=v_cnt && v_cnt<=383-position2) ?(h_cnt-448)+30720+(v_cnt-352+position2)*32://elavator
                       20480;
   
   
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
