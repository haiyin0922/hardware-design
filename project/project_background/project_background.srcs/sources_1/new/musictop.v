module musictop(
  clk, // clock from crystal
  rst, // active high reset
  volume,
  audio_mclk, // master clock
  audio_lrck, // left-right clock
  audio_sck, // serial clock
  audio_sdin // serial audio data input
);

// I/O declaration
input clk;  // clock from the crystal
input rst;  // active high reset
input [2:0] volume;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input

// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;
wire [31:0] freq_b, freq_c;
wire [21:0] freq_out_b, freq_out_c;
wire clkDiv23;

reg [8:0] ibeat, next_ibeat;

parameter BEATLEAGTH = 323;


always @(posedge clkDiv23 or posedge rst) begin
  if (rst) begin
    ibeat <= 0;    
  end
  else begin
    ibeat <= (ibeat < BEATLEAGTH)? ibeat + 1 : 0;
  end
end

clock_divider #(16) clkdiv16(.clk(clk), .clk_div(clk16));

clock_divider #(.n(23)) clock_22(
    .clk(clk),
  .clk_div(clkDiv23)
);

Music music00 ( 
    .ibeatNum(ibeat),
    .volume(volume),
    .tone_b(freq_b),
    .tone_c(freq_c)
);

assign freq_out_b = 50000000/freq_b;
assign freq_out_c = 50000000/freq_c;

// Note generation
note_gen Ung(
  .clk(clk), // clock from crystal
  .rst(rst), // active high reset
  .note_div_b(freq_out_b), // div for note generation
  .note_div_c(freq_out_c),
  .volume(volume),
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control Usc(
  .clk(clk),  // clock from the crystal
  .rst(rst),  // active high reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);

endmodule