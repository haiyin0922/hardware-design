module project(
     input button_UP,
     input button_DOWN,
     input button_LEFT,
     input button_RIGHT,
     input button_ATTACK,
     input clk,
     input rst,
     input [2:0] volume,
     inout wire PS2_DATA,
     inout wire PS2_CLK,
     output [3:0] vgaRed,
     output [3:0] vgaGreen,
     output [3:0] vgaBlue,
     output hsync,
     output vsync,
     output [15:0]led,
     output [6:0] DISPLAY,
     output [3:0] DIGIT,
     output audio_mclk, // master clock
     output audio_lrck, // left-right clock
     output audio_sck, // serial clock
     output audio_sdin
    );
    

    wire [11:0] data1 , data2 , data3 ;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr1 , pixel_addr2 , pixel_addr3;
    wire [11:0] pixel1 , pixel2 , pixel3;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [8:0] elevatorposition2;
    wire [10:0] player1position1 , player1position2 , player2position1 , player2position2;
    wire player1direct , player1attack , player2direct , player2attack;
    wire [10:0] fire_player1position1 , fire_player1position2 , fire_player2position1 , fire_player2position2;
    wire player2win, player1win;
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    
    reg [2:0] state , next_state;
    reg [3:0] vgaRed, vgaGreen, vgaBlue;
    reg [15:0] led , next_led;
    reg [1:0] ledstate1 , next_ledstate1 , ledstate2 , next_ledstate2;
    reg [25:0] clkcount1 , next_clkcount1 , clkcount2 , next_clkcount2;
    reg flag;
    
    parameter RESET=3'b000 , START=3'b001 , FIRE=3'b010 , END1=3'b011 , END2=3'b100;
    parameter  KEYCODE_ENTER = 9'b0_0101_1010 ,  KEYCODE_G = 9'b0_0011_0100;
    
    clock_divider #(27) clkdiv(.clk(clk), .clk_div(clk27));
    
    always@(posedge clk , posedge rst)begin
        if(rst)begin
            state <= RESET; 
        end
        else begin
            state <= next_state;
        end
    end
    
    always@(*)begin
        next_state = state;
        flag = 0;
        case(state)
            RESET:begin
                flag = 1;
                next_state = (been_ready && key_down[KEYCODE_ENTER]) ?START:RESET;
                if(!valid || !clk27 && v_cnt>=218 && v_cnt<=253 && h_cnt>=202 && h_cnt<=348)
                    {vgaRed, vgaGreen, vgaBlue} = 12'h0;          
                else if(v_cnt>=218 && v_cnt<=220 && (h_cnt>=25 && h_cnt<=42 || h_cnt>=55 && h_cnt<=72 || h_cnt>=85 && h_cnt<=108 || 
                       h_cnt>=121 && h_cnt<=132 || h_cnt>=151 && h_cnt<=162 || h_cnt>=205 && h_cnt<=228 || h_cnt>=235 && h_cnt<=240 ||
                       h_cnt>=253 && h_cnt<=258 || h_cnt>=265 && h_cnt<=288 || h_cnt>=295 && h_cnt<=318 || h_cnt>=325 && h_cnt<=342 ||
                       h_cnt>=385 && h_cnt<=408 || h_cnt>=421 && h_cnt<=432 || h_cnt>=481 && h_cnt<=492 || h_cnt>=505 && h_cnt<=528 ||
                       h_cnt>=544 && h_cnt<=549 || h_cnt>=565 && h_cnt<=582 || h_cnt>=595 && h_cnt<=618) ||
                       v_cnt>=221 && v_cnt<=223 && (h_cnt>=25 && h_cnt<=45 || h_cnt>=55 && h_cnt<=75 || h_cnt>=85 && h_cnt<=108 ||
                       h_cnt>=118 && h_cnt<=135 || h_cnt>=148 && h_cnt<=165 || h_cnt>=205 && h_cnt<=228 || h_cnt>=235 && h_cnt<=243 ||
                       h_cnt>=253 && h_cnt<=258 || h_cnt>=265 && h_cnt<=288 || h_cnt>=295 && h_cnt<=318 || h_cnt>=325 && h_cnt<=345 ||
                       h_cnt>=385 && h_cnt<=408 || h_cnt>=418 && h_cnt<=435 || h_cnt>=478 && h_cnt<=495 || h_cnt>=505 && h_cnt<=528 ||
                       h_cnt>=541 && h_cnt<=552 || h_cnt>=565 && h_cnt<=585 || h_cnt>= 595&& h_cnt<=618) ||
                       v_cnt>=224 && v_cnt<=226 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=40 && h_cnt<=48 || h_cnt>=55 && h_cnt<=60 ||
                       h_cnt>=70 && h_cnt<=78 || h_cnt>=85 && h_cnt<=90 || h_cnt>=115 && h_cnt<=123 || h_cnt>=130 && h_cnt<=138 ||
                       h_cnt>=145 && h_cnt<=153 || h_cnt>=160 && h_cnt<=168 || h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=243 ||
                       h_cnt>=253 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=330 ||
                       h_cnt>=340 && h_cnt<=348 || h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=423 || h_cnt>=430 && h_cnt<=438 ||
                       h_cnt>=475 && h_cnt<=483 || h_cnt>=490 && h_cnt<=498 || h_cnt>=514 && h_cnt<=519 || h_cnt>=538 && h_cnt<=543 ||
                       h_cnt>=550 && h_cnt<= 555 || h_cnt>=565 && h_cnt<=570 || h_cnt>=580 && h_cnt<=588 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=227 && v_cnt<=229 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=43 && h_cnt<=48 || h_cnt>=55 && h_cnt<=60 ||
                       h_cnt>=73 && h_cnt<=78 || h_cnt>=85 && h_cnt<=90 || h_cnt>=115 && h_cnt<=123 || h_cnt>=145 && h_cnt<=153 ||
                       h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=246 || h_cnt>=253 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 ||
                       h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=330 || h_cnt>=343 && h_cnt<=348 || h_cnt>=394 && h_cnt<=399 ||
                       h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 || h_cnt>=475 && h_cnt<=483 || h_cnt>=514 && h_cnt<=519 ||
                       h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<= 558 || h_cnt>=565 && h_cnt<=570 || h_cnt>=583 && h_cnt<=588 ||
                       h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=230 && v_cnt<=232 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=43 && h_cnt<=48 || h_cnt>=55 && h_cnt<=60 ||
                       h_cnt>=73 && h_cnt<=78 || h_cnt>=85 && h_cnt<=90 || h_cnt>=118 && h_cnt<=126 || h_cnt>=148 && h_cnt<=156 ||
                       h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=246 || h_cnt>=253 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 ||
                       h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=330 || h_cnt>=343 && h_cnt<=348 || h_cnt>=394 && h_cnt<=399 ||
                       h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 || h_cnt>=478 && h_cnt<=486 || h_cnt>=514 && h_cnt<=519 ||
                       h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<= 558 || h_cnt>=565 && h_cnt<=570 || h_cnt>=583 && h_cnt<=588 ||
                       h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=233 && v_cnt<=235 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=40 && h_cnt<=48 || h_cnt>=55 && h_cnt<=60 ||
                       h_cnt>=70 && h_cnt<=78 || h_cnt>=85 && h_cnt<=102 || h_cnt>=121 && h_cnt<=129 || h_cnt>=151 && h_cnt<=159 ||
                       h_cnt>=205 && h_cnt<=222 || h_cnt>=235 && h_cnt<=240 || h_cnt>=244 && h_cnt<=249 || h_cnt>=253 && h_cnt<=258 ||
                       h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=312 || h_cnt>=325 && h_cnt<=330 || h_cnt>=340 && h_cnt<=348 ||
                       h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 || h_cnt>=481 && h_cnt<=489 ||
                       h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<= 558 || h_cnt>=565 && h_cnt<=570 ||
                       h_cnt>=580 && h_cnt<=588 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=236 && v_cnt<=238 && (h_cnt>=25 && h_cnt<=45 || h_cnt>=55 && h_cnt<=75 || h_cnt>=85 && h_cnt<=102 ||
                       h_cnt>=127 && h_cnt<=132 || h_cnt>=157 && h_cnt<=162 || h_cnt>=205 && h_cnt<=222 || h_cnt>=235 && h_cnt<=240 ||
                       h_cnt>=244 && h_cnt<=249 || h_cnt>=253 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=312 ||
                       h_cnt>=325 && h_cnt<=345 || h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 ||
                       h_cnt>=487 && h_cnt<=492 || h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<= 558 ||
                       h_cnt>=565 && h_cnt<=585 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=239 && v_cnt<=241 && (h_cnt>=25 && h_cnt<=42 || h_cnt>=55 && h_cnt<=72 || h_cnt>=85 && h_cnt<=90 ||
                       h_cnt>=130 && h_cnt<=135 || h_cnt>=160 && h_cnt<=165 || h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=240 ||
                       h_cnt>=247 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=342 ||
                       h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 || h_cnt>=490 && h_cnt<=495 ||
                       h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=558 || h_cnt>=565 && h_cnt<=582 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=242 && v_cnt<=244 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=55 && h_cnt<=60 ||
                       h_cnt>=70 && h_cnt<=75 || h_cnt>=85 && h_cnt<=90 || h_cnt>=130 && h_cnt<=138 ||
                       h_cnt>=160 && h_cnt<=168 || h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=240 ||
                       h_cnt>=247 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=330 ||
                       h_cnt>=340 && h_cnt<=345 || h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=420 || h_cnt>=433 && h_cnt<=438 ||
                       h_cnt>=490 && h_cnt<=498 || h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=558 ||
                       h_cnt>=565 && h_cnt<=570 || h_cnt>=580 && h_cnt<=585 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=245 && v_cnt<=247 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=55 && h_cnt<=60 || h_cnt>=73 && h_cnt<=78 ||
                       h_cnt>=85 && h_cnt<=90 || h_cnt>=115 && h_cnt<=123 || h_cnt>=130 && h_cnt<=138 || h_cnt>=145 && h_cnt<=153 ||
                       h_cnt>=160 && h_cnt<=168 || h_cnt>=205 && h_cnt<=210 || h_cnt>=235 && h_cnt<=240 || h_cnt>=250 && h_cnt<=258 ||
                       h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=300 || h_cnt>=325 && h_cnt<=330 || h_cnt>=343 && h_cnt<=348 ||
                       h_cnt>=394 && h_cnt<=399 || h_cnt>=415 && h_cnt<=423 || h_cnt>=430 && h_cnt<=438 || h_cnt>=475 && h_cnt<=483 ||
                       h_cnt>=490 && h_cnt<=498 || h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<= 558 ||
                       h_cnt>=565 && h_cnt<=570 || h_cnt>=583 && h_cnt<=588 || h_cnt>=604 && h_cnt<=609) ||
                       v_cnt>=248 && v_cnt<=250 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=55 && h_cnt<=60 || h_cnt>=73 && h_cnt<=78 ||
                       h_cnt>=85 && h_cnt<=108 || h_cnt>=118 && h_cnt<=135 || h_cnt>=148 && h_cnt<=165 || h_cnt>=205 && h_cnt<=228 ||
                       h_cnt>=235 && h_cnt<=240 || h_cnt>=250 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=318 ||
                       h_cnt>=325 && h_cnt<=330 || h_cnt>=343 && h_cnt<=348 || h_cnt>=394 && h_cnt<=399 || h_cnt>=418 && h_cnt<=435 ||
                       h_cnt>=478 && h_cnt<=495 || h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<=558 ||
                       h_cnt>=565 && h_cnt<=570 || h_cnt>=583 && h_cnt<=588 || h_cnt>= 604&& h_cnt<=609) ||
                       v_cnt>=251 && v_cnt<=253 && (h_cnt>=25 && h_cnt<=30 || h_cnt>=55 && h_cnt<=60 || h_cnt>=73 && h_cnt<=78 ||
                       h_cnt>=85 && h_cnt<=108 || h_cnt>=121 && h_cnt<=132 || h_cnt>=151 && h_cnt<=162 || h_cnt>=205 && h_cnt<=228 ||
                       h_cnt>=235 && h_cnt<=240 || h_cnt>=253 && h_cnt<=258 || h_cnt>=274 && h_cnt<=279 || h_cnt>=295 && h_cnt<=318 ||
                       h_cnt>=325 && h_cnt<=330 || h_cnt>=343 && h_cnt<=348 || h_cnt>=394 && h_cnt<=399 || h_cnt>=421 && h_cnt<=432 ||
                       h_cnt>=481 && h_cnt<=492 || h_cnt>=514 && h_cnt<=519 || h_cnt>=535 && h_cnt<=540 || h_cnt>=553 && h_cnt<=558 ||
                       h_cnt>=565 && h_cnt<=570 || h_cnt>=583 && h_cnt<=588 || h_cnt>= 604 && h_cnt<=609))
                    {vgaRed, vgaGreen, vgaBlue} = 12'hFE3;
                else
                    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            end
            START:begin
                next_state = (player1win) ?END1:(player2win) ?END2:START;
                {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1 && fire_player1position1<=h_cnt && h_cnt<=39+fire_player1position1 && 420-fire_player1position2<=v_cnt && v_cnt<=449-fire_player1position2 && pixel3!=12'h5BF) ?pixel3:
                                              (valid==1'b1 && fire_player1position1<=h_cnt && h_cnt<=39+fire_player1position1 && 420-fire_player1position2<=v_cnt && v_cnt<=449-fire_player1position2 && pixel3==12'h5BF) ?pixel1://fire1
                                              (valid==1'b1 && fire_player2position1<=h_cnt && h_cnt<=39+fire_player2position1 && 420-fire_player2position2<=v_cnt && v_cnt<=449-fire_player2position2 && pixel2!=12'h5BF) ?pixel2:
                                              (valid==1'b1 && fire_player2position1<=h_cnt && h_cnt<=39+fire_player2position1 && 420-fire_player2position2<=v_cnt && v_cnt<=449-fire_player2position2 && pixel2==12'h5BF) ?pixel1://fire1
                                              (valid==1'b1 && player1position1<=h_cnt && h_cnt<=39+player1position1 && 420-player1position2<=v_cnt && v_cnt<=479-player1position2 && (player2position1<=player1position1 && player1position1<=player2position1+39 && 420-player2position2<=479-player1position2 && 479-player1position2<=479-player2position2 || player2position1<=player1position1 && player1position1<=player2position1+39 && 420-player2position2<=420-player1position2 && 420-player1position2<=479-player2position2 || player2position1<=player1position1+39 && player1position1+39<=player2position1+39 && 420-player2position2<=479-player1position2 && 479-player1position2<=479-player2position2 || player2position1<=player1position1+39 && player1position1+39<=player2position1+39 && 420-player2position2<=420-player1position2 && 420-player1position2<=479-player2position2) && pixel3!=12'h5BF) ?pixel3:
                                              (valid==1'b1 && player1position1<=h_cnt && h_cnt<=39+player1position1 && 420-player1position2<=v_cnt && v_cnt<=479-player1position2 && (player2position1<=player1position1 && player1position1<=player2position1+39 && 420-player2position2<=479-player1position2 && 479-player1position2<=479-player2position2 || player2position1<=player1position1 && player1position1<=player2position1+39 && 420-player2position2<=420-player1position2 && 420-player1position2<=479-player2position2 || player2position1<=player1position1+39 && player1position1+39<=player2position1+39 && 420-player2position2<=479-player1position2 && 479-player1position2<=479-player2position2 || player2position1<=player1position1+39 && player1position1+39<=player2position1+39 && 420-player2position2<=420-player1position2 && 420-player1position2<=479-player2position2) && pixel3==12'h5BF && player2position1<=h_cnt && h_cnt<=39+player2position1 && 420-player2position2<=v_cnt && v_cnt<=479-player2position2 && pixel2!=12'h5BF) ?pixel2:
                                              (valid==1'b1 && (player1position1<=h_cnt && h_cnt<=39+player1position1 && 420-player1position2<=v_cnt && v_cnt<=479-player1position2 || player2position1<=h_cnt && h_cnt<=39+player2position1 && 420-player2position2<=v_cnt && v_cnt<=479-player2position2) && pixel3==12'h5BF && pixel2==12'h5BF) ?pixel1://cover
                                              (valid==1'b1 && player1position1<=h_cnt && h_cnt<=39+player1position1 && 420-player1position2<=v_cnt && v_cnt<=479-player1position2 && pixel3!=12'h5BF) ?pixel3:
                                              (valid==1'b1 && player1position1<=h_cnt && h_cnt<=39+player1position1 && 420-player1position2<=v_cnt && v_cnt<=479-player1position2 && pixel3==12'h5BF) ?pixel1://player1
                                              (valid==1'b1 && player2position1<=h_cnt && h_cnt<=39+player2position1 && 420-player2position2<=v_cnt && v_cnt<=479-player2position2 && pixel2!=12'h5BF) ?pixel2:
                                              (valid==1'b1 && player2position1<=h_cnt && h_cnt<=39+player2position1 && 420-player2position2<=v_cnt && v_cnt<=479-player2position2 && pixel2==12'h5BF) ?pixel1://player2
                                              (valid==1'b1) ?pixel1:
                                              12'h0;
                
            end
            END1:begin
                 if(!valid)
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;            
                    else if(v_cnt>=198 && v_cnt<=203 && (h_cnt>=436 && h_cnt<=445) ||
                           v_cnt>=204 && v_cnt<=209 && (h_cnt>=106 && h_cnt<=125 || h_cnt>=436 && h_cnt<=445 || h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=210 && v_cnt<=215 && (h_cnt>=116 && h_cnt<=125 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=216 && v_cnt<=221 && (h_cnt>=66 && h_cnt<=90 || h_cnt>=116 && h_cnt<=125 || h_cnt>=151 && h_cnt<=170 || 
                           h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=231 && h_cnt<=250 || h_cnt>=266 && h_cnt<=275 ||
                           h_cnt>=286 && h_cnt<=295 || h_cnt>=386 && h_cnt<=395 || h_cnt>=411 && h_cnt<=420 || h_cnt>=426 && h_cnt<=445 ||
                           h_cnt>=466 && h_cnt<=490 || h_cnt>=511 && h_cnt<=535 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=222 && v_cnt<=227 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=235 ||
                           h_cnt>=246 && h_cnt<=255 || h_cnt>=266 && h_cnt<=275 || h_cnt>=281 && h_cnt<=295 || h_cnt>=386 && h_cnt<=395 ||
                           h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 ||
                           h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=515 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=228 && v_cnt<=233 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=235 ||
                           h_cnt>=246 && h_cnt<=255 || h_cnt>=266 && h_cnt<=280 || h_cnt>=386 && h_cnt<=395 ||
                           h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 ||
                           h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=515 || h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=234 && v_cnt<=239 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=151 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=255 ||
                           h_cnt>=266 && h_cnt<=275 || h_cnt>=386 && h_cnt<=395 || h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 ||
                           h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=511 && h_cnt<=530 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=240 && v_cnt<=245 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=146 && h_cnt<=155 || h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 ||
                           h_cnt>=226 && h_cnt<=235 || h_cnt>=266 && h_cnt<=275 || h_cnt>=386 && h_cnt<=395 || h_cnt>=401 && h_cnt<=405 ||
                           h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 ||
                           h_cnt>=526 && h_cnt<=535) ||
                           v_cnt>=246 && v_cnt<=251 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=146 && h_cnt<=155 || h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 ||
                           h_cnt>=226 && h_cnt<=235 || h_cnt>=266 && h_cnt<=275 || h_cnt>=391 && h_cnt<=400 || h_cnt>=406 && h_cnt<=415 ||
                           h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=526 && h_cnt<=535 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=252 && v_cnt<=257 && (h_cnt>=66 && h_cnt<=90 || h_cnt>=106 && h_cnt<=135 ||
                           h_cnt>=151 && h_cnt<=175 || h_cnt>=191 && h_cnt<=210 ||
                           h_cnt>=231 && h_cnt<=250 || h_cnt>=266 && h_cnt<=275 || h_cnt>=391 && h_cnt<=400 || h_cnt>=406 && h_cnt<=415 ||
                           h_cnt>=426 && h_cnt<=455 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=530 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=258 && v_cnt<=263 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=201 && h_cnt<=210) ||
                           v_cnt>=264 && v_cnt<=269 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=196 && h_cnt<=205) ||
                           v_cnt>=270 && v_cnt<=281 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=181 && h_cnt<=200) ||
                           h_cnt>=306 && h_cnt<=315 && v_cnt>=216 && v_cnt<=221 ||
                           h_cnt>=316 && h_cnt<=320 && v_cnt>=210 && v_cnt<=221 ||
                           h_cnt>=321 && h_cnt<=330 && v_cnt>=204 && v_cnt<=257)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hFE3;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            end
            END2:begin
                 if(!valid)
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;            
                    else if(v_cnt>=198 && v_cnt<=203 && (h_cnt>=436 && h_cnt<=445) ||
                           v_cnt>=204 && v_cnt<=209 && (h_cnt>=106 && h_cnt<=125 || h_cnt>=436 && h_cnt<=445 || h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=210 && v_cnt<=215 && (h_cnt>=116 && h_cnt<=125 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=216 && v_cnt<=221 && (h_cnt>=66 && h_cnt<=90 || h_cnt>=116 && h_cnt<=125 || h_cnt>=151 && h_cnt<=170 || 
                           h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=231 && h_cnt<=250 || h_cnt>=266 && h_cnt<=275 ||
                           h_cnt>=286 && h_cnt<=295 || h_cnt>=386 && h_cnt<=395 || h_cnt>=411 && h_cnt<=420 || h_cnt>=426 && h_cnt<=445 ||
                           h_cnt>=466 && h_cnt<=490 || h_cnt>=511 && h_cnt<=535 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=222 && v_cnt<=227 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=235 ||
                           h_cnt>=246 && h_cnt<=255 || h_cnt>=266 && h_cnt<=275 || h_cnt>=281 && h_cnt<=295 || h_cnt>=386 && h_cnt<=395 ||
                           h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 ||
                           h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=515 || h_cnt>=551 && h_cnt<=570) ||
                           v_cnt>=228 && v_cnt<=233 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=235 ||
                           h_cnt>=246 && h_cnt<=255 || h_cnt>=266 && h_cnt<=280 || h_cnt>=386 && h_cnt<=395 ||
                           h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 ||
                           h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=515 || h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=234 && v_cnt<=239 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=151 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 || h_cnt>=226 && h_cnt<=255 ||
                           h_cnt>=266 && h_cnt<=275 || h_cnt>=386 && h_cnt<=395 || h_cnt>=401 && h_cnt<=405 || h_cnt>=411 && h_cnt<=420 ||
                           h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=511 && h_cnt<=530 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=240 && v_cnt<=245 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=146 && h_cnt<=155 || h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 ||
                           h_cnt>=226 && h_cnt<=235 || h_cnt>=266 && h_cnt<=275 || h_cnt>=386 && h_cnt<=395 || h_cnt>=401 && h_cnt<=405 ||
                           h_cnt>=411 && h_cnt<=420 || h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 ||
                           h_cnt>=526 && h_cnt<=535) ||
                           v_cnt>=246 && v_cnt<=251 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=86 && h_cnt<=95 || h_cnt>=116 && h_cnt<=125 ||
                           h_cnt>=146 && h_cnt<=155 || h_cnt>=166 && h_cnt<=175 || h_cnt>=186 && h_cnt<=195 || h_cnt>=206 && h_cnt<=215 ||
                           h_cnt>=226 && h_cnt<=235 || h_cnt>=266 && h_cnt<=275 || h_cnt>=391 && h_cnt<=400 || h_cnt>=406 && h_cnt<=415 ||
                           h_cnt>=436 && h_cnt<=445 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=526 && h_cnt<=535 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=252 && v_cnt<=257 && (h_cnt>=66 && h_cnt<=90 || h_cnt>=106 && h_cnt<=135 ||
                           h_cnt>=151 && h_cnt<=175 || h_cnt>=191 && h_cnt<=210 ||
                           h_cnt>=231 && h_cnt<=250 || h_cnt>=266 && h_cnt<=275 || h_cnt>=391 && h_cnt<=400 || h_cnt>=406 && h_cnt<=415 ||
                           h_cnt>=426 && h_cnt<=455 || h_cnt>=466 && h_cnt<=475 || h_cnt>=486 && h_cnt<=495 || h_cnt>=506 && h_cnt<=530 ||
                           h_cnt>=556 && h_cnt<=565) ||
                           v_cnt>=258 && v_cnt<=263 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=201 && h_cnt<=210) ||
                           v_cnt>=264 && v_cnt<=269 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=196 && h_cnt<=205) ||
                           v_cnt>=270 && v_cnt<=281 && (h_cnt>=66 && h_cnt<=75 || h_cnt>=181 && h_cnt<=200) ||
                           h_cnt>=306 && h_cnt<=315 && (v_cnt>=210 && v_cnt<=221 || v_cnt>=246 && v_cnt<=257) ||
                           h_cnt>=311 && h_cnt<=315 && (v_cnt>=204 && v_cnt<=221 || v_cnt>=240 && v_cnt<=257) ||
                           h_cnt>=316 && h_cnt<=320 && (v_cnt>=204 && v_cnt<=209 || v_cnt>=234 && v_cnt<=245 || v_cnt>=252 && v_cnt<=257) ||
                           h_cnt>=321 && h_cnt<=325 && (v_cnt>=204 && v_cnt<=209 || v_cnt>=228 && v_cnt<=239 || v_cnt>=252 && v_cnt<=257) ||
                           h_cnt>=326 && h_cnt<=330 && (v_cnt>=204 && v_cnt<=233 || v_cnt>=252 && v_cnt<=257) ||
                           h_cnt>=331 && h_cnt<=335 && (v_cnt>=210 && v_cnt<=227 || v_cnt>=252 && v_cnt<=257))
                        {vgaRed, vgaGreen, vgaBlue} = 12'hFE3;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            end
        endcase
    end
    
    always@(posedge clk , posedge rst)begin
        if(rst)begin
            ledstate1<= RESET;
            ledstate2 <= RESET;
            led <= 0;
            clkcount1 <= 0;
            clkcount2 <= 0;
        end
        else begin
            ledstate1 <= next_ledstate1;
            ledstate2 <= next_ledstate2;
            led <= next_led;
            clkcount1 <= next_clkcount1;
            clkcount2 <= next_clkcount2;
        end
    end
    
    always@(*)begin
        next_ledstate1 = ledstate1;
        next_led[15:8] = led[15:8];
        next_clkcount1 = clkcount1;
        case(ledstate1)
            RESET:begin
                next_ledstate1 = (been_ready && key_down[KEYCODE_ENTER]) ?START:RESET;
                next_led[15:8] = (been_ready && key_down[KEYCODE_ENTER]) ?8'b1111_1111:8'b0000_0000;
            end
            START:begin
                next_ledstate1 = (been_ready && key_down[KEYCODE_G]) ?FIRE:START;
                next_led[15:8] = (been_ready && key_down[KEYCODE_G]) ?8'b0000_0000:8'b1111_1111;
                next_clkcount1 = 0;
            end
            FIRE:begin
                next_ledstate1 = (clkcount1==33554431 && led[15:8]==8'b1111_1111) ?START:FIRE;
                next_led[15:8] = (clkcount1==33554431) ?(led[15:8]<<1)+1:led[15:8];
                next_clkcount1 = (clkcount1!=33554431) ?clkcount1+1:0;
            end
        endcase
    end
    
    always@(*)begin
        next_ledstate2 = ledstate2;
        next_led[7:0] = led[7:0];
        next_clkcount2 = clkcount2;
        case(ledstate2)
            RESET:begin
                next_ledstate2 = (been_ready && key_down[KEYCODE_ENTER]) ?FIRE:RESET;
                next_led[7:0] = (been_ready && key_down[KEYCODE_ENTER]) ?8'b1111_1111:8'b0000_0000;
            end
            START:begin
                next_ledstate2 = (button_ATTACK) ?FIRE:START;
                next_led[7:0] = (button_ATTACK) ?8'b0000_0000:8'b1111_1111;
                next_clkcount2 = 0;
            end
            FIRE:begin
                next_ledstate2 = (clkcount2==33554431 && led[7:0]==8'b1111_1111) ?START:FIRE;
                next_led[7:0] = (clkcount2==33554431) ?(led[7:0]<<1)+1:led[7:0];
                next_clkcount2 = (clkcount2!=33554431) ?clkcount2+1:0;
            end
        endcase
    end
 
    KeyboardDecoder key_de (
     .key_down(key_down),
     .last_change(last_change),
     .key_valid(been_ready),
     .PS2_DATA(PS2_DATA),
     .PS2_CLK(PS2_CLK),
     .rst(rst),
     .clk(clk)
     );
    
     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );
    
    player1 player1(
      .player2attack(player2attack),
      .player2direct(player2direct),
      .fire2position1(fire_player2position1),
      .fire2position2(fire_player2position2),
      .player2position1(player2position1),
      .player2position2(player2position2),
      .led(led[15:8]),
      .key_down(key_down),
      .been_ready(been_ready),
      .elevatortop(352-elevatorposition2),
      .elevatorbottom(383-elevatorposition2),
      .clk(clk),
      .rst(been_ready && key_down[KEYCODE_ENTER]),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .pixel_addr(pixel_addr3),
      .position1(player1position1),
      .position2(player1position2),
      .direct(player1direct),
      .fireposition1(fire_player1position1),
      .fireposition2(fire_player1position2),
      .player1attack(player1attack),
      .player2win(player2win)
    );
    
    player2 player2(
      .player1attack(player1attack),
      .player1direct(player1direct),
      .fire1position1(fire_player1position1),
      .fire1position2(fire_player1position2),
      .player1position1(player1position1),
      .player1position2(player1position2),
      .led(led[7:0]),
      .button_UP(button_UP),
      .button_DOWN(button_DOWN),
      .button_LEFT(button_LEFT), 
      .button_RIGHT(button_RIGHT),
      .button_ATTACK(button_ATTACK),
      .elevatortop(352-elevatorposition2),
      .elevatorbottom(383-elevatorposition2),
      .clk(clk),
      .rst(been_ready && key_down[KEYCODE_ENTER]),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .pixel_addr(pixel_addr2),
      .position1(player2position1),
      .position2(player2position2),
      .direct(player2direct),
      .fireposition1(fire_player2position1),
      .fireposition2(fire_player2position2),
      .player2attack(player2attack),
      .player1win(player1win)
    );

    background background(
    .clk(clk_22),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr1),
    .position2(elevatorposition2)
    );
   
     
 
    blk_mem_gen_0 background1(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr1),
      .dina(data1[11:0]),
      .douta(pixel1)
    ); 
    
    blk_mem_gen_1 person2(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr2),
          .dina(data2[11:0]),
          .douta(pixel2)
    );
    
    blk_mem_gen_1 person1(
              .clka(clk_25MHz),
              .wea(0),
              .addra(pixel_addr3),
              .dina(data3[11:0]),
              .douta(pixel3)
    );

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
    
    sevenseg seven(
     .clk(clk),
     .rst(rst),
     .DIGIT(DIGIT),
     .DISPLAY(DISPLAY)
     );
     
     musictop music(
       .clk(clk), // clock from crystal
       .rst(rst), // active high reset
       .volume(volume),
       .audio_mclk(audio_mclk), // master clock
       .audio_lrck(audio_lrck), // left-right clock
       .audio_sck(audio_sck), // serial clock
       .audio_sdin(audio_sdin) // serial audio data input
     );
      
endmodule

