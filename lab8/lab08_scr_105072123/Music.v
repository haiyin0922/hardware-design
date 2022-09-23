`define NMCss  32'd1047 // C sharp sharp
`define NMDss  32'd1175 // D sharp sharp
`define NMEss  32'd1319 // E sharp sharp
`define NMCs  32'd524 // C sharp
`define NMDs  32'd588 // D sharp
`define NMEs  32'd660 // E sharp
`define NMFs  32'd698 // F sharp
`define NMfs  32'd740 // #F sharp
`define NMGs  32'd784 // G sharp
`define NMAs  32'd880 // A sharp
`define NMBs  32'd988 // B sharp
`define NMC   32'd262 // C
`define NMD   32'd294 // D
`define NME   32'd330 // E
`define NMF   32'd349 // F
`define NMf   32'd370 // #F
`define NMG   32'd392 // G
`define NMA   32'd440 // A
`define NMB   32'd494 // B
`define NM0   32'd50000 //slience (over freq.)

module Music (
    input [7:0] ibeatNum,
    input en,
    input Mute,
    input StartPause,
    input Music,
    output reg [31:0] tone_b,
    output reg [31:0] tone_c
);

always @(*) begin
    if(!StartPause) begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    else if(en==0 && Music==0)begin //告白氣球
    case(ibeatNum)
    8'd0 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd1 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd2 :begin
        tone_b = `NMC;
        tone_c = `NMC;
    end
    8'd3 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd4 :begin
        tone_b = `NMC;
        tone_c = `NMC;
    end
    8'd5 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd6 :begin
        tone_b = `NMC;
        tone_c = `NMC;
    end
    8'd7 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
           
    8'd8 :begin
        tone_b = `NMD;
        tone_c = `NMD;
    end
    8'd9 :begin
        tone_b = `NMD;
        tone_c = `NMD;
    end
    8'd10 :begin
        tone_b = `NMG;
        tone_c = `NMG;
    end
    8'd11 :begin
        tone_b = `NMG;
        tone_c = `NMG;
    end
    8'd12 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd13 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd14 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd15 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
////////////////////////////////////////           
    8'd16 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd17 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd18 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd19 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd20 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd21 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd22 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd23 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
           
    8'd24 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd25 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd26 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd27 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd28 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd29 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd30 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd31 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
///////////////////////////////////           
    8'd32 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd33 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd34 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd35 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd36 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd37 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd38 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd39 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
           
    8'd40 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd41 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd42 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd43 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd44 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd45 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd46 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd47 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
/////////////////////////////              
    8'd48 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd49 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd50 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd51 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd52 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    8'd53 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    8'd54 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    8'd55 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
                  
    8'd56 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd57 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd58 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd59 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd60 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd61 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd62 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd63 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
///////////////////////////////
    8'd64 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd65 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd66 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd67 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd68 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd69 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd70 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd71 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end

    8'd72 :begin
        tone_b = `NMG;
        tone_c = `NMG;
    end
    8'd73 :begin
        tone_b = `NMG;
        tone_c = `NMG;
    end
    8'd74 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd75 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd76 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd77 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd78 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd79 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
/////////////////////////////
    8'd80 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd81 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd82 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd83 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    8'd84 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd85 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd86 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd87 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
                  
    8'd88 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd89 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd90 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd91 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd92 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd93 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd94 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd95 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
///////////////////////////////                  
    8'd96 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd97 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd98 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd99 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd100 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd101 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd102 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd103 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end

    8'd104 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd105 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd106 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd107 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd108 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd109 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    8'd110 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd111 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
///////////////////////////////                   
    8'd112 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd113 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    8'd114 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd115 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    8'd116 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd117 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd118 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd119 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    8'd120 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd121 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd122 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd123 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    8'd124 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd125 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd126 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    8'd127 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    default : begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    endcase
    end
///////////////////////////////////////////////////
    else if(en==0 && Music==1) begin // jingle bell
    case(ibeatNum)
    8'd0 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd1 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd2 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd3 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd4 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd5 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd6 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd7 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
           
    8'd8 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd9 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd10 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd11 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd12 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd13 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd14 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd15 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
////////////////////////////////////////
    8'd16 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd17 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd18 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd19 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd20 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd21 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd22 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd23 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd24 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd25 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd26 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd27 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd28 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd29 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd30 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd31 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
///////////////////////////////////           
    8'd32 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd33 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd34 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd35 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd36 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd37 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd38 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd39 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
           
    8'd40 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd41 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd42 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd43 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd44 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd45 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd46 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd47 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
/////////////////////////////                  
    8'd48 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd49 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd50 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd51 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd52 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd53 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd54 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd55 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
                  
    8'd56 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd57 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd58 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd59 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd60 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd61 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd62 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd63 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
///////////////////////////////
                  
    8'd64 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd65 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd66 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd67 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd68 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd69 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd70 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd71 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
                  
    8'd72 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd73 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd74 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd75 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd76 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd77 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd78 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd79 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
/////////////////////////////                  
    8'd80 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd81 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd82 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd83 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd84 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd85 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd86 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd87 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
                  
    8'd88 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd89 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd90 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd91 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd92 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd93 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd94 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd95 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
///////////////////////////////
                  
    8'd96 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd97 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd98 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd99 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd100 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd101 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd102 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd103 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
                   
    8'd104 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd105 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd106 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd107 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd108 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd109 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
    8'd110 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd111 :begin
        tone_b = `NMfs;
        tone_c = `NMf;
    end
///////////////:// ////////////
                   
    8'd112 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd113 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd114 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd115 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    8'd116 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd117 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    8'd118 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
    8'd119 :begin
        tone_b = `NMEs;
        tone_c = `NME;
    end
                   
    8'd120 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd121 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd122 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd123 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd124 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd125 :begin
        tone_b = `NMDs;
        tone_c = `NMD;
    end
    8'd126 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    8'd127 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    default :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    endcase
    end
    else begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
end
endmodule