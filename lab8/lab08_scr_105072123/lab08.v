module lab08(
  clk, // clock from crystal
  Reset, // active high reset
  StartPause,
  Mute,
  Repeat,
  Music,
  VolumeUp,
  VolumeDown,
  audio_mclk, // master clock
  audio_lrck, // left-right clock
  audio_sck, // serial clock
  audio_sdin, // serial audio data input
  Volume,
  DISPLAY,
  DIGIT
);

// I/O declaration
input clk;  // clock from the crystal
input Reset;  // active high reset
input StartPause;
input Mute;
input Repeat;
input Music;
input VolumeUp;
input VolumeDown;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input
output [3:0] Volume;
output [6:0] DISPLAY;
output [3:0] DIGIT;

// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;
wire [31:0] freq_b, freq_c;
wire [21:0] freq_out_b, freq_out_c;
wire clkDiv23;

reg [8:0] ibeat, next_ibeat;
reg [1:0] state, next_state;
reg [3:0] Volume, next_Volume, temp, next_temp;

parameter RESET = 2'b00, BALLON = 2'b01, JINGEL = 2'b10;
parameter BEATLEAGTH = 127;

debounce Reset_debounce(.pb_debounced(Reset_deb), .pb(Reset), .clk(clk16));
onepulse Reset_onepulse(.pb_debounced(Reset_deb), .clk(clk16), .pb_1pulse(Reset_one));
debounce VolumeUp_debounce(.pb_debounced(VolumeUp_deb), .pb(VolumeUp), .clk(clk16));
onepulse VolumeUp_onepulse(.pb_debounced(VolumeUp_deb), .clk(clk16), .pb_1pulse(VolumeUp_one));
debounce VolumeDown_debounce(.pb_debounced(VolumeDown_deb), .pb(VolumeDown), .clk(clk16));
onepulse VolumeDown_onepulse(.pb_debounced(VolumeDown_deb), .clk(clk16), .pb_1pulse(VolumeDown_one));

always @(posedge clk or posedge Reset_one) begin
  if (Reset_one) begin
    state <= RESET;
  end
  else begin
    state <= next_state;
  end
end

always @(posedge clk_sel or posedge Reset_one) begin
  if (Reset_one) begin
    ibeat <= 0;    
  end
  else begin
    ibeat <= next_ibeat;
  end
end

assign clk_sel = (state==BALLON && Music==1 || state==JINGEL && Music==0 || state==RESET)? clk : clkDiv23;

always@(posedge clk16 or posedge Reset_one)begin
    if(Reset_one)begin
        Volume <= 4'b0001;
        temp <= 4'b0001;
    end
    else begin
        Volume <= (Mute)? 4'b0 : next_Volume;
        temp <= (Mute)? temp : next_Volume;
    end
end

    always@(*)begin
        if(VolumeUp_one)begin
            next_Volume = (Mute)? Volume : (Volume == 4'b1111)? 4'b1111 : (Volume<<1)+1;
        end
        else if(VolumeDown_one)begin
            next_Volume = (Mute)? Volume : (Volume == 4'b0001)? 4'b0001 : Volume>>1;
        end
        else begin
            next_Volume = temp;
        end
    end

always @(*) begin
  case(state)
    RESET: begin
      next_ibeat = 0;
      next_state = (!StartPause)? RESET : (!Music)? BALLON : JINGEL;
    end
    BALLON: begin
      if (!Music) begin
        if(ibeat < BEATLEAGTH) begin
          next_ibeat = (!StartPause)? ibeat : ibeat + 1;
        end
        else if (ibeat == BEATLEAGTH)begin
          next_ibeat = (Repeat && StartPause)? 0 : ibeat;
        end
      end
      else if(Music) begin
        next_ibeat = 0;
      end
      next_state = (Music)? JINGEL : BALLON;
   end
    JINGEL: begin
      if (Music) begin
        if(ibeat < BEATLEAGTH) begin
          next_ibeat = (!StartPause)? ibeat : ibeat + 1;
        end
        else if (ibeat == BEATLEAGTH)begin
          next_ibeat = (Repeat && StartPause)? 0 : ibeat;
        end
      end
      else if(!Music) begin
        next_ibeat = 0;
      end
      next_state = (!Music)? BALLON : JINGEL;      
    end
    default: begin
      next_ibeat = ibeat;
      next_state = state;
    end
  endcase
end

clock_divider #(16) clkdiv16(.clk(clk), .clk_div(clk16));

clock_divider #(.n(24)) clock_23(
    .clk(clk),
  .clk_div(clkDiv23)
);

Music music00 ( 
    .ibeatNum(ibeat),
    .en(1'b0),
    .Mute(Mute),
    .StartPause(StartPause),
    .Music(Music),
    .tone_b(freq_b),
    .tone_c(freq_c)
);

assign freq_out_b = 50000000/freq_b;
assign freq_out_c = 50000000/freq_c;

// Note generation
note_gen Ung(
  .clk(clk), // clock from crystal
  .rst(Reset_one), // active high reset
  .note_div_b(freq_out_b), // div for note generation
  .note_div_c(freq_out_c),
  .Volume(Volume),
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control Usc(
  .clk(clk),  // clock from the crystal
  .rst(Reset_one),  // active high reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);

 SevenSegment seven(
  .display(DISPLAY),
  .digit(DIGIT),
  .tone_c(freq_c),
  .rst(Reset_one),
  .clk(clk)
);

endmodule