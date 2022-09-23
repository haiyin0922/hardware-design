module lab07(
    input clk,
    input rst,
    input btnC, btnL, btnR, btnU,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
    );

    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480

    reg [9:0] count, next_count, position, next_position;
    reg [3:0] vgaRed, vgaGreen, vgaBlue;
    reg [2:0] state, next_state;
    reg [4:0] clk27, next_clk27;

    parameter BLACK = 3'b000,  RISINGCURTAIN = 3'b001, SLIDINGIN = 3'b010,
              BOX = 3'b011, SPLIT = 3'b100, DISPLAY = 3'b101;

    always @(posedge clk_22 or posedge rst_one) begin
        if (rst_one) begin
            count <= 0;
            position <= 0;
            clk27 <= 0;
        end
        else begin
            count <= next_count;
            position <= next_position;
            clk27 <= next_clk27;
        end
    end

    always @(posedge clk_sel) begin
        if (rst_one) state <= BLACK;
        else state <= next_state;
    end

    assign clk_sel = (state == DISPLAY)? clk_22 : clk;

    always @(*) begin
        next_count = 0;
        next_position = 0;
        next_clk27 = 0;
        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        next_state = BLACK;
        case(state) 
            BLACK: begin
                {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                next_state = btnC_one? RISINGCURTAIN : btnR_one? SLIDINGIN : btnL_one? BOX : btnU_one? SPLIT : BLACK;
            end
            RISINGCURTAIN: begin
                next_count = (count >= 480)? 480 : count + 2;
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1 && v_cnt >= (480 - count))? pixel : 12'h0;
                next_state = (count == 480)? DISPLAY : RISINGCURTAIN;
            end
            SLIDINGIN: begin
                next_count = (count >= 640)? 640 : count + 2;
                next_position = (count >= 638)? 0 : (position > 0)? position - 1 : 319;
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1 && h_cnt < count)? pixel : 12'h0;
                next_state = (count == 640)? DISPLAY : SLIDINGIN;
            end
            BOX: begin
                next_count = (count >= 80)? 80 : count + 1;
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1 && v_cnt <= (240 + count*3) && v_cnt >= (240 - count*3) &&
                                               h_cnt <= (320 + count*4) && h_cnt >= (320 - count*4))? pixel : 12'h0;
                next_state = (count == 80)? DISPLAY : BOX; 
            end
            SPLIT: begin
                next_count = (count >= 640)? 640 : count + 2;
                next_position = (count >= 638)? 0 : (position > 0)? position - 1 : 319;
                if(valid == 1'b1 && h_cnt < count && (v_cnt < 120 || v_cnt >= 240 && v_cnt < 360))
                    {vgaRed, vgaGreen, vgaBlue} = pixel;
                else if(valid ==1'b1 && h_cnt >= 640 - count && (v_cnt >= 120 && v_cnt < 240 || v_cnt >= 360))
                    {vgaRed, vgaGreen, vgaBlue} = pixel;
                else {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                next_state = (count == 640)? DISPLAY : SPLIT;
            end
            DISPLAY: begin
                next_clk27 = clk27 + 1;
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1)? pixel : 12'h0;
                next_state = (clk27 == 31)? BLACK : DISPLAY;                
            end
        endcase
    end

    assign pixel_addr = (state == 3'b100 && (v_cnt >= 360 || v_cnt >= 120 && v_cnt < 240))?
                        ((h_cnt>>1)+320*(v_cnt>>1)-position)% 76800 : ((h_cnt>>1)+320*(v_cnt>>1)+position)% 76800;

    OnePulse rst_onepulse(.signal_single_pulse(rst_one), .signal(rst), .clock(clk));
    OnePulse btnC_onepulse(.signal_single_pulse(btnC_one), .signal(btnC), .clock(clk));
    OnePulse btnR_onepulse(.signal_single_pulse(btnR_one), .signal(btnR), .clock(clk));
    OnePulse btnL_onepulse(.signal_single_pulse(btnL_one), .signal(btnL), .clock(clk));
    OnePulse btnU_onepulse(.signal_single_pulse(btnU_one), .signal(btnU), .clock(clk));

    clock_divider clk_wiz_0_inst(
    .clk(clk),
    .clk1(clk_25MHz),
    .clk22(clk_22)
    );

    blk_mem_gen_0 blk_mem_gen_0_inst(
    .clka(clk_25MHz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel)
    ); 

    vga_controller vga_inst(
    .pclk(clk_25MHz),
    .reset(rst_one),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
    );

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


module clock_divider(clk1, clk, clk22);
    input clk;
    output clk1;
    output clk22;
    reg [21:0] num;
    wire [21:0] next_num;

    always @(posedge clk) begin
        num <= next_num;
    end

    assign next_num = num + 1'b1;
    assign clk1 = num[1];
    assign clk22 = num[21];

endmodule


module vga_controller (
    input wire pclk, reset,
    output wire hsync, vsync, valid,
    output wire [9:0]h_cnt,
    output wire [9:0]v_cnt
    );

    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;

    parameter HD = 640;
    parameter HF = 16;
    parameter HS = 96;
    parameter HB = 48;
    parameter HT = 800; 
    parameter VD = 480;
    parameter VF = 10;
    parameter VS = 2;
    parameter VB = 33;
    parameter VT = 525;
    parameter hsync_default = 1'b1;
    parameter vsync_default = 1'b1;

    always @(posedge pclk)
        if (reset)
            pixel_cnt <= 0;
        else
            if (pixel_cnt < (HT - 1))
                pixel_cnt <= pixel_cnt + 1;
            else
                pixel_cnt <= 0;

    always @(posedge pclk)
        if (reset)
            hsync_i <= hsync_default;
        else
            if ((pixel_cnt >= (HD + HF - 1)) && (pixel_cnt < (HD + HF + HS - 1)))
                hsync_i <= ~hsync_default;
            else
                hsync_i <= hsync_default; 

    always @(posedge pclk)
        if (reset)
            line_cnt <= 0;
        else
            if (pixel_cnt == (HT -1))
                if (line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;

    always @(posedge pclk)
        if (reset)
            vsync_i <= vsync_default; 
        else if ((line_cnt >= (VD + VF - 1)) && (line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 

    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));

    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt : 10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt : 10'd0;

endmodule