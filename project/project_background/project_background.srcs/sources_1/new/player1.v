module player1(
    input player2attack,
    input player2direct,
    input [10:0] player2position1,
    input [10:0] player2position2,
    input [10:0] fire2position1,
    input [10:0] fire2position2,
    input [7:0] led,
    input [511:0] key_down,
    input been_ready,
    input clk,
    input rst,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [8:0] elevatortop,
    input [8:0] elevatorbottom,
    output [16:0] pixel_addr,
    output [10:0] position1,
    output [10:0] position2,
    output [10:0] fireposition1,
    output [10:0] fireposition2,
    output direct,
    output player1attack,
    output player2win
    );
    
    parameter RESET = 5'b00000 , RSTAY = 5'b00001 , RIGHT = 5'b00010 , LEFT = 5'b00011 , RJUMP1 = 5'b00100 ,
              RJUMP2 = 5'b00101 , LSTAY = 5'b00110 , LJUMP1 = 5'b00111 , LJUMP2 = 5'b01000 , JUMP1 = 5'b01001 , JUMP2 = 5'b01010 , JUMP11 = 5'b01011 , JUMP22 = 5'b01100 , 
              RATTACK_STAND = 5'b01101 , RATTACK_JUMP1 = 5'b01110 , RATTACK_JUMP2 = 5'b01111 , LATTACK_STAND = 5'b10000 , LATTACK_JUMP1 = 5'b10001 , LATTACK_JUMP2 = 5'b10010 , 
              ATTACK_JUMP1 = 5'b10011 , ATTACK_JUMP2 = 5'b10100 , ATTACK_JUMP11 = 5'b10101 , ATTACK_JUMP22 = 5'b10110 , RFALL = 5'b10111 , LFALL = 5'b11000;
    parameter KEYCODE_W = 9'b0_0001_1101 ,  KEYCODE_S = 9'b0_0001_1011 , KEYCODE_A = 9'b0_0001_1100 , KEYCODE_D = 9'b0_0010_0011 , KEYCODE_G = 9'b0_0011_0100; 
    
    reg signed[10:0] position1 , next_position1 , position2 , next_position2;
    reg [4:0] state , next_state;
    reg [4:0] count1 , next_count1;//motion
    reg [4:0] atkcount1 , next_atkcount1;
    reg [23:0] clkcount , next_clkcount;
    reg direct , next_direct;
    
    parameter RSHOOTING = 5'b00001 , LSHOOTING = 5'b00010;
    
    reg [4:0] firestate , next_firestate;
    reg signed[10:0] fireposition1 , next_fireposition1 , fireposition2 , next_fireposition2;
    reg [17:0] fireclkcount , next_fireclkcount;
    reg player1attack , next_player1attack; 
    reg player2win , next_player2win;
     
     
    assign pixel_addr = (state==RSTAY && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1)+40*(v_cnt-420+position2):
                        (state==LSTAY && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(39-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==RIGHT && count1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+2400)+40*(v_cnt-420+position2):
                        (state==RIGHT && count1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+4800)+40*(v_cnt-420+position2):
                        (state==RIGHT && count1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+7200)+40*(v_cnt-420+position2):
                        (state==RIGHT && count1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+9600)+40*(v_cnt-420+position2):
                        (state==LEFT && count1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(2439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LEFT && count1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(4839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LEFT && count1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(7239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LEFT && count1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(9639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==JUMP1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+12000)+40*(v_cnt-420+position2):
                        (state==JUMP2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+14400)+40*(v_cnt-420+position2):
                        (state==JUMP11 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(12039-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==JUMP22 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(14439-h_cnt+position1)+40*(v_cnt-420+position2):                                           
                        (state==RJUMP1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+12000)+40*(v_cnt-420+position2):
                        (state==RJUMP2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+14400)+40*(v_cnt-420+position2):
                        (state==LJUMP1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(12039-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LJUMP2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(14439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==RATTACK_STAND && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+16800)+40*(v_cnt-420+position2):
                        (state==RATTACK_STAND && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+19200)+40*(v_cnt-420+position2):
                        (state==RATTACK_STAND && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+21600)+40*(v_cnt-420+position2):
                        (state==RATTACK_STAND && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+24000)+40*(v_cnt-420+position2):
                        (state==LATTACK_STAND && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(16839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_STAND && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(19239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_STAND && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(21639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_STAND && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(24039-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP1 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+26400)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP1 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+28800)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP1 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+31200)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP1 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+33600)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP2 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+26400)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP2 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+28800)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP2 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+31200)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP2 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+33600)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP11 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(26439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP11 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(28839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP11 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(31239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP11 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(33639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP22 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(26439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP22 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(28839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP22 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(31239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==ATTACK_JUMP22 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(33639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP1 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+26400)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP1 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+28800)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP1 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+31200)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP1 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+33600)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP2 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+26400)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP2 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+28800)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP2 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+31200)+40*(v_cnt-420+position2):
                        (state==RATTACK_JUMP2 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+33600)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP1 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(26439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP1 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(28839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP1 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(31239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP1 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(33639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP2 && atkcount1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(26439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP2 && atkcount1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(28839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP2 && atkcount1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(31239-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LATTACK_JUMP2 && atkcount1==3 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(33639-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==RFALL && count1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+36000)+40*(v_cnt-420+position2):
                        (state==RFALL && count1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+38400)+40*(v_cnt-420+position2):
                        (state==RFALL && count1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(h_cnt-position1+40800)+40*(v_cnt-420+position2):
                        (state==LFALL && count1==0 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(36039-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LFALL && count1==1 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(38439-h_cnt+position1)+40*(v_cnt-420+position2):
                        (state==LFALL && count1==2 && position1<=h_cnt && h_cnt<=39+position1 && 420-position2<=v_cnt && v_cnt<=479-position2) ?(40839-h_cnt+position1)+40*(v_cnt-420+position2):
                        (firestate==RSHOOTING && fireposition1<=h_cnt && h_cnt<=39+fireposition1 && 420-fireposition2<=v_cnt && v_cnt<=449-fireposition2) ?(h_cnt-fireposition1+43200)+40*(v_cnt-420+fireposition2):
                        (firestate==LSHOOTING && fireposition1<=h_cnt && h_cnt<=39+fireposition1 && 420-fireposition2<=v_cnt && v_cnt<=449-fireposition2) ?(43239-h_cnt+fireposition1)+40*(v_cnt-420+fireposition2):
                        0;
    
    always @(posedge clk , posedge rst)begin
        if(rst)begin
            firestate <= RESET;
            fireposition1 <= -40;
            fireposition2 <= 125;
            fireclkcount <= 0;
            player1attack <= 0;
        end
        else begin
            firestate <= next_firestate;
            fireposition1 <= next_fireposition1;
            fireposition2 <= next_fireposition2;
            fireclkcount <= next_fireclkcount;
            player1attack <= next_player1attack;
        end
    end
   
    always @(*)begin
        next_firestate = firestate;
        next_fireposition1 = fireposition1;
        next_fireposition2 = fireposition2;
        next_fireclkcount = fireclkcount;
        next_player1attack = player1attack;
        case(firestate)
            RESET:begin
                next_firestate = (been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b1) ?RSHOOTING:(been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b0) ?LSHOOTING:RESET;
                next_fireposition1 = (been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b1) ?position1+40:(been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b0) ?position1-40:fireposition1;
                next_player1attack = (been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b1) ?1'b1:(been_ready==1'b1 && key_down[KEYCODE_G]==1'b1 && led==8'b1111_1111 && direct==1'b0) ?1'b0:player1attack;
                next_fireposition2 = position2-20;
                next_fireclkcount = 0;
            end
            RSHOOTING:begin
                next_firestate = (fireposition1>=640) ?RESET:RSHOOTING;
                next_fireposition1 = (fireclkcount!=262143) ?fireposition1:(player2direct==1'b0 && player2position1+18<=39+fireposition1 && 39+fireposition1<=39+player2position1 && (420-player2position2<=420-fireposition2 && 420-fireposition2<=479-player2position2 || 420-player2position2<=449-fireposition2 && 449-fireposition2<=479-player2position2)) ?640:(player2direct==1'b1 && player2position1+12<=39+fireposition1 && 39+fireposition1<=39+player2position1 && (420-player2position2<=420-fireposition2 && 420-fireposition2<=479-player2position2 || 420-player2position2<=449-fireposition2 && 449-fireposition2<=479-player2position2)) ?640:(fireposition1<640) ?fireposition1+1:fireposition1;
                next_fireposition2 = fireposition2;
                next_fireclkcount = (fireclkcount!=262143) ?fireclkcount+1:0;
            end
            LSHOOTING:begin
                next_firestate = (fireposition1<=-40) ?RESET:LSHOOTING;
                next_fireposition1 = (fireclkcount!=262143) ?fireposition1:(player2direct==1'b0 && player2position1<=fireposition1 && fireposition1<=28+player2position1 && (420-player2position2<=420-fireposition2 && 420-fireposition2<=479-player2position2 || 420-player2position2<=449-fireposition2 && 449-fireposition2<=479-player2position2)) ?-40:(player2direct==1'b1 && player2position1<=fireposition1 && fireposition1<=22+player2position1 && (420-player2position2<=420-fireposition2 && 420-fireposition2<=479-player2position2 || 420-player2position2<=449-fireposition2 && 449-fireposition2<=479-player2position2)) ?-40:(fireposition1>-40) ?fireposition1-1:fireposition1;
                next_fireposition2 = fireposition2;
                next_fireclkcount = (fireclkcount!=262143) ?fireclkcount+1:0;
            end
        endcase   
    end
    
    always @ (posedge clk , posedge rst)begin
       if(rst)begin
           state <=RESET;
           position1 <= 0;
           position2 <= 125;
           count1 <= 0;
           clkcount <= 0;
           direct <= 1;
           atkcount1 <= 0;
           player2win <= 0;
       end
       else begin
           state <= next_state;
           position1 <= next_position1;
           position2 <= next_position2;
           count1 <= next_count1;
           clkcount <= next_clkcount;
           direct <= next_direct;
           atkcount1 <= next_atkcount1;
           player2win <= next_player2win;
       end
    end
    
    always@(*)begin
        next_state = state;
        next_position1 = position1;
        next_count1 = count1;
        next_clkcount = clkcount;
        next_direct = direct;
        next_position2 = position2;
        next_atkcount1 = atkcount1;
        next_player2win = player2win;
           case(state)
               RESET:begin
                   next_state = RSTAY;
               end
               RSTAY:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:
                                (player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:
                                (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && key_down[KEYCODE_W] != 1'b1) ?RIGHT:
                                (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && key_down[KEYCODE_W] != 1'b1) ?LEFT:
                                (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_A] !=1'b1 && key_down[KEYCODE_D] != 1'b1) ?JUMP1:
                                (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP1:
                                (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP1:
                                (been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1 ) ?RATTACK_STAND:
                                RSTAY;
                   next_position2 = (162<=position1 && position1<=195 && 479-elevatorbottom<=position2 || 196<=position1 && position1<=211 && 479-elevatorbottom<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-elevatorbottom<=position2 && position2<=316 || 436<=position1 && position1<=469 && 479-elevatorbottom<=position2) ?479-(elevatortop+2):position2;
                   next_count1 = 0;
                   next_clkcount = 0;
                   next_direct = 1;
                   next_atkcount1 = 0;
               end
               LSTAY:begin
                   next_state =(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:
                               (player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:
                               (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && key_down[KEYCODE_W] != 1'b1) ?RIGHT:
                               (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && key_down[KEYCODE_W] != 1'b1) ?LEFT:
                               (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_A] != 1'b1 && key_down[KEYCODE_D] != 1'b1) ?JUMP11:
                               (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP1:
                               (been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP1:
                               (been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:
                               LSTAY;
                   next_position2 = (162<=position1 && position1<=195 && 479-elevatorbottom<=position2 || 196<=position1 && position1<=211 && 479-elevatorbottom<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-elevatorbottom<=position2 && position2<=316 || 436<=position1 && position1<=469 && 479-elevatorbottom<=position2) ?479-(elevatortop+2):position2;
                   next_count1 = 0;
                   next_clkcount = 0;
                   next_direct = 0;
                   next_atkcount1 = 0;
               end
               RIGHT:begin
                   if(0<=position1 && position1<=51 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 51<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 51<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 1;
                   end
                   if(52<=position1 && position1<=147 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 147<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 147<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 1;
                   end
                   if(228<=position1 && position1<=403 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 403<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 403<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 1;
                   end
                   if(484<=position1 && position1<=639 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 1;
                   end
                   if(36<=position1 && position1<=115 && 317<=position2)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 115<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 115<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 1;
                   end
                   if(196<=position1 && position1<=275 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 275<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                      next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 275<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 1;
                   end
                   if(356<=position1 && position1<=435 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 435<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                      next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 435<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 1;
                   end
                   if(516<=position1 && position1<=639 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                      next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 1;
                   end
                   if(164<=position1 && position1<=211 && 479-elevatorbottom<=position2 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 211<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                      next_position2 = 479-(elevatortop+2);
                      next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 211<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 1;
                   end
                   if(420<=position1 && position1<=467 && 479-elevatorbottom<=position2 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && 467<position1+4) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?RJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_D] != 1'b1)) ?RSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1)) ?RIGHT:RSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4 :position1;
                      next_position2 = 479-(elevatortop+2);
                      next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && 467<position1+4) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 1;
                   end
               end
               LEFT:begin
                   if(0<=position1 && position1<=51 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(52<=position1 && position1<=147 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(228<=position1 && position1<=403 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<234) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<234) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(484<=position1 && position1<=639 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<484) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<484) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(36<=position1 && position1<=115 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<36) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<36) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(196<=position1 && position1<=275 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<196) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<196) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                      next_direct = 0;
                   end
                   if(356<=position1 && position1<=435 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<356) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<356) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;        
                      next_direct = 0;          
                   end
                   if(516<=position1 && position1<=639 && 317<=position2)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<516) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<516) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                      next_direct = 0;
                   end
                   if(164<=position1 && position1<=211 && 479-elevatorbottom<=position2 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<164) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<164) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                      next_direct = 0; 
                   end
                   if(420<=position1 && position1<=467 && 479-elevatorbottom<=position2 && position2<=316)begin
                      next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && position1-4<420) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?LJUMP1:(clkcount==4194303 && count1==3 && (been_ready != 1'b1 || key_down[KEYCODE_A] != 1'b1)) ?LSTAY:(count1<3 || (been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1)) ?LEFT:LSTAY;
                      next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                      next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount==4194303 && position1-4<420) ?0:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_W] == 1'b1) ?0:(clkcount!=4194303) ?count1:(count1<3) ?count1+1:0;
                      next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                      next_direct = 0;
                   end
               end
               JUMP1:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP1:JUMP1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 1;
               end
               JUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;             
                       next_direct = 1;           
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;       
                       next_direct = 1;
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                 
                       next_direct = 1;      
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;               
                       next_direct = 1;        
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?RFALL:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 1;
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2)) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;             
                       next_direct = 1;       
                   end
               end
               JUMP11:begin
                   next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP11:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP1:JUMP11;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 0;
               end
               JUMP22:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                 
                       next_direct = 0;       
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;           
                       next_direct = 0;             
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;             
                       next_direct = 0;          
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;            
                       next_direct = 0;           
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?LFALL:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 0;
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2)) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;             
                       next_direct = 0;       
                   end
               end
               RJUMP1:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP1:RJUMP1;
                   next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 1;
               end
               RJUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                        
                       next_direct = 1;
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                       next_direct = 1;
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                       
                       next_direct = 1;
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                   
                       next_direct = 1;    
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?RFALL:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 1;
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2)) ?RSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1) ?LJUMP2:RJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 1;
                   end
               end
               LJUMP1:begin
                   next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP11:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP1:LJUMP1;
                   next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 0;
               end
               LJUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                        
                       next_direct = 0;
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                           
                       next_direct = 0;  
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                       next_direct = 0;                    
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;            
                       next_direct = 0;           
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?LFALL:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 0;
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2)) ?LSTAY:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_G] == 1'b1) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1) ?RJUMP2:LJUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                    
                       next_direct = 0;
                   end
               end
               RATTACK_STAND:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && atkcount1==3) ?RSTAY:RATTACK_STAND;
                   next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:count1;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                   next_direct = 1;
               end
               LATTACK_STAND:begin
                   next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && atkcount1==3) ?LSTAY:LATTACK_STAND;
                   next_atkcount1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:count1;
                   next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0; 
                   next_direct = 0;
               end
               ATTACK_JUMP1:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11 && atkcount1==3) ?JUMP2:(clkcount==4194303 && count1==11 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP1:(clkcount==4194303 && atkcount1==3) ?JUMP1:ATTACK_JUMP1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_atkcount1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 1;
               end
               ATTACK_JUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125 && atkcount1==3) ?RSTAY:(position2==125 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                   next_position2 = (clkcount!=4194303) ?position2:
                                    (count1==0) ?(position2-1>=125)?position2-1:125:
                                    (count1==1) ?(position2-1>=125)?position2-1:125:
                                    (count1==2) ?(position2-2>=125)?position2-2:125:
                                    (count1==3) ?(position2-3>=125)?position2-3:125:
                                    (count1==4) ?(position2-4>=125)?position2-4:125:
                                    (count1==5) ?(position2-5>=125)?position2-5:125:
                                    (count1==6) ?(position2-6>=125)?position2-6:125:
                                    (count1==7) ?(position2-6>=125)?position2-6:125:
                                    (count1==8) ?(position2-8>=125)?position2-8:125:
                                    (count1==9) ?(position2-8>=125)?position2-8:125:
                                    (count1==10) ?(position2-9>=125)?position2-9:125:
                                    (count1==11) ?(position2-11>=125)?position2-11:125:
                                    (count1==12) ?(position2-11>=125)?position2-11:125:
                                    (count1==13) ?(position2-12>=125)?position2-12:125:
                                    (count1==14) ?(position2-13>=125)?position2-13:125:
                                    (count1==15) ?(position2-14>=125)?position2-14:125:
                                    (count1==16) ?(position2-15>=125)?position2-15:125:
                                    (count1==17) ?(position2-15>=125)?position2-15:125:
                                    (count1==18) ?(position2-16>=125)?position2-16:125:
                                    (count1==19) ?(position2-18>=125)?position2-18:125:
                                    (count1==20) ?(position2-18>=125)?position2-18:125:
                                    (count1==21) ?(position2-19>=125)?position2-19:125:
                                    (count1==22) ?(position2-20>=125)?position2-20:125:
                                    (count1==23) ?(position2-21>=125)?position2-21:125:
                                    (count1==24) ?(position2-22>=125)?position2-22:125:
                                    (count1==25) ?(position2-22>=125)?position2-22:125:
                                    (count1==26) ?(position2-24>=125)?position2-24:125:
                                    (count1==27) ?(position2-24>=125)?position2-24:125:
                                    (count1==28) ?(position2-26>=125)?position2-26:125:
                                    (count1==29) ?(position2-26>=125)?position2-26:125:
                                    position2;
                   next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                   next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                        
                   next_direct = 1;
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?RSTAY:(position2==93 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;       
                       next_direct = 1;
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?RSTAY:(position2==93 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;         
                       next_direct = 1;              
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317 && atkcount1==3) ?RSTAY:(position2==317 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                       next_direct = 1;                     
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?RFALL:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0 && atkcount1==3) ?RSTAY:(position2==0 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;          
                       next_direct = 1;          
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2) && atkcount1==3) ?RSTAY:(position2==479-(elevatortop+2) && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP2:ATTACK_JUMP2;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;         
                       next_direct = 1;           
                   end
               end
               ATTACK_JUMP11:begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11 && atkcount1==3) ?JUMP22:(clkcount==4194303 && count1==11 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP1:(clkcount==4194303 && atkcount1==3) ?JUMP11:ATTACK_JUMP11;
                       next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                       next_count1 = (clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                       next_atkcount1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                       next_direct = 0;
               end
               ATTACK_JUMP22:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125 && atkcount1==3) ?LSTAY:(position2==125 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;     
                       next_direct = 0;                   
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?LSTAY:(position2==93 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                       next_direct = 0;                     
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?LSTAY:(position2==93 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;         
                       next_direct = 0;              
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317 && atkcount1==3) ?LSTAY:(position2==317 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                       next_direct = 0;                     
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?LFALL:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0 && atkcount1==3) ?LSTAY:(position2==0 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;     
                       next_direct = 0;               
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2) && atkcount1==3) ?LSTAY:(position2==479-(elevatortop+2) && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?JUMP22:ATTACK_JUMP22;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;         
                       next_direct = 0;           
                   end
               end
               RATTACK_JUMP1:begin
                   next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && count1==11 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP1:(clkcount==4194303 && atkcount1==3) ?RJUMP1:RATTACK_JUMP1;
                   next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;    
                   next_direct = 1;               
               end
               RATTACK_JUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125 && atkcount1==3) ?RSTAY:(position2==125 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;                     
                       next_direct = 1;         
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?RSTAY:(position2==93 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;  
                       next_direct = 1;      
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?RSTAY:(position2==93 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                       next_direct = 1;                          
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317 && atkcount1==3) ?RSTAY:(position2==317 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;             
                       next_direct = 1;                
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?RFALL:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0 && atkcount1==3) ?RSTAY:(position2==0 && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;          
                       next_direct = 1;                
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2) && atkcount1==3) ?RSTAY:(position2==479-(elevatortop+2) && atkcount1!=3) ?RATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_A] == 1'b1 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?RJUMP2:RATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1+4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+12<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=22+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;              
                       next_direct = 1;            
                   end              
               end
               LATTACK_JUMP1:begin
                   next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(clkcount==4194303 && count1==11 && atkcount1==3) ?LJUMP2:(clkcount==4194303 && count1==11 && atkcount1!=3) ?LATTACK_JUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP11:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP11:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP1:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP1:(clkcount==4194303 && atkcount1==3) ?LJUMP1:LATTACK_JUMP1;
                   next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                   next_position2 = (clkcount!=4194303) ?position2:(count1==0) ?position2+11:(count1==1) ?position2+9:(count1==2) ?position2+8:(count1==3) ?position2+8:(count1==4) ?position2+6:(count1==5) ?position2+6:(count1==6) ?position2+5:(count1==7) ?position2+4:(count1==8) ?position2+3:(count1==9) ?position2+2:(count1==10) ?position2+1:(count1==11) ?position2+1:position2;
                   next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(count1<11) ?count1+1:0;
                   next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                   next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;
                   next_direct = 0;      
               end
               LATTACK_JUMP2:begin
                   if(0<=position1 && position1<=41 && 125<=position2 || 42<=position1 && position1<=51 && 125<=position2 && position2<=316)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==125 && atkcount1==3) ?LSTAY:(position2==125 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=125)?position2-1:125:
                                        (count1==1) ?(position2-1>=125)?position2-1:125:
                                        (count1==2) ?(position2-2>=125)?position2-2:125:
                                        (count1==3) ?(position2-3>=125)?position2-3:125:
                                        (count1==4) ?(position2-4>=125)?position2-4:125:
                                        (count1==5) ?(position2-5>=125)?position2-5:125:
                                        (count1==6) ?(position2-6>=125)?position2-6:125:
                                        (count1==7) ?(position2-6>=125)?position2-6:125:
                                        (count1==8) ?(position2-8>=125)?position2-8:125:
                                        (count1==9) ?(position2-8>=125)?position2-8:125:
                                        (count1==10) ?(position2-9>=125)?position2-9:125:
                                        (count1==11) ?(position2-11>=125)?position2-11:125:
                                        (count1==12) ?(position2-11>=125)?position2-11:125:
                                        (count1==13) ?(position2-12>=125)?position2-12:125:
                                        (count1==14) ?(position2-13>=125)?position2-13:125:
                                        (count1==15) ?(position2-14>=125)?position2-14:125:
                                        (count1==16) ?(position2-15>=125)?position2-15:125:
                                        (count1==17) ?(position2-15>=125)?position2-15:125:
                                        (count1==18) ?(position2-16>=125)?position2-16:125:
                                        (count1==19) ?(position2-18>=125)?position2-18:125:
                                        (count1==20) ?(position2-18>=125)?position2-18:125:
                                        (count1==21) ?(position2-19>=125)?position2-19:125:
                                        (count1==22) ?(position2-20>=125)?position2-20:125:
                                        (count1==23) ?(position2-21>=125)?position2-21:125:
                                        (count1==24) ?(position2-22>=125)?position2-22:125:
                                        (count1==25) ?(position2-22>=125)?position2-22:125:
                                        (count1==26) ?(position2-24>=125)?position2-24:125:
                                        (count1==27) ?(position2-24>=125)?position2-24:125:
                                        (count1==28) ?(position2-26>=125)?position2-26:125:
                                        (count1==29) ?(position2-26>=125)?position2-26:125:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=125) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                       next_direct = 0;                           
                   end
                   if(0<=position1 && position1<=41 && position2<=124 || 42<=position1 && position1<=51 && position2<=124)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?LSTAY:(position2==93 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;       
                       next_direct = 0;                            
                   end
                   if((52<=position1 && position1<=115 && position2<=316) || (228<=position1 && position1<=275 && position2<=316) || (362<=position1 && position1<=403 && position2<=316) || (522<=position1 && position1<=639 && position2<=316) || (116<=position1 && position1<=147) || (276<=position1 && position1<=361) || (484<=position1 && position1<=521))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==93 && atkcount1==3) ?LSTAY:(position2==93 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=93)?position2-1:93:
                                        (count1==1) ?(position2-1>=93)?position2-1:93:
                                        (count1==2) ?(position2-2>=93)?position2-2:93:
                                        (count1==3) ?(position2-3>=93)?position2-3:93:
                                        (count1==4) ?(position2-4>=93)?position2-4:93:
                                        (count1==5) ?(position2-5>=93)?position2-5:93:
                                        (count1==6) ?(position2-6>=93)?position2-6:93:
                                        (count1==7) ?(position2-6>=93)?position2-6:93:
                                        (count1==8) ?(position2-8>=93)?position2-8:93:
                                        (count1==9) ?(position2-8>=93)?position2-8:93:
                                        (count1==10) ?(position2-9>=93)?position2-9:93:
                                        (count1==11) ?(position2-11>=93)?position2-11:93:
                                        (count1==12) ?(position2-11>=93)?position2-11:93:
                                        (count1==13) ?(position2-12>=93)?position2-12:93:
                                        (count1==14) ?(position2-13>=93)?position2-13:93:
                                        (count1==15) ?(position2-14>=93)?position2-14:93:
                                        (count1==16) ?(position2-15>=93)?position2-15:93:
                                        (count1==17) ?(position2-15>=93)?position2-15:93:
                                        (count1==18) ?(position2-16>=93)?position2-16:93:
                                        (count1==19) ?(position2-18>=93)?position2-18:93:
                                        (count1==20) ?(position2-18>=93)?position2-18:93:
                                        (count1==21) ?(position2-19>=93)?position2-19:93:
                                        (count1==22) ?(position2-20>=93)?position2-20:93:
                                        (count1==23) ?(position2-21>=93)?position2-21:93:
                                        (count1==24) ?(position2-22>=93)?position2-22:93:
                                        (count1==25) ?(position2-22>=93)?position2-22:93:
                                        (count1==26) ?(position2-24>=93)?position2-24:93:
                                        (count1==27) ?(position2-24>=93)?position2-24:93:
                                        (count1==28) ?(position2-26>=93)?position2-26:93:
                                        (count1==29) ?(position2-26>=93)?position2-26:93:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=93) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;          
                       next_direct = 0;                   
                   end
                   if((36<=position1 && position1<=115 && 317<=position2) || (196<=position1 && position1<=275 && 317<=position2) || (356<=position1 && position1<=435 && 317<=position2) || (516<=position1 && position1<=639 && 317<=position2))begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==317 && atkcount1==3) ?LSTAY:(position2==317 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1>0) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=317)?position2-1:317:
                                        (count1==1) ?(position2-1>=317)?position2-1:317:
                                        (count1==2) ?(position2-2>=317)?position2-2:317:
                                        (count1==3) ?(position2-3>=317)?position2-3:317:
                                        (count1==4) ?(position2-4>=317)?position2-4:317:
                                        (count1==5) ?(position2-5>=317)?position2-5:317:
                                        (count1==6) ?(position2-6>=317)?position2-6:317:
                                        (count1==7) ?(position2-6>=317)?position2-6:317:
                                        (count1==8) ?(position2-8>=317)?position2-8:317:
                                        (count1==9) ?(position2-8>=317)?position2-8:317:
                                        (count1==10) ?(position2-9>=317)?position2-9:317:
                                        (count1==11) ?(position2-11>=317)?position2-11:317:
                                        (count1==12) ?(position2-11>=317)?position2-11:317:
                                        (count1==13) ?(position2-12>=317)?position2-12:317:
                                        (count1==14) ?(position2-13>=317)?position2-13:317:
                                        (count1==15) ?(position2-14>=317)?position2-14:317:
                                        (count1==16) ?(position2-15>=317)?position2-15:317:
                                        (count1==17) ?(position2-15>=317)?position2-15:317:
                                        (count1==18) ?(position2-16>=317)?position2-16:317:
                                        (count1==19) ?(position2-18>=317)?position2-18:317:
                                        (count1==20) ?(position2-18>=317)?position2-18:317:
                                        (count1==21) ?(position2-19>=317)?position2-19:317:
                                        (count1==22) ?(position2-20>=317)?position2-20:317:
                                        (count1==23) ?(position2-21>=317)?position2-21:317:
                                        (count1==24) ?(position2-22>=317)?position2-22:317:
                                        (count1==25) ?(position2-22>=317)?position2-22:317:
                                        (count1==26) ?(position2-24>=317)?position2-24:317:
                                        (count1==27) ?(position2-24>=317)?position2-24:317:
                                        (count1==28) ?(position2-26>=317)?position2-26:317:
                                        (count1==29) ?(position2-26>=317)?position2-26:317:
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=317) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;       
                       next_direct = 0;                      
                   end
                   if((212<=position1 && position1<=227 && position2<=316) || (404<=position1 && position1<=419 && position2<=316) || (148<=position1 && position1<=163) || (468<=position1 && position1<=483) || (164<=position1 && position1<=211 && position2<=479-(elevatortop+3)) || (420<=position1 && position1<=467 && position2<=479-(elevatortop+3)))begin
                       next_state = (position2<=61) ?LFALL:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==0 && atkcount1==3) ?LSTAY:(position2==0 && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=0)?position2-1:0:
                                        (count1==1) ?(position2-1>=0)?position2-1:0:
                                        (count1==2) ?(position2-2>=0)?position2-2:0:
                                        (count1==3) ?(position2-3>=0)?position2-3:0:
                                        (count1==4) ?(position2-4>=0)?position2-4:0:
                                        (count1==5) ?(position2-5>=0)?position2-5:0:
                                        (count1==6) ?(position2-6>=0)?position2-6:0:
                                        (count1==7) ?(position2-6>=0)?position2-6:0:
                                        (count1==8) ?(position2-8>=0)?position2-8:0:
                                        (count1==9) ?(position2-8>=0)?position2-8:0:
                                        (count1==10) ?(position2-9>=0)?position2-9:0:
                                        (count1==11) ?(position2-11>=0)?position2-11:0:
                                        (count1==12) ?(position2-11>=0)?position2-11:0:
                                        (count1==13) ?(position2-12>=0)?position2-12:0:
                                        (count1==14) ?(position2-13>=0)?position2-13:0:
                                        (count1==15) ?(position2-14>=0)?position2-14:0:
                                        (count1==16) ?(position2-15>=0)?position2-15:0:
                                        (count1==17) ?(position2-15>=0)?position2-15:0:
                                        (count1==18) ?(position2-16>=0)?position2-16:0:
                                        (count1==19) ?(position2-18>=0)?position2-18:0:
                                        (count1==20) ?(position2-18>=0)?position2-18:0:
                                        (count1==21) ?(position2-19>=0)?position2-19:0:
                                        (count1==22) ?(position2-20>=0)?position2-20:0:
                                        (count1==23) ?(position2-21>=0)?position2-21:0:
                                        (count1==24) ?(position2-22>=0)?position2-22:0:
                                        (count1==25) ?(position2-22>=0)?position2-22:0:
                                        (count1==26) ?(position2-24>=0)?position2-24:0:
                                        (count1==27) ?(position2-24>=0)?position2-24:0:
                                        (count1==28) ?(position2-26>=0)?position2-26:0:
                                        (count1==29) ?(position2-26>=0)?position2-26:0:
                                        position2;
                       next_count1 = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=0) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (position2<=61) ?0:(player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;   
                       next_direct = 0;                       
                   end
                   if(164<=position1 && position1<=195 && 479-(elevatortop+2)<=position2 || 196<=position1 && position1<=211 && 479-(elevatortop+2)<=position2 && position2<=316 || 420<=position1 && position1<=435 && 479-(elevatortop+2)<=position2 && position2<=316 || 436<=position1 && position1<=467 && 479-(elevatortop+2)<=position2)begin
                       next_state = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?LFALL:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?RFALL:(position2==479-(elevatortop+2) && atkcount1==3) ?LSTAY:(position2==479-(elevatortop+2) && atkcount1!=3) ?LATTACK_STAND:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1==3) ?JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] != 1'b1 && key_down[KEYCODE_A] != 1'b1 && atkcount1!=3) ?ATTACK_JUMP22:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1==3) ?RJUMP2:(clkcount==4194303 && been_ready == 1'b1 && key_down[KEYCODE_D] == 1'b1 && atkcount1!=3) ?RATTACK_JUMP2:(clkcount==4194303 && atkcount1==3) ?LJUMP2:LATTACK_JUMP2;
                       next_position1 = (clkcount!=4194303) ?position1:(position1<600) ?position1-4:position1;
                       next_position2 = (clkcount!=4194303) ?position2:
                                        (count1==0) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==1) ?(position2-1>=479-(elevatortop+2))?position2-1:479-(elevatortop+2):
                                        (count1==2) ?(position2-2>=479-(elevatortop+2))?position2-2:479-(elevatortop+2):
                                        (count1==3) ?(position2-3>=479-(elevatortop+2))?position2-3:479-(elevatortop+2):
                                        (count1==4) ?(position2-4>=479-(elevatortop+2))?position2-4:479-(elevatortop+2):
                                        (count1==5) ?(position2-5>=479-(elevatortop+2))?position2-5:479-(elevatortop+2):
                                        (count1==6) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==7) ?(position2-6>=479-(elevatortop+2))?position2-6:479-(elevatortop+2):
                                        (count1==8) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==9) ?(position2-8>=479-(elevatortop+2))?position2-8:479-(elevatortop+2):
                                        (count1==10) ?(position2-9>=479-(elevatortop+2))?position2-9:479-(elevatortop+2):
                                        (count1==11) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==12) ?(position2-11>=479-(elevatortop+2))?position2-11:479-(elevatortop+2):
                                        (count1==13) ?(position2-12>=479-(elevatortop+2))?position2-12:479-(elevatortop+2):
                                        (count1==14) ?(position2-13>=479-(elevatortop+2))?position2-13:479-(elevatortop+2):
                                        (count1==15) ?(position2-14>=479-(elevatortop+2))?position2-14:479-(elevatortop+2):
                                        (count1==16) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==17) ?(position2-15>=479-(elevatortop+2))?position2-15:479-(elevatortop+2):
                                        (count1==18) ?(position2-16>=479-(elevatortop+2))?position2-16:479-(elevatortop+2):
                                        (count1==19) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==20) ?(position2-18>=479-(elevatortop+2))?position2-18:479-(elevatortop+2):
                                        (count1==21) ?(position2-19>=479-(elevatortop+2))?position2-19:479-(elevatortop+2):
                                        (count1==22) ?(position2-20>=479-(elevatortop+2))?position2-20:479-(elevatortop+2):
                                        (count1==23) ?(position2-21>=479-(elevatortop+2))?position2-21:479-(elevatortop+2):
                                        (count1==24) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==25) ?(position2-22>=479-(elevatortop+2))?position2-22:479-(elevatortop+2):
                                        (count1==26) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==27) ?(position2-24>=479-(elevatortop+2))?position2-24:479-(elevatortop+2):
                                        (count1==28) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        (count1==29) ?(position2-26>=479-(elevatortop+2))?position2-26:479-(elevatortop+2):
                                        position2;
                       next_count1 = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?count1:(position2!=479-(elevatortop+2)) ?count1+1:0;
                       next_atkcount1 = (clkcount!=4194303) ?atkcount1:(atkcount1<3) ?atkcount1+1:0;
                       next_clkcount = (player2attack==1'b1 && position1+18<=39+fire2position1 && 39+fire2position1<=39+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(player2attack==1'b0 && position1<=fire2position1 && fire2position1<=28+position1 && (420-position2<=420-fire2position2 && 420-fire2position2<=479-position2 || 420-position2<=449-fire2position2 && 449-fire2position2<=479-position2)) ?0:(clkcount!=4194303) ?clkcount+1:0;     
                       next_direct = 0;                     
                   end             
               end
               RFALL:begin
                   next_state = RFALL;
                   next_count1 = (clkcount!=16777215) ?count1:(count1<2) ?count1+1:2;
                   next_clkcount = (clkcount!=16777215) ?clkcount+1:0;     
                   next_player2win = (clkcount==16777215 && count1==2) ?1'b1:1'b0;
               end
               LFALL:begin
                   next_state = LFALL;
                   next_count1 = (clkcount!=16777215) ?count1:(count1<2) ?count1+1:2;
                   next_clkcount = (clkcount!=16777215) ?clkcount+1:0;
                   next_player2win = (clkcount==16777215 && count1==2) ?1'b1:1'b0;     
               end
           endcase
    end
    
endmodule
