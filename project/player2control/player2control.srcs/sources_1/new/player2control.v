module player2control(
     input clk,
     inout wire PS2_DATA,
     inout wire PS2_CLK,
     output button_UP,
     output button_DOWN,
     output button_LEFT,
     output button_RIGHT,
     output button_ATTACK
    );
    
    assign button_UP = (been_ready && key_down[KEYCODE_W]) ?1'b1:1'b0;
    assign button_DOWN = (been_ready && key_down[KEYCODE_S]) ?1'b1:1'b0;
    assign button_LEFT = (been_ready && key_down[KEYCODE_A]) ?1'b1:1'b0;
    assign button_RIGHT = (been_ready && key_down[KEYCODE_D]) ?1'b1:1'b0;
    assign button_ATTACK = (been_ready && key_down[KEYCODE_G]) ?1'b1:1'b0;
    
    //parameter KEYCODE_UP = 9'b0_0111_0011 ,  KEYCODE_DOWN = 9'b0_0111_0010 , KEYCODE_LEFT = 9'b0_0110_1001 , KEYCODE_RIGHT = 9'b0_0111_1010 , KEYCODE_ATTACK = 9'b0_0101_1010; 
    parameter KEYCODE_W = 9'b0_0001_1101 ,  KEYCODE_S = 9'b0_0001_1011 , KEYCODE_A = 9'b0_0001_1100 , KEYCODE_D = 9'b0_0010_0011 , KEYCODE_G = 9'b0_0011_0100;
     
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
endmodule
