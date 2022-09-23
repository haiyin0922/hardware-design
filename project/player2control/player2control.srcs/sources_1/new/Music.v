`define NMCss  32'd1047 // C sharp sharp
`define NMDss  32'd1175 // D sharp sharp
`define NMEss  32'd1319 // E sharp sharp
`define NMFss 32'd1397 // F sharp sharp
`define NMfss 32'd1480 // #F sharp sharp
`define NMGss 32'd1568 // G sharp sharp
`define NMAss 32'd1760 // A sharp sharp
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
`define NMG   32'd392 // G
`define NMA   32'd440 // A
`define NMb   32'd466 // bB
`define NMB   32'd494 // B
`define NM0   32'd50000 //slience (over freq.)

module Music (
    input [8:0] ibeatNum,
    input [2:0] volume,
    input Music,
    output reg [31:0] tone_b,
    output reg [31:0] tone_c
);

always @(*) begin
    if(volume == 3'b0) begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    else begin
    case(ibeatNum)
    9'd0 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end 
    9'd1 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end 
    9'd2 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd3 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end 
    9'd4 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd5 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end 
    9'd6 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
    9'd7 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end 
           
    9'd8 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd9 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd10 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd11 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd12 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd13 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd14 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
    9'd15 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
////////////////////////////////////////           
    9'd16 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd17 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd18 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd19 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd20 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd21 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd22 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
    9'd23 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
           
    9'd24 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd25 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end 
    9'd26 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd27 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd28 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
    9'd29 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
    9'd30 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
    9'd31 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
///////////////////////////////////           
    9'd32 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd33 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd34 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd35 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd36 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd37 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd38 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
    9'd39 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
           
    9'd40 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd41 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd42 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd43 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd44 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd45 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd46 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
    9'd47 :begin
        tone_b = `NMCs;
        tone_c = `NMG;
    end
/////////////////////////////              
    9'd48 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd49 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd50 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd51 :begin
        tone_b = `NMDs;
        tone_c = `NMA;
    end
    9'd52 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
    9'd53 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
    9'd54 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
    9'd55 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
                  
    9'd56 :begin
        tone_b = `NMGs;
        tone_c = `NMDs;
    end
    9'd57 :begin
        tone_b = `NMGs;
        tone_c = `NMDs;
    end
    9'd58 :begin
        tone_b = `NMGs;
        tone_c = `NMDs;
    end
    9'd59 :begin
        tone_b = `NMGs;
        tone_c = `NMDs;
    end
    9'd60 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
    9'd61 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
    9'd62 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
    9'd63 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
///////////////////////////////
    9'd64 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd65 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd66 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd67 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd68 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd69 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd70 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd71 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    9'd72 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd73 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd74 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd75 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd76 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd77 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd78 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd79 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
/////////////////////////////
    9'd80 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd81 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd82 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd83 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd84 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd85 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd86 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd87 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
                  
    9'd88 :begin
        tone_b = `NMFs;
        tone_c = `NMA;
    end
    9'd89 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd90 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd91 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd92 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd93 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd94 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd95 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
///////////////////////////////                  
    9'd96 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    9'd97 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    9'd98 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd99 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd100 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd101 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd102 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd103 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    9'd104 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd105 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd106 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd107 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd108 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd109 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd110 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd111 :begin
        tone_b = `NMDs;
        tone_c = `NMCs;
    end
///////////////////////////////                   
    9'd112 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd113 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd114 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd115 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd116 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd117 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd118 :begin
        tone_b = `NMFss;
        tone_c = `NMFs;
    end
    9'd119 :begin
        tone_b = `NMFss;
        tone_c = `NMFs;
    end

    9'd120 :begin
        tone_b = `NMEss;
        tone_c = `NMEs;
    end
    9'd121 :begin
        tone_b = `NMFss;
        tone_c = `NMFss;
    end
    9'd122 :begin
        tone_b = `NMEss;
        tone_c = `NMEss;
    end
    9'd123 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd124 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd125 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd126 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd127 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
///////////////////////////////                   
    9'd128 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd129 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd130 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd131 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd132 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd133 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd134 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd135 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    9'd136 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd137 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd138 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd139 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd140 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd141 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd142 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd143 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
///////////////////////////////                   
    9'd144 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd145 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd146 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd147 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd148 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd149 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd150 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd151 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    9'd152 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd153 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd154 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd155 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd156 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd157 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd158 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd159 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
///////////////////////////////                   
    9'd160 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd161 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd162 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd163 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd164 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd165 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd166 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd167 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end

    9'd168 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    9'd169 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd170 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
    9'd171 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd172 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd173 :begin
        tone_b = `NMFss;
        tone_c = `NMFss;
    end
    9'd174 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd175 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
///////////////////////////////                   
    9'd176 :begin
        tone_b = `NMFss;
        tone_c = `NMFss;
    end
    9'd177 :begin
        tone_b = `NMEss;
        tone_c = `NMEss;
    end
    9'd178 :begin
        tone_b = `NMFss;
        tone_c = `NMFss;
    end
    9'd179 :begin
        tone_b = `NMEss;
        tone_c = `NMEss;
    end
    9'd180 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd181 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd182 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd183 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end

    9'd184 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd185 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd186 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd187 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd188 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd189 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd190 :begin
        tone_b = `NMFss;
        tone_c = `NMCss;
    end
    9'd191 :begin
        tone_b = `NMFss;
        tone_c = `NMCss;
    end
/////////////////////////////// 開始畫面結束                   
    9'd192 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd193 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd194 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd195 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd196 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd197 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd198 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd199 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end

    9'd200 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd201 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd202 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd203 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd204 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd205 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd206 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd207 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
////////////////////////////////////////           
    9'd208 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd209 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd210 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd211 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd212 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd213 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd214 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd215 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
           
    9'd216 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
    9'd217 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end 
    9'd218 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd219 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd220 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd221 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd222 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd223 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
////////////////////////////////////////           
    9'd224 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd225 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd226 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd227 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd228 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd229 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd230 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd231 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
           
    9'd232 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd233 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end 
    9'd234 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd235 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd236 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd237 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd238 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd239 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
////////////////////////////////////////           
    9'd240 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd241 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd242 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd243 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd244 :begin
        tone_b = `NMCss;
        tone_c = `NMCs;
    end
    9'd245 :begin
        tone_b = `NMCss;
        tone_c = `NMCs;
    end
    9'd246 :begin
        tone_b = `NMFss;
        tone_c = `NMFs;
    end
    9'd247 :begin
        tone_b = `NMFss;
        tone_c = `NMFs;
    end
           
    9'd248 :begin
        tone_b = `NMEss;
        tone_c = `NMEss;
    end
    9'd249 :begin
        tone_b = `NMFss;
        tone_c = `NMFss;
    end 
    9'd250 :begin
        tone_b = `NMEss;
        tone_c = `NMEss;
    end
    9'd251 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd252 :begin
        tone_b = `NMCss;
        tone_c = `NMCs;
    end
    9'd253 :begin
        tone_b = `NMCss;
        tone_c = `NMCs;
    end
    9'd254 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd255 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
////////////////////////////////////////           
    9'd256 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd257 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd258 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd259 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd260 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd261 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd262 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd263 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
           
    9'd264 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd265 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end 
    9'd266 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd267 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd268 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd269 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd270 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd271 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
////////////////////////////////////////           
    9'd272 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd273 :begin
        tone_b = `NMGs;
        tone_c = `NMG;
    end
    9'd274 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd275 :begin
        tone_b = `NMAs;
        tone_c = `NMA;
    end
    9'd276 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd277 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd278 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd279 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
           
    9'd280 :begin
        tone_b = `NMFs;
        tone_c = `NMCs;
    end
    9'd281 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end 
    9'd282 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd283 :begin
        tone_b = `NMEs;
        tone_c = `NMEs;
    end
    9'd284 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd285 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd286 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
    9'd287 :begin
        tone_b = `NMCs;
        tone_c = `NMCs;
    end
////////////////////////////////////////
    9'd288 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
    9'd289 :begin
        tone_b = `NMFs;
        tone_c = `NMDs;
    end
    9'd290 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd291 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd292 :begin
        tone_b = `NMDss;
        tone_c = `NMDss;
    end
    9'd293 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd294 :begin
        tone_b = `NMAs;
        tone_c = `NMAs;
    end
    9'd295 :begin
        tone_b = `NMGs;
        tone_c = `NMGs;
    end
           
    9'd296 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end
    9'd297 :begin
        tone_b = `NMDs;
        tone_c = `NMDs;
    end 
    9'd298 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd299 :begin
        tone_b = `NMFs;
        tone_c = `NMFs;
    end
    9'd300 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
    9'd301 :begin
        tone_b = `NMAs;
        tone_c = `NMDs;
    end
    9'd302 :begin
        tone_b = `NMAs;
        tone_c = `NMCs;
    end
    9'd303 :begin
        tone_b = `NMAs;
        tone_c = `NMCs;
    end
////////////////////////////////////////           
    9'd304 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd305 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd306 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd307 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd308 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd309 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd310 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
    9'd311 :begin
        tone_b = `NMCss;
        tone_c = `NMCss;
    end
           
    9'd312 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd313 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end 
    9'd314 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd315 :begin
        tone_b = `NMDss;
        tone_c = `NMAs;
    end
    9'd316 :begin
        tone_b = `NMAss;
        tone_c = `NMAss;
    end
    9'd317 :begin
        tone_b = `NMAss;
        tone_c = `NMAss;
    end
    9'd318 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
    9'd319 :begin
        tone_b = `NMA;
        tone_c = `NMA;
    end
////////////////////////////////////////
    9'd320 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd321 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd322 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end
    9'd323 :begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    default : begin
        tone_b = `NM0;
        tone_c = `NM0;
    end 
    endcase
    end
end
endmodule