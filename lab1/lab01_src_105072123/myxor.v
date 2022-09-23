`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 13:05:48
// Design Name: 
// Module Name: myxor
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


module myxor (out, a, b);
    input a, b;
    output out;
    
    not not_0 (not0, a);
    not not_1 (not1, b);
     
    and and_0 (and0, not0, b);
    and and_1 (and1, not1, a);
            
    or or_0 (out, and0, and1);
    
endmodule

